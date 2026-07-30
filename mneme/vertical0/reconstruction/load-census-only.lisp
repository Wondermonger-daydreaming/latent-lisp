;;;; load-census-only.lisp — the MINIMAL load chain for official state.
;;;;
;;;; Contract §11: the official census is produced "in a FRESH process
;;;; loading only: primary durable journals, lawfully captured evidence,
;;;; public program configuration, the census procedure module
;;;; (census.lisp).  It must not load: the orchestration module
;;;; (campaign.lisp), the oracle, finalizer outputs, live caches, dead
;;;; state, private fake-world truth."
;;;;
;;;; This file is the executable form of that sentence.  It loads:
;;;;
;;;;   Capability /2 (which transitively brings Capability /1, /0,
;;;;   Journal /0, Canonical Datum /0 and the smoke-checked Kernel /0)
;;;;   Adapter /0 (guarded against a second journal0 load)
;;;;   program/package.lisp        — the vertical package
;;;;   program/config-reader.lisp  — PUBLIC program configuration (data)
;;;;   program/records.lisp        — event envelopes + fold-side readers
;;;;   program/evidence.lisp       — read-octet-file (captured evidence)
;;;;   program/budget.lisp         — the durable cost fold
;;;;   program/census.lisp         — vertical-census-0, THE procedure
;;;;
;;;; It does NOT load, and MUST never be extended to load:
;;;;   program/campaign.lisp       — the ORCHESTRATION module
;;;;   harness/*.lisp              — the grader's program
;;;;   VERTICAL-HARNESS-ORACLE.sexp— grader knowledge
;;;;   reconstruction/finalizer.lisp — derived artifacts only
;;;;
;;;; recovery-projection.lisp and interpretation.lisp are also omitted:
;;;; they are campaign-time transformations, and the census derives their
;;;; results from the JOURNALED records they left behind, never from the
;;;; procedures themselves.  Loading less is the point.
;;;;
;;;; ORCHESTRATION GUARD (code, not prose): after loading, this file
;;;; refuses if the orchestration module turns out to be present in the
;;;; image.  CAMPAIGN-MAIN is campaign.lisp's entry point and exists in
;;;; no other file in this lane.
;;;;
;;;; — TALLYARD (Claude Fable 5 subagent), 2026-07-30

(let* ((here (make-pathname :name nil :type nil :defaults *load-truename*))
       (program (merge-pathnames "../program/" here)))
  (unless (find-package '#:lisp-plus-capability2)
    (load (merge-pathnames "../../capability2/load.lisp" here)))
  (unless (find-package '#:lisp-plus-adapter0)
    (load (merge-pathnames "../../adapter0/load.lisp" here)))
  (unless (find-package '#:lisp-plus-vertical0)
    (dolist (source '("package.lisp"
                      "config-reader.lisp"
                      "records.lisp"
                      "evidence.lisp"
                      "budget.lisp"
                      "census.lisp"))
      (load (merge-pathnames source program)))))

;;; The guard.  A census-only image that has the orchestration module in
;;; it is not a census-only image, whatever its load list claims.
(defun vertical0-census-only-orchestration-present-p ()
  "T iff the ORCHESTRATION module (campaign.lisp) is in this image.
Teeth: VERTICAL0_FAKE_ORCHESTRATION=1 makes this answer T with nothing
loaded, so every caller's refusal path can be fired on demand."
  (or (and (sb-ext:posix-getenv "VERTICAL0_FAKE_ORCHESTRATION") t)
      (let ((symbol (find-symbol "CAMPAIGN-MAIN"
                                 (find-package '#:lisp-plus-vertical0))))
        (and symbol (fboundp symbol) t))))

(defun vertical0-census-only-guard ()
  (when (vertical0-census-only-orchestration-present-p)
    (error "census-only guard: the ORCHESTRATION module (campaign.lisp) ~
            is present in this image; official state may not be derived ~
            from an orchestrated process (contract §11)"))
  t)

(vertical0-census-only-guard)
