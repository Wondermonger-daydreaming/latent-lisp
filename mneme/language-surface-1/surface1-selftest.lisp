;;;; surface1-selftest.lisp — Language Surface /1, Candidate /0: the teeth.
;;;;
;;;; Run: sbcl --non-interactive --load surface1-selftest.lisp
;;;;
;;;; This suite loads Surface /1 (which loads CD/0 ONLY) and then loads
;;;; Surface /0 SEPARATELY, as a client would, so that the layer's own load
;;;; graph is observable rather than asserted: check A1 records that Surface /1
;;;; came up with Surface /0 absent.
;;;;
;;;; Every green here is SELF-CONSISTENCY CERTIFICATION by the family that wrote
;;;; the layer.  The stranger audit is OWED.

(defparameter *here* (or *load-truename* *default-pathname-defaults*))

;;; --- A1 is measured BEFORE anything else can perturb it. -------------
(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "surface1.lisp" *here*)))
(defparameter *surface0-absent-after-surface1-load*
  (not (find-package '#:lisp-plus-surface0)))

;;; Now Surface /0, as a client.
(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "../language-surface-0/surface0.lisp" *here*)))

(defpackage #:surface1-selftest (:use #:common-lisp))
(in-package #:surface1-selftest)

(defmacro s1 (name &rest args)
  "ERRATA 0.1 — finding 4, second half.  Candidate /0's version used INTERN,
which cannot tell an internal symbol from an external one, so the suite reached
a NON-EXPORTED accessor without noticing.  This one resolves through
FIND-SYMBOL and refuses at macroexpansion time unless the symbol is EXTERNAL —
so a suite can no longer silently depend on a private name."
  (multiple-value-bind (sym status) (find-symbol (string name) '#:lisp-plus-surface1)
    (unless (eq status :external)
      (error "S1: ~A is ~:[absent~;~:*~A~] in LISP-PLUS-SURFACE1, not :EXTERNAL"
             (string name) status))
    `(,sym ,@args)))
(defmacro cd0 (name &rest args) `(,(intern (string name) '#:lisp-plus-cd0) ,@args))

(defparameter *checks* 0)
(defparameter *failed* 0)
(defun ok (label condition &optional detail)
  (incf *checks*)
  (if condition
      (format t "  [~3,'0D] ok   ~A~%" *checks* label)
      (progn (incf *failed*)
             (format t "  [~3,'0D] FAIL ~A~@[  ~A~]~%" *checks* label detail))))
(defun section (title) (format t "~%── ~A~%" title))

(defun tag (&rest path) (cd0 make-identifier-datum '("surface1-selftest") path))
(defun same (a b) (cd0 equal-datum a b))
(defun refusal-of (thunk)
  "Run THUNK; return the Surface /1 refusal object it produced, or NIL."
  (handler-case (progn (funcall thunk) nil)
    (lisp-plus-surface1:expansion-refused (c)
      (lisp-plus-surface1:expansion-condition-refusal c))))

;;; The one specimen, chosen because EVERY field of it is literal syntax:
;;; nothing in the source is evaluated, so the expansion is a pure function of
;;; the source text.
(defparameter *specimen*
  '(lisp-plus-surface0:define-admission-contract cl-user::*s1-contract*
    :contract-id :surface1/selftest
    :contract-version 1
    :accepted-clauses ((:verified-judged-claim))
    :proposition-relation :exact-normalized-equality
    :receiver-accessibility :required
    :retain (:contract-snapshot :support-identity :support-basis :source-basis)))

(format t "~&LANGUAGE SURFACE /1 — CANDIDATE /0 — SELFTEST~%")
(format t "SBCL ~A · grammar v~D · procedure v~D · policy v~D~%"
        (lisp-implementation-version)
        (s1 expansion-grammar-version)
        (s1 expansion-procedure-version)
        (s1 expansion-policy-version))

;;; ==================================================================
(section "A. LOAD GRAPH AND LAYER IDENTITY")

(ok "A1 Surface /1 loaded with Surface /0 ABSENT — it loads CD/0 only"
    cl-user::*surface0-absent-after-surface1-load*)
(ok "A2 Surface /0 is present now, loaded separately as a client"
    (and (find-package '#:lisp-plus-surface0) t))
(ok "A3 grammar, procedure and policy identities are three DISTINCT identifiers"
    (and (not (same (s1 expansion-grammar-identity) (s1 expansion-procedure-identity)))
         (not (same (s1 expansion-procedure-identity) (s1 expansion-policy-identity)))
         (not (same (s1 expansion-grammar-identity) (s1 expansion-policy-identity)))))
(ok "A4 every layer identity is a CD/0 IDENTIFIER datum, never a host symbol"
    (every (lambda (d) (cd0 identifier-datum-p d))
           (list (s1 expansion-grammar-identity)
                 (s1 expansion-procedure-identity)
                 (s1 expansion-policy-identity))))
(ok "A5 IDENTITY-OCTETS reports the encoded octet length — the unit every
        ceiling in this layer is denominated in"
    (let ((n (s1 identity-octets (cd0 make-bytes-datum (cd0 canonical-octets (tag "x"))))))
      (and (integerp n) (plusp n))))
(defparameter *probe-tag* (tag "identity" "probe"))
(defparameter *probe-req*
  (s1 request-expansion *specimen* :macroexpand-1 *probe-tag*))
(ok "A5b a minted request identity is a CD/0 BYTES datum, not a string"
    (cd0 bytes-datum-p (s1 expansion-request-identity *probe-req*)))
(ok "A6 there is NO surface-0-version anywhere in the exported surface"
    (null (remove-if-not
           (lambda (s) (search "SURFACE0" (symbol-name s)))
           (let (acc) (do-external-symbols (s '#:lisp-plus-surface1) (push s acc)) acc)))
    "Surface /0 declares no version; this layer must not mint one for it")

;;; ==================================================================
(section "B. THE REFUSAL CATALOGUE — one table, two derived lists, no flat list")

(defparameter *catalog* (s1 expansion-refusal-code-catalog))
(defparameter *protocol* (s1 expansion-protocol-refusal-codes))
(defparameter *integrity* (s1 expansion-integrity-alarm-codes))

(ok "B1 the two derived lists partition the catalogue exactly"
    (and (= (length *catalog*) (+ (length *protocol*) (length *integrity*)))
         (null (intersection *protocol* *integrity*))))
(ok "B2 every catalogue code is unique"
    (= (length *catalog*)
       (length (remove-duplicates (mapcar (lambda (e) (s1 refusal-catalog-entry-code e))
                                          *catalog*)))))
(ok "B3 every entry declares a class, a phase and a reachability"
    (every (lambda (e) (and (member (s1 refusal-catalog-entry-class e)
                                    '(:protocol-refusal :integrity-alarm))
                            (member (s1 refusal-catalog-entry-phase e)
                                    '(:request :perform :receipt))
                            (member (s1 refusal-catalog-entry-reachability e)
                                    '(:public-api :public-api-in-a-stub-image
                                      :unreachable-under-this-policy
                                      :internal-planted-fault-only))))
           *catalog*))
(ok "B4 the two deleted false affordances are ABSENT and stay absent"
    (and (null (assoc :construct-package-absent *catalog*))
         (null (assoc :construct-symbol-absent *catalog*)))
    "no caller can reach a package lookup that already matched on that package's name")
(ok "B5 no FORBIDDEN VOCABULARY word appears in any code, class or phase name"
    (notany (lambda (e)
              (let ((s (string-upcase (format nil "~S" e))))
                (some (lambda (w) (search w s))
                      '("REPAIR" "PRESERV" "EQUIVALEN" "NORMALIZ" "CORRECT"
                        "IMPROVE" "HYGIEN" "SAME-MEANING" "FAITHFUL" "PORTABLE"
                        "VERIFIED" "SOUND"))))
            (mapcar (lambda (e) (list (s1 refusal-catalog-entry-code e)
                                      (s1 refusal-catalog-entry-class e)
                                      (s1 refusal-catalog-entry-phase e)))
                    *catalog*)))
(ok "B6 the DISPOSITIONS name the operation that ran, with no adverb"
    (let ((d (mapcar (lambda (op)
                       (s1 expansion-receipt-disposition
                           (s1 perform-expansion
                               (s1 request-expansion *specimen* op (tag "disp" (string op))))))
                     (s1 expansion-operations))))
      (equal d '(:macroexpanded-one-step :macroexpanded-repeatedly))))

;;; ==================================================================
(section "C. THE TERM GRAMMAR — what it represents, and what it refuses")

(ok "C1 the term inventory is exactly four kinds"
    (equal (s1 term-kinds) '("SYMBOL" "INTEGER" "STRING" "LIST")))
(ok "C2 a symbol encodes as an identifier of package-name / symbol-name"
    (let ((d (s1 encode-term 'cl:car)))
      (and (cd0 record-datum-p d)
           (same (cd0 record-datum-ref d (cd0 make-identifier-datum '("TERM") '("VALUE")))
                 (cd0 make-identifier-datum '("COMMON-LISP") '("CAR"))))))
(ok "C3 NIL encodes as the SYMBOL COMMON-LISP:NIL — the host does not separate
        the empty list from the symbol, and the grammar does not pretend to"
    (same (s1 encode-term 'nil) (s1 encode-term '())))
(ok "C4 integers, strings and lists each encode"
    (and (cd0 record-datum-p (s1 encode-term 42))
         (cd0 record-datum-p (s1 encode-term "text"))
         (cd0 record-datum-p (s1 encode-term '(1 "two" three)))))
(ok "C5 case is preserved exactly — |lower| and LOWER are different terms"
    (not (same (s1 encode-term (intern "lower" '#:cl-user))
               (s1 encode-term (intern "LOWER" '#:cl-user)))))
(ok "C6 every encoded specimen term DECODES — construction is not enough,
        because CD/0 enforces max-depth on decode and not at construction"
    (let ((d (s1 encode-term *specimen*)))
      (same d (cd0 decode-exact (cd0 canonical-octets d)))))

;;; ==================================================================
(section "D. DOOR 1 — describes; does not expand")

(ok "D1 a request mints an identity, a source datum and a source identity"
    (and (s1 expansion-request-p *probe-req*)
         (cd0 bytes-datum-p (s1 expansion-request-identity *probe-req*))
         (cd0 record-datum-p (s1 expansion-request-source-form-datum *probe-req*))
         (cd0 bytes-datum-p (s1 expansion-request-source-form-identity *probe-req*))))
(ok "D2 the source-form identity is the identity OF the stored source datum"
    (same (s1 expansion-request-source-form-identity *probe-req*)
          (cd0 make-bytes-datum
               (cd0 canonical-octets (s1 expansion-request-source-form-datum *probe-req*)))))
(ok "D3 DOOR 1 ACCEPTS a head that names no known construct —
        a request that can never be performed is still a lawful request"
    (s1 expansion-request-p
        (s1 request-expansion '(cl:list 1 2) :macroexpand-1 (tag "d3"))))
(ok "D4 ... and its construct identity is ABSENT rather than invented"
    (null (s1 expansion-request-construct-identity
              (s1 request-expansion '(cl:list 1 2) :macroexpand-1 (tag "d4")))))
(ok "D5 a non-cons source form refuses :SOURCE-FORM-NOT-A-CALL"
    (eq :source-form-not-a-call
        (s1 expansion-refusal-code
            (refusal-of (lambda () (s1 request-expansion 7 :macroexpand-1 (tag "d5")))))))
(ok "D6 a non-symbol head refuses :SOURCE-FORM-HEAD-NOT-A-SYMBOL"
    (eq :source-form-head-not-a-symbol
        (s1 expansion-refusal-code
            (refusal-of (lambda () (s1 request-expansion '((1) 2) :macroexpand-1 (tag "d6")))))))
(ok "D7 an undeclared operation refuses :OPERATION-NOT-DECLARED
        — there is no :MACROEXPAND-ALL and this layer offers no code walker"
    (eq :operation-not-declared
        (s1 expansion-refusal-code
            (refusal-of (lambda () (s1 request-expansion *specimen* :macroexpand-all (tag "d7")))))))
(ok "D8 a non-identifier occurrence tag refuses — there is NO default tag"
    (eq :occurrence-tag-not-identifier
        (s1 expansion-refusal-code
            (refusal-of (lambda () (s1 request-expansion *specimen* :macroexpand-1 "a string"))))))
(ok "D9 a gensym in the SOURCE refuses at DOOR 1, upstream reason preserved"
    (let ((r (refusal-of (lambda ()
                           (s1 request-expansion (list 'cl:quote (gensym "G"))
                               :macroexpand-1 (tag "d9"))))))
      (and (eq :source-term-unrepresentable (s1 expansion-refusal-code r))
           (string= "UNINTERNED-SYMBOL" (s1 expansion-refusal-upstream-code r))
           (string= "term-encode" (s1 expansion-refusal-upstream-stage r)))))
(ok "D10 an improper list in the source refuses, upstream reason preserved"
    (let ((r (refusal-of (lambda ()
                           (s1 request-expansion (cons 'cl:car (cons 1 2))
                               :macroexpand-1 (tag "d10"))))))
      (and (eq :source-term-unrepresentable (s1 expansion-refusal-code r))
           (string= "IMPROPER-LIST" (s1 expansion-refusal-upstream-code r)))))
(ok "D11 a host object with no term kind refuses (a character)"
    (let ((r (refusal-of (lambda ()
                           (s1 request-expansion (list 'cl:quote #\x)
                               :macroexpand-1 (tag "d11"))))))
      (and (eq :source-term-unrepresentable (s1 expansion-refusal-code r))
           (string= "NO-TERM-KIND" (s1 expansion-refusal-upstream-code r)))))
(ok "D12 a float refuses too — no printed-representation escape hatch exists"
    (eq :source-term-unrepresentable
        (s1 expansion-refusal-code
            (refusal-of (lambda () (s1 request-expansion (list 'cl:quote 1.5)
                                       :macroexpand-1 (tag "d12")))))))
(ok "D13 a source form deeper than the declared ceiling refuses"
    (let ((deep (let ((f 'cl:t))
                  (dotimes (i (+ 2 (s1 expansion-policy-max-source-depth))) (setf f (list f)))
                  (cons 'cl:quote (list f)))))
      (eq :source-depth-exceeded
          (s1 expansion-refusal-code
              (refusal-of (lambda () (s1 request-expansion deep :macroexpand-1 (tag "d13"))))))))
(ok "D14 a source form with more nodes than the ceiling refuses"
    (let ((wide (cons 'cl:quote (list (make-list (+ 2 (s1 expansion-policy-max-source-nodes))
                                                 :initial-element 'cl:t)))))
      (eq :source-nodes-exceeded
          (s1 expansion-refusal-code
              (refusal-of (lambda () (s1 request-expansion wide :macroexpand-1 (tag "d14"))))))))
(ok "D15 an encoded source term over the octet ceiling refuses"
    (let ((big (list 'cl:quote (make-string (1+ (s1 expansion-policy-max-term-octets))
                                            :initial-element #\a))))
      (eq :source-term-octets-exceeded
          (s1 expansion-refusal-code
              (refusal-of (lambda () (s1 request-expansion big :macroexpand-1 (tag "d15"))))))))
(ok "D16 the OPERATION is committed into the request identity, not inferred"
    (not (same (s1 expansion-request-identity
                   (s1 request-expansion *specimen* :macroexpand-1 (tag "same")))
               (s1 expansion-request-identity
                   (s1 request-expansion *specimen* :macroexpand (tag "same"))))))

;;; ==================================================================
(section "E. DOOR 2 — meets the image, and accounts for what it found")

(defparameter *r1* (s1 request-expansion *specimen* :macroexpand-1 (tag "e" "one")))
(defparameter *receipt* nil)
(defparameter *expanded* nil)
(defparameter *occ-id* nil)
(defparameter *occurrence* nil)
(multiple-value-setq (*receipt* *expanded* *occurrence*) (s1 perform-expansion *r1*))
(setf *occ-id* (s1 expansion-occurrence-identity *occurrence*))

(ok "E1 a completed expansion mints a receipt, an expanded form and a
        FIRST-CLASS OCCURRENCE OBJECT (errata 0.1, finding 3)"
    (and (s1 expansion-receipt-p *receipt*) (consp *expanded*)
         (s1 expansion-occurrence-p *occurrence*)
         (cd0 bytes-datum-p *occ-id*)))
(ok "E2 the expanded host form is EXACTLY what MACROEXPAND-1 returns"
    (equal *expanded* (macroexpand-1 *specimen* nil)))
(ok "E3 the receipt's expanded datum is the encoding of that exact form"
    (same (s1 expansion-receipt-expanded-form-datum *receipt*)
          (cd0 decode-exact (cd0 canonical-octets (s1 encode-term *expanded*)))))
(ok "E4 the receipt's source datum is the encoding of the exact source form"
    (same (s1 expansion-receipt-source-form-datum *receipt*)
          (cd0 decode-exact (cd0 canonical-octets (s1 encode-term *specimen*)))))
(ok "E5 both stored identities equal the identities of their stored data"
    (and (same (s1 expansion-receipt-source-form-identity *receipt*)
               (cd0 make-bytes-datum
                    (cd0 canonical-octets (s1 expansion-receipt-source-form-datum *receipt*))))
         (same (s1 expansion-receipt-expanded-form-identity *receipt*)
               (cd0 make-bytes-datum
                    (cd0 canonical-octets (s1 expansion-receipt-expanded-form-datum *receipt*))))))
(ok "E6 the receipt records the operation and the construct identity"
    (and (eq :macroexpand-1 (s1 expansion-receipt-operation *receipt*))
         (same (s1 expansion-receipt-construct-identity *receipt*)
               (s1 construct-identity-for "LISP-PLUS-SURFACE0" "DEFINE-ADMISSION-CONTRACT"))))
(ok "E7 the receipt carries the request and occurrence identities it was minted from"
    (and (same (s1 expansion-receipt-request-identity *receipt*)
               (s1 expansion-request-identity *r1*))
         (same (s1 expansion-receipt-occurrence-identity *receipt*) *occ-id*)))
(ok "E8 procedure and policy versions come from the PACKAGE, not from a slot —
        a receipt cannot disagree with the package that minted it"
    (and (eql (s1 expansion-receipt-procedure-version *receipt*) (s1 expansion-procedure-version))
         (eql (s1 expansion-receipt-policy-version *receipt*) (s1 expansion-policy-version))))
(ok "E9 the expansion CONTEXT records only what was SUPPLIED, and denies capture"
    (let ((ctx (s1 expansion-receipt-expansion-context *receipt*)))
      (and (same (cd0 record-datum-ref ctx (cd0 make-identifier-datum
                                            '("CONTEXT") '("SUPPLIED-LEXICAL-ENVIRONMENT")))
                 (cd0 make-identifier-datum '("lisp-plus-surface1" "environment") '("null")))
           (same (cd0 record-datum-ref ctx (cd0 make-identifier-datum
                                            '("CONTEXT") '("ENVIRONMENT-OBJECT-CAPTURED")))
                 (cd0 make-boolean-datum nil)))))
(ok "E10 the whole receipt's own identity is a bytes datum and is stable"
    (and (cd0 bytes-datum-p (s1 expansion-receipt-identity *receipt*))
         (same (s1 expansion-receipt-identity *receipt*)
               (s1 expansion-receipt-identity *receipt*))))
(ok "E11 two SEPARATE requests with equal inputs give the SAME occurrence
        identity.  NOTE THE WORDING: Candidate /0 labelled this 'the same
        request performed twice', which it never was — it built a fresh
        equivalent request.  The same-object claim is E11b."
    (let ((again (s1 expansion-occurrence-identity
                     (nth-value 2 (s1 perform-expansion
                                      (s1 request-expansion *specimen* :macroexpand-1
                                          (tag "e" "one")))))))
      (same again *occ-id*)))
(ok "E11b the SAME REQUEST OBJECT performed twice gives the same occurrence
        identity — the claim E11 was mislabelled as making"
    (let ((a (s1 expansion-occurrence-identity (nth-value 2 (s1 perform-expansion *r1*))))
          (b (s1 expansion-occurrence-identity (nth-value 2 (s1 perform-expansion *r1*)))))
      (and (same a b) (same a *occ-id*))))
(ok "E12 a DIFFERENT occurrence tag gives a DIFFERENT occurrence identity"
    (let ((other (s1 expansion-occurrence-identity
                     (nth-value 2 (s1 perform-expansion
                                      (s1 request-expansion *specimen* :macroexpand-1
                                          (tag "e" "other")))))))
      (not (same other *occ-id*))))
(ok "E13 an unknown head reaches DOOR 2 and refuses there, minting NOTHING"
    (let ((r (refusal-of (lambda ()
                           (s1 perform-expansion
                               (s1 request-expansion '(cl:list 1 2) :macroexpand-1 (tag "e13")))))))
      (and (eq :not-a-known-surface-construct (s1 expansion-refusal-code r))
           (eq :perform (s1 expansion-refusal-phase r)))))
(ok "E14 TRY-PERFORM returns THREE values on BOTH branches, so a refusal
        cannot be destructured as a success"
    (and (= 3 (length (multiple-value-list (s1 try-perform-expansion *r1*))))
         (= 3 (length (multiple-value-list
                       (s1 try-perform-expansion
                           (s1 request-expansion '(cl:list 1) :macroexpand-1 (tag "e14"))))))))

;;; ==================================================================
(section "F. THE OPERATION DISTINCTION — one step vs repeated")

(defparameter *full-receipt*
  (s1 perform-expansion (s1 request-expansion *specimen* :macroexpand (tag "f" "full"))))

(ok "F1 for this specimen the two operations produce the SAME expanded form,
        because the expansion's head is PROGN, a special operator"
    (same (s1 expansion-receipt-expanded-form-identity *receipt*)
          (s1 expansion-receipt-expanded-form-identity *full-receipt*)))
(ok "F2 ... and the receipts are NEVERTHELESS DIFFERENT, because the operation
        is part of the account rather than derived from the result"
    (and (not (same (s1 expansion-receipt-identity *receipt*)
                    (s1 expansion-receipt-identity *full-receipt*)))
         (not (eq (s1 expansion-receipt-disposition *receipt*)
                  (s1 expansion-receipt-disposition *full-receipt*)))))
(ok "F3 the mechanism is checkable: the expansion's head is not a macro"
    (and (eq 'cl:progn (car (macroexpand-1 *specimen* nil)))
         (null (macro-function 'cl:progn))))

;;; The control forms DO differ, because HANDLER-CASE is itself a macro.
(defparameter *control-form*
  '(lisp-plus-surface0:derive-case (cl-user::c cl-user::r)
    (lisp-plus-slice1:derive :schema-name :x)
    (:granted cl-user::c) (:refused (cl-user::e) cl-user::e)))

(ok "F4 DERIVE-CASE's one-step expansion is accounted for cleanly"
    (s1 expansion-receipt-p
        (s1 perform-expansion
            (s1 request-expansion *control-form* :macroexpand-1 (tag "f4")))))
(ok "F5 ... and its FULL expansion is REFUSED, because HANDLER-CASE is a host
        macro.  ERRATA 0.1 CORRECTS THE CODE THIS CHECK USED TO ASSERT:
        Candidate /0 claimed :EXPANDED-TERM-UNREPRESENTABLE / UNINTERNED-SYMBOL.
        MEASURED, that expansion carries BOTH disqualifying properties — 3 conses
        reachable by more than one path AND 13 uninterned symbols — and since
        the global sharing check now runs first, the reported code is the
        SHARING one.  Reporting the first check that fires is correct; claiming
        the other code was not."
    (let ((r (refusal-of (lambda ()
                           (s1 perform-expansion
                               (s1 request-expansion *control-form* :macroexpand (tag "f5")))))))
      (and (eq :expanded-term-shared-structure (s1 expansion-refusal-code r))
           (string= "SHARED-OR-CIRCULAR-STRUCTURE" (s1 expansion-refusal-upstream-code r)))))
(ok "F5b ... and BOTH disqualifying properties are exhibited, not merely the one
        the refusal happened to name first"
    (let* ((full (macroexpand *control-form* nil))
           (atoms (labels ((a (f) (if (consp f) (append (a (car f)) (a (cdr f))) (list f))))
                    (a full)))
           (gensyms (remove-if #'symbol-package (remove-if-not #'symbolp atoms))))
      (and (plusp (length gensyms))
           ;; and a gensym-bearing expansion with NO sharing lands on the OTHER
           ;; code, so the two are genuinely distinguished rather than merged
           (let ((r (refusal-of
                     (lambda ()
                       (s1 perform-expansion
                           (s1 request-expansion
                               '(lisp-plus-surface0:derive-case (cl-user::c cl-user::r)
                                 (lisp-plus-slice1:derive :schema-name :x)
                                 (:granted cl-user::c) (:refused (nil) 1))
                               :macroexpand-1 (tag "f5b")))))))
             (eq :expanded-term-unrepresentable (s1 expansion-refusal-code r))))))
(ok "F6 the two operations genuinely differ for that form at the host level"
    (not (equal (macroexpand-1 *control-form* nil) (macroexpand *control-form* nil))))

;;; ==================================================================
(section "G. THE NON-DETERMINISM REFUSAL — the reason the boundary exists")
;;;
;;; Surface /0's %PARSE-ARMS accepts `(:refused (nil) ...)`: its guard omits the
;;; non-NIL conjunct that its sibling guard for the claim/receipt variables has.
;;; The dormant `(or refused-var (gensym "COND"))` therefore fires, and the SAME
;;; SOURCE FORM EXPANDS DIFFERENTLY EACH TIME.
;;;
;;; SURFACE /1 DOES NOT REPAIR THIS.  The observer accounts for the expansion
;;; that exists; it must never manufacture a friendlier one and then certify its
;;; own handiwork.  It refuses, and the refusal is the point: a receipt for a
;;; non-deterministic expansion would be an account that could not be true twice.

(defparameter *nondet-form*
  '(lisp-plus-surface0:derive-case (cl-user::c cl-user::r)
    (lisp-plus-slice1:derive :schema-name :x)
    (:granted cl-user::c) (:refused (nil) 1)))

(ok "G1 the host really does expand that form differently twice"
    (not (equal (macroexpand-1 *nondet-form* nil) (macroexpand-1 *nondet-form* nil))))
(ok "G2 Surface /1 REFUSES it at ONE-STEP expansion, not merely at full expansion"
    (let ((r (refusal-of (lambda ()
                           (s1 perform-expansion
                               (s1 request-expansion *nondet-form* :macroexpand-1 (tag "g2")))))))
      (and (eq :expanded-term-unrepresentable (s1 expansion-refusal-code r))
           (string= "UNINTERNED-SYMBOL" (s1 expansion-refusal-upstream-code r)))))
(ok "G3 the refusal mints NO occurrence and NO receipt — the objects do not come
        into existence, they are not nil-valued"
    (multiple-value-bind (rc ex rf)
        (s1 try-perform-expansion
            (s1 request-expansion *nondet-form* :macroexpand-1 (tag "g3")))
      (and (null rc) (null ex) (s1 expansion-refusal-p rf))))
(ok "G4 Surface /0 IS UNMODIFIED BY THIS SUITE — the defect is reported, not repaired"
    (not (equal (macroexpand-1 *nondet-form* nil) (macroexpand-1 *nondet-form* nil))))

;;; ==================================================================
(section "H. DISCRIMINATION — a changed source changes the account")

(defparameter *specimen-v2*
  '(lisp-plus-surface0:define-admission-contract cl-user::*s1-contract*
    :contract-id :surface1/selftest
    :contract-version 2
    :accepted-clauses ((:verified-judged-claim))
    :proposition-relation :exact-normalized-equality
    :receiver-accessibility :required
    :retain (:contract-snapshot :support-identity :support-basis :source-basis)))

(defparameter *receipt-v2*
  (s1 perform-expansion (s1 request-expansion *specimen-v2* :macroexpand-1 (tag "e" "one"))))

(ok "H1 a changed source form changes the SOURCE identity"
    (not (same (s1 expansion-receipt-source-form-identity *receipt*)
               (s1 expansion-receipt-source-form-identity *receipt-v2*))))
(ok "H2 ... and changes the EXPANDED identity"
    (not (same (s1 expansion-receipt-expanded-form-identity *receipt*)
               (s1 expansion-receipt-expanded-form-identity *receipt-v2*))))
(ok "H3 ... and therefore changes the OCCURRENCE identity, even with the SAME tag"
    (not (same (s1 expansion-receipt-occurrence-identity *receipt*)
               (s1 expansion-receipt-occurrence-identity *receipt-v2*))))
(ok "H4 ... and the RECEIPT identity"
    (not (same (s1 expansion-receipt-identity *receipt*)
               (s1 expansion-receipt-identity *receipt-v2*))))
(ok "H5 a one-character difference in a symbol NAME is discriminated"
    (not (same (s1 encode-term '(cl-user::abc)) (s1 encode-term '(cl-user::abd)))))

;;; ==================================================================
(section "I. NON-PROMOTION — later handling flows nowhere backward")
;;;
;;; The expanded form is EVALUATED here, producing a REAL Slice /2 admission
;;; contract through Slice /2's own public constructor.  That is a genuine
;;; downstream success.  The receipt must be byte-identical afterwards and must
;;; still claim exactly what it claimed before: what form became what other form.

(defparameter *receipt-octets-before*
  (cd0 octets-to-hex (cd0 canonical-octets (s1 expansion-receipt-identity *receipt*))))
(defparameter *expanded-octets-before*
  (cd0 octets-to-hex (cd0 canonical-octets (s1 expansion-receipt-expanded-form-datum *receipt*))))

(defparameter *evaluated* (eval *expanded*))
(defparameter *made-contract* (symbol-value 'cl-user::*s1-contract*))

(ok "I1 evaluating the expansion really does produce a Slice /2 contract object"
    (and *evaluated* (lisp-plus-slice2:support-admission-contract-p *made-contract*)))
(ok "I2 the receipt identity is byte-identical after that downstream success"
    (string= *receipt-octets-before*
             (cd0 octets-to-hex (cd0 canonical-octets (s1 expansion-receipt-identity *receipt*)))))
(ok "I3 the stored expanded datum is byte-identical after it"
    (string= *expanded-octets-before*
             (cd0 octets-to-hex
                  (cd0 canonical-octets (s1 expansion-receipt-expanded-form-datum *receipt*)))))
(ok "I4 the receipt gained NO field naming the object that evaluation produced"
    (notany (lambda (slot) (search "CONTRACT" (symbol-name slot)))
            '(#:identity #:request-identity #:occurrence-identity #:source-form-datum
              #:source-form-identity #:expanded-form-datum #:expanded-form-identity
              #:operation #:expansion-context #:disposition))
    "CONSTRUCT-IDENTITY names the macro asked about, never a produced object")
(ok "I5 the disposition is unchanged by downstream success"
    (eq :macroexpanded-one-step (s1 expansion-receipt-disposition *receipt*)))
(ok "I6 a FAILING downstream evaluation leaves the receipt equally unchanged"
    (let* ((bad (s1 perform-expansion
                    (s1 request-expansion
                        '(lisp-plus-surface0:define-admission-contract cl-user::*s1-bad*
                          :contract-id :surface1/bad :contract-version 99
                          :accepted-clauses ((:no-such-clause-family))
                          :proposition-relation :exact-normalized-equality
                          :receiver-accessibility :required :retain (:contract-snapshot :support-identity :support-basis :source-basis))
                        :macroexpand-1 (tag "i6"))))
           (before (cd0 octets-to-hex (cd0 canonical-octets (s1 expansion-receipt-identity bad)))))
      (handler-case (eval (nth-value 1 (s1 try-perform-expansion
                                           (s1 request-expansion
                                               '(lisp-plus-surface0:define-admission-contract
                                                 cl-user::*s1-bad*
                                                 :contract-id :surface1/bad :contract-version 99
                                                 :accepted-clauses ((:no-such-clause-family))
                                                 :proposition-relation :exact-normalized-equality
                                                 :receiver-accessibility :required
                                                 :retain (:contract-snapshot :support-identity :support-basis :source-basis))
                                               :macroexpand-1 (tag "i6b")))))
        (error () nil))
      (string= before
               (cd0 octets-to-hex (cd0 canonical-octets (s1 expansion-receipt-identity bad)))))
    "an unknown clause family is Slice /2's refusal to make; the receipt is untouched either way")

;;; ==================================================================
(section "J. SURFACE /0'S OWN REFUSAL ESCAPES, AND MINTS NOTHING HERE")

(defparameter *malformed*
  '(lisp-plus-surface0:define-admission-contract cl-user::*s1-x* :contract-id :only))

(ok "J1 a malformed construct signals SURFACE /0's condition, not Surface /1's"
    (handler-case (progn (s1 perform-expansion
                             (s1 request-expansion *malformed* :macroexpand-1 (tag "j1")))
                         nil)
      (lisp-plus-surface1:expansion-refused () nil)
      (lisp-plus-surface0:surface-syntax-refused () t)))
(ok "J2 ... carrying Surface /0's OWN reason keyword, unwrapped and unreclassified"
    (handler-case (progn (s1 perform-expansion
                             (s1 request-expansion *malformed* :macroexpand-1 (tag "j2")))
                         nil)
      (lisp-plus-surface0:surface-syntax-refused (c)
        (eq :missing-field (lisp-plus-surface0:surface-syntax-refused-reason c)))))
(ok "J3 TRY-PERFORM does NOT convert it either — the twin catches only this
        layer's refusals, never another layer's verdict"
    (handler-case (progn (s1 try-perform-expansion
                             (s1 request-expansion *malformed* :macroexpand-1 (tag "j3")))
                         nil)
      (lisp-plus-surface0:surface-syntax-refused () t)))

;;; ==================================================================
(section "K. PLANTED FAULTS — a gate that has never fired is untested")

(ok "K1 with no fault bound, the same expansion is green (the teeth are not stuck on)"
    (s1 expansion-receipt-p
        (s1 perform-expansion (s1 request-expansion *specimen* :macroexpand-1 (tag "k1")))))
(ok "K2 a wrong stored SOURCE identity produces NO receipt"
    (let ((r (let ((lisp-plus-surface1::*%fault-source-identity*
                     (cd0 make-bytes-datum (cd0 canonical-octets (tag "wrong")))))
               (refusal-of (lambda () (s1 perform-expansion
                                          (s1 request-expansion *specimen* :macroexpand-1
                                              (tag "k2"))))))))
      (eq :source-identity-projection-mismatch (s1 expansion-refusal-code r))))
(ok "K3 a wrong stored EXPANDED identity produces NO receipt"
    (let ((r (let ((lisp-plus-surface1::*%fault-expanded-identity*
                     (cd0 make-bytes-datum (cd0 canonical-octets (tag "wrong")))))
               (refusal-of (lambda () (s1 perform-expansion
                                          (s1 request-expansion *specimen* :macroexpand-1
                                              (tag "k3"))))))))
      (eq :expanded-identity-projection-mismatch (s1 expansion-refusal-code r))))
(ok "K4 an altered procedure version produces NO receipt"
    (let ((r (let ((lisp-plus-surface1::*%fault-procedure-version* 99))
               (refusal-of (lambda () (s1 perform-expansion
                                          (s1 request-expansion *specimen* :macroexpand-1
                                              (tag "k4"))))))))
      (eq :procedure-version-mismatch (s1 expansion-refusal-code r))))
(ok "K5 after the faults unwind, the layer is green again"
    (s1 expansion-receipt-p
        (s1 perform-expansion (s1 request-expansion *specimen* :macroexpand-1 (tag "k5")))))

;;; ==================================================================
(section "L. IMMUTABILITY AND THE ABSENT CONSTRUCTORS")

(ok "L1 no public constructor mints a request, a receipt or a refusal"
    (notany (lambda (n) (eq :external (nth-value 1 (find-symbol n '#:lisp-plus-surface1))))
            '("MAKE-EXPANSION-REQUEST" "MAKE-EXPANSION-RECEIPT" "MAKE-EXPANSION-REFUSAL"
              "%MAKE-REQUEST" "%MAKE-RECEIPT" "%MAKE-REFUSAL")))
(ok "L2 no copier is exported for any minted object"
    (notany (lambda (n) (find-symbol n '#:lisp-plus-surface1))
            '("COPY-EXPANSION-REQUEST" "COPY-EXPANSION-RECEIPT" "COPY-EXPANSION-REFUSAL")))
(ok "L3 the exported surface exposes no setter of any kind"
    (let (acc) (do-external-symbols (s '#:lisp-plus-surface1) (push (symbol-name s) acc))
         (notany (lambda (n) (or (search "SET-" n) (search "-SET" n))) acc)))
(ok "L4 the retained host form is NOT exported — it never reaches a receipt"
    (not (eq :external (nth-value 1 (find-symbol "EXPANSION-REQUEST-%HOST-FORM"
                                                 '#:lisp-plus-surface1)))))

;;; EXPORT CENSUS, reconciled BOTH WAYS.  A declared export that names nothing is
;;; a false affordance; a live definition nobody declared is an accidental
;;; surface.  NOTE the third predicate: a CONDITION CLASS is neither FBOUNDP nor
;;; BOUNDP, and a census that checked only those two would report the layer's
;;; own condition type as dead.  The first draft of this check did exactly that.
(defparameter *declared* '())
(defparameter *dead* '())
(do-external-symbols (s '#:lisp-plus-surface1)
  (push s *declared*)
  (unless (or (fboundp s) (boundp s) (find-class s nil))
    (push s *dead*)))

(ok "L5 EXPORT CENSUS — every declared export names a live function, variable
        or condition class; nothing is a false affordance"
    (null *dead*) (format nil "~S" *dead*))
(ok "L6 ... and the count is stated rather than left implicit"
    (= 75 (length *declared*))
    (format nil "declared ~D" (length *declared*)))
(ok "L7 ERRATA 0.1 — the catalogue accessor that was live-but-internal is now
        EXPORTED, and its four siblings still are"
    (every (lambda (n) (eq :external (nth-value 1 (find-symbol n '#:lisp-plus-surface1))))
           '("REFUSAL-CATALOG-ENTRY-CODE" "REFUSAL-CATALOG-ENTRY-CLASS"
             "REFUSAL-CATALOG-ENTRY-PHASE" "REFUSAL-CATALOG-ENTRY-NOTE"
             "REFUSAL-CATALOG-ENTRY-REACHABILITY")))
(ok "L8 ... and the request no longer carries a caller-owned host form at all —
        the slot is GONE, not guarded"
    (null (find-symbol "EXPANSION-REQUEST-%HOST-FORM" '#:lisp-plus-surface1)))

;;; ==================================================================
(section "M. REFUSAL-CODE COVERAGE — set difference, both directions")

(defparameter *exercised*
  '(:source-form-not-a-call :source-form-head-not-a-symbol :operation-not-declared
    :occurrence-tag-not-identifier :source-term-unrepresentable :source-depth-exceeded
    :source-nodes-exceeded :source-term-octets-exceeded :not-a-known-surface-construct
    :expanded-term-unrepresentable
    ;; ERRATA 0.1
    :source-term-shared-structure :expanded-term-shared-structure
    :source-not-reconstructible
    :source-identity-projection-mismatch :expanded-identity-projection-mismatch
    :procedure-version-mismatch))

(defun codes-with-reachability (r)
  (mapcar (lambda (e) (s1 refusal-catalog-entry-code e))
          (remove-if-not (lambda (e) (eq r (s1 refusal-catalog-entry-reachability e)))
                         *catalog*)))

(defparameter *public-api-codes* (codes-with-reachability :public-api))

(ok "M1 every code exercised above is DECLARED in the catalogue"
    (null (set-difference *exercised* (mapcar (lambda (e) (s1 refusal-catalog-entry-code e))
                                              *catalog*))))
(ok "M2 the :PUBLIC-API codes this suite does not exercise are exactly the two
        expanded-side ceilings the APPLICATION drives to their edges — depth and
        term-octets.  Nothing else is left uncovered."
    (equal (sort (copy-list (set-difference *public-api-codes* *exercised*)) #'string<)
           '(:expanded-depth-exceeded :expanded-term-octets-exceeded)))
(ok "M3 exactly one code is declared reachable only in a stub image"
    (equal '(:construct-not-a-macro) (codes-with-reachability :public-api-in-a-stub-image)))
(ok "M4 exactly one code is declared UNREACHABLE UNDER THIS POLICY, and it is the
        expanded-side NODE ceiling — dominated by the octet ceiling, measured"
    (equal '(:expanded-nodes-exceeded) (codes-with-reachability :unreachable-under-this-policy)))
(ok "M5 ... and its SOURCE-side twin IS reachable, because the node check runs
        BEFORE the encode — so the pair is not symmetric, and saying so is the
        difference between a measured claim and a tidy one"
    (member :source-nodes-exceeded *exercised*))
(ok "M6 the arithmetic behind M4, exhibited rather than asserted: one term costs
        far more than 262144/20000 = 13 octets, so octets must fire first"
    (let ((one-term-octets (cd0 octets-length (cd0 canonical-octets (s1 encode-term 'cl:t)))))
      (> one-term-octets (/ (s1 expansion-policy-max-term-octets)
                            (s1 expansion-policy-max-source-nodes)))))

;;; ==================================================================
(section "N. ERRATA 0.1 — THE SIX PROOF OBLIGATIONS, EACH EXECUTED")
;;;
;;; Candidate /0 retained the caller's own cons tree and handed it to the
;;; macroexpander.  The repair makes the IMMUTABLE CANONICAL SOURCE DATUM THE
;;; SINGLE AUTHORITY: Door 2 reconstructs a fresh private host form from that
;;; datum on every performance.  These six checks are the obligations that
;;; design must discharge, and they are executed rather than argued.

(defun mutable-source (version)
  (copy-tree
   (list (find-symbol "DEFINE-ADMISSION-CONTRACT" '#:lisp-plus-surface0)
         (intern "*S1-N*" '#:cl-user)
         :contract-id :surface1/n :contract-version version
         :accepted-clauses (list (list :verified-judged-claim))
         :proposition-relation :exact-normalized-equality
         :receiver-accessibility :required
         :retain (list :contract-snapshot))))

(ok "N1 CALLER MUTATION AFTER DOOR 1 CANNOT CHANGE WHAT DOOR 2 EXPANDS"
    (let* ((live (mutable-source 1))
           (pristine (copy-tree live))
           (req (s1 request-expansion live :macroexpand-1 (tag "n1"))))
      (setf (getf (cddr live) :contract-version) 999)
      (let ((rc (s1 perform-expansion req)))
        (and (same (s1 expansion-receipt-expanded-form-datum rc)
                   (s1 encode-term (macroexpand-1 pristine nil)))
             (not (same (s1 expansion-receipt-expanded-form-datum rc)
                        (s1 encode-term (macroexpand-1 live nil))))))))

(ok "N2 MUTATION BY ONE MACROEXPANSION CANNOT CHANGE A LATER PERFORMANCE of the
        same request — each performance gets its own freshly reconstructed form"
    (let* ((req (s1 request-expansion (mutable-source 1) :macroexpand-1 (tag "n2")))
           (a (nth-value 1 (s1 perform-expansion req)))
           (b (nth-value 1 (s1 perform-expansion req))))
      ;; destructively wreck the form the FIRST performance returned
      (setf (second a) :wrecked)
      (let ((c (nth-value 1 (s1 perform-expansion req))))
        (and (not (eq a b)) (not (eq b c))
             (equal b c)
             (not (equal a c))))))

(ok "N3 MUTABLE STRING LEAVES ARE ISOLATED"
    (let* ((str (copy-seq "alpha"))
           (src (list (find-symbol "DEFINE-ADMISSION-CONTRACT" '#:lisp-plus-surface0)
                      (intern "*S1-STR*" '#:cl-user)
                      :contract-id str :contract-version 1
                      :accepted-clauses (list (list :verified-judged-claim))
                      :proposition-relation :exact-normalized-equality
                      :receiver-accessibility :required
                      :retain (list :contract-snapshot)))
           (req (s1 request-expansion src :macroexpand-1 (tag "n3"))))
      (setf (char str 0) #\Z)
      (let* ((rc (s1 perform-expansion req))
             (back (s1 decode-term (s1 expansion-receipt-expanded-form-datum rc))))
        ;; the accounted expansion must still carry "alpha"
        (search "alpha" (format nil "~S" back)))))

(ok "N3b ... and the reconstructed string is a FRESH object each time, so a
        caller who mutates what it received cannot reach the next performance"
    (let* ((req (s1 request-expansion
                    (list (find-symbol "DEFINE-ADMISSION-CONTRACT" '#:lisp-plus-surface0)
                          (intern "*S1-STR2*" '#:cl-user)
                          :contract-id (copy-seq "beta") :contract-version 1
                          :accepted-clauses (list (list :verified-judged-claim))
                          :proposition-relation :exact-normalized-equality
                          :receiver-accessibility :required
                          :retain (list :contract-snapshot))
                    :macroexpand-1 (tag "n3b")))
           (a (s1 decode-term (s1 expansion-request-source-form-datum req)))
           (b (s1 decode-term (s1 expansion-request-source-form-datum req))))
      (and (equal a b) (not (eq (getf (cddr a) :contract-id)
                                (getf (cddr b) :contract-id))))))

(ok "N4 SHARED STRUCTURE IS REFUSED GLOBALLY — a shared subtree and two distinct
        equal copies no longer encode identically; the shared one refuses"
    (let* ((sub (list :verified-judged-claim))
           (shared (list sub sub))
           (copies (list (list :verified-judged-claim) (list :verified-judged-claim))))
      (and (handler-case (progn (s1 encode-term shared) nil) (error () t))
           (handler-case (progn (s1 encode-term copies) t) (error () nil)))))

(ok "N4b ... and a CAR-POSITION CYCLE handed to the PUBLIC encoder REFUSES
        instead of exhausting the control stack, as it did in Candidate /0"
    (let ((x (list :a)))
      (setf (car x) x)
      (handler-case (progn (s1 encode-term x) nil)
        (storage-condition () nil)
        (error () t))))

(ok "N4c ... and a spine cycle still refuses"
    (let ((x (list :a)))
      (setf (cdr x) x)
      (handler-case (progn (s1 encode-term x) nil) (error () t))))

(ok "N5 THE STORED SOURCE DATUM IS EXACTLY THE SOURCE HANDED TO THE
        MACROEXPANDER — re-encoding the reconstruction reproduces the datum"
    (let* ((req (s1 request-expansion (mutable-source 3) :macroexpand-1 (tag "n5")))
           (d (s1 expansion-request-source-form-datum req))
           (round (s1 encode-term (s1 decode-term d))))
      (same d round)))

(ok "N5b ... and the expansion the receipt accounts for is the expansion OF THAT
        RECONSTRUCTION, computed independently here"
    (let* ((req (s1 request-expansion (mutable-source 4) :macroexpand-1 (tag "n5b")))
           (rc (s1 perform-expansion req))
           (independent (macroexpand-1
                         (s1 decode-term (s1 expansion-request-source-form-datum req))
                         nil)))
      (same (s1 expansion-receipt-expanded-form-datum rc)
            (s1 encode-term independent))))

(ok "N6 THE SAME REQUEST OBJECT CAN BE PERFORMED REPEATEDLY WITHOUT DRIFT"
    (let* ((req (s1 request-expansion (mutable-source 5) :macroexpand-1 (tag "n6")))
           (ids (loop repeat 5 collect
                      (s1 expansion-occurrence-identity
                          (nth-value 2 (s1 perform-expansion req))))))
      (every (lambda (i) (same i (first ids))) ids)))

(ok "N7 DECODE-TERM NEVER INTERNS — a symbol absent from the image refuses
        rather than being silently re-created"
    (let* ((pkg (or (find-package "S1-N7") (make-package "S1-N7" :use '())))
           (sym (intern "TRANSIENT" pkg))
           (d (s1 encode-term (list sym 1))))
      (unintern sym pkg)
      (and (null (find-symbol "TRANSIENT" pkg))
           (handler-case (progn (s1 decode-term d) nil) (error () t))
           ;; and it did NOT create the symbol on the way out
           (null (find-symbol "TRANSIENT" pkg)))))

(ok "N7b ... and the same absence reaches DOOR 2 as its own typed refusal"
    (let* ((pkg (or (find-package "S1-N7B") (make-package "S1-N7B" :use '())))
           (sym (intern "GONE" pkg))
           (req (s1 request-expansion (list sym 1) :macroexpand-1 (tag "n7b"))))
      (unintern sym pkg)
      (let ((r (refusal-of (lambda () (s1 perform-expansion req)))))
        (and r (eq :source-not-reconstructible (s1 expansion-refusal-code r))
             (string= "SYMBOL-ABSENT-IN-IMAGE" (s1 expansion-refusal-upstream-code r))))))

(ok "N8 THE NONDETERMINISM RATIONALE IS ABOUT REPRESENTABILITY, and the code
        says so: the refusal a gensym-bearing expansion lands under names the
        TERM GRAMMAR, not determinism"
    (let ((r (refusal-of
              (lambda ()
                (s1 perform-expansion
                    (s1 request-expansion
                        '(lisp-plus-surface0:derive-case (cl-user::c cl-user::r)
                          (lisp-plus-slice1:derive :schema-name :x)
                          (:granted cl-user::c) (:refused (nil) 1))
                        :macroexpand-1 (tag "n8")))))))
      (and (eq :expanded-term-unrepresentable (s1 expansion-refusal-code r))
           (string= "TermGrammar" (s1 expansion-refusal-upstream-category r))
           (string= "UNINTERNED-SYMBOL" (s1 expansion-refusal-upstream-code r)))))

;;; ==================================================================
(section "O. ERRATA 0.2 — HOME-PACKAGE IDENTITY AND THE EXECUTED ROUND TRIP")
;;;
;;; Errata 0.1 resolved reconstructed symbols with FIND-SYMBOL and required only
;;; that the symbol be FOUND.  FIND-SYMBOL answers ACCESSIBILITY; the grammar
;;; records HOME-PACKAGE IDENTITY.  Those are different questions, and asking
;;; the wrong one re-opened the false edge one layer down: a datum naming P/X
;;; reconstructed as Q:X, and a receipt was minted for it.

(ok "O1 an INHERITED symbol no longer substitutes for the one the datum names"
    (let* ((q (or (find-package "S1-O-Q")
                  (eval '(defpackage #:s1-o-q (:use) (:export #:x)))))
           (p (or (find-package "S1-O-P")
                  (eval '(defpackage #:s1-o-p (:use #:s1-o-q) (:shadow #:x)))))
           (px (find-symbol "X" p))
           (d (s1 encode-term (list px 1))))
      (declare (ignorable q))
      (unintern px p)
      ;; X is now reachable in P only by INHERITANCE from Q
      (and (eq :inherited (nth-value 1 (find-symbol "X" p)))
           (handler-case (progn (s1 decode-term d) nil) (error () t)))))

(ok "O2 ... and that refusal reaches DOOR 2 with its own upstream reason,
        minting nothing"
    (let* ((q (or (find-package "S1-O2-Q")
                  (eval '(defpackage #:s1-o2-q (:use) (:export #:x)))))
           (p (or (find-package "S1-O2-P")
                  (eval '(defpackage #:s1-o2-p (:use #:s1-o2-q) (:shadow #:x)))))
           (px (find-symbol "X" p))
           (req (s1 request-expansion
                    (list (find-symbol "DEFINE-ADMISSION-CONTRACT" '#:lisp-plus-surface0)
                          px :contract-id :s1/o2 :contract-version 1
                          :accepted-clauses (list (list :verified-judged-claim))
                          :proposition-relation :exact-normalized-equality
                          :receiver-accessibility :required
                          :retain (list :contract-snapshot))
                    :macroexpand-1 (tag "o2"))))
      (declare (ignorable q))
      (unintern px p)
      (multiple-value-bind (rc ex rf) (s1 try-perform-expansion req)
        (declare (ignore ex))
        (and (null rc)
             (eq :source-not-reconstructible (s1 expansion-refusal-code rf))
             (string= "SYMBOL-NOT-HOME-IN-NAMESPACE"
                      (s1 expansion-refusal-upstream-code rf))))))

(ok "O3 the HOME-PACKAGE conjunct does work the STATUS conjunct cannot: an
        IMPORTED symbol is :INTERNAL in the importing package while its home
        package is elsewhere, so a status-only guard would pass it"
    (let* ((q (or (find-package "S1-O3-Q")
                  (eval '(defpackage #:s1-o3-q (:use) (:export #:y)))))
           (p (or (find-package "S1-O3-P") (eval '(defpackage #:s1-o3-p (:use))))))
      (import (find-symbol "Y" q) p)
      (multiple-value-bind (sym status) (find-symbol "Y" p)
        (and (eq :internal status)
             (not (eq (symbol-package sym) p))
             ;; a hand-built datum naming P/Y must refuse — no encode path
             ;; produces it, because the ENCODER writes the HOME package
             (let ((hand (cd0 make-record-datum
                              (list (cd0 make-record-entry
                                         (cd0 make-identifier-datum '("TERM") '("KIND"))
                                         (cd0 make-identifier-datum '("TERMKIND") '("SYMBOL")))
                                    (cd0 make-record-entry
                                         (cd0 make-identifier-datum '("TERM") '("VALUE"))
                                         (cd0 make-identifier-datum
                                              (list (package-name p)) '("Y")))))))
               (handler-case (progn (s1 decode-term hand) nil) (error () t)))))))

(ok "O3b ... and the ENCODER writes the HOME package, which is why an imported
        symbol has no hole on the encode side"
    (let* ((q (or (find-package "S1-O3B-Q")
                  (eval '(defpackage #:s1-o3b-q (:use) (:export #:z)))))
           (p (or (find-package "S1-O3B-P") (eval '(defpackage #:s1-o3b-p (:use))))))
      (import (find-symbol "Z" q) p)
      (let* ((imported (find-symbol "Z" p))
             (d (s1 encode-term imported))
             (ns (cd0 identifier-datum-namespace
                      (cd0 record-datum-ref d (cd0 make-identifier-datum '("TERM") '("VALUE"))))))
        (string= (aref ns 0) (package-name q)))))

(ok "O4 THE ROUND TRIP IS AN EXECUTED GATE, not a tested property — with a
        DEFECTIVE decoder planted, Door 2 refuses ROUND-TRIP-MISMATCH before
        any expansion"
    (let ((req (s1 request-expansion *specimen* :macroexpand-1 (tag "o4"))))
      (let ((lisp-plus-surface1::*%fault-decode-substitution*
              (lambda (form)
                (let ((copy (copy-tree form)))
                  (setf (getf (cddr copy) :contract-version) 424242)
                  copy))))
        (multiple-value-bind (rc ex rf) (s1 try-perform-expansion req)
          (declare (ignore ex))
          (and (null rc)
               (eq :source-not-reconstructible (s1 expansion-refusal-code rf))
               (string= "ROUND-TRIP-MISMATCH" (s1 expansion-refusal-upstream-code rf)))))))

(ok "O4b ... and the gate is NOT stuck on: with no fault bound the same request
        performs cleanly"
    (s1 expansion-receipt-p
        (s1 perform-expansion (s1 request-expansion *specimen* :macroexpand-1 (tag "o4b")))))

(ok "O5 NO PUBLIC INPUT CAN REACH THE ROUND-TRIP MISMATCH, and saying so is the
        honest classification: with the home-package guard in place decode is
        injective, so the earlier and more precise guard always fires first.
        The gate is DEFENCE IN DEPTH, proved live only by planted fault."
    (let* ((q (or (find-package "S1-O5-Q")
                  (eval '(defpackage #:s1-o5-q (:use) (:export #:x)))))
           (p (or (find-package "S1-O5-P")
                  (eval '(defpackage #:s1-o5-p (:use #:s1-o5-q) (:shadow #:x)))))
           (px (find-symbol "X" p))
           (req (s1 request-expansion (list px 1) :macroexpand-1 (tag "o5"))))
      (declare (ignorable q))
      (unintern px p)
      (multiple-value-bind (rc ex rf) (s1 try-perform-expansion req)
        (declare (ignore rc ex))
        ;; the SYMBOL guard fires, never the round-trip guard
        (string= "SYMBOL-NOT-HOME-IN-NAMESPACE" (s1 expansion-refusal-upstream-code rf)))))

(ok "O6 grammar and procedure versions BOTH moved, because both changed:
        the decode relation narrowed and the reconstruction procedure now
        enforces the round trip"
    (and (= 3 (s1 expansion-grammar-version))
         (= 3 (s1 expansion-procedure-version))
         (= 1 (s1 expansion-policy-version))))

;;; ==================================================================
(format t "~%")
(format t "  WHAT THESE GREENS DO NOT ESTABLISH~%")
(format t "  Not that any source and its expansion mean the same thing.~%")
(format t "  Not that any expansion is correct, evaluable, compilable, hygienic~%")
(format t "    or portable to another Common Lisp.~%")
(format t "  Not that any lexical environment was captured: none ever is.~%")
(format t "  Not that later evaluation reaches backward and validates anything.~%")
(format t "  A receipt is an ACCOUNT, not an AUTHENTICATION.~%")
(format t "  Every green above is SELF-CONSISTENCY CERTIFICATION by the family~%")
(format t "    that wrote the layer.  The stranger audit is OWED.~%~%")
(format t "== surface1-selftest: ~D checks passed / ~D failed ==~%"
        (- *checks* *failed*) *failed*)
(when (plusp *failed*) (sb-ext:exit :code 1))
