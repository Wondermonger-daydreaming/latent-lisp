;;;; probe-door-semantics.lisp — CHAIR probes, Surface /1 stranger audit 2026-07-28.
;;;;
;;;; Jurisdiction: §5 of the audit brief — same-package same-name symbol
;;;; reincarnation between Door 1 and Door 2, and the reachability of
;;;; ROUND-TRIP-MISMATCH through public inputs.
;;;;
;;;; This file mutates ONLY the running image (fresh audit packages) and its own
;;;; output.  It never touches the subject's files.

(load (merge-pathnames "../../extract/target/tree/mneme/language-surface-1/surface1.lisp"
                       *load-truename*))

(defpackage #:chair-probe (:use #:cl #:lisp-plus-surface1))
(in-package #:chair-probe)

(defvar *results* '())
(defun say (fmt &rest args) (format t "~&~?~%" fmt args) (finish-output))
(defun verdict (name pass fmt &rest args)
  (push (list name pass) *results*)
  (say "  [~a] ~a — ~?" (if pass "OBSERVED" "NOT-OBSERVED") name fmt args))

(defun tag (n)
  (lisp-plus-cd0:make-identifier-datum '("chair-audit") (list n)))

;;; ==================================================================
;;; PROBE A — same-package, same-name symbol REINCARNATION.
;;; ==================================================================
(say "~%=== PROBE A: symbol reincarnation between the doors ===")

(defpackage #:audit-p (:use))
(let* ((s1 (intern "REINCARNATE" (find-package "AUDIT-P")))
       (form (list s1 7))
       (req (request-expansion form :macroexpand-1 (tag "A"))))
  ;; kill the original symbol; raise a same-named stranger in its place
  (unintern s1 (find-package "AUDIT-P"))
  (let ((s2 (intern "REINCARNATE" (find-package "AUDIT-P"))))
    (verdict "A0-non-eq" (not (eq s1 s2)) "s1 and s2 are distinct host objects: ~a" (not (eq s1 s2)))
    ;; A1 — public decode-term: which object does the stored datum resolve to now?
    (let ((decoded (decode-term (expansion-request-source-form-datum req))))
      (verdict "A1-decode-resolves-to-s2"
               (and (consp decoded) (eq (car decoded) s2) (not (eq (car decoded) s1)))
               "decode-term returned head EQ to the REINCARNATED s2 (~a), non-EQ to the original s1 (~a)"
               (eq (car decoded) s2) (not (eq (car decoded) s1))))
    ;; A2 — full Door 2: reconstruction + round-trip gate must PASS (the refusal,
    ;; if any, must be the LATER :not-a-known-surface-construct, proving the gate
    ;; was crossed with the reincarnated symbol).
    (multiple-value-bind (receipt expanded refusal) (try-perform-expansion req)
      (declare (ignore receipt expanded))
      (verdict "A2-gate-crossed-with-s2"
               (and refusal
                    (eq (expansion-refusal-code refusal) :not-a-known-surface-construct))
               "Door 2 refusal code = ~s (reconstruction and round-trip gate PASSED; ~
                the reincarnated symbol reached construct resolution)"
               (and refusal (expansion-refusal-code refusal))))))

;;; ==================================================================
;;; PROBE B — rename-package WITH the old name kept as a nickname:
;;;           a public route to ROUND-TRIP-MISMATCH?
;;; ==================================================================
(say "~%=== PROBE B: rename-package (nickname kept) -> ROUND-TRIP-MISMATCH ===")

(defpackage #:audit-rho (:use))
(let* ((x (intern "X" (find-package "AUDIT-RHO")))
       (req (request-expansion (list x) :macroexpand-1 (tag "B"))))
  (rename-package (find-package "AUDIT-RHO") "AUDIT-RHO-PRIME" '("AUDIT-RHO"))
  (multiple-value-bind (receipt expanded refusal) (try-perform-expansion req)
    (declare (ignore receipt expanded))
    (verdict "B1-round-trip-mismatch-reached"
             (and refusal
                  (eq (expansion-refusal-code refusal) :source-not-reconstructible)
                  (equal (expansion-refusal-upstream-code refusal) "ROUND-TRIP-MISMATCH"))
             "code=~s upstream-code=~s upstream-stage=~s detail=~s"
             (and refusal (expansion-refusal-code refusal))
             (and refusal (expansion-refusal-upstream-code refusal))
             (and refusal (expansion-refusal-upstream-stage refusal))
             (and refusal (expansion-refusal-detail refusal))))
  ;; restore the world for later probes
  (rename-package (find-package "AUDIT-RHO-PRIME") "AUDIT-RHO"))

;;; ==================================================================
;;; PROBE B2 — rename WITHOUT nickname: the earlier guard fires instead,
;;;            showing exactly where the boundary sits.
;;; ==================================================================
(say "~%=== PROBE B2: rename-package (no nickname) -> PACKAGE-ABSENT ===")

(defpackage #:audit-tau (:use))
(let* ((x (intern "X" (find-package "AUDIT-TAU")))
       (req (request-expansion (list x) :macroexpand-1 (tag "B2"))))
  (rename-package (find-package "AUDIT-TAU") "AUDIT-TAU-PRIME")
  (multiple-value-bind (receipt expanded refusal) (try-perform-expansion req)
    (declare (ignore receipt expanded))
    (verdict "B2-package-absent"
             (and refusal
                  (eq (expansion-refusal-code refusal) :source-not-reconstructible)
                  (equal (expansion-refusal-upstream-code refusal) "PACKAGE-ABSENT-IN-IMAGE"))
             "code=~s upstream-code=~s"
             (and refusal (expansion-refusal-code refusal))
             (and refusal (expansion-refusal-upstream-code refusal))))
  (rename-package (find-package "AUDIT-TAU-PRIME") "AUDIT-TAU"))

;;; ==================================================================
;;; PROBE C — WHOLE-PACKAGE reincarnation: old package renamed away, a fresh
;;;           package takes its name, a fresh symbol takes the name.  Does the
;;;           stranger cross Door 2 with no refusal at the gate?
;;; ==================================================================
(say "~%=== PROBE C: whole-package reincarnation crosses silently ===")

(defpackage #:audit-sigma (:use))
(let* ((y1 (intern "Y" (find-package "AUDIT-SIGMA")))
       (req (request-expansion (list y1) :macroexpand-1 (tag "C"))))
  (rename-package (find-package "AUDIT-SIGMA") "AUDIT-SIGMA-OLD")  ; no nickname
  (let* ((fresh (make-package "AUDIT-SIGMA" :use '()))
         (y2 (intern "Y" fresh)))
    (verdict "C0-distinct" (and (not (eq y1 y2))
                                (not (eq (symbol-package y1) (symbol-package y2))))
             "y2 and its package are BOTH new host objects, unrelated to Door 1's")
    (let ((decoded (decode-term (expansion-request-source-form-datum req))))
      (verdict "C1-decode-resolves-to-stranger"
               (eq (car decoded) y2)
               "decode-term resolved to the fresh package's fresh symbol"))
    (multiple-value-bind (receipt expanded refusal) (try-perform-expansion req)
      (declare (ignore receipt expanded))
      (verdict "C2-gate-crossed-with-stranger"
               (and refusal
                    (eq (expansion-refusal-code refusal) :not-a-known-surface-construct))
               "Door 2 code = ~s — the round-trip gate PASSED on a symbol whose ~
                package did not exist at Door 1"
               (and refusal (expansion-refusal-code refusal))))))

;;; ==================================================================
;;; Summary.
;;; ==================================================================
(let ((obs (count-if #'second *results*))
      (all (length *results*)))
  (say "~%CHAIR-PROBE-RESULT observed=~d of=~d" obs all)
  (sb-ext:exit :code (if (= obs all) 0 1)))
