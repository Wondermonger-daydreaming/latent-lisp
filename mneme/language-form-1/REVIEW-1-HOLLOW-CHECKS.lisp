;;;; REVIEW-1-HOLLOW-CHECKS.lisp — the BEFORE/AFTER witness for checks [46] and [129].
;;;;
;;;; Run: sbcl --non-interactive --load REVIEW-1-HOLLOW-CHECKS.lisp
;;;;
;;;; THE OWNER RULING, §1: "Also preserve the before/after evidence for hollow
;;;; checks [46] and [129].  Do not quietly absorb FANG's findings into the
;;;; final suite."
;;;;
;;;; So this file does NOT live inside form1-selftest.lisp, where a repaired
;;;; tooth's history disappears into a green line.  It holds BOTH FORMS —
;;;; the shipped one and the repaired one — side by side, executes each against
;;;; a discriminating pair of worlds, and prints the truth table.
;;;;
;;;; A HOLLOW CHECK IS ONE THAT CANNOT FAIL.  The only way to show a check is
;;;; not hollow is to exhibit a world in which it DOES fail.  Every row below is
;;;; that exhibition, run, not asserted.
;;;;
;;;; ON THE FAITHFULNESS OF THE [46] SIMULATION — this is the chair error the
;;;; return records at §13.1, and it is repeated here as a live control rather
;;;; than as prose.  The chair's FIRST aliasing harness aliased the ACCESSOR'S
;;;; RETURN and not the DATUM'S INTERNAL STORE, so EQUAL-DATUM still read
;;;; uncorrupted bytes and the hollow check appeared to discriminate.  Both
;;;; harnesses are run below.  The unfaithful one is kept, labelled, and shown
;;;; giving the wrong answer — because a simulation that stands in for the thing
;;;; simulated is exactly the defect this whole review is about.

(unless (find-package :lisp-plus-form1)
  (handler-bind ((style-warning #'muffle-warning))
    (load (merge-pathnames "form1.lisp" *load-truename*))))

(defpackage #:review-1-hollow-checks
  (:use #:cl)
  (:local-nicknames (#:f1 #:lisp-plus-form1)
                    (#:cd0 #:lisp-plus-cd0)
                    (#:s0 #:lisp-plus-slice0)
                    (#:s1 #:lisp-plus-slice1)
                    (#:s2 #:lisp-plus-slice2)))

(in-package #:review-1-hollow-checks)

(defun idd (namespace path) (cd0:make-identifier-datum namespace path))
(defun np (form) (s1:proposition form))
(defun pp (form) (s1:proposition-pattern form))

(defun petition-tree ()
  (f1:petition-datum :schema (f1:schema-reference "s")
                     :conclusion (f1:conclusion-reference "c")
                     :supports (list (f1:support-reference "w1"))
                     :receiver (f1:receiver-reference "r")))

(defun rule (title)
  (format t "~%~%~A~%~A~%" title (make-string (length title) :initial-element #\=)))

(defun row (label real aliased verdict)
  (format t "  ~22A  ~6A   ~10A ~A~%" label real aliased verdict))

(format t "~%~%")
(format t "================================================================~%")
(format t "  LANGUAGE FORM /1 — REVIEW 1~%")
(format t "  THE BEFORE/AFTER WITNESS FOR THE TWO HOLLOW CHECKS~%")
(format t "================================================================~%")
(format t "~%  SBCL : ~A~%" (lisp-implementation-version))

;;; ══════════════════════════════════════════════════════════════════════════
;;; CHECK [46] — THE DRIFT-CEILING TOOTH
;;; ══════════════════════════════════════════════════════════════════════════

(rule "CHECK [46] — the drift-ceiling tooth")

(format t "~%  THE CLAIM the check's label makes:~%")
(format t "    \"BYTES-DATUM-VALUE hands back a COPY, so no public caller can~%")
(format t "     force real drift.\"~%")

(format t "~%  THE SHIPPED FORM (commit 295f9fba):~%")
(format t "    (let ((first-read (cd0:bytes-datum-value identity)))~%")
(format t "      (fill first-read 0)~%")
(format t "      (cd0:equal-datum identity~%")
(format t "                       (cd0:make-bytes-datum (cd0:bytes-datum-value identity))))~%")

(format t "~%  THE REPAIRED FORM (commit 7db2da94):~%")
(format t "    (let ((first-read (cd0:bytes-datum-value identity)))~%")
(format t "      (fill first-read 0)~%")
(format t "      (notevery #'zerop (cd0:bytes-datum-value identity)))~%")

(defun old-46 ()
  "The EXACT shipped predicate, transcribed from 295f9fba."
  (let ((identity (f1:proposed-petition-form-subject-identity
                   (f1:propose-petition (petition-tree)))))
    (let ((first-read (cd0:bytes-datum-value identity)))
      (fill first-read 0)
      (cd0:equal-datum identity
                       (cd0:make-bytes-datum (cd0:bytes-datum-value identity))))))

(defun new-46 ()
  "The EXACT repaired predicate, transcribed from 7db2da94."
  (let ((identity (f1:proposed-petition-form-subject-identity
                   (f1:propose-petition (petition-tree)))))
    (let ((first-read (cd0:bytes-datum-value identity)))
      (fill first-read 0)
      (notevery #'zerop (cd0:bytes-datum-value identity)))))

;;; --- world 2: a FAITHFUL aliasing accessor -------------------------------
;;; It returns the datum's ACTUAL INTERNAL STORE, uncopied.  This is what CD/0
;;; would do if its copy-on-access guarantee were ever lost.

(defun call-with-faithful-aliasing (thunk)
  (let ((real (fdefinition 'cd0:bytes-datum-value)))
    (unwind-protect
         (progn
           (setf (fdefinition 'cd0:bytes-datum-value)
                 (lambda (datum) (lisp-plus-cd0::%bytes-octets datum)))
           (funcall thunk))
      (setf (fdefinition 'cd0:bytes-datum-value) real))))

;;; --- world 3: the CHAIR'S FIRST, UNFAITHFUL harness ----------------------
;;; It aliases the ACCESSOR'S RETURN across two calls but leaves the datum's
;;; internal store untouched.  Kept, labelled, and run — this is the simulation
;;; that stood in for the thing simulated, and it is preserved as a control on
;;; the review's own instrument.

(defun call-with-unfaithful-aliasing (thunk)
  (let ((real (fdefinition 'cd0:bytes-datum-value))
        (cache (make-hash-table :test #'eq)))
    (unwind-protect
         (progn
           (setf (fdefinition 'cd0:bytes-datum-value)
                 (lambda (datum)
                   ;; hand back THE SAME vector on every call for this datum,
                   ;; but never the datum's own store
                   (or (gethash datum cache)
                       (setf (gethash datum cache) (funcall real datum)))))
           (funcall thunk))
      (setf (fdefinition 'cd0:bytes-datum-value) real))))

(let ((old-real     (old-46))
      (new-real     (new-46))
      (old-faithful (call-with-faithful-aliasing   #'old-46))
      (new-faithful (call-with-faithful-aliasing   #'new-46))
      (old-unfaith  (call-with-unfaithful-aliasing #'old-46))
      (new-unfaith  (call-with-unfaithful-aliasing #'new-46)))

  (format t "~%  ── the truth table ─────────────────────────────────────────────~%~%")
  (format t "  form                    REAL     ALIASING   verdict~%")
  (format t "                                   (faithful)~%")
  (format t "  ────────────────────────────────────────────────────────────────~%")
  (row "OLD [46] (shipped)" old-real old-faithful
       (if (eq old-real old-faithful)
           "*** CANNOT FAIL — HOLLOW ***"
           "discriminates"))
  (row "NEW [46] (repaired)" new-real new-faithful
       (if (eq new-real new-faithful)
           "*** CANNOT FAIL — HOLLOW ***"
           "DISCRIMINATES"))

  (format t "~%  ── the chair's own instrument, audited ─────────────────────────~%~%")
  (format t "  form                    REAL     ALIASING   verdict~%")
  (format t "                                   (UNFAITHFUL — return aliased,~%")
  (format t "                                    internal store NOT aliased)~%")
  (format t "  ────────────────────────────────────────────────────────────────~%")
  (row "OLD [46] (shipped)" old-real old-unfaith
       (if (eq old-real old-unfaith) "reported hollow" "REPORTED DISCRIMINATING — WRONG"))
  (row "NEW [46] (repaired)" new-real new-unfaith "")

  (format t "~%  WHAT THE SECOND TABLE RECORDS.  The chair's first aliasing harness~%")
  (format t "  aliased the accessor's RETURN and not the datum's INTERNAL STORE.~%")
  (format t "  Under it, the shipped [46] appeared to discriminate — which would have~%")
  (format t "  made the entire hollow-tooth finding a false alarm.  It was caught only~%")
  (format t "  because its answer disagreed with a report the chair had reason to trust.~%")
  (format t "~%  A SIMULATION STANDING IN FOR THE THING SIMULATED, inside the session~%")
  (format t "  whose subject is exactly that.  It is preserved here as a live control,~%")
  (format t "  not as an anecdote.~%")

  (format t "~%  WHY THE SHIPPED FORM COULD NOT FAIL.  It filled the FIRST read, then~%")
  (format t "  compared the store against a datum rebuilt from a SECOND read.  Under~%")
  (format t "  an aliasing accessor BOTH SIDES ARE THE SAME ZEROED VECTOR, so equality~%")
  (format t "  holds.  It demonstrated that MAKE-BYTES-DATUM . BYTES-DATUM-VALUE round~%")
  (format t "  trips.  Its label claimed it demonstrated defensive copying.~%")

  (format t "~%  THE STANDING OF THE REPAIRED FORM.  It is a TRIPWIRE ON AN IMPORTED~%")
  (format t "  GUARANTEE, not Form /1 coverage.  CD/0's copy-on-access is pinned by~%")
  (format t "  CD/0's own suite in CD/0's own language and in the Python seed; if it~%")
  (format t "  ever regressed, CD/0's suite is what goes red.  [46] exists so that~%")
  (format t "  Form /1 does not keep printing green while the threat model beneath it~%")
  (format t "  has changed.~%"))

;;; ══════════════════════════════════════════════════════════════════════════
;;; CHECK [129] — NC-34
;;; ══════════════════════════════════════════════════════════════════════════

(rule "CHECK [129] — NC-34, the no-values-at-all tooth")

(format t "~%  THE CLAIM the check's label makes:~%")
(format t "    \"the escaping path returned NO values at all — no outcome and no~%")
(format t "     submission receipt exist to be read.\"~%")

(format t "~%  THE SHIPPED FORM (commit 295f9fba):~%")
(format t "    (notany (lambda (entry) (eq :escape-should-not-log (getf entry :label)))~%")
(format t "            *submission-log*)~%")

;;; The submission log's shape, reproduced exactly: COUNTED-SUBMIT pushes
;;;   (list :label label :count n :outcome o :refusal r)
;;; and every call site in the suite passes a STRING literal as LABEL.

(defparameter *log-as-the-suite-builds-it*
  (list (list :label "nc16-a"  :count 1 :outcome :granted :refusal nil)
        (list :label "nc16-b"  :count 1 :outcome :granted :refusal nil)
        (list :label "nc31-a"  :count 1 :outcome :granted :refusal nil)
        (list :label "nc31-b"  :count 1 :outcome :governed-refusal :refusal nil))
  "Four entries in the exact shape COUNTED-SUBMIT pushes.  Labels are STRINGS,
because every call site in the suite passes a string literal.")

(defparameter *log-with-the-label-as-a-string*
  (append *log-as-the-suite-builds-it*
          (list (list :label "escape-should-not-log" :count 0
                      :outcome nil :refusal nil)))
  "The label the check hunts for, present — AS A STRING, which is the only
representation any fixture could ever have produced.")

(defparameter *log-with-the-label-as-a-keyword*
  (append *log-as-the-suite-builds-it*
          (list (list :label :escape-should-not-log :count 0
                      :outcome nil :refusal nil)))
  "The label present AS A KEYWORD — the ONLY world in which the shipped form can
return NIL, and a world no call site in the suite can construct.")

(defun old-129 (log)
  "The EXACT shipped predicate, transcribed from 295f9fba."
  (notany (lambda (entry) (eq :escape-should-not-log (getf entry :label))) log))

(format t "~%  ── vacuity, first fold: TYPE ───────────────────────────────────~%~%")
(format t "    log as the suite actually builds it       OLD [129] -> ~A~%"
        (old-129 *log-as-the-suite-builds-it*))
(format t "    log WITH the hunted label, as a STRING    OLD [129] -> ~A~%"
        (old-129 *log-with-the-label-as-a-string*))
(format t "    log WITH the hunted label, as a KEYWORD   OLD [129] -> ~A~%"
        (old-129 *log-with-the-label-as-a-keyword*))
(format t "~%    (eq :escape-should-not-log \"escape-should-not-log\") => ~A~%"
        (eq :escape-should-not-log "escape-should-not-log"))
(format t "~%  The predicate compares a KEYWORD against values that are always~%")
(format t "  STRINGS.  EQ is NIL for every entry any fixture can produce, so~%")
(format t "  NOTANY is T no matter what the layer did.~%")

(format t "~%  ── vacuity, second fold: PROVENANCE ────────────────────────────~%~%")
(format t "  Even under the keyword representation, the check can only fail if some~%")
(format t "  call site passes :ESCAPE-SHOULD-NOT-LOG as a label.  No call site in~%")
(format t "  form1-selftest.lisp ever did, in any representation.  The world in which~%")
(format t "  the shipped [129] returns NIL was never constructible by the suite.~%")
(format t "~%  VERDICT ON THE SHIPPED FORM: *** CANNOT FAIL — HOLLOW, TWICE OVER ***~%")

(format t "~%  ── the repaired form, and the world in which it DOES fail ──────~%")
(format t "~%  THE REPAIRED FORM (commit 7db2da94) runs the escaping submission and~%")
(format t "  records whether control ever reached a point where values existed.~%")
(format t "  Its discriminating world is a submission that DOES return: a VALID~%")
(format t "  conclusion binding, where TRY-SUBMIT-PETITION comes back normally.~%")

;;; The live discrimination.  Two fixtures, identical but for the conclusion
;;; binding; the tooth must report T for the escaping one and NIL for the
;;; returning one.

(defun install-schema ()
  (s1:clear-schema-registry)
  (s1:register-schema
   (s1:judgment-schema
    :name :volume-reshelved :version 1
    :conclusion (pp '(:predicate :volume-reshelved (:volume (:var :volume))))
    :premises (list (pp '(:predicate :volume-scanned-at-desk (:volume (:var :volume))))))))

(defun scan-contract ()
  (s2:make-support-admission-contract
   :contract-id :scan-by-direct-survey
   :accepted-clauses '((:asserted-witness :mode :direct :kind :shelf-scan
                        :truth-ceiling :asserted))))

(defun wrapper ()
  (s2:make-slice2-schema
   :schema-id :volume-reshelved/2
   :base-schema (s1:resolve-schema :volume-reshelved 1)
   :premise-contracts (list (list 0 (scan-contract)))))

(defun scan-witness (volume)
  (s0:witness :for (np `(:predicate :volume-scanned-at-desk (:volume ,volume)))
              :mode :direct :kind :shelf-scan :source :desk-clerk))

(defun desk (witnesses)
  (s0:receiver-context :context-id :reshelving-desk
                       :accessible-supports (mapcar #'s0:witness-id witnesses)))

;;; CONTEXT CONSTRUCTION IS ROUTED THROUGH THIS ONE FUNCTION so that when the
;;; Review 1 binder signature lands, exactly one place changes and the semantic
;;; fixture is provably the same one.  See the run captures: this file is
;;; executed BOTH against the unmodified tip and after the repair.
(defun escape-context (conclusion tag)
  (let* ((witnesses (list (scan-witness "PLUT-7")))
         (context (f1:make-derivation-resolution-context)))
    ;; POLICY v3 MIGRATION, AND THE ONLY LINE THAT CHANGED.  This file is run
    ;; TWICE and both captures are preserved: REVIEW-1-HOLLOW-CHECKS-AT-TIP.txt
    ;; against the unmodified branch tip (v2 binders, three arguments) and
    ;; REVIEW-1-HOLLOW-CHECKS-AFTER-REPAIR.txt against the repaired layer (v3
    ;; binders, four).  The [46] evidence does not touch a binder at all and is
    ;; therefore byte-comparable across both.  The [129] fixture needed the
    ;; fourth argument here and nowhere else, so the semantic fixture is
    ;; provably the same one in both runs.
    (setf context (f1:bind-schema-reference context (f1:schema-reference "s") (wrapper)
                                            (idd '("review-1") '("den" "s"))))
    (setf context (f1:bind-conclusion-reference context (f1:conclusion-reference "c") conclusion
                                                (idd '("review-1") '("den" "c"))))
    (setf context (f1:bind-support-reference context (f1:support-reference "w1")
                                             (first witnesses)
                                             (idd '("review-1") '("den" "w1"))))
    (setf context (f1:bind-receiver-reference context (f1:receiver-reference "r")
                                              (desk witnesses)
                                              (idd '("review-1") '("den" "r"))))
    (f1:seal-resolution-context context (idd '("review-1") (list "ctx" tag)))))

(defun new-129 (conclusion tag)
  "The EXACT repaired predicate, transcribed from 7db2da94, parameterised on the
conclusion binding so both worlds can be run."
  (let ((reached :no-values-ever-returned))
    (let* ((proposed (f1:propose-petition (petition-tree)))
           (validated (f1:validate-petition proposed))
           (petition (f1:materialize-petition validated (idd '("review-1") (list "occ" tag))))
           (context (escape-context conclusion tag)))
      (handler-case
          (multiple-value-bind (outcome refusal)
              (f1:try-submit-petition petition context :by :clerk
                                      :by-id (idd '("review-1") '("by" "1"))
                                      :act-id (idd '("review-1") '("act" "1")))
            (setf reached (list :returned outcome refusal)))
        (f1:petition-refused () (setf reached :converted-to-a-petition-refusal))
        (condition () nil)))
    (eq reached :no-values-ever-returned)))

(install-schema)

(let ((escaping (new-129 '(:predicate :not-a-proposition-object) "escapes"))
      (returning (new-129 (np '(:predicate :volume-reshelved (:volume "PLUT-7"))) "returns")))
  (format t "~%    malformed conclusion (SHOULD escape)   NEW [129] -> ~A~%" escaping)
  (format t "    valid conclusion     (SHOULD return)   NEW [129] -> ~A~%" returning)
  (format t "~%  VERDICT ON THE REPAIRED FORM: ~A~%"
          (if (eq escaping returning)
              "*** CANNOT FAIL — HOLLOW ***"
              "DISCRIMINATES")))

;;; ══════════════════════════════════════════════════════════════════════════

(rule "WHAT THIS FILE IS FOR")

(format t "~%  FANG's two findings are NOT absorbed into the final suite.  A repaired~%")
(format t "  tooth in a green run is indistinguishable from a tooth that was always~%")
(format t "  sound; the history is only preserved if the OLD FORM stays executable~%")
(format t "  beside the new one, in a world that tells them apart.  That is this file.~%")
(format t "~%  It also preserves the chair's own wrong instrument, running, giving the~%")
(format t "  wrong answer — because the review that finds a description standing in~%")
(format t "  for the thing described must be able to find its own.~%")

(format t "~%~%== REVIEW-1-HOLLOW-CHECKS: record complete ==~%")
