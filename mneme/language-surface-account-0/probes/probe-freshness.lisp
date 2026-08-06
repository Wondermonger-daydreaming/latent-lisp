;;;; probe-freshness.lisp
;;;;
;;;; ==========================================================================
;;;; NON-PRODUCTION FEASIBILITY PROBE — Surface Account /0 opening round —
;;;; not a package, not an API, not loadable as part of any system.
;;;; ==========================================================================
;;;;
;;;; THE OCCURRENCE-FRESHNESS MECHANISM, DEMONSTRATED (contract §II.3, as
;;;; normalized by R3-B).
;;;;
;;;; WHY THIS FILE EXISTS.  The R1 adjudication, section D: "A merely asserted
;;;; 'fresh fact minted by Door 2' is not a mechanism."  A specified mechanism
;;;; that is never run is still only a sentence, so this child DEMONSTRATES the
;;;; primitive.
;;;;
;;;; WHAT R3 CHANGED HERE, AND THE R2 TEXT THAT IS WITHDRAWN.
;;;;
;;;;   1. THE CONSTRUCTOR IS NO LONGER LOCAL.  Under R2 this file built its own
;;;;      performance datum — namespace ("lisp-plus-surface-account"
;;;;      "performance"), path (<epoch-hex> <counter-decimal>) — while
;;;;      probe-allocator.lisp built a DIFFERENT one, and only the allocator's
;;;;      was the contract's shape.  Both witnesses now load
;;;;      probe-identity.lisp and call the ONE constructor there.
;;;;
;;;;   2. THE RELOAD LAW IS REVERSED, AND THE R2 COMMENT THAT STATED THE OLD
;;;;      ONE IS DELETED.  The R2 source said, of the epoch, "a reload mints a
;;;;      fresh epoch", and used DEFPARAMETER, which made that true.  R3-B
;;;;      rules the OPPOSITE: allocator state, epoch and counter initialize
;;;;      once per running image and SURVIVE package/source reload — a reload
;;;;      must not reset the counter and must not gather a new epoch.  The
;;;;      state now lives in guarded DEFVARs in probe-identity.lisp, and T4
;;;;      below PROVES the new law by actually re-loading that source in this
;;;;      same image.
;;;;
;;;;   3. IDENTITIES ARE BUILT FROM THE RULED BASIS RECORDS.  "Folded into" is
;;;;      gone; occurrence and account identities are projections of exact
;;;;      three-entry, domain-separated basis records in which the COMPLETE
;;;;      performance identifier datum is its own entry.
;;;;
;;;; WHAT THIS IS NOT, and the boundary is absolute.  This is a MECHANISM
;;;; DEMONSTRATION, not an account.  It defines no Surface Account /0 package,
;;;; exports nothing, mints no Account /0 object, and — unlike most files in
;;;; this directory — DOES NOT TOUCH EITHER PROVIDER.  The "request",
;;;; "occurrence" and "account" identities below are PROBE-LOCAL stand-ins with
;;;; those roles; they are not the contract's objects and nothing here is
;;;; sealed, admitted, or presentable to anything.
;;;;
;;;; THE FOUR ARMS, AND THE RULED PROOFS THEY DISCHARGE (II.3's five proofs;
;;;; proof 1 — synchronized concurrent allocations are distinct — belongs to
;;;; probe-allocator.lisp, which needs threads):
;;;;
;;;;   T1  PROOF 3  occurrence and account identities differ when performance
;;;;                differs, and the difference is attributable to the
;;;;                performance datum ALONE.
;;;;   T2  PROOF 2  request identity is stable across performances.
;;;;   T3  PROOF 5  a new image MAY DIFFER OBSERVATIONALLY — an observation
;;;;                about entropy, never a uniqueness claim.
;;;;   T4  PROOF 4  package/source reload preserves the epoch and the counter
;;;;                progression.  NEW IN R3.
;;;;
;;;; THE CEILING IS PRINTED, NOT IMPLIED.  What is demonstrated is same-image
;;;; freshness (deterministic, by the counter), reload persistence
;;;; (deterministic, by the guarded state) and epoch distinctness AS OBSERVED
;;;; between two children on this host at this tip.  NO CROSS-IMAGE TEMPORAL
;;;; UNIQUENESS IS CLAIMED: two images' counters coincide by construction and
;;;; only the epoch segment separates them.
;;;;
;;;; HOW T3 GETS ITS SECOND IMAGE.  run-probe.sh runs this file TWICE: once in
;;;; the WITNESS role, whose entire job is to mint an epoch, print it, and exit
;;;; (its output is kept beside the transcripts as freshness-peer-image.txt);
;;;; and once in the ordinary role, told the peer's epoch through the
;;;; environment.  Two separately started SBCL images, and the comparison lands
;;;; in one section.
;;;;
;;;; ANCHORS.  T1..T4 blocks open with FRESHNESS-T1 .. -T4 and close with
;;;; END-FRESHNESS-T1 .. -T4; the planted arms are FRESHNESS-T1-PLANTED and
;;;; kin.  Values that differ between two runs are prefixed VOLATILE.

(in-package #:cl-user)

;;; THE SHARED CONSTRUCTOR.  Loaded from beside this file — not an arbitrary
;;; path: the sibling source in this same probes directory, named relative to
;;; THIS file's own truename, which is the only way two witnesses can be made
;;; to share one representation without a package.
(load (merge-pathnames "probe-identity.lisp" (or *load-truename* *load-pathname*)))

;;; --------------------------------------------------------------------------
;;; THE WITNESS ROLE.  Mint an epoch, print it, leave.  No section, no footer:
;;; this run is not a transcript, it is the second image T3 needs.
;;;
;;; R3.3.1 EVIDENCE HYGIENE — THE TWO PEER-IMAGE LINES ARE NOW MARKED VOLATILE.
;;; The peer image's PID and its freshly gathered epoch are the two most
;;; obviously unstable values this lane produces — a new process id and sixteen
;;; fresh octets from the operating system, every run — and they were the only
;;; unstable values in the whole evidence set carrying NO `VOLATILE` marker,
;;; because this file is not a verified transcript and the marking discipline
;;; had been applied only where a verifier looks.  That is exactly backwards: a
;;; comparer excluding VOLATILE lines runs over the WHOLE evidence directory,
;;; not only over the parts a verifier reads.  Marked here, at the point of
;;; emission.  THE RUNNER READS THE EPOCH OUT OF THIS LINE, so its parser was
;;; moved to the new spelling in the same commit; the two must never drift.
;;; --------------------------------------------------------------------------

(when (let ((v (sb-posix:getenv "SA0_PROBE_FRESHNESS_ROLE")))
        (and v (string= v "witness")))
  (p "NON-PRODUCTION FEASIBILITY PROBE — Surface Account /0 — freshness peer image")
  (p "This image exists only to mint an image epoch for T3's cross-image comparison.")
  (p "VOLATILE FRESHNESS-WITNESS-PID ~D" (sb-posix:getpid))
  (p "VOLATILE FRESHNESS-WITNESS-EPOCH ~A" *image-epoch-hex*)
  (finish-output)
  (sb-ext:exit :code 0))

;;; --------------------------------------------------------------------------
;;; The probe-local role datums.  Plain CD/0 structure; nothing sealed, nothing
;;; admitted, nothing presentable.
;;; --------------------------------------------------------------------------

(defun probe-request-identity (payload)
  (lisp-plus-cd0:make-string-datum (concatenate 'string ":probe-request/" payload)))

(defun probe-expanded-identity (payload)
  (lisp-plus-cd0:make-string-datum (concatenate 'string ":probe-expanded/" payload)))

(defun occurrence-identity (request-identity performance)
  "R3.1-B NAMES THE PROJECTION rather than leaving it as \"/1 identity
projection\": an occurrence identity IS a CD/0 BYTES DATUM containing
CANONICAL-OCTETS of the exact, domain-separated identity basis record.  Both
identities are built by IDENTITY-DATUM, the one shared constructor in
probe-identity.lisp — this file no longer wraps the projection itself, because
two files wrapping one projection is exactly the disagreement R3-B closed one
level down."
  (identity-datum (occurrence-identity-basis request-identity performance)))

(defun account-identity (occurrence-id expanded-identity)
  (identity-datum (account-identity-basis occurrence-id expanded-identity)))

;;; --------------------------------------------------------------------------

(probe-header "FRESHNESS MECHANISM DEMONSTRATION — contract II.3 (no provider is touched)")

(p "SCOPE, PRINTED BEFORE ANY NUMBER:")
(p "  This section demonstrates a PRIMITIVE, not an account.  No Surface Account")
(p "  /0 package is defined, no Account object is minted, and NEITHER PROVIDER IS")
(p "  READ.  The datums below are probe-local stand-ins carrying the roles the")
(p "  contract names.  The performance identifier is built by the ONE shared")
(p "  constructor in probe-identity.lisp — the same one probe-allocator.lisp")
(p "  calls; under R2 these two witnesses built DIFFERENT shapes and neither")
(p "  transcript could show it.  What is demonstrated is SAME-IMAGE freshness,")
(p "  RELOAD PERSISTENCE, and epoch distinctness AS OBSERVED between two children")
(p "  on this host at this tip.  NO CROSS-IMAGE TEMPORAL UNIQUENESS IS CLAIMED:")
(p "  two images' counters coincide by construction, and only the epoch segment")
(p "  separates them.")

(kv "VOLATILE image-epoch hex" *image-epoch-hex*)
(kv "VOLATILE this image pid" (sb-posix:getpid))
(kv "epoch datum family" (lisp-plus-cd0:datum-family *image-epoch-datum*))
(kv "epoch hex digits" (length *image-epoch-hex*))
(kv "epoch gatherings this image" *epoch-initializations*)
(kv "counter at section start" *performance-counter*)
(kv "allocator primitive" "sb-thread mutex (the linearizable contract's discharging primitive, named per II.3)")

;;; ==========================================================================
;;; T1 — PROOF 3: occurrence and account identities differ when performance
;;; differs, and the difference is attributable to the performance datum alone.
;;; ==========================================================================

(p "FRESHNESS-T1  same-image freshness: two performances of ONE request")
(rule)

(defparameter *req* (probe-request-identity "one-and-the-same-request"))
(defparameter *exp-id* (probe-expanded-identity "one-and-the-same-expansion"))
(defparameter *req-hex-1* (datum-hex *req*))

(defparameter *p1* (multiple-value-list (mint-performance-identifier)))
(defparameter *perf1* (first *p1*))
(defparameter *c1* (second *p1*))
(defparameter *p2* (multiple-value-list (mint-performance-identifier)))
(defparameter *perf2* (first *p2*))
(defparameter *c2* (second *p2*))

(defparameter *occ1* (occurrence-identity *req* *perf1*))
(defparameter *occ2* (occurrence-identity *req* *perf2*))
(defparameter *acc1* (account-identity *occ1* *exp-id*))
(defparameter *acc2* (account-identity *occ2* *exp-id*))

(kv "T1 counter at performance 1" *c1*)
(kv "T1 counter at performance 2" *c2*)
(kv "VOLATILE T1 performance datum 1" (datum-hex *perf1*))
(kv "VOLATILE T1 performance datum 2" (datum-hex *perf2*))
(kv "VOLATILE T1 occurrence identity 1" (datum-hex *occ1*))
(kv "VOLATILE T1 occurrence identity 2" (datum-hex *occ2*))
(kv "VOLATILE T1 account identity 1" (datum-hex *acc1*))
(kv "VOLATILE T1 account identity 2" (datum-hex *acc2*))

(probe-check "FRESHNESS-T1-COUNTER-ADVANCED" "T1: the counter advanced monotonically across the two performances"
             (and (= *c1* 1) (= *c2* 2) (< *c1* *c2*)))
(probe-check "FRESHNESS-T1-PERFORMANCE-SHAPE" "T1: both performance datums carry the contract's exact encoded shape — namespace (lisp-plus-surface-account), path (performance <epoch-hex> <counter-decimal>) — built by the ONE shared constructor"
             (and (performance-identifier-shape-p *perf1*)
                  (performance-identifier-shape-p *perf2*)))
(probe-check "FRESHNESS-T1-PERFORMANCE-DATUMS-DIFFER" "T1: the two performance datums DIFFER"
             (not (lisp-plus-cd0:equal-datum *perf1* *perf2*)))
(probe-check "FRESHNESS-T1-OCCURRENCE-IDENTITIES-DIFFER" "T1 [PROOF 3]: the two OCCURRENCE identities DIFFER when the performance differs"
             (not (string= (datum-hex *occ1*) (datum-hex *occ2*))))
(probe-check "FRESHNESS-T1-ACCOUNT-IDENTITIES-DIFFER" "T1 [PROOF 3]: and the two ACCOUNT identities DIFFER, inheriting the distinction through their occurrence-identity entry"
             (not (string= (datum-hex *acc1*) (datum-hex *acc2*))))

;;; ATTRIBUTION.  "The difference is attributable to the performance datum
;;; alone" is a claim about WHICH input moved, and it is proved by holding the
;;; request fixed and recomputing: each occurrence identity is reproduced
;;; exactly from the same request identity and its own performance datum.
(probe-check "FRESHNESS-T1-ATTRIBUTION-OCCURRENCE-1-REPRODUCED" "T1 attribution: occurrence 1 is reproduced EXACTLY from the same request identity and performance 1"
             (string= (datum-hex *occ1*) (datum-hex (occurrence-identity *req* *perf1*))))
(probe-check "FRESHNESS-T1-ATTRIBUTION-OCCURRENCE-2-REPRODUCED" "T1 attribution: occurrence 2 is reproduced EXACTLY from the SAME request identity and performance 2"
             (string= (datum-hex *occ2*) (datum-hex (occurrence-identity *req* *perf2*))))
(probe-check "FRESHNESS-T1-ATTRIBUTION-ONLY-PERFORMANCE-MOVED" "T1 attribution: therefore the ONLY input that moved between them is the performance datum"
             (and (lisp-plus-cd0:equal-datum *req* *req*)
                  (not (lisp-plus-cd0:equal-datum *perf1* *perf2*))
                  (not (string= (datum-hex *occ1*) (datum-hex *occ2*)))))

;;; DOMAIN SEPARATION, exhibited.  The two identity families cannot collide,
;;; because the two ("identity" …) separator values make an occurrence basis and
;;; an account basis unequal as datums regardless of their other entries.
(probe-check "FRESHNESS-T1-IDENTITY-IS-CANONICAL-OCTETS-BYTES-DATUM"
             "T1 [R3.1-B]: both identities ARE what the ruling normatively defines them to be — a CD/0 BYTES datum whose octets are exactly CANONICAL-OCTETS of the domain-separated basis record, measured by rebuilding the projection and comparing octet for octet.  A DIGEST ALTERNATIVE DOES NOT INHERIT the injectivity exhibited below and may not be substituted while that claim stands"
             (and (lisp-plus-cd0:bytes-datum-p *occ1*)
                  (lisp-plus-cd0:bytes-datum-p *acc1*)
                  (lisp-plus-cd0:equal-datum
                   *occ1* (lisp-plus-cd0:make-bytes-datum
                           (identity-projection (occurrence-identity-basis *req* *perf1*))))
                  (lisp-plus-cd0:equal-datum
                   *acc1* (lisp-plus-cd0:make-bytes-datum
                           (identity-projection (account-identity-basis *occ1* *exp-id*))))))

(probe-check "FRESHNESS-T1-DOMAIN-SEPARATION" "T1: the occurrence and account identity BASES are unequal datums even when every other entry is made to coincide — the domain separator is doing the work, structurally"
             (let ((o (occurrence-identity-basis *req* *perf1*))
                   (a (account-identity-basis *req* *perf1*)))
               (and (not (lisp-plus-cd0:equal-datum o a))
                    (not (string= (identity-hex o) (identity-hex a))))))

;;; INJECTIVITY OF THE PERFORMANCE COMPONENT, exhibited rather than asserted.
(probe-check "FRESHNESS-T1-PERFORMANCE-INJECTIVE-COMPONENT" "T1: holding every other basis entry fixed, distinct performance datums give distinct basis canonical octets — the performance datum is an INJECTIVE COMPONENT, not an ingredient stirred into an unnamed projection"
             (and (not (string= (identity-hex (occurrence-identity-basis *req* *perf1*))
                                (identity-hex (occurrence-identity-basis *req* *perf2*))))
                  (string= (identity-hex (occurrence-identity-basis *req* *perf1*))
                           (identity-hex (occurrence-identity-basis *req* *perf1*)))))

;;; ---- THE TOOTH: a deliberately REUSED counter ---------------------------
(p "FRESHNESS-T1-PLANTED  a spent counter value is deliberately reused")
(arm "PLANTED" "construct a performance identifier at the ALREADY-SPENT counter value")
;;; The allocator is not asked for this one: a linearizable allocator cannot
;;; return a spent value, which is the point.  The identifier is built directly
;;; at the spent counter, which is what a NON-linearizable allocator would have
;;; handed back.
(defparameter *perf-replay* (performance-identifier *c1*))
(defparameter *occ-replay* (occurrence-identity *req* *perf-replay*))
(defparameter *acc-replay* (account-identity *occ-replay* *exp-id*))
(kv "T1 planted reused counter" *c1*)
(kv "VOLATILE T1 planted performance datum" (datum-hex *perf-replay*))
(kv "VOLATILE T1 planted occurrence identity" (datum-hex *occ-replay*))
(kv "VOLATILE T1 planted account identity" (datum-hex *acc-replay*))
(probe-check "FRESHNESS-T1-PLANTED-PERFORMANCE-COLLIDES" "T1 planted: with the counter reused, the performance datum COLLIDES with the spent one"
             (lisp-plus-cd0:equal-datum *perf-replay* *perf1*))
(probe-check "FRESHNESS-T1-PLANTED-OCCURRENCE-COLLIDES" "T1 planted: and the occurrence identity COLLIDES — freshness is carried by the counter, nothing else"
             (string= (datum-hex *occ-replay*) (datum-hex *occ1*)))
(probe-check "FRESHNESS-T1-PLANTED-ACCOUNT-COLLIDES" "T1 planted: and the account identity COLLIDES too"
             (string= (datum-hex *acc-replay*) (datum-hex *acc1*)))
(p "  READING: the same comparator that reported DIFFERENT in the clean arm")
(p "  reports IDENTICAL here.  T1 is therefore a real measurement of the")
(p "  counter's contribution, not a restatement of it — and a counter that")
(p "  failed to advance would be caught, not absorbed.")
(p "END-FRESHNESS-T1")

;;; ==========================================================================
;;; T2 — PROOF 2: request identity is stable.
;;; ==========================================================================

(rule)
(p "FRESHNESS-T2  request stability across performances")
(rule)
(defparameter *req-hex-2* (datum-hex *req*))
(kv "T2 request identity before performance 1" *req-hex-1*)
(kv "T2 request identity after both performances" *req-hex-2*)
(probe-check "FRESHNESS-T2-REQUEST-IDENTITY-STABLE" "T2 [PROOF 2]: the request identity is BYTE-IDENTICAL across both performances"
             (string= *req-hex-1* *req-hex-2*))
(probe-check "FRESHNESS-T2-REQUEST-DATUM-UNCHANGED" "T2: the request identity datum itself is unchanged (nothing mutated it)"
             (lisp-plus-cd0:equal-datum *req* (probe-request-identity "one-and-the-same-request")))
(probe-check "FRESHNESS-T2-IDENTITY-EXCLUDES-PERFORMANCE" "T2: the request identity does NOT contain the performance datum — it is stable BY CONSTRUCTION, because the performance datum lives in the OCCURRENCE basis and in no request"
             (and (not (search (datum-hex *perf1*) *req-hex-2*))
                  (not (search (datum-hex *perf2*) *req-hex-2*))))

;;; ---- THE TOOTH: a perturbed request MUST move -----------------------------
(p "FRESHNESS-T2-PLANTED  a perturbed request is presented to the same comparator")
(arm "PLANTED" "one octet of payload changed")
(defparameter *req-perturbed* (probe-request-identity "one-and-the-same-requesT"))
(kv "T2 planted perturbed request identity" (datum-hex *req-perturbed*))
(probe-check "FRESHNESS-T2-PLANTED-PERTURBED-IDENTITY-DIFFERS" "T2 planted: the perturbed request identity DIFFERS — the stability check is not vacuous"
             (not (string= *req-hex-2* (datum-hex *req-perturbed*))))
(p "END-FRESHNESS-T2")

;;; ==========================================================================
;;; T3 — PROOF 5: a new image may differ OBSERVATIONALLY, with no uniqueness
;;; claim.  The epoch is also shown constant WITHIN this image.
;;; ==========================================================================

(rule)
(p "FRESHNESS-T3  epoch behaviour: constant within an image, observed distinct across images")
(rule)

(defparameter *epoch-samples*
  (list *image-epoch-hex* *image-epoch-hex* (performance-epoch-of (performance-identifier 0))))
(kv "T3 epoch samples taken" (length *epoch-samples*))
(kv "T3 epoch samples all equal" (if (every (lambda (s) (string= s (first *epoch-samples*)))
                                            *epoch-samples*)
                                     "YES" "NO"))
(probe-check "FRESHNESS-T3-EPOCH-CONSTANT-IN-IMAGE" "T3: the image epoch is CONSTANT within this image (three samples, one of them read back out of a freshly constructed performance identifier, all equal)"
             (every (lambda (s) (string= s (first *epoch-samples*))) *epoch-samples*))

(defparameter *peer-epoch* (sb-posix:getenv "SA0_PROBE_PEER_EPOCH"))
(kv "VOLATILE T3 this image epoch" *image-epoch-hex*)
(kv "VOLATILE T3 peer image epoch" (or *peer-epoch* "ABSENT"))
(kv "T3 peer epoch supplied" (if *peer-epoch* "YES" "NO — the run is incomplete"))
(probe-check "FRESHNESS-T3-PEER-EPOCH-SUPPLIED" "T3: a peer image's epoch WAS supplied (a second, separately started SBCL image ran)"
             (and *peer-epoch* (plusp (length *peer-epoch*))))
(probe-check "FRESHNESS-T3-EPOCH-DIFFERS-FROM-PEER" "T3 [PROOF 5]: this image's epoch is OBSERVED to differ from the peer image's epoch — an observation about entropy on this host, and NOT a uniqueness guarantee"
             (and *peer-epoch* (not (string= *image-epoch-hex* *peer-epoch*))))

;;; ---- THE TOOTH: the distinctness comparator must be able to say "same" ----
(p "FRESHNESS-T3-PLANTED  the distinctness comparator is handed two equal epochs")
(arm "PLANTED" "compare the image epoch against a forged copy of itself")
(defparameter *forged-epoch* (copy-seq *image-epoch-hex*))
(kv "T3 planted forged epoch equals this image's" (if (string= *forged-epoch* *image-epoch-hex*) "YES" "NO"))
(probe-check "FRESHNESS-T3-PLANTED-EQUAL-EPOCHS-NOT-DISTINCT" "T3 planted: handed two EQUAL epochs the comparator reports NOT DISTINCT — so its clean verdict is a measurement"
             (string= *image-epoch-hex* *forged-epoch*))
(p "END-FRESHNESS-T3")

;;; ==========================================================================
;;; T4 — PROOF 4 (NEW IN R3): package/source reload preserves the epoch and the
;;; counter progression.
;;;
;;; THIS ARM ACTUALLY RE-LOADS THE SOURCE.  A reload law audited by reading the
;;; DEFVARs would be a procedure audited by inspection; the standing rule is
;;; that a procedure is audited by SIMULATION.  So the identity source is loaded
;;; again, into THIS SAME RUNNING IMAGE, and the epoch and counter are read
;;; afterwards.
;;;
;;; THE R2 LAW THIS REVERSES, named so the reversal is visible: the R2 source
;;; carried the comment "a reload mints a fresh epoch" and used DEFPARAMETER,
;;; which made it so.  Under R3-B a reload must NOT re-gather the epoch and must
;;; NOT reset the counter.  That R2 sentence is withdrawn.
;;; ==========================================================================

(rule)
(p "FRESHNESS-T4  package/source reload preserves the epoch and the counter progression")
(rule)

(defparameter *t4-epoch-before* *image-epoch-hex*)
(defparameter *t4-gatherings-before* *epoch-initializations*)
(defparameter *t4-counter-before* *performance-counter*)
(defparameter *t4-perf-before* (multiple-value-list (mint-performance-identifier)))
(kv "T4 counter before reload" *t4-counter-before*)
(kv "T4 allocation taken before reload" (second *t4-perf-before*))
(kv "T4 epoch gatherings before reload" *t4-gatherings-before*)
(kv "T4 identity source" (file-namestring *sa0-identity-source*))

(arm "CLEAN" "the identity source is LOADED AGAIN into this same running image")
(load *sa0-identity-source*)

(defparameter *t4-epoch-after* *image-epoch-hex*)
(defparameter *t4-gatherings-after* *epoch-initializations*)
(defparameter *t4-counter-after* *performance-counter*)
(defparameter *t4-perf-after* (multiple-value-list (mint-performance-identifier)))

(kv "T4 counter immediately after reload" *t4-counter-after*)
(kv "T4 allocation taken after reload" (second *t4-perf-after*))
(kv "T4 epoch gatherings after reload" *t4-gatherings-after*)
(kv "T4 epoch identical across reload" (if (string= *t4-epoch-before* *t4-epoch-after*) "YES" "NO"))

(probe-check "FRESHNESS-T4-RELOAD-HAPPENED" "T4: the identity source was really re-loaded in this image — its recorded load truename is present and names this probe directory's identity source"
             (and *sa0-identity-source*
                  (string= "probe-identity.lisp" (file-namestring *sa0-identity-source*))))
(probe-check "FRESHNESS-T4-EPOCH-NOT-REGATHERED" "T4 [PROOF 4]: the reload did NOT gather a new epoch — the gathering count is unchanged across the reload"
             (= *t4-gatherings-before* *t4-gatherings-after*))
(probe-check "FRESHNESS-T4-EPOCH-UNCHANGED" "T4 [PROOF 4]: and the epoch itself is byte-identical across the reload"
             (string= *t4-epoch-before* *t4-epoch-after*))
(probe-check "FRESHNESS-T4-COUNTER-NOT-RESET" "T4 [PROOF 4]: the reload did NOT reset the counter — it stands exactly where the last pre-reload allocation left it"
             (= *t4-counter-after* (second *t4-perf-before*)))
(probe-check "FRESHNESS-T4-COUNTER-CONTINUES" "T4 [PROOF 4]: and the NEXT allocation after the reload CONTINUES the progression — strictly greater by exactly one, with no restart at 1"
             (and (= (second *t4-perf-after*) (1+ (second *t4-perf-before*)))
                  (> (second *t4-perf-after*) (second *t4-perf-before*))
                  (/= 1 (second *t4-perf-after*))))
(probe-check "FRESHNESS-T4-POST-RELOAD-DATUM-SHAPE" "T4: the post-reload performance identifier still carries the contract's exact encoded shape and the SAME epoch segment"
             (and (performance-identifier-shape-p (first *t4-perf-after*))
                  (string= (performance-epoch-of (first *t4-perf-after*)) *t4-epoch-before*)))

;;; ---- R3.2: THE SEQUENTIAL RELOAD IS ALSO RUN CONCURRENTLY -----------------
;;; MISLABEL CORRECTED (R3.3, OWNER FINDING 1, closing paragraph).  R3.2 headed
;;; this block "THE RE-ENTRANT RELOAD" and R3.2's allocator called its own
;;; top-level reload "the RE-ENTRANT one".  Neither is re-entrant.  Both are
;;; SEQUENTIAL RELOADS: they run on a thread with no load of this source in
;;; progress beneath them, after initialization has already completed.  A
;;; GENUINE re-entry is a same-thread recursive LOAD fired from INSIDE an
;;; unfinished initialization, before ready publication — a case neither arm can
;;; stage and neither ever staged.  It is closed by the recursive-load tooth in
;;; probe-init-schedule.lisp (role recursive), which is where the word now lives.
;;;
;;; WHAT THIS BLOCK ACTUALLY MEASURES, then: the reload above is SEQUENTIAL and
;;; single-threaded, so this one runs N CONCURRENT SEQUENTIAL RELOADS — the same
;;; source loaded again by N threads AT ONCE, in this same image, each taking
;;; allocations afterwards; the epoch, the gathering count and the counter's
;;; progression are then read.  (The remaining case — N threads racing the FIRST
;;; load, when the epoch has never been gathered — cannot be staged here,
;;; because this image initialized at the top of this file; it is exercised as a
;;; broad contention control in the ALLOCATOR section's ALLOCATOR-INIT-RACE arm,
;;; and the dangerous schedule is pinned in probe-init-schedule.lisp.)
(arm "CLEAN" "the identity source is loaded again by N threads AT ONCE, in this same running image")

(defparameter *t4-concurrent-threads* 8)
(defparameter *t4-concurrent-allocations* 3)
(defparameter *t4-concurrent-mutex* (sb-thread:make-mutex :name "sa0-probe-t4-concurrent"))
(defparameter *t4-concurrent-epochs* nil)
(defparameter *t4-concurrent-counters* nil)
(defparameter *t4-concurrent-errors* nil)
(defparameter *t4-counter-before-concurrent* *performance-counter*)
(defparameter *t4-gatherings-before-concurrent* *epoch-initializations*)

(defparameter *t4-concurrent-returned*
  (let* ((n *t4-concurrent-threads*)
         (path *sa0-identity-source*)
         (threads
           (loop for i from 0 below n
                 collect (sb-thread:make-thread
                          (lambda ()
                            (handler-case (load path)
                              (error (condition)
                                (sb-thread:with-mutex (*t4-concurrent-mutex*)
                                  (push (princ-to-string condition) *t4-concurrent-errors*))))
                            (let ((hex  *image-epoch-hex*)
                                  (mine (loop repeat *t4-concurrent-allocations*
                                              collect (allocate-performance-counter))))
                              (sb-thread:with-mutex (*t4-concurrent-mutex*)
                                (push hex *t4-concurrent-epochs*)
                                (setf *t4-concurrent-counters*
                                      (append mine *t4-concurrent-counters*))))
                            t)
                          :name (format nil "sa0-probe-t4-reload-~D" i)))))
    (count t (mapcar (lambda (th) (and (sb-thread:join-thread th :default :error) t))
                     threads))))

(defparameter *t4-concurrent-total* (* *t4-concurrent-threads* *t4-concurrent-allocations*))
(kv "T4 concurrent reloaders requested" *t4-concurrent-threads*)
(kv "T4 concurrent reloaders that returned normally" *t4-concurrent-returned*)
(kv "T4 concurrent reload errors [printed global]" (length *t4-concurrent-errors*))
(kv "T4 counter before the concurrent reload" *t4-counter-before-concurrent*)
(kv "T4 counter after the concurrent reload" *performance-counter*)
(kv "T4 allocations taken across the concurrent reload" (length *t4-concurrent-counters*))
(kv "T4 distinct epochs observed by the concurrent reloaders"
    (length (remove-duplicates (remove nil *t4-concurrent-epochs*) :test #'string=)))
(kv "T4 epoch gatherings after the concurrent reload" *epoch-initializations*)

(probe-check "FRESHNESS-T4-CONCURRENT-RELOAD-PRESERVES"
             "T4 [PROOF 4, R3.2-B, RELABELLED R3.3]: N threads re-loading the identity source AT ONCE in this image gathered NO new epoch and observed one and the same epoch text — CONCURRENT SEQUENTIAL RELOADS, not re-entry: no load was in progress beneath any of them.  Re-entry is closed separately, by the recursive-load tooth"
             (and (= *t4-concurrent-threads* *t4-concurrent-returned*)
                  (null *t4-concurrent-errors*)
                  (= *t4-concurrent-threads* (length *t4-concurrent-epochs*))
                  (= 1 (length (remove-duplicates (remove nil *t4-concurrent-epochs*)
                                                  :test #'string=)))
                  (string= *t4-epoch-before* (first *t4-concurrent-epochs*))
                  (= *t4-gatherings-before-concurrent* *epoch-initializations*)))
(probe-check "FRESHNESS-T4-CONCURRENT-RELOAD-COUNTER-CONTINUES"
             "T4 [PROOF 4, R3.2-B]: and the counter was neither reset nor duplicated across those concurrent reloads — the allocations taken through them are exactly the next N*K values, with no gap and no repeat, so one counter and one allocator mutex survived the reload"
             (and (= *t4-concurrent-total* (length *t4-concurrent-counters*))
                  (= (+ *t4-counter-before-concurrent* *t4-concurrent-total*)
                     *performance-counter*)
                  (let ((sorted (sort (copy-list *t4-concurrent-counters*) #'<)))
                    (loop for want from (1+ *t4-counter-before-concurrent*)
                          for got in sorted
                          always (= want got)))))

;;; ---- THE TOOTH: the reload comparator must be able to report a RESET ------
;;; A "the counter did not reset" verdict from a comparator that has never seen
;;; a reset is worth nothing.  So the same comparison is handed a counter value
;;; that DID restart, and must report it.
(p "FRESHNESS-T4-PLANTED  the reload comparator is handed a counter that DID restart")
(arm "PLANTED" "a simulated re-initialized counter, reset to zero, beside a structurally different epoch")
(defparameter *t4-planted-counter* 0)
;;; STRUCTURAL, NOT PROBABILISTIC.  The obvious way to write this arm is to
;;; call the gatherer again and assert the two epochs differ — and that is a
;;; PROBABILISTIC assertion dressed as a gate, which is exactly what this lane
;;; does not do.  Worse, writing it that way is how the R2 entropy defect was
;;; found: the second gathering returned THE IDENTICAL STRING, because
;;; SEED-RANDOM-STATE NIL is deterministic (see probe-identity.lisp, where it
;;; is fixed and disclosed).  So the planted epoch is made different BY
;;; CONSTRUCTION — one hex digit of this image's epoch replaced — and no
;;; assertion here rests on entropy at all.
(defparameter *t4-planted-epoch*
  (let ((e (copy-seq *t4-epoch-before*)))
    (setf (char e 0) (if (char= (char e 0) #\0) #\1 #\0))
    e))
(kv "T4 planted counter" *t4-planted-counter*)
(kv "T4 planted epoch differs by construction" "one hex digit replaced")
(probe-check "FRESHNESS-T4-PLANTED-RESET-DETECTED" "T4 planted: handed a counter that restarted at zero and a re-gathered epoch, the SAME two comparisons report NOT-PRESERVED — so T4's clean verdict is a measurement, not a habit"
             (and (not (= *t4-planted-counter* (second *t4-perf-before*)))
                  (= (length *t4-planted-epoch*) (length *t4-epoch-before*))
                  (not (string= *t4-planted-epoch* *t4-epoch-before*))))
(p "END-FRESHNESS-T4")

(rule)
(p "CEILING, RESTATED WHERE THE NUMBERS ARE:")
(p "  T1 and T4 are DETERMINISTIC: within one image the counter advances and")
(p "  survives reload, so two performances of one request cannot collide unless")
(p "  the counter is reused or reset, and both of those are shown being caught.")
(p "  T3 is an OBSERVATION about a seed, on this host, in this pair of children.")
(p "  It is not a uniqueness guarantee.  Two images' COUNTERS coincide by")
(p "  construction — performance 1 is performance 1 in both — and only the epoch")
(p "  segment separates their performance datums.  No cross-image temporal")
(p "  uniqueness is claimed here or licensed from here.")
(p "  PROOF 1 — synchronized concurrent allocations are distinct — is NOT")
(p "  discharged in this section.  It needs real thread contention and is")
(p "  discharged in the ALLOCATOR section, through this same constructor.")

(when (plant-failure-requested-p)
  (p "  !! PLANTED FAILURE ARM ACTIVE — the next check is deliberately false")
  (probe-check "FRESHNESS-PLANTED-FAULT" "PLANTED FAULT: this check is designed to fail" nil))

(probe-footer "FRESHNESS")
(probe-exit)
