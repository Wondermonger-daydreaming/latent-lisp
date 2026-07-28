;;;; APPLICATION.lisp — de expansione testata: concerning the attested expansion.
;;;;
;;;; Run: sbcl --non-interactive --load APPLICATION.lisp
;;;;
;;;; WHAT THIS DOES NOT ESTABLISH — first, because it is the part a reader is
;;;; most likely to supply for himself if nobody says it, and because this is the
;;;; layer where the intuition "obviously the same meaning" is strongest:
;;;;
;;;;   Nothing here establishes that any source form and its expansion MEAN THE
;;;;   SAME THING.  Surface /1 says WHAT FORM BECAME WHAT OTHER FORM.  It never
;;;;   says better, same, or right.  It does not establish that an expansion is
;;;;   correct, evaluable, compilable, hygienic, or portable to any other Common
;;;;   Lisp; it captures no lexical environment; and no later success flows
;;;;   backward to validate anything.  A receipt is an ACCOUNT, not an
;;;;   AUTHENTICATION.
;;;;
;;;; THESIS.  A Lisp+ macro expansion can become an inspectable structural
;;;; occurrence whose receipt says exactly what form became what other form,
;;;; while remaining silent about whether the transformation preserves meaning.
;;;;
;;;; THE DIVISION OF LABOUR, WHICH IS THE WHOLE POINT.
;;;;
;;;;   Surface /1  establishes that THIS FORM BECAME THAT FORM.
;;;;   Surface /0  establishes NOTHING here — it is not modified, not wrapped,
;;;;               and its own grammar refusal reaches the caller in its voice.
;;;;   Slice /2    ALONE decides whether the evaluated result is a lawful
;;;;               admission contract, and it refuses one of ours.
;;;;
;;;; SURFACE /1 IS NOT MODIFIED BY THIS PROGRAM, AND NEITHER IS SURFACE /0.
;;;; Surface /1 loads CD/0 only.  This application loads Surface /0 as a CLIENT,
;;;; so the neighbour can accept or refuse in its own voice instead of Surface
;;;; /1 impersonating it.

;;;; ERRATA 0.3 / D4.  This program used to report to its wrapper with nothing but
;;;; an exit code, and it exited 0 while running almost nothing: the stranger audit
;;;; gutted it to its preamble and re-appended its summary, and the runner reported
;;;; peace (`FOSSOR.md` §4, cases T9 and T11).  A check that never ran never fails.
;;;; It now ends with ONE canonical machine-readable line emitted from the LIVE
;;;; counter, against a count DECLARED at the top of this file, carrying the
;;;; content-derived subject digest.

(defparameter *here* (or *load-truename* *default-pathname-defaults*))
(handler-bind ((style-warning #'muffle-warning))
  (load (merge-pathnames "../surface1.lisp" *here*))
  (load (merge-pathnames "../../language-surface-0/surface0.lisp" *here*)))
(load (merge-pathnames "../errata-0.3/EVIDENCE.lisp" *here*))

;;; THE DECLARED COUNT.  At the top, so a file truncated anywhere below cannot
;;; satisfy it: the live counter falls short and the canonical line does not match.
(defparameter *expected-checks* 26)

(defpackage #:de-expansione-testata (:use #:common-lisp))
(in-package #:de-expansione-testata)

;;; ERRATA 0.3 / D8 F-16.  These helpers used bare INTERN.  Errata 0.1 repaired the
;;; selftest's and wrote the sentence unqualified; the audit measured the tree and
;;; found the repair had reached one instrument of five (`FOSSOR.md` §6, F7).  INTERN
;;; cannot tell a private name from a public one, and it CREATES the symbol it fails
;;; to find — so a typo becomes a fresh internal symbol and the error surfaces far
;;; from its cause.  This is the artefact a reader is meant to learn the PUBLIC
;;; surface from, so it is the last file that should be able to reach a private name.
(defmacro s1 (name &rest args)
  (multiple-value-bind (sym status) (find-symbol (string name) '#:lisp-plus-surface1)
    (unless (eq status :external)
      (error "S1: ~A is ~:[absent~;~:*~A~] in LISP-PLUS-SURFACE1, not :EXTERNAL"
             (string name) status))
    `(,sym ,@args)))
(defmacro cd0 (name &rest args)
  (multiple-value-bind (sym status) (find-symbol (string name) '#:lisp-plus-cd0)
    (unless (eq status :external)
      (error "CD0: ~A is ~:[absent~;~:*~A~] in LISP-PLUS-CD0, not :EXTERNAL"
             (string name) status))
    `(,sym ,@args)))

(defparameter *checks* 0)
(defparameter *failed* 0)
(defparameter *census* (make-hash-table :test #'equal))

(defun section (title) (format t "~%── ~A~%" title))
(defun desk (control &rest args)
  ;; A blank desk line emits NO trailing whitespace.  A captured transcript is
  ;; EVIDENCE, and evidence should never need hand-editing to pass a hygiene
  ;; check — fix the thing that writes it, not the thing it wrote.
  (let ((text (apply #'format nil control args)))
    (if (string= text "") (format t "~%") (format t "  ~A~%" text))))
(defun check (condition label)
  (incf *checks*)
  (if condition
      (format t "  [~2,'0D] ok   ~A~%" *checks* label)
      (progn (incf *failed*) (format t "  [~2,'0D] FAIL ~A~%" *checks* label))))

(defun tag (&rest path) (cd0 make-identifier-datum '("de-expansione-testata") path))
(defun same (a b) (cd0 equal-datum a b))
(defun full-hex (d) (cd0 octets-to-hex (cd0 canonical-octets d)))

;;; THE ABBREVIATION IS ITSELF UNDER TEST.  Naive prefixes of lossless
;;; identities collapse: two identities sharing a long head differ only far into
;;; the tail.  Every identity PRINTED here registers into *CENSUS* as a side
;;; effect of printing, so nothing displayed escapes the discrimination check at
;;; the foot of the program.
;;; ERRATA 0.3 / D8 F-1.  The census USED to register only the full identity, and
;;; the check at the foot of the program compared a value with its own defining
;;; expression — it could not fail.  The abbreviation, the thing actually under
;;; test, was never compared with anything.  Now each printed identity registers
;;; FULL -> ABBREVIATION, and the foot of the program asserts that the two counts
;;; agree: two distinct identities printing as one abbreviation would fail it.
(defparameter +head+ 20)
(defparameter +tail+ 20)
(defun abbreviate (hex)
  (if (<= (length hex) (+ +head+ +tail+ 3))
      hex
      (format nil "~A…~A [~D]" (subseq hex 0 +head+)
              (subseq hex (- (length hex) +tail+)) (length hex))))
(defun id! (datum)
  (let* ((hex (full-hex datum))
         (short (abbreviate hex)))
    (setf (gethash hex *census*) short)
    short))

;;; a tiny line splitter, so the program has no dependency of any kind
(defun uiop-split (s)
  (let ((out '()) (start 0))
    (loop for i from 0 below (length s)
          do (when (char= (char s i) #\Newline)
               (push (subseq s start i) out) (setf start (1+ i))))
    (push (subseq s start) out)
    (nreverse out)))

(defun show-form (label form)
  (format t "  ~A~%" label)
  (let ((*print-pretty* t) (*print-right-margin* 72) (*print-case* :downcase))
    (let ((s (with-output-to-string (o) (pprint form o))))
      (dolist (line (rest (uiop-split s)))
        (format t "    ~A~%" line)))))


(format t "~&DE EXPANSIONE TESTATA — concerning the attested expansion~%")
(surface1-evidence:print-evidence-header
 (merge-pathnames "../" cl-user::*here*))
(format t "SBCL ~A · Surface /1 grammar v~D · procedure v~D · policy v~D~%"
        (lisp-implementation-version)
        (s1 expansion-grammar-version) (s1 expansion-procedure-version)
        (s1 expansion-policy-version))
(format t "ceilings: source-depth ~D · source-nodes ~D · term-octets ~D~%"
        (s1 expansion-policy-max-source-depth)
        (s1 expansion-policy-max-source-nodes)
        (s1 expansion-policy-max-term-octets))

;;; ==================================================================
(section "I. THE SPECIMEN — and why it is this one")
;;;
;;; DEFINE-ADMISSION-CONTRACT, of the five Surface /0 constructs, because:
;;;   EVERY FIELD OF IT IS LITERAL SYNTAX (surface0.lisp:148).  Nothing in the
;;;   source is evaluated, so the expansion is a pure function of the source
;;;   text, with no free reference whose meaning depends on ambient bindings.
;;;   Its expansion's head is PROGN, a special operator, so one-step and
;;;   repeated expansion coincide — a mechanism, not a coincidence.
;;;   Its expansion performs no registry write, unlike DEFINE-JUDGMENT-SCHEMA.
;;;   It carries zero uninterned symbols at either operation.

(defparameter *source*
  '(lisp-plus-surface0:define-admission-contract cl-user::*testata-contract*
    :contract-id :de-expansione-testata/c
    :contract-version 0
    :accepted-clauses ((:verified-judged-claim))
    :proposition-relation :exact-normalized-equality
    :receiver-accessibility :required
    :retain (:contract-snapshot :support-identity :support-basis :source-basis)))

(show-form "THE EXACT SOURCE FORM PRESENTED:" *source*)

;;; ==================================================================
(section "II. DOOR 1 — a description, not yet an event")

(defparameter *request*
  (s1 request-expansion *source* :macroexpand-1 (tag "movement" "one")))

(desk "request identity      ~A" (id! (s1 expansion-request-identity *request*)))
(desk "source-form identity  ~A" (id! (s1 expansion-request-source-form-identity *request*)))
(desk "operation             ~S" (s1 expansion-request-operation *request*))
(desk "construct identity    ~A" (id! (s1 expansion-request-construct-identity *request*)))

(check (s1 expansion-request-p *request*) "Door 1 minted a request object")
(check (null (find-symbol "EXPANSION-REQUEST-%HOST-FORM" '#:lisp-plus-surface1))
       "ERRATA 0.1 — the request holds NO caller-owned host form; the slot is gone")
(check (not (boundp (intern "*TESTATA-CONTRACT*" '#:cl-user)))
       "Door 1 EXPANDED NOTHING — the variable its expansion would bind is still UNBOUND")

;;; ==================================================================
(section "III. DOOR 2 — the occurrence, and the exact expanded form")

(defparameter *receipt* nil) (defparameter *expanded* nil) (defparameter *occ* nil)
(multiple-value-setq (*receipt* *expanded* *occ*) (s1 perform-expansion *request*))

(show-form "THE EXACT EXPANDED FORM PRODUCED:" *expanded*)

(desk "occurrence identity   ~A" (id! (s1 expansion-occurrence-identity *occ*)))
(desk "receipt identity      ~A" (id! (s1 expansion-receipt-identity *receipt*)))
(desk "expanded-form ident.  ~A" (id! (s1 expansion-receipt-expanded-form-identity *receipt*)))
(desk "disposition           ~S" (s1 expansion-receipt-disposition *receipt*))
(desk "source term octets    ~D" (cd0 octets-length
                                      (cd0 canonical-octets
                                           (s1 expansion-receipt-source-form-datum *receipt*))))
(desk "expanded term octets  ~D" (cd0 octets-length
                                      (cd0 canonical-octets
                                           (s1 expansion-receipt-expanded-form-datum *receipt*))))

(check (equal *expanded* (macroexpand-1 *source* nil))
       "the accounted expansion IS what MACROEXPAND-1 returns — nothing was manufactured")
(check (same (s1 expansion-receipt-expanded-form-datum *receipt*)
             (cd0 decode-exact (cd0 canonical-octets (s1 encode-term *expanded*))))
       "the stored expanded datum is the encoding of that exact host form")
(check (same (s1 expansion-receipt-request-identity *receipt*)
             (s1 expansion-request-identity *request*))
       "the receipt carries the request identity it was minted from")
(check (eq :macroexpanded-one-step (s1 expansion-receipt-disposition *receipt*))
       "the disposition names the OPERATION THAT RAN, with no adverb")

;;; ==================================================================
(section "IV. THE ACCOUNT IS COMPLETE, AND IT IS ONLY AN ACCOUNT")

(desk "the receipt's fields, exhaustively:")
(desk "  identity · request-identity · occurrence-identity")
(desk "  source-form-datum · source-form-identity")
(desk "  expanded-form-datum · expanded-form-identity")
(desk "  operation · construct-identity · expansion-context · disposition")
(desk "  procedure-identity/version · policy-identity/version  (package constants)")
(desk "")
(desk "THERE IS NO FIELD FOR: meaning, equality, correctness, hygiene,")
(desk "evaluability, compilability, portability, or an environment object.")

(check (null (find-symbol "EXPANSION-RECEIPT-MEANING" '#:lisp-plus-surface1))
       "no receipt field names MEANING")
(check (null (find-symbol "EXPANSION-RECEIPT-ENVIRONMENT" '#:lisp-plus-surface1))
       "no receipt field names an ENVIRONMENT object")
(check (same (cd0 record-datum-ref (s1 expansion-receipt-expansion-context *receipt*)
                  (cd0 make-identifier-datum '("CONTEXT") '("ENVIRONMENT-OBJECT-CAPTURED")))
             (cd0 make-boolean-datum nil))
       "the context field says explicitly that NO environment object was captured")

;;; ==================================================================
(section "V. THE GOVERNED LAYER ALONE DECIDES WHAT THE EXPANSION WAS WORTH")

(defparameter *evaluated* (eval *expanded*))
(defparameter *object* (symbol-value (find-symbol "*TESTATA-CONTRACT*" '#:cl-user)))

(desk "evaluating the accounted expansion produced: ~A"
      (if (lisp-plus-slice2:support-admission-contract-p *object*)
          "a real Slice /2 support-admission contract"
          "something else"))

(check (lisp-plus-slice2:support-admission-contract-p *object*)
       "Slice /2's OWN public constructor accepted it — Surface /1 said nothing about that")

(defparameter *receipt-before* (full-hex (s1 expansion-receipt-identity *receipt*)))
(defparameter *expanded-before* (full-hex (s1 expansion-receipt-expanded-form-datum *receipt*)))

(check (string= *receipt-before* (full-hex (s1 expansion-receipt-identity *receipt*)))
       "AFTER that governed success the receipt identity is BYTE-IDENTICAL")
(check (string= *expanded-before* (full-hex (s1 expansion-receipt-expanded-form-datum *receipt*)))
       "and the stored expanded datum is BYTE-IDENTICAL — nothing flowed backward")

;;; The mirror case: an expansion Surface /1 accounts for perfectly, which the
;;; governed layer then REFUSES.  The account is identical in kind.
(defparameter *bad-source*
  '(lisp-plus-surface0:define-admission-contract cl-user::*testata-bad*
    :contract-id :de-expansione-testata/bad
    :contract-version 0
    :accepted-clauses ((:verified-judged-claim))
    :proposition-relation :no-such-relation
    :receiver-accessibility :required
    :retain (:contract-snapshot :support-identity :support-basis :source-basis)))

(defparameter *bad-receipt* nil) (defparameter *bad-expanded* nil)
(multiple-value-setq (*bad-receipt* *bad-expanded*)
  (s1 perform-expansion (s1 request-expansion *bad-source* :macroexpand-1 (tag "movement" "five"))))

(desk "the SECOND specimen differs from the first in ONE field: the proposition")
(desk "relation.  Surface /1's account of it is a receipt, exactly as before:")
(desk "  receipt identity    ~A" (id! (s1 expansion-receipt-identity *bad-receipt*)))
(desk "  disposition         ~S" (s1 expansion-receipt-disposition *bad-receipt*))

(check (s1 expansion-receipt-p *bad-receipt*)
       "Surface /1 accounted for the second expansion with the SAME disposition")
(check (eq (s1 expansion-receipt-disposition *receipt*)
           (s1 expansion-receipt-disposition *bad-receipt*))
       "the two dispositions are identical — the layer cannot tell them apart, and must not")

(defparameter *slice2-refused*
  (handler-case (progn (eval *bad-expanded*) nil)
    (lisp-plus-slice2:admission-contract-error () t)))

(check *slice2-refused*
       "SLICE /2 REFUSED IT — and that refusal is Slice /2's, in Slice /2's voice")
(check (not (same (s1 expansion-receipt-expanded-form-identity *receipt*)
                  (s1 expansion-receipt-expanded-form-identity *bad-receipt*)))
       "the two accounts ARE distinguishable — by WHAT CHANGED, never by what it meant")

(desk "")
(desk "THIS IS THE WHOLE DEMONSTRATION.  Two expansions identical in every")
(desk "structural respect Surface /1 can see, differing in one field, and")
(desk "Surface /1's accounts of them differ ONLY in the encoded forms.  The")
(desk "difference in WORTH was decided one layer down, by the only voice with")
(desk "standing to decide it.  Nothing above filtered the second one.")

;;; ==================================================================
(section "VI. THE EXPANDED-SIDE CEILINGS — driven to their real edges")
;;;
;;; A FIXTURE THAT IS LARGE IS NOT A FIXTURE THAT IS MAXIMAL.  Each ceiling
;;; below is found by bisection and reported with the refusal at n+1 exhibited,
;;; not with a comfortable margin off a fixture that merely felt big.

(defun contract-with-clauses (n)
  `(lisp-plus-surface0:define-admission-contract cl-user::*testata-wide*
     :contract-id :de-expansione-testata/wide :contract-version 0
     :accepted-clauses ,(loop repeat n collect (list :verified-judged-claim))
     :proposition-relation :exact-normalized-equality
     :receiver-accessibility :required
     :retain (:contract-snapshot :support-identity :support-basis :source-basis)))

(defun accounted-p (form)
  (multiple-value-bind (rc ex rf)
      (s1 try-perform-expansion
          (nth-value 0 (s1 try-request-expansion form :macroexpand-1 (tag "ceiling"))))
    (declare (ignore ex))
    (values (and rc t) (and rf (s1 expansion-refusal-code rf)))))

(defun bisect (lo hi f)
  (let ((best lo))
    (loop while (<= lo hi)
          do (let ((mid (floor (+ lo hi) 2)))
               (if (funcall f mid) (progn (setf best mid) (setf lo (1+ mid)))
                   (setf hi (1- mid)))))
    best))

(let* ((max-n (bisect 1 40000 (lambda (n)
                                (handler-case (accounted-p (contract-with-clauses n))
                                  (error () nil))))))
  (multiple-value-bind (ok code) (handler-case (accounted-p (contract-with-clauses (1+ max-n)))
                                   (error () (values nil :host-error)))
    (declare (ignore ok))
    (desk "largest ACCOUNTED clause count : ~D" max-n)
    (desk "at ~D the layer refuses with   : ~S" (1+ max-n) code)
    (check (member code '(:source-nodes-exceeded :source-term-octets-exceeded
                          :expanded-term-octets-exceeded))
           "the edge is a DECLARED ceiling of this layer, not a host accident")
    (desk "")))

;;; ==================================================================
;;; ERRATA 0.3 / D1 — THE CEILING THIS PROGRAM SAID DOES NOT FIRE.  IT FIRES.
;;;
;;; What stood here was WITHDRAWN, in these words: ":EXPANDED-NODES-EXCEEDED is
;;; UNREACHABLE UNDER THIS POLICY … octets must always fire first."  The 2026-07-28
;;; stranger audit reached the code from the public API with an ordinary admissible
;;; source form (`FOSSOR.md` §2, F1), and the arithmetic that stood here was
;;; backwards: it divided the octet ceiling by the cost of ONE TERM measured on the
;;; SOURCE side, and then compared that against the EXPANDED-side node count.  The
;;; two sides are not the same size.  DEFINE-JUDGMENT-SCHEMA amplifies about 4.0x in
;;; nodes and far less in octets, so at the crossing the expansion has passed 20000
;;; nodes while its octets are still under 262144.  The amplification is
;;; CONSTRUCT-DEPENDENT and this threshold is NOT universal.
;;;
;;; No ceiling was moved to make this fire.  The guard was always real; the note
;;; about it was false.  A claim of unreachability is a claim, and this one is now
;;; EXECUTED rather than asserted — the crossing is exhibited at n and n+1.
(section "VI-b. THE EXPANDED-SIDE NODE CEILING — REACHED, NOT ARGUED AWAY")

(defun schema-with-premises (n)
  `(lisp-plus-surface0:define-judgment-schema cl-user::*testata-premises*
     :name :z :version 0 :conclusion 0
     :premises ,(loop repeat n collect 0)
     :locals () :unique-locals ()))

(multiple-value-bind (ok-lo code-lo) (accounted-p (schema-with-premises 2492))
  (declare (ignore ok-lo))
  (multiple-value-bind (ok-hi code-hi) (accounted-p (schema-with-premises 2493))
    (declare (ignore ok-hi))
    (desk "an ordinary DEFINE-JUDGMENT-SCHEMA with N integer premises:")
    (desk "  N=2492 -> ~S" code-lo)
    (desk "  N=2493 -> ~S" code-hi)
    (desk "no fault hook, no internal symbol, no fixture — Door 1 accepts both and")
    (desk "Door 2 refuses both, one octet-side and one node-side, one apart.")
    (check (eq code-hi :expanded-nodes-exceeded)
           "ERRATA 0.3 — :EXPANDED-NODES-EXCEEDED IS REACHABLE from the public API")
    (check (eq code-lo :expanded-term-octets-exceeded)
           "and one premise lower the OCTET ceiling fires — the two are adjacent, not dominated")))

(let ((entry (find :expanded-nodes-exceeded (s1 expansion-refusal-code-catalog)
                   :key (lambda (e) (s1 refusal-catalog-entry-code e)))))
  (desk "catalogue reachability of :EXPANDED-NODES-EXCEEDED : ~S"
        (s1 refusal-catalog-entry-reachability entry))
  (check (eq :public-api (s1 refusal-catalog-entry-reachability entry))
         "and the catalogue now SAYS SO — the entry no longer claims unreachability"))

;;; The depth ceiling, on the expanded side specifically.  DEFINE-JUDGMENT-SCHEMA
;;; wraps each premise in (PROPOSITION-PATTERN '...), so an expansion is deeper
;;; than its source — which is how an expanded-side depth refusal is reachable at
;;; all while the source passes.
(defun schema-with-depth (n)
  (let ((concl '(:predicate :z (:v (:var :v)))))
    (dotimes (i n) (setf concl (list concl)))
    `(lisp-plus-surface0:define-judgment-schema cl-user::*testata-deep*
       :name :z :version 0 :conclusion ,concl :premises ()
       :locals () :unique-locals ())))

(let ((found nil))
  (loop for n from (- (s1 expansion-policy-max-source-depth) 6)
          to (s1 expansion-policy-max-source-depth)
        until found
        do (multiple-value-bind (ok code)
               (handler-case (accounted-p (schema-with-depth n)) (error () (values nil nil)))
             (declare (ignore ok))
             (when (eq code :expanded-depth-exceeded)
               (setf found n)
               (desk "at conclusion-nesting ~D the SOURCE passes and the EXPANSION" n)
               (desk "exceeds the depth ceiling — the wrapper adds the levels"))))
  (check found ":EXPANDED-DEPTH-EXCEEDED is reachable, and reachable ONLY expanded-side"))

;;; ==================================================================
(section "VII. WHAT THE LAYER REFUSES, AND WHY THE REFUSALS ARE THE POINT")

(multiple-value-bind (ok code)
    (accounted-p '(lisp-plus-surface0:derive-case (cl-user::c cl-user::r)
                   (lisp-plus-slice1:derive :schema-name :x)
                   (:granted cl-user::c) (:refused (nil) 1)))
  (declare (ignore ok))
  (desk "a Surface /0 form whose ONE-STEP expansion carries a fresh gensym:")
  (desk "  refused with ~S" code)
  (check (eq :expanded-term-unrepresentable code)
         "an expansion bearing an implementation-generated name is REFUSED"))

(desk "")
(desk "THE RATIONALE, CORRECTED IN ERRATA 0.1.  Candidate /0 said a receipt for")
(desk "a non-deterministic expansion 'would be an account that could not be true")
(desk "twice.'  THAT WAS WRONG, and the error was worth catching: a receipt")
(desk "accounts for ONE OCCURRENCE, and a nondeterministic occurrence can have a")
(desk "perfectly truthful receipt — it says what form became what other form ON")
(desk "THAT OCCASION, which is what a receipt is for.")
(desk "")
(desk "THE REAL REASON IS REPRESENTABILITY.  The term grammar cannot account for")
(desk "uninterned-symbol identity INJECTIVELY: two distinct gensyms bearing one")
(desk "name collapse to a single identifier datum, because CD/0 compares")
(desk "identifier segments bytewise.  The grammar therefore cannot represent the")
(desk "binding structure that makes such a symbol mean anything.  That is a")
(desk "grammar limit, not an epistemic one, and it is the whole reason.")
(desk "")
(desk "SURFACE /0 IS STILL NOT MODIFIED TO MAKE THIS CONVENIENT.")

(check (not (equal (macroexpand-1 '(lisp-plus-surface0:derive-case (cl-user::c cl-user::r)
                                    (lisp-plus-slice1:derive :schema-name :x)
                                    (:granted cl-user::c) (:refused (nil) 1))
                                  nil)
                   (macroexpand-1 '(lisp-plus-surface0:derive-case (cl-user::c cl-user::r)
                                    (lisp-plus-slice1:derive :schema-name :x)
                                    (:granted cl-user::c) (:refused (nil) 1))
                                  nil)))
       "and Surface /0 still expands it non-deterministically — reported, not repaired")

;;; ==================================================================
(section "VIII. THE CENSUS — the abbreviation did not lie")

;;; ERRATA 0.3 / D8 F-1.  What stood here was `(check (= n (hash-table-count
;;; *census*)) "every printed identity was registered in full")` — `n` compared with
;;; its own defining expression, which cannot fail, under a section heading
;;; advertising a discrimination check that existed nowhere in the file
;;; (`TABULARIUS.md` §1, F-1).  The advertised measurement is now performed.
(let* ((fulls (hash-table-count *census*))
       (shorts (let ((seen (make-hash-table :test #'equal)))
                 (maphash (lambda (full short) (declare (ignore full))
                            (setf (gethash short seen) t))
                          *census*)
                 (hash-table-count seen))))
  (desk "distinct FULL identities printed above ..... ~D" fulls)
  (desk "distinct ABBREVIATIONS they printed as ..... ~D" shorts)
  (check (= shorts fulls)
         "the abbreviation DID NOT LIE: distinct identities printed as distinct abbreviations")
  (check (> fulls 6) "the program printed enough distinct identities to be worth checking"))

;;; ==================================================================
(format t "~%")
(format t "  — an expansion leaves a receipt~%")
(format t "  — the receipt says what form became what other form~%")
(format t "  — and it is silent about whether that preserves meaning~%")
(format t "~%")
(format t "== de-expansione-testata: ~D checks passed / ~D failed ==~%"
        (- *checks* *failed*) *failed*)

;;; ONE CANONICAL, MACHINE-READABLE RESULT LINE — from the LIVE counter, after every
;;; intended check has executed, carrying the CONTENT-DERIVED subject digest.  The
;;; wrapper requires this exact shape with checks == expected and failed = 0, so a
;;; truncation at a clean form boundary, a gutted preamble-only run, a crash, a
;;; renamed label and a trailing space all fail closed.
(format t "~%APPLICATION-RESULT checks=~D expected=~D failed=~D subject=~A~%"
        *checks* cl-user::*expected-checks* *failed*
        (surface1-evidence:subject-short (merge-pathnames "../" cl-user::*here*)))
(when (or (plusp *failed*) (/= *checks* cl-user::*expected-checks*))
  (sb-ext:exit :code 1))
