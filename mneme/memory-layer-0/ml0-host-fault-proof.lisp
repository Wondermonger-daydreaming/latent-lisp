;;;; ml0-host-fault-proof.lisp — Memory Layer /0: A HOST FAULT MAY NOT WEAR A
;;;; SEMANTIC REFUSAL'S CLOTHES.
;;;;
;;;;   sbcl --script mneme/memory-layer-0/ml0-host-fault-proof.lisp
;;;;
;;;; Sentinel: ml0-host-fault-proof: PASS
;;;;
;;;; ⚑ THE INHERITED FINDING THIS PAYS, and it is not this lane's to relearn.
;;;; Before 2026-08-20 One Act /1's dispatch caught `(error (c))` — the whole
;;;; Common Lisp error hierarchy — behind prose that said "every typed condition
;;;; from D1 or D2".  An unexpected implementation error raised before any
;;;; attempt frame landed left the derived standing :absent, so the handler
;;;; converted it into an ordinary pre-frontier refusal, and the lane
;;;; MANUFACTURED a refused Outcome AND a fresh Core /0 evidence account for a
;;;; TYPE-ERROR.  The journal and world were clean; the defect was in the
;;;; CLASSIFICATION.  (language-act-1/RED-PROOF-HOST-FAULT-BEFORE.txt.)
;;;;
;;;; That finding is the reason this lane exists at all, and it is also a warning
;;;; about this lane's OWN handlers.  `ml0-through` enumerates admitted condition
;;;; families BY ROOT — each root read out of that lane's own package.lisp — and
;;;; routes everything else to a typed `ml0-bridge-contract-violated` with NO
;;;; account, NO standing and NO discriminant written.
;;;;
;;;; ⚠ THE GATE IS TWO-HALVED, and the second half is the one that is easy to
;;;; skip.  A gate that answered "bridge violation" to EVERYTHING would pass the
;;;; first half perfectly and would have destroyed the lane's ability to tell a
;;;; lawful refusal from a bug.  So half (b) drives a LAWFUL refusal from an
;;;; ADMITTED family through the same door and requires it to arrive AS ITSELF.
;;;;
;;;; CANDIDATE.  Nothing here is adopted, and nothing here is independent
;;;; verification.
;;;;
;;;; — TABULARIUS (Claude Opus 5, subagent), 2026-08-20

(require :sb-posix)

(load (merge-pathnames "ml0-suite-ground.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-memory-layer0)

(defvar *host-fault-probe* "not a list"
  "⚠ THE PROBE LIVES IN A GLOBAL ON PURPOSE.  SBCL derives the type of a literal
— and of `(format nil ...)` — precisely enough to turn `(car x)` into a
COMPILE-TIME WARNING instead of a RUN-TIME FAULT, and a warning is not a host
fault: it would leave this gate testing nothing while looking green.  A special
variable's value is opaque to the compiler, so the slip happens where it must.
(The lab has been bitten by the mirror of this rule before — SBCL elides a
DISCARDED special-var read — so note that this value is USED, as CAR's argument,
and cannot be optimized away.)")

(defparameter *lane-directory*
  (make-pathname :name nil :type nil :defaults *load-truename*))
(defparameter *subject-root* (merge-pathnames "../../" *lane-directory*))

(defvar *unadmitted-refused* nil)
(defvar *unadmitted-through-the-door* nil)
(defvar *admitted-arrived-as-itself* nil)
(defvar *admitted-through-the-door* nil)
(defvar *state-clean* nil)
(defvar *no-account-written* nil)

(format t "~&Memory Layer /0 — HOST-FAULT PROOF.  CANDIDATE; nothing here is ~
adopted, and nothing here is independent verification.~%~%")

(unless (ml0-env-preflight :signal nil)
  (format t "~&ml0-host-fault-proof: VOID — a process-ending switch is set.~%")
  (sb-ext:exit :code 4))
(terpri)

(defvar *root* (ml0-fresh-run-root "ml0-hostfault" *subject-root*))

;;; ⚠ THE RUN'S VARIABLES ARE DECLARED AT TOP LEVEL AND ASSIGNED BELOW.
;;; `defparameter` INSIDE the unwind-protect would be one top-level form,
;;; so every later reference in that form compiles against an undefined
;;; variable and SBCL warns — and a gate whose own transcript is full of
;;; compiler noise is a gate nobody reads.
(defvar *settled* nil)
(defvar *settled-id* nil)
(defvar *world-src* nil)
(defvar *before* nil)
(defvar *accounts-before* nil)
(defvar *after* nil)

(unwind-protect
     (progn
       (ml0-ground *root*)
       (setf *settled* (ml0-settled-row))
       (setf lisp-plus-language-act1:*act1-fixture-table* (list *settled*))
       (ml0-open-authority (list *settled*))
       (lisp-plus-language-act1:run-act1 *settled* :verbose nil)
       (setf *settled-id* (nth-value 0 (ml0-rederive-act-identity *settled*)))
       (setf *world-src* (ml0-world-source *settled-id* "a-prima"))

       (setf *before* (ml0-take-store-scope *ml0-account-root*))
       (setf *accounts-before*
         (length (ml0-list-account-ids *ml0-account-store*)))

       ;; ---- HALF (a).  An unadmitted host fault, twice: raised inside
       ;; ---- `ml0-through` directly, and raised through the REAL Write door.
       (format t "~&---- half (a): the unadmitted host fault ----~%")

       (setf *unadmitted-refused*
             (handler-case (progn (ml0-through "a deliberate host fault"
                                               (lambda ()
                                                ;; a GENUINE implementation slip:
                                                ;; CAR of a string, taken at RUN
                                                ;; time from an opaque global.
                                                (car *host-fault-probe*)))
                                  nil)
               (ml0-bridge-contract-violated (c)
                 (format t "  direct  : ~a [~a]~%" (type-of c)
                         (ml0-condition-requirement-id c))
                 (equal "ML0-BRIDGE-2" (ml0-condition-requirement-id c)))
               (error (c) (format t "  direct  : WRONG TYPE ~a~%" (type-of c)) nil)))

       (setf *unadmitted-through-the-door*
             (handler-case
                 (progn (ml0-write *ml0-account-store*
                                   (make-ml0-bundle
                                    :fixture-row :not-a-fixture-row
                                    :claimed-act-id nil
                                    :subject-principal *suite-actor*
                                    :sources (list *world-src*)))
                        nil)
               (ml0-bridge-contract-violated (c)
                 (format t "  ml0-write: ~a [~a]~%" (type-of c)
                         (ml0-condition-requirement-id c))
                 (equal "ML0-BRIDGE-2" (ml0-condition-requirement-id c)))
               (error (c) (format t "  ml0-write: WRONG TYPE ~a~%" (type-of c)) nil)))

       ;; ---- HALF (b).  A LAWFUL refusal from an ADMITTED family must arrive AS
       ;; ---- ITSELF.  This is the half a blanket refusal fails.
       (format t "~&---- half (b): an admitted family's lawful refusal ----~%")

       (setf *admitted-arrived-as-itself*
             (handler-case
                 (progn (ml0-through
                         "an admitted lawful refusal"
                         (lambda ()
                           (lisp-plus-language-act1:make-act1-fixture-row
                            :arm "BAD" :label "x" :runtime-seat "x"
                            :attempt-name "wrong-shape"
                            :cell-segments '("cella" "prima")
                            :adapter-symbol 'ml0-hostfault/bad
                            :form (lisp-plus-language-act1:act1-request-form
                                   "cella:prima" "t"))))
                        nil)
               (lisp-plus-language-act1:act1-condition (c)
                 (format t "  direct  : ~a [~a]  <- the ACT LANE'S own condition, unchanged~%"
                         (type-of c)
                         (lisp-plus-language-act1:act1-condition-requirement-id c))
                 (equal "ACT1-FX-3"
                        (lisp-plus-language-act1:act1-condition-requirement-id c)))
               (ml0-condition (c)
                 (format t "  direct  : RECLASSIFIED to ~a — the gate is a blanket~%"
                         (type-of c))
                 nil)))

       (setf *admitted-through-the-door*
             (handler-case
                 (progn (ml0-write *ml0-account-store*
                                   (make-ml0-bundle
                                    :fixture-row (ml0-settled-row
                                                  :seat "quinta" :attempt "a-quinta"
                                                  :text " leading space"
                                                  :symbol 'ml0-hostfault/lexis)
                                    :claimed-act-id nil
                                    :subject-principal *suite-actor*
                                    :sources (list *world-src*)))
                        nil)
               (lisp-plus-language-act1:act1-request-lexis-refused (c)
                 (format t "  ml0-write: ~a [~a]  <- propagated unchanged~%"
                         (type-of c)
                         (lisp-plus-language-act1:act1-condition-requirement-id c))
                 t)
               (ml0-condition (c)
                 (format t "  ml0-write: RECLASSIFIED to ~a — the gate is a blanket~%"
                         (type-of c))
                 nil)))

       ;; ---- and NOTHING WAS WRITTEN, over the WHOLE declared store.
       (format t "~&---- the state, measured ----~%")
       (setf *after* (ml0-take-store-scope *ml0-account-root*))
       (setf *state-clean* (ml0-store-scope-unchanged-p *before* *after*))
       (setf *no-account-written*
             (= *accounts-before*
                (length (ml0-list-account-ids *ml0-account-store*))))
       (ml0-print-store-universe "across all four faults" *before* *after*)
       (format t "  account count ~d -> ~d~%" *accounts-before*
               (length (ml0-list-account-ids *ml0-account-store*)))

       (format t "~&~%"))
  (when (probe-file *root*) (sb-ext:delete-directory *root* :recursive t)))

(let ((verdict (and *unadmitted-refused* *unadmitted-through-the-door*
                    *admitted-arrived-as-itself* *admitted-through-the-door*
                    *state-clean* *no-account-written*)))
  (format t "~& half (a) unadmitted refused as a HOST FAULT : ~a / ~a~%~
 half (b) admitted arrived AS ITSELF          : ~a / ~a~%~
 no account written · store byte-unchanged    : ~a / ~a~%~%"
          (if *unadmitted-refused* "yes" "NO")
          (if *unadmitted-through-the-door* "yes" "NO")
          (if *admitted-arrived-as-itself* "yes" "NO")
          (if *admitted-through-the-door* "yes" "NO")
          (if *no-account-written* "yes" "NO")
          (if *state-clean* "yes" "NO"))
  (format t "~&ml0-host-fault-proof: ~a~%" (if verdict "PASS" "FAIL"))
  (finish-output)
  (sb-ext:exit :code (if verdict 0 1)))
