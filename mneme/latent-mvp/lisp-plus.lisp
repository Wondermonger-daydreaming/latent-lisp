;;;; lisp-plus.lisp — the FIRST runnable Lisp+ (latent-MVP)
;;;;
;;;; Axiom 3 made mechanical: EVERY VALUE CARRIES ITS GRADE, and the claim
;;;; algebra resolves EACH SPECIES IN ITS OWN VOCABULARY. A rationale sitting
;;;; next to an example reads as confident but carries a different passport and
;;;; CANNOT count as evidence. "Rhetoric is not evidence" — here it is a fact of
;;;; the type system, not a slogan.
;;;;
;;;; Run:  sbcl --script experiments/lispplus/latent-mvp/lisp-plus.lisp
;;;; Determinism: seeded at :33 (atelier convention). Must exit 0.
;;;;
;;;; — FORGE (built on Common Lisp / SBCL), 2026-07-11

(require :sb-md5)

(defpackage :lisp-plus
  (:use :cl))
(in-package :lisp-plus)

;;; --------------------------------------------------------------------------
;;; 0. Determinism — the atelier :33 seed
;;; --------------------------------------------------------------------------

(defparameter +seed+ 33)
(setf *random-state* (sb-ext:seed-random-state +seed+))

(defun content-digest (obj)
  "A REAL content hash (md5 of the printed form) — a resolvable evidence link,
   not a description of evidence. The Constitution wants sha256; MVP uses md5
   (built into SBCL). Same law: the link resolves to the bytes."
  (let ((s (format nil "~S" obj)))
    (format nil "md5:~(~{~2,'0X~}~)"
            (coerce (sb-md5:md5sum-string s) 'list))))

;;; ==========================================================================
;;; 1. GRADED VALUES — every value wears its passport on its face
;;; ==========================================================================
;;;
;;; Two species (Axiom 3):
;;;   OBSERVED  — append-only, evidence-linked. an execution RECORD, or a
;;;               path/sha/span. it does not DESCRIBE evidence; it LINKS to it.
;;;   ASSERTED  — an interpretation. carries :status :confidence :vantage
;;;               :temporality. a bare boolean cannot establish contemporaneity;
;;;               a passport can.

(defclass graded () ()
  (:documentation "Any Lisp+ value that carries its grade."))

(defclass observed (graded)
  ((payload   :initarg :payload   :reader payload)
   (link-kind :initarg :link-kind :reader link-kind)  ; :execution | :path | :span
   (evidence  :initarg :evidence  :reader evidence)   ; the resolvable link data
   (digest    :reader digest)))

(defmethod initialize-instance :after ((o observed) &key)
  (setf (slot-value o 'digest) (content-digest (evidence o))))

(defclass asserted (graded)
  ((payload     :initarg :payload     :reader payload)
   (status      :initarg :status      :reader status      :initform :claimed)
   (confidence  :initarg :confidence  :reader confidence  :initform 1.0)
   (vantage     :initarg :vantage     :reader vantage     :initform :unknown)
   (temporality :initarg :temporality :reader temporality :initform :contemporaneous)))

;;; The PASSPORT on the face — print-object is where the grade becomes visible.

(defmethod print-object ((o observed) stream)
  (format stream "#<OBSERVED ~S :via ~A :evidence ~S :~A>"
          (payload o) (link-kind o) (evidence o) (digest o)))

(defmethod print-object ((a asserted) stream)
  (format stream "#<ASSERTED ~S :status ~A :confidence ~,2F :vantage ~A :temporality ~A>"
          (payload a) (status a) (confidence a) (vantage a) (temporality a)))

(defun observe (payload &key (link-kind :execution) evidence)
  (make-instance 'observed :payload payload :link-kind link-kind
                           :evidence (or evidence payload)))

(defun assert-val (payload &key (status :claimed) (confidence 1.0)
                                (vantage :unknown) (temporality :contemporaneous))
  (make-instance 'asserted :payload payload :status status :confidence confidence
                           :vantage vantage :temporality temporality))

;;; ==========================================================================
;;; 2. THE SUBJECT UNDER TEST — median (sort -> middle-or-mean)
;;; ==========================================================================

(define-condition empty-input (error) ()
  (:report (lambda (c s) (declare (ignore c)) (format s "median of empty list"))))

(defun median (xs)
  "Sort-based median. Stability preferred over linear-time selection."
  (when (null xs) (error 'empty-input))
  (let* ((s (sort (copy-list xs) #'<))
         (n (length s))
         (h (floor n 2)))
    (if (oddp n)
        (nth h s)
        (/ (+ (nth (1- h) s) (nth h s)) 2))))

;;; ==========================================================================
;;; 3. THE CLAIM ALGEBRA — each species resolves IN ITS OWN VOCABULARY
;;; ==========================================================================
;;;
;;; This is the whole point. The vocabularies do NOT collapse into one another:
;;;
;;;   example    (executed)            -> :supported | :refuted
;;;   property   (generated-input)     -> :supported | :refuted
;;;   raises     (verified)            -> :supported | :refuted
;;;   contract   (enforced)            -> :enforced  | :violated
;;;   complexity (asserted|profiled)   -> :asserted   (never a truth-verdict)
;;;   rationale  (explanatory)         -> :explanatory  (NEVER :supported)

(defstruct resolution
  species        ; the claim KIND (a keyword)
  status         ; the verdict, IN THE SPECIES' OWN VOCABULARY
  observed       ; the OBSERVED value produced by resolving (or NIL)
  asserted       ; the ASSERTED value the claim carried (or NIL)
  note)          ; short human-facing gloss

;; --- example: EXECUTE the fn, compare to the asserted return -----------------

(defun resolve-example (fn input returns &key (vantage :corpus))
  (let* ((claimed (assert-val returns :status :claimed :confidence 1.0
                                       :vantage vantage :temporality :contemporaneous))
         (actual-val (handler-case (apply fn input)
                       (error (e) (list :signalled (type-of e)))))
         (record `(:call (,(nth-value 2 (function-lambda-expression fn))
                          ,@input)
                   :returned ,actual-val))
         (obs (observe actual-val :link-kind :execution :evidence record))
         (ok  (and (numberp actual-val) (= actual-val returns))))
    (make-resolution :species :example
                     :status (if ok :supported :refuted)
                     :observed obs :asserted claimed
                     :note (format nil "executed on ~S; ~:[EXPECTED ~S, GOT ~S~;matched ~S~]"
                                   input ok returns
                                   (if ok returns actual-val)))))

;; --- property: N SEEDED generated inputs, backtrack on first failure ---------

(defun seeded-random-list (max-len max-val)
  (let ((n (1+ (random max-len))))          ; nonempty
    (loop repeat n collect (random max-val))))

(defun resolve-property (fn name pred &key (trials 200) (max-len 9) (max-val 50))
  "PRED is (lambda (xs) ...) over a generated nonempty list. Uses the seeded
   RNG, so the trial stream is deterministic under +seed+."
  (let ((counterexample nil) (checked 0))
    (block search
      (dotimes (i trials)
        (let ((xs (seeded-random-list max-len max-val)))
          (incf checked)
          (unless (funcall pred fn xs)
            (setf counterexample xs)
            (return-from search)))))
    (let* ((ok (null counterexample))
           (record `(:property ,name :trials-checked ,checked :seed ,+seed+
                     ,@(when counterexample `(:counterexample ,counterexample))))
           (obs (observe (if ok :held counterexample)
                         :link-kind :execution :evidence record))
           (claimed (assert-val name :status :claimed :confidence 0.9
                                      :vantage :corpus :temporality :contemporaneous)))
      (make-resolution :species :property
                       :status (if ok :supported :refuted)
                       :observed obs :asserted claimed
                       :note (if ok
                                 (format nil "~D seeded trials, no counterexample" checked)
                                 (format nil "counterexample after ~D trials: ~S"
                                         checked counterexample))))))

;; --- raises: does calling on the trigger SIGNAL the named condition? ---------

(defun resolve-raises (fn input condition-name &key (vantage :corpus))
  (let* ((signalled
           (handler-case (progn (apply fn input) nil)
             (condition (c) (type-of c))))
         (ok (and signalled (subtypep signalled condition-name)))
         (record `(:call-expecting-signal ,input :got ,(or signalled :no-signal)))
         (obs (observe (or signalled :no-signal) :link-kind :execution :evidence record))
         (claimed (assert-val condition-name :status :claimed :confidence 1.0
                                              :vantage vantage :temporality :contemporaneous)))
    (make-resolution :species :raises
                     :status (if ok :supported :refuted)
                     :observed obs :asserted claimed
                     :note (format nil "expected signal ~A; ~:[got ~A~;signalled ~A~]"
                                   condition-name ok signalled))))

;; --- contract: ENFORCED at the boundary -> :enforced | :violated -------------

(defun resolve-contract (fn input pred name &key (vantage :corpus))
  "PRED checks a post-condition on the return. Its vocabulary is enforcement,
   NOT support — a contract is a guard, not a hypothesis."
  (let* ((val (handler-case (apply fn input) (error (e) (list :signalled (type-of e)))))
         (ok (ignore-errors (funcall pred input val)))
         (record `(:contract ,name :input ,input :return ,val :satisfied ,(and ok t)))
         (obs (observe val :link-kind :execution :evidence record))
         (claimed (assert-val name :status :claimed :confidence 1.0
                                    :vantage vantage :temporality :contemporaneous)))
    (make-resolution :species :contract
                     :status (if ok :enforced :violated)
                     :observed obs :asserted claimed
                     :note (format nil "post-condition ~A on ~S -> ~S" name input val))))

;; --- complexity: ASSERTED unless actually profiled --------------------------

(defun resolve-complexity (big-o &key profiled)
  "A complexity claim that was not profiled resolves to :asserted — it is a
   statement wearing no evidence. Its vocabulary is not truth."
  (let ((claimed (assert-val big-o :status :claimed :confidence 0.6
                                    :vantage :author :temporality :retrospective)))
    (make-resolution :species :complexity
                     :status (if profiled :profiled :asserted)
                     :observed nil :asserted claimed
                     :note (if profiled
                               (format nil "~A (profiled)" big-o)
                               (format nil "~A (asserted, not profiled)" big-o)))))

;; --- rationale: EXPLANATORY, and NEVER anything else -------------------------
;;;
;;; THE THESIS, COMPILED. There is NO code path from a rationale to :supported.
;;; It carries an ASSERTED value with status :explanatory; it produces NO
;;; OBSERVED value, because it links to no evidence. It sits next to the
;;; examples reading just as confident — and cannot count as one.

(defun resolve-rationale (text)
  (let ((claimed (assert-val text :status :explanatory :confidence 0.0
                                   :vantage :author :temporality :retrospective)))
    (make-resolution :species :rationale
                     :status :explanatory           ; hard-wired; no branch to :supported
                     :observed nil                  ; no evidence link — that is the point
                     :asserted claimed
                     :note "explanatory prose; verifies NOTHING")))

;;; A structural guard, so the thesis is enforced by CODE, not by author care:
;;; a rationale that ever wore an evidential verdict is a language bug.
(defun assert-rationale-cannot-support (res)
  (when (and (eq (resolution-species res) :rationale)
             (member (resolution-status res) '(:supported :enforced :profiled)))
    (error "LANGUAGE VIOLATION: a rationale resolved to an evidential verdict ~S"
           (resolution-status res))))

;;; ==========================================================================
;;; 4. THE REPORT — graded, load-bearing output
;;; ==========================================================================

(defparameter +species-vocab+
  '((:example    . "(:supported | :refuted)")
    (:property   . "(:supported | :refuted)")
    (:raises     . "(:supported | :refuted)")
    (:contract   . "(:enforced | :violated)")
    (:complexity . "(:asserted | :profiled)")
    (:rationale  . "(:explanatory — never :supported)")))

(defun rule (&optional (ch #\=) (n 78))
  (format t "~A~%" (make-string n :initial-element ch)))

(defun print-resolution (idx res)
  (let ((vocab (cdr (assoc (resolution-species res) +species-vocab+))))
    (format t "~%[~D] CLAIM KIND: ~A    resolves in vocabulary ~A~%"
            idx (string-upcase (symbol-name (resolution-species res))) vocab)
    (format t "    -> RESOLUTION: ~A~%" (resolution-status res))
    (format t "       ~A~%" (resolution-note res))
    (when (resolution-observed res)
      (format t "    OBSERVED : ~A~%" (resolution-observed res)))
    (when (resolution-asserted res)
      (format t "    ASSERTED : ~A~%" (resolution-asserted res)))
    (when (and (resolution-observed res) (resolution-asserted res))
      (format t "    PASSPORTS DIFFER: observed carries a resolvable link; asserted carries only a vantage.~%"))))

;;; ==========================================================================
;;; 5. THE RUN — median's claims from 0001-median.lisp+, plus TWO planted proofs
;;; ==========================================================================

(defun run ()
  (rule #\=)
  (format t "Lisp+ latent-MVP — Axiom 3: every value carries its grade~%")
  (format t "seed = ~D (deterministic)   subject = (median xs) : sort -> middle-or-mean~%" +seed+)
  (rule #\=)

  (let ((claims '()))
    (flet ((add (r) (assert-rationale-cannot-support r) (push r claims)))

      ;; --- the honest claims transcribed from corpus seed 0001 -----------------
      (add (resolve-example #'median '((1 2 3))   2))       ; middle
      (add (resolve-example #'median '((1 2 3 4)) 5/2))     ; mean-of-two

      (add (resolve-property #'median 'permutation-invariance
                             (lambda (fn xs)
                               (= (funcall fn xs)
                                  (funcall fn (alexandria-shuffle xs))))))

      (add (resolve-raises #'median '(()) 'empty-input))

      ;; contract: the median lies within [min,max] of the input (a guard, its
      ;; own vocabulary — :enforced, not :supported)
      (add (resolve-contract #'median '((3 1 2 9 4))
                             (lambda (in val)
                               (let ((xs (car in)))
                                 (<= (reduce #'min xs) val (reduce #'max xs))))
                             'within-range))

      ;; complexity: asserted, not profiled -> resolves :asserted
      (add (resolve-complexity "O(n log n)"))

      ;; --- PLANTED PROOF (a): a DELIBERATELY FALSE example --------------------
      ;; median of (10 20 30) is 20, NOT 999. refutation must TRAVEL: the
      ;; language does not rubber-stamp a claim just because it is asserted.
      (add (resolve-example #'median '((10 20 30)) 999))

      ;; --- PLANTED PROOF (b): the rationale from 0001 -------------------------
      ;; sits right next to the examples, reads just as confident, carries a
      ;; DIFFERENT passport -> :explanatory, and there is no path to :supported.
      (add (resolve-rationale
            "Sort-based: stability preferred over linear-time selection.")))

    (setf claims (nreverse claims))
    (loop for r in claims for i from 1 do (print-resolution i r))

    ;; --- THE THESIS, PROVEN BY THIS RUN ------------------------------------
    (rule #\=)
    (format t "THESIS — proven by the run above, not asserted:~%")
    (rule #\-)
    (let* ((false-ex (find-if (lambda (r)
                                (and (eq (resolution-species r) :example)
                                     (eq (resolution-status r) :refuted)))
                              claims))
           (rationale (find :rationale claims :key #'resolution-species))
           (any-rationale-supported
             (some (lambda (r) (and (eq (resolution-species r) :rationale)
                                    (eq (resolution-status r) :supported)))
                   claims)))
      (format t "1. The planted FALSE example resolved: ~A~%"
              (resolution-status false-ex))
      (format t "   => refutation TRAVELS. an asserted :returns of 999 was executed,~%")
      (format t "      observed to be 20, and REFUTED. rhetoric did not save it.~%~%")
      (format t "2. The rationale resolved: ~A   (rationale-ever-:supported? ~A)~%"
              (resolution-status rationale) any-rationale-supported)
      (format t "   => it reads as confident as any example, but its passport is~%")
      (format t "      EXPLANATORY. it produced no OBSERVED value; it links to no~%")
      (format t "      evidence; there is no code path from a rationale to :supported.~%~%")
      (format t "GRADES TRAVEL. Rhetorical proximity never masqueraded as evidential~%")
      (format t "equivalence: the example carries a resolvable execution record; the~%")
      (format t "rationale, sitting one line away, carries only a vantage. The type~%")
      (format t "system — not the author's good manners — kept them apart.~%")
      (rule #\=)

      ;; hard gates: the run is only honest if BOTH planted proofs landed.
      (unless (and false-ex (eq (resolution-status false-ex) :refuted))
        (error "PLANT FAILED: the false example did not refute"))
      (when any-rationale-supported
        (error "PLANT FAILED: a rationale wore an evidential verdict"))
      (format t "~%[gates passed: false-example REFUTED, rationale EXPLANATORY-only]~%"))))

;;; --- a seeded shuffle, so property trials are deterministic ------------------
(defun alexandria-shuffle (seq)
  "Fisher-Yates over a copy, drawing from the seeded *random-state*."
  (let ((v (coerce seq 'vector)))
    (loop for i from (1- (length v)) downto 1
          for j = (random (1+ i))
          do (rotatef (aref v i) (aref v j)))
    (coerce v 'list)))

(run)
(sb-ext:exit :code 0)
