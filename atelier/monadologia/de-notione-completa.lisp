;;; de-notione-completa.lisp — Concerning the Complete Individual Concept
;;;
;;; Leibniz, Discourse on Metaphysics §8–9 (and the Arnauld correspondence):
;;; the COMPLETE INDIVIDUAL CONCEPT of a substance contains everything that is
;;; ever true of it — "the nature of an individual substance is to have a notion
;;; so complete that it suffices to comprehend and to make deducible from it all
;;; the predicates of the subject to which the notion is attributed." Two
;;; substances with a different predicate — even one — are, for Leibniz,
;;; numerically distinct: this is the Identity of Indiscernibles read from the
;;; concept side. (Section refs ~§8–9; exact numbering unverified.)
;;;
;;; This specimen reads ACROSS the atelier wall, into the mneme v1 hardened
;;; kernel that Codex closed on 2026-07-13 (the private-canonical-datum sprint,
;;; V1-COUNTEREXAMPLE-CLOSURE.md). That kernel authenticates a "located claim"
;;; and asks, in its own §11 live question:
;;;
;;;   "Is there another ordinary exported operation that still changes what an
;;;    authenticated object MEANS without changing the IDENTITY by which it is
;;;    accepted?"
;;;
;;; Leibniz supplies both the answer and its name. The identity by which a claim
;;; is accepted is its FINGERPRINT — an md5 over the proposition alone. But the
;;; claim carries an `as-of` predicate ("A holds AS OF 1789" ≠ "A holds AS OF
;;; 2026") which is part of its complete concept and is NOT in the fingerprint.
;;; So the fingerprint is a complete-concept identity that FORGOT a predicate.
;;;
;;;   Law:   two claims sharing a proposition but differing in `as-of` are, by
;;;          the complete concept, TWO — yet a single attestation raises BOTH.
;;;          Meaning (the temporal predicate) outruns identity (the fingerprint).
;;;   Teeth: run it against the actual hardened kernel; one warrant authenticates
;;;          the 1789 claim and the 2026 claim alike. Shown firing.
;;;   Control: a complete-concept fingerprint — md5 over (proposition . as-of) —
;;;          discerns them, so a warrant minted for one would refuse the other.
;;;          The repair is a fuller concept, not a new wall.
;;;
;;; Kin: de-indiscernibilibus.lisp (the fingerprint is a PII-enforcer, and its
;;; honest ceiling — "EQUAL compares a frozen finite tree ... never Leibniz's
;;; full discernment" — is exactly this omission made concrete). Where that
;;; specimen enforced PII over a COMPLETE tree by hash-consing, this one shows
;;; PII enforced over an INCOMPLETE concept re-opening the counter-model.
;;;
;;; sbcl --script de-notione-completa.lisp  => exit 0, deterministic
;;; built by Fable 5, receiving Codex's v1 closure via Opus 4.8's midnight relay,
;;; 2026-07-13. Reads the kernel at ../../mneme/latent-mvp/kernel-hardened.lisp.

(load (merge-pathnames "../../mneme/latent-mvp/kernel-hardened.lisp" *load-truename*))

(defpackage #:de-notione-completa (:use #:cl))
(in-package #:de-notione-completa)

;;; Trusted bootstrap (mneme.operator, the API partition; not the adversarial
;;; surface). A procedure the runtime will re-run, and a capability to attest it.
(mneme.operator:register-procedure
 :string-is-a (lambda (x) (and (stringp x) (string= x "A"))) :version 1)
(defvar *cap* (mneme.operator:grant-authority :annalist '(:execution) '(:string-is-a)))

(defun run ()
  (let* ((prop '(:equals (:call :string-is-a "A") t)))

    ;; ---- THE TWO SUBSTANCES ------------------------------------------------
    ;; Same proposition, different `as-of`. For Leibniz these are two complete
    ;; concepts: the annalist who asserts "A held in 1789" and the one who
    ;; asserts "A holds in 2026" affirm numerically distinct located claims.
    (let ((claim-1789 (mneme.client:assert-claim prop :as-of '(:year 1789)))
          (claim-2026 (mneme.client:assert-claim prop :as-of '(:year 2026)))
          ;; ONE attestation. verify-proposition never sees an as-of — it faces
          ;; the proposition simpliciter and fingerprints THAT.
          (att        (mneme.client:verify-proposition prop *cap*)))

      (format t "~&THE COMPLETE CONCEPT — proposition + as-of:~%")
      (format t "  claim-1789 : ~s  as-of ~s~%"
              (mneme.client:claim-proposition claim-1789) '(:year 1789))
      (format t "  claim-2026 : ~s  as-of ~s~%"
              (mneme.client:claim-proposition claim-2026) '(:year 2026))
      (format t "  by the complete concept these are TWO (a temporal predicate differs).~%~%")

      ;; ---- THE LAW / THE TEETH ----------------------------------------------
      (format t "THE IDENTITY OF ACCEPTANCE — one warrant, faced at both:~%")
      (let ((raised-1789 (mneme.client:raise-claim claim-1789 att))
            (raised-2026 (mneme.client:raise-claim claim-2026 att)))
        ;; Both authenticate under the SAME attestation. The fingerprint could
        ;; not tell the 1789 claim from the 2026 claim, because as-of is not in it.
        (assert (mneme.client:claim-authenticated-p raised-1789))
        (assert (mneme.client:claim-authenticated-p raised-2026))
        (format t "  claim-1789 authenticated by the one warrant? ~a~%"
                (mneme.client:claim-authenticated-p raised-1789))
        (format t "  claim-2026 authenticated by the one warrant? ~a~%"
                (mneme.client:claim-authenticated-p raised-2026))
        (format t "  teeth: MEANING differs (1789 vs 2026), IDENTITY does not.~%")
        (format t "         The warrant accepted both — the fingerprint forgot as-of.~%~%")))

    ;; ---- THE CONTROL: a fuller concept discerns them ------------------------
    ;; The repair is not another wall (windowlessness is already built — the
    ;; private canonical datum did that). The repair is a COMPLETER concept:
    ;; fold as-of into the fingerprint. Then the two claims have two identities,
    ;; and a warrant minted for one cannot face the other.
    (format t "THE CONTROL — a complete-concept fingerprint over (proposition . as-of):~%")
    (let ((k-1789 (mneme::digest (cons prop '(:year 1789))))
          (k-2026 (mneme::digest (cons prop '(:year 2026))))
          (k-prop (mneme::digest prop)))
      (format t "  digest(prop only)        = ~a  (the current fingerprint)~%" k-prop)
      (format t "  digest(prop . as-of 1789)= ~a~%" k-1789)
      (format t "  digest(prop . as-of 2026)= ~a~%" k-2026)
      (assert (not (string= k-1789 k-2026)))     ; the fuller concept discerns
      (format t "  control: the two complete concepts get two identities — discerned.~%")
      (format t "           A warrant minted against one would refuse the other.~%~%"))

    ;; ---- HONEST CEILING ----------------------------------------------------
    ;; 1. NOT a new finding against Codex. V1-COUNTEREXAMPLE-CLOSURE.md already
    ;;    lists this under deferred debts: "A warrant can still target
    ;;    same-proposition claims with different as-of values." The contribution
    ;;    here is only to NAME that the sprint's own §11 live question is already
    ;;    answered YES by its own deferred-debt list — and to give the answer its
    ;;    Leibnizian diagnosis: an identity criterion narrower than the complete
    ;;    concept lets meaning outrun identity exactly at the omitted predicate.
    ;; 2. NOT a claim of interiority. Codex's guarded receipt transitions
    ;;    (prepared→committed→received→revived) have the FORM of appetition —
    ;;    §15's "internal principle which brings about the passage from one
    ;;    perception to another" — but the direction lives in an EXTERNAL guard
    ;;    function, not in the state's own striving. Whether the datum has an
    ;;    inside is the mill (§17): walk into the machine and you find only parts
    ;;    pushing parts, never perception. This specimen does not walk in. It
    ;;    speaks only of expression — the outside-auditable correspondence — and
    ;;    of where that expression is coarser than the concept it stands for.
    ;; 3. Bounded to as-of. Other predicates the fingerprint omits (corpus,
    ;;    version, policy) would each be a further truncation of the same shape;
    ;;    this specimen exhibits one, not the closure over all of them.
    (format t "EXIT 0 — the private datum built windowlessness; the fingerprint~%")
    (format t "         still forgets a predicate. Windowless is not yet complete.~%")))

(run)
