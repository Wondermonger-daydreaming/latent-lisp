;;;; run-reconstruction-gate.lisp — the reconstruction gate (contract §11).
;;;;
;;;; Run:  sbcl --script mneme/vertical0/reconstruction/run-reconstruction-gate.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;; Transcript: mneme/vertical0/RUN-RECONSTRUCTION.txt (and, for the twin
;;;; run, RUN-RECONSTRUCTION-SECOND.txt); the pair must be byte-identical.
;;;;
;;;; WHAT THIS GATE IS.  Contract §11 makes one claim — "the official state
;;;; of the campaign is what a fresh process can derive from durable
;;;; evidence alone" — and gives the exact way to earn it: a fresh
;;;; reconstruction, an independent replay, a finalizer that adds no unique
;;;; primary fact, and a proof by DELETION rather than by inspection.  This
;;;; file executes that, live, over runs/campaign-1/exec.
;;;;
;;;; THE GATE IS HARNESS-SIDE.  It may quote the oracle's expected outcome
;;;; map (below, inline): only CHILDREN may never see the oracle, and no
;;;; child spawned here is given it — the children receive an execution
;;;; directory and an output path, nothing else.  Every child's environment
;;;; is built by CHILD-ENVIRONMENT, which strips every VERTICAL0_* variable
;;;; before adding the ones a given tooth declares.
;;;;
;;;; TEETH.  A gate that found nothing must be shown able to find
;;;; something, so every comparator here is fired at a planted fault as
;;;; well as at the real artifact: a mutated byte, a wrong expected map, a
;;;; missing primary input, a faked orchestration module, a deleted
;;;; journal, a live finalizer-only "primary fact", and a probe closure
;;;; that genuinely depends on a finalizer cell.
;;;;
;;;; DETERMINISM.  No wall-clock, no pid, no random path, no absolute path
;;;; is printed.  The workspace root is a FIXED path
;;;; (/tmp/vertical0-reconstruction-gate/), rebuilt from scratch each run
;;;; and never named in the transcript.  Everything printed is a check
;;;; line, a count, or a sha256 of content.
;;;;
;;;; — TALLYARD (Claude Fable 5 subagent), 2026-07-30

(require :sb-posix)

;;; The gate holds every module (harness jurisdiction).  The children hold
;;; only what contract §11 allows them.
(sb-posix:putenv "VERTICAL0_RECONSTRUCT_LIBRARY=1")
(sb-posix:putenv "VERTICAL0_REPLAY_LIBRARY=1")
(sb-posix:putenv "VERTICAL0_FINALIZER_LIBRARY=1")

(load (merge-pathnames "reconstruct-census.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))
(load (merge-pathnames "replay-census.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))
(load (merge-pathnames "finalizer.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(defpackage #:vertical0-reconstruction-gate (:use #:cl))
(in-package #:vertical0-reconstruction-gate)

;;; ---------------------------------------------------------------------------
;;; House gate style: check / note / RESULT sentinel / exit code.

(defvar *checks* 0)
(defvar *failures* 0)

(defvar *leak-sink* nil
  "Where the named-cell probe closures deposit whatever they manage to
read.  A global special, deliberately: an assignment to one is a side
effect the compiler must preserve, so the probe's read cannot be flushed
away before it has a chance to signal.")

(defun check (description thunk)
  (incf *checks*)
  (let ((description (format nil description))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "[R~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[R~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))))

(defun note (control &rest arguments)
  (apply #'format t control arguments)
  (terpri))

;;; ---------------------------------------------------------------------------
;;; Paths (never printed) and process plumbing.

(defparameter *lane* "mneme/vertical0/")
(defparameter *campaign-exec* "mneme/vertical0/runs/campaign-1/exec")
(defparameter *work* "/tmp/vertical0-reconstruction-gate/")

(defun work (relative) (concatenate 'string *work* relative))

(defun child-environment (&rest additions)
  "The child's environment: every VERTICAL0_* variable stripped, then the
declared teeth added.  A child must never inherit the gate's library
flags, and must never receive the oracle by any channel."
  (append additions
          (remove-if (lambda (entry)
                       (and (>= (length entry) 10)
                            (string= "VERTICAL0_" entry :end2 10)))
                     (sb-ext:posix-environ))))

(defun run-child (script arguments &key environment)
  "Run SCRIPT under a fresh sbcl.  Returns (values exit-code output)."
  (let* ((sink (make-string-output-stream))
         (process (sb-ext:run-program
                   "sbcl" (append (list "--script" script) arguments)
                   :search t :output sink :error sink
                   :environment (or environment (child-environment)))))
    (values (sb-ext:process-exit-code process)
            (get-output-stream-string sink))))

(defun shell (program &rest arguments)
  (sb-ext:process-exit-code
   (sb-ext:run-program program arguments :search t :output nil :error nil)))

(defun slurp-octets (pathname)
  (with-open-file (stream pathname :direction :input
                                   :element-type '(unsigned-byte 8))
    (let ((buffer (make-array (file-length stream)
                              :element-type '(unsigned-byte 8))))
      (read-sequence buffer stream)
      buffer)))

(defun slurp-text (pathname)
  (with-open-file (stream pathname :direction :input :external-format :utf-8)
    (let ((buffer (make-string (file-length stream))))
      (subseq buffer 0 (read-sequence buffer stream)))))

(defun octets-equal (left right)
  (and (= (length left) (length right))
       (every #'= left right)))

(defun digest (octets) (lisp-plus-journal0:sha256-hex octets))

(defun tree-manifest-digest (root)
  "A sha256 over (relative-path, content-digest) for every file under ROOT,
in sorted path order.  Deterministic; used to prove the completed campaign
was not mutated by anything this gate ran."
  (let* ((root-name (namestring (truename root)))
         (files (sort (remove-if #'null
                                 (mapcar (lambda (path)
                                           (and (pathname-name path) path))
                                         (directory
                                          (merge-pathnames "**/*.*"
                                                           (pathname
                                                            (concatenate
                                                             'string root-name
                                                             (if (char= #\/ (char root-name (1- (length root-name))))
                                                                 "" "/")))))))
                      #'string< :key #'namestring))
         (lines (with-output-to-string (out)
                  (dolist (file files)
                    (format out "~a ~a~%"
                            (subseq (namestring file) (length root-name))
                            (digest (slurp-octets file)))))))
    (values (digest (map '(vector (unsigned-byte 8)) #'char-code lines))
            (length files))))

;;; ---------------------------------------------------------------------------
;;; Canonical artifact readers.

(defun decode-state (octets) (lisp-plus-journal0:decode-pjs0 octets))

(defun field (record namespace name)
  (lisp-plus-journal0:record-field record namespace name))

(defun text (datum)
  (cond ((null datum) nil)
        ((lisp-plus-cd0:string-datum-p datum)
         (lisp-plus-cd0:string-datum-value datum))
        ((lisp-plus-cd0:identifier-datum-p datum)
         (lisp-plus-journal0:identifier-segment-string datum))
        (t nil)))

(defun number-of (datum)
  (and datum (lisp-plus-cd0:integer-datum-p datum)
       (lisp-plus-cd0:integer-datum-value datum)))

(defun census-of (state) (field state "official" "census"))

(defun outcome-map (state)
  "The 12-seat outcome map as comparable plain data, in census order."
  (loop for seat-record across (lisp-plus-cd0:sequence-datum-elements
                                (field (census-of state) "census" "seats"))
        collect (remove nil
                        (list (text (field seat-record "census" "seat"))
                              (text (field seat-record "census" "manifestation"))
                              (text (field seat-record "census" "effect"))
                              (text (field seat-record "census" "absence-state"))
                              (text (field seat-record "census" "refusal"))
                              (let ((n (number-of (field seat-record "census"
                                                         "chunks-preserved"))))
                                (and n (format nil "chunks=~a" n)))
                              (text (field seat-record "census"
                                           "projection-origin"))))))

;;; The EXPECTED outcome map — asserted inline, harness-side, from the
;;; sealed contract §3's "required outcome" column and the oracle's
;;; :expected-outcomes table.  Order is the declared bank order.
(defparameter *expected-outcomes*
  '(("seat-first-fruit"   "present"         "settled")
    ("seat-empty-page"    "present-empty"   "settled")
    ("seat-locked-purse"  "absent"          "refused-pre-effect"
                          "budget-ceiling-exceeded")
    ("seat-torn-crossing" "absent"          "uncertain-unresolved")
    ("seat-half-song"     "present-partial" "crossed-unsettled-partial-closed"
                          "chunks=1")
    ("seat-broken-glass"  "present-invalid" "settled")
    ("seat-dead-hand"     "absent"          "refused-pre-effect"
                          "capability-revoked")
    ("seat-slammed-door"  "absent"          "reconciled-not-applied")
    ("seat-burned-draft"  "absent"          "settled" "absent-after-completion")
    ("seat-sealed-letter" "present"         "settled" "derived-recovery")
    ("seat-cold-supper"   "present"         "settled")
    ("seat-late-riser"    "present"         "settled")))

(defun outcome-maps-agree-p (derived expected)
  (and (= (length derived) (length expected))
       (every (lambda (left right)
                (and (= (length left) (length right))
                     (every #'equal left right)))
              derived expected)))

;;; ---------------------------------------------------------------------------

(note "run-reconstruction-gate — Vertical Specimen /0, contract §11")
(note "the official state is what a FRESH process derives from durable ~
evidence alone")

(shell "rm" "-rf" *work*)
(ensure-directories-exist *work*)

(defparameter *exec-digest-before* (tree-manifest-digest *campaign-exec*))

;;; ===========================================================================
(note "~%== A. the official reconstruction, in a fresh child process ==")

(defparameter *official-out* (work "official.pjs"))
(defparameter *official-exit* nil)
(defparameter *official-text* "")
(defparameter *official-octets* nil)

(check "1 reconstruct-census.lisp runs in a FRESH child process over the ~
        completed campaign's exec/ and exits 0"
  (lambda ()
    (multiple-value-setq (*official-exit* *official-text*)
      (run-child (concatenate 'string *lane* "reconstruction/reconstruct-census.lisp")
                 (list *campaign-exec* *official-out*)))
    (and (eql 0 *official-exit*)
         (search "RESULT: OFFICIAL-STATE-DERIVED" *official-text*))))

(check "2 the census artifact was produced and is non-empty"
  (lambda ()
    (and (probe-file *official-out*)
         (progn (setf *official-octets* (slurp-octets *official-out*))
                (plusp (length *official-octets*))))))

;;; ===========================================================================
(note "~%== B. the independent replay, in its own fresh child process ==")

(defparameter *replay-out* (work "replay.pjs"))
(defparameter *replay-octets* nil)

(check "3 replay-census.lisp — structurally separate source, same census ~
        procedure — runs in a fresh child and exits 0"
  (lambda ()
    (multiple-value-bind (code text)
        (run-child (concatenate 'string *lane* "reconstruction/replay-census.lisp")
                   (list *campaign-exec* *replay-out*))
      (and (eql 0 code) (search "RESULT: REPLAY-STATE-DERIVED" text)))))

(check "4 the replay artifact was produced and is non-empty"
  (lambda ()
    (and (probe-file *replay-out*)
         (progn (setf *replay-octets* (slurp-octets *replay-out*))
                (plusp (length *replay-octets*))))))

;;; ===========================================================================
(note "~%== C. the two official results are BYTE-IDENTICAL and both ~
:reconstructed ==")

(check "5 official reconstruction and independent replay are byte-identical"
  (lambda () (octets-equal *official-octets* *replay-octets*)))

(check "6 TEETH: the byte comparator finds a single flipped octet ~
        (a comparator that has never refused is untested)"
  (lambda ()
    (let ((mutated (copy-seq *official-octets*)))
      (setf (aref mutated (floor (length mutated) 2))
            (logxor 1 (aref mutated (floor (length mutated) 2))))
      (not (octets-equal *official-octets* mutated)))))

(check "7 the official state carries derivation-origin \"reconstructed\" ~
        at the top level AND inside the census record"
  (lambda ()
    (let ((state (decode-state *official-octets*)))
      (and (equal "reconstructed"
                  (text (field state "official" "derivation-origin")))
           (equal "reconstructed"
                  (text (field (census-of state) "census"
                               "derivation-origin")))
           (equal "vertical-census-0"
                  (text (field (census-of state) "census" "procedure-id")))))))

(check "8 the replay's artifact carries the same origin tag ~
        (decoded independently, not inferred from the byte comparison)"
  (lambda ()
    (let ((state (decode-state *replay-octets*)))
      (and (equal "reconstructed"
                  (text (field state "official" "derivation-origin")))
           (equal "reconstructed"
                  (text (field (census-of state) "census"
                               "derivation-origin")))))))

;;; ===========================================================================
(note "~%== D. the 12-seat outcome map, against the sealed expectations ==")

(defparameter *derived-map* (outcome-map (decode-state *official-octets*)))

(check "9 the derived census holds exactly 12 seats"
  (lambda () (= 12 (length *derived-map*))))

(check "10 the derived outcome map equals the sealed contract §3 / oracle ~
        expected-outcomes table, seat for seat"
  (lambda () (outcome-maps-agree-p *derived-map* *expected-outcomes*)))

(check "11 TEETH: the outcome comparator refuses a deliberately wrong ~
        expected map (S2 promoted from uncertain to settled)"
  (lambda ()
    (let ((wrong (mapcar (lambda (row)
                           (if (equal (first row) "seat-torn-crossing")
                               (list "seat-torn-crossing" "present" "settled")
                               row))
                         *expected-outcomes*)))
      (not (outcome-maps-agree-p *derived-map* wrong)))))

(note "~%   the outcome map as DERIVED (not as remembered):")
(dolist (row *derived-map*)
  (note "     ~{~a~^ | ~}" row))

;;; ===========================================================================
(note "~%== E. refusals: what the official program will not do ==")

(check "12 TEETH: a child whose image is told the ORCHESTRATION module is ~
        present refuses — nonzero exit, no RESULT sentinel"
  (lambda ()
    (multiple-value-bind (code text)
        (run-child (concatenate 'string *lane*
                                "reconstruction/reconstruct-census.lisp")
                   (list *campaign-exec* (work "must-not-exist.pjs"))
                   :environment (child-environment "VERTICAL0_FAKE_ORCHESTRATION=1"))
      (and (not (eql 0 code))
           (not (search "RESULT:" text))
           (not (probe-file (work "must-not-exist.pjs")))))))

(check "13 TEETH: a child pointed at a directory without the primary ~
        journal refuses — nonzero exit, no artifact"
  (lambda ()
    (ensure-directories-exist (work "empty/"))
    (multiple-value-bind (code text)
        (run-child (concatenate 'string *lane*
                                "reconstruction/reconstruct-census.lisp")
                   (list (work "empty") (work "also-must-not-exist.pjs")))
      (and (not (eql 0 code))
           (not (search "RESULT:" text))
           (not (probe-file (work "also-must-not-exist.pjs")))))))

;;; ===========================================================================
(note "~%== F. temporal repeatability of the derivation ==")

(check "14 a second official child over the same durable evidence produces ~
        a byte-identical artifact"
  (lambda ()
    (multiple-value-bind (code text)
        (run-child (concatenate 'string *lane*
                                "reconstruction/reconstruct-census.lisp")
                   (list *campaign-exec* (work "official-twin.pjs")))
      (and (eql 0 code)
           (search "RESULT: OFFICIAL-STATE-DERIVED" text)
           (octets-equal *official-octets*
                         (slurp-octets (work "official-twin.pjs")))))))

;;; ===========================================================================
(note "~%== G. the FINALIZER-DELETION PROOF ==")

(defparameter *ws* (work "deletion-workspace/exec"))

(check "15 the completed run is copied to a workspace (the campaign's own ~
        directory is never the finalizer's subject)"
  (lambda ()
    (ensure-directories-exist (work "deletion-workspace/"))
    (and (eql 0 (shell "cp" "-a" *campaign-exec* *ws*))
         (probe-file (concatenate 'string *ws* "/store/EVENTS.pj0")))))

(check "16 the finalizer runs over the workspace copy and writes its four ~
        derived artifacts"
  (lambda ()
    (multiple-value-bind (code text)
        (run-child (concatenate 'string *lane* "reconstruction/finalizer.lisp")
                   (list *ws*))
      (and (eql 0 code)
           (search "RESULT: FINALIZED" text)
           (every (lambda (relative)
                    (probe-file (concatenate 'string *ws* "/" relative)))
                  (lisp-plus-vertical0-finalizer:derived-relative-paths))))))

(defparameter *pre-deletion-out* (work "pre-deletion.pjs"))

(check "17 with the finalizer's outputs PRESENT, a fresh reconstruction ~
        child over the workspace equals the official census byte for byte"
  (lambda ()
    (multiple-value-bind (code text)
        (run-child (concatenate 'string *lane*
                                "reconstruction/reconstruct-census.lisp")
                   (list *ws* *pre-deletion-out*))
      (and (eql 0 code)
           (search "RESULT: OFFICIAL-STATE-DERIVED" text)
           (octets-equal *official-octets*
                         (slurp-octets *pre-deletion-out*))))))

(check "18 the finalizer's outputs are PRESERVED before deletion (the ~
        proof discards them from the run, not from the record)"
  (lambda ()
    (ensure-directories-exist (work "preserved/"))
    (and (eql 0 (shell "cp" "-a" (concatenate 'string *ws* "/derived")
                       (work "preserved/derived")))
         (probe-file (work "preserved/derived/INDEX.md"))
         (probe-file (work "preserved/derived/SHA256SUMS"))
         (probe-file (work "preserved/derived/SUMMARY.md"))
         (probe-file (work "preserved/derived/export-bundle.pjs")))))

(check "19 EVERY derived index / summary / export is DELETED from the ~
        workspace — the finalizer's derived/, and the campaign's own ~
        export/ and mirror-sim/ bundles with it"
  (lambda ()
    (dolist (relative '("derived" "export" "mirror-sim"))
      (shell "rm" "-rf" (concatenate 'string *ws* "/" relative)))
    (notany (lambda (relative)
              (probe-file (concatenate 'string *ws* "/" relative "/")))
            '("derived" "export" "mirror-sim"))))

(check "20 only PRIMARY evidence is retained: the journal, the captured ~
        evidence files, the public config (and the class-A/B world state)"
  (lambda ()
    (and (probe-file (concatenate 'string *ws* "/store/EVENTS.pj0"))
         (probe-file (concatenate 'string *ws* "/store/JOURNAL-META.pjs"))
         (probe-file (concatenate 'string *ws*
                                  "/VERTICAL-PROGRAM-CONFIG.sexp"))
         (probe-file (concatenate 'string *ws*
                                  "/evidence/seat-sealed-letter-envelope.bin"))
         (probe-file (concatenate 'string *ws* "/world/CELLS.txt"))
         (probe-file (concatenate 'string *ws*
                                  "/fake-world/provider-domain.sexp"))
         (null (probe-file (concatenate 'string *ws*
                                        "/export/campaign-export.sexp"))))))

(defparameter *post-deletion-out* (work "post-deletion.pjs"))

(check "21 THE PROOF: a fresh child that never loads the finalizer module ~
        reconstructs the census from what is left, byte-identical to the ~
        pre-deletion official state"
  (lambda ()
    (multiple-value-bind (code text)
        (run-child (concatenate 'string *lane*
                                "reconstruction/reconstruct-census.lisp")
                   (list *ws* *post-deletion-out*))
      (and (eql 0 code)
           (search "RESULT: OFFICIAL-STATE-DERIVED" text)
           (octets-equal *official-octets*
                         (slurp-octets *post-deletion-out*))))))

(check "22 TEETH: the deletion proof is sensitive to what actually ~
        matters — remove a PRIMARY journal and reconstruction refuses"
  (lambda ()
    (let ((scratch (work "deletion-workspace/scratch")))
      (shell "rm" "-rf" scratch)
      (shell "cp" "-a" *ws* scratch)
      (shell "rm" "-f" (concatenate 'string scratch "/store/EVENTS.pj0"))
      (multiple-value-bind (code text)
          (run-child (concatenate 'string *lane*
                                  "reconstruction/reconstruct-census.lisp")
                     (list scratch (work "must-not-exist-2.pjs")))
        (and (not (eql 0 code))
             (not (search "RESULT:" text))
             (not (probe-file (work "must-not-exist-2.pjs"))))))))

;;; ===========================================================================
(note "~%== H. the NAMED-CELL localization tooth (in-process diagnostic) ==")

(defparameter *tooth-ws* (work "tooth-workspace/exec"))

(check "23 the finalizer, run IN THIS PROCESS over a workspace copy, ~
        populates all three named cells"
  (lambda ()
    (ensure-directories-exist (work "tooth-workspace/"))
    (shell "cp" "-a" *campaign-exec* *tooth-ws*)
    (lisp-plus-vertical0-finalizer:finalize-run *tooth-ws*)
    (and (boundp 'lisp-plus-vertical0-finalizer:*finalizer-index-cache*)
         (boundp 'lisp-plus-vertical0-finalizer:*finalizer-summary-cache*)
         (boundp 'lisp-plus-vertical0-finalizer:*finalizer-export-cache*)
         lisp-plus-vertical0-finalizer:*finalizer-index-cache*
         lisp-plus-vertical0-finalizer:*finalizer-summary-cache*
         lisp-plus-vertical0-finalizer:*finalizer-export-cache*
         t)))

(check "24 all three cells are MAKUNBOUND"
  (lambda ()
    (makunbound 'lisp-plus-vertical0-finalizer:*finalizer-index-cache*)
    (makunbound 'lisp-plus-vertical0-finalizer:*finalizer-summary-cache*)
    (makunbound 'lisp-plus-vertical0-finalizer:*finalizer-export-cache*)
    (notany #'boundp
            '(lisp-plus-vertical0-finalizer:*finalizer-index-cache*
              lisp-plus-vertical0-finalizer:*finalizer-summary-cache*
              lisp-plus-vertical0-finalizer:*finalizer-export-cache*))))

(check "25 with the cells unbound, the reconstruction procedure run ~
        IN-PROCESS completes unaffected and returns the official bytes"
  (lambda ()
    (sb-posix:putenv "VERTICAL0_RECONSTRUCT_DIAGNOSTIC_TOOTH=1")
    (unwind-protect
         (octets-equal *official-octets*
                       (vertical0-reconstruct:official-state-octets
                        *campaign-exec*))
      (sb-posix:unsetenv "VERTICAL0_RECONSTRUCT_DIAGNOSTIC_TOOTH"))))

(check "26 TEETH: a deliberately-dependent probe closure reading one of ~
        those cells signals UNBOUND-VARIABLE whose CELL-ERROR-NAME is the ~
        finalizer-only symbol *FINALIZER-INDEX-CACHE*"
  (lambda ()
    ;; NB — caught while building this gate, and worth the sentence: a
    ;; special-variable read whose value is DISCARDED is flushable, and
    ;; SBCL flushes it.  The first two drafts of this tooth ((progn (funcall
    ;; probe) nil), then (format nil "~a" (funcall probe))) never signalled
    ;; anything, because the read was deleted before it could.  The value
    ;; must land somewhere the compiler must preserve — a global special —
    ;; or the tooth has no teeth and reports success.
    (let ((probe (lambda ()
                   lisp-plus-vertical0-finalizer:*finalizer-index-cache*)))
      (handler-case (progn (setf *leak-sink* (funcall probe)) nil)
        (unbound-variable (condition)
          (and (eq (cell-error-name condition)
                   'lisp-plus-vertical0-finalizer:*finalizer-index-cache*)
               (eq (symbol-package (cell-error-name condition))
                   (find-package '#:lisp-plus-vertical0-finalizer))))))))

(check "27 TEETH: the same holds for the summary and export cells ~
        (each names itself, so a leak could be localized)"
  (lambda ()
    (flet ((names-itself-p (thunk symbol)
             (handler-case (progn (setf *leak-sink* (funcall thunk)) nil)
               (unbound-variable (condition)
                 (eq (cell-error-name condition) symbol)))))
      (and (names-itself-p
            (lambda () lisp-plus-vertical0-finalizer:*finalizer-summary-cache*)
            'lisp-plus-vertical0-finalizer:*finalizer-summary-cache*)
           (names-itself-p
            (lambda () lisp-plus-vertical0-finalizer:*finalizer-export-cache*)
            'lisp-plus-vertical0-finalizer:*finalizer-export-cache*)))))

;;; ===========================================================================
(note "~%== I. the FINALIZER-ONLY-FACT mutant ==")

(defparameter *plant-ws* (work "plant-workspace/exec"))
(defparameter *phantom* (lisp-plus-vertical0-finalizer:phantom-seat-name))

(check "28 the planted mutant is LIVE: a finalizer run with the plant ~
        enabled writes a fabricated seat into its derived artifacts"
  (lambda ()
    (ensure-directories-exist (work "plant-workspace/"))
    (shell "cp" "-a" *campaign-exec* *plant-ws*)
    (multiple-value-bind (code text)
        (run-child (concatenate 'string *lane* "reconstruction/finalizer.lisp")
                   (list *plant-ws*)
                   :environment (child-environment
                                 "VERTICAL0_FINALIZER_PLANT_FACT=1"))
      (and (eql 0 code)
           (search "RESULT: FINALIZED" text)
           (search *phantom* (slurp-text (concatenate 'string *plant-ws*
                                                      "/derived/INDEX.md")))
           (search *phantom* (slurp-text (concatenate 'string *plant-ws*
                                                      "/derived/SUMMARY.md")))
           (search *phantom*
                   (map 'string #'code-char
                        (slurp-octets (concatenate
                                       'string *plant-ws*
                                       "/derived/export-bundle.pjs"))))))))

(check "29 THE KILL: a fresh reconstruction over the same workspace does ~
        NOT contain the finalizer-only fact anywhere in its canonical bytes"
  (lambda ()
    (multiple-value-bind (code text)
        (run-child (concatenate 'string *lane*
                                "reconstruction/reconstruct-census.lisp")
                   (list *plant-ws* (work "planted.pjs")))
      (declare (ignore text))
      (and (eql 0 code)
           (let ((octets (slurp-octets (work "planted.pjs"))))
             (and (not (search *phantom* (map 'string #'code-char octets)))
                  (octets-equal *official-octets* octets)))))))

(check "30 the planted fact is also absent from the derived outcome map ~
        (13 seats would be a finalizer-authored primary fact; 12 is the ~
        journal's own answer)"
  (lambda ()
    (let ((map (outcome-map (decode-state (slurp-octets (work "planted.pjs"))))))
      (and (= 12 (length map))
           (notany (lambda (row) (equal (first row) *phantom*)) map)))))

;;; ===========================================================================
(note "~%== J. the completed campaign was not mutated by any of this ==")

(check "31 runs/campaign-1/exec is byte-for-byte what it was before the ~
        gate ran: every reconstruction is read-only over durable evidence"
  (lambda ()
    (equal *exec-digest-before* (tree-manifest-digest *campaign-exec*))))

;;; ===========================================================================

(multiple-value-bind (manifest files) (tree-manifest-digest *campaign-exec*)
  (note "~%campaign-1/exec: ~a primary file~:p, tree manifest ~a"
        files manifest))
(note "official state:  ~a canonical octets, sha256 ~a"
      (length *official-octets*) (digest *official-octets*))
(note "independent replay: sha256 ~a" (digest *replay-octets*))
(note "post-deletion reconstruction: sha256 ~a"
      (digest (slurp-octets *post-deletion-out*)))

(format t "~%run-reconstruction-gate: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
