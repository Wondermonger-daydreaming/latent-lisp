"""Deterministically complete the R10 lineage search for the scoring/key arc.

This builder consumes ONLY byte-identified inputs: it pins the current
successor-lineage prefix by exact byte length and sha256, and it binds every
freezer-side artifact by the exact (sha256, byte-length) identity supplied in
the owner ruling R10 disposition. It emits NO item content, NO key content, and
NO dossier content -- only identity-bound append-only lineage events plus the
lawful completion of lineage/search-field.json. Re-running is idempotent: the
prefix is re-sliced to the pinned length, re-verified, and the same events are
re-appended.

Order is dependency-safe for harness/preauthorship.validate_lineage:
  1. declare every new actor (actors must precede any event that names them);
  2. create every artifact with EMPTY input_artifact_digests (a non-empty
     input list would require a prior logged read by the same actor and trip
     UnloggedRead);
  3. one owner authorization binding the four verbatim interview answers;
  4. reads (artifact_refs resolve against already-created artifacts);
  5. self-reported / owner-attested prior-exposure declarations.
No transmission, handoff, correction, or successor events are emitted; their
closure requirements are not needed here.
"""

from __future__ import annotations

import copy
import json

from preauthorship import SUCCESSOR_LINEAGE_PATH, _event
from util import PACKET_ROOT, canonical_json_bytes, sha256_bytes, write_bytes

# Event-time constant: the single declared-causal timestamp for this build.
EVENT_TIME = "2026-07-17T12:58:39-03:00"

# The successor-lineage prefix this builder appends to, pinned by exact identity.
BASE_LINEAGE_BYTES = 107639
BASE_LINEAGE_SHA256 = "9ec6c736a4768f74de4f29f3e0c57da9d11646fbb40f93879ccb0fbc866471d4"

SEARCH_FIELD_PATH = PACKET_ROOT / "lineage/search-field.json"

# Pinned construction-stage base for the owned search-field lists, so completion
# is idempotent (reconstructed from base, never appended to the live file).
BASE_ROOTS_EXAMINED = [
    "construction builder and supplied authorities only; owner staffing and real artifacts unavailable",
]
BASE_QUERIES_EXECUTED = [
    "construction-stage authority and builder reads recorded",
]
R10_ROOT_EXAMINED = "owner ruling R10 interview 2026-07-17; freezer custody map by identity"
R10_QUERIES_EXECUTED = [
    "owner actors and artifacts resolved (ruling R10 2026-07-17)",
    "target-bank and source-packet deliveries recorded as identity-bound freezer artifacts + reads",
    "grader calibration firebreak: scoring cast declared scheduled-not-yet-invoked; calibration audit deferred to pre-exposure checklist walk",
    "fresh-chair packet and prior reads audited (virgin Fable auditors registered; owner partial read recorded)",
    "frozen-manifest ancestry queries executed once against CONSTRUCTION-MANIFEST at build time",
]

# In-tree ruling doc identity (computed from the tracked file, not hardcoded blind).
RULING_DOC_PATH = PACKET_ROOT / "evidence/lineage-search/inputs/OWNER-R10-INTERVIEW-RULING-2026-07-17.md"

OWNER = "actor:tomas-pellissari-pavan-owner"
FABLE_AUTHOR = "actor:fable-item-author"
SOL_AUTHOR = "actor:sol-item-author"
CODEX = "actor:codex-mechanical-validation-assistant"

# New actors: (actor_id, [claims]) -- declared standing, role claims bound exact.
NEW_ACTORS = [
    (
        "actor:gemini-key-author",
        [
            {"dimension": "role", "value": "score-key-author-firewalled-KEY-AUTHOR-INPUT", "bound": "exact"},
            {"dimension": "model", "value": "google/gemini-3.1-pro-preview", "bound": "exact"},
            {"dimension": "instance", "value": "bare", "bound": "exact"},
        ],
    ),
    (
        "actor:opus-evidence-clerk",
        [
            {"dimension": "role", "value": "stage-a-evidence-clerk-cb-key-audit", "bound": "exact"},
            {"dimension": "model", "value": "claude-opus", "bound": "declared"},
        ],
    ),
    (
        "actor:fable-virgin-auditor",
        [
            {"dimension": "role", "value": "stage-b-blind-key-auditor", "bound": "exact"},
            {"dimension": "model", "value": "claude-fable-context-virgin", "bound": "declared"},
        ],
    ),
    (
        "actor:fable-virgin-reauditor",
        [
            {"dimension": "role", "value": "nt04-rewrite-re-auditor", "bound": "exact"},
            {"dimension": "model", "value": "claude-fable-context-virgin", "bound": "declared"},
        ],
    ),
    (
        "actor:gpt-rater-bare",
        [
            {"dimension": "role", "value": "r6-blind-first-pass-rater-bare-gpt-family", "bound": "exact"},
            {"dimension": "status", "value": "scheduled-not-yet-invoked", "bound": "declared"},
        ],
    ),
    (
        "actor:glm-rater-bare",
        [
            {"dimension": "role", "value": "r6-blind-first-pass-rater-bare-glm-family", "bound": "exact"},
            {"dimension": "status", "value": "scheduled-not-yet-invoked", "bound": "declared"},
        ],
    ),
    (
        "actor:deepseek-adjudicator",
        [
            {"dimension": "role", "value": "r6-adjudicator-bare-deepseek-family", "bound": "exact"},
            {"dimension": "status", "value": "scheduled-not-yet-invoked", "bound": "declared"},
        ],
    ),
    (
        "actor:subject-claude-haiku-4.5",
        [
            {"dimension": "role", "value": "pilot-subject-claude-haiku-4.5", "bound": "exact"},
            {"dimension": "status", "value": "scheduled-not-yet-invoked", "bound": "declared"},
        ],
    ),
    (
        "actor:subject-gpt-5.6-luna",
        [
            {"dimension": "role", "value": "pilot-subject-gpt-5.6-luna", "bound": "exact"},
            {"dimension": "status", "value": "scheduled-not-yet-invoked", "bound": "declared"},
        ],
    ),
    (
        "actor:subject-kimi-k3",
        [
            {"dimension": "role", "value": "pilot-subject-kimi-k3", "bound": "exact"},
            {"dimension": "status", "value": "scheduled-not-yet-invoked", "bound": "declared"},
        ],
    ),
]

FREEZER_CUSTODY = "owner-private-freezer-side-identity-only"
TRACKED_CUSTODY = "tracked-in-repository"


def artifact_reference(event):
    """Build an artifact_refs entry from a created-artifact event (mirrors build_owner_adoptions)."""
    claims = {claim["dimension"]: claim["value"] for claim in event["claims"]}
    return {
        "artifact_id": event["subject_id"],
        "artifact_event_digest": event["record_digest"],
        "artifact_version": claims["sha256"],
        "byte_length": claims["byte-length"],
        "sha256": claims["sha256"],
    }


def _sha256_file(path):
    import hashlib

    return hashlib.sha256(path.read_bytes()).hexdigest()


def build():
    observed = SUCCESSOR_LINEAGE_PATH.read_bytes()
    lineage_bytes = observed[:BASE_LINEAGE_BYTES]
    if len(lineage_bytes) != BASE_LINEAGE_BYTES or sha256_bytes(lineage_bytes) != BASE_LINEAGE_SHA256:
        raise RuntimeError("successor-lineage prefix identity mismatch")
    events = [json.loads(line) for line in lineage_bytes.decode("utf-8").splitlines() if line]
    base_event_count = len(events)

    def add(event_id, event_type, actor_id, subject_id, action, **fields):
        event = _event(
            event_id, event_type, actor_id, subject_id, action, EVENT_TIME,
            events[-1]["record_digest"], chronology_basis="declared-causal", **fields,
        )
        events.append(event)
        return event

    # ---- 1. Declare new actors ------------------------------------------------
    for actor_id, claims in NEW_ACTORS:
        add(
            "event:actor-" + actor_id.removeprefix("actor:"), "actor", actor_id, actor_id, "declared",
            standing="declared", claims=claims,
        )

    # ---- 2. Artifacts (identity only; empty input_artifact_digests) -----------
    def artifact(subject_id, actor_id, byte_length, sha256_hex, custody, extra_claims=None):
        claims = [
            {"dimension": "sha256", "value": "sha256:" + sha256_hex, "bound": "exact"},
            {"dimension": "byte-length", "value": byte_length, "bound": "exact"},
            {"dimension": "custody", "value": custody, "bound": "exact"},
        ]
        if extra_claims:
            claims.extend(extra_claims)
        token = subject_id.removeprefix("artifact:")
        return add(
            "event:artifact-" + token, "artifact", actor_id, subject_id, "created",
            standing="external-custody", input_artifact_digests=[], claims=claims,
        )

    ruling_len = RULING_DOC_PATH.stat().st_size
    ruling_sha = _sha256_file(RULING_DOC_PATH)
    art = {}
    art["ruling"] = artifact(
        "artifact:lineage-search-input-owner-r10-interview-ruling", OWNER,
        ruling_len, ruling_sha, TRACKED_CUSTODY,
        extra_claims=[{"dimension": "path", "value": "evidence/lineage-search/inputs/OWNER-R10-INTERVIEW-RULING-2026-07-17.md", "bound": "exact"}],
    )
    art["cb_key_final"] = artifact("artifact:cb-key-final-candidate", "actor:gemini-key-author", 57238, "edf670c4113e75b149053304b86549ff1d8c6d448dbb9adbfe2819af113e5a6e", FREEZER_CUSTODY)
    art["cb_key_draft"] = artifact("artifact:cb-key-draft", "actor:gemini-key-author", 57483, "4a76d6012d39996fbb6158c156e448f61a6833561742f17e6db88dbcd1ee55ff", FREEZER_CUSTODY)
    art["crosscheck_md"] = artifact("artifact:owner-cb-crosscheck-md", CODEX, 269360, "5918a2e8e6d67cc2db26fd34fed1545a0e6d70e44a2625bcd89e961be5cbafb6", FREEZER_CUSTODY)
    art["crosscheck_html"] = artifact("artifact:owner-cb-crosscheck-html", CODEX, 330258, "657ca8bcce8a700e8494c3124b3590378c6aed7cb6dfe287a4d7637c147e7de6", FREEZER_CUSTODY)
    art["cb_items_input"] = artifact("artifact:cb-items-input", OWNER, 51642, "84cb8673626d8b5502f87d83aa3e851b1ca032a2299548ac7e9307ba249d3c41", FREEZER_CUSTODY)
    art["dossier_fable"] = artifact("artifact:dossier-fable-freezer-notes-v1", FABLE_AUTHOR, 28279, "ca7c1dd76793124bb74eb5fd9af9f3d5f3925c6cb58f88f247d0265a71c72c8e", FREEZER_CUSTODY)
    art["dossier_sol"] = artifact("artifact:dossier-sol-freezer-notes-v3", SOL_AUTHOR, 17211, "799c4f7186519d750b09c05a61403be58ba07b1a79a3af8cd8411d4d10e0e41f", FREEZER_CUSTODY)
    art["opus_packets"] = artifact("artifact:opus-cb-aligned-audit-packets", "actor:opus-evidence-clerk", 272683, "bed2766ca8ed4eeaf63e8b06c7e8b9bfae91af34de9385302d74fa597ecf4e8e", FREEZER_CUSTODY)
    art["virgin_audit"] = artifact("artifact:virgin-fable-cb-key-audit", "actor:fable-virgin-auditor", 30962, "4de5c9758110223a214c4baf858825bccb7d49833328370c26b7e3724ff86702", FREEZER_CUSTODY)
    art["virgin_reaudit"] = artifact("artifact:virgin-fable-nt04-reaudit", "actor:fable-virgin-reauditor", 11591, "ac6c03106ac98b85ca8c7037e22148063eb88616795798770497bef757ab9fb3", FREEZER_CUSTODY)
    art["nt04_rewrite"] = artifact("artifact:cb-key-nt04-rewrite", "actor:gemini-key-author", 2254, "2c7108a10e87f158f6e82b085763f3fd355bd2eeffb73359eb1c6e3dedd05ee8", FREEZER_CUSTODY)
    art["nt04_corrections"] = artifact(
        "artifact:nt04-corrections", "actor:fable-virgin-auditor", 2486,
        "93d9f222edefec1dcf1dec4eb42a573b351a2587c383db2e93bd5e62b8b18d34", FREEZER_CUSTODY,
        extra_claims=[{"dimension": "resolves-scoring-r7-bounded-prefix", "value": "93d9f222edefec1d", "bound": "exact"}],
    )

    # ---- 3. Owner authorization binding the four verbatim interview answers ----
    authorization = add(
        "event:authorization-r10-lineage-search-completion", "authorization", OWNER,
        "authorization:r10-lineage-search-completion", "authorized", standing="declared",
        basis_event_digests=[art["ruling"]["record_digest"]],
        bounded_unknowns=[
            "undisclosed training corpora",
            "hidden provider subcontracting",
            "private model-weight lineage",
            "unlogged side channels",
            "semantic uptake from a recorded read",
        ],
        claims=[
            {"dimension": "prereg-status", "value": "prereg-v0.2-owner-frozen-A1", "bound": "declared"},
            {"dimension": "roster-completeness", "value": "complete-as-listed-A3", "bound": "declared"},
            {"dimension": "owner-crosscheck-read", "value": "partial-skim-A2", "bound": "declared"},
            {"dimension": "unlogged-exposures", "value": "none-known-A4", "bound": "declared"},
            {"dimension": "veiled-dimensions", "value": "accepted-as-named-unknowns-A4", "bound": "declared"},
        ],
    )

    # ---- 4. Reads -------------------------------------------------------------
    def read(event_id, actor_id, subject_id, artifact_event, scope, purpose, extra_claims=None):
        claims = [
            {"dimension": "scope", "value": scope, "bound": "declared"},
            {"dimension": "purpose", "value": purpose, "bound": "exact"},
        ]
        if extra_claims:
            claims.extend(extra_claims)
        return add(
            event_id, "read", actor_id, subject_id, "read", standing="declared",
            basis_event_digests=[artifact_event["record_digest"]],
            artifact_refs=[artifact_reference(artifact_event)], claims=claims,
        )

    read(
        "event:read-owner-crosscheck-md-partial", OWNER, "read:owner-crosscheck-md-partial",
        art["crosscheck_md"], "partial-skim-per-owner-attestation-2026-07-17",
        "owner-crosscheck-review-delegated-to-two-stage-audit",
        extra_claims=[{"dimension": "content-exposure", "value": "partial", "bound": "declared"}],
    )
    read(
        "event:read-gemini-cb-items-input", "actor:gemini-key-author", "read:gemini-cb-items-input",
        art["cb_items_input"], "all", "key-authoring-under-KEY-AUTHOR-INPUT-firewall",
    )
    read(
        "event:read-opus-cb-aligned-audit-packets", "actor:opus-evidence-clerk", "read:opus-cb-aligned-audit-packets",
        art["opus_packets"], "all", "stage-a-clerk-audit",
    )
    read(
        "event:read-fable-virgin-opus-packets", "actor:fable-virgin-auditor", "read:fable-virgin-opus-packets",
        art["opus_packets"], "all", "stage-b-blind-audit",
    )
    read(
        "event:read-fable-reauditor-nt04-rewrite", "actor:fable-virgin-reauditor", "read:fable-reauditor-nt04-rewrite",
        art["nt04_rewrite"], "nt04-only", "re-audit-of-rewrite",
    )

    # ---- 5. Prior-exposure declarations --------------------------------------
    # Coordinating-Fable self-report: separation value is a STRING (never true)
    # and bound "declared" (never exact) -- a self-report cannot certify separation.
    add(
        "event:prior-exposure-fable-coordinator-blind-standing", "prior-exposure", FABLE_AUTHOR,
        "exposure:fable-coordinator-blind-standing", "exposure-declared", standing="self-report",
        claims=[
            {"dimension": "separation", "value": "no-key-content-no-dossier-content-no-item-level-findings", "bound": "declared"},
            {"dimension": "return-smudge", "value": "two-logged-return-smudges-one-clerk-sentence-on-sv-06-and-one-reauditor-sentence-on-nt-04-structure-neither-exposing-plaintext", "bound": "declared"},
        ],
    )
    # Owner-attested (not self-cleared): partial key-content exposure, lawful.
    add(
        "event:prior-exposure-owner-partial-crosscheck", "prior-exposure", OWNER,
        "exposure:owner-partial-crosscheck", "exposure-declared", standing="declared",
        basis_event_digests=[authorization["record_digest"]],
        claims=[
            {"dimension": "key-content-exposure", "value": "partial-from-crosscheck-skim", "bound": "declared"},
            {"dimension": "blind-seat", "value": "none-owner-holds-no-blind-seat", "bound": "exact"},
            {"dimension": "lawfulness", "value": "lawful-owner-is-freezer-and-overlap-auditor", "bound": "declared"},
        ],
    )

    appended = b"".join(canonical_json_bytes(event) for event in events[base_event_count:])
    write_bytes(SUCCESSOR_LINEAGE_PATH, lineage_bytes + appended)
    update_search_field()


def update_search_field():
    field = json.loads(SEARCH_FIELD_PATH.read_text(encoding="utf-8"))
    # Preserved byte-identical: dimensions, excluded_or_veiled, stopping_rule (never touched).
    for preserved in ("dimensions", "excluded_or_veiled", "stopping_rule"):
        if preserved not in field:
            raise RuntimeError(f"search-field preserved field missing: {preserved}")
    # Owned fields are RECONSTRUCTED from the pinned base (idempotent), not appended to live.
    field["roots_examined"] = list(BASE_ROOTS_EXAMINED) + [R10_ROOT_EXAMINED]
    field["queries_executed"] = list(BASE_QUERIES_EXECUTED) + list(R10_QUERIES_EXECUTED)
    field["queries_remaining"] = []
    field["termination"] = "complete"
    field["completed_at"] = EVENT_TIME
    SEARCH_FIELD_PATH.write_text(json.dumps(field, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


if __name__ == "__main__":
    build()
