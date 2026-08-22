;;;; ml0-red-proof.lisp — Memory Layer /0: THE CROWN TOOTH, SHOWN TO BLEED.
;;;;
;;;;   sbcl --script mneme/memory-layer-0/ml0-red-proof.lisp
;;;;   sbcl --script mneme/memory-layer-0/ml0-red-proof.lisp cured
;;;;   sbcl --script mneme/memory-layer-0/ml0-red-proof.lisp uncured
;;;;
;;;; Sentinel (both arms): ml0-red-proof: cured PASS, uncured FAIL — the tooth bites
;;;;
;;;; A SUITE NEVER SEEN TO FAIL LICENSES NOTHING.  This file runs the crown tooth
;;;; — the predicate the whole commission rests on — twice: once against the lane
;;;; as it ships (CURED) and once against the planted
;;;; `:issuance-implies-occurrence` seam (UNCURED).  The uncured run must FAIL,
;;;; VISIBLY, in this transcript.  It exits NONZERO if the uncured arm passes.
;;;;
;;;; With a single argument the file runs ONE arm and exits on that arm's own
;;;; verdict, which is how the preserved RED-BEFORE / GREEN-AFTER captures are
;;;; produced.  No environment variable is involved: a switch that diverts a run
;;;; belongs in the W-ENV class lists, and an argument does not.
;;;;
;;;; THE GROUND IS A LAWFUL REFUSAL, NOT A PLANTED BUG.  `:authority-mode
;;;; :ambient` makes Core /0 refuse at its own authority check, and that refusal
;;;; GENUINELY ISSUES a Core /0 evidence account bound to this act's canonical
;;;; request (core0.lisp:1059-1082, "ISSUANCE SITE 1 of 4").  The journal's frame
;;;; count does not move, the derived standing is :ABSENT, and the world is
;;;; byte-unchanged.  One Act /1's repaired production bug is NOT reintroduced,
;;;; and no public evidence constructor is added or wanted.
;;;;
;;;; ⚠ WHAT THIS PROOF DOES **NOT** SHOW, stated here rather than left for a
;;;; reader to discover: it does not show that the durable bytes differ between
;;;; the arms in any way a reader could detect WITHOUT the rule.  Both arms write
;;;; the same sources; what differs is the STANDING the rule computed from them,
;;;; and that standing is in the bytes.  The tooth detects WHICH RULE WROTE THE
;;;; STANDING — which is exactly the lane's claim, because the standing is the
;;;; only thing a later reader will have.
;;;;
;;;; — TABULARIUS (Claude Opus 5, subagent), 2026-08-20

(require :sb-posix)

(load (merge-pathnames "ml0-suite-ground.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))
;; ⚑ R4: the UNCURED arm's defect used to be a public `&key` on the production
;; functions this file calls.  It is now installed from an overlay `load.lisp`
;; never loads, for the dynamic extent of the arm.
(load (merge-pathnames "ml0-mutant-overlay.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-memory-layer0)

(defparameter *lane-directory*
  (make-pathname :name nil :type nil :defaults *load-truename*))
(defparameter *subject-root* (merge-pathnames "../../" *lane-directory*))
(defparameter *arm-argument* (second sb-ext:*posix-argv*))

(defvar *cured-passed* nil)
(defvar *uncured-passed* nil)

;;; THE CROWN TOOTH, written ONCE and applied to both arms.  If the two arms had
;;; their own copies of the predicate, this file would prove nothing.
(defun crown-tooth (retrieved consolidated-occurrence)
  "The commission's acceptance sentence, as a predicate: when the only positive
artifact is issued evidence for an act that did not occur, NEITHER a
fresh-process-shaped retrieval NOR consolidation may promote it to `occurred`,
and no public reader may answer occurred.

⚠ R4.1 — THIS PARAMETER IS A STANDING, AND IT HAD SILENTLY STOPPED BEING ONE.
When `ml0-consolidate` began returning a typed ML0-CONSOLIDATION carrier, the
call site below kept handing this function the CARRIER, so the middle conjunct
compared a keyword against a struct: it could never be false, and the
consolidation half of the crown tooth was DEAD while the gate went on exiting 0
and printing `the tooth bites`.  Nothing failed — which is why it needed
finding rather than fixing.  The call site now reads the standing off the
carrier; this docstring records the disarming so the next reader knows the
conjunct is load-bearing and not decorative."
  (and (not (ml0-account-occurred-p retrieved))
       (not (eq :occurred consolidated-occurrence))
       (not (eq :occurred (ml0-account-occurrence-standing retrieved)))))

(defun arm (label defect root-stem &key (seat "secunda") (attempt "a-secunda")
                                        (cell '("cella" "vetita-scope"))
                                        (cell-name "cella:vetita-scope")
                                        (symbol 'ml0-red/refused-a)
                                        (settled-seat "prima")
                                        (settled-attempt "a-prima")
                                        (settled-text "Actus memorandus.")
                                        (settled-symbol 'ml0-red/settled-a))
  "⚠ THE TWO ARMS USE DIFFERENT SEATS, and the reason is mechanical rather than
semantic: One Act /1 keeps a RUN-LOCAL set of minted act identities
(act1.lisp:417-419) and refuses a second mint of the same identity in one
process.  Both arms are the SAME SHAPE — a lawful `:ambient` pre-frontier refusal
that genuinely issues evidence — and the transcript prints each arm's own
instruments so a reader can check that rather than take it on trust."
  (let ((root (ml0-fresh-run-root root-stem *subject-root*)))
    (unwind-protect
         ;; ⚑ R4: the arm's defect (NIL for the cured arm) is installed for the
         ;; dynamic extent of the whole arm, from the overlay, instead of being
         ;; threaded as a `:defect` keyword through six production calls.
         (with-ml0-mutant (defect)
           (ml0-ground root)
           (let* ((refused (ml0-refused-row :seat seat :attempt attempt
                                            :cell cell :cell-name cell-name
                                            :symbol symbol))
                  (settled (ml0-settled-row :seat settled-seat
                                            :attempt settled-attempt
                                            :text settled-text
                                            :symbol settled-symbol)))
             (setf lisp-plus-language-act1:*act1-fixture-table*
                   (list settled refused))
             (ml0-open-authority (list settled refused))
             ;; ⚑ THE SETTLED ACT IS PERFORMED FIRST, so the single-delta pair's
             ;; LAWFUL row has genuinely satisfied legs rather than asserted ones.
             (let* ((settled-result (lisp-plus-language-act1:run-act1 settled
                                                                      :verbose nil))
                    (settled-id (nth-value 0 (ml0-rederive-act-identity settled)))
                    (frames-before (nth-value 1 (act1-journal-kinds *ml0-act-store*)))
                    (world-before (lisp-plus-language-act1:take-world-scope
                                   (ml0-world) (ml0-world-directory)
                                   :request-key
                                   (lisp-plus-language-act1:external-request-key
                                    attempt)))
                    (result (lisp-plus-language-act1:run-act1 refused :verbose nil))
                    (frames-after (nth-value 1 (act1-journal-kinds *ml0-act-store*)))
                    (world-after (lisp-plus-language-act1:take-world-scope
                                  (ml0-world) (ml0-world-directory)
                                  :request-key
                                  (lisp-plus-language-act1:external-request-key
                                   attempt)))
                    (evidence (lisp-plus-language-act1:act1-result-evidence result))
                    (act-id (nth-value 0 (ml0-rederive-act-identity refused)))
                    ;; ⚑ THE SINGLE-DELTA NEAR-NEIGHBOUR PAIR (AMENDMENT 1.2), and
                    ;; it is built ON THE SETTLED ACT — the one act for which a
                    ;; genuinely COMPLETE bundle of BOTH species exists, so that
                    ;; the pair really are near-neighbours and not a strong row
                    ;; beside a hobbled one.  Both are about the SAME act, with the
                    ;; SAME acquisition route, the SAME declared scope, the SAME
                    ;; observation interval, the SAME attestation, and a 64-hex
                    ;; payload digest each.  ONE FIELD DIFFERS: the species.
                    ;;
                    ;; ⚠ AND ON THIS PAIR THE ACT DID OCCUR.  The cured rule still
                    ;; refuses the issuance row — which is the sharper half of the
                    ;; law: an inadmissible warrant yields :UNRESOLVED even when
                    ;; its conclusion happens to be TRUE.  A rule that promoted
                    ;; here would be right by luck, and right by luck is the thing
                    ;; a memory layer cannot afford.
                    (lawful-src (nth-value 0 (ml0-single-delta-pair
                                              settled-id settled-attempt
                                              (lisp-plus-language-act1:act1-result-evidence
                                               settled-result))))
                    (delta-src (nth-value 1 (ml0-single-delta-pair
                                             settled-id settled-attempt
                                             (lisp-plus-language-act1:act1-result-evidence
                                              settled-result))))
                    ;; the CROWN NEGATIVE's own row: the refused act, whose
                    ;; issuance is genuine and whose occurrence is not.
                    (issuance-src (ml0-issuance-source act-id evidence))
                    (written (ml0-write *ml0-account-store*
                                        (make-ml0-bundle
                                         :fixture-row refused
                                         :claimed-act-id act-id
                                         :subject-principal *suite-actor*
                                         :sources (list issuance-src)
                                         :issuance-observation (ml0-issuance-observation-for act-id result))))
                    ;; a second, DISTINCT issuance-only account of the same act,
                    ;; so consolidation has something to consolidate
                    (second-written (ml0-write *ml0-account-store*
                                               (make-ml0-bundle
                                                :fixture-row refused
                                                :claimed-act-id act-id
                                                :subject-principal *suite-actor*
                                                :sources (list issuance-src
                                                               (ml0-self-report-source
                                                                act-id "a second reading"))
                                                :issuance-observation (ml0-issuance-observation-for act-id result))))
                    ;; the readback goes through the durable bytes, not the object
                    (retrieved (ml0-retrieve *ml0-account-store*
                                             :account-hex (ml0-account-id-hex written)))
                    ;; ⚠ R4.1: READ THE STANDING OFF THE CARRIER.  Passing the
                    ;; carrier itself made `crown-tooth`'s middle conjunct
                    ;; vacuously true — see its docstring.
                    (consolidated (ml0-consolidation-occurrence-standing
                                   (ml0-consolidate
                                    (list retrieved second-written))))
                    (verdict (crown-tooth retrieved consolidated)))
               (format t "~&---- ~a ----~%" (format nil label))
               (format t "  defect seam            : ~s~%" defect)
               (format t "~%  THE PINNED PROPOSITION `:occurred` WOULD WARRANT:~%    ~a~%"
                       +ml0-occurred-proposition+)
               (format t "~%  THE ACT (a lawful pre-frontier refusal):~%")
               (format t "    disposition          : ~s~%"
                       (lisp-plus-language-act1:act1-result-disposition result))
               (format t "    class                : ~s~%"
                       (lisp-plus-language-act1:act1-result-class result))
               (format t "    EVIDENCE-ISSUED      : ~a~%"
                       (lisp-plus-core0:core0-evidence-current-image-issued-p evidence))
               (format t "    ISSUED-FOR-REQUEST   : ~a~%"
                       (lisp-plus-core0:core0-evidence-current-image-issued-for-request-p
                        evidence
                        (lisp-plus-language-act1:act1-record-normal-form
                         (lisp-plus-language-act1:act1-result-record result))))
               (format t "    JOURNAL-FRAMES-MOVED : ~a  (~d -> ~d)~%"
                       (if (eql frames-before frames-after) "NIL" "YES")
                       frames-before frames-after)
               (format t "    DERIVED-STANDING     : ~s~%"
                       (derive-effect-standing *ml0-act-store* attempt))
               (format t "    WORLD-BYTE-UNCHANGED : ~a~%"
                       (if (lisp-plus-language-act1:world-scope-unchanged-p
                            world-before world-after) "T" "NO"))
               (format t "~%  THE ACCOUNT, read back from durable bytes:~%")
               (format t "    account id           : ~a~%" (ml0-account-id-hex retrieved))
               (format t "    OCCURRENCE standing  : ~s~%"
                       (ml0-account-occurrence-standing retrieved))
               (format t "    ISSUANCE standing    : ~s~%"
                       (ml0-account-issuance-standing retrieved))
               (format t "    issuance-only-p      : ~a~%"
                       (if (ml0-account-issuance-only-p retrieved) "T" "NIL"))
               (format t "    after CONSOLIDATION  : ~s~%" consolidated)
               (format t "~%  THE SINGLE-DELTA PAIR — same act binding, same route, ~
same declared scope,~%  same observation interval, same attestation; ONLY THE ~
SPECIES DIFFERS:~%")
               (ml0-print-conjuncts
                "row A — the LAWFUL occurrence bundle (species world-bytes)"
                settled-id lawful-src)
               (ml0-print-conjuncts
                "row B — the SAME act, SAME everything, species core0-issuance-testimony"
                settled-id delta-src)
               (multiple-value-bind (ok-a source-a reason-a)
                   (ml0-occurrence-warranted-p settled-id (list lawful-src))
                 (declare (ignore source-a))
                 (format t "~%  RULE ON ROW A: ~a~%    ~a~%"
                         (if ok-a "PROMOTED" "refused") reason-a))
               (multiple-value-bind (ok-b source-b reason-b)
                   (ml0-occurrence-warranted-p settled-id (list delta-src))
                 (declare (ignore source-b))
                 (format t "  RULE ON ROW B: ~a~%    ~a~%"
                         (if ok-b "PROMOTED" "refused") reason-b))
               (format t "~%  CROWN TOOTH            : ~a~%~%"
                       (if verdict "PASS" "FAIL"))
               (finish-output)
               verdict)))
      (when (probe-file root) (sb-ext:delete-directory root :recursive t)))))

(format t "~&Memory Layer /0 — RED PROOF of the crown tooth.  CANDIDATE; nothing ~
here is adopted.~%~%")

(unless (ml0-env-preflight :signal nil)
  (format t "~&ml0-red-proof: VOID — a process-ending switch is set.~%")
  (sb-ext:exit :code 4))
(terpri)

(cond
  ((equal *arm-argument* "cured")
   (let ((ok (arm "CURED — the lane as it ships" nil "ml0-red-cured")))
     (format t "~&ml0-red-proof [cured arm only]: the tooth ~a~%"
             (if ok "HOLDS" "DOES NOT HOLD"))
     (finish-output)
     (sb-ext:exit :code (if ok 0 1))))
  ((equal *arm-argument* "uncured")
   (let ((ok (arm "UNCURED — the planted :issuance-implies-occurrence seam"
                  :issuance-implies-occurrence "ml0-red-uncured"
                  :seat "tertia" :attempt "a-tertia"
                  :cell '("cella" "vetita-ambient")
                  :cell-name "cella:vetita-ambient"
                  :symbol 'ml0-red/refused-b
                  :settled-seat "quarta" :settled-attempt "a-quarta"
                  :settled-text "Actus memorandus alter."
                  :settled-symbol 'ml0-red/settled-b)))
     (format t "~&ml0-red-proof [uncured arm only]: the tooth ~a — and it MUST ~
NOT hold here, which is why this capture exits NONZERO~%"
             (if ok "HOLDS" "DOES NOT HOLD"))
     (finish-output)
     (sb-ext:exit :code (if ok 0 1))))
  (t
   (setf *cured-passed* (arm "CURED — the lane as it ships" nil "ml0-red-cured"))
   (setf *uncured-passed*
         (arm "UNCURED — the planted :issuance-implies-occurrence seam"
              :issuance-implies-occurrence "ml0-red-uncured"
              :seat "tertia" :attempt "a-tertia"
              :cell '("cella" "vetita-ambient")
              :cell-name "cella:vetita-ambient"
              :symbol 'ml0-red/refused-b
              :settled-seat "quarta" :settled-attempt "a-quarta"
              :settled-text "Actus memorandus alter."
              :settled-symbol 'ml0-red/settled-b))
   (format t "~&READ THIS BEFORE BANKING THE PROOF: both arms wrote the SAME ~
sources over the SAME lawful refusal, and both arms' journals and worlds are ~
equally untouched.  What differs is the OCCURRENCE STANDING the promotion rule ~
computed and then committed to durable bytes — and that standing is all a later ~
reader will ever have.  The tooth kills the uncured lane on what the account ~
SAYS, which is the only thing a memory layer can be wrong about.~%~%")
   (let ((green (and *cured-passed* (not *uncured-passed*))))
     (format t "~&ml0-red-proof: cured ~a, uncured ~a — the tooth ~a~%"
             (if *cured-passed* "PASS" "FAIL")
             (if *uncured-passed* "PASS" "FAIL")
             (if green "bites" "DID NOT BITE"))
     (finish-output)
     (sb-ext:exit :code (if green 0 1)))))
