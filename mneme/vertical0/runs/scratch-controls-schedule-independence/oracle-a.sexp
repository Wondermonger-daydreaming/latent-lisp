;;;; VERTICAL-HARNESS-ORACLE.sexp — Vertical Specimen /0, GRADER KNOWLEDGE ONLY.
;;;; JURISDICTION (sealed contract §2.2): the child and every recovering
;;;; process must NEVER receive or open this artifact; the strace read-set
;;;; witness proves it. The harness consults private fake-world truth only
;;;; AFTER the program has durably committed its recovery disposition.

(:vertical-harness-oracle
 (:oracle-version "vertical-oracle-0")

 ;; Kill schedule: (boundary-name campaign-cumulative-occurrence -> SIGKILL).
 ;; Pauses are PER-ROUTE (config :route-pauses); occurrences count every
 ;; pause at that boundary across the whole campaign, in the
 ;; deterministic seat order of the program config.
 (:kill-schedule
  ((:w "W1" :boundary "EFFECT-FRONTIER-CROSSED-UNSETTLED" :occurrence 1
    :expected-seat "seat-torn-crossing" :life 1)
   (:w "W2" :boundary "STREAM-CHUNK-CUSTODY-COMMITTED"    :occurrence 1
    :expected-seat "seat-half-song"     :life 2)
   (:w "W3" :boundary "ENVELOPE-CUSTODY-COMMITTED"        :occurrence 1
    :expected-seat "seat-sealed-letter" :life 3)
   (:w "W4" :boundary "PROJECTION-COMMITTED"              :occurrence 2
    :expected-seat "seat-cold-supper"   :life 4)))
 ;; Life 5 receives only CONTINUE answers and must exit 0.

 ;; Expected boundary-occurrence ledger (grading aid, derived from the
 ;; declared seat order + route pauses; corrected additively if the
 ;; sealed expectation proves wrong). Only pausing routes appear:
 ;; frontier:   S2(1=KILL W1)                       [route :frontier-only]
 ;; chunk:      S3(1=KILL W2)                       [route :streaming]
 ;; envelope:   S4(1=KILL W3)                       [route :envelope-then-recover]
 ;; projection: S4-recovery(1, life 4, CONTINUE)
 ;;             S5(2=KILL W4)                       [route :project-then-consume-later]

 ;; Expected corpse records at each death (semantic grain; the seat's
 ;; frontier group = prepared-invocation, request-capture, exposure,
 ;; cap2 attempt:prepared, attempt:frontier-crossed, ap0 dispatch,
 ;; crossing-evidence-binding):
 (:expected-corpses
  ((:w "W1" :seat "seat-torn-crossing"
    :present (:frontier-group)
    :absent (:acknowledgment :settlement :effect-evidence))
   (:w "W2" :seat "seat-half-song"
    :present (:frontier-group :acknowledgment :chunk-1)
    :absent (:chunk-2 :terminal-settlement))
   (:w "W3" :seat "seat-sealed-letter"
    :present (:frontier-group :acknowledgment :envelope-record
              :envelope-evidence-file)
    :absent (:projection))
   (:w "W4" :seat "seat-cold-supper"
    :present (:frontier-group :acknowledgment :envelope-record
              :envelope-evidence-file :projection)
    :absent (:consumption :interpretation))))

 ;; Expected fold after each restart (the recovering program's lawful
 ;; conclusions; graded against the journal it produces):
 (:expected-folds
  ((:after "W1" :seat "seat-torn-crossing"
    :effect-standing :crossed-unsettled
    :then :structured-uncertainty :blind-retry :refused)
   (:after "W2" :seat "seat-half-song"
    :manifestation :present-partial :chunks-preserved t
    :resumption :refused-typed)
   (:after "W3" :seat "seat-sealed-letter"
    :envelope :integrity-checked :projection :derived-from-captured-bytes
    :provider-recalled nil)
   (:after "W4" :seat "seat-cold-supper"
    :projection :byte-identical :consumption :of-existing
    :provider-recalled nil)))

 ;; Expected final per-seat outcome map (census grain):
 (:expected-outcomes
  ((:seat "seat-first-fruit"   :manifestation :present        :effect :settled)
   (:seat "seat-empty-page"    :manifestation :present-empty  :effect :settled)
   (:seat "seat-locked-purse"  :manifestation :absent
    :absence-state :refused-pre-effect :refusal budget-ceiling-exceeded)
   (:seat "seat-torn-crossing" :manifestation :absent
    :effect :uncertain-unresolved)
   (:seat "seat-half-song"     :manifestation :present-partial
    :effect :crossed-unsettled-partial-closed)
   (:seat "seat-broken-glass"  :manifestation :present-invalid :effect :settled)
   (:seat "seat-dead-hand"     :manifestation :absent
    :absence-state :refused-pre-effect :refusal capability-revoked)
   (:seat "seat-slammed-door"  :manifestation :absent
    :effect :reconciled-not-applied)
   (:seat "seat-burned-draft"  :manifestation :absent
    :absence-state :absent-after-completion :effect :settled)
   (:seat "seat-sealed-letter" :manifestation :present :effect :settled
    :projection-origin :derived-recovery)
   (:seat "seat-cold-supper"   :manifestation :present :effect :settled)
   (:seat "seat-late-riser"    :manifestation :present :effect :settled)))

 ;; W1 indistinguishability pair — PRIVATE ground truth. Flow:
 ;; life 1: control child killed at its W1 boundary (arms identical).
 ;; life 2: recovery journals the uncertainty disposition and pauses at
 ;;   CONTROL-DISPOSITION-COMMITTED. The harness BANKS both arms'
 ;;   journal snapshots and requires the dispositions canonically equal
 ;;   BEFORE planting any provider evidence (order-enforced: at
 ;;   disposition time the class-B provider domain is identical—empty—
 ;;   in both arms). Only then does the harness play the concurrent
 ;;   provider per this table, writing (or not) the effect into the
 ;;   fake provider's durable domain; then CONTINUE.
 ;; reconciliation: the child reads class B ONLY through the declared
 ;;   reconciliation reader feeding ap0:reconcile-request; each arm must
 ;;   reach its true standing; the uncertainty records stay unchanged.
 (:w1-control
  ((:arm "control-a" :hidden-truth :effect-applied
    :post-reconciliation :found-uncertainty-preserved)
   (:arm "control-b" :hidden-truth :effect-not-applied
    :post-reconciliation :not-found-settled-no-effect)))

 ;; Mutation schedule (each killed by its exact predicate; counts derive
 ;; from the live mutant registries at run time, never from this file):
 (:mutation-schedule
  (:rule-omission
   (:unsafe-retry-allowed :revoked-accepted :scope-mismatch-accepted
    :budget-ignored :ack-promoted-to-settlement :partial-promoted-complete
    :projection-promoted-to-truth :missing-cost-as-zero
    :finalizer-only-fact :no-sync-durability :w1-settled-by-script)
   :rule-addition
   (:deny-every-mint :every-seat-poisoned :every-budget-exhausted
    :suppress-every-dispatch :refuse-every-projection
    :refuse-every-consumption :preserve-uncertainty-despite-evidence
    :every-manifestation-unresolved :refuse-founded-census)))

 ;; Grading predicates (names; bodies live in the harness grader):
 (:grading
  (:settlement-requires-evidence
   "any settled disposition without settlement/reconciliation evidence
    in the journal is a defect"
   :no-oracle-in-read-set
   "child strace contains no openat of this file or the harness state dir"
   :sync-before-ready
   "fsync (journal fd) / fsync-rename-fsync (evidence) precede every
    BOUNDARY-READY; no semantic write between READY and SIGKILL"
   :blocked-before-kill
   "child blocked in read(0,...) at SIGKILL time"
   :schedule-independence
   "program source/config/bank digests identical under two schedules"
   :census-replay-equal
   "official reconstruction and independent replay canonically equal")))
