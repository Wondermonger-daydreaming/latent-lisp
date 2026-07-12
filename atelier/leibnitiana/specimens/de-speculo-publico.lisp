;;;; de-speculo-publico.lisp — On the public mirror
;;;
;;;; A public Git mirror can provide actual, content-addressed custody outside
;;;; either model's unilateral control. It does not choose an independent
;;;; witness, authenticate process truth, or prove that the carrier pushed every
;;;; relevant artifact. The mirror is an anchor, not an oracle.

(load (merge-pathnames "../src/package.lisp" *load-truename*))
(load (merge-pathnames "../src/core.lisp" *load-truename*))
(load (merge-pathnames "../src/provenance.lisp" *load-truename*))

(in-package #:leibnitiana)

(print-section "NO SPECIFIC MIRROR CHECKPOINT SUPPLIED")
(let ((report (assess-mirror-checkpoint nil)))
  (format t "~S~%" report)
  (check-equal :not-established
               (getf report :custody-standing)
               "a public repository claim does not invent a specific checkpoint"))

(print-section "LOCAL GIT CAPTURE — CONTENT ADDRESSED, NOT YET EXTERNAL")
(let* ((checkpoint
         (make-mirror-checkpoint
          :repository "Wondermonger-daydreaming/latent-lisp"
          :provider :github
          :commit-hash "LOCAL-COMMIT-FIXTURE"
          :tree-hash "LOCAL-TREE-FIXTURE"
          :blob-hash "LOCAL-BLOB-FIXTURE"
          :path "atelier/leibnitiana/data/council-process-2026-07-12.sexp"
          :observed-at "2026-07-12T04:00:00-03:00"
          :observer :landing-script
          :publication-status :captured-from-local-git
          :selection-relation :carrier-selected-not-independent))
       (report (assess-mirror-checkpoint checkpoint)))
  (format t "~S~%" report)
  (check-equal :local-content-addressed-checkpoint-only
               (getf report :custody-standing)
               "local Git object identity is not promoted to public custody")
  (check-equal :not-established
               (getf report :independent-witness)
               "content addressing does not independently select a witness"))

(print-section "PUBLIC MIRROR OBSERVATION — WEAK ACTUAL CUSTODY")
(let* ((checkpoint
         (make-mirror-checkpoint
          :repository "Wondermonger-daydreaming/latent-lisp"
          :provider :github
          :commit-hash "PUBLIC-COMMIT-FIXTURE"
          :tree-hash "PUBLIC-TREE-FIXTURE"
          :blob-hash "PUBLIC-BLOB-FIXTURE"
          :path "atelier/leibnitiana/data/council-process-2026-07-12.sexp"
          :observed-at "2026-07-12T04:05:00-03:00"
          :observer :outside-mirror-observer
          :publication-status :observed-on-public-mirror
          :selection-relation :carrier-selected-not-independent))
       (report (assess-mirror-checkpoint checkpoint)))
  (format t "~S~%" report)
  (check-equal :weak-external-infrastructure-custody
               (getf report :custody-standing)
               "a remotely observed content-addressed object earns weak custody")
  (check-equal :carrier-selected-not-independent
               (getf report :witness-selection)
               "the mirror record carries its selection relation")
  (check-equal :not-established
               (getf report :independent-witness)
               "public infrastructure is not an ancestry-independent cold reader")
  (check-equal
   :content-addressed-publication-does-not-authenticate-process-truth
   (getf report :boundary)
   "the mirror binds bytes, not the honesty or completeness of their history"))
