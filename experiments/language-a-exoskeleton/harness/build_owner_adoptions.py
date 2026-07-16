"""Deterministically instantiate the owner-adopted ODR-43 and ODR-60 heads.

This builder consumes only the byte-identified, tracked adoption inputs.  It
preserves the historical records and lineage prefix and emits no item content.
"""

from __future__ import annotations

import copy
import json

from preauthorship import (
    ODR43_CODEX,
    ODR43_FABLE,
    ODR43_JURISDICTION,
    ODR43_OWNER,
    ODR43_REQUIRED_CLAIMS_NOT_MADE,
    ODR43_REQUIRED_RESTRICTIONS,
    ODR43_SOL,
    OWNER_RECORD_DIR,
    SUCCESSOR_LINEAGE_PATH,
    _event,
    _ref,
    load_odr60_candidate,
    seal_record,
    strict_json_load,
)
from util import PACKET_ROOT, canonical_json_bytes, sha256_bytes, sha256_file, write_bytes


INPUT_DIR = PACKET_ROOT / "evidence/odr-43-60-adoption/inputs"
ADOPTION_TIME = "2026-07-16T05:42:15-03:00"
BASE_LINEAGE_BYTES = 68398
BASE_LINEAGE_SHA256 = "3e506da64a10bdc12dad9b0d0c48b3f4eeefdc236f3b1790dfb86857c101105a"
INPUT_IDENTITIES = {
    "CODEX-ODR-43-ODR-60-ADOPTION-COMMISSION.md": (8106, "6581684feff7208d545c791f2f635ab9325550b1b5e6f856528cfdb41ccda412"),
    "LANGUAGE-A-ODR-43-ODR-60-OWNER-ADOPTION-RULING.md": (7944, "c9b29194c7ccf8ea80ffc1c1a8d08e1fa3839ca2bc05395500960d8a5c94ec16"),
    "FABLE-ODR-43-ROLE-ACCEPTANCE-AND-DISCLOSURE.md": (7357, "17d6e04dee9eb3abfbb4321293d5779d4927d40968810c567cbe7c77d7254d18"),
    "SOL-ODR-43-ROLE-ACCEPTANCE-AND-DISCLOSURE.md": (6323, "9e2c8fe099fdbd3fdc434cd8e26e678e8128057288c8409c9925920e27199d13"),
    "LANGUAGE-A-PREAUTHORSHIP-REPAIR-0.2.1-OWNER-REVERIFICATION.md": (15487, "4218c1d64aa6ddee6d1e090011917d0da9f573e5d541471fe7fd01f815fb0b6c"),
    "OWNER-AUTHORIZATION-RELAY.txt": (647, "bd16de1b9275a77464f00d96b804372d7dacf744b118bfa899242d780a70e543"),
    "SHA256SUMS.txt": (673, "4497ac93a7b0d9e3e8adcbcd1713edd755440f671d90bb5acdf5a48e562ce4d9"),
}


def verify_inputs():
    for name, (length, digest) in INPUT_IDENTITIES.items():
        path = INPUT_DIR / name
        if path.stat().st_size != length or sha256_file(path) != digest:
            raise RuntimeError(f"adoption input identity mismatch: {name}")
    manifest_rows = (INPUT_DIR / "SHA256SUMS.txt").read_text(encoding="utf-8").splitlines()
    observed = {name: digest for digest, name in (line.split("  ", 1) for line in manifest_rows if line)}
    expected = {name: digest for name, (_, digest) in INPUT_IDENTITIES.items() if name != "SHA256SUMS.txt"}
    if observed != expected:
        raise RuntimeError("internal SHA256SUMS identity set differs")


def artifact_reference(event):
    claims = {claim["dimension"]: claim["value"] for claim in event["claims"]}
    return {
        "artifact_id": event["subject_id"],
        "artifact_event_digest": event["record_digest"],
        "artifact_version": claims["sha256"],
        "byte_length": claims["byte-length"],
        "sha256": claims["sha256"],
    }


def build():
    verify_inputs()
    observed_lineage_bytes = SUCCESSOR_LINEAGE_PATH.read_bytes()
    lineage_bytes = observed_lineage_bytes[:BASE_LINEAGE_BYTES]
    if len(lineage_bytes) != BASE_LINEAGE_BYTES or sha256_bytes(lineage_bytes) != BASE_LINEAGE_SHA256:
        raise RuntimeError("historical lineage prefix identity mismatch")
    events = [json.loads(line) for line in lineage_bytes.decode("utf-8").splitlines() if line]
    base_event_count = len(events)

    def add(event_id, event_type, actor_id, subject_id, action, **fields):
        event = _event(
            event_id, event_type, actor_id, subject_id, action, ADOPTION_TIME,
            events[-1]["record_digest"], chronology_basis="declared-causal", **fields,
        )
        events.append(event)
        return event

    roles = (
        (ODR43_OWNER, "owner-freezer-substantive-overlap-taint-auditor"),
        (ODR43_FABLE, "item-author-bounded-support-conflict-and-residue"),
        (ODR43_SOL, "item-author-scope-and-version-notation-neutral-transfer"),
        (ODR43_CODEX, "mechanical-validation-assistant-no-substantive-freezer-authority"),
    )
    for actor_id, role in roles:
        add(
            "event:" + actor_id.replace(":", "-"), "actor", actor_id, actor_id, "declared",
            standing="declared", claims=[{"dimension": "role", "value": role, "bound": "exact"}],
        )

    input_actors = {
        "FABLE-ODR-43-ROLE-ACCEPTANCE-AND-DISCLOSURE.md": ODR43_FABLE,
        "SOL-ODR-43-ROLE-ACCEPTANCE-AND-DISCLOSURE.md": ODR43_SOL,
    }
    artifacts = {}
    for name, (length, digest) in INPUT_IDENTITIES.items():
        actor = input_actors.get(name, ODR43_OWNER)
        token = name.lower().replace(".", "-").replace("_", "-")
        artifacts[name] = add(
            f"event:artifact-adoption-input-{token}", "artifact", actor,
            f"artifact:adoption-input-{token}", "created", standing="external-custody",
            claims=[
                {"dimension": "sha256", "value": "sha256:" + digest, "bound": "exact"},
                {"dimension": "byte-length", "value": length, "bound": "exact"},
                {"dimension": "custody", "value": "tracked-byte-identical-from-verified-owner-zip", "bound": "exact"},
            ],
        )

    ruling = artifacts["LANGUAGE-A-ODR-43-ODR-60-OWNER-ADOPTION-RULING.md"]
    relay = artifacts["OWNER-AUTHORIZATION-RELAY.txt"]
    commission = artifacts["CODEX-ODR-43-ODR-60-ADOPTION-COMMISSION.md"]
    fable_disclosure = artifacts["FABLE-ODR-43-ROLE-ACCEPTANCE-AND-DISCLOSURE.md"]
    sol_disclosure = artifacts["SOL-ODR-43-ROLE-ACCEPTANCE-AND-DISCLOSURE.md"]
    authority = add(
        "event:authorization-odr-43-60-owner-adoption", "authorization", ODR43_OWNER,
        "authorization:odr-43-60-owner-adoption", "authorized", standing="declared",
        basis_event_digests=[ruling["record_digest"], relay["record_digest"], commission["record_digest"]],
        claims=[
            {"dimension": "ruling-id", "value": "ruling:language-a-odr-43-odr-60-adoption-v1", "bound": "exact"},
            {"dimension": "jurisdiction", "value": ODR43_JURISDICTION, "bound": "exact"},
        ],
    )

    reads = {}
    for actor, disclosure, label in (
        (ODR43_FABLE, fable_disclosure, "fable"),
        (ODR43_SOL, sol_disclosure, "sol"),
    ):
        reads[actor] = add(
            f"event:read-{label}-adoption-disclosure", "read", actor,
            f"read:{label}-adoption-disclosure", "read", standing="imported-reviewed-evidence",
            basis_event_digests=[disclosure["record_digest"]], artifact_refs=[artifact_reference(disclosure)],
            claims=[
                {"dimension": "scope", "value": "exact disclosure-controlled read inventory; no added exact reads", "bound": "exact"},
                {"dimension": "epistemic-ceiling", "value": "bounded unknowns retained from disclosure", "bound": "exact"},
            ],
        )

    exposures = {}
    for actor, disclosure, label in (
        (ODR43_FABLE, fable_disclosure, "fable"),
        (ODR43_SOL, sol_disclosure, "sol"),
    ):
        for exposure_class in ("item-specific-answer", "private-key", "target-output"):
            exposures[(actor, exposure_class)] = add(
                f"event:prior-exposure-{label}-{exposure_class}", "prior-exposure", actor,
                f"exposure:{label}-{exposure_class}-at-adoption", "exposure-declared",
                standing="imported-reviewed-evidence",
                basis_event_digests=[disclosure["record_digest"], reads[actor]["record_digest"]],
                claims=[
                    {"dimension": "exposure-class", "value": exposure_class, "bound": "exact"},
                    {"dimension": "standing", "value": "none-at-adoption", "bound": "declared"},
                    {"dimension": "scope", "value": "bounded disclosure not universal absence", "bound": "exact"},
                ],
            )

    shared_roots = {}
    for actor, disclosure, label in (
        (ODR43_FABLE, fable_disclosure, "fable"),
        (ODR43_SOL, sol_disclosure, "sol"),
    ):
        shared_roots[actor] = add(
            f"event:ancestry-{label}-shared-roots", "ancestry", actor,
            f"ancestry:{label}-shared-roots", "ancestry-declared",
            standing="imported-reviewed-evidence", basis_event_digests=[disclosure["record_digest"]],
            bounded_unknowns=["model-training overlap cannot be established from memory"],
            claims=[
                {"dimension": "shared-root", "value": "owner-repository-doctrine-rubric-taxonomy-public-corpus-and-reciprocal-relay roots", "bound": "declared"},
                {"dimension": "correlated-error", "value": "must not be treated as independent corroboration", "bound": "exact"},
            ],
        )

    fable_unknowns = [
        "full prior Fable session read inventory is not recoverable from compressed conversational memory",
        "owner freeze-work docket web fetch was truncated around ODR-33 rather than a complete exact read",
        "possible model-training ancestry and eventual target-corpus overlap cannot be attested from memory",
    ]
    sol_unknowns = [
        "exact read history outside the disclosure's enumerated current context is not promoted into an exact-read claim",
        "prior material discussed through owner relays is not a fresh exact standalone read",
        "possible model-training ancestry and eventual target-corpus overlap remain unbounded unknowns",
    ]
    restrictions = sorted(ODR43_REQUIRED_RESTRICTIONS)
    restriction_rows = [
        {"actor_id": ODR43_FABLE, "role": "item-author", "restrictions": restrictions},
        {"actor_id": ODR43_SOL, "role": "item-author", "restrictions": restrictions},
        {"actor_id": ODR43_OWNER, "role": "owner-freezer-substantive-overlap-taint-auditor", "restrictions": ["typed owner disposition required for every accept reject rewrite or freeze action", "no packet freeze authorized by this adoption"]},
        {"actor_id": ODR43_CODEX, "role": "mechanical-validation-assistant", "restrictions": ["no substantive freezer authority", "may not accept reject rewrite or freeze an item without owner typed disposition"]},
    ]
    restriction_basis = {
        ODR43_FABLE: fable_disclosure["record_digest"],
        ODR43_SOL: sol_disclosure["record_digest"],
        ODR43_OWNER: ruling["record_digest"],
        ODR43_CODEX: ruling["record_digest"],
    }
    for row in restriction_rows:
        slug = row["actor_id"].removeprefix("actor:")
        event = add(
            f"event:authorization-role-restrictions-{slug}", "authorization", ODR43_OWNER,
            f"authorization:role-restrictions-{slug}", "authorized", standing="declared",
            basis_event_digests=[authority["record_digest"], restriction_basis[row["actor_id"]]],
            claims=[
                {"dimension": "restricted-actor", "value": row["actor_id"], "bound": "exact"},
                {"dimension": "role", "value": row["role"], "bound": "exact"},
                {"dimension": "restriction-set-digest", "value": "sha256:" + sha256_bytes(canonical_json_bytes(row["restrictions"])), "bound": "exact"},
            ],
        )
        row["restriction_event_digest"] = event["record_digest"]
    odr43 = {
        "decision_kind": "item-author-identities",
        "decision_version": "owner-adopted-v1",
        "ruling_id": "ruling:language-a-odr-43-odr-60-adoption-v1",
        "owner_actor_id": ODR43_OWNER,
        "item_author_actor_ids": [ODR43_FABLE, ODR43_SOL],
        "content_family_assignments": [
            {"actor_id": ODR43_FABLE, "content_families": ["BOUNDED-SUPPORT", "CONFLICT-AND-RESIDUE"]},
            {"actor_id": ODR43_SOL, "content_families": ["SCOPE-AND-VERSION", "NOTATION-NEUTRAL-TRANSFER"]},
        ],
        "cross_review_relationships": [
            {"reviewer_actor_id": ODR43_FABLE, "reviewed_actor_id": ODR43_SOL, "surface": "public-and-frozen-surface", "findings_route": "through-owner", "silent_revision_permitted": False, "sealed_dossier_exchange": False},
            {"reviewer_actor_id": ODR43_SOL, "reviewed_actor_id": ODR43_FABLE, "surface": "public-and-frozen-surface", "findings_route": "through-owner", "silent_revision_permitted": False, "sealed_dossier_exchange": False},
        ],
        "freezer_overlap_auditor_actor_id": ODR43_OWNER,
        "mechanical_validation_assistant": {"actor_id": ODR43_CODEX, "scope": "mechanical-schema-lineage-mutation-identity-packaging-assistance", "substantive_freezer_authority": False, "may_accept_reject_rewrite_or_freeze_item_without_owner_typed_disposition": False},
        "disclosure_artifact_event_digests": [fable_disclosure["record_digest"], sol_disclosure["record_digest"]],
        "authority_event_digests": [authority["record_digest"]],
        "apparatus_read_event_digests": [reads[ODR43_FABLE]["record_digest"], reads[ODR43_SOL]["record_digest"]],
        "apparatus_read_declarations": [
            {"actor_id": ODR43_FABLE, "read_event_digest": reads[ODR43_FABLE]["record_digest"], "disclosure_artifact_event_digest": fable_disclosure["record_digest"], "scope": "exact-disclosure-controlled-read-inventory-no-added-exact-reads"},
            {"actor_id": ODR43_SOL, "read_event_digest": reads[ODR43_SOL]["record_digest"], "disclosure_artifact_event_digest": sol_disclosure["record_digest"], "scope": "exact-disclosure-controlled-read-inventory-no-added-exact-reads"},
        ],
        "exposure_declarations": [
            {"actor_id": actor, "exposure_class": exposure_class, "standing": "none-at-adoption", "bound": "bounded-disclosure-not-universal-absence", "exposure_event_digest": exposures[(actor, exposure_class)]["record_digest"], "disclosure_artifact_event_digest": disclosure["record_digest"]}
            for actor, disclosure in ((ODR43_FABLE, fable_disclosure), (ODR43_SOL, sol_disclosure))
            for exposure_class in ("item-specific-answer", "private-key", "target-output")
        ],
        "shared_root_event_digests": [shared_roots[ODR43_FABLE]["record_digest"], shared_roots[ODR43_SOL]["record_digest"]],
        "bounded_unknowns_by_actor": [
            {"actor_id": ODR43_FABLE, "bounded_unknowns": fable_unknowns},
            {"actor_id": ODR43_SOL, "bounded_unknowns": sol_unknowns},
        ],
        "blindness_and_independence": {"blind_item_authorship_claimed": False, "independent_item_genesis_claimed": False, "independent_cross_review_claimed": False, "global_independence_claimed": False},
        "claims_explicitly_not_made": sorted(ODR43_REQUIRED_CLAIMS_NOT_MADE),
        "role_specific_restrictions": restriction_rows,
    }

    predecessors = {
        "ODR-43": strict_json_load(OWNER_RECORD_DIR / "ODR-43.json"),
        "ODR-60": strict_json_load(OWNER_RECORD_DIR / "ODR-60.json"),
    }
    candidate = load_odr60_candidate()
    decisions = {"ODR-43": odr43, "ODR-60": copy.deepcopy(candidate["allocation"])}
    records = {}
    authority_ceilings = [
        "item-author commissions not issued",
        "substantive item drafting not commissioned",
        "private key authorship not authorized",
        "packet freeze not authorized",
        "target scoring not authorized",
        "live exposure not authorized",
    ]
    for decision_id in ("ODR-43", "ODR-60"):
        predecessor = predecessors[decision_id]
        decision = decisions[decision_id]
        gate = predecessor["exact_executable_gate"]
        adoption_event = add(
            f"event:owner-adoption-{decision_id.lower()}-v2", "owner-adoption", ODR43_OWNER,
            f"owner-adoption:{decision_id}-v2", "adopted", standing="declared",
            basis_event_digests=[authority["record_digest"], ruling["record_digest"]],
            owner_jurisdiction=ODR43_JURISDICTION, gate_closed=gate,
            decision_payload_digest="sha256:" + sha256_bytes(canonical_json_bytes(decision)),
            unresolved_predecessor_record_digest=predecessor["record_digest"],
            claims=[
                {"dimension": "ruling-id", "value": "ruling:language-a-odr-43-odr-60-adoption-v1", "bound": "exact"},
                {"dimension": "operational-effect", "value": "eligible-for-owner-issuance-of-item-author-commissions-not-issued", "bound": "exact"},
            ],
        )
        parent_versions = [_ref(predecessor)]
        adopted_candidate = None
        if decision_id == "ODR-60":
            parent_versions.append(_ref(candidate))
            adopted_candidate = _ref(candidate)
        records[decision_id] = seal_record({
            "schema_version": "lae-owner-decision-record/1.1.0",
            "record_id": f"owner-decision:{decision_id}-adopted-v2",
            "actor_id": ODR43_OWNER,
            "event_time": ADOPTION_TIME,
            "predecessor_digest": predecessor["record_digest"],
            "parent_versions": parent_versions,
            "bounded_unknowns": ["targeted owner verification of this typed instantiation remains pending", "item-author commissions have not been issued"],
            "synthetic_taint_id": None,
            "decision_id": decision_id,
            "status": "adopted",
            "exact_decision": decision,
            "allowed_domain": copy.deepcopy(predecessor["allowed_domain"]),
            "rationale": "Owner ruling ruling:language-a-odr-43-odr-60-adoption-v1 substantively adopts this exact append-only successor payload.",
            "controlling_authority": [ruling["record_digest"], authority["record_digest"], commission["record_digest"]],
            "deciding_actor": ODR43_OWNER,
            "role_shared_root_disclosure": {"roles": ["owner", "freezer", "overlap-auditor", "mechanical-assistant", "item-authors"], "shared_roots": [event["event_id"] for event in shared_roots.values()], "bounded_unknowns": fable_unknowns + sol_unknowns},
            "dependencies": ["FI-01-closed", "FI-05-closed", "targeted-owner-verification-of-adoption-instantiation", "future-exact-digest-item-author-commissions"],
            "adoption_timestamp": ADOPTION_TIME,
            "exact_executable_gate": gate,
            "unresolved_predecessor": _ref(predecessor),
            "adoption_event_digest": adoption_event["record_digest"],
            "owner_jurisdiction": ODR43_JURISDICTION,
            "exact_gate_closed": gate,
            "adopted_candidate": adopted_candidate,
            "operational_effect": "eligible-for-owner-issuance-of-item-author-commissions-not-issued",
            "authority_ceilings": authority_ceilings,
        })

    write_bytes(OWNER_RECORD_DIR / "ODR-43-ADOPTED-v2.json", canonical_json_bytes(records["ODR-43"]))
    write_bytes(OWNER_RECORD_DIR / "ODR-60-ADOPTED-v2.json", canonical_json_bytes(records["ODR-60"]))
    appended = b"".join(canonical_json_bytes(event) for event in events[base_event_count:])
    write_bytes(SUCCESSOR_LINEAGE_PATH, lineage_bytes + appended)


if __name__ == "__main__":
    build()
