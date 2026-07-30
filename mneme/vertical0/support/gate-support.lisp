;;;; gate-support.lisp — shared machinery for the two DENTIST gates
;;;; (mutants/run-mutation-gate.lisp and
;;;; controls/run-integration-controls.lisp).
;;;;
;;;; It loads, in this order and by these means:
;;;;   support/forms-loader.lisp   (CL:LOAD)
;;;;   program/load.lisp           (CL:LOAD — the real library)
;;;;   program/campaign.lisp       (definitions only; entry form skipped)
;;;;   harness/harness.lisp        (definitions only — the REAL spawner,
;;;;                                /proc blocked-state sampler, corpse
;;;;                                snapshotter and journal readers are
;;;;                                reused, never re-implemented)
;;;;   harness/witness.lisp        (definitions only, into CL-USER — the
;;;;                                REAL strace parser and durability
;;;;                                checkers are reused read-only)
;;;;   program/defects.lisp        (the planted-defect registry, LAST, so
;;;;                                every replacement closes over the real
;;;;                                original)
;;;;
;;;; DETERMINISM.  Nothing here prints a pid, a wall clock, a temporary
;;;; name, or a raw child line.  Child stdout is captured and queried, never
;;;; relayed: it contains CHILD-PID.  Every gate transcript must be
;;;; byte-identical across two runs; that is checked by the twin-run pair.
;;;;
;;;; SCRATCH ONLY.  Every directory this file creates lives under
;;;; mneme/vertical0/runs/scratch-*/.  runs/campaign-1, runs/control-a and
;;;; runs/control-b are PRESERVED EVIDENCE and are opened read-only (and
;;;; only ever via a copy).
;;;;
;;;; — DENTIST (Claude Fable 5 subagent), 2026-07-30

(in-package #:cl-user)

(defvar *gate-vertical0-root*
  (merge-pathnames "../" (make-pathname :name nil :type nil
                                        :defaults *load-truename*)))

(defun gate-path (relative) (merge-pathnames relative *gate-vertical0-root*))

;; The whole substrate load chatters ("kernel0 ... smoke: PASS"); swallow it
;; so a gate transcript begins with the gate.
(let ((*standard-output* (make-broadcast-stream))
      (*error-output* (make-broadcast-stream)))
  (load (gate-path "program/load.lisp"))
  (load-definitions (gate-path "program/campaign.lisp")
                    :package (find-package '#:lisp-plus-vertical0))
  (load-definitions (gate-path "harness/harness.lisp")
                    :package (find-package '#:lisp-plus-vertical0))
  (load-definitions (gate-path "harness/witness.lisp")
                    :package (find-package '#:cl-user))
  (load (gate-path "program/defects.lisp")))

(in-package #:lisp-plus-vertical0)

;;; ---------------------------------------------------------------------------
;;; Verdict machinery (live counters; nothing ceremonial).

(defvar *gate-checks* 0)
(defvar *gate-failures* 0)
(defvar *omission-killed* 0)
(defvar *omission-total* 0)
(defvar *addition-killed* 0)
(defvar *addition-total* 0)
(defvar *controls-passed* 0)
(defvar *controls-total* 0)

(defun gnote (control &rest arguments)
  (apply #'format t control arguments)
  (terpri)
  (finish-output))

(defun gcheck (prefix description thunk)
  "Run THUNK; print one verdict line.  Returns T on pass.  Only the
condition TYPE is reported on an error — reports may carry paths."
  (incf *gate-checks*)
  (let ((description (format nil description))   ; fold source continuations
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error (type-of condition))))))
    (cond ((eq outcome :ok)
           (format t "[~a~3,'0d] ok   ~a~%" prefix *gate-checks* description)
           (finish-output)
           t)
          (t
           (incf *gate-failures*)
           (format t "[~a~3,'0d] FAIL ~a~@[ (errored: ~a)~]~%" prefix
                   *gate-checks* description
                   (when (consp outcome) (second outcome)))
           (finish-output)
           nil))))

;;; ---------------------------------------------------------------------------
;;; Deterministic mini-configuration emitter.
;;;
;;; A mini campaign is a real campaign with a small bank.  The emitted text
;;; is a pure function of its arguments — same bytes every run.

(defun %seat-text (seat)
  (destructuring-bind (&key id route shape estimate cell control-policy) seat
    (format nil "   (:seat ~s :route ~a~%    :shape ~a :estimate-lexeme ~a ~
                 :cell ~s~@[~%    :control-policy ~a~])"
            id
            (string-downcase (format nil ":~a" (symbol-name route)))
            (if shape (format nil "~s" shape) "nil")
            (if estimate (format nil "~s" estimate) "nil")
            cell
            (when control-policy
              (string-downcase (format nil ":~a"
                                       (symbol-name control-policy)))))))

(defun %pause-text (route-pauses)
  (if (null route-pauses)
      "()"
      (format nil "(~{~a~^~%     ~})"
              (mapcar (lambda (entry)
                        (format nil "(:route ~a :pauses (~{~s~^ ~}))"
                                (string-downcase
                                 (format nil ":~a" (symbol-name (first entry))))
                                (rest entry)))
                      route-pauses))))

(defun mini-config (&key seats order route-pauses revoked request-loss
                         (ceiling "5/1") (durability "synced")
                         (nonce "vertical-de-morte") secret publication
                         (chunk-count 2))
  "The text of a program-lawful mini configuration.  Deterministic."
  (with-output-to-string (out)
    (format out ";;;; scratch mini configuration — DENTIST gate fixture.~%")
    (format out "(:vertical-program-config~%")
    (format out " (:config-version \"vertical-config-0-mini\")~%")
    (format out " (:declared-versions~%  (:adapter ~
                 \"adapter0-through-erratum-0.1\"~%   :cost-procedure ~
                 \"fake-cost-procedure-1\"~%   :recovery-projection ~
                 \"vertical-recovery-projection-0\"~%   :interpretation ~
                 \"vertical-interpretation-0\"~%   :census ~
                 \"vertical-census-0\"))~%")
    (format out " (:adapter~%  (:descriptor-identity \"fake-reference-0\"~%~
                 ~4t:usage-procedure \"fake-usage-procedure-0\"~%~
                 ~4t:cost-procedure \"fake-cost-procedure-1\"~%~
                 ~4t:price-schedule \"fake-prices-v0\"))~%")
    (format out " (:authority~%  (:bootstrap-issuer \"auctor-primus\"~%~
                 ~4t:subject (\"subject\" \"machina\")~%~
                 ~4t:action (\"action\" \"loqui\")~%~
                 ~4t:scope (\"scope\" \"semel\")~%~
                 ~4t:revoked-seats (~{~s~^ ~})))~%" revoked)
    (format out " (:budget (:ceiling-lexeme ~s))~%" ceiling)
    (format out " (:bank~%  (~%~{~a~^~%~}))~%"
            (mapcar #'%seat-text seats))
    (format out " (:policy~%  (:seat-order (~{~s~^ ~})~%~
                 ~3t:route-pauses ~a~%~
                 ~3t:partial-stream-resumption :refused~%~
                 ~3t:request-loss-simulated-seats (~{~s~^ ~})~%~
                 ~3t:torn-crossing-policy :leave-unresolved~%~
                 ~3t:stream-chunk-count ~a~%~
                 ~3t:journal-declared-durability ~s~%~
                 ~3t:journal-nonce ~s))"
            order (%pause-text route-pauses) request-loss chunk-count
            durability nonce)
    (when secret
      (format out "~% (:secret~%  (:rubric-id \"rubrum-mini-0\"~%~
                   ~3t:rubric-body \"SYNTHETIC-NOT-A-REAL-SECRET\"~%~
                   ~3t:opening-action (\"action\" \"aperire\")~%~
                   ~3t:exposed-principals (\"principalis-unus\")~%~
                   ~3t:exposure-scope \"gate-graders\"))"))
    (when publication
      (format out "~% (:publication~%  (:staging-artifact ~
                   \"export/campaign-export.sexp\"~%~
                   ~3t:publication-action (\"action\" \"publicare\")~%~
                   ~3t:mirror-destination \"mirror-sim/\"~%~
                   ~3t:mirror-cell \"cella-speculi\"~%~
                   ~3t:channel-policy \"test-channel-only-no-real-mirror\"))"))
    (format out ")~%")))

;;; ---------------------------------------------------------------------------
;;; Child driving.

(defstruct mini-life
  exit-code killed-p eof-p lines boundaries condition-type child-error)

(defun %line-prefix-p (prefix line)
  (and (>= (length line) (length prefix))
       (string= prefix line :end2 (length prefix))))

(defun mini-life-boundary-count (result boundary)
  (count boundary (mini-life-boundaries result)
         :key #'second :test #'equal))

(defun defects-environment (defects)
  (cons (format nil "VERTICAL0_DEFECTS=~{~a~^,~}"
                (mapcar (lambda (name) (string-downcase (symbol-name name)))
                        defects))
        (sb-ext:posix-environ)))

(defun run-mini-life (exec-dir &key defects trace-path (policy nil)
                                    (program :mutant) (life 1))
  "Spawn ONE life of the mini campaign over EXEC-DIR.

PROGRAM is :MUTANT (mutants/mutant-child.lisp, the real campaign plus any
installed defects) or :REAL (program/campaign.lisp verbatim).
POLICY, when given, is called with (LIFE SEAT BOUNDARY OCCURRENCE) at every
BOUNDARY-READY and answers :CONTINUE, :EOF (close the wait pipe: the child
refuses the pause and stops WITHOUT further semantic work) or :KILL (confirm
the blocked pipe read via the harness's own /proc sampler, then SIGKILL).
Nothing about this decision ever reaches the child."
  (let* ((script (ecase program
                   (:mutant "mneme/vertical0/mutants/mutant-child.lisp")
                   (:real "mneme/vertical0/program/campaign.lisp")))
         (arguments (if trace-path
                        (list "-f" "-s" "256" "-o" (namestring trace-path)
                              "-e" +strace-set+
                              "--" "sbcl" "--script" script
                              (namestring exec-dir))
                        (list "--script" script (namestring exec-dir))))
         (process (sb-ext:run-program (if trace-path "strace" "sbcl")
                                      arguments
                                      :search t :wait nil
                                      :input :stream :output :stream
                                      :error :output
                                      :environment (defects-environment
                                                       defects)))
         (output (sb-ext:process-output process))
         (input (sb-ext:process-input process))
         (pid nil) (killed nil) (eofed nil) (occurrences 0)
         (lines '()) (boundaries '())
         (condition-type nil) (child-error nil))
    (loop for line = (read-line output nil nil)
          while line
          do (push line lines)
             (cond
               ((%line-prefix-p "CHILD-PID " line)
                (setf pid (parse-integer (subseq line 10))))
               ((%line-prefix-p "CHILD-CONDITION " line)
                (setf condition-type (string-trim " " (subseq line 16))))
               ((%line-prefix-p "CHILD-ERROR " line)
                (setf child-error (subseq line 12)))
               ((%line-prefix-p "BOUNDARY-READY" line)
                (multiple-value-bind (seat boundary) (parse-ready-line line)
                  (incf occurrences)
                  (push (list seat boundary occurrences) boundaries)
                  (ecase (if policy
                             (funcall policy life seat boundary occurrences)
                             :continue)
                    (:continue (write-line "CONTINUE" input)
                               (finish-output input))
                    (:eof (setf eofed t) (close input))
                    (:kill
                     (let ((proof (wait-until-blocked-on-pipe pid)))
                       (unless proof
                         (error "mini child never reached the blocked ~
                                 pipe-read state"))
                       (setf killed t)
                       (sb-posix:kill pid 9))))))
               (t nil)))
    (sb-ext:process-wait process)
    (make-mini-life :exit-code (sb-ext:process-exit-code process)
                    :killed-p killed :eof-p eofed
                    :lines (nreverse lines)
                    :boundaries (nreverse boundaries)
                    :condition-type condition-type
                    :child-error child-error)))

(defun setup-mini-exec (exec-dir config-text)
  (setup-exec-dir exec-dir config-text))

(defun run-mini-campaign (root config-text
                          &key defects (max-lives 4) policy trace-directory
                               (program :mutant))
  "Fresh scratch ROOT, then lives until exit 0 or a life ends unexpectedly.
Returns the list of MINI-LIFE results, oldest first."
  (let ((exec-dir (merge-pathnames "exec/" root))
        (results '()))
    (fresh-directory root)
    (setup-mini-exec exec-dir config-text)
    (loop for life from 1 to max-lives
          do (let ((result (run-mini-life
                            exec-dir
                            :defects defects
                            :policy policy
                            :program program
                            :life life
                            :trace-path
                            (when trace-directory
                              (merge-pathnames (format nil "trace-life~a.txt"
                                                       life)
                                               trace-directory)))))
               (push result results)
               ;; A per-life journal snapshot: the absence proofs (an
               ;; untouched seat is untouched) need the bytes as they stood
               ;; between lives, not only at the end.
               (let ((octets (read-octet-file
                              (merge-pathnames "store/EVENTS.pj0" exec-dir))))
                 (when octets
                   (write-evidence-file
                    (merge-pathnames (format nil "snapshot-life~a.pj0" life)
                                     root)
                    octets)))
               (when (and (not (mini-life-killed-p result))
                          (not (mini-life-eof-p result)))
                 (return))))
    (nreverse results)))

(defun snapshot-events (root life)
  "The events of ROOT's between-lives snapshot after LIFE, or NIL."
  (let ((path (merge-pathnames (format nil "snapshot-life~a.pj0" life) root))
        (store-dir (merge-pathnames "exec/store/" root)))
    (when (probe-file path)
      ;; Read the snapshot through a throwaway store directory so the
      ;; strict reader validates it exactly as journal0 would.
      (let ((scratch (merge-pathnames (format nil "snapshot-store-~a/" life)
                                      root)))
        (fresh-directory scratch)
        (dolist (name '("JOURNAL-META.pjs" "JOURNAL-META.pjs.sha256"))
          (write-evidence-file
           (merge-pathnames name scratch)
           (read-octet-file (merge-pathnames name store-dir))))
        (write-evidence-file (merge-pathnames "EVENTS.pj0" scratch)
                             (read-octet-file path))
        (store-events scratch)))))

(defun last-life (results) (first (last results)))

(defun mini-store-events (root)
  "(values events store) over a finished mini campaign's journal."
  (store-events (merge-pathnames "exec/store/" root)))

(defun mini-store-present-p (root)
  (and (probe-file (merge-pathnames "exec/store/JOURNAL-META.pjs" root)) t))

;;; ---------------------------------------------------------------------------
;;; Standard mini banks used by both gates.

(defparameter +bank-full-clean+
  '((:id "seat-alpha" :route :full-clean :shape "nonempty"
     :estimate "100/1000000" :cell "cella-alpha")))

(defparameter +bank-two-clean+
  '((:id "seat-alpha" :route :full-clean :shape "nonempty"
     :estimate "100/1000000" :cell "cella-alpha")
    (:id "seat-beta" :route :full-clean :shape "nonempty"
     :estimate "100/1000000" :cell "cella-beta")))

(defparameter +bank-frontier+
  '((:id "seat-torn" :route :frontier-only :shape nil
     :estimate "200/1000000" :cell "cella-scissa")))

(defparameter +bank-control+
  '((:id "seat-control" :route :frontier-only :shape nil
     :estimate "100/1000000" :cell "cella-controlata"
     :control-policy :disposition-then-reconcile)))

(defparameter +bank-revoked+
  '((:id "seat-dead" :route :refused-authority :shape nil
     :estimate "100/1000000" :cell "cella-mortua")))

(defparameter +bank-stream+
  '((:id "seat-song" :route :streaming :shape "partial"
     :estimate "300/1000000" :cell "cella-dimidia")))

(defparameter +bank-founded+
  '((:id "seat-alpha" :route :full-clean :shape "nonempty"
     :estimate "100/1000000" :cell "cella-alpha")
    (:id "seat-song" :route :streaming :shape "partial"
     :estimate "300/1000000" :cell "cella-dimidia")
    (:id "seat-sealed" :route :envelope-then-recover :shape "nonempty"
     :estimate "400/1000000" :cell "cella-sigillata")
    (:id "seat-slammed" :route :interrupted-then-reconcile :shape nil
     :estimate "500/1000000" :cell "cella-clausa-post"))
  "The founded-progress bank: one clean route (fresh authority · budget ·
dispatch · projection · consumption · settled execution), one streaming
route (journaled partial chunk), one envelope route whose life 1 stops at
ENVELOPE-CUSTODY-COMMITTED so life 2 must project from captured bytes, and
one post-frontier failure that must reconcile against surviving world
evidence.  Seat-slammed is untouched until life 2 — the untouched-seat-
resumed-after-restart obligation.")

(defun config-founded (&key (durability "synced"))
  (mini-config :seats +bank-founded+
               :order '("seat-alpha" "seat-song" "seat-sealed"
                        "seat-slammed")
               :route-pauses '((:streaming "STREAM-CHUNK-CUSTODY-COMMITTED")
                               (:envelope-then-recover
                                "ENVELOPE-CUSTODY-COMMITTED"
                                "PROJECTION-COMMITTED"))
               :request-loss '("seat-slammed")
               :durability durability))

(defun founded-policy (life seat boundary occurrence)
  "Life 1 stops at the stream chunk-custody boundary, life 2 at the
envelope-custody boundary (EOF each time: the child refuses the pause and
performs NO further semantic work).  Life 3 runs to completion.  So the
founded baseline crosses two restarts, exactly as the founded-progress
matrix's restart rows require."
  (declare (ignore seat occurrence))
  (cond ((and (= life 1) (equal boundary "STREAM-CHUNK-CUSTODY-COMMITTED"))
         :eof)
        ((and (= life 2) (equal boundary "ENVELOPE-CUSTODY-COMMITTED"))
         :eof)
        (t :continue)))

;;; ---------------------------------------------------------------------------
;;; In-process boot.
;;;
;;; The campaign's own prologue (campaign-main's first half), run in THIS
;;; process over a fresh scratch execution directory, using the program's
;;; own functions in the program's own order.  It exists so a control can
;;; trigger a REAL predecessor condition through the vertical's own
;;; composition (mint-seat-key / authorize-seat / cross-frontier / the AP0
;;; operation surface) instead of a hand-rolled imitation.

(defun boot-in-process (root config-text &key (context-label "vertical-gate"))
  (fresh-directory root)
  (let ((exec (merge-pathnames "exec/" root)))
    (setup-mini-exec exec config-text)
    (setf *exec-dir* exec)
    (setf *config* (read-vertical-config
                    (exec-path "VERTICAL-PROGRAM-CONFIG.sexp")))
    (setf *ceiling* (parse-lexeme-rational
                     (getf (%plist-section *config* :budget) :ceiling-lexeme)))
    (setf *store-existed* nil)
    (setf *store* (create-journal
                   (exec-path "store/")
                   :declared-durability (config-durability *config*)
                   :nonce-octets (config-nonce-octets *config*)))
    (setf *world* (make-world (exec-path "world/") (declared-world-cells)))
    (setf *bootstrap* (declare-bootstrap-authority
                       (list "issuer" (getf (authority-config)
                                            :bootstrap-issuer))
                       (expected-store-id)))
    (setf *context* (make-minting-context :label context-label))
    (journal-opening-authority)
    exec))

(defun seat-by-id (seat-id)
  (find seat-id (config-bank *config*)
        :key (lambda (plist) (seat-field plist :seat)) :test #'equal))

(defmacro signals-exactly (type &body body)
  "T iff BODY signals a condition of exactly TYPE (subtype test)."
  `(handler-case (progn ,@body nil)
     (,type () t)
     (error () nil)))
