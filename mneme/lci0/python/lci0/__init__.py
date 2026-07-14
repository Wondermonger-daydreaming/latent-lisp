"""Lisp+ Located Claim Identity /0 — frozen fixture implementation.

This package exposes inert identity, validation, relation, finite-policy, and
migration-fixture operations only.  It intentionally has no WarrantId, live
warrant, standing, capability, cryptographic, or production authority surface.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any

import cd0

from .adapter import FixtureAdapterFailure, PACKAGE_SHAPES, from_package_json, schema_census, to_cd0_fixture_ast
from .core import (
    CD0_BUDGET,
    apply_admissibility_floor,
    canonical_bytes,
    claim_ids_equal,
    evaluate_policy,
    failure,
    match_target as _match_target,
    project_claim_id,
    project_occurrence,
    restore_live_warrant,
    scope_relation,
    temporal_relation,
    validate_claim_id,
    validate_stable_ref as _validate_stable_ref,
    validate_warrant_target,
)
from .model import *  # re-export the deliberately closed typed value surface
from .package import definition, fixture_datum, iter_vectors


class _ObservedDict(dict):
    def __init__(self, *args, callback=None, **kwargs):
        self._callback = callback
        super().__init__(*args, **kwargs)

    def __setitem__(self, key, value):
        super().__setitem__(key, value)
        if self._callback is not None:
            self._callback(key, value)


class MutableClaim(dict):
    """Mutation-test view whose authoritative source remains an immutable datum."""

    def __init__(self, datum: cd0.Datum):
        self._lci_source_datum = datum
        self._nested_version_changed = False
        self._lci_coordinate_override = None

        def nested_changed(key, value):
            if key == "schema-version" and value != 0:
                self._nested_version_changed = True

        location = _ObservedDict()
        scope = _ObservedDict({"schema-version": 0}, callback=nested_changed)
        location["scope"] = scope
        super().__init__(
            {
                "kind": "claim-id-envelope",
                "lci-version": 0,
                "identity-policy": {},
                "claim-profile": {},
                "proposition": {},
                "location": location,
            }
        )


def make_neutral_fixture_claim() -> MutableClaim:
    return MutableClaim(fixture_datum("claim-id.file-alpha-neutral"))


def with_location_coordinate(claim: MutableClaim, coordinate: str, value: cd0.Datum) -> MutableClaim:
    result = MutableClaim(claim._lci_source_datum)
    result._lci_coordinate_override = (coordinate, value)
    return result


def make_fixture_occurrence(name: str) -> cd0.Datum:
    target = {
        "metadata:left": "claim-occurrence.alpha",
        "metadata:right": "claim-occurrence.beta-metadata-different",
    }.get(name)
    if target is None:
        raise KeyError(name)
    return fixture_datum(target)


def fixture_value(name: str):
    """Resolve named *test* fixtures; never used by semantic execution."""

    from .vector import input_payload_by_id

    mappings = {
        "scope:org": ("LCI0-SCOPE-ORG-DEPT", "right"),
        "target:broad-undeclared": ("LCI0-E5-NONMONOTONE-NARROWING", "target"),
        "target:broad-insufficient": ("LCI0-E5-COVERAGE-INSUFFICIENT", "target"),
        "claim:narrow": ("LCI0-E5-NONMONOTONE-NARROWING", "candidate-claim"),
        "claim:narrow-insufficient": ("LCI0-E5-COVERAGE-INSUFFICIENT", "candidate-claim"),
        "target:temporal-container": ("LCI0-N020", "target"),
        "claim:contained": ("LCI0-N020", "candidate-claim"),
        "placement:disagreement": ("LCI0-PLACEMENT-QUANTIFIED-DOMAIN-NEG", "claim"),
        "migration:legacy-warrant": ("LCI0-E9-INERT-PREDECESSOR", "source"),
    }
    if name == "claim:digest-collision-pair":
        payload = input_payload_by_id("LCI0-E8-DIGEST-NOT-ENVELOPE")
        return payload["left-claim-id"], payload["right-claim-id"]
    if name == "migration:fingerprint-collision":
        payload = input_payload_by_id("LCI0-P027")
        return payload["left-source"], payload["right-source"]
    vector_id, field = mappings[name]
    return input_payload_by_id(vector_id)[field]


def match_target(target: Any, candidate: Any):
    result = _match_target(target, candidate)
    if result.failure is not None:
        return result.failure
    return result


def validate_stable_ref(value: cd0.Datum):
    try:
        return _validate_stable_ref(value)
    except LCIFailure:
        raise


def mutable_alias_ref(alias: str) -> cd0.Datum:
    material = cd0.record(
        (
            (cd0.identifier(("lisp-plus", "lci", "0", "fixture", "field"), ("kind",)), cd0.identifier(("lisp-plus", "lci", "0", "fixture"), ("tag", "fixture-stable-material"))),
            (cd0.identifier(("lisp-plus", "lci", "0", "fixture", "field"), ("schema-version",)), cd0.integer(0)),
            (cd0.identifier(("lisp-plus", "lci", "0", "fixture", "field"), ("object-id",)), cd0.identifier(("lisp-plus", "lci", "0", "fixture"), ("object", "artifact", alias))),
            (cd0.identifier(("lisp-plus", "lci", "0", "fixture", "field"), ("object-version",)), cd0.integer(0)),
        )
    )
    return cd0.record(
        (
            (cd0.identifier(("lisp-plus", "lci", "0"), ("kind",)), cd0.identifier(("lisp-plus", "lci", "0", "tag"), ("stable-reference",))),
            (cd0.identifier(("lisp-plus", "lci", "0"), ("domain",)), cd0.identifier(("lisp-plus", "lci", "0", "fixture"), ("domain", "artifact"))),
            (cd0.identifier(("lisp-plus", "lci", "0"), ("scheme",)), cd0.identifier(("lisp-plus", "lci", "0", "fixture"), ("scheme", "artifact", "structural", "0"))),
            (cd0.identifier(("lisp-plus", "lci", "0"), ("material",)), material),
        )
    )


@dataclass(frozen=True, slots=True)
class InertMigrationView:
    claim_id: bytes
    inert: bool = True
    live_warrants: tuple[()] = ()


def migrate_v1(value: cd0.Datum) -> InertMigrationView:
    # The bounded grammar has already supplied an inert parsed record.  This
    # mapping performs no registry/procedure lookup and never loads legacy code.
    from .vector import _migrate

    migration_result = _migrate(value)
    claim_id = field_by_path(migration_result, "claim-id")
    return InertMigrationView(canonical_bytes(claim_id))


def __getattr__(name: str):
    if name == "NEUTRAL_CLAIM_ID_HEX":
        return definition("claim-id.file-alpha-neutral")["canonical_cd0_hex"]
    raise AttributeError(name)
