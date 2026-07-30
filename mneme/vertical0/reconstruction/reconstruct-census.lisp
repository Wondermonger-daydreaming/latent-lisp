;;;; reconstruct-census.lisp — THE OFFICIAL RECONSTRUCTION (contract §11).
;;;;
;;;; Run:  sbcl --script mneme/vertical0/reconstruction/reconstruct-census.lisp \
;;;;         <exec-dir> <output-path>
;;;; from the latent-lisp root.  Exit 0 iff the official state was derived
;;;; and written; any refusal exits nonzero with no artifact.
;;;;
;;;; WHAT THIS PROCESS IS ALLOWED TO KNOW — and nothing else:
;;;;   exec/store/            the primary durable journal (validated prefix)
;;;;   exec/evidence/*.bin    lawfully captured evidence, reached ONLY through
;;;;                          the journaled envelope-custody bindings (never a
;;;;                          directory enumeration — contract §16)
;;;;   exec/VERTICAL-PROGRAM-CONFIG.sexp   the PUBLIC program configuration
;;;;   the census procedure module (census.lisp) via load-census-only.lisp
;;;;
;;;; WHAT IT NEVER TOUCHES: campaign.lisp (orchestration), the harness, the
;;;; oracle, finalizer outputs, runs/<run>/private/, the corpse snapshots,
;;;; exec/export/, exec/mirror-sim/ (derived exports), dead-process memory.
;;;; The finalizer guard below is a live refusal, not a comment.
;;;;
;;;; DERIVATION ORIGIN: every state this process asserts is tagged
;;;; "reconstructed" — the tag names WHERE THE EVALUATION HAPPENED (a fresh
;;;; process over durable bytes), never a life number and never a claim
;;;; about what the dead processes believed.
;;;;
;;;; CANONICAL OUTPUT: the artifact is a CD/0 record encoded by PJS/0.  It
;;;; contains no wall-clock, no pid, no pathname, no host address, no
;;;; temporary directory, no filesystem-enumeration order.  Two runs over
;;;; the same durable evidence produce byte-identical artifacts, and so
;;;; does replay-census.lisp — which shares ONLY census.lisp with this file.
;;;;
;;;; — TALLYARD (Claude Fable 5 subagent), 2026-07-30

(load (merge-pathnames "load-census-only.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(defpackage #:vertical0-reconstruct
  (:use #:cl)
  (:export #:official-state-octets #:official-state-counters #:main))

(in-package #:vertical0-reconstruct)

;;; ---------------------------------------------------------------------------
;;; Local shorthands (this file's own; replay-census.lisp writes its own).

(defun id* (&rest segments)
  (lisp-plus-journal0:identifier-from-segments segments))
(defun str* (string) (lisp-plus-cd0:make-string-datum string))
(defun int* (value) (lisp-plus-cd0:make-integer-datum value))
(defun seq* (elements) (lisp-plus-cd0:make-sequence-datum elements))

(defun rec* (&rest pairs)
  "PAIRS is alternating (namespace name) datum.  NIL data are dropped, so
an absent fact is ABSENT — never spelled as an empty string."
  (lisp-plus-cd0:make-record-datum
   (loop for (key datum) on pairs by #'cddr
         when datum
           collect (lisp-plus-cd0:make-record-entry
                    (lisp-plus-journal0:identifier-from-segments key)
                    datum))))

(defun refuse (control &rest arguments)
  (format *error-output* "reconstruct-census: ~a~%"
          (apply #'format nil control arguments))
  (finish-output *error-output*)
  (sb-ext:exit :code 2))

;;; ---------------------------------------------------------------------------
;;; Admissible-input guards.

(defun finalizer-module-present-p ()
  (and (find-package '#:lisp-plus-vertical0-finalizer) t))

(defun guard-inputs (exec-dir)
  (cl-user::vertical0-census-only-guard)
  ;; The named-cell tooth (contract §11) deliberately runs THIS procedure
  ;; in a diagnostic image where the finalizer IS loaded and its cells
  ;; have been MAKUNBOUNDed.  That one declared diagnostic sets the
  ;; variable below; the official child process never does, and its
  ;; refusal is live either way.
  (when (and (finalizer-module-present-p)
             (not (sb-ext:posix-getenv
                   "VERTICAL0_RECONSTRUCT_DIAGNOSTIC_TOOTH")))
    (error "reconstruct-census: the FINALIZER module is present in this ~
            image; official state is derived without it (contract §11)"))
  (dolist (required '("VERTICAL-PROGRAM-CONFIG.sexp"
                      "store/JOURNAL-META.pjs"
                      "store/EVENTS.pj0"))
    (unless (probe-file (merge-pathnames required exec-dir))
      (error "reconstruct-census: execution directory lacks the primary ~
              input ~a" required)))
  t)

;;; ---------------------------------------------------------------------------
;;; The walk.  Bank order is this file's spine: the census procedure emits
;;; its outcomes in bank order, so the standings are collected the same way
;;; and the two seq's are index-aligned by construction.

(defun seat-authority-standing (store bootstrap authority seat-plist)
  "The seat's authority standing at the CURRENT validated prefix, folded
fresh.  :origin :reconstructed — Capability /0 law 11: a restart
derivation must say so."
  (let ((receipt
          (lisp-plus-capability0:query-live-authority
           store bootstrap
           :query-id (list "cap0-query"
                           (format nil "q-official-~a"
                                   (lisp-plus-vertical0:seat-field
                                    seat-plist :seat)))
           :capability-id (list "cap" (lisp-plus-vertical0:seat-field
                                       seat-plist :seat))
           :subject (getf authority :subject)
           :action (getf authority :action)
           ;; Contract §3 as corrected by C1: the per-seat resource IS the
           ;; seat's effect-cell identity.
           :resource (list "cella" (lisp-plus-vertical0:seat-field
                                    seat-plist :cell))
           :scope (getf authority :scope)
           :origin :reconstructed)))
    (values (string-downcase
             (symbol-name (lisp-plus-capability0:receipt-decision receipt)))
            (lisp-plus-capability0:receipt-reason receipt))))

(defun seat-retry-standing (store seat-id)
  "The CAP2-W1 pre-declaration scan over DURABLE BYTES ALONE.  A seat
holding an unresolved uncertain predecessor refuses a fresh dispatch; the
refusal is the seat's standing, not an error in this program."
  (handler-case
      (progn
        (lisp-plus-capability2:check-retry-safety-from-store
         store :seat-name seat-id
               :candidate-attempt-name (format nil "a-~a-official-scan"
                                               seat-id))
        "dispatch-lawful")
    (lisp-plus-kernel0:unsafe-retry ()
      "refused-unsafe-retry")))

(defun standing-record (store bootstrap authority seat-plist outcome)
  (let ((seat-id (lisp-plus-vertical0:seat-field seat-plist :seat)))
    (unless (equal seat-id (getf outcome :seat))
      (error "reconstruct-census: standings walk desynchronized from the ~
              census walk at ~a vs ~a" seat-id (getf outcome :seat)))
    (multiple-value-bind (decision reason)
        (seat-authority-standing store bootstrap authority seat-plist)
      (rec* '("standing" "seat") (str* seat-id)
            '("standing" "manifestation") (str* (getf outcome :manifestation))
            '("standing" "effect")
            (let ((effect (getf outcome :effect))) (and effect (str* effect)))
            '("standing" "absence-state")
            (let ((state (getf outcome :absence-state)))
              (and state (str* state)))
            '("standing" "refusal")
            (let ((refusal (getf outcome :refusal)))
              (and refusal (str* refusal)))
            '("standing" "projection-origin")
            (let ((origin (getf outcome :projection-origin)))
              (and origin (str* origin)))
            '("standing" "authority-decision") (str* decision)
            '("standing" "authority-reason") (str* reason)
            '("standing" "retry") (str* (seat-retry-standing store seat-id))))))

(defun evidence-records (store exec-dir)
  "Captured evidence, reached through the JOURNALED custody bindings in
journal order.  Each file's sha256 is recomputed and compared against the
binding: captured evidence is admissible only while it still IS the
evidence that was captured."
  (loop for event in (lisp-plus-vertical0::collect-events
                      (lisp-plus-vertical0::validated-events store)
                      :kind "vertical-record:envelope-custody")
        for body = (lisp-plus-vertical0::event-body event)
        for seat = (lisp-plus-vertical0::body-string body "vertical" "seat-id")
        for relative = (lisp-plus-vertical0::body-string body "vertical"
                                                         "evidence-file")
        for bound = (lisp-plus-vertical0::body-string body "vertical"
                                                      "raw-payload-sha256")
        for count = (lisp-plus-vertical0::body-integer body "vertical"
                                                       "raw-payload-octet-count")
        for octets = (lisp-plus-vertical0:read-octet-file
                      (merge-pathnames relative exec-dir))
        do (unless (equal bound (lisp-plus-journal0:sha256-hex octets))
             (error "reconstruct-census: captured evidence ~a no longer ~
                     matches its journaled sha256 binding" relative))
           (unless (eql count (length octets))
             (error "reconstruct-census: captured evidence ~a is ~a octets, ~
                     journaled as ~a" relative (length octets) count))
        collect (rec* '("evidence" "seat") (str* seat)
                      '("evidence" "file") (str* relative)
                      '("evidence" "octet-count") (int* (length octets))
                      '("evidence" "integrity")
                      (str* "sha256-matches-journaled-binding"))))

(defun budget-record (store config)
  "Cost/budget fold, re-derived from durable records only.  Exact
rationals are carried as numerator/denominator integer pairs: no float
ever crosses a durable boundary, and the ketiv (lexeme) is not the qere."
  (multiple-value-bind (spent count)
      (lisp-plus-vertical0:fold-durable-costs store)
    (let* ((ceiling (lisp-plus-vertical0::parse-lexeme-rational
                     (getf (first (lisp-plus-vertical0:config-field
                                   config :budget))
                           :ceiling-lexeme)))
           (remaining (- ceiling spent)))
      (values
       (rec* '("budget" "ceiling-numerator") (int* (numerator ceiling))
             '("budget" "ceiling-denominator") (int* (denominator ceiling))
             '("budget" "spent-numerator") (int* (numerator spent))
             '("budget" "spent-denominator") (int* (denominator spent))
             '("budget" "remaining-numerator") (int* (numerator remaining))
             '("budget" "remaining-denominator") (int* (denominator remaining))
             '("budget" "cost-record-count") (int* count))
       count))))

;;; ---------------------------------------------------------------------------
;;; The official state.

(defun official-state-octets (exec-dir-namestring)
  "Derive the official state of the campaign in EXEC-DIR from durable
evidence alone.  Returns (values canonical-octets counters-plist)."
  (let* ((exec-dir (pathname (concatenate 'string exec-dir-namestring
                                          (if (char= #\/ (char exec-dir-namestring
                                                               (1- (length
                                                                    exec-dir-namestring))))
                                              "" "/"))))
         (ignore (guard-inputs exec-dir))
         (config (lisp-plus-vertical0:read-vertical-config
                  (merge-pathnames "VERTICAL-PROGRAM-CONFIG.sexp" exec-dir)))
         (store (lisp-plus-journal0:open-store
                 (merge-pathnames "store/" exec-dir)))
         (report (lisp-plus-journal0:validate-journal store))
         (authority (first (lisp-plus-vertical0:config-field
                            config :authority)))
         (bootstrap (lisp-plus-capability0:declare-bootstrap-authority
                     (list "issuer" (getf authority :bootstrap-issuer))
                     (lisp-plus-journal0:store-id-string
                      (lisp-plus-journal0:validate-metadata-octets
                       (lisp-plus-journal0:render-metadata-octets
                        (lisp-plus-journal0:build-metadata-record
                         :declared-durability
                         (lisp-plus-vertical0:config-durability config)
                         :nonce-octets
                         (lisp-plus-vertical0:config-nonce-octets
                          config))))))))
    (declare (ignore ignore))
    (unless (eq :valid (lisp-plus-journal0:prefix-report-status report))
      (error "reconstruct-census: durable journal did not validate :valid ~
              (~a); official state is founded or it is not asserted"
             (lisp-plus-journal0:prefix-report-status report)))
    (multiple-value-bind (census-record outcomes)
        (lisp-plus-vertical0:derive-census store config
                                           :derivation-origin "reconstructed")
      (multiple-value-bind (budget cost-count) (budget-record store config)
        (let* ((bank (lisp-plus-vertical0:config-bank config))
               (standings (loop for seat-plist in bank
                                for outcome in outcomes
                                collect (standing-record store bootstrap
                                                         authority seat-plist
                                                         outcome)))
               (evidence (evidence-records store exec-dir))
               (state
                 (rec* '("official" "record-kind")
                       (id* "record" "official-state")
                       '("official" "procedure-id")
                       (str* "vertical-official-state-0")
                       '("official" "procedure-version") (int* 0)
                       '("official" "derivation-origin") (str* "reconstructed")
                       '("official" "journal")
                       (rec* '("journal" "store-id")
                             (str* (lisp-plus-journal0:journal-store-store-id
                                    store))
                             '("journal" "validated-status") (str* "valid")
                             '("journal" "frame-count")
                             (int* (lisp-plus-journal0:prefix-report-frame-count
                                    report))
                             '("journal" "terminal-digest")
                             (str* (lisp-plus-journal0:prefix-report-terminal-digest
                                    report)))
                       '("official" "budget") budget
                       '("official" "evidence") (seq* evidence)
                       '("official" "census") census-record
                       '("official" "standings") (seq* standings))))
          (values
           (lisp-plus-journal0:encode-pjs0 state)
           (list :seats (length outcomes)
                 :cost-records cost-count
                 :evidence-files (length evidence)
                 :frames (lisp-plus-journal0:prefix-report-frame-count
                          report))))))))

(defun official-state-counters (exec-dir-namestring)
  (nth-value 1 (official-state-octets exec-dir-namestring)))

(defun main ()
  (let ((arguments (rest sb-ext:*posix-argv*)))
    (unless (= 2 (length arguments))
      (refuse "usage: reconstruct-census.lisp <exec-dir> <output-path>"))
    (handler-case
        (multiple-value-bind (octets counters)
            (official-state-octets (first arguments))
          (with-open-file (stream (second arguments)
                                  :direction :output
                                  :element-type '(unsigned-byte 8)
                                  :if-exists :supersede
                                  :if-does-not-exist :create)
            (write-sequence octets stream))
          ;; Live counters — derived here, this run, from what was walked.
          (format t "reconstruct-census: OFFICIAL RECONSTRUCTION (fresh process)~%")
          (format t "  derivation-origin  reconstructed~%")
          (format t "  journal frames     ~a~%" (getf counters :frames))
          (format t "  seats derived      ~a~%" (getf counters :seats))
          (format t "  cost records folded ~a~%" (getf counters :cost-records))
          (format t "  evidence files verified ~a~%"
                  (getf counters :evidence-files))
          (format t "  canonical octets   ~a~%" (length octets))
          (format t "  canonical sha256   ~a~%"
                  (lisp-plus-journal0:sha256-hex octets))
          (format t "RESULT: OFFICIAL-STATE-DERIVED~%")
          (sb-ext:exit :code 0))
      (error (condition) (refuse "~a" condition)))))

;;; Script mode unless a gate loads this file as a library.
(unless (sb-ext:posix-getenv "VERTICAL0_RECONSTRUCT_LIBRARY")
  (main))
