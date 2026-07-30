;;;; VERTICAL-PROGRAM-CONFIG.sexp — Vertical Specimen /0, program-lawful input.
;;;; JURISDICTION (sealed contract §2.1): only what the program lawfully knows.
;;;; NO life numbers, NO W labels, NO kill schedule, NO expected folds or
;;;; outcomes, NO oracle pathname, NO private fake-world truth.
;;;; Read with the narrow data reader (no read-eval); this is data, not code.

(:vertical-program-config
 (:config-version "vertical-config-0")
 (:declared-versions
  (:adapter "adapter0-through-erratum-0.1"
   :cost-procedure "fake-cost-procedure-1"
   :recovery-projection "vertical-recovery-projection-0"
   :interpretation "vertical-interpretation-0"
   :census "vertical-census-0"))

 ;; Adapter invocation configuration (public).
 (:adapter
  (:descriptor-identity "fake-reference-0"
   :usage-procedure "fake-usage-procedure-0"
   :cost-procedure "fake-cost-procedure-1"
   :price-schedule "fake-prices-v0"))

 ;; Synthetic authority configuration.
 (:authority
  (:bootstrap-issuer "auctor-primus"
   :subject ("subject" "machina")
   :action ("action" "loqui")
   :scope ("scope" "semel")
   ;; S10's identity is granted and then revoked in the opening grants.
   :revoked-seats ("seat-dead-hand")))

 ;; Budget (ketiv/qere per Adapter /0 Erratum 0.1): the ceiling and every
 ;; declared estimate carry BOTH the source lexeme and are canonicalized
 ;; by the narrow grammar at load. Currency USD.
 (:budget
  (:ceiling-lexeme "5/1"))

 ;; The canonical bank. Twelve seats; per-seat: route class, projection
 ;; shape (absence-table shape leaf, or nil), declared estimated cost
 ;; lexeme (nil = extract without schedule -> missing-cost marker),
 ;; world cell name. Routes: :full-clean :frontier-only :streaming
 ;; :envelope-then-recover :project-then-consume-later :refused-budget
 ;; :refused-authority :interrupted-then-reconcile :late-full-clean
 (:bank
  ((:seat "seat-first-fruit"   :route :full-clean
    :shape "nonempty"      :estimate-lexeme nil            :cell "cella-prima")
   (:seat "seat-empty-page"    :route :full-clean
    :shape "empty-string"  :estimate-lexeme "100/1000000"  :cell "cella-vacua")
   (:seat "seat-locked-purse"  :route :refused-budget
    :shape nil             :estimate-lexeme "1000000/1"    :cell "cella-clausa")
   (:seat "seat-torn-crossing" :route :frontier-only
    :shape nil             :estimate-lexeme "200/1000000"  :cell "cella-scissa")
   (:seat "seat-half-song"     :route :streaming
    :shape "partial"       :estimate-lexeme "300/1000000"  :cell "cella-dimidia")
   (:seat "seat-broken-glass"  :route :full-clean
    :shape "invalid-utf8"  :estimate-lexeme "2/4"          :cell "cella-fracta")
   (:seat "seat-dead-hand"     :route :refused-authority
    :shape nil             :estimate-lexeme "100/1000000"  :cell "cella-mortua")
   (:seat "seat-slammed-door"  :route :interrupted-then-reconcile
    :shape nil             :estimate-lexeme "1/2"          :cell "cella-clausa-post")
   (:seat "seat-burned-draft"  :route :full-clean
    :shape "missing"       :estimate-lexeme "100/1000000"  :cell "cella-usta")
   (:seat "seat-sealed-letter" :route :envelope-then-recover
    :shape "nonempty"      :estimate-lexeme "400/1000000"  :cell "cella-sigillata")
   (:seat "seat-cold-supper"   :route :project-then-consume-later
    :shape "nonempty"      :estimate-lexeme "500/1000000"  :cell "cella-frigida")
   (:seat "seat-late-riser"    :route :late-full-clean
    :shape "nonempty"      :estimate-lexeme "600/1000000"  :cell "cella-sera")))

 ;; Public campaign policy.
 (:policy
  (;; Deterministic seat order (the program simply proceeds over what
   ;; remains; it never knows where or whether it will be killed).
   :seat-order ("seat-first-fruit" "seat-empty-page" "seat-locked-purse"
                "seat-torn-crossing" "seat-half-song" "seat-broken-glass"
                "seat-dead-hand" "seat-slammed-door" "seat-burned-draft"
                "seat-sealed-letter" "seat-cold-supper" "seat-late-riser")
   ;; Declared semantic boundaries at which the child pauses (emit
   ;; BOUNDARY-READY on stdout, block reading stdin for CONTINUE),
   ;; DECLARED PER ROUTE — a route pauses only where its window is
   ;; genuinely open (full-clean routes close their windows atomically
   ;; inside the public calls and never pause):
   :route-pauses
   ((:route :frontier-only
     :pauses ("EFFECT-FRONTIER-CROSSED-UNSETTLED"))
    (:route :streaming
     :pauses ("STREAM-CHUNK-CUSTODY-COMMITTED"))
    (:route :envelope-then-recover
     :pauses ("ENVELOPE-CUSTODY-COMMITTED" "PROJECTION-COMMITTED"))
    (:route :project-then-consume-later
     :pauses ("PROJECTION-COMMITTED")))
   ;; A partial stream is never resumed: resumption from chunk zero
   ;; would duplicate custody; the typed refusal is journaled once.
   :partial-stream-resumption :refused
   ;; Seats whose crossing runs under the declared request-loss
   ;; simulation (cap2's :request-lost seam — the request crosses the
   ;; frontier and never reaches the world; public fake-world behavior,
   ;; not a schedule secret). seat-torn-crossing then LEAVES its
   ;; uncertainty unresolved (:leave-unresolved policy);
   ;; seat-slammed-door reconciles through cap2 world evidence.
   :request-loss-simulated-seats ("seat-torn-crossing" "seat-slammed-door")
   :torn-crossing-policy :leave-unresolved
   :stream-chunk-count 2
   :journal-declared-durability "synced"
   :journal-nonce "vertical-de-morte"))

 ;; W1 indistinguishability control bank (program-lawful template; the
 ;; harness materializes one identical copy per arm). The control child:
 ;; crosses under request-loss simulation, pauses (killable), and on
 ;; recovery journals its uncertainty disposition, pauses at
 ;; CONTROL-DISPOSITION-COMMITTED (so the disposition is banked and
 ;; compared BEFORE any provider evidence exists), then on CONTINUE
 ;; attempts lawful reconciliation through the declared class-B reader
 ;; and journals the outcome. Nothing here names arms or hidden truth.
 (:control-bank
  (:seat "seat-control" :route :frontier-only
   :shape nil :estimate-lexeme "100/1000000" :cell "cella-controlata"
   :control-policy :disposition-then-reconcile
   :control-pauses ("EFFECT-FRONTIER-CROSSED-UNSETTLED"
                    "CONTROL-DISPOSITION-COMMITTED")))

 ;; Synthetic secret-opening fixtures (wholly synthetic; no real material).
 (:secret
  (:rubric-id "rubrum-sigillatum-0"
   :rubric-body "SYNTHETIC-SEALED-RUBRIC-NOT-A-REAL-SECRET"
   :opening-action ("action" "aperire")
   :exposed-principals ("principalis-unus" "principalis-duo")
   :exposure-scope "vertical-campaign-graders"))

 ;; Synthetic publication fixtures (test channel; never the real mirror).
 (:publication
  (:staging-artifact "export/campaign-export.sexp"
   :publication-action ("action" "publicare")
   :mirror-destination "mirror-sim/"
   :mirror-cell "cella-speculi"
   :channel-policy "test-channel-only-no-real-mirror")))
