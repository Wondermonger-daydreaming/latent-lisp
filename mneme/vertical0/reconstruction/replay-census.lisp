;;;; replay-census.lisp — THE INDEPENDENT REPLAY (contract §11).
;;;;
;;;; Run:  sbcl --script mneme/vertical0/reconstruction/replay-census.lisp \
;;;;         <exec-dir> <output-path>
;;;; from the latent-lisp root.  Exit 0 iff the official state was
;;;; independently re-derived and written.
;;;;
;;;; WHAT "INDEPENDENT" MEANS HERE, EXACTLY.  Contract §11 requires "a
;;;; separate read-only program that does not import the orchestration
;;;; module, applying the SAME census procedure".  The sameness is
;;;; mandated, not accidental: a replay that re-implemented the census
;;;; would be testing a second opinion, not testing reproduction.  So:
;;;;
;;;;   SHARED with reconstruct-census.lisp — and only this: census.lisp
;;;;     (vertical-census-0) and the non-orchestration modules it needs
;;;;     (package, config-reader, records, evidence, budget), via the same
;;;;     minimal load chain.
;;;;   NOT SHARED — everything this file does with it: the store walk, the
;;;;     event index, the seat walk (this file walks the DECLARED SEAT
;;;;     ORDER and proves it agrees with the bank, where the official
;;;;     program walks the bank), the evidence reader (its own octet
;;;;     reader, not read-octet-file), the budget fold (its own walk over
;;;;     the journaled cost records, not fold-durable-costs), the record
;;;;     assembly (an alist-driven builder), the output writer.
;;;;
;;;; READ-ONLY: this program opens the journal, reads config, reads the
;;;; captured evidence files, and writes exactly one file — the artifact
;;;; path it was given.  It appends nothing, renames nothing, deletes
;;;; nothing inside the execution directory.
;;;;
;;;; The artifact must be BYTE-IDENTICAL to the official reconstruction's.
;;;; Anything else is a finding, not a nuisance.
;;;;
;;;; — TALLYARD (Claude Fable 5 subagent), 2026-07-30

(load (merge-pathnames "load-census-only.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(defpackage #:vertical0-replay
  (:use #:cl)
  (:export #:replayed-state-octets #:main))

(in-package #:vertical0-replay)

;;; ---------------------------------------------------------------------------
;;; An alist-driven canonical record builder.  ENTRIES are
;;; ((namespace name) . datum); NIL data drop out, so an absent fact stays
;;; absent instead of becoming an empty string.

(defun build (entries)
  (lisp-plus-cd0:make-record-datum
   (loop for (key . datum) in entries
         when datum
           collect (lisp-plus-cd0:make-record-entry
                    (lisp-plus-journal0:identifier-from-segments key)
                    datum))))

(defun as-text (string) (lisp-plus-cd0:make-string-datum string))
(defun as-count (value) (lisp-plus-cd0:make-integer-datum value))

(defun bail (control &rest arguments)
  (format *error-output* "replay-census: ~a~%"
          (apply #'format nil control arguments))
  (finish-output *error-output*)
  (sb-ext:exit :code 2))

;;; ---------------------------------------------------------------------------
;;; This file's own journal walk.

(defun directory-of (namestring)
  (pathname (concatenate 'string namestring
                         (if (char= #\/ (char namestring
                                              (1- (length namestring))))
                             "" "/"))))

(defun event-list (store)
  "Every event of the validated prefix, oldest first — walked here rather
than borrowed."
  (let* ((report (lisp-plus-journal0:validate-journal store))
         (status (lisp-plus-journal0:prefix-report-status report))
         (vector (lisp-plus-journal0:prefix-report-events report)))
    (unless (eq :valid status)
      (error "replay-census: journal prefix is ~a, not :valid" status))
    (values (coerce (subseq vector 0 (fill-pointer vector)) 'list) report)))

(defun kind-of (event)
  (let ((field (lisp-plus-journal0:record-field event "event" "kind")))
    (and field (lisp-plus-cd0:identifier-datum-p field)
         (lisp-plus-journal0:identifier-segment-string field))))

(defun body-of (event)
  (lisp-plus-journal0:record-field event "event" "body"))

(defun text-field (body namespace name)
  (let ((field (lisp-plus-journal0:record-field body namespace name)))
    (cond ((null field) nil)
          ((lisp-plus-cd0:string-datum-p field)
           (lisp-plus-cd0:string-datum-value field))
          ((lisp-plus-cd0:identifier-datum-p field)
           (lisp-plus-journal0:identifier-segment-string field))
          (t nil))))

(defun count-field (body namespace name)
  (let ((field (lisp-plus-journal0:record-field body namespace name)))
    (and field (lisp-plus-cd0:integer-datum-p field)
         (lisp-plus-cd0:integer-datum-value field))))

(defun events-of-kind (events kind)
  (remove-if-not (lambda (event) (equal kind (kind-of event))) events))

;;; ---------------------------------------------------------------------------
;;; This file's own octet reader (the official program uses the vertical
;;; evidence module's; neither borrows the other).

(defun slurp-octets (pathname)
  (with-open-file (stream pathname :direction :input
                                   :element-type '(unsigned-byte 8))
    (let ((buffer (make-array (file-length stream)
                              :element-type '(unsigned-byte 8))))
      (unless (= (length buffer) (read-sequence buffer stream))
        (error "replay-census: short read on captured evidence"))
      buffer)))

;;; ---------------------------------------------------------------------------
;;; This file's own exact-number reader and budget fold.

(defun exact-value (datum)
  (cond ((lisp-plus-cd0:integer-datum-p datum)
         (lisp-plus-cd0:integer-datum-value datum))
        ((lisp-plus-cd0:rational-datum-p datum)
         (/ (lisp-plus-cd0:rational-datum-numerator datum)
            (lisp-plus-cd0:rational-datum-denominator datum)))
        (t (error "replay-census: not a canonical number datum"))))

(defun replayed-spend (events)
  "Fold the journaled cost records.  A record without a readable canonical
amount stops the fold — missing cost is missing, never zero."
  (let ((total 0) (seen 0))
    (dolist (event (events-of-kind events "ap0-record:cost-record")
                   (values total seen))
      (let ((amount (lisp-plus-journal0:record-field
                     (body-of event) "ap0" "canonical-amount")))
        (unless amount
          (error "replay-census: a journaled cost record carries no ~
                  canonical amount; missing cost is never zero"))
        (setf total (+ total (exact-value amount)))
        (incf seen)))))

;;; ---------------------------------------------------------------------------
;;; Standings.

(defun authority-pair (store bootstrap authority seat-plist)
  (let* ((seat (lisp-plus-vertical0:seat-field seat-plist :seat))
         (receipt (lisp-plus-capability0:query-live-authority
                   store bootstrap
                   :query-id (list "cap0-query"
                                   (format nil "q-official-~a" seat))
                   :capability-id (list "cap" seat)
                   :subject (getf authority :subject)
                   :action (getf authority :action)
                   :resource (list "cella"
                                   (lisp-plus-vertical0:seat-field
                                    seat-plist :cell))
                   :scope (getf authority :scope)
                   :origin :reconstructed)))
    (cons (string-downcase
           (symbol-name (lisp-plus-capability0:receipt-decision receipt)))
          (lisp-plus-capability0:receipt-reason receipt))))

(defun retry-text (store seat)
  (handler-case
      (progn (lisp-plus-capability2:check-retry-safety-from-store
              store :seat-name seat
                    :candidate-attempt-name
                    (format nil "a-~a-official-scan" seat))
             "dispatch-lawful")
    (lisp-plus-kernel0:unsafe-retry () "refused-unsafe-retry")))

;;; ---------------------------------------------------------------------------
;;; The replay.

(defun replayed-state-octets (exec-dir-namestring)
  (cl-user::vertical0-census-only-guard)
  (when (find-package '#:lisp-plus-vertical0-finalizer)
    (error "replay-census: the FINALIZER module is present in this image"))
  (let* ((exec (directory-of exec-dir-namestring))
         (config (lisp-plus-vertical0:read-vertical-config
                  (merge-pathnames "VERTICAL-PROGRAM-CONFIG.sexp" exec)))
         (store (lisp-plus-journal0:open-store (merge-pathnames "store/" exec)))
         (bank (lisp-plus-vertical0:config-bank config))
         (order (lisp-plus-vertical0:config-seat-order config))
         (authority (first (lisp-plus-vertical0:config-field config
                                                             :authority))))
    ;; The seat walk: the DECLARED ORDER, proven to agree with the bank the
    ;; census procedure walks.  If a future config ever ordered them
    ;; differently this refuses instead of silently emitting a differently
    ;; sorted — and therefore unequal — artifact.
    (unless (equal order (mapcar (lambda (plist)
                                   (lisp-plus-vertical0:seat-field plist :seat))
                                 bank))
      (error "replay-census: declared seat order and bank order differ; the ~
              replay walk cannot be aligned with the census walk"))
    (multiple-value-bind (events report) (event-list store)
      (let* ((bootstrap
               (lisp-plus-capability0:declare-bootstrap-authority
                (list "issuer" (getf authority :bootstrap-issuer))
                (lisp-plus-journal0:store-id-string
                 (lisp-plus-journal0:validate-metadata-octets
                  (lisp-plus-journal0:render-metadata-octets
                   (lisp-plus-journal0:build-metadata-record
                    :declared-durability
                    (lisp-plus-vertical0:config-durability config)
                    :nonce-octets
                    (lisp-plus-vertical0:config-nonce-octets config)))))))
             (census nil)
             (outcomes nil))
        (multiple-value-setq (census outcomes)
          (lisp-plus-vertical0:derive-census
           store config :derivation-origin "reconstructed"))
        (let* ((standings
                 (loop for seat in order
                       for outcome in outcomes
                       for seat-plist = (find seat bank :test #'equal
                                              :key (lambda (plist)
                                                     (lisp-plus-vertical0:seat-field
                                                      plist :seat)))
                       do (unless (equal seat (getf outcome :seat))
                            (error "replay-census: seat walk desynchronized ~
                                    at ~a" seat))
                       collect
                       (let ((pair (authority-pair store bootstrap authority
                                                   seat-plist)))
                         (build
                          (list
                           (cons '("standing" "seat") (as-text seat))
                           (cons '("standing" "manifestation")
                                 (as-text (getf outcome :manifestation)))
                           (cons '("standing" "effect")
                                 (let ((v (getf outcome :effect)))
                                   (and v (as-text v))))
                           (cons '("standing" "absence-state")
                                 (let ((v (getf outcome :absence-state)))
                                   (and v (as-text v))))
                           (cons '("standing" "refusal")
                                 (let ((v (getf outcome :refusal)))
                                   (and v (as-text v))))
                           (cons '("standing" "projection-origin")
                                 (let ((v (getf outcome :projection-origin)))
                                   (and v (as-text v))))
                           (cons '("standing" "authority-decision")
                                 (as-text (car pair)))
                           (cons '("standing" "authority-reason")
                                 (as-text (cdr pair)))
                           (cons '("standing" "retry")
                                 (as-text (retry-text store seat))))))))
               (evidence
                 (loop for event in (events-of-kind
                                     events "vertical-record:envelope-custody")
                       for body = (body-of event)
                       for relative = (text-field body "vertical"
                                                  "evidence-file")
                       for octets = (slurp-octets (merge-pathnames relative
                                                                   exec))
                       do (unless (equal (text-field body "vertical"
                                                     "raw-payload-sha256")
                                         (lisp-plus-journal0:sha256-hex octets))
                            (error "replay-census: captured evidence ~a no ~
                                    longer matches its journaled binding"
                                   relative))
                          (unless (eql (count-field body "vertical"
                                                    "raw-payload-octet-count")
                                       (length octets))
                            (error "replay-census: captured evidence ~a has ~
                                    an unexpected octet count" relative))
                       collect (build
                                (list
                                 (cons '("evidence" "seat")
                                       (as-text (text-field body "vertical"
                                                            "seat-id")))
                                 (cons '("evidence" "file") (as-text relative))
                                 (cons '("evidence" "octet-count")
                                       (as-count (length octets)))
                                 (cons '("evidence" "integrity")
                                       (as-text
                                        "sha256-matches-journaled-binding")))))))
          (multiple-value-bind (spent cost-count) (replayed-spend events)
            (let* ((ceiling (exact-value
                             (lisp-plus-adapter0:parse-cost-lexeme
                              (getf (first (lisp-plus-vertical0:config-field
                                            config :budget))
                                    :ceiling-lexeme))))
                   (left (- ceiling spent))
                   (state
                     (build
                      (list
                       (cons '("official" "record-kind")
                             (lisp-plus-journal0:identifier-from-segments
                              '("record" "official-state")))
                       (cons '("official" "procedure-id")
                             (as-text "vertical-official-state-0"))
                       (cons '("official" "procedure-version") (as-count 0))
                       (cons '("official" "derivation-origin")
                             (as-text "reconstructed"))
                       (cons '("official" "journal")
                             (build
                              (list
                               (cons '("journal" "store-id")
                                     (as-text
                                      (lisp-plus-journal0:journal-store-store-id
                                       store)))
                               (cons '("journal" "validated-status")
                                     (as-text "valid"))
                               (cons '("journal" "frame-count")
                                     (as-count
                                      (lisp-plus-journal0:prefix-report-frame-count
                                       report)))
                               (cons '("journal" "terminal-digest")
                                     (as-text
                                      (lisp-plus-journal0:prefix-report-terminal-digest
                                       report))))))
                       (cons '("official" "budget")
                             (build
                              (list
                               (cons '("budget" "ceiling-numerator")
                                     (as-count (numerator ceiling)))
                               (cons '("budget" "ceiling-denominator")
                                     (as-count (denominator ceiling)))
                               (cons '("budget" "spent-numerator")
                                     (as-count (numerator spent)))
                               (cons '("budget" "spent-denominator")
                                     (as-count (denominator spent)))
                               (cons '("budget" "remaining-numerator")
                                     (as-count (numerator left)))
                               (cons '("budget" "remaining-denominator")
                                     (as-count (denominator left)))
                               (cons '("budget" "cost-record-count")
                                     (as-count cost-count)))))
                       (cons '("official" "evidence")
                             (lisp-plus-cd0:make-sequence-datum evidence))
                       (cons '("official" "census") census)
                       (cons '("official" "standings")
                             (lisp-plus-cd0:make-sequence-datum standings))))))
              (values (lisp-plus-journal0:encode-pjs0 state)
                      (list :seats (length outcomes)
                            :cost-records cost-count
                            :evidence-files (length evidence)
                            :frames (lisp-plus-journal0:prefix-report-frame-count
                                     report))))))))))

(defun main ()
  (let ((arguments (rest sb-ext:*posix-argv*)))
    (unless (= 2 (length arguments))
      (bail "usage: replay-census.lisp <exec-dir> <output-path>"))
    (handler-case
        (multiple-value-bind (octets counters)
            (replayed-state-octets (first arguments))
          (with-open-file (stream (second arguments)
                                  :direction :output
                                  :element-type '(unsigned-byte 8)
                                  :if-exists :supersede
                                  :if-does-not-exist :create)
            (write-sequence octets stream))
          (format t "replay-census: INDEPENDENT REPLAY (read-only, fresh process)~%")
          (format t "  derivation-origin  reconstructed~%")
          (format t "  journal frames     ~a~%" (getf counters :frames))
          (format t "  seats replayed     ~a~%" (getf counters :seats))
          (format t "  cost records folded ~a~%" (getf counters :cost-records))
          (format t "  evidence files verified ~a~%"
                  (getf counters :evidence-files))
          (format t "  canonical octets   ~a~%" (length octets))
          (format t "  canonical sha256   ~a~%"
                  (lisp-plus-journal0:sha256-hex octets))
          (format t "RESULT: REPLAY-STATE-DERIVED~%")
          (sb-ext:exit :code 0))
      (error (condition) (bail "~a" condition)))))

(unless (sb-ext:posix-getenv "VERTICAL0_REPLAY_LIBRARY")
  (main))
