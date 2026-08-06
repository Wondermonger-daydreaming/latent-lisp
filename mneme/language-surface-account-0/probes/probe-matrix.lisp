;;;; probe-matrix.lisp
;;;;
;;;; ==========================================================================
;;;; NON-PRODUCTION FEASIBILITY PROBE — Surface Account /0 opening round —
;;;; not a package, not an API, not loadable as part of any system.
;;;; ==========================================================================
;;;;
;;;; THE POSITIVE MATRIX.  Seven exact head keys x two declared operations =
;;;; fourteen cases, each driven through the NATIVE provider machine's public
;;;; API only.  Nothing here mints an Account /0 object, proposes a package, or
;;;; evaluates, compiles or executes any expansion.
;;;;
;;;; TWO STANDING REFUSALS OF THIS FILE, per the commission:
;;;;   * native receipt identities are NEVER compared across providers;
;;;;   * no general macroexpansion determinism is inferred from repeated
;;;;     current-host results.  Every measurement below is one occurrence on
;;;;     one host.

(in-package #:cl-user)

;;; --------------------------------------------------------------------------
;;; THE FOURTEEN FIXTURES.  Each is quoted text taken from a PREDECESSOR'S OWN
;;; fixture or test file, cited in the comment above it, and read fresh at run
;;; time.  Nothing here invents an admitted form.
;;; --------------------------------------------------------------------------

(defparameter *fixtures*
  (list
   ;; ---- LISP-PLUS-SURFACE0, five heads (Surface /1's machine) ----
   (list :s1 "DEFINE-JUDGMENT-SCHEMA"
         ;; source: mneme/language-surface-1/surface1-selftest.lisp, the
         ;; JUDGMENT-SCHEMA-WITH-PREMISES witness (line ~1534), instantiated at
         ;; two premises instead of 2491 so the case measures an ordinary form.
         "(lisp-plus-surface0:define-judgment-schema cl-user::*s1-p-schema*
            :name :z :version 0 :conclusion (:predicate :z (:v (:var :v)))
            :premises (:a :a) :locals () :unique-locals ())")
   (list :s1 "DEFINE-ADMISSION-CONTRACT"
         ;; source: mneme/language-surface-1/surface1-selftest.lisp *SPECIMEN*
         ;; (line ~155) — verbatim.
         "(lisp-plus-surface0:define-admission-contract cl-user::*s1-contract*
            :contract-id :surface1/selftest
            :contract-version 1
            :accepted-clauses ((:verified-judged-claim))
            :proposition-relation :exact-normalized-equality
            :receiver-accessibility :required
            :retain (:contract-snapshot :support-identity :support-basis :source-basis))")
   (list :s1 "DEFINE-SLICE2-SCHEMA"
         ;; source: mneme/language-surface-0/surface0-selftest.lisp (line ~192),
         ;; the *SURF-S2* schema, qualified for reading outside that file.
         "(lisp-plus-surface0:define-slice2-schema cl-user::*surf-s2*
            :schema-id :surf-account/2 :schema-version 0
            :base-schema cl-user::*surf-account-schema*
            :premise-contracts ((0 cl-user::*surf-source-bound*)))")
   (list :s1 "DERIVE-CASE"
         ;; source: mneme/language-surface-1/surface1-selftest.lisp
         ;; *CONTROL-FORM* (line ~515) — verbatim.
         "(lisp-plus-surface0:derive-case (cl-user::c cl-user::r)
            (lisp-plus-slice1:derive :schema-name :x)
            (:granted cl-user::c) (:refused (cl-user::e) cl-user::e))")
   (list :s1 "DERIVE/2-CASE"
         ;; source: mneme/language-surface-0/surface0-selftest.lisp SC5/SC6
         ;; (lines ~409-414) — the admitted DERIVE/2-CASE shape carrying the
         ;; RIGHT operation (SC6 shows the same shape with the wrong one).
         "(lisp-plus-surface0:derive/2-case (cl-user::c cl-user::r cl-user::b)
            (lisp-plus-slice2:derive/2 :schema nil)
            (:granted nil) (:refused (cl-user::e) nil))")
   ;; ---- LISP-PLUS-SURFACE2, two heads (Surface /2's machine) ----
   (list :s2 "WITH-OUTCOME"
         ;; source: mneme/language-surface-2/surface2-selftest.lisp *WITH-FORM*
         ;; (line ~366) — verbatim but for CL-USER qualification of the two
         ;; ordinary variables.
         "(lisp-plus-surface2:with-outcome (cl-user::o (identity cl-user::o2)) cl-user::o)")
   (list :s2 "MATCH-OUTCOME"
         ;; source: mneme/language-surface-2/surface2-selftest.lisp *MATCH-FORM*
         ;; (line ~361) — verbatim but for CL-USER qualification.
         "(lisp-plus-surface2:match-outcome cl-user::o
            ((:execution :settled) (lisp-plus-surface2:seat-outcome-seat-id cl-user::o))
            (otherwise cl-user::o))")))

(defparameter *operations* '(:macroexpand-1 :macroexpand))

;;; --------------------------------------------------------------------------
;;; PROBE-SIDE supplementary measurement, used ONLY where a provider refuses and
;;; the expansion therefore has no public datum to measure.  Labelled at every
;;; appearance.  It performs the host macroexpansion and MEASURES the returned
;;; tree; it never evaluates, compiles, loads or re-presents it.
;;; --------------------------------------------------------------------------

(defun count-uninterned (form)
  (let ((n 0))
    (labels ((walk (x)
               (cond ((consp x) (walk (car x)) (walk (cdr x)))
                     ((and (symbolp x) (null (symbol-package x))) (incf n)))))
      (walk form))
    n))

(defun count-shared-conses (form)
  (let ((seen (make-hash-table :test #'eq)) (shared 0))
    (labels ((walk (x)
               (when (consp x)
                 (if (gethash x seen)
                     (incf shared)
                     (progn (setf (gethash x seen) t)
                            (walk (car x)) (walk (cdr x)))))))
      (walk form))
    shared))

(defun probe-side-expansion-measure (form operation)
  "PROBE-SIDE HOST MEASUREMENT — not a provider observation."
  (handler-case
      (let ((expanded (ecase operation
                        (:macroexpand-1 (macroexpand-1 form nil))
                        (:macroexpand (macroexpand form nil)))))
        (list :depth (host-depth expanded)
              :nodes (host-nodes expanded)
              :uninterned (count-uninterned expanded)
              :shared-conses (count-shared-conses expanded)))
    (condition (c)
      (multiple-value-bind (name pkg) (condition-species c)
        (list :condition name :condition-package pkg)))))

;;; --------------------------------------------------------------------------
;;; Recorded maxima, for the term-grammar decision.  THESE ARE OBSERVATIONS OF
;;; FOURTEEN FIXTURES, NEVER "NEEDED CEILINGS".
;;; --------------------------------------------------------------------------

(defvar *max-source-depth* 0)
(defvar *max-source-nodes* 0)
(defvar *max-source-octets* 0)
(defvar *max-expansion-depth* 0)
(defvar *max-expansion-nodes* 0)
(defvar *max-expansion-octets* 0)
(defvar *representability-stops* nil)

(defun note-max (place value) (max place value))

;;; --------------------------------------------------------------------------
;;; The two case drivers.  Two functions rather than one dispatcher, because the
;;; provider symbols are qualified external symbols written literally — there is
;;; no registry, no adapter table of procedures, and no caller-supplied
;;; procedure anywhere in this probe.
;;; --------------------------------------------------------------------------

(defun report-case-head (n provider head operation text)
  (rule)
  (p "CASE ~2,'0D  PROVIDER ~A  HEAD LISP-PLUS-~A:~A  OPERATION ~A"
     n
     (ecase provider (:s1 "LISP-PLUS-SURFACE1") (:s2 "LISP-PLUS-SURFACE2"))
     (ecase provider (:s1 "SURFACE0") (:s2 "SURFACE2"))
     head operation)
  (p "  FIXTURE-TEXT-BEGIN")
  (dolist (line (let ((acc nil) (start 0))
                  (loop for i from 0 below (length text)
                        when (char= (char text i) #\Newline)
                          do (push (subseq text start i) acc) (setf start (1+ i)))
                  (push (subseq text start) acc)
                  (nreverse acc)))
    (p "  | ~A" (string-right-trim " " line)))
  (p "  FIXTURE-TEXT-END"))

(defun run-case-s1 (n head operation text)
  (incf *probe-cases*)
  (report-case-head n :s1 head operation text)
  (let* ((form (read-fixture text))
         (sd (host-depth form))
         (sn (host-nodes form))
         (tag (tag-for (format nil "case-~2,'0D" n))))
    (kv "SOURCE probe-side depth" sd)
    (kv "SOURCE probe-side nodes" sn)
    (setf *max-source-depth* (note-max *max-source-depth* sd)
          *max-source-nodes* (note-max *max-source-nodes* sn))
    ;; ---- DOOR 1 ----
    (multiple-value-bind (req refusal)
        (lisp-plus-surface1:try-request-expansion form operation tag)
      (cond
        ((null req)
         (kv "DOOR-1" "REFUSED")
         (kv "  refusal-code" (lisp-plus-surface1:expansion-refusal-code refusal))
         (kv "  refusal-detail" (lisp-plus-surface1:expansion-refusal-detail refusal))
         (kv "SOURCE-EXACTLY-REPRESENTABLE" "NO")
         (probe-check (format nil "MATRIX-CASE-~2,'0D-DOOR1-ACCEPTED" n) (format nil "case ~2,'0D Door 1 accepted the admitted fixture" n) nil))
        (t
         (let* ((sdatum (lisp-plus-surface1:expansion-request-source-form-datum req))
                (soct (lisp-plus-surface1:identity-octets sdatum))
                (round (lisp-plus-surface1:decode-term sdatum)))
           (setf *max-source-octets* (note-max *max-source-octets* soct))
           (kv "DOOR-1" "REQUEST MINTED")
           (kv "SOURCE canonical octets" soct)
           (kv "SOURCE round-trip EQUAL" (if (equal round form) "YES" "NO"))
           (kv "SOURCE-EXACTLY-REPRESENTABLE" (if (equal round form) "YES" "NO"))
           (probe-check (format nil "MATRIX-CASE-~2,'0D-SOURCE-REPRESENTABLE" n) (format nil "case ~2,'0D exact source is representable and round-trips EQUAL" n)
                        (equal round form))
           ;; the three governing versions, as VALUES the request stored
           (kv "request grammar-version [request-stored]"
               (lisp-plus-surface1:expansion-request-grammar-version req))
           (kv "request procedure-version [request-stored]"
               (lisp-plus-surface1:expansion-request-procedure-version req))
           (kv "request policy-version [request-stored]"
               (lisp-plus-surface1:expansion-request-policy-version req))
           (kv "request construct-identity"
               (if (lisp-plus-surface1:expansion-request-construct-identity req)
                   "PRESENT (known head)" "ABSENT (unknown head)"))
           ;; ---- DOOR 2 ----
           (handler-case
               (multiple-value-bind (receipt expanded refusal2)
                   (lisp-plus-surface1:try-perform-expansion req)
                 (declare (ignore expanded))
                 (cond
                   (receipt
                    (let* ((edatum (lisp-plus-surface1:expansion-receipt-expanded-form-datum receipt))
                           (eoct (lisp-plus-surface1:identity-octets edatum))
                           (ehost (lisp-plus-surface1:decode-term edatum))
                           (ed (host-depth ehost))
                           (en (host-nodes ehost))
                           (reenc (lisp-plus-surface1:encode-term ehost))
                           (lossless (= eoct (lisp-plus-surface1:identity-octets reenc))))
                      (setf *max-expansion-depth* (note-max *max-expansion-depth* ed)
                            *max-expansion-nodes* (note-max *max-expansion-nodes* en)
                            *max-expansion-octets* (note-max *max-expansion-octets* eoct))
                      (kv "DOOR-2" "RECEIPT MINTED")
                      (kv "EXPANSION probe-side depth" ed)
                      (kv "EXPANSION probe-side nodes" en)
                      (kv "EXPANSION canonical octets" eoct)
                      (kv "EXPANSION decode/re-encode octet-identical" (if lossless "YES" "NO"))
                      (kv "EXPANSION-EXACTLY-REPRESENTABLE" (if lossless "YES" "NO"))
                      (probe-check (format nil "MATRIX-CASE-~2,'0D-EXPANSION-OCTET-IDENTICAL" n) (format nil "case ~2,'0D expansion re-encodes to identical octets (no lossy normalization)" n)
                                   lossless)
                      (kv "receipt disposition [receipt-stored]"
                          (lisp-plus-surface1:expansion-receipt-disposition receipt))
                      (kv "receipt grammar-version [receipt-stored]"
                          (lisp-plus-surface1:expansion-receipt-grammar-version receipt))
                      (kv "receipt procedure-version [receipt-stored]"
                          (lisp-plus-surface1:expansion-receipt-procedure-version receipt))
                      (kv "receipt policy-version [receipt-stored]"
                          (lisp-plus-surface1:expansion-receipt-policy-version receipt))
                      (kv "receipt procedure-identity [provider-current-declaration]"
                          (lisp-plus-surface1:render-identity-hex
                           (lisp-plus-surface1:expansion-receipt-procedure-identity receipt)))
                      (kv "receipt policy-identity [provider-current-declaration]"
                          (lisp-plus-surface1:render-identity-hex
                           (lisp-plus-surface1:expansion-receipt-policy-identity receipt)))
                      (kv "receipt grammar-IDENTITY [unavailable]"
                          "no receipt-stored grammar identity is exposed by this provider")
                      (kv "public verify-receipt [unavailable]"
                          "LISP-PLUS-SURFACE1 exports no receipt verifier")
                      (kv "MACRO-CONDITION vs ACCOUNT-REFUSAL" "n/a — completed")))
                   (refusal2
                    (kv "DOOR-2" "ACCOUNT REFUSAL (provider's own retained object)")
                    (kv "  refusal phase" (lisp-plus-surface1:expansion-refusal-phase refusal2))
                    (kv "  refusal category" (lisp-plus-surface1:expansion-refusal-category refusal2))
                    (kv "  refusal code" (lisp-plus-surface1:expansion-refusal-code refusal2))
                    (kv "  refusal detail" (lisp-plus-surface1:expansion-refusal-detail refusal2))
                    (kv "  upstream category" (or (lisp-plus-surface1:expansion-refusal-upstream-category refusal2) "NONE"))
                    (kv "  upstream code" (or (lisp-plus-surface1:expansion-refusal-upstream-code refusal2) "NONE"))
                    (kv "  upstream stage" (or (lisp-plus-surface1:expansion-refusal-upstream-stage refusal2) "NONE"))
                    (kv "EXPANSION canonical octets [unavailable]" "no receipt was minted")
                    (kv "EXPANSION-EXACTLY-REPRESENTABLE" "NO")
                    (let ((m (probe-side-expansion-measure form operation)))
                      (kv "PROBE-SIDE-HOST-MEASUREMENT" m))
                    (push (list n :s1 head operation
                                (lisp-plus-surface1:expansion-refusal-code refusal2))
                          *representability-stops*)
                    (kv "MACRO-CONDITION vs ACCOUNT-REFUSAL"
                        "ACCOUNT REFUSAL — class LISP-PLUS-SURFACE1:EXPANSION-REFUSED"))))
             ;; anything the layer does NOT catch escapes here, in its own species
             (condition (c)
               (multiple-value-bind (name pkg) (condition-species c)
                 (kv "DOOR-2" "FOREIGN CONDITION ESCAPED UNCAUGHT")
                 (kv "  condition class" name)
                 (kv "  owning package" pkg)
                 (kv "EXPANSION-EXACTLY-REPRESENTABLE" "NO — no outcome minted")
                 (kv "MACRO-CONDITION vs ACCOUNT-REFUSAL"
                     (format nil "DISTINGUISHABLE BY CLASS — ~A:~A is not LISP-PLUS-SURFACE1:EXPANSION-REFUSED"
                             pkg name)))))))))))

(defun run-case-s2 (n head operation text)
  (incf *probe-cases*)
  (report-case-head n :s2 head operation text)
  (let* ((form (read-fixture text))
         (sd (host-depth form))
         (sn (host-nodes form))
         (tag (tag-for (format nil "case-~2,'0D" n))))
    (kv "SOURCE probe-side depth" sd)
    (kv "SOURCE probe-side nodes" sn)
    (setf *max-source-depth* (note-max *max-source-depth* sd)
          *max-source-nodes* (note-max *max-source-nodes* sn))
    (multiple-value-bind (req refusal)
        (lisp-plus-surface2:try-request-expansion form operation tag)
      (cond
        ((null req)
         (kv "DOOR-1" "REFUSED")
         (kv "  refusal-code" (lisp-plus-surface2:expansion-refusal-code refusal))
         (kv "  refusal-detail" (lisp-plus-surface2:expansion-refusal-detail refusal))
         (kv "SOURCE-EXACTLY-REPRESENTABLE" "NO")
         (probe-check (format nil "MATRIX-CASE-~2,'0D-DOOR1-ACCEPTED" n) (format nil "case ~2,'0D Door 1 accepted the admitted fixture" n) nil))
        (t
         (let* ((sdatum (lisp-plus-surface2:expansion-request-source-form-datum req))
                (soct (lisp-plus-surface2:identity-octets sdatum))
                (round (lisp-plus-surface2:decode-term2 sdatum)))
           (setf *max-source-octets* (note-max *max-source-octets* soct))
           (kv "DOOR-1" "REQUEST MINTED")
           (kv "SOURCE canonical octets" soct)
           (kv "SOURCE round-trip EQUAL" (if (equal round form) "YES" "NO"))
           (kv "SOURCE-EXACTLY-REPRESENTABLE" (if (equal round form) "YES" "NO"))
           (probe-check (format nil "MATRIX-CASE-~2,'0D-SOURCE-REPRESENTABLE" n) (format nil "case ~2,'0D exact source is representable and round-trips EQUAL" n)
                        (equal round form))
           (kv "request grammar-version [request-stored]"
               (lisp-plus-surface2:expansion-request-grammar-version req))
           (kv "request procedure-version [request-stored]"
               (lisp-plus-surface2:expansion-request-procedure-version req))
           (kv "request policy-version [request-stored]"
               (lisp-plus-surface2:expansion-request-policy-version req))
           (kv "request construct-identity"
               (if (lisp-plus-surface2:expansion-request-construct-identity req)
                   "PRESENT (known head)" "ABSENT (unknown head)"))
           (handler-case
               (multiple-value-bind (receipt expanded refusal2)
                   (lisp-plus-surface2:try-perform-expansion req)
                 (declare (ignore expanded))
                 (cond
                   (receipt
                    (let* ((edatum (lisp-plus-surface2:expansion-receipt-expanded-form-datum receipt))
                           (eoct (lisp-plus-surface2:identity-octets edatum))
                           (ehost (lisp-plus-surface2:decode-term2 edatum))
                           (ed (host-depth ehost))
                           (en (host-nodes ehost))
                           (reenc (lisp-plus-surface2:encode-term2 ehost))
                           (lossless (= eoct (lisp-plus-surface2:identity-octets reenc))))
                      (setf *max-expansion-depth* (note-max *max-expansion-depth* ed)
                            *max-expansion-nodes* (note-max *max-expansion-nodes* en)
                            *max-expansion-octets* (note-max *max-expansion-octets* eoct))
                      (kv "DOOR-2" "RECEIPT MINTED")
                      (kv "EXPANSION probe-side depth" ed)
                      (kv "EXPANSION probe-side nodes" en)
                      (kv "EXPANSION canonical octets" eoct)
                      (kv "EXPANSION decode/re-encode octet-identical" (if lossless "YES" "NO"))
                      (kv "EXPANSION-EXACTLY-REPRESENTABLE" (if lossless "YES" "NO"))
                      (probe-check (format nil "MATRIX-CASE-~2,'0D-EXPANSION-OCTET-IDENTICAL" n) (format nil "case ~2,'0D expansion re-encodes to identical octets (no lossy normalization)" n)
                                   lossless)
                      (kv "receipt disposition [receipt-stored]"
                          (lisp-plus-surface2:expansion-receipt-disposition receipt))
                      (kv "receipt grammar-version [receipt-stored]"
                          (lisp-plus-surface2:expansion-receipt-grammar-version receipt))
                      (kv "receipt procedure-version [receipt-stored]"
                          (lisp-plus-surface2:expansion-receipt-procedure-version receipt))
                      (kv "receipt policy-version [receipt-stored]"
                          (lisp-plus-surface2:expansion-receipt-policy-version receipt))
                      (kv "receipt procedure-identity [provider-current-declaration]"
                          (lisp-plus-surface2:render-identity-hex
                           (lisp-plus-surface2:expansion-receipt-procedure-identity receipt)))
                      (kv "receipt policy-identity [provider-current-declaration]"
                          (lisp-plus-surface2:render-identity-hex
                           (lisp-plus-surface2:expansion-receipt-policy-identity receipt)))
                      (kv "receipt grammar-IDENTITY [unavailable]"
                          "no receipt-stored grammar identity is exposed by this provider")
                      (kv "public verify-receipt [provider-recomputation]"
                          (multiple-value-bind (ok report)
                              (lisp-plus-surface2:verify-receipt receipt)
                            (declare (ignore report))
                            (format nil "PRESENT — returned ~A" ok)))
                      (kv "MACRO-CONDITION vs ACCOUNT-REFUSAL" "n/a — completed")))
                   (refusal2
                    (kv "DOOR-2" "ACCOUNT REFUSAL (provider's own retained object)")
                    (kv "  refusal phase" (lisp-plus-surface2:expansion-refusal-phase refusal2))
                    (kv "  refusal category" (lisp-plus-surface2:expansion-refusal-category refusal2))
                    (kv "  refusal code" (lisp-plus-surface2:expansion-refusal-code refusal2))
                    (kv "  refusal detail" (lisp-plus-surface2:expansion-refusal-detail refusal2))
                    (kv "EXPANSION canonical octets [unavailable]" "no receipt was minted")
                    (kv "EXPANSION-EXACTLY-REPRESENTABLE" "NO")
                    (let ((m (probe-side-expansion-measure form operation)))
                      (kv "PROBE-SIDE-HOST-MEASUREMENT" m))
                    (push (list n :s2 head operation
                                (lisp-plus-surface2:expansion-refusal-code refusal2))
                          *representability-stops*)
                    (kv "MACRO-CONDITION vs ACCOUNT-REFUSAL"
                        "SAME CLASS — this provider's macro-owned refusal and its account refusal are both LISP-PLUS-SURFACE2:SURFACE2-EXPANSION-REFUSED; the CATEGORY field is read first (an :INTEGRITY-ALARM is never an account refusal), and RESTRICTED TO S2 PROTOCOL-REFUSAL ROWS the PHASE field is the only separator"))))
             (condition (c)
               (multiple-value-bind (name pkg) (condition-species c)
                 (kv "DOOR-2" "FOREIGN CONDITION ESCAPED UNCAUGHT")
                 (kv "  condition class" name)
                 (kv "  owning package" pkg)
                 (kv "EXPANSION-EXACTLY-REPRESENTABLE" "NO — no outcome minted")
                 (kv "MACRO-CONDITION vs ACCOUNT-REFUSAL"
                     (format nil "DISTINGUISHABLE BY CLASS — ~A:~A" pkg name)))))))))))

;;; --------------------------------------------------------------------------
;;; RUN.
;;; --------------------------------------------------------------------------

(probe-header "POSITIVE MATRIX — 7 heads x 2 operations = 14 cases")

(p "PROVIDER DECLARATIONS AS READ IN THIS IMAGE [provider-current-declaration]")
(kv "S1 grammar-version" (lisp-plus-surface1:expansion-grammar-version))
(kv "S1 procedure-version" (lisp-plus-surface1:expansion-procedure-version))
(kv "S1 policy-version" (lisp-plus-surface1:expansion-policy-version))
(kv "S1 operations" (lisp-plus-surface1:expansion-operations))
(kv "S1 closed heads" (length (lisp-plus-surface1:known-surface-constructs)))
(kv "S1 max-source-depth" (lisp-plus-surface1:expansion-policy-max-source-depth))
(kv "S1 max-source-nodes" (lisp-plus-surface1:expansion-policy-max-source-nodes))
(kv "S1 max-term-octets" (lisp-plus-surface1:expansion-policy-max-term-octets))
(kv "S1 term-depth-ceiling" (lisp-plus-surface1:term-depth-ceiling))
(kv "S2 grammar-version" (lisp-plus-surface2:surface2-grammar-version))
(kv "S2 procedure-version" (lisp-plus-surface2:surface2-procedure-version))
(kv "S2 policy-version" (lisp-plus-surface2:surface2-policy-version))
(kv "S2 operations" (lisp-plus-surface2:surface2-expansion-operations))
(kv "S2 closed heads" (length (lisp-plus-surface2:known-surface2-constructs)))
(kv "S1 term kinds" (lisp-plus-surface1:term-kinds))
(kv "S2 term kinds" (lisp-plus-surface2:term2-kinds))

(let ((n 0))
  (dolist (op *operations*)
    (dolist (fx *fixtures*)
      (incf n)
      (destructuring-bind (provider head text) fx
        (ecase provider
          (:s1 (run-case-s1 n head op text))
          (:s2 (run-case-s2 n head op text)))
        ;; STABLE CLOSING ANCHOR.  The opening anchor `CASE NN  PROVIDER …` is
        ;; unchanged from R0 so existing citations survive; this closes the
        ;; block, so a document may cite the interval CASE NN … END-CASE NN
        ;; and never a line number.
        (p "END-CASE ~2,'0D" n)))))

(rule #\=)
(p "OBSERVED MAXIMA OVER THE FOURTEEN FIXTURES")
(p "  These are OBSERVATIONS of these fourteen forms on this host.  They are")
(p "  NOT needed ceilings, NOT a proposed grammar bound, and NOT a claim about")
(p "  any form outside this fixture set.")
(p "  SCOPE, STATED SO THE NUMBERS ARE NOT OVER-READ: the SOURCE maxima are over")
(p "  all fourteen cases.  The EXPANSION maxima are over only the cases that")
(p "  produced a public expansion datum; every refused case contributes NOTHING")
(p "  to them and is listed below instead.  A larger unrepresented expansion")
(p "  therefore exists behind each STOP and is not in these figures.")
(kv "max SOURCE depth (probe-side)" *max-source-depth*)
(kv "max SOURCE nodes (probe-side)" *max-source-nodes*)
(kv "max SOURCE canonical octets" *max-source-octets*)
(kv "max EXPANSION depth (probe-side)" *max-expansion-depth*)
(kv "max EXPANSION nodes (probe-side)" *max-expansion-nodes*)
(kv "max EXPANSION canonical octets" *max-expansion-octets*)
(rule)
(p "REPRESENTABILITY STOPS — lawful admitted sources whose EXPANSION the native")
(p "provider could not represent.  Each is a STOP-AND-REPORT, never a silent")
(p "weakening of anybody's grammar.")
(if (null *representability-stops*)
    (p "  NONE")
    (dolist (s (reverse *representability-stops*))
      (p "  STOP case ~2,'0D  ~A  ~A  ~A  code ~A"
         (first s) (second s) (third s) (fourth s) (fifth s))))

(probe-check "MATRIX-ALL-FOURTEEN-CASES-RAN" "all fourteen cases ran" (= 14 *probe-cases*))
(when (plant-failure-requested-p)
  (p "  !! PLANTED FAILURE ARM ACTIVE — the next check is deliberately false")
  (probe-check "MATRIX-PLANTED-FAULT" "PLANTED FAULT: this check is designed to fail" nil))

(probe-footer "POSITIVE-MATRIX")
(probe-exit)
