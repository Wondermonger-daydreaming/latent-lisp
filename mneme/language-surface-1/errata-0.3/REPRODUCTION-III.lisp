;;;; REPRODUCTION-III.lisp — the Errata 0.3 standing regression gate.
;;;;
;;;; ONE INSTRUMENT, TWO SUBJECTS.  Run against the Errata 0.2 candidate every
;;;; verdict below CONFIRMS a defect the 2026-07-28 stranger audit returned.
;;;; Run against Errata 0.3 every verdict must come back REFUTED.  The captures
;;;; against the earlier subject are preserved beside this file in
;;;; `pre-errata-evidence/`.
;;;;
;;;; WHAT A VERDICT MEANS HERE, because the audit taught this lane that the
;;;; distinction is load-bearing:
;;;;
;;;;   Some of the returned defects were BEHAVIOURAL — the layer did the wrong
;;;;   thing (crashed, substituted, reported a live value for a frozen one).
;;;;   Those are tested by DOING the thing and observing the outcome.
;;;;
;;;;   Others were CLASSIFICATION defects — the layer did exactly the right
;;;;   thing and SAID something false about it.  D1 and D3 are of this kind: the
;;;;   ceiling guard and the round-trip gate were correct throughout, and what
;;;;   was wrong was the published claim that no public input could reach them.
;;;;   A test that fired those guards and called the firing a repair would be
;;;;   testing the wrong proposition entirely — the guards STILL fire, by
;;;;   design, and must.  So those verdicts examine THE CLAIM: the catalogue's
;;;;   reachability field, and the absence of the retracted sentences.
;;;;
;;;; Usage:  sbcl --non-interactive --load REPRODUCTION-III.lisp [SUBJECT-LABEL]

(defparameter *here* (or *load-truename* *default-pathname-defaults*))
(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "../surface1.lisp" *here*))
  (load (merge-pathnames "../../language-surface-0/surface0.lisp" *here*))
  ;; ERRATA 0.3 / D6.  This instrument computes its own subject digest; it does
  ;; not accept one from its wrapper.  An instrument that trusted its wrapper
  ;; for its subject identity would be exactly where the audit found this
  ;; layer, one level up.
  (load (merge-pathnames "EVIDENCE.lisp" *here*)))

(defpackage #:errata-0.3-reproduction (:use #:cl))
(in-package #:errata-0.3-reproduction)

(defparameter *here* cl-user::*here*)

;;; ERRATA 0.3 (D8/F-16).  Resolve through FIND-SYMBOL and REFUSE unless the
;;; symbol is already EXTERNAL, so this instrument cannot silently depend on a
;;; private name — the repair Errata 0.1 named and applied to one file of five.
(defmacro s1 (name &rest args)
  (let ((p (find-package '#:lisp-plus-surface1)))
    (multiple-value-bind (sym status) (find-symbol (string name) p)
      (unless (eq status :external)
        (error "instrument reached a non-external symbol ~A (status ~S)" name status))
      `(,sym ,@args))))

(defparameter *expected-verdicts* 12)
(defparameter *verdicts* 0)
(defparameter *confirmed* 0)
(defparameter *refuted* 0)
(defparameter *reclassified* 0)

(defun line (control &rest args)
  (let ((text (apply #'format nil control args)))
    (if (string= text "") (format t "~%") (format t "  ~A~%" text)))
  (finish-output))

(defun verdict (id kind label confirmed-p detail)
  "KIND is :behavioural or :classification — recorded, never collapsed."
  (incf *verdicts*)
  (if confirmed-p (incf *confirmed*) (incf *refuted*))
  (when (eq kind :classification) (incf *reclassified*))
  (format t "~&  [~A] ~A  ~A~%        ~A~%        ~A~%"
          id (if confirmed-p "CONFIRMED" "REFUTED  ")
          (if (eq kind :classification) "(classification)" "(behavioural)  ")
          label detail)
  (finish-output))

(defun tag (n) (lisp-plus-cd0:make-identifier-datum '("errata-0.3") (list n)))

(defun catalogue-entry (code)
  (assoc code (s1 expansion-refusal-code-catalog)))

;;; ==================================================================

(defparameter *subject-dir*
  (merge-pathnames "../" (make-pathname :name nil :type nil :defaults *here*)))
(defparameter *subject-digest*
  (funcall (find-symbol "SUBJECT-DIGEST" "SURFACE1-EVIDENCE") *subject-dir*))
(defparameter *subject-short* (subseq *subject-digest* 0 16))

(format t "~%LANGUAGE SURFACE /1 — ERRATA 0.3 REPRODUCTION III~%")
;; ERRATA 0.3 / D6.  The digest is the MEASUREMENT; the label is ADVISORY and is
;; marked as such, because `git rev-parse HEAD` answers what was last committed
;; here, never what is in these files.
(format t "  subject     ~A   (content digest — this is the measurement)~%"
        *subject-digest*)
(format t "  label       ~A   (ADVISORY, supplied from outside; not a measurement)~%"
        (or (second sb-ext:*posix-argv*) "<unlabelled subject>"))
;; The directory is printed RELATIVE, not as an absolute truename: an absolute
;; path makes a transcript unreproducible outside the directory it was frozen
;; from, which is exactly the packaging defect that made two of the audit
;; packet's own manifest entries unverifiable in place.
(format t "  directory   mneme/language-surface-1/  (relative, so this transcript is location-stable)~%")
(format t "  SBCL ~A · grammar v~D · procedure v~D · policy v~D~%"
        (lisp-implementation-version)
        (s1 expansion-grammar-version) (s1 expansion-procedure-version)
        (s1 expansion-policy-version))
(format t "~%")

;;; ==================================================================
;;; D1 — CLASSIFICATION.  The guard was always right; the claim was wrong.
;;; ==================================================================

(let* ((entry (catalogue-entry :expanded-nodes-exceeded))
       (reach (and entry (s1 refusal-catalog-entry-reachability entry)))
       (note (and entry (s1 refusal-catalog-entry-note entry))))
  (verdict "D1a" :classification
           "the expanded-side NODE ceiling is catalogued UNREACHABLE while public input reaches it"
           (eq reach :unreachable-under-this-policy)
           (format nil "catalogue reachability field reads ~S" reach))
  (verdict "D1b" :classification
           "the catalogue note still asserts the retracted measurement (\"MEASURED UNREACHABLE\" / \"never approach 20000\" / \"roughly 120 octets\")"
           (and note (or (search "MEASURED
UNREACHABLE" note) (search "MEASURED UNREACHABLE" note)
                         (search "can never approach 20000" note)
                         (search "roughly 120 octets" note)))
           (format nil "retracted phrases present: ~A"
                   (if (and note (or (search "MEASURED UNREACHABLE" note)
                                     (search "can never approach 20000" note)
                                     (search "roughly 120 octets" note)))
                       "yes" "no"))))

;;; The BEHAVIOUR under D1 must be UNCHANGED by the repair: the guard fires, and
;;; it must go on firing.  This verdict is written so that it CONFIRMS only if
;;; the guard has been broken or a ceiling has been moved to make the code
;;; theatrically unreachable — i.e. it guards the repair against overreach.
(let ((code nil) (door1 nil))
  (handler-case
      (let* ((form `(lisp-plus-surface0:define-judgment-schema cl-user::*e03r-j*
                      :name :e03r :version 0 :conclusion 0
                      :premises ,(make-list 2600 :initial-element 0)
                      :locals () :unique-locals ()))
             (req (s1 request-expansion form :macroexpand-1 (tag "d1c"))))
        (setf door1 t)
        (multiple-value-bind (r e refusal) (s1 try-perform-expansion req)
          (declare (ignore r e))
          (setf code (and refusal (s1 expansion-refusal-code refusal)))))
    (error (c) (setf code (type-of c))))
  (verdict "D1c" :behavioural
           "the node guard stopped firing, or a ceiling was moved to make the code unreachable (a repair must not do this)"
           (not (and door1 (eq code :expanded-nodes-exceeded)))
           (format nil "Door 1 accepted ~A · Door 2 code ~S (the guard firing is CORRECT and expected)"
                   door1 code)))

;;; ==================================================================
;;; D2 — BEHAVIOURAL.  Compound TYPE-OF must not escape as a host condition.
;;; ==================================================================

(dolist (spec (list (list "D2a" "a complex number"         (complex 1 2))
                    (list "D2b" "a simple vector"          (vector 1 2 3))
                    (list "D2c" "a multidimensional array" (make-array '(2 2)))))
  (destructuring-bind (id label object) spec
    (let ((signalling nil) (non-signalling nil))
      ;; the signalling door
      (handler-case (progn (s1 request-expansion (list 'f object) :macroexpand-1 (tag id))
                           (setf signalling :no-refusal))
        (type-error () (setf signalling :host-type-error))
        (error (c) (setf signalling (if (typep c (find-symbol "EXPANSION-REFUSED"
                                                              "LISP-PLUS-SURFACE1"))
                                        :designed-refusal
                                        (list :other (type-of c))))))
      ;; the NON-signalling twin, whose whole contract is that it does not signal
      (handler-case (multiple-value-bind (req refusal)
                        (s1 try-request-expansion (list 'f object) :macroexpand-1 (tag id))
                      (declare (ignore req))
                      (setf non-signalling
                            (if (and refusal
                                     (eq (s1 expansion-refusal-code refusal)
                                         :source-term-unrepresentable))
                                :designed-refusal
                                (list :unexpected (and refusal (s1 expansion-refusal-code refusal))))))
        (type-error () (setf non-signalling :host-type-error))
        (error (c) (setf non-signalling (list :other (type-of c)))))
      (verdict id :behavioural
               (format nil "~A escapes the public API as an uncaught host TYPE-ERROR instead of the designed refusal" label)
               (or (eq signalling :host-type-error) (eq non-signalling :host-type-error))
               (format nil "REQUEST-EXPANSION ~S · TRY-REQUEST-EXPANSION ~S"
                       signalling non-signalling)))))

;;; ==================================================================
;;; D3 — one CLASSIFICATION verdict and one BEHAVIOURAL verdict.
;;; ==================================================================

(let* ((entry (catalogue-entry :source-not-reconstructible))
       (note (and entry (s1 refusal-catalog-entry-note entry))))
  ;; A NOTE ON THIS PROBE, because it caught me out and the lesson generalises:
  ;; my first version searched the note for "decode is injective" and reported
  ;; CONFIRMED against the REPAIRED tree — because the repaired note RETRACTS
  ;; that claim and therefore QUOTES IT.  A probe that greps for a claim cannot
  ;; tell an assertion from its retraction.  So this verdict tests the two
  ;; things that actually differ: the absolute phrase is gone, AND the note now
  ;; states the reachability positively.
  (verdict "D3a" :classification
           "the catalogue does not tell a reader that ROUND-TRIP-MISMATCH is publicly reachable (or still asserts that no public input reaches it)"
           (or (null note)
               (search "NO PUBLIC INPUT REACHES THIS" note)
               (not (search "PUBLICLY REACHABLE" note)))
           (format nil "absolute retracted phrase present: ~A · states public reachability: ~A"
                   (if (and note (search "NO PUBLIC INPUT REACHES THIS" note)) "yes" "no")
                   (if (and note (search "PUBLICLY REACHABLE" note)) "yes" "no"))))

;;; The two public mechanisms must go on refusing — again, a guard whose firing
;;; is correct.  This verdict CONFIRMS only if a mechanism stopped refusing,
;;; i.e. if the repair had "fixed" the gate by letting the substitution through.
(let ((rename-code nil) (pln-code nil))
  (defpackage #:e03r-rho (:use))
  (let* ((x (intern "X" (find-package "E03R-RHO")))
         (req (s1 request-expansion (list x) :macroexpand-1 (tag "d3b"))))
    (rename-package (find-package "E03R-RHO") "E03R-RHO-PRIME" '("E03R-RHO"))
    (multiple-value-bind (r e refusal) (s1 try-perform-expansion req)
      (declare (ignore r e))
      (setf rename-code (and refusal (s1 expansion-refusal-upstream-code refusal))))
    (rename-package (find-package "E03R-RHO-PRIME") "E03R-RHO"))
  (defpackage #:e03r-delta (:use))
  (defpackage #:e03r-else (:use))
  (defpackage #:e03r-caller (:use))
  (let* ((x (intern "X" (find-package "E03R-DELTA"))))
    (intern "X" (find-package "E03R-ELSE"))
    (let ((req (s1 request-expansion (list x) :macroexpand-1 (tag "d3c"))))
      (sb-ext:add-package-local-nickname "E03R-DELTA" "E03R-ELSE"
                                         (find-package "E03R-CALLER"))
      (let ((*package* (find-package "E03R-CALLER")))
        (multiple-value-bind (r e refusal) (s1 try-perform-expansion req)
          (declare (ignore r e))
          (setf pln-code (and refusal (s1 expansion-refusal-upstream-code refusal)))))))
  (verdict "D3b" :behavioural
           "a public host-state substitution stopped refusing at the round-trip gate (a repair must not do this)"
           (not (and (equal rename-code "ROUND-TRIP-MISMATCH")
                     (equal pln-code "ROUND-TRIP-MISMATCH")))
           (format nil "rename+nickname upstream ~S · ambient package-local nickname upstream ~S (both refusing is CORRECT)"
                   rename-code pln-code)))

;;; D3c — BEHAVIOURAL: surplus identifier segments must no longer decode.
(let* ((mk (lambda (ns path)
             (lisp-plus-cd0:make-record-datum
              (list (lisp-plus-cd0:make-record-entry
                     (lisp-plus-cd0:make-identifier-datum '("TERM") '("KIND"))
                     (lisp-plus-cd0:make-identifier-datum '("TERMKIND") '("SYMBOL")))
                    (lisp-plus-cd0:make-record-entry
                     (lisp-plus-cd0:make-identifier-datum '("TERM") '("VALUE"))
                     (lisp-plus-cd0:make-identifier-datum ns path))))))
       (a (funcall mk '("COMMON-LISP") '("CAR")))
       (b (funcall mk '("COMMON-LISP" "SURPLUS") '("CAR" "SURPLUS")))
       (da (handler-case (s1 decode-term a) (error () :refused)))
       (db (handler-case (s1 decode-term b) (error () :refused))))
  (verdict "D3d" :behavioural
           "two DISTINCT admissible data decode to ONE symbol — surplus identifier segments are silently discarded"
           (and (eq da 'car) (eq db 'car))
           (format nil "decode(one-segment) ~S · decode(surplus-segment) ~S · distinct data ~S"
                   da db (not (lisp-plus-cd0:equal-datum a b)))))

;;; ==================================================================
;;; D5 — BEHAVIOURAL.  The raw public functions must refuse, not die.
;;; The DECODE half is exercised in a SEPARATE PROCESS by the runner, because
;;; before the repair it was a fatal image abort no handler could reach; here we
;;; exercise the encode half plus both ceiling edges.
;;; ==================================================================

(let* ((ceiling (s1 term-depth-ceiling))
       (deep (let ((f 0)) (dotimes (i 40000 f) (setf f (list f)))))
       (encode-outcome
         (handler-case (progn (s1 encode-term deep) :encoded)
           (storage-condition () :control-stack-exhausted)
           (error () :refused)))
       (at-ceiling (let ((f 0)) (dotimes (i (1- ceiling) f) (setf f (list f)))))
       (at-outcome (handler-case (progn (s1 encode-term at-ceiling) :encoded)
                     (storage-condition () :control-stack-exhausted)
                     (error () :refused))))
  (verdict "D5a" :behavioural
           "the PUBLIC ENCODE-TERM exhausts the host control stack on deep ACYCLIC input instead of refusing"
           (eq encode-outcome :control-stack-exhausted)
           (format nil "depth 40000 -> ~S · at declared ceiling ~D -> ~S (must be :ENCODED)"
                   encode-outcome ceiling at-outcome)))

;;; ==================================================================
;;; D7 — BEHAVIOURAL.  A receipt must report the versions that minted it.
;;; ==================================================================

(defparameter *good-source*
  '(lisp-plus-surface0:define-judgment-schema cl-user::*e03r-good*
    :name :e03rg :version 0
    :conclusion (:predicate :z (:v (:var :v)))
    :premises () :locals () :unique-locals ()))

(let* ((req (s1 request-expansion *good-source* :macroexpand-1 (tag "d7")))
       (receipt (s1 perform-expansion req))
       (minted (s1 expansion-receipt-procedure-version receipt))
       (id-before (s1 render-identity-hex (s1 expansion-receipt-identity receipt)))
       (live-before (s1 expansion-procedure-version)))
  (handler-bind ((warning #'muffle-warning))
    (eval `(defun lisp-plus-surface1::expansion-procedure-version () ,(+ 1 live-before))))
  (let ((after (s1 expansion-receipt-procedure-version receipt))
        (id-after (s1 render-identity-hex (s1 expansion-receipt-identity receipt))))
    (handler-bind ((warning #'muffle-warning))
      (eval `(defun lisp-plus-surface1::expansion-procedure-version () ,live-before)))
    (verdict "D7a" :behavioural
             "an OLD receipt's reported procedure version MOVES when the live package version changes"
             (/= minted after)
             (format nil "minted ~S · after a live bump the same receipt reports ~S · identity unchanged ~S"
                     minted after (string= id-before id-after))))
  ;; D7b — the alarm must have two real operands: a Door-1 capture that differs
  ;; from the live-at-mint value must REFUSE rather than pass unseen.
  (let* ((req2 (s1 request-expansion *good-source* :macroexpand-1 (tag "d7b")))
         (outcome nil))
    (handler-bind ((warning #'muffle-warning))
      (eval `(defun lisp-plus-surface1::expansion-procedure-version () ,(+ 1 live-before))))
    (multiple-value-bind (r e refusal) (s1 try-perform-expansion req2)
      (declare (ignore r e))
      (setf outcome (if refusal (s1 expansion-refusal-code refusal) :minted-anyway)))
    (handler-bind ((warning #'muffle-warning))
      (eval `(defun lisp-plus-surface1::expansion-procedure-version () ,live-before)))
    (verdict "D7b" :behavioural
             "an image upgraded BETWEEN the doors mints a receipt anyway — the version alarm has no second operand"
             (eq outcome :minted-anyway)
             (format nil "outcome ~S (:PROCEDURE-VERSION-MISMATCH is the repaired answer)" outcome))))

;;; ==================================================================

(format t "~%")
(line "verdicts marked (classification) test A PUBLISHED CLAIM; verdicts marked")
(line "(behavioural) test WHAT THE CODE DOES.  D1c and D3b are written inverted on")
(line "purpose: they CONFIRM only if a correct guard was weakened, so a repair")
(line "cannot buy a green by making a reachable code unreachable.")
(format t "~%REPRODUCTION-III-RESULT verdicts=~D expected=~D confirmed=~D refuted=~D classification=~D subject=~A~%"
        *verdicts* *expected-verdicts* *confirmed* *refuted* *reclassified*
        *subject-short*)
(finish-output)
(sb-ext:exit :code (if (= *verdicts* *expected-verdicts*) 0 1))
