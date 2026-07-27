;;;; CONDITION-PARTITION.lisp — the executable half of CONDITION-PARTITION.md.
;;;;
;;;; Language Form /1, Candidate /0.  SBCL 2.4.6.
;;;; — Claude Opus 5 (1M context), as LIMEN.
;;;;
;;;; WHAT THIS FILE IS.  A REPORT, executed.  It measures which condition classes
;;;; SUBMIT-PETITION classifies and which pass through it as themselves, and it
;;;; refuses to let the companion document go stale in silence.
;;;;
;;;; THREE RULES IT HOLDS ITSELF TO, ALL VISIBLE IN THE CODE BELOW.
;;;;
;;;;   1.  NOT ONE HANDLER WAS ADDED TO THE LAYER.  Three conditions escape
;;;;       SUBMIT-PETITION.  The correct action for a report is to record that
;;;;       they escape.  form1.lisp is untouched by this file — it is LOADED,
;;;;       never edited, and nothing here wraps, shadows or advises it.
;;;;
;;;;   2.  NO BROAD HANDLER, ANYWHERE.  There is no (ERROR () …) and no
;;;;       (CONDITION () …) in this file — not in a fixture, not in a helper.
;;;;       EXPECTING names ONE LITERAL CLASS per use site.  A condition of any
;;;;       other class escapes THIS HARNESS exactly as it escapes the layer, and
;;;;       the run dies loudly.  That is deliberate: a harness that absorbs a
;;;;       surprise cannot report a partition, because it has already destroyed
;;;;       the evidence that the partition was wrong.  T-NO-BLANKET (§5) proves
;;;;       the property by scanning this file's own source text.
;;;;
;;;;   3.  THE TABLE IS CHECKED AGAINST THE RUNNING IMAGE, NOT REMEMBERED.
;;;;       §2 walks the external symbols of the three packages on the submission
;;;;       path and keeps every one that names a condition class.  §3 parses the
;;;;       markdown table out of CONDITION-PARTITION.md.  §4 set-differences the
;;;;       two IN BOTH DIRECTIONS and exits non-zero on any disagreement — the
;;;;       same shape as form1-selftest's T-CODESET tooth, for the same reason:
;;;;       a transcribed catalogue is one document-edit from a lie, and this lane
;;;;       has already paid that bill once.
;;;;
;;;; EXACTNESS.  Every condition assertion is (EQ (TYPE-OF c) 'EXACT-CLASS).
;;;; Never (TYPEP c 'FAMILY), never (MEMBER c '(…)).  A menu of acceptable
;;;; classes may not stand in for the class a fixture produces.

(unless (find-package :lisp-plus-form1)
  (handler-bind ((style-warning #'muffle-warning))
    (load (merge-pathnames "form1.lisp" (or *load-truename*
                                            *default-pathname-defaults*)))))

(defpackage #:form1-condition-partition
  (:use #:cl)
  (:local-nicknames (#:f1 #:lisp-plus-form1)
                    (#:cd0 #:lisp-plus-cd0)
                    (#:s0 #:lisp-plus-slice0)
                    (#:s1 #:lisp-plus-slice1)
                    (#:s2 #:lisp-plus-slice2)))

(in-package #:form1-condition-partition)

(defparameter *here* (or *load-truename* *default-pathname-defaults*))
(defparameter *this-source* (merge-pathnames "CONDITION-PARTITION.lisp" *here*))
(defparameter *document* (merge-pathnames "CONDITION-PARTITION.md" *here*))

;;; ══════════════════════════════════════════════════════════════════════════
;;; 0.  HARNESS
;;; ══════════════════════════════════════════════════════════════════════════

(defparameter *checks* 0)
(defparameter *failed* 0)
(defparameter *failed-labels* '())

(defun check (condition label)
  (incf *checks*)
  (if condition
      (format t "  [~2,'0D] ok   ~A~%" *checks* label)
      (progn (incf *failed*)
             (push (format nil "[~2,'0D] ~A" *checks* label) *failed-labels*)
             (format t "  [~2,'0D] FAIL ~A~%" *checks* label))))

(defun section (title) (format t "~%── ~A~%" title))
(defun note (control &rest arguments)
  (format t "       ~A~%" (apply #'format nil control arguments)))

;;; THE ONE OBSERVATION PRIMITIVE.  CLASS is a LITERAL symbol at every use site,
;;; so the expansion installs a handler for exactly that class and nothing wider.
;;; Yields (values :SIGNALLED condition) or (values :RETURNED value).
(defmacro expecting (class &body body)
  `(handler-case (values :returned (progn ,@body))
     (,class (c) (values :signalled c))))

(defun exact-class-p (condition class)
  "EXACTNESS, not membership: the condition's OWN class, compared by EQ."
  (and condition (eq (type-of condition) class)))

(defun qualified-name (symbol)
  "PACKAGE:SYMBOL, in the form %HOST-TYPE-DESCRIPTOR produces — COMPUTED from
the symbol, never transcribed, so a rename cannot leave a stale literal here."
  (concatenate 'string (package-name (symbol-package symbol))
               ":" (symbol-name symbol)))

;;; The exercised-class ledger.  A row of the table is not evidence; a run is.
;;; Every fixture that reaches a terminal classification records it HERE, and §6
;;; compares this record of production against what the document claims is
;;; reachable — the same both-directions discipline as the inventory gate.
(defparameter *exercised* '())
(defun record-exercised (symbol) (pushnew symbol *exercised*))

(format t "~%════════════════════════════════════════════════════════════════~%")
(format t "  CONDITION-PARTITION — Language Form /1, Candidate /0~%")
(format t "  SBCL ~A~%" (lisp-implementation-version))
(format t "════════════════════════════════════════════════════════════════~%")

;;; ══════════════════════════════════════════════════════════════════════════
;;; 1.  THE FIXTURE WORLD.  Deterministic: no randomness, no clock, no I/O
;;;     except reading the companion document.
;;; ══════════════════════════════════════════════════════════════════════════

(defun idd (namespace path) (cd0:make-identifier-datum namespace path))
(defun ground (form) (s1:proposition form))
(defun pattern (form) (s1:proposition-pattern form))

(defparameter *base-schema* nil)

(defun install-registry ()
  "Clear and repopulate the Slice /1 registry with THE object *BASE-SCHEMA*
names.  Called at start and after every fixture that deliberately disturbs the
registry, so fixture order cannot leak."
  (s1:clear-schema-registry)
  (s1:register-schema *base-schema*)
  *base-schema*)

(setf *base-schema*
      (s1:judgment-schema
       :name :vr :version 1
       :conclusion (pattern '(:predicate :vr (:volume (:var :v))))
       :premises (list (pattern '(:predicate :vs (:volume (:var :v)))))))
(install-registry)

(defparameter *slice2-schema*
  (s2:make-slice2-schema
   :schema-id :vr/2
   :base-schema (s1:resolve-schema :vr 1)
   :premise-contracts
   (list (list 0 (s2:make-support-admission-contract
                  :contract-id :c
                  :accepted-clauses
                  '((:asserted-witness :mode :direct :kind :scan
                     :truth-ceiling :asserted)))))))

(defun scan-witness (volume)
  (s0:witness :for (ground `(:predicate :vs (:volume ,volume)))
              :mode :direct :kind :scan :source :clerk))

(defparameter *witness* (scan-witness "P7"))

(defun fresh-petition ()
  (f1:materialize-petition
   (f1:validate-petition
    (f1:propose-petition
     (f1:petition-datum :schema (f1:schema-reference "s")
                        :conclusion (f1:conclusion-reference "c")
                        :supports (list (f1:support-reference "w1"))
                        :receiver (f1:receiver-reference "r"))))
   (idd '("partition") '("occ" "1"))))

(defun sealed-context (&key (schema *slice2-schema*)
                            (conclusion (ground '(:predicate :vr (:volume "P7"))))
                            (support *witness*)
                            (receiver :live)
                            (tag "ctx"))
  "Build and seal a four-role context.  RECEIVER :LIVE builds a receiver context
accessible to SUPPORT; NIL binds explicit absence with the package-owned
declaration; any other value is bound as-is (used only to show the binder
refusing it)."
  (let ((context (f1:make-derivation-resolution-context)))
    (setf context (f1:bind-schema-reference
                   context (f1:schema-reference "s") schema
                   (idd '("partition") '("den" "schema"))))
    (setf context (f1:bind-conclusion-reference
                   context (f1:conclusion-reference "c") conclusion
                   (idd '("partition") '("den" "conclusion"))))
    (setf context (f1:bind-support-reference
                   context (f1:support-reference "w1") support
                   (idd '("partition") '("den" "support"))))
    (setf context (f1:bind-receiver-reference
                   context (f1:receiver-reference "r")
                   (if (eq receiver :live)
                       (s0:receiver-context
                        :context-id :desk
                        :accessible-supports (list (s0:witness-id support)))
                       receiver)
                   (if (null receiver)
                       (f1:receiver-absence-declaration)
                       (idd '("partition") '("den" "receiver")))))
    (f1:seal-resolution-context context (idd '("partition") (list "seal" tag)))))

(defun submit (context)
  (f1:submit-petition (fresh-petition) context
                      :by :clerk
                      :by-id (idd '("partition") '("by" "1"))
                      :act-id (idd '("partition") '("act" "1"))))

;;; ══════════════════════════════════════════════════════════════════════════
;;; 2.  THE LIVE INVENTORY, WALKED OUT OF THE RUNNING IMAGE.
;;;
;;;     Never a list anybody typed.  DO-EXTERNAL-SYMBOLS over each package on
;;;     the submission path; keep every symbol that FIND-CLASS resolves to a
;;;     class which SUBTYPEP says is a CONDITION.
;;; ══════════════════════════════════════════════════════════════════════════

(defparameter *scoped-packages* '("LISP-PLUS-SLICE1" "LISP-PLUS-SLICE2" "LISP-PLUS-FORM1"))

(defun condition-classes-of (package-name)
  (let ((package (find-package package-name))
        (found '()))
    (unless package
      (error "package ~S is not present in this image" package-name))
    (do-external-symbols (symbol package)
      (let ((class (find-class symbol nil)))
        (when (and class (subtypep symbol 'condition))
          (pushnew symbol found))))
    (sort found #'string< :key #'symbol-name)))

(defparameter *live*
  (loop for package in *scoped-packages* append (condition-classes-of package)))

(section "1. LIVE CONDITION INVENTORY (walked from the running image)")
(dolist (package *scoped-packages*)
  (let ((classes (condition-classes-of package)))
    (note "~A — ~D exported condition class~:[es~;~]" package (length classes) (= 1 (length classes)))
    (dolist (symbol classes) (note "    ~A" (qualified-name symbol)))))
(note "LIVE TOTAL: ~D" (length *live*))

;;; ══════════════════════════════════════════════════════════════════════════
;;; 3.  THE DOCUMENT'S TABLE, PARSED FROM THE MARKDOWN ITSELF.
;;;
;;;     THE HUMAN TABLE *IS* THE PARSED ARTEFACT.  There is deliberately no
;;;     machine-readable twin alongside it: a twin is a second thing to keep in
;;;     sync, which is the very defect this gate exists to prevent.
;;; ══════════════════════════════════════════════════════════════════════════

(defparameter +classes+
  '("PROTOCOL-REFUSAL" "GOVERNED-REFUSAL" "DOOR-REFUSAL" "ESCAPES" "UNREACHABLE"))

(defun trim (string)
  (string-trim '(#\Space #\Tab #\Return #\Newline #\` #\* #\|) string))

(defun split-row (line)
  (let ((cells '()) (start 0))
    (loop for i from 0 below (length line)
          when (char= (char line i) #\|)
            do (push (subseq line start i) cells) (setf start (1+ i)))
    (push (subseq line start) cells)
    (mapcar #'trim (nreverse cells))))

;;; The delimiters are matched as WHOLE HTML COMMENTS, assembled here from parts.
;;; Two reasons, and the first was learned the hard way in this file's own first
;;; run: prose that merely NAMES a bare marker token must not re-open the parser,
;;; and the assembled literals cannot themselves be mistaken for delimiters when
;;; this source is scanned.
(defparameter +table-begin+ (concatenate 'string "<!-- PARTITION-TABLE" "-BEGIN -->"))
(defparameter +table-end+ (concatenate 'string "<!-- PARTITION-TABLE" "-END -->"))

(defun parse-table-lines (lines)
  "Return (values ROWS PARSE-PROBLEMS).  ROWS is a list of (SYMBOL . CLASS-STRING).
A cell naming an absent package, an unknown symbol, or a symbol that is not
EXTERNAL is a PARSE PROBLEM and is REPORTED — never silently dropped.  Silently
dropping an unparseable row is how a table gate quietly stops gating."
  (let ((rows '()) (problems '()) (inside nil))
    (dolist (line lines)
      (cond ((search +table-begin+ line) (setf inside t))
            ((search +table-end+ line) (setf inside nil))
            ((and inside (plusp (length line)) (char= (char line 0) #\|))
             (let* ((cells (split-row line))
                    (name (second cells))
                    (class (third cells)))
               (when (and name (find #\: name) (not (string= name "SYMBOL")))
                 (let* ((colon (position #\: name))
                        (package-name (subseq name 0 colon))
                        (symbol-name (subseq name (1+ colon)))
                        (package (find-package package-name)))
                   (if (null package)
                       (push (format nil "row names absent package ~A" name) problems)
                       (multiple-value-bind (symbol status)
                           (find-symbol symbol-name package)
                         (cond ((null symbol)
                                (push (format nil "~A names no symbol" name) problems))
                               ((not (eq status :external))
                                (push (format nil "~A is not EXTERNAL" name) problems))
                               (t (push (cons symbol class) rows)))))))))))
    (values (nreverse rows) (nreverse problems))))

(defun file-lines (path)
  (with-open-file (stream path :direction :input :external-format :utf-8)
    (loop for line = (read-line stream nil nil) while line collect line)))

(defun read-table (path) (parse-table-lines (file-lines path)))

(multiple-value-bind (rows problems) (read-table *document*)
  (defparameter *table* rows)
  (defparameter *table-problems* problems))

(defparameter *tabled* (mapcar #'car *table*))

(section "2. DOCUMENT TABLE (parsed from CONDITION-PARTITION.md)")
(note "rows parsed: ~D" (length *table*))
(dolist (class-token +classes+)
  (note "~14A ~D" class-token
        (count class-token *table* :key #'cdr :test #'string=)))

(check (null *table-problems*)
       "the document's table parses clean: every row names an EXTERNAL symbol of a present package")
(when *table-problems*
  (dolist (problem *table-problems*) (note "PARSE PROBLEM: ~A" problem)))

(check (plusp (length *table*))
       "the document's table is non-empty (the markers were found and rows were read)")

(check (every (lambda (row) (member (cdr row) +classes+ :test #'string=)) *table*)
       (format nil "every row's class token is one of the ~D declared classes" (length +classes+)))
(dolist (row *table*)
  (unless (member (cdr row) +classes+ :test #'string=)
    (note "UNKNOWN CLASS TOKEN ~S on row ~A" (cdr row) (qualified-name (car row)))))

(check (= (length *tabled*) (length (remove-duplicates *tabled*)))
       "the document's table classifies each symbol exactly once (no duplicate rows)")

;;; TEETH FOR THE PARSER GATE.  A gate that has never fired is untested, not
;;; passing — so the parser is shown able to FAIL before its clean result on the
;;; real document is believed.  Three planted faults, one per problem class.
;;; (This is not decoration: the parser's FIRST run against the real document
;;; failed here, because prose naming a bare marker token re-opened the scan and
;;; swept in two later tables.  The delimiters became whole HTML comments as a
;;; result.  The tooth caught its own author.)
(let ((synthetic
        (list +table-begin+
              "| SYMBOL | CLASS | EVIDENCE | IF-IT-ARRIVED | WHY |"
              "|---|---|---|---|---|"
              "| `LISP-PLUS-SLICE1:PATTERN-USED-AS-GROUND` | ESCAPES | E | e | w |"
              "| `NO-SUCH-PACKAGE:SOMETHING` | ESCAPES | E | e | w |"
              "| `LISP-PLUS-SLICE1:NO-SUCH-SYMBOL-HERE` | ESCAPES | E | e | w |"
              +table-end+
              "| `LISP-PLUS-SLICE2:SLICE2-CONDITION` | ESCAPES | E | e | w |")))
  (multiple-value-bind (rows problems) (parse-table-lines synthetic)
    (check (= 1 (length rows))
           "PARSER TEETH: exactly ONE good row survives the planted faults — and the row AFTER the end-marker is not swept in")
    (check (and (= 1 (length rows)) (eq (car (first rows))
                                        'lisp-plus-slice1:pattern-used-as-ground))
           "PARSER TEETH: and it is the right row, with its class token intact")
    (check (= 2 (length problems))
           "PARSER TEETH: BOTH planted faults are REPORTED as problems, not silently dropped")))

;;; And the delimiters must actually delimit: an empty in-range region yields
;;; nothing rather than falling back to scanning the whole file.
(check (null (parse-table-lines
              (list "| `LISP-PLUS-SLICE1:DERIVATION-REFUSED` | ESCAPES | E | e | w |")))
       "PARSER TEETH: a table row OUTSIDE the markers is not parsed at all")

;;; ══════════════════════════════════════════════════════════════════════════
;;; 4.  THE STALENESS GATE — SET-DIFFERENCE, BOTH DIRECTIONS.
;;;     The T-CODESET shape, applied to condition classes instead of codes.
;;; ══════════════════════════════════════════════════════════════════════════

(section "3. INVENTORY GATE — live inventory vs. document table, both directions")

(defparameter *live-not-tabled* (set-difference *live* *tabled*))
(defparameter *tabled-not-live* (set-difference *tabled* *live*))

(note "live ~D · tabled ~D" (length *live*) (length *tabled*))
(when *live-not-tabled*
  (note "LIVE BUT UNCLASSIFIED: ~{~A ~}" (mapcar #'qualified-name *live-not-tabled*)))
(when *tabled-not-live*
  (note "CLASSIFIED BUT NOT LIVE: ~{~A ~}" (mapcar #'qualified-name *tabled-not-live*)))

(check (null *live-not-tabled*)
       (format nil "GATE (→): every one of the ~D LIVE condition classes is classified by the document — an unclassified class is exactly the defect this file exists to prevent"
               (length *live*)))

(check (null *tabled-not-live*)
       (format nil "GATE (←): every one of the ~D CLASSIFIED symbols is still a live exported condition class — the document names nothing that has been renamed or withdrawn"
               (length *tabled*)))

(check (and (= (length *live*) (length (remove-duplicates *live*)))
            (= (length *tabled*) (length (remove-duplicates *tabled*))))
       "GATE hygiene: neither set contains a duplicate, so both set-differences are over true sets")

;;; TEETH FOR THE INVENTORY GATE.  The clean result above is only evidence once
;;; the gate has been shown able to find something.  Both faults are planted
;;; against the REAL live inventory and run through the REAL parse-and-compare
;;; pipeline — not against a toy pair of lists, which would only test
;;; SET-DIFFERENCE.
;;; Computed against *LIVE* rather than *TABLED* ON PURPOSE: a teeth-check that
;;; reads the document cascades off any real fault in it, and a tooth that fails
;;; whenever the thing it guards fails reports nothing of its own.
(let* ((one-row-short (remove (first *live*) *live*))
       (one-row-extra (cons 'form1-condition-partition::not-a-condition-class *live*)))
  (check (equal (list (first *live*)) (set-difference *live* one-row-short))
         "GATE TEETH (→): drop ONE class from the compared set and the live∖table difference names exactly the dropped class — the forward gate fires")
  (check (equal (list 'form1-condition-partition::not-a-condition-class)
                (set-difference one-row-extra *live*))
         "GATE TEETH (←): add ONE symbol that is not a live condition class and the table∖live difference names exactly it — the reverse gate fires")
  (note "GATE TEETH: the forward gate would surface a dropped ~A"
        (qualified-name (first *live*))))

;;; ══════════════════════════════════════════════════════════════════════════
;;; 5.  T-NO-BLANKET — the harness proves its OWN second rule.
;;;     Scans this file's source text for a broad handler clause.  A rule stated
;;;     in a comment is a promise; a rule scanned out of the source is a check.
;;; ══════════════════════════════════════════════════════════════════════════

(section "4. T-NO-BLANKET — no broad handler anywhere in this file")

(defun source-text (path)
  (with-open-file (stream path :direction :input :external-format :utf-8)
    (let ((text (make-string (file-length stream))))
      (subseq text 0 (read-sequence text stream)))))

(defun count-occurrences (needle haystack)
  (loop with n = 0 with start = 0
        for hit = (search needle haystack :start2 start)
        while hit do (incf n) (setf start (1+ hit))
        finally (return n)))

;; Each needle is ASSEMBLED AT RUNTIME from two halves, so the whole literal
;; never appears in this source and the scanner's own vocabulary is not part of
;; the corpus it scans.  The expected count is therefore EXACTLY ZERO — not
;; "zero plus my own declaration", which is a tolerance a real handler could hide
;; inside.
(defparameter +banned-handler-forms+
  (list (concatenate 'string "(error " "() ")
        (concatenate 'string "(condition " "() ")
        (concatenate 'string "(serious-condition " "() ")
        (concatenate 'string "(warning " "() ")
        (concatenate 'string "(t " "() ")))

(let ((text (source-text *this-source*)))
  (dolist (form +banned-handler-forms+)
    (let ((n (count-occurrences form text)))
      (check (zerop n)
             (format nil "T-NO-BLANKET: the blanket clause ~S appears ~D time~:P — anything but 0 is a handler catching more than one named class"
                     form n))))
  ;; Teeth for the tooth: the scanner must be shown able to FIND something before
  ;; a clean result is believed.  A gate that has never fired is untested.
  (check (plusp (count-occurrences "handler-case" text))
         "T-NO-BLANKET teeth: the scanner does find HANDLER-CASE in this file, so a null result above is a measurement and not a broken search")
  ;; The needle is assembled so that the ONLY occurrence of the whole literal in
  ;; this file is the one the scanner constructs at runtime — otherwise the
  ;; check's own label is a match and the tooth convicts itself.  (It did, on the
  ;; first run.  The fix is the same split-literal discipline as the banned forms
  ;; above, and it is worth stating: a source scanner must be written so that its
  ;; own vocabulary is not part of the corpus it scans.)
  (let ((needle (concatenate 'string "ignore-" "errors")))
    (check (zerop (count-occurrences needle text))
           "T-NO-BLANKET: the quiet blanket handler (IGNORE- + ERRORS) appears nowhere in this file")))

;;; ══════════════════════════════════════════════════════════════════════════
;;; 6.  THE FIXTURES.  One per reachable class, every assertion EXACT.
;;; ══════════════════════════════════════════════════════════════════════════

(section "5. FIXTURE 1 — PROTOCOL-REFUSAL: refused BEFORE DERIVE/2 is invoked")

;; An unsealed context.  SUBMIT-PETITION's third gate, well before any resolution.
(multiple-value-bind (status condition)
    (expecting f1:petition-refused
      (submit (f1:make-derivation-resolution-context)))
  (check (eq status :signalled) "F1: an unsealed context signals rather than returning an outcome")
  (check (exact-class-p condition 'f1:petition-refused)
         "F1: the condition's class is EXACTLY LISP-PLUS-FORM1:PETITION-REFUSED")
  (when (exact-class-p condition 'f1:petition-refused)
    (record-exercised 'f1:petition-refused)
    (let ((refusal (f1:petition-refused-refusal condition)))
      (check (eq :context-not-sealed (f1:petition-refusal-code refusal))
             "F1: the code is EXACTLY :CONTEXT-NOT-SEALED")
      (check (eq :submit (f1:petition-refusal-phase refusal))
             "F1: the phase is EXACTLY :SUBMIT — Form /1's own, not Slice /2's")
      (check (member (f1:petition-refusal-code refusal)
                     (f1:petition-protocol-refusal-codes))
             "F1: the code is in the LIVE published protocol-refusal catalogue"))))

(section "6. FIXTURE 2 — GOVERNED-REFUSAL: SLICE2-DERIVATION-REFUSED is caught")

;; The bound support witnesses a different volume, so the premise is not satisfied.
(let ((outcome (submit (sealed-context :support (scan-witness "WRONG") :tag "gov"))))
  (check (f1:petition-submission-outcome-p outcome)
         "F2: a Form /1 outcome object exists — the condition did NOT escape")
  (check (eq :governed-refusal (f1:petition-submission-outcome-kind outcome))
         "F2: the outcome kind is EXACTLY :GOVERNED-REFUSAL")
  (let ((condition (f1:petition-submission-outcome-condition outcome))
        (receipt (f1:petition-submission-outcome-receipt outcome)))
    (check (exact-class-p condition 'lisp-plus-slice2:slice2-derivation-refused)
           "F2: the retained condition's class is EXACTLY LISP-PLUS-SLICE2:SLICE2-DERIVATION-REFUSED")
    (when (exact-class-p condition 'lisp-plus-slice2:slice2-derivation-refused)
      (record-exercised 'lisp-plus-slice2:slice2-derivation-refused))
    (check (string= (qualified-name 'lisp-plus-slice2:slice2-derivation-refused)
                    (or (f1:petition-submission-receipt-slice2-condition-class receipt) ""))
           "F2: the submission receipt records that exact class name (computed from the symbol, not transcribed)")
    (check (s2:slice2-receipt-p (f1:petition-submission-outcome-slice2-receipt outcome))
           "F2: the Slice /2 receipt travelled out with the outcome — the governed account survives")
    (check (null (f1:petition-submission-outcome-claim outcome))
           "F2: no claim was minted on a refusal")))

(section "7. FIXTURE 3 — DOOR-REFUSAL: SLICE2-SCHEMA-ERROR is caught (two provocations)")

;; 3a.  The registry now holds a DIFFERENT object under (:VR 1).  DERIVE/2's
;;      (EQ registered base) check refuses: the anatomy it cannot confirm.
(let ((context (sealed-context :tag "door-a")))
  (s1:clear-schema-registry)
  (s1:register-schema (s1:judgment-schema
                       :name :vr :version 1
                       :conclusion (pattern '(:predicate :vr (:volume (:var :v))))
                       :premises (list (pattern '(:predicate :vs (:volume (:var :v)))))))
  (let ((outcome (submit context)))
    (check (f1:petition-submission-outcome-p outcome)
           "F3a: a Form /1 outcome object exists — the condition did NOT escape")
    (check (eq :door-refusal (f1:petition-submission-outcome-kind outcome))
           "F3a: a schema re-registered as a DIFFERENT object under the same key yields EXACTLY :DOOR-REFUSAL")
    (let ((condition (f1:petition-submission-outcome-condition outcome))
          (receipt (f1:petition-submission-outcome-receipt outcome)))
      (check (exact-class-p condition 'lisp-plus-slice2:slice2-schema-error)
             "F3a: the retained condition's class is EXACTLY LISP-PLUS-SLICE2:SLICE2-SCHEMA-ERROR (the family base, not a subtype)")
      (when (exact-class-p condition 'lisp-plus-slice2:slice2-schema-error)
        (record-exercised 'lisp-plus-slice2:slice2-schema-error))
      (check (string= (qualified-name 'lisp-plus-slice2:slice2-schema-error)
                      (or (f1:petition-submission-receipt-slice2-condition-class receipt) ""))
             "F3a: the submission receipt records that exact class name")
      (check (null (f1:petition-submission-outcome-slice2-receipt outcome))
             "F3a: a door refusal carries NO Slice /2 receipt — the act never reached a governed account"))))
(install-registry)

;; 3b.  The registry is EMPTY.  RESOLVE-SCHEMA would signal SCHEMA-NOT-FOUND, but
;;      DERIVE/2 swallows that in its own HANDLER-CASE and refuses with a
;;      SLICE2-SCHEMA-ERROR instead — which is why SCHEMA-NOT-FOUND is
;;      classified UNREACHABLE rather than ESCAPES.  This fixture is the
;;      evidence for that row.
(let ((context (sealed-context :tag "door-b")))
  (s1:clear-schema-registry)
  (let ((outcome (submit context)))
    (check (eq :door-refusal (f1:petition-submission-outcome-kind outcome))
           "F3b: an EMPTY registry also yields EXACTLY :DOOR-REFUSAL")
    (check (exact-class-p (f1:petition-submission-outcome-condition outcome)
                          'lisp-plus-slice2:slice2-schema-error)
           "F3b: the class is EXACTLY SLICE2-SCHEMA-ERROR — SCHEMA-NOT-FOUND does NOT escape here, which is the whole reason that row reads UNREACHABLE")))
(install-registry)

(section "8. FIXTURE 4 — ESCAPE: PATTERN-USED-AS-GROUND")

(multiple-value-bind (status condition)
    (expecting lisp-plus-slice1:pattern-used-as-ground
      (submit (sealed-context
               :conclusion (pattern '(:predicate :vr (:volume (:var :v))))
               :tag "esc-pattern")))
  (check (eq status :signalled)
         "F4: a proposition-PATTERN bound as the conclusion signals — no outcome is returned")
  (check (exact-class-p condition 'lisp-plus-slice1:pattern-used-as-ground)
         "F4: the escaping class is EXACTLY LISP-PLUS-SLICE1:PATTERN-USED-AS-GROUND")
  (when (exact-class-p condition 'lisp-plus-slice1:pattern-used-as-ground)
    (record-exercised 'lisp-plus-slice1:pattern-used-as-ground))
  (check (eq :conclusion (s1:slice1-condition-offending-field condition))
         "F4: it names :CONCLUSION as the offending field — it came through the unchecked conclusion binder")
  (check (null (s1:slice1-condition-receipt condition))
         "F4: it carries NO receipt (pre-threshold), so the escape destroys nothing Slice /1 had built"))

(section "9. FIXTURE 5 — ESCAPE: MALFORMED-STRUCTURED-PROPOSITION (two malformations)")

(multiple-value-bind (status condition)
    (expecting lisp-plus-slice1:malformed-structured-proposition
      (submit (sealed-context :conclusion 17 :tag "esc-int")))
  (check (eq status :signalled) "F5a: an integer conclusion signals — no outcome is returned")
  (check (exact-class-p condition 'lisp-plus-slice1:malformed-structured-proposition)
         "F5a: the escaping class is EXACTLY LISP-PLUS-SLICE1:MALFORMED-STRUCTURED-PROPOSITION")
  (when (exact-class-p condition 'lisp-plus-slice1:malformed-structured-proposition)
    (record-exercised 'lisp-plus-slice1:malformed-structured-proposition)))

(multiple-value-bind (status condition)
    (expecting lisp-plus-slice1:malformed-structured-proposition
      (submit (sealed-context :conclusion '(:notpred :x) :tag "esc-head")))
  (check (eq status :signalled) "F5b: a bad-head list conclusion signals — no outcome is returned")
  (check (exact-class-p condition 'lisp-plus-slice1:malformed-structured-proposition)
         "F5b: same EXACT class from a structurally different malformation"))

(section "10. FIXTURE 6 — ESCAPE: UNBOUND-CONCLUSION-VARIABLE (and what it destroys)")

(multiple-value-bind (status condition)
    (expecting lisp-plus-slice1:unbound-conclusion-variable
      (submit (sealed-context
               :conclusion (ground '(:predicate :other (:volume "P7")))
               :tag "esc-unbound")))
  (check (eq status :signalled)
         "F6: a lawful ground conclusion that does not ground the schema's conclusion variables signals")
  (check (exact-class-p condition 'lisp-plus-slice1:unbound-conclusion-variable)
         "F6: the escaping class is EXACTLY LISP-PLUS-SLICE1:UNBOUND-CONCLUSION-VARIABLE")
  (when (exact-class-p condition 'lisp-plus-slice1:unbound-conclusion-variable)
    (record-exercised 'lisp-plus-slice1:unbound-conclusion-variable))
  (let ((receipt (s1:slice1-condition-receipt condition)))
    (check (s1:derivation-receipt-p receipt)
           "F6: it DOES carry a real Slice /1 derivation receipt — this is the post-threshold refusal")
    (check (eq :refused (s1:derivation-receipt-decision receipt))
           "F6: that receipt's decision is :REFUSED — a genuine governed account exists")
    (note "F6 — THE COST: that receipt reaches the caller only inside the escaping condition.")
    (note "F6 — No submission receipt is minted, so nothing records that the act occurred.")))

(section "11. FIXTURE 7 — the raw host TYPE-ERROR receiver path: STILL REACHABLE?")

;; Leg 1 — the door is real ONE LAYER DOWN.  Slice /1 DERIVE, receiver 42.
(multiple-value-bind (status condition)
    (expecting cl:type-error
      (s1:derive :schema-name :vr :schema-version 1
                 :conclusion (ground '(:predicate :vr (:volume "P7")))
                 :supports (list *witness*) :receiver 42 :by :clerk))
  (check (eq status :signalled)
         "F7a: LISP-PLUS-SLICE1:DERIVE with :RECEIVER 42 does signal — the door is real")
  (check (typep condition 'cl:type-error)
         "F7a: and it is a raw host CL:TYPE-ERROR, from the RECEIVER-CONTEXT-CONTEXT-ID struct accessor")
  (note "F7a: ~S" (and condition (type-of condition))))

;; Leg 2 — Slice /2 does not guard it either.
(multiple-value-bind (status condition)
    (expecting cl:type-error
      (s2:derive/2 :schema *slice2-schema*
                   :conclusion (ground '(:predicate :vr (:volume "P7")))
                   :supports (list *witness*) :receiver 42 :by :clerk))
  (check (eq status :signalled)
         "F7b: LISP-PLUS-SLICE2:DERIVE/2 with :RECEIVER 42 signals too — Slice /2 adds no guard")
  (check (typep condition 'cl:type-error)
         "F7b: still a raw host CL:TYPE-ERROR at the Slice /2 surface"))

;; Leg 3 — and Form /1 CLOSES it, at bind time, before any context is sealed.
(dolist (bogus (list 42 "desk" :desk))
  (multiple-value-bind (status condition)
      (expecting f1:petition-refused
        (f1:bind-receiver-reference (f1:make-derivation-resolution-context)
                                    (f1:receiver-reference "r")
                                    bogus
                                    (idd '("partition") '("den" "receiver"))))
    (check (eq status :signalled)
           (format nil "F7c: BIND-RECEIVER-REFERENCE refuses ~S rather than binding it" bogus))
    (check (exact-class-p condition 'f1:petition-refused)
           (format nil "F7c: the class is EXACTLY PETITION-REFUSED for ~S — not a TYPE-ERROR" bogus))
    (when (exact-class-p condition 'f1:petition-refused)
      (check (eq :wrong-receiver-species
                 (f1:petition-refusal-code (f1:petition-refused-refusal condition)))
             (format nil "F7c: the code is EXACTLY :WRONG-RECEIVER-SPECIES for ~S" bogus)))))

(note "F7 VERDICT: the raw TYPE-ERROR receiver path is NOT reachable through the")
(note "F7          Form /1 public boundary.  It is sealed by ONE species check in")
(note "F7          BIND-RECEIVER-REFERENCE, whose deletion reopens it silently.")

(section "12. FIXTURE 8 — an explicitly-ABSENT receiver reaches DERIVE/2 without a host error")

;; The NIL-receiver branch is the other half of the receiver binder.  It must
;; produce an ordinary classified outcome, not a condition of any kind.
(let ((outcome (submit (sealed-context :receiver nil :tag "absent"))))
  (check (f1:petition-submission-outcome-p outcome)
         "F8: an explicitly-absent receiver yields an ordinary Form /1 outcome — the NIL-guards in %SUPPORT-ACCESSIBLE-P hold")
  (check (member (f1:petition-submission-outcome-kind outcome)
                 '(:granted :governed-refusal :door-refusal))
         "F8: and its kind is one of the three terminal classifications")
  (note "F8: outcome kind ~S" (f1:petition-submission-outcome-kind outcome)))

(section "13. FIXTURE 9 — the control: a clean grant leaves a full semantic object")

(let ((outcome (submit (sealed-context :tag "grant"))))
  (check (eq :granted (f1:petition-submission-outcome-kind outcome))
         "F9: the matched-witness case grants — the fixture world is sound and the escapes above are not artefacts of a broken setup")
  (check (null (f1:petition-submission-outcome-condition outcome))
         "F9: a grant retains no condition")
  (check (s2:slice2-receipt-p (f1:petition-submission-outcome-slice2-receipt outcome))
         "F9: a grant carries its Slice /2 receipt"))

;;; ══════════════════════════════════════════════════════════════════════════
;;; 7.  COVERAGE GATE — the document's reachability claims vs. THIS RUN.
;;;     Both directions again, for the same reason.
;;; ══════════════════════════════════════════════════════════════════════════

(section "14. COVERAGE GATE — classified-reachable vs. actually-exercised")

(defparameter +reachable-tokens+
  '("PROTOCOL-REFUSAL" "GOVERNED-REFUSAL" "DOOR-REFUSAL" "ESCAPES"))

(defparameter *claimed-reachable*
  (loop for (symbol . class) in *table*
        when (member class +reachable-tokens+ :test #'string=) collect symbol))

(defparameter *claimed-not-exercised* (set-difference *claimed-reachable* *exercised*))
(defparameter *exercised-not-claimed* (set-difference *exercised* *claimed-reachable*))

(note "claimed reachable ~D · exercised ~D"
      (length *claimed-reachable*) (length *exercised*))
(when *claimed-not-exercised*
  (note "CLAIMED REACHABLE BUT NEVER EXERCISED: ~{~A ~}"
        (mapcar #'qualified-name *claimed-not-exercised*)))
(when *exercised-not-claimed*
  (note "EXERCISED BUT NOT CLAIMED REACHABLE: ~{~A ~}"
        (mapcar #'qualified-name *exercised-not-claimed*)))

(check (null *claimed-not-exercised*)
       (format nil "COVERAGE (→): every one of the ~D classes the document calls reachable was reached by a fixture in this run"
               (length *claimed-reachable*)))

(check (null *exercised-not-claimed*)
       (format nil "COVERAGE (←): every one of the ~D classes a fixture actually reached is classified reachable by the document"
               (length *exercised*)))

;;; ══════════════════════════════════════════════════════════════════════════
;;; 8.  THE PARTITION, AS THIS RUN MEASURED IT
;;; ══════════════════════════════════════════════════════════════════════════

(section "15. THE PARTITION")

(dolist (class-token +classes+)
  (let ((members (loop for (symbol . class) in *table*
                       when (string= class class-token) collect symbol)))
    (format t "~%       ~A — ~D~%" class-token (length members))
    (dolist (symbol members)
      (format t "         ~A~A~%" (qualified-name symbol)
              (if (member symbol *exercised*) "   [EXERCISED]" "   [READ]")))))

(format t "~%       CL:TYPE-ERROR (off-inventory, no package export to gate against)~%")
(format t "         UNREACHABLE through the Form /1 boundary — sealed at BIND-RECEIVER-REFERENCE~%")
(format t "         [EXERCISED: real at Slice /1 and Slice /2, refused at the Form /1 binder]~%")

(format t "~%── Everything else ESCAPES.  This file says which everything.  ──~%")

(when (plusp *failed*)
  (format t "~%   FAILED CHECKS:~%")
  (dolist (label (reverse *failed-labels*)) (format t "     ~A~%" label)))

(format t "~%== CONDITION-PARTITION: ~D checks passed / ~D failed ==~%"
        (- *checks* *failed*) *failed*)

(when (plusp *failed*)
  (sb-ext:exit :code 1))
