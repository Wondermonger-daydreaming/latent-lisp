;;;; repro.lisp — REPRODUCTION of an owner-supplied pre-audit defect report
;;;; against Language Surface /1 Candidate /0 at 2e21f367.
;;;;
;;;; THIS INSTRUMENT IS SUBJECT-NEUTRAL.  It takes the candidate directory as
;;;; argv[1] and an optional SUBJECT LABEL as argv[2], and it reports the
;;;; grammar and procedure versions it actually found.  It does not patch.
;;;;
;;;; ERRATA 0.2 — an earlier revision hard-coded "candidate 2e21f367, unpatched"
;;;; into its own banner, so the AFTER capture, taken against the repaired tree,
;;;; identified itself as the unpatched candidate.  In a layer devoted to
;;;; truthful accounts, the evidence had wandered onstage wearing the subject's
;;;; nametag.  The header is now derived, never asserted.

(defparameter *s1dir*
  (pathname (or (second sb-ext:*posix-argv*)
                "/home/gauss/Desktop/Claude-Code-Lab/experiments/latent-lisp/mneme/language-surface-1/")))
(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "surface1.lisp" *s1dir*))
  (load (merge-pathnames "../language-surface-0/surface0.lisp" *s1dir*)))

(defpackage #:repro (:use #:common-lisp))
(in-package #:repro)
(defmacro s1 (n &rest a) `(,(intern (string n) '#:lisp-plus-surface1) ,@a))
(defmacro cd0 (n &rest a) `(,(intern (string n) '#:lisp-plus-cd0) ,@a))
(defun banner (s)
  ;; The underline is INDENTED.  A row of = at column 0 is what `git diff
  ;; --check` reads as a leftover conflict marker, and a captured transcript
  ;; that trips the repository's own hygiene gate is a transcript somebody will
  ;; eventually be tempted to hand-edit.
  (format t "~%  ~A~%  ~A~%" s (make-string (length s) :initial-element #\-)))
(defun line (c &rest a)
  ;; A blank line emits no trailing whitespace, for the same reason.
  (let ((text (apply #'format nil c a)))
    (if (string= text "") (format t "~%") (format t "    ~A~%" text))))
(defun tag (&rest p) (cd0 make-identifier-datum '("repro") p))
(defun same (a b) (cd0 equal-datum a b))
(defun hexid (d) (cd0 octets-to-hex (cd0 canonical-octets d)))
;;; API-AGNOSTIC: Candidate /0 returned an occurrence IDENTITY as the third
;;; value; Errata 0.1 returns an occurrence OBJECT.  This probe must run
;;; unchanged against BOTH trees, or a before/after comparison is measuring two
;;; instruments instead of two candidates.
(defun occ-id (x)
  (if (cd0 bytes-datum-p x) x
      (funcall (find-symbol "EXPANSION-OCCURRENCE-IDENTITY" '#:lisp-plus-surface1) x)))

(defparameter *verdicts* '())
(defun verdict (id text state) (push (list id state text) *verdicts*)
  (format t "  ~A  ~A — ~A~%" (if (eq state :confirmed) "CONFIRMED" "REFUTED  ") id text))

(defparameter *subject-label* (or (third sb-ext:*posix-argv*) "<unlabelled subject>"))
(format t "~&REPRODUCTION I — Surface /1 pre-audit defect report (4 findings, 6 parts)~%")
(format t "subject     ~A~%" *subject-label*)
(format t "directory   ~A~%" (namestring (truename cl-user::*s1dir*)))
(format t "SBCL ~A · grammar v~D · procedure v~D · policy v~D~%"
        (lisp-implementation-version)
        (s1 expansion-grammar-version) (s1 expansion-procedure-version)
        (s1 expansion-policy-version))

;;; ==================================================================
(banner "FINDING 1 — MUTABLE SOURCE ALIAS / FALSE EDGE")

;;; A caller-owned MUTABLE tree.  Built with LIST/COPY-TREE so no literal is
;;; shared with the compiled file and SETF is legal.
(defun fresh-source (version)
  (copy-tree
   (list (find-symbol "DEFINE-ADMISSION-CONTRACT" '#:lisp-plus-surface0)
         (intern "*REPRO-C*" '#:cl-user)
         :contract-id :repro/c
         :contract-version version
         :accepted-clauses (list (list :verified-judged-claim))
         :proposition-relation :exact-normalized-equality
         :receiver-accessibility :required
         :retain (list :contract-snapshot :support-identity
                       :support-basis :source-basis))))

(defparameter *live* (fresh-source 1))
(defparameter *pristine* (copy-tree *live*))

(line "pre-mutation :contract-version = ~S" (getf (cddr *live*) :contract-version))
(defparameter *req* (s1 request-expansion *live* :macroexpand-1 (tag "f1")))
(defparameter *stored-datum* (s1 expansion-request-source-form-datum *req*))
(line "Door 1 stored source datum id ~A…" (subseq (hexid *stored-datum*) 0 24))

;;; THE MUTATION.  The request object is not touched.
(setf (getf (cddr *live*) :contract-version) 999)
(line "post-mutation :contract-version = ~S  (request object untouched)"
      (getf (cddr *live*) :contract-version))

(defparameter *rc* nil) (defparameter *ex* nil)
(multiple-value-setq (*rc* *ex*) (s1 perform-expansion *req*))

(defparameter *datum-of-pristine* (s1 encode-term *pristine*))
(defparameter *datum-of-mutated*  (s1 encode-term *live*))
(defparameter *receipt-src*  (s1 expansion-receipt-source-form-datum *rc*))
(defparameter *receipt-exp*  (s1 expansion-receipt-expanded-form-datum *rc*))
(defparameter *expected-exp-from-pristine* (s1 encode-term (macroexpand-1 *pristine* nil)))
(defparameter *expected-exp-from-mutated*  (s1 encode-term (macroexpand-1 *live* nil)))

(line "")
(line "stored source datum  == PRISTINE source ......... ~A"
      (same *receipt-src* *datum-of-pristine*))
(line "stored source datum  == MUTATED  source ......... ~A"
      (same *receipt-src* *datum-of-mutated*))
(line "receipt expanded     == expansion of PRISTINE ... ~A"
      (same *receipt-exp* *expected-exp-from-pristine*))
(line "receipt expanded     == expansion of MUTATED .... ~A"
      (same *receipt-exp* *expected-exp-from-mutated*))
(line "the expanded form actually carries version ...... ~S"
      (let ((walk (macroexpand-1 *live* nil)))
        (getf (cdr (third (second walk))) :contract-version)))

(if (and (same *receipt-src* *datum-of-pristine*)
         (not (same *receipt-src* *datum-of-mutated*))
         (same *receipt-exp* *expected-exp-from-mutated*)
         (not (same *receipt-exp* *expected-exp-from-pristine*)))
    (verdict "1a" "receipt asserts a FALSE EDGE: stored source is the PRE-mutation form, expanded datum is computed from the POST-mutation form" :confirmed)
    (verdict "1a" "no false edge observed" :refuted))

;;; --- 1b: a mutable STRING leaf ------------------------------------
;;; The question is what the RECEIPT accounts for, never what a fresh host
;;; expansion of the caller's live tree would produce.  An earlier revision of
;;; this probe asked the host directly and would have reported a defect against
;;; any implementation whatsoever.
(defparameter *str* (copy-seq "alpha"))
(defun string-source (s)
  (list (find-symbol "DEFINE-ADMISSION-CONTRACT" '#:lisp-plus-surface0)
        (intern "*REPRO-S*" '#:cl-user)
        :contract-id s
        :contract-version 1
        :accepted-clauses (list (list :verified-judged-claim))
        :proposition-relation :exact-normalized-equality
        :receiver-accessibility :required
        :retain (list :contract-snapshot)))
(defparameter *src2* (string-source *str*))
(defparameter *pristine2* (string-source (copy-seq "alpha")))
(defparameter *req2* (s1 request-expansion *src2* :macroexpand-1 (tag "f1b")))
(setf (char *str* 0) #\Z)
(line "")
(line "string leaf mutated in place: ~S" *str*)
(defparameter *rc2* (s1 perform-expansion *req2*))
(defparameter *exp2* (s1 expansion-receipt-expanded-form-datum *rc2*))
(defparameter *exp-from-pristine2* (s1 encode-term (macroexpand-1 *pristine2* nil)))
(defparameter *exp-from-mutated2*  (s1 encode-term (macroexpand-1 (string-source *str*) nil)))
(line "receipt expanded == expansion of the PRE-mutation string ... ~A"
      (same *exp2* *exp-from-pristine2*))
(line "receipt expanded == expansion of the POST-mutation string .. ~A"
      (same *exp2* *exp-from-mutated2*))
(if (and (same *exp2* *exp-from-mutated2*) (not (same *exp2* *exp-from-pristine2*)))
    (verdict "1b" "a mutable STRING leaf is NOT isolated: the receipt accounts for an expansion computed from the MUTATED string while its stored source datum holds the pre-mutation text" :confirmed)
    (verdict "1b" "the string leaf is isolated: the receipt accounts for the expansion of the string as it stood at Door 1" :refuted))

;;; --- 1c: E11's claim, and a SAME-OBJECT probe ---------------------
(banner "FINDING 1c — E11 CONSTRUCTS A FRESH REQUEST, NOT THE SAME OBJECT")

(defparameter *live3* (fresh-source 1))
(defparameter *req3* (s1 request-expansion *live3* :macroexpand-1 (tag "f1c")))
(defparameter *occ-a* (occ-id (nth-value 2 (s1 perform-expansion *req3*))))
(setf (getf (cddr *live3*) :contract-version) 777)
(defparameter *occ-b* (occ-id (nth-value 2 (s1 perform-expansion *req3*))))
(line "SAME request object performed twice, caller mutated in between:")
(line "  occurrence identity #1 == #2 ... ~A" (same *occ-a* *occ-b*))
(if (not (same *occ-a* *occ-b*))
    (verdict "1c" "performing the SAME request object twice yields DIFFERENT occurrence identities when the caller's tree is mutated in between — E11 never tested this, it built a fresh equivalent request" :confirmed)
    (verdict "1c" "the SAME request object performed twice is stable across caller mutation" :refuted))

;;; ==================================================================
(banner "FINDING 2 — SHARED-STRUCTURE COLLAPSE")

;;; A GLOBAL EQ traversal, not an inference from printed forms.
(defun eq-census (form)
  "GLOBAL EQ traversal counting REFERENCES to each cons, not visits.
A cons reachable by two different paths gets a reference count of 2.
The earlier version of this function guarded before counting, so every count
was 1 and it could not have detected sharing at all — the defect it was written
to look for was invisible to it.
Returns (values DISTINCT-CONSES MAX-REFCOUNT SHARED-CONS-COUNT)."
  (let ((refs (make-hash-table :test 'eq)) (guard (make-hash-table :test 'eq)))
    (labels ((visit (f)
               (when (consp f)
                 (incf (gethash f refs 0))
                 (unless (gethash f guard)
                   (setf (gethash f guard) t)
                   (visit (car f))
                   (visit (cdr f))))))
      (visit form))
    (let ((maxref 0) (shared 0))
      (maphash (lambda (k v) (declare (ignore k))
                 (setf maxref (max maxref v))
                 (when (> v 1) (incf shared)))
               refs)
      (values (hash-table-count refs) maxref shared))))

(defparameter *sub* (list :verified-judged-claim))
(defparameter *shared* (list *sub* *sub*))            ; ONE cons in two positions
(defparameter *copies* (list (list :verified-judged-claim)
                             (list :verified-judged-claim)))  ; equal, distinct

(multiple-value-bind (dis mx sh) (eq-census *shared*)
  (line "shared tree : distinct conses ~D · max refcount ~D · shared conses ~D" dis mx sh))
(multiple-value-bind (dis mx sh) (eq-census *copies*)
  (line "copied tree : distinct conses ~D · max refcount ~D · shared conses ~D" dis mx sh))
(line "printed forms are EQUAL ....... ~A" (equal *shared* *copies*))
(line "trees are EQ-distinct ......... ~A" (not (eq (first *shared*) (first *copies*))))
(line "first two elements share a cons in the SHARED tree ... ~A"
      (eq (first *shared*) (second *shared*)))
(line "... and are distinct in the COPIED tree ............... ~A"
      (not (eq (first *copies*) (second *copies*))))

(defparameter *enc-shared* (handler-case (s1 encode-term *shared*)
                             (error (e) (format nil "REFUSED ~A" (type-of e)))))
(defparameter *enc-copies* (handler-case (s1 encode-term *copies*)
                             (error (e) (format nil "REFUSED ~A" (type-of e)))))
(line "")
(line "ENCODE-TERM(shared) ... ~A" (if (stringp *enc-shared*) *enc-shared* "encoded"))
(line "ENCODE-TERM(copies) ... ~A" (if (stringp *enc-copies*) *enc-copies* "encoded"))
(when (and (not (stringp *enc-shared*)) (not (stringp *enc-copies*)))
  (line "the two encodings are IDENTICAL ... ~A" (same *enc-shared* *enc-copies*)))

(if (and (not (stringp *enc-shared*))
         (same *enc-shared* *enc-copies*))
    (verdict "2" "sharing is SILENTLY UNFOLDED — a shared subtree and two distinct copies encode identically — while package.lisp claims 'a CIRCULAR OR SHARED structure — refused'" :confirmed)
    (verdict "2" "sharing is refused or distinguished" :refuted))

;;; Does a SPINE cycle still refuse?  (the part of the claim that IS true)
(defparameter *spine-cycle* (let ((x (list :a))) (setf (cdr x) x) x))
(line "spine cycle -> ~A"
      (handler-case (progn (s1 encode-term *spine-cycle*) "ENCODED (bad)")
        (error () "refused")))
;;; And a CAR cycle?
(defparameter *car-cycle* (let ((x (list :a))) (setf (car x) x) x))
(line "car cycle at ENCODE-TERM -> ~A"
      (handler-case (progn (s1 encode-term *car-cycle*) "ENCODED (bad)")
        (storage-condition () "stack exhausted")
        (error (e) (format nil "refused ~A" (type-of e)))))
(line "car cycle through DOOR 1 -> ~A"
      (multiple-value-bind (r f)
          (handler-case (s1 try-request-expansion (list 'cl:quote *car-cycle*)
                            :macroexpand-1 (tag "carcycle"))
            (storage-condition () (values nil :stack-exhausted)))
        (declare (ignore r))
        (if (keywordp f) f (and f (s1 expansion-refusal-code f)))))

;;; Do the REAL specimens contain internal sharing?  This decides whether a
;;; GLOBAL sharing refusal is even viable.
(banner "FINDING 2b — DO REAL EXPANSIONS CONTAIN SHARING?")
(dolist (spec (list
               (cons :admission (fresh-source 1))
               (cons :judgment (copy-tree
                                (list (find-symbol "DEFINE-JUDGMENT-SCHEMA" '#:lisp-plus-surface0)
                                      (intern "*REPRO-J*" '#:cl-user)
                                      :name :z :version 1
                                      :conclusion (list :predicate :z (list :v (list :var :v)))
                                      :premises (list (list :predicate :y (list :v (list :var :v))))
                                      :locals nil :unique-locals nil)))))
  (let ((src (cdr spec)))
    (multiple-value-bind (ds mx sh) (eq-census src)
      (line "~10@A SOURCE    distinct ~4D · max refcount ~D · SHARED ~D"
            (car spec) ds mx sh))
    (multiple-value-bind (ds mx sh) (eq-census (macroexpand-1 src nil))
      (line "~10@A EXPANSION distinct ~4D · max refcount ~D · SHARED ~D"
            (car spec) ds mx sh))))

;;; ==================================================================
(banner "FINDING 3 — NO OCCURRENCE OBJECT TYPE")

(line "EXPANSION-OCCURRENCE symbol present? .......... ~A"
      (and (find-symbol "EXPANSION-OCCURRENCE" '#:lisp-plus-surface1) t))
(line "EXPANSION-OCCURRENCE-P present? ............... ~A"
      (and (find-symbol "EXPANSION-OCCURRENCE-P" '#:lisp-plus-surface1) t))
(line "third value of PERFORM-EXPANSION is a ......... ~A"
      (type-of (nth-value 2 (s1 perform-expansion
                                (s1 request-expansion (fresh-source 1)
                                    :macroexpand-1 (tag "f3"))))))
(if (null (find-symbol "EXPANSION-OCCURRENCE-P" '#:lisp-plus-surface1))
    (verdict "3" "there is NO first-class occurrence object; the occurrence exists only as an identity value returned as a third value" :confirmed)
    (verdict "3" "a first-class immutable occurrence object exists and is the third value" :refuted))

;;; ==================================================================
(banner "FINDING 4 — PUBLIC CATALOGUE ACCESSOR")

(dolist (n '("REFUSAL-CATALOG-ENTRY-CODE" "REFUSAL-CATALOG-ENTRY-CLASS"
             "REFUSAL-CATALOG-ENTRY-PHASE" "REFUSAL-CATALOG-ENTRY-NOTE"
             "REFUSAL-CATALOG-ENTRY-REACHABILITY"))
  (multiple-value-bind (sym status) (find-symbol n '#:lisp-plus-surface1)
    (line "~44@A  status ~12@S  fbound ~A" n status (and sym (fboundp sym) t))))

(let ((sym (find-symbol "REFUSAL-CATALOG-ENTRY-REACHABILITY" '#:lisp-plus-surface1)))
  (if (and sym (fboundp sym)
           (not (eq :external (nth-value 1 (find-symbol
                                            "REFUSAL-CATALOG-ENTRY-REACHABILITY"
                                            '#:lisp-plus-surface1)))))
      (verdict "4" "REFUSAL-CATALOG-ENTRY-REACHABILITY is live but NON-EXTERNAL while its four sibling accessors are exported; the selftest reaches it through an internal symbol because its `s1` macro uses INTERN, which cannot tell internal from external" :confirmed)
      (verdict "4" "the accessor is exported" :refuted)))

;;; ==================================================================
(banner "SUMMARY")
(dolist (v (reverse *verdicts*))
  (format t "  ~9@A  ~A~%" (if (eq (second v) :confirmed) "CONFIRMED" "REFUTED") (first v)))
(format t "~%  confirmed: ~D of ~D~%"
        (count :confirmed *verdicts* :key #'second) (length *verdicts*))
;;; ONE CANONICAL, MACHINE-READABLE RESULT LINE.  A wrapper must be able to
;;; require that ALL verdicts executed, not merely that no CONFIRMED string was
;;; printed — a truncated instrument, a renamed label or an early exit all
;;; produce zero CONFIRMED lines while proving nothing.
(format t "~%REPRODUCTION-RESULT verdicts=~D expected=~D confirmed=~D~%"
        (length *verdicts*) 6 (count :confirmed *verdicts* :key #'second))
