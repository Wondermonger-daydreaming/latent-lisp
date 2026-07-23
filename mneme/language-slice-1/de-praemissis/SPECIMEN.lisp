;;;; SPECIMEN.lisp — de-praemissis: the founding Slice /1 regression specimen.
;;;;
;;;; An executable argument.  ONE judgment schema — :artifact-admissibility v1 —
;;;; declares the anatomy of "this artifact is admissible for this receiver and
;;;; this purpose": four required premises (digest-matches, signature-valid,
;;;; receiver-recognizes-signer, provenance-admissible).  Because the anatomy is
;;;; DECLARED, an omitted, mismatched, refuted, inaccessible, or wrong-receiver
;;;; premise becomes mechanically visible in a derivation receipt BEFORE the
;;;; conclusion can be granted — and the grant, when it comes, is a real Slice /0
;;;; promotion keyed to the derivation, not to opaque content.  The S3 species
;;;; (BASELINE's silent skip; ABLATION's reproduction) is impossible here.
;;;;
;;;; FRONT-DOOR DISCIPLINE: this file uses ONLY the single-colon public surfaces
;;;; of Slice /0, Slice /1, and kernel0 — single colon only, no internal-symbol
;;;; access anywhere (grep-verified zero at closure).
;;;;
;;;; Run: sbcl --non-interactive --load SPECIMEN.lisp   (exits 0 on 12/12)

(unless (find-package :lisp-plus-slice1)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../slice1.lisp" *load-truename*))))

(defpackage #:de-praemissis-specimen (:use #:cl))
(in-package #:de-praemissis-specimen)

;;; Public-surface nicknames (single colon everywhere).
(defun p (form) (lisp-plus-slice1:proposition form))
(defun pat (form) (lisp-plus-slice1:proposition-pattern form))

(defun sw (form &key (kind :observation) (source :signer))
  "A GROUND direct support witness for structured proposition FORM."
  (lisp-plus-slice0:witness :for (p form) :mode :direct :kind kind :source source))

(defun mk-ctx (id &rest supports)
  "A receiver-context whose accessible-supports are the witness ids among
SUPPORTS (refutations, which have no witness id, are ignored for accessibility)."
  (lisp-plus-slice0:receiver-context
   :context-id id
   :accessible-supports
   (mapcar #'lisp-plus-slice0:witness-id
           (remove-if-not #'lisp-plus-slice0:witness-p supports))))

(defun split-lines (string)
  "Split STRING on newlines into a list of lines (no external deps)."
  (loop with start = 0
        for nl = (position #\Newline string :start start)
        collect (subseq string start (or nl (length string)))
        while nl do (setf start (1+ nl))))

(defun assessment-for (receipt predicate)
  "Find the premise-assessment for PREDICATE in RECEIPT."
  (find predicate (lisp-plus-slice1:derivation-receipt-assessments receipt)
        :key (lambda (a)
               (second (lisp-plus-slice1:premise-assessment-premise-pattern a)))))

(defun disp (receipt predicate)
  (lisp-plus-slice1:premise-assessment-disposition
   (assessment-for receipt predicate)))

(defun roles-of-mismatch (receipt predicate)
  "The conflicting roles named on the first mismatched candidate of PREDICATE."
  (let ((mc (lisp-plus-slice1:premise-assessment-mismatched-candidates
             (assessment-for receipt predicate))))
    (and mc (cdr (first mc)))))

(defun attempt (&key conclusion supports receiver)
  "Run DERIVE; return (values RECEIPT GRANTED-CLAIM).  On refusal the receipt is
recovered from the typed condition, so callers get the receipt either way."
  (handler-case
      (multiple-value-bind (claim receipt)
          (lisp-plus-slice1:derive
           :schema-name :artifact-admissibility :schema-version 1
           :conclusion conclusion :supports supports :receiver receiver)
        (values receipt claim))
    (lisp-plus-slice1:derivation-refused (c)
      (values (lisp-plus-slice1:slice1-condition-receipt c) nil))))

;;; ------------------------------------------------------------------
;;; The founding schema: artifact admissibility for a receiver + purpose.
;;; Conclusion vars: :art :rcv :pur.  Schema-locals: :dig :sig :key :signer.

(defun install-schema ()
  (lisp-plus-slice1:clear-schema-registry)
  (lisp-plus-slice1:register-schema
   (lisp-plus-slice1:judgment-schema
    :name :artifact-admissibility :version 1
    :conclusion (pat '(:predicate :artifact-admissible
                       (:artifact (:var :art)) (:receiver (:var :rcv))
                       (:purpose (:var :pur))))
    :premises
    (list (pat '(:predicate :digest-matches
                 (:artifact (:var :art)) (:expected (:var :dig))))
          (pat '(:predicate :signature-valid
                 (:artifact (:var :art)) (:signature (:var :sig)) (:key (:var :key))))
          (pat '(:predicate :receiver-recognizes-signer
                 (:receiver (:var :rcv)) (:signer (:var :signer))))
          (pat '(:predicate :provenance-admissible
                 (:artifact (:var :art)) (:receiver (:var :rcv)) (:purpose (:var :pur)))))
    :locals '(:dig :sig :key :signer))))

;;; Support constructors keyed on the roles a behavior needs to vary.
(defun s-digest (&key (art "artifact-1") (dig "D1"))
  (sw `(:predicate :digest-matches (:artifact ,art) (:expected ,dig))))
(defun s-signature (&key (art "artifact-1") (sig "S1") (key "K1"))
  (sw `(:predicate :signature-valid (:artifact ,art) (:signature ,sig) (:key ,key))))
(defun s-recognizes (&key (rcv :receiver-a) (signer "signer-acme"))
  (sw `(:predicate :receiver-recognizes-signer (:receiver ,rcv) (:signer ,signer))))
(defun s-provenance (&key (art "artifact-1") (rcv :receiver-a) (pur :production))
  (sw `(:predicate :provenance-admissible (:artifact ,art) (:receiver ,rcv) (:purpose ,pur))))

(defun full-supports (&key (art "artifact-1") (rcv :receiver-a) (pur :production))
  (list (s-digest :art art) (s-signature :art art)
        (s-recognizes :rcv rcv) (s-provenance :art art :rcv rcv :pur pur)))

(defun conclusion (&key (art "artifact-1") (rcv :receiver-a) (pur :production))
  (p `(:predicate :artifact-admissible (:artifact ,art) (:receiver ,rcv) (:purpose ,pur))))

;;; ==================================================================
;;; Harness.

(defvar *demonstrated* 0)
(defvar *behaviors* 12)

(defun hd (n title) (format t "~%── behavior ~D: ~A~%" n title))
(defun ln (fmt &rest args) (format t "   ") (apply #'format t fmt args) (terpri))
(defun pass (n msg)
  (incf *demonstrated*)
  (format t "   ✓ [~D] ~A~%" n msg))
(defun expect (bool)
  (unless bool (error "SPECIMEN INVARIANT VIOLATED — a behavior did not hold")))

(install-schema)
(format t "== de-praemissis SPECIMEN — Slice /1, schema :artifact-admissibility v1 ==~%")

;;; ---- behavior 1 : digest-match alone cannot grant ----
(hd 1 "digest-match support alone ⇒ refusal; receipt shows the other three missing")
(let* ((sup (list (s-digest)))
       (r (attempt :conclusion (conclusion) :supports sup
                   :receiver (apply #'mk-ctx :ctx sup))))
  (ln "decision: ~S" (lisp-plus-slice1:derivation-receipt-decision r))
  (ln "digest-matches=~S  signature-valid=~S  recognition=~S  provenance=~S"
      (disp r :digest-matches) (disp r :signature-valid)
      (disp r :receiver-recognizes-signer) (disp r :provenance-admissible))
  (expect (eq (lisp-plus-slice1:derivation-receipt-decision r) :refused))
  (expect (eq (disp r :digest-matches) :satisfied))
  (expect (eq (disp r :signature-valid) :missing))
  (expect (eq (disp r :receiver-recognizes-signer) :missing))
  (expect (eq (disp r :provenance-admissible) :missing))
  (pass 1 "refused; signature+recognition+provenance all :missing"))

;;; ---- behavior 2 : digest+signature still refused ----
(hd 2 "digest+signature ⇒ still refused (recognition + provenance missing)")
(let* ((sup (list (s-digest) (s-signature)))
       (r (attempt :conclusion (conclusion) :supports sup
                   :receiver (apply #'mk-ctx :ctx sup))))
  (ln "decision: ~S ; recognition=~S provenance=~S"
      (lisp-plus-slice1:derivation-receipt-decision r)
      (disp r :receiver-recognizes-signer) (disp r :provenance-admissible))
  (expect (eq (lisp-plus-slice1:derivation-receipt-decision r) :refused))
  (expect (eq (disp r :receiver-recognizes-signer) :missing))
  (pass 2 "refused despite two satisfied premises"))

;;; ---- behavior 3 : signature stays satisfied while recognition is missing ----
(hd 3 "the signature-valid premise stays :satisfied beside recognition :missing")
(let* ((sup (list (s-digest) (s-signature)))
       (r (attempt :conclusion (conclusion) :supports sup
                   :receiver (apply #'mk-ctx :ctx sup))))
  (ln "signature-valid disposition       : ~S" (disp r :signature-valid))
  (ln "receiver-recognizes-signer        : ~S" (disp r :receiver-recognizes-signer))
  (expect (eq (disp r :signature-valid) :satisfied))
  (expect (eq (disp r :receiver-recognizes-signer) :missing))
  (pass 3 "a valid signature is not contaminated by a missing sibling premise"))

;;; ---- behavior 4 : missing recognition ⇒ NAMED refusal ----
(hd 4 "missing recognition ⇒ a NAMED refusal (premise pattern + :missing), not generic")
(let* ((sup (list (s-digest) (s-signature) (s-provenance)))
       (r (attempt :conclusion (conclusion) :supports sup
                   :receiver (apply #'mk-ctx :ctx sup)))
       (a (assessment-for r :receiver-recognizes-signer)))
  (ln "named premise : ~S" (second (lisp-plus-slice1:premise-assessment-premise-pattern a)))
  (ln "disposition   : ~S" (lisp-plus-slice1:premise-assessment-disposition a))
  (ln "strongest-lawful-result: ~S"
      (lisp-plus-slice1:derivation-receipt-strongest-lawful-result r))
  (expect (eq (second (lisp-plus-slice1:premise-assessment-premise-pattern a))
              :receiver-recognizes-signer))
  (expect (eq (lisp-plus-slice1:premise-assessment-disposition a) :missing))
  (pass 4 "the refusal names :receiver-recognizes-signer as the blocking premise"))

;;; ---- behavior 5 : receiver-a recognition does NOT discharge receiver-b ----
(hd 5 "receiver-a's recognition does NOT discharge receiver-b's conclusion (⇒ :mismatched :receiver)")
(let* ((sup (list (s-digest) (s-signature)
                  (s-recognizes :rcv :receiver-a)          ; recognition for A
                  (s-provenance :rcv :receiver-b)))        ; provenance for B
       (r (attempt :conclusion (conclusion :rcv :receiver-b) :supports sup
                   :receiver (apply #'mk-ctx :ctx sup))))
  (ln "recognition disposition : ~S ; conflicting roles : ~S"
      (disp r :receiver-recognizes-signer)
      (roles-of-mismatch r :receiver-recognizes-signer))
  (expect (eq (disp r :receiver-recognizes-signer) :mismatched))
  (expect (equal (roles-of-mismatch r :receiver-recognizes-signer) '(:receiver)))
  (pass 5 "A's recognition lands :mismatched on role :receiver against a B-conclusion"))

;;; ---- behavior 6 : :staging provenance does not discharge :production ----
(hd 6 ":staging provenance does not discharge a :production conclusion (⇒ :mismatched :purpose)")
(let* ((sup (list (s-digest) (s-signature) (s-recognizes)
                  (s-provenance :pur :staging)))           ; staging, not production
       (r (attempt :conclusion (conclusion :pur :production) :supports sup
                   :receiver (apply #'mk-ctx :ctx sup))))
  (ln "provenance disposition : ~S ; conflicting roles : ~S"
      (disp r :provenance-admissible) (roles-of-mismatch r :provenance-admissible))
  (expect (eq (disp r :provenance-admissible) :mismatched))
  (expect (equal (roles-of-mismatch r :provenance-admissible) '(:purpose)))
  (pass 6 ":staging support lands :mismatched on role :purpose"))

;;; ---- behavior 7 : another artifact's premise cannot discharge ----
(hd 7 "another artifact's premise cannot discharge this artifact (⇒ :mismatched :artifact)")
(let* ((sup (list (s-digest :art "artifact-2")             ; wrong artifact
                  (s-signature) (s-recognizes) (s-provenance)))
       (r (attempt :conclusion (conclusion :art "artifact-1") :supports sup
                   :receiver (apply #'mk-ctx :ctx sup))))
  (ln "digest disposition : ~S ; conflicting roles : ~S"
      (disp r :digest-matches) (roles-of-mismatch r :digest-matches))
  (expect (eq (disp r :digest-matches) :mismatched))
  (expect (equal (roles-of-mismatch r :digest-matches) '(:artifact)))
  (pass 7 "artifact-2's digest lands :mismatched on role :artifact"))

;;; ---- behavior 8 : inaccessible recognition ⇒ :inaccessible residue, not :missing ----
(hd 8 "an inaccessible recognition support is :inaccessible residue, NOT :missing")
(let* ((recog (s-recognizes))
       (sup (list (s-digest) (s-signature) recog (s-provenance)))
       ;; ctx accessible to everything EXCEPT the recognition witness
       (ctx (apply #'mk-ctx :ctx (remove recog sup)))
       (r (attempt :conclusion (conclusion) :supports sup :receiver ctx))
       (a (assessment-for r :receiver-recognizes-signer)))
  (ln "disposition                       : ~S" (disp r :receiver-recognizes-signer))
  (ln "matching-accessible-supports      : ~S"
      (lisp-plus-slice1:premise-assessment-matching-accessible-supports a))
  (ln "matching-inaccessible-supports (n): ~D"
      (length (lisp-plus-slice1:premise-assessment-matching-inaccessible-supports a)))
  (expect (eq (disp r :receiver-recognizes-signer) :inaccessible))
  (expect (null (lisp-plus-slice1:premise-assessment-matching-accessible-supports a)))
  (expect (lisp-plus-slice1:premise-assessment-matching-inaccessible-supports a))
  (pass 8 "a present-but-unreachable support is residue (:inaccessible), distinct from :missing"))

;;; ---- behavior 9 : refuted provenance blocks even with positive support ----
(hd 9 "refuted provenance blocks even with positive support present — BOTH visible")
(let* ((sup (append (full-supports)
                    (list (lisp-plus-slice1:refutation
                           :refutes '(:predicate :provenance-admissible
                                      (:artifact "artifact-1") (:receiver :receiver-a)
                                      (:purpose :production))
                           :source :auditor))))
       (ctx (apply #'mk-ctx :ctx (remove-if-not #'lisp-plus-slice0:witness-p sup)))
       (r (attempt :conclusion (conclusion) :supports sup :receiver ctx))
       (a (assessment-for r :provenance-admissible)))
  (ln "disposition                  : ~S" (disp r :provenance-admissible))
  (ln "positive support present     : ~S"
      (and (lisp-plus-slice1:premise-assessment-matching-accessible-supports a) t))
  (ln "refuting support present     : ~S"
      (and (lisp-plus-slice1:premise-assessment-refuting-supports a) t))
  (expect (eq (disp r :provenance-admissible) :refuted))
  (expect (lisp-plus-slice1:premise-assessment-matching-accessible-supports a))
  (expect (lisp-plus-slice1:premise-assessment-refuting-supports a))
  (pass 9 "positive AND refuting evidence both preserved; premise :refuted, never erased"))

;;; ---- behavior 10 : full coherent discharge ⇒ :granted, a real Slice /0 promotion ----
(hd 10 "full coherent discharge ⇒ :granted, a real Slice /0 promotion")
(let* ((sup (full-supports))
       (ctx (apply #'mk-ctx :ctx sup)))
  (multiple-value-bind (r claim) (attempt :conclusion (conclusion) :supports sup :receiver ctx)
    (let ((jr (lisp-plus-slice0:claim-judgment claim)))
      (ln "receipt decision  : ~S" (lisp-plus-slice1:derivation-receipt-decision r))
      (ln "granted claim prop: ~S" (lisp-plus-slice0:claim-proposition claim))
      (ln "judgment-record   : ~S (procedure v~S)"
          (lisp-plus-slice0:judgment-record-judgment jr)
          (lisp-plus-slice0:judgment-record-procedure-version jr))
      (expect (eq (lisp-plus-slice1:derivation-receipt-decision r) :granted))
      (expect (lisp-plus-slice0:claim-p claim))
      (expect (eq (lisp-plus-slice0:judgment-record-judgment jr) :verified))
      (pass 10 "a real Slice /0 :verified promotion, keyed to the derivation"))))

;;; ---- behavior 11 : why names every satisfied AND unsatisfied premise ----
(hd 11 "why / render-derivation-why names every satisfied AND unsatisfied premise")
(let* ((sup (list (s-digest) (s-signature)))   ; 2 satisfied, 2 unsatisfied
       (r (attempt :conclusion (conclusion) :supports sup
                   :receiver (apply #'mk-ctx :ctx sup))))
  (ln "why façade returns the receipt itself: ~S" (eq (lisp-plus-slice1:why r) r))
  (format t "   ---- render-derivation-why ----~%")
  (let ((text (with-output-to-string (s)
                (lisp-plus-slice1:render-derivation-why r s))))
    (dolist (l (remove "" (split-lines text) :test #'string=))
      (format t "   ~A~%" l))
    (expect (search "DIGEST-MATCHES" (string-upcase text)))
    (expect (search "SIGNATURE-VALID" (string-upcase text)))
    (expect (search "RECEIVER-RECOGNIZES-SIGNER" (string-upcase text)))
    (expect (search "PROVENANCE-ADMISSIBLE" (string-upcase text)))
    (expect (search "SATISFIED" (string-upcase text)))
    (expect (search "MISSING" (string-upcase text))))
  (pass 11 "all four premises named, satisfied and missing alike"))

;;; ---- behavior 12 : projection re-derives at the target; it never copies ----
(hd 12 "projection: the conclusion does NOT survive to a second receiver by copy")
(let* ((sup-a (full-supports :rcv :receiver-a))
       (ctx-a (apply #'mk-ctx :ctx-a sup-a)))
  (multiple-value-bind (r-a claim-a)
      (attempt :conclusion (conclusion :rcv :receiver-a) :supports sup-a :receiver ctx-a)
    (declare (ignore claim-a))
    (let ((id-a (lisp-plus-kernel0:identity-key
                 (lisp-plus-slice1:derivation-receipt-identity r-a))))
      (ln "source grant at receiver-a, receipt id : ~A" id-a)
      (expect (eq (lisp-plus-slice1:derivation-receipt-decision r-a) :granted))

      ;; (a) COPY PLANT: transport receipt-a as support for the SAME conclusion
      ;;     at a second context — refused at the frozen Slice /0 gate.
      (let* ((testimony (lisp-plus-slice1:transported-testimony r-a :context-a :ctx-a))
             (schema (lisp-plus-slice1:resolve-schema :artifact-admissibility 1))
             (admit-kind (lisp-plus-slice1:judgment-schema-admit-kind schema))
             (proc (lisp-plus-slice0:promotion-procedure
                    :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                                 :procedure-id (lisp-plus-kernel0:make-identity
                                                :procedure "copy-plant-probe")
                                 :version 1 :judgment-class :semantic
                                 :result-vocabulary '(:verified))
                    :admits (list (list :derivation admit-kind))))
             (claim (lisp-plus-slice0:claim :proposition (conclusion :rcv :receiver-b)
                                            :by :attacker)))
        (ln "transported receipt is (~S ~S) — a product, not a local derivation"
            (lisp-plus-slice0:witness-mode testimony)
            (lisp-plus-slice0:witness-kind testimony))
        (handler-case
            (progn (lisp-plus-slice0:raise claim :to :verified :per proc
                                           :considering (list testimony) :receiver :ctx-b)
                   (error "COPY PLANT SUCCEEDED — S3 would be reproduced"))
          (lisp-plus-slice0:slice0-condition (c)
            (ln "copy-plant refused at frozen gate : ~A" (type-of c))
            (expect (typep c 'lisp-plus-slice0:wrong-proposition-support)))))

      ;; (b) target lacking its own recognition ⇒ refused at target
      (let* ((sup-b0 (list (s-digest) (s-signature) (s-provenance :rcv :receiver-b)))
             (ctx-b (apply #'mk-ctx :ctx-b sup-b0))
             (r-b0 (attempt :conclusion (conclusion :rcv :receiver-b)
                            :supports sup-b0 :receiver ctx-b)))
        (ln "target receiver-b, no local recognition ⇒ decision ~S (recognition ~S)"
            (lisp-plus-slice1:derivation-receipt-decision r-b0)
            (disp r-b0 :receiver-recognizes-signer))
        (expect (eq (lisp-plus-slice1:derivation-receipt-decision r-b0) :refused))
        (expect (eq (disp r-b0 :receiver-recognizes-signer) :missing)))

      ;; (c) give the target ITS OWN recognition ⇒ granted at target,
      ;;     with a DISTINCT receipt identity (reconstruct, not copy)
      (let* ((sup-b (list (s-digest) (s-signature)
                          (s-recognizes :rcv :receiver-b)
                          (s-provenance :rcv :receiver-b)))
             (ctx-b (apply #'mk-ctx :ctx-b sup-b)))
        (multiple-value-bind (r-b claim-b)
            (attempt :conclusion (conclusion :rcv :receiver-b) :supports sup-b :receiver ctx-b)
          (let ((id-b (lisp-plus-kernel0:identity-key
                       (lisp-plus-slice1:derivation-receipt-identity r-b))))
            (ln "target grant at receiver-b, receipt id : ~A" id-b)
            (expect (eq (lisp-plus-slice1:derivation-receipt-decision r-b) :granted))
            (expect (lisp-plus-slice0:claim-p claim-b))
            (ln "receipt identities distinct (a≠b)      : ~S" (not (equal id-a id-b)))
            (expect (not (equal id-a id-b)))
            (pass 12 "target re-derived over its OWN lawful premises; distinct receipt identity — no copy")))))))

;;; ==================================================================
(format t "~%de-praemissis specimen: ~D/~D behaviors demonstrated~%"
        *demonstrated* *behaviors*)
(finish-output)
(sb-ext:exit :code (if (= *demonstrated* *behaviors*) 0 1))
