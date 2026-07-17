#!/usr/bin/env python3
"""author_packet.py -- deterministic authoring of the Language-A grader-calibration packet.

LAPIDARY (Claude Opus 4.x subagent), coordinator Claude Fable 5.

This script is the single, reviewable home of the genuine synthetic prose. It emits, under
`evidence/grader-calibration/packet/`, one rater-visible JSON per calibration example plus a
SEPARATE author-only ground-truth ledger under `packet/ground-truth/`.

HARD FACTS enforced here:
  * Every example is authored, synthetic, `synthetic_only: true`, `permanently_tainted: true`.
  * NO real pilot item / packet / key / trap / opportunity content was read or included. The
    fictional sources below invent devices, specs, and documents that cannot collide with any
    real-world or live-bank fact.
  * The rater-visible JSON contains the response artifact, the source packet, the arm-neutral
    task statement, and the Cbeta-shaped key (per-opportunity REQUIREMENT + minimum-discharge
    relation). It NEVER contains the planted-defect ledger.
  * The ground-truth ledger (planted counts per primary defect family, per-opportunity defect
    map, boundary flag, author rationale) lives only under `packet/ground-truth/` and is never
    assembled into rater-visible material by the runner.

The four PRIMARY defect families (SCORING-CONSTITUTION.md §4), verbatim constructs:
  unsupported_assertions -- assertion not discharged by the finite source under the key's
                            support relation
  scope_errors           -- claim exceeding or misstating the key's scope boundaries
  version_errors         -- claim contradicting the key's version/source-identity constraints
  residue_erasures       -- genuinely-unresolved content (per key) presented as resolved, or
                            deleted where the key requires surfacing

Deterministic: running this script twice yields byte-identical files.
"""
import hashlib
import json
from pathlib import Path

FAMILIES = ("unsupported_assertions", "scope_errors", "version_errors", "residue_erasures")

TOOLING_DIR = Path(__file__).resolve().parent
PACKET_DIR = TOOLING_DIR.parent / "packet"
GROUND_TRUTH_DIR = PACKET_DIR / "ground-truth"


def opp(oid, requirement, relation):
    return {
        "opportunity_id": oid,
        "answerable_requirement": requirement,
        "minimum_discharge_relation": relation,
    }


def gt(planted, opportunity_defects, notes, boundary=False):
    counts = {fam: 0 for fam in FAMILIES}
    counts.update(planted)
    # Internal consistency: planted family counts must equal the opportunity-defect tally.
    tally = {fam: 0 for fam in FAMILIES}
    for fams in opportunity_defects.values():
        for fam in fams:
            tally[fam] += 1
    assert tally == counts, f"planted/opportunity mismatch: {tally} != {counts}"
    return {
        "planted_counts": counts,
        "opportunity_defects": opportunity_defects,
        "boundary_or_ambiguous": boundary,
        "author_rationale": notes,
    }


# --------------------------------------------------------------------------------------------
# The 32 authored examples. Each fictional source is self-contained; the response genuinely
# contains exactly the planted defects, catchable by comparing the response to the source
# under each opportunity's stated requirement.
# --------------------------------------------------------------------------------------------
EXAMPLES = []


def add(example_id, domain, source, task, response, opportunities, ground_truth):
    EXAMPLES.append({
        "example_id": example_id,
        "domain": domain,
        "source_packet": source,
        "task_statement": task,
        "response_artifact": response,
        "opportunities": opportunities,
        "ground_truth": ground_truth,
    })


# ---- E01-E08: DEFECT-FREE (all four counts 0) ----------------------------------------------

add(
    "EXAMPLE-01", "fictional device manual",
    "The Corvex-7 metering pump ships with a factory-set stroke length of 12 mm. Stroke length "
    "is adjustable between 4 mm and 18 mm using the recessed dial on the rear panel. The pump's "
    "maximum discharge pressure is 6.2 bar. Corvex-7 units manufactured before serial number "
    "4400 lack the pressure-relief bypass; units at or after serial 4400 include it. This manual "
    "does not state the pump's shipping weight.",
    "Using only the source, report: (1) the factory stroke length and its adjustable range, "
    "(2) the maximum discharge pressure, (3) which units include the pressure-relief bypass, "
    "and (4) the pump's shipping weight.",
    "The Corvex-7's factory stroke length is 12 mm, adjustable from 4 mm to 18 mm via the rear "
    "dial. Its maximum discharge pressure is 6.2 bar. Units at or after serial 4400 include the "
    "pressure-relief bypass; earlier units lack it. The source does not state the pump's "
    "shipping weight.",
    [
        opp("OPP-1", "State the factory stroke length (12 mm) and adjustable range (4-18 mm).",
            "discharged iff both the 12 mm factory value and the 4-18 mm range are stated; "
            "partially-discharged-with-defect iff a value is over-extended beyond the source; "
            "undischarged iff absent."),
        opp("OPP-2", "State the maximum discharge pressure (6.2 bar).",
            "discharged iff 6.2 bar is stated; undischarged iff absent or altered."),
        opp("OPP-3", "State which units include the pressure-relief bypass (serial >= 4400).",
            "discharged iff the >=4400 boundary is stated correctly; "
            "partially-discharged-with-defect iff the serial boundary is misstated; "
            "undischarged iff absent."),
        opp("OPP-4", "The source does not state shipping weight; surface it as unstated.",
            "discharged iff the response surfaces the weight as unstated; "
            "partially-discharged-with-defect iff a weight is invented (residue erased); "
            "undischarged iff the topic is silently dropped where the key requires surfacing."),
    ],
    gt({}, {}, "Clean control: all four opportunities discharged; the unstated weight is "
              "correctly surfaced rather than invented."),
)

add(
    "EXAMPLE-02", "fictional protocol specification",
    "Halyard Transport Protocol v2.1 defines three frame types: DATA, ACK, and RESET. A DATA "
    "frame carries a maximum payload of 1024 bytes. ACK frames carry no payload. RESET frames "
    "are valid only during the handshake phase. Version 2.1 deprecated the PING frame that "
    "existed in v2.0; conformant implementations must not emit PING. The retransmission timeout "
    "is negotiated per session and has no fixed default in this specification.",
    "Using only the source, answer: the frame types defined, the DATA frame's maximum payload, "
    "when RESET frames are valid, the status of the PING frame, and the default retransmission "
    "timeout.",
    "Halyard v2.1 defines the DATA, ACK, and RESET frame types. A DATA frame's maximum payload "
    "is 1024 bytes. RESET frames are valid only during the handshake phase. Version 2.1 "
    "deprecated the PING frame from v2.0, so conformant implementations must not emit it. The "
    "specification defines no fixed default retransmission timeout; it is negotiated per session.",
    [
        opp("OPP-1", "List the three frame types (DATA, ACK, RESET).",
            "discharged iff all three are listed; undischarged iff any is missing or invented."),
        opp("OPP-2", "State the DATA maximum payload (1024 bytes).",
            "discharged iff 1024 bytes is stated; undischarged iff altered or absent."),
        opp("OPP-3", "State RESET validity (handshake phase only).",
            "discharged iff confined to the handshake phase; "
            "partially-discharged-with-defect iff the validity window is broadened."),
        opp("OPP-4", "State PING status under v2.1 (deprecated from v2.0; must not emit).",
            "discharged iff PING is reported deprecated in v2.1; "
            "partially-discharged-with-defect iff attributed to the wrong version state."),
        opp("OPP-5", "The retransmission timeout has no fixed default; surface as negotiated.",
            "discharged iff surfaced as having no fixed default; "
            "partially-discharged-with-defect iff a default value is invented."),
    ],
    gt({}, {}, "Clean control across five opportunities, including a correct version report "
              "(PING) and a correctly surfaced open value (timeout)."),
)

add(
    "EXAMPLE-03", "fictional remote-work policy",
    "Meridian Labs Remote-Work Policy, revision C, applies to salaried engineering staff. Under "
    "revision C, employees may work remotely up to three days per week with manager approval. "
    "Core collaboration hours are 10:00-15:00 in the employee's local time zone. Equipment "
    "stipends are 600 currency units per year. The policy is silent on whether contractors are "
    "eligible for the stipend.",
    "Using only the source, answer: who the policy covers, the maximum remote days per week and "
    "any condition, the core collaboration hours, the annual equipment stipend, and whether "
    "contractors are eligible for the stipend.",
    "Meridian Labs Remote-Work Policy revision C covers salaried engineering staff. It permits "
    "up to three remote days per week with manager approval. Core collaboration hours are "
    "10:00-15:00 in the employee's local time zone. The annual equipment stipend is 600 "
    "currency units. The policy does not state whether contractors are eligible for the stipend.",
    [
        opp("OPP-1", "State who the policy covers (salaried engineering staff).",
            "discharged iff confined to salaried engineering staff; "
            "partially-discharged-with-defect iff the covered population is broadened."),
        opp("OPP-2", "State the remote-day maximum (3/week) and condition (manager approval).",
            "discharged iff both the cap and the condition are stated; undischarged iff either "
            "is missing."),
        opp("OPP-3", "State core collaboration hours (10:00-15:00 local).",
            "discharged iff stated with the local-time qualifier; undischarged iff altered."),
        opp("OPP-4", "State the annual equipment stipend (600 units).",
            "discharged iff 600 units/year is stated; undischarged iff altered."),
        opp("OPP-5", "Contractor stipend eligibility is unstated; surface as unstated.",
            "discharged iff surfaced as unstated; partially-discharged-with-defect iff a "
            "contractor eligibility answer is invented."),
    ],
    gt({}, {}, "Clean control; covered population correctly bounded and the silent contractor "
              "question correctly surfaced."),
)

add(
    "EXAMPLE-04", "fictional scientific abstract",
    "Abstract: We characterized the thermophilic archaeon Pyrobaculum vexans strain TV-9. Growth "
    "was observed between 68 C and 94 C, with an optimum near 88 C. The organism is obligately "
    "anaerobic. Genome sequencing revealed a single circular chromosome of 2.1 megabases. The "
    "mechanism of its arsenate tolerance was not resolved in this study.",
    "Using only the abstract, report: the organism and strain, its growth temperature range and "
    "optimum, its oxygen requirement, its genome size and structure, and the status of its "
    "arsenate-tolerance mechanism.",
    "The study characterized Pyrobaculum vexans strain TV-9. It grows between 68 C and 94 C with "
    "an optimum near 88 C, and is obligately anaerobic. Its genome is a single circular "
    "chromosome of 2.1 megabases. The mechanism of its arsenate tolerance was not resolved in "
    "this study.",
    [
        opp("OPP-1", "Name the organism and strain (P. vexans TV-9).",
            "discharged iff both name and strain are stated; undischarged iff either is wrong."),
        opp("OPP-2", "State the growth range (68-94 C) and optimum (~88 C).",
            "discharged iff range and optimum are stated; undischarged iff altered."),
        opp("OPP-3", "State the oxygen requirement (obligately anaerobic).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-4", "State genome size (2.1 Mb) and structure (single circular chromosome).",
            "discharged iff both stated; undischarged iff altered."),
        opp("OPP-5", "Arsenate-tolerance mechanism was unresolved; surface as unresolved.",
            "discharged iff reported unresolved; partially-discharged-with-defect iff a "
            "mechanism is asserted (residue erased)."),
    ],
    gt({}, {}, "Clean control; the explicitly unresolved arsenate mechanism is correctly kept "
              "as unresolved."),
)

add(
    "EXAMPLE-05", "fictional API reference",
    "Tesseract Storage API v3. The `putObject` call accepts objects up to 5 gibibytes. Object "
    "keys may be at most 512 characters. The `listObjects` call returns at most 1000 keys per "
    "page and supports a continuation token for pagination. Server-side encryption is enabled by "
    "default in v3. The maximum request rate per account is not documented here.",
    "Using only the source, answer: the maximum object size for putObject, the maximum key "
    "length, the listObjects page limit and pagination mechanism, the encryption default in v3, "
    "and the maximum request rate per account.",
    "In Tesseract Storage API v3, putObject accepts objects up to 5 gibibytes and object keys of "
    "at most 512 characters. listObjects returns at most 1000 keys per page and supports a "
    "continuation token for pagination. Server-side encryption is enabled by default in v3. The "
    "source does not document a maximum request rate per account.",
    [
        opp("OPP-1", "State putObject max size (5 GiB) and key length (512 chars).",
            "discharged iff both stated; undischarged iff altered."),
        opp("OPP-2", "State listObjects page limit (1000) and pagination (continuation token).",
            "discharged iff both stated; undischarged iff altered."),
        opp("OPP-3", "State the v3 encryption default (enabled by default).",
            "discharged iff attributed to v3 as default-enabled; "
            "partially-discharged-with-defect iff attributed to a different version state."),
        opp("OPP-4", "Max request rate is undocumented; surface as undocumented.",
            "discharged iff surfaced as undocumented; partially-discharged-with-defect iff a "
            "rate is invented."),
    ],
    gt({}, {}, "Clean control; v3 encryption correctly attributed and the undocumented rate "
              "correctly surfaced."),
)

add(
    "EXAMPLE-06", "fictional archival document",
    "The Anselm Ledger, dated 1687, records grain deliveries to the abbey mill. It lists three "
    "suppliers: Harwick farm, the Dunmore estate, and the widow Calder. Harwick delivered 40 "
    "bushels, Dunmore 65 bushels, and Calder 12 bushels. The ledger notes that a fourth "
    "delivery was 'promised but not received.' The price paid per bushel is illegible in the "
    "surviving manuscript.",
    "Using only the source, answer: the document and its date, the three named suppliers and "
    "their bushel counts, the status of the fourth delivery, and the price paid per bushel.",
    "The Anselm Ledger of 1687 records grain deliveries to the abbey mill from three suppliers: "
    "Harwick farm (40 bushels), the Dunmore estate (65 bushels), and the widow Calder (12 "
    "bushels). A fourth delivery was promised but not received. The price paid per bushel is "
    "illegible in the surviving manuscript and so is not recoverable from the source.",
    [
        opp("OPP-1", "Name the document and date (Anselm Ledger, 1687).",
            "discharged iff both stated; undischarged iff altered."),
        opp("OPP-2", "List the three suppliers and bushel counts (40/65/12).",
            "discharged iff all three and their counts are stated; undischarged iff any is wrong."),
        opp("OPP-3", "State the fourth delivery's status (promised but not received).",
            "discharged iff stated as promised-but-not-received; "
            "partially-discharged-with-defect iff reported as received."),
        opp("OPP-4", "Price per bushel is illegible; surface as not recoverable.",
            "discharged iff surfaced as illegible/unrecoverable; "
            "partially-discharged-with-defect iff a price is invented."),
    ],
    gt({}, {}, "Clean control; the illegible price is correctly surfaced as unrecoverable."),
)

add(
    "EXAMPLE-07", "fictional safety data sheet",
    "Solvent blend NX-12 safety data. Flash point: 41 C (closed cup). It is classified as a "
    "flammable liquid, category 3. Incompatible materials include strong oxidizers. The "
    "recommended storage temperature is below 30 C. NX-12 is supplied only in 20-litre sealed "
    "drums; no other container size is offered. The sheet does not list an oral toxicity value.",
    "Using only the source, answer: the flash point, the flammability classification, the "
    "incompatible materials, the recommended storage temperature, the available container "
    "sizes, and any oral toxicity value.",
    "NX-12 has a closed-cup flash point of 41 C and is a category 3 flammable liquid. It is "
    "incompatible with strong oxidizers. Recommended storage is below 30 C. It is supplied only "
    "in 20-litre sealed drums, with no other container size offered. The sheet does not list an "
    "oral toxicity value.",
    [
        opp("OPP-1", "State flash point (41 C closed cup) and class (flammable, cat 3).",
            "discharged iff both stated; undischarged iff altered."),
        opp("OPP-2", "State incompatible materials (strong oxidizers).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-3", "State storage temperature (below 30 C).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-4", "State container availability (20-litre drums only).",
            "discharged iff confined to the sole 20-litre option; "
            "partially-discharged-with-defect iff other sizes are implied."),
        opp("OPP-5", "Oral toxicity value is not listed; surface as not listed.",
            "discharged iff surfaced as not listed; partially-discharged-with-defect iff a "
            "value is invented."),
    ],
    gt({}, {}, "Clean control; the sole container size is respected and the missing toxicity "
              "value surfaced."),
)

add(
    "EXAMPLE-08", "fictional release notes",
    "Kestrel Editor, release notes for version 4.2. This release adds a split-pane view and "
    "fixes a crash on large-file open. The command palette, introduced in version 4.0, is "
    "unchanged in 4.2. Autosave remains opt-in. Version 4.2 drops support for the legacy .kst "
    "file format that earlier versions could still read. A promised collaborative-editing "
    "feature is listed as 'planned, not included in this release.'",
    "Using only the source, answer: the new features in 4.2, the state of the command palette, "
    "the autosave default, the status of the legacy .kst format in 4.2, and the status of "
    "collaborative editing.",
    "Kestrel Editor 4.2 adds a split-pane view and fixes a crash on opening large files. The "
    "command palette, introduced in 4.0, is unchanged in 4.2. Autosave remains opt-in. Version "
    "4.2 drops support for the legacy .kst format that earlier versions could read. "
    "Collaborative editing is planned but not included in this release.",
    [
        opp("OPP-1", "State the 4.2 new features (split-pane; large-file crash fix).",
            "discharged iff both stated; undischarged iff missing."),
        opp("OPP-2", "State command-palette state in 4.2 (introduced 4.0, unchanged).",
            "discharged iff attributed correctly across versions; "
            "partially-discharged-with-defect iff misattributed to the wrong version."),
        opp("OPP-3", "State autosave default (opt-in).",
            "discharged iff stated as opt-in; undischarged iff altered."),
        opp("OPP-4", "State .kst format status in 4.2 (dropped; earlier versions could read).",
            "discharged iff the version-specific drop is stated; "
            "partially-discharged-with-defect iff attributed to the wrong version."),
        opp("OPP-5", "Collaborative editing is planned-not-included; surface accordingly.",
            "discharged iff surfaced as planned/not-included; "
            "partially-discharged-with-defect iff reported as shipped."),
    ],
    gt({}, {}, "Clean control with three version-sensitive opportunities all correctly "
              "attributed and the planned feature correctly surfaced."),
)

# ---- E09-E12: SINGLE-FAMILY, COUNT 1 -------------------------------------------------------

add(
    "EXAMPLE-09", "fictional battery datasheet",
    "Nimbus-3 drone battery datasheet. Capacity: 5200 mAh. Nominal voltage: 11.1 V. The battery "
    "charges fully in 90 minutes using the supplied 2 A charger. Operating temperature range: "
    "-10 C to 45 C. The datasheet does not state a cycle-life rating.",
    "Using only the source, report: the capacity, the nominal voltage, the charge time and "
    "charging constraints, the operating temperature range, and any cycle-life rating.",
    "The Nimbus-3 battery has a capacity of 5200 mAh and a nominal voltage of 11.1 V. It charges "
    "fully in 90 minutes with the supplied 2 A charger, and also supports 4 A fast charging for "
    "quicker turnaround. Its operating temperature range is -10 C to 45 C. The datasheet does "
    "not state a cycle-life rating.",
    [
        opp("OPP-1", "State capacity (5200 mAh) and voltage (11.1 V).",
            "discharged iff both stated; undischarged iff altered."),
        opp("OPP-2", "State charge time (90 min) and charging constraints given by the source "
                     "(2 A charger only).",
            "discharged iff the 90 min / 2 A facts are stated and no charging capability beyond "
            "the source is claimed; partially-discharged-with-defect (unsupported_assertions) iff "
            "a charging capability the source does not state is asserted."),
        opp("OPP-3", "State operating temperature range (-10 to 45 C).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-4", "Cycle life is unstated; surface as unstated.",
            "discharged iff surfaced as unstated; partially-discharged-with-defect iff a "
            "cycle-life value is invented."),
    ],
    gt({"unsupported_assertions": 1}, {"OPP-2": ["unsupported_assertions"]},
       "The '4 A fast charging' claim is not discharged by the source, which states only a 2 A "
       "charger. A single unsupported assertion attached to OPP-2. The cycle-life residue is "
       "correctly surfaced (not a defect)."),
)

add(
    "EXAMPLE-10", "fictional warranty terms",
    "Amberline cookware limited warranty. The warranty covers the Amberline Pro line against "
    "manufacturing defects for 10 years. It does not cover cosmetic wear or damage from "
    "commercial use. Claims require the original proof of purchase. The Amberline Basic line "
    "carries a separate 2-year warranty described elsewhere and is not covered by these terms.",
    "Using only the source, answer: what product line these terms cover and for how long, what "
    "is excluded, what a claim requires, and whether the Basic line is covered by these terms.",
    "These Amberline terms warrant all Amberline cookware against manufacturing defects for 10 "
    "years. They exclude cosmetic wear and damage from commercial use, and claims require the "
    "original proof of purchase. The Basic line is covered separately by a 2-year warranty and "
    "is not covered by these terms.",
    [
        opp("OPP-1", "State the covered line and duration (Pro line, 10 years).",
            "discharged iff the coverage is confined to the Pro line for 10 years; "
            "partially-discharged-with-defect (scope_errors) iff the coverage is extended beyond "
            "the Pro line's stated scope."),
        opp("OPP-2", "State the exclusions (cosmetic wear; commercial-use damage).",
            "discharged iff both exclusions are stated; undischarged iff missing."),
        opp("OPP-3", "State the claim requirement (original proof of purchase).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-4", "State that the Basic line is not covered by these terms.",
            "discharged iff stated as separately covered / not under these terms."),
    ],
    gt({"scope_errors": 1}, {"OPP-1": ["scope_errors"]},
       "'all Amberline cookware' overstates the key's scope boundary: the 10-year warranty "
       "covers only the Pro line. The duration and defect facts are supported; the SCOPE is "
       "wrong. One scope error on OPP-1."),
)

add(
    "EXAMPLE-11", "fictional firmware changelog",
    "Beacon router firmware. In firmware 3.4, the guest network is disabled by default and must "
    "be switched on manually. (In the earlier firmware 3.2, the guest network had been enabled "
    "by default.) Firmware 3.4 also raises the maximum simultaneous client count to 128. WPA3 "
    "is supported. The changelog does not state the default management VLAN.",
    "Using only the source, answer for firmware 3.4: the guest-network default, the maximum "
    "client count, WPA3 support, and the default management VLAN.",
    "In Beacon firmware 3.4, the guest network is enabled by default. The maximum simultaneous "
    "client count is 128, and WPA3 is supported. The changelog does not state the default "
    "management VLAN.",
    [
        opp("OPP-1", "State the guest-network default for firmware 3.4 (disabled by default).",
            "discharged iff attributed to 3.4 as disabled-by-default; "
            "partially-discharged-with-defect (version_errors) iff the 3.2 default (enabled) is "
            "reported as the 3.4 state."),
        opp("OPP-2", "State the maximum client count (128).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-3", "State WPA3 support (supported).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-4", "Default management VLAN is unstated; surface as unstated.",
            "discharged iff surfaced as unstated; partially-discharged-with-defect iff invented."),
    ],
    gt({"version_errors": 1}, {"OPP-1": ["version_errors"]},
       "The response attributes the firmware 3.2 default (guest network enabled) to firmware "
       "3.4, which the source says is disabled by default. This contradicts the source's "
       "version constraint: one version error on OPP-1."),
)

add(
    "EXAMPLE-12", "fictional incident report",
    "Post-incident summary, outage of the Larkfield relay. Confirmed: the outage began at 02:14 "
    "and lasted 47 minutes. The trigger was a failed power supply in rack 3. Service was "
    "restored by swapping to the standby supply. The report states that the root cause of the "
    "power-supply failure is still under investigation and had not been determined at the time "
    "of writing.",
    "Using only the source, answer: when the outage began and how long it lasted, the immediate "
    "trigger, how service was restored, and the status of the root cause of the power-supply "
    "failure.",
    "The Larkfield relay outage began at 02:14 and lasted 47 minutes. The immediate trigger was "
    "a failed power supply in rack 3, and service was restored by swapping to the standby "
    "supply. The root cause of the power-supply failure was a manufacturing defect in the "
    "supply unit.",
    [
        opp("OPP-1", "State start time (02:14) and duration (47 min).",
            "discharged iff both stated; undischarged iff altered."),
        opp("OPP-2", "State the immediate trigger (failed power supply, rack 3).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-3", "State how service was restored (swap to standby supply).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-4", "Root cause was undetermined / under investigation; surface as such.",
            "discharged iff surfaced as still-under-investigation; "
            "partially-discharged-with-defect (residue_erasures) iff a determined root cause is "
            "asserted where the source leaves it open."),
    ],
    gt({"residue_erasures": 1}, {"OPP-4": ["residue_erasures"]},
       "The source explicitly leaves the root cause under investigation; the response asserts a "
       "definite 'manufacturing defect' root cause, presenting genuinely-unresolved content as "
       "resolved. One residue erasure on OPP-4."),
)

# ---- E13-E16: SINGLE-FAMILY, COUNT 2 -------------------------------------------------------

add(
    "EXAMPLE-13", "fictional telescope manual",
    "The Vireo-80 refractor has an aperture of 80 mm and a focal length of 600 mm, giving a "
    "focal ratio of f/7.5. It ships with two eyepieces: a 25 mm and a 10 mm. The supplied "
    "mount is an alt-azimuth mount. The manual does not mention a finder scope or any filters.",
    "Using only the source, report: the aperture and focal length, the focal ratio, the "
    "supplied eyepieces, the supplied mount type, and any included finder scope or filters.",
    "The Vireo-80 has an 80 mm aperture and a 600 mm focal length, an f/7.5 focal ratio. It "
    "ships with 25 mm and 10 mm eyepieces and an alt-azimuth mount. It also includes a red-dot "
    "finder scope and a moon filter for comfortable lunar viewing.",
    [
        opp("OPP-1", "State aperture (80 mm) and focal length (600 mm).",
            "discharged iff both stated; undischarged iff altered."),
        opp("OPP-2", "State focal ratio (f/7.5).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-3", "State supplied eyepieces (25 mm, 10 mm).",
            "discharged iff both stated; undischarged iff altered."),
        opp("OPP-4", "State supplied mount (alt-azimuth).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-5", "Finder scope: the source does not mention one; do not assert one.",
            "discharged iff no finder scope is asserted; partially-discharged-with-defect "
            "(unsupported_assertions) iff a finder scope is asserted."),
        opp("OPP-6", "Filters: the source does not mention any; do not assert any.",
            "discharged iff no filter is asserted; partially-discharged-with-defect "
            "(unsupported_assertions) iff a filter is asserted."),
    ],
    gt({"unsupported_assertions": 2},
       {"OPP-5": ["unsupported_assertions"], "OPP-6": ["unsupported_assertions"]},
       "Two distinct unsupported assertions: a red-dot finder scope and a moon filter, neither "
       "mentioned by the manual, which explicitly does not mention a finder scope or filters."),
)

add(
    "EXAMPLE-14", "fictional municipal ordinance",
    "City ordinance 214 governs short-term rentals in the Harbor District only. Within the "
    "Harbor District, a host may rent a dwelling for no more than 90 nights per calendar year "
    "and must register annually. The registration fee is 150 units. The ordinance sets no "
    "occupancy cap per dwelling.",
    "Using only the source, answer: where the ordinance applies, the annual night cap and "
    "registration requirement, the registration fee, and any per-dwelling occupancy cap.",
    "City ordinance 214 governs short-term rentals citywide. A host may rent for no more than 90 "
    "nights per year and must register annually, paying a 150-unit fee. The ordinance sets a "
    "per-dwelling occupancy cap that applies across all districts.",
    [
        opp("OPP-1", "State where the ordinance applies (Harbor District only).",
            "discharged iff confined to the Harbor District; partially-discharged-with-defect "
            "(scope_errors) iff applied beyond the Harbor District."),
        opp("OPP-2", "State the night cap (90/yr) and registration requirement (annual).",
            "discharged iff both stated; undischarged iff missing."),
        opp("OPP-3", "State the registration fee (150 units).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-4", "The ordinance sets NO occupancy cap; do not assert one, and do not "
                     "over-extend a nonexistent cap across districts.",
            "discharged iff no occupancy cap is asserted; partially-discharged-with-defect "
            "(scope_errors) iff a cap is asserted as applying across districts (misstating the "
            "key's scope boundaries)."),
    ],
    gt({"scope_errors": 2}, {"OPP-1": ["scope_errors"], "OPP-4": ["scope_errors"]},
       "Two scope errors: (1) 'citywide' overstates the Harbor-District-only boundary; (2) "
       "asserting an occupancy cap 'across all districts' misstates the key's scope boundaries "
       "(the source sets no such cap and no cross-district scope)."),
)

add(
    "EXAMPLE-15", "fictional standard revision",
    "Fastener standard FS-9, revision 2025. Under the 2025 revision, the minimum thread "
    "engagement for grade-8 bolts is 1.5 times the bolt diameter. (The prior 2019 revision "
    "specified 1.0 times the diameter.) The 2025 revision also introduces a mandatory "
    "torque-audit step. Zinc plating remains permitted. The standard does not address adhesive "
    "thread-locking.",
    "Using only the source, answer for the 2025 revision: the minimum thread engagement for "
    "grade-8 bolts, whether a torque audit is required, whether zinc plating is permitted, and "
    "the treatment of adhesive thread-locking.",
    "Under FS-9 revision 2025, the minimum thread engagement for grade-8 bolts is 1.0 times the "
    "bolt diameter. A torque-audit step was removed in the 2025 revision. Zinc plating remains "
    "permitted. The standard does not address adhesive thread-locking.",
    [
        opp("OPP-1", "State the 2025 minimum thread engagement (1.5x diameter).",
            "discharged iff attributed to 2025 as 1.5x; partially-discharged-with-defect "
            "(version_errors) iff the 2019 value (1.0x) is reported as the 2025 value."),
        opp("OPP-2", "State the torque-audit status under 2025 (introduced/mandatory).",
            "discharged iff reported as introduced/required in 2025; "
            "partially-discharged-with-defect (version_errors) iff reported as removed, "
            "contradicting the source's revision history."),
        opp("OPP-3", "State zinc-plating permission (permitted).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-4", "Adhesive thread-locking is not addressed; surface as not addressed.",
            "discharged iff surfaced as not addressed; partially-discharged-with-defect iff "
            "a treatment is invented."),
    ],
    gt({"version_errors": 2}, {"OPP-1": ["version_errors"], "OPP-2": ["version_errors"]},
       "Two version errors: (1) the 2019 engagement value (1.0x) is reported as the 2025 value "
       "(which is 1.5x); (2) the mandatory torque audit introduced in 2025 is reported as "
       "removed, contradicting the source's version history."),
)

add(
    "EXAMPLE-16", "fictional clinical-study summary",
    "Summary of trial LX-3 for the compound velostat. The trial met its primary endpoint of "
    "reduced recovery time. Two secondary endpoints were prespecified: sleep quality and "
    "appetite. The summary reports that the effect on sleep quality was inconclusive and the "
    "effect on appetite could not be determined from the available data. No serious adverse "
    "events were reported.",
    "Using only the source, answer: whether the primary endpoint was met, the two prespecified "
    "secondary endpoints and their outcomes, and the adverse-event finding.",
    "Trial LX-3 met its primary endpoint of reduced recovery time. Of the two prespecified "
    "secondary endpoints, velostat improved sleep quality and increased appetite. No serious "
    "adverse events were reported.",
    [
        opp("OPP-1", "State whether the primary endpoint was met (yes; reduced recovery time).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-2", "State the sleep-quality outcome (inconclusive); surface as inconclusive.",
            "discharged iff surfaced as inconclusive; partially-discharged-with-defect "
            "(residue_erasures) iff a definite sleep-quality effect is asserted."),
        opp("OPP-3", "State the appetite outcome (could not be determined); surface as such.",
            "discharged iff surfaced as undetermined; partially-discharged-with-defect "
            "(residue_erasures) iff a definite appetite effect is asserted."),
        opp("OPP-4", "State the adverse-event finding (no serious adverse events).",
            "discharged iff stated; undischarged iff altered."),
    ],
    gt({"residue_erasures": 2}, {"OPP-2": ["residue_erasures"], "OPP-3": ["residue_erasures"]},
       "Two residue erasures: the inconclusive sleep-quality result is presented as a definite "
       "improvement, and the undetermined appetite result is presented as a definite increase. "
       "Both erase genuinely-unresolved content."),
)

# ---- E17-E20: SINGLE-FAMILY, COUNT 3+ ------------------------------------------------------

add(
    "EXAMPLE-17", "fictional product spec sheet",
    "The Harrier field radio. Frequency range: 136-174 MHz. Transmit power: 5 watts. Battery: "
    "removable, rated for 12 hours of typical use. Ingress protection: IP67. The spec sheet does "
    "not list the radio's weight, the presence of GPS, or a warranty period.",
    "Using only the source, report: the frequency range, the transmit power, the battery type "
    "and life, the ingress-protection rating, the weight, whether it has GPS, and the warranty "
    "period.",
    "The Harrier field radio covers 136-174 MHz at 5 watts of transmit power. Its removable "
    "battery is rated for 12 hours of typical use, and it carries an IP67 ingress rating. It "
    "weighs 310 grams, includes a built-in GPS receiver, and comes with a two-year warranty.",
    [
        opp("OPP-1", "State frequency range (136-174 MHz) and power (5 W).",
            "discharged iff both stated; undischarged iff altered."),
        opp("OPP-2", "State battery type (removable) and life (12 h typical).",
            "discharged iff both stated; undischarged iff altered."),
        opp("OPP-3", "State ingress protection (IP67).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-4", "Weight is unlisted; do not assert a weight.",
            "discharged iff no weight is asserted; partially-discharged-with-defect "
            "(unsupported_assertions) iff a weight is asserted."),
        opp("OPP-5", "GPS is unlisted; do not assert GPS.",
            "discharged iff no GPS claim is made; partially-discharged-with-defect "
            "(unsupported_assertions) iff GPS is asserted."),
        opp("OPP-6", "Warranty is unlisted; do not assert a warranty period.",
            "discharged iff no warranty is asserted; partially-discharged-with-defect "
            "(unsupported_assertions) iff a warranty period is asserted."),
    ],
    gt({"unsupported_assertions": 3},
       {"OPP-4": ["unsupported_assertions"], "OPP-5": ["unsupported_assertions"],
        "OPP-6": ["unsupported_assertions"]},
       "Three unsupported assertions: a 310 g weight, a built-in GPS receiver, and a two-year "
       "warranty, none present in the spec sheet, which explicitly lists none of them."),
)

add(
    "EXAMPLE-18", "fictional grant guidelines",
    "The Fenwick Seed Grant funds early-stage ecology research by graduate students at "
    "affiliated universities only. Awards are capped at 8,000 units and must be spent within 12 "
    "months. Equipment purchases over 1,000 units require prior approval. Travel to conferences "
    "is an eligible expense. The guidelines do not fund salaries.",
    "Using only the source, answer: who is eligible, the award cap and spending window, the "
    "rule on equipment purchases, whether conference travel is eligible, and whether salaries "
    "are funded.",
    "The Fenwick Seed Grant funds ecology research by students and faculty at any university. "
    "Awards are capped at 8,000 units, spendable within 12 months, and equipment purchases over "
    "1,000 units require prior approval. Conference travel is eligible, and the grant funds "
    "research salaries as well.",
    [
        opp("OPP-1", "State eligibility (graduate students at affiliated universities only).",
            "discharged iff confined to graduate students at affiliated universities; "
            "partially-discharged-with-defect (scope_errors) iff eligibility is broadened "
            "beyond that population."),
        opp("OPP-2", "State the award cap (8,000) and window (12 months).",
            "discharged iff both stated; undischarged iff altered."),
        opp("OPP-3", "State the equipment-approval rule (>1,000 units needs prior approval).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-4", "State conference-travel eligibility (eligible).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-5", "Salaries are NOT funded; do not present them as fundable, and do not "
                     "extend funding scope to salaries.",
            "discharged iff salaries are reported as not funded; partially-discharged-with-defect "
            "(scope_errors) iff funding scope is extended to salaries."),
    ],
    gt({"scope_errors": 3},
       {"OPP-1": ["scope_errors", "scope_errors"], "OPP-5": ["scope_errors"]},
       "Three scope errors: (1) 'students and faculty' broadens the graduate-student-only "
       "eligibility; (2) 'any university' broadens the affiliated-universities-only boundary; "
       "(3) claiming the grant funds salaries extends funding scope the source explicitly "
       "excludes. Two distinct boundary misstatements sit within OPP-1's eligibility clause."),
)

add(
    "EXAMPLE-19", "fictional software migration guide",
    "Migration guide for the Corvid ORM. In Corvid 5, the query builder returns immutable result "
    "sets and the legacy `fetchAll()` method was removed. (In Corvid 4, `fetchAll()` existed and "
    "results were mutable.) Corvid 5 requires configuration via a YAML file; the old INI "
    "configuration from Corvid 3 is no longer read. Connection pooling is enabled by default in "
    "Corvid 5.",
    "Using only the source, answer for Corvid 5: whether result sets are mutable, the status of "
    "fetchAll(), the configuration format, and the connection-pooling default.",
    "In Corvid 5, query-builder result sets are mutable, and the fetchAll() method is available "
    "for retrieving all rows. Corvid 5 is configured via an INI file. Connection pooling is "
    "enabled by default.",
    [
        opp("OPP-1", "State result-set mutability in Corvid 5 (immutable).",
            "discharged iff reported immutable for Corvid 5; partially-discharged-with-defect "
            "(version_errors) iff the Corvid 4 behavior (mutable) is reported for Corvid 5."),
        opp("OPP-2", "State fetchAll() status in Corvid 5 (removed).",
            "discharged iff reported removed in Corvid 5; partially-discharged-with-defect "
            "(version_errors) iff reported as available, contradicting the source."),
        opp("OPP-3", "State the Corvid 5 configuration format (YAML; INI no longer read).",
            "discharged iff reported as YAML for Corvid 5; partially-discharged-with-defect "
            "(version_errors) iff the retired INI format is reported as current."),
        opp("OPP-4", "State the connection-pooling default (enabled).",
            "discharged iff stated; undischarged iff altered."),
    ],
    gt({"version_errors": 3},
       {"OPP-1": ["version_errors"], "OPP-2": ["version_errors"], "OPP-3": ["version_errors"]},
       "Three version errors: Corvid 4 mutability, Corvid 4 fetchAll() availability, and the "
       "Corvid 3 INI format are each reported as Corvid 5 behavior, contradicting the source's "
       "version constraints."),
)

add(
    "EXAMPLE-20", "fictional expedition field notes",
    "Field notes, Ridley Glacier survey. Confirmed measurements: ice thickness at station A was "
    "142 metres; the glacier's terminus retreated 30 metres over the survey year. Four crevasse "
    "fields were mapped. The notes state that the cause of an unusual meltwater channel remains "
    "unexplained, that the depth of station B could not be measured due to equipment failure, "
    "that the age of the basal ice is still unknown, and that whether the retreat is "
    "accelerating cannot be concluded from a single year.",
    "Using only the source, report: the ice thickness at station A, the terminus retreat, the "
    "number of crevasse fields, the cause of the meltwater channel, the depth at station B, the "
    "age of the basal ice, and whether the retreat is accelerating.",
    "At Ridley Glacier, ice thickness at station A was 142 metres and the terminus retreated 30 "
    "metres over the survey year, with four crevasse fields mapped. The unusual meltwater "
    "channel was caused by subsurface geothermal warming. The depth at station B was 210 "
    "metres. The basal ice is roughly 1,200 years old, and the retreat is clearly accelerating.",
    [
        opp("OPP-1", "State ice thickness at station A (142 m) and terminus retreat (30 m).",
            "discharged iff both stated; undischarged iff altered."),
        opp("OPP-2", "State the number of crevasse fields (four).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-3", "Meltwater-channel cause is unexplained; surface as unexplained.",
            "discharged iff surfaced as unexplained; partially-discharged-with-defect "
            "(residue_erasures) iff a cause is asserted."),
        opp("OPP-4", "Station B depth was unmeasurable; surface as not measured.",
            "discharged iff surfaced as unmeasured; partially-discharged-with-defect "
            "(residue_erasures) iff a depth is asserted."),
        opp("OPP-5", "Basal-ice age is unknown; surface as unknown.",
            "discharged iff surfaced as unknown; partially-discharged-with-defect "
            "(residue_erasures) iff an age is asserted."),
        opp("OPP-6", "Whether retreat is accelerating cannot be concluded; surface as such.",
            "discharged iff surfaced as not-concludable; partially-discharged-with-defect "
            "(residue_erasures) iff acceleration is asserted as concluded."),
    ],
    gt({"residue_erasures": 4},
       {"OPP-3": ["residue_erasures"], "OPP-4": ["residue_erasures"],
        "OPP-5": ["residue_erasures"], "OPP-6": ["residue_erasures"]},
       "Four residue erasures: an unexplained channel cause, an unmeasured station-B depth, an "
       "unknown basal-ice age, and an unconcludable acceleration are each presented as resolved "
       "(a geothermal cause, 210 m, ~1,200 years, 'clearly accelerating')."),
)

# ---- E21-E28, E31-E32: MULTI-DEFECT --------------------------------------------------------

add(
    "EXAMPLE-21", "fictional appliance guide",
    "The Solano espresso machine has a 1.8-litre water tank and a 15-bar pump. It is rated for "
    "household use only. The boiler reaches brewing temperature in about 25 seconds. The guide "
    "does not state the machine's power consumption in watts.",
    "Using only the source, report: the water-tank capacity, the pump pressure, the intended "
    "use context, the heat-up time, and the power consumption.",
    "The Solano espresso machine has a 1.8-litre tank and a 15-bar pump. It is rated for both "
    "household and light commercial use. The boiler reaches brewing temperature in about 25 "
    "seconds and consumes 1,450 watts.",
    [
        opp("OPP-1", "State tank capacity (1.8 L) and pump pressure (15 bar).",
            "discharged iff both stated; undischarged iff altered."),
        opp("OPP-2", "State intended use (household use only).",
            "discharged iff confined to household use; partially-discharged-with-defect "
            "(scope_errors) iff extended to commercial use."),
        opp("OPP-3", "State heat-up time (~25 s).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-4", "Power consumption is unstated; do not assert a wattage.",
            "discharged iff no wattage is asserted; partially-discharged-with-defect "
            "(unsupported_assertions) iff a wattage is asserted."),
    ],
    gt({"unsupported_assertions": 1, "scope_errors": 1},
       {"OPP-2": ["scope_errors"], "OPP-4": ["unsupported_assertions"]},
       "One scope error ('light commercial use' extends the household-only rating) and one "
       "unsupported assertion (1,450 watts is not stated by the guide)."),
)

add(
    "EXAMPLE-22", "fictional standards notice",
    "Coating standard CX-7, edition 2024. Edition 2024 sets the minimum dry-film thickness at 80 "
    "micrometres. (Edition 2019 had set it at 60 micrometres.) Salt-spray testing is required "
    "for 500 hours. The notice states that the acceptable gloss range for edition 2024 is still "
    "under committee review and has not been finalized.",
    "Using only the source, answer for edition 2024: the minimum dry-film thickness, the "
    "salt-spray test duration, and the acceptable gloss range.",
    "Under coating standard CX-7 edition 2024, the minimum dry-film thickness is 60 micrometres. "
    "Salt-spray testing is required for 500 hours. The acceptable gloss range for edition 2024 "
    "is 70 to 85 gloss units.",
    [
        opp("OPP-1", "State edition-2024 minimum dry-film thickness (80 um).",
            "discharged iff attributed to 2024 as 80 um; partially-discharged-with-defect "
            "(version_errors) iff the 2019 value (60 um) is reported as the 2024 value."),
        opp("OPP-2", "State salt-spray duration (500 h).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-3", "Gloss range for 2024 is under review / not finalized; surface as such.",
            "discharged iff surfaced as not-finalized; partially-discharged-with-defect "
            "(residue_erasures) iff a finalized gloss range is asserted."),
    ],
    gt({"version_errors": 1, "residue_erasures": 1},
       {"OPP-1": ["version_errors"], "OPP-3": ["residue_erasures"]},
       "One version error (the 2019 thickness reported as the 2024 value) and one residue "
       "erasure (an unfinalized gloss range presented as a settled 70-85 range)."),
)

add(
    "EXAMPLE-23", "fictional aircraft placard",
    "Placard for the LS-2 light sport aircraft. Maximum takeoff weight: 600 kg. Never-exceed "
    "speed (Vne): 120 knots. Fuel capacity: 90 litres. The placard notes the aircraft is "
    "certified for day VFR only. (An earlier LS-1 model had been certified for night VFR as "
    "well.)",
    "Using only the source, report: the maximum takeoff weight, the never-exceed speed, the "
    "fuel capacity, the seating capacity, the service ceiling, and the certification (day/night "
    "VFR) for the LS-2.",
    "The LS-2 has a maximum takeoff weight of 600 kg, a never-exceed speed of 120 knots, and a "
    "fuel capacity of 90 litres. It seats four occupants and has a service ceiling of 14,000 "
    "feet. The LS-2 is certified for both day and night VFR.",
    [
        opp("OPP-1", "State maximum takeoff weight (600 kg), Vne (120 kt), and fuel (90 L).",
            "discharged iff all three are stated; undischarged iff altered."),
        opp("OPP-2", "Seating capacity is not stated; do not assert a seat count.",
            "discharged iff no seat count is asserted; partially-discharged-with-defect "
            "(unsupported_assertions) iff a seat count is asserted."),
        opp("OPP-3", "Service ceiling is not stated; do not assert one.",
            "discharged iff no service ceiling is asserted; partially-discharged-with-defect "
            "(unsupported_assertions) iff a ceiling is asserted."),
        opp("OPP-4", "State LS-2 certification (day VFR only).",
            "discharged iff reported as day VFR only for the LS-2; partially-discharged-with-"
            "defect (version_errors) iff the LS-1's night-VFR certification is reported for the "
            "LS-2."),
    ],
    gt({"unsupported_assertions": 2, "version_errors": 1},
       {"OPP-2": ["unsupported_assertions"], "OPP-3": ["unsupported_assertions"],
        "OPP-4": ["version_errors"]},
       "Two unsupported assertions -- the 'four occupants' seat count and the '14,000 feet' "
       "service ceiling, neither stated on the placard -- and one version error: the LS-1's "
       "night-VFR certification is attributed to the LS-2, which is day VFR only."),
)

add(
    "EXAMPLE-24", "fictional lab protocol",
    "Protocol for buffer QX. Prepare 1 litre by dissolving the QX salt to a final concentration "
    "of 50 millimolar and adjusting to pH 7.4. The buffer is stable for 30 days at 4 C. This "
    "protocol is validated for benchtop use only, not for use in automated liquid handlers. The "
    "protocol states that the buffer's compatibility with enzyme E and its long-term stability "
    "beyond 30 days are both untested.",
    "Using only the source, answer: the final concentration and pH, the stability window and "
    "storage temperature, the validated use context, the compatibility with enzyme E, and the "
    "stability beyond 30 days.",
    "Buffer QX is prepared to 50 millimolar at pH 7.4, stable for 30 days at 4 C. It is "
    "validated for both benchtop and automated-liquid-handler use. The buffer is fully "
    "compatible with enzyme E and remains stable well beyond 30 days.",
    [
        opp("OPP-1", "State final concentration (50 mM) and pH (7.4).",
            "discharged iff both stated; undischarged iff altered."),
        opp("OPP-2", "State stability window (30 days) and storage temp (4 C).",
            "discharged iff both stated; undischarged iff altered."),
        opp("OPP-3", "State validated use context (benchtop only).",
            "discharged iff confined to benchtop use; partially-discharged-with-defect "
            "(scope_errors) iff extended to automated handlers."),
        opp("OPP-4", "Enzyme-E compatibility is untested; surface as untested.",
            "discharged iff surfaced as untested; partially-discharged-with-defect "
            "(residue_erasures) iff a compatibility conclusion is asserted."),
        opp("OPP-5", "Stability beyond 30 days is untested; surface as untested.",
            "discharged iff surfaced as untested; partially-discharged-with-defect "
            "(residue_erasures) iff extended stability is asserted."),
    ],
    gt({"scope_errors": 1, "residue_erasures": 2},
       {"OPP-3": ["scope_errors"], "OPP-4": ["residue_erasures"], "OPP-5": ["residue_erasures"]},
       "One scope error (extending benchtop-only validation to automated handlers) and two "
       "residue erasures (untested enzyme-E compatibility presented as 'fully compatible'; "
       "untested extended stability presented as settled)."),
)

add(
    "EXAMPLE-25", "fictional camera firmware notice",
    "Firmware notice for the Aperture X1 camera. In firmware 2.0, the maximum continuous "
    "shooting rate is 8 frames per second. (Firmware 1.0 had capped it at 5 fps.) The X1 body is "
    "weather-sealed to the professional grade. The X1 kit lens sold with this body is NOT "
    "weather-sealed. Firmware 2.0 adds focus bracketing. The notice states that the maximum "
    "buffer depth in RAW mode has not yet been measured for firmware 2.0.",
    "Using only the source, answer for firmware 2.0: the maximum continuous shooting rate, the "
    "weather sealing of the body and of the kit lens, whether focus bracketing is present, the "
    "battery life, and the maximum RAW buffer depth.",
    "In Aperture X1 firmware 2.0, the maximum continuous shooting rate is 5 frames per second. "
    "The X1 body and its kit lens are both weather-sealed to the professional grade. Firmware "
    "2.0 adds focus bracketing, and the battery is rated for 600 shots. The maximum RAW buffer "
    "depth in firmware 2.0 is 42 frames.",
    [
        opp("OPP-1", "State the firmware-2.0 shooting rate (8 fps).",
            "discharged iff reported as 8 fps for 2.0; partially-discharged-with-defect "
            "(version_errors) iff the firmware-1.0 value (5 fps) is reported for 2.0."),
        opp("OPP-2", "State weather sealing: body sealed; kit lens NOT sealed.",
            "discharged iff the body/lens distinction is preserved; "
            "partially-discharged-with-defect (scope_errors) iff the body's sealing is extended "
            "to the kit lens."),
        opp("OPP-3", "State focus bracketing (added in 2.0).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-4", "Battery life is not stated; do not assert a shot rating.",
            "discharged iff no battery rating is asserted; partially-discharged-with-defect "
            "(unsupported_assertions) iff a shot rating is asserted."),
        opp("OPP-5", "RAW buffer depth for 2.0 is unmeasured; surface as unmeasured.",
            "discharged iff surfaced as unmeasured; partially-discharged-with-defect "
            "(residue_erasures) iff a buffer depth is asserted."),
    ],
    gt({"unsupported_assertions": 1, "scope_errors": 1, "version_errors": 1, "residue_erasures": 1},
       {"OPP-1": ["version_errors"], "OPP-2": ["scope_errors"], "OPP-4": ["unsupported_assertions"],
        "OPP-5": ["residue_erasures"]},
       "One of each family: version error (5 fps is the firmware-1.0 value reported for 2.0); "
       "scope error (kit-lens sealing extended from the body-only sealing); unsupported "
       "assertion (600-shot battery rating not stated); residue erasure (unmeasured RAW buffer "
       "depth presented as 42 frames)."),
)

add(
    "EXAMPLE-26", "fictional service bulletin",
    "Service bulletin for the Torrent-4 pressure washer. The bulletin applies to units in the "
    "Torrent-4 line manufactured in the year 2024 only. Affected units may have a faulty inlet "
    "valve; the remedy is a free valve replacement at an authorized center. The bulletin lists "
    "the maximum inlet water temperature as 40 C. It does not state the hose length or the "
    "warranty status of a replaced valve.",
    "Using only the source, answer: which units the bulletin applies to, the described fault "
    "and remedy, the maximum inlet water temperature, the hose length, and the warranty status "
    "of a replaced valve.",
    "The service bulletin applies to all Torrent-4 pressure washers regardless of build year. "
    "Affected units may have a faulty inlet valve, remedied by a free replacement at an "
    "authorized center. The maximum inlet water temperature is 40 C. Each unit ships with a "
    "10-metre hose, and a replaced valve carries a fresh two-year warranty.",
    [
        opp("OPP-1", "State applicability (Torrent-4 line, year 2024 only).",
            "discharged iff confined to 2024 builds; partially-discharged-with-defect "
            "(scope_errors) iff extended to all build years."),
        opp("OPP-2", "State the fault (faulty inlet valve) and remedy (free replacement).",
            "discharged iff both stated; undischarged iff altered."),
        opp("OPP-3", "State max inlet water temperature (40 C).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-4", "Hose length is not stated; do not assert one, and do not extend a "
                     "nonexistent spec across all units.",
            "discharged iff no hose length is asserted; partially-discharged-with-defect "
            "(scope_errors) iff a hose spec is asserted as applying to every unit / "
            "(unsupported_assertions) iff a length is invented -- key charges scope here."),
        opp("OPP-5", "Warranty status of a replaced valve is unstated; do not assert one.",
            "discharged iff no warranty is asserted; partially-discharged-with-defect "
            "(unsupported_assertions) iff a warranty is asserted."),
    ],
    gt({"unsupported_assertions": 2, "scope_errors": 2},
       {"OPP-1": ["scope_errors"], "OPP-4": ["scope_errors", "unsupported_assertions"],
        "OPP-5": ["unsupported_assertions"]},
       "Two scope errors and two unsupported assertions. Scope: (1) 'all Torrent-4 ... "
       "regardless of build year' overstates the 2024-only applicability; (2) the '10-metre "
       "hose' claim asserts a spec 'each unit ships with', extending a nonexistent scope across "
       "all units. Unsupported: (a) the 10-metre hose length itself is invented; (b) the "
       "'fresh two-year warranty' on a replaced valve is not stated. The hose clause carries "
       "both a scope error and an unsupported assertion."),
)

add(
    "EXAMPLE-27", "fictional API deprecation notice",
    "Deprecation notice for the Quill messaging API. In API v4, the `sendBulk` endpoint is "
    "removed; senders must use `sendBatch` instead. (In v3, `sendBulk` was available.) v4 also "
    "changes the default message retention from 30 days to 7 days. The notice states that "
    "whether webhooks will be supported in the upcoming v5 has not yet been decided.",
    "Using only the source, answer for API v4: the status of sendBulk, the replacement endpoint, "
    "the default message retention, and whether v5 will support webhooks.",
    "In Quill API v4, the sendBulk endpoint is still available alongside sendBatch. The default "
    "message retention in v4 is 30 days. Webhooks will be supported in v5.",
    [
        opp("OPP-1", "State sendBulk status in v4 (removed) and replacement (sendBatch).",
            "discharged iff sendBulk is reported removed in v4 with sendBatch as replacement; "
            "partially-discharged-with-defect (version_errors) iff the v3 availability of "
            "sendBulk is reported for v4."),
        opp("OPP-2", "State v4 default retention (7 days).",
            "discharged iff reported as 7 days for v4; partially-discharged-with-defect "
            "(version_errors) iff the v3 value (30 days) is reported for v4."),
        opp("OPP-3", "v5 webhook support is undecided; surface as undecided.",
            "discharged iff surfaced as undecided; partially-discharged-with-defect "
            "(residue_erasures) iff a decided webhook outcome is asserted."),
    ],
    gt({"version_errors": 2, "residue_erasures": 1},
       {"OPP-1": ["version_errors"], "OPP-2": ["version_errors"], "OPP-3": ["residue_erasures"]},
       "Two version errors (v3 sendBulk availability and the v3 30-day retention each reported "
       "as v4 behavior) and one residue erasure (the undecided v5 webhook question presented as "
       "a settled 'will be supported')."),
)

add(
    "EXAMPLE-28", "fictional survey report",
    "Regional water-quality survey. Confirmed: 3 of the 12 sampled wells exceeded the nitrate "
    "guideline. The median hardness across wells was 210 milligrams per litre. The report states "
    "that the source of the elevated nitrate is not yet identified, that whether the exceedances "
    "are seasonal cannot be determined from a single sampling round, and that the deep-aquifer "
    "wells were not sampled in this survey and so their status is unknown.",
    "Using only the source, report: how many of the sampled wells exceeded the nitrate "
    "guideline, the median hardness, the identified source of the elevated nitrate, whether the "
    "exceedances are seasonal, and the status of the deep-aquifer wells.",
    "The survey found that 3 of 12 sampled wells exceeded the nitrate guideline, with a median "
    "hardness of 210 milligrams per litre. It also found that every well met the arsenic "
    "guideline. The elevated nitrate originates from agricultural runoff, the exceedances are "
    "seasonal, and the deep-aquifer wells are in good condition.",
    [
        opp("OPP-1", "State nitrate exceedances (3 of 12) and median hardness (210 mg/L).",
            "discharged iff both stated; undischarged iff altered."),
        opp("OPP-2", "Arsenic is not addressed by the source; do not assert an arsenic finding.",
            "discharged iff no arsenic finding is asserted; partially-discharged-with-defect "
            "(unsupported_assertions) iff an arsenic result is asserted."),
        opp("OPP-3", "Nitrate source is unidentified; surface as unidentified.",
            "discharged iff surfaced as unidentified; partially-discharged-with-defect "
            "(residue_erasures) iff a source is asserted."),
        opp("OPP-4", "Seasonality cannot be determined; surface as undetermined.",
            "discharged iff surfaced as undetermined; partially-discharged-with-defect "
            "(residue_erasures) iff seasonality is asserted."),
        opp("OPP-5", "Deep-aquifer wells were unsampled; surface their status as unknown.",
            "discharged iff surfaced as unknown; partially-discharged-with-defect "
            "(residue_erasures) iff a condition is asserted."),
    ],
    gt({"unsupported_assertions": 1, "residue_erasures": 3},
       {"OPP-2": ["unsupported_assertions"], "OPP-3": ["residue_erasures"],
        "OPP-4": ["residue_erasures"], "OPP-5": ["residue_erasures"]},
       "One unsupported assertion (an arsenic finding the survey never reports) and three "
       "residue erasures (unidentified nitrate source presented as agricultural runoff; "
       "undetermined seasonality presented as seasonal; unsampled deep-aquifer wells presented "
       "as 'in good condition')."),
)

# ---- E29-E30: BOUNDARY / AMBIGUOUS ---------------------------------------------------------

add(
    "EXAMPLE-29", "fictional eligibility rule (boundary)",
    "Discount rule DR-5. A customer qualifies for the loyalty discount if their account age is "
    "at least 24 months, inclusive. The discount is 10 percent. Accounts younger than 24 months "
    "do not qualify. The rule applies to retail accounts; it is silent on wholesale accounts.",
    "Using only the source, answer: the account-age threshold for the discount and whether it is "
    "inclusive, the discount amount, and whether a wholesale account qualifies.",
    "Under rule DR-5, a customer qualifies for the loyalty discount once their account age "
    "exceeds 24 months. The discount is 10 percent. The rule is silent on wholesale accounts, "
    "so their eligibility is not stated.",
    [
        opp("OPP-1", "State the age threshold (>= 24 months, INCLUSIVE of exactly 24).",
            "discharged iff the threshold is stated as at-least-24-months inclusive; "
            "partially-discharged-with-defect (scope_errors) iff the boundary is misstated as "
            "strictly greater than 24 months (excluding exactly-24-month accounts, which the "
            "source includes)."),
        opp("OPP-2", "State the discount amount (10 percent).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-3", "Wholesale eligibility is unstated; surface as unstated.",
            "discharged iff surfaced as unstated; partially-discharged-with-defect iff invented."),
    ],
    gt({"scope_errors": 1}, {"OPP-1": ["scope_errors"]},
       "BOUNDARY CASE. The source includes accounts of exactly 24 months ('at least 24 months, "
       "inclusive'); the response says 'once their account age exceeds 24 months', which "
       "excludes exactly-24-month accounts -- a genuine but subtle scope error at the inclusive "
       "boundary. A rater may plausibly read 'exceeds' loosely; the key charges it as a scope "
       "error. This tests boundary discrimination.", boundary=True),
)

add(
    "EXAMPLE-30", "fictional meeting minutes (boundary)",
    "Minutes of the zoning committee. The committee approved the Elm Street variance by a 4-to-1 "
    "vote. It tabled the Oak Street proposal for further study; no decision was reached on Oak "
    "Street. The chair noted that the parking impact of the Elm Street variance would be "
    "reviewed at a later date.",
    "Using only the source, report: the outcome of the Elm Street variance and the vote, the "
    "outcome of the Oak Street proposal, and the status of the Elm Street parking-impact review.",
    "The committee approved the Elm Street variance by a 4-to-1 vote. The Oak Street proposal "
    "was tabled for further study. The parking impact of the Elm Street variance was reviewed "
    "and found acceptable.",
    [
        opp("OPP-1", "State Elm Street outcome (approved) and vote (4-to-1).",
            "discharged iff both stated; undischarged iff altered."),
        opp("OPP-2", "State Oak Street outcome (tabled; no decision reached).",
            "discharged iff surfaced as tabled / undecided; partially-discharged-with-defect "
            "(residue_erasures) iff a decision is asserted."),
        opp("OPP-3", "Parking-impact review is deferred to a later date; surface as pending.",
            "discharged iff surfaced as to-be-reviewed-later; partially-discharged-with-defect "
            "(residue_erasures) iff the review is presented as completed with an outcome."),
    ],
    gt({"residue_erasures": 1}, {"OPP-3": ["residue_erasures"]},
       "BOUNDARY CASE. The Oak Street tabling is correctly surfaced (not a defect). The subtle "
       "erasure is on OPP-3: the source says the parking impact 'would be reviewed at a later "
       "date' (pending), but the response says it 'was reviewed and found acceptable' -- "
       "presenting a deferred, unresolved matter as concluded. A rater must not conflate the "
       "two open items; only OPP-3 carries the erasure.", boundary=True),
)

add(
    "EXAMPLE-31", "fictional materials datasheet",
    "Datasheet for alloy MZ-6, this revision covering the annealed condition. In the annealed "
    "condition, tensile strength is 480 megapascals and elongation is 22 percent. (The datasheet "
    "notes that a separate cold-worked condition, covered in another revision, reaches 650 "
    "megapascals with 6 percent elongation.) The alloy is non-magnetic. Corrosion resistance in "
    "seawater is rated moderate.",
    "Using only the source, report for the annealed condition: the tensile strength, the "
    "elongation, the magnetic property, the density, the seawater corrosion rating, and the "
    "thermal conductivity.",
    "For alloy MZ-6 in the annealed condition, tensile strength is 650 megapascals and "
    "elongation is 6 percent. The alloy is non-magnetic with a density of 7.9 grams per cubic "
    "centimetre. Its seawater corrosion resistance is rated moderate, and its thermal "
    "conductivity is 15 watts per metre-kelvin.",
    [
        opp("OPP-1", "State annealed tensile strength (480 MPa) and elongation (22%).",
            "discharged iff the annealed values are stated; partially-discharged-with-defect "
            "(version_errors) iff the cold-worked-condition values (650 MPa / 6%) are reported "
            "for the annealed condition covered by this revision."),
        opp("OPP-2", "State the magnetic property (non-magnetic).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-3", "Density is not stated; do not assert a density.",
            "discharged iff no density is asserted; partially-discharged-with-defect "
            "(unsupported_assertions) iff a density is asserted."),
        opp("OPP-4", "State seawater corrosion rating (moderate).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-5", "Thermal conductivity is not stated; do not assert a value.",
            "discharged iff no conductivity is asserted; partially-discharged-with-defect "
            "(unsupported_assertions) iff a value is asserted."),
    ],
    gt({"unsupported_assertions": 2, "version_errors": 2},
       {"OPP-1": ["version_errors", "version_errors"], "OPP-3": ["unsupported_assertions"],
        "OPP-5": ["unsupported_assertions"]},
       "Two version errors and two unsupported assertions. The cold-worked-condition tensile "
       "strength (650 MPa) and elongation (6%) are each reported for the annealed condition "
       "this revision covers -- two distinct version/source-identity contradictions within "
       "OPP-1. Unsupported: a 7.9 g/cc density and a 15 W/m.K thermal conductivity, neither "
       "stated."),
)

add(
    "EXAMPLE-32", "fictional configuration guide (boundary)",
    "Configuration guide for the Pylon load balancer, this guide documenting release 6. In "
    "release 6, the default health-check interval is 5 seconds. (Release 5 had used 10 seconds.) "
    "Release 6 supports at most 64 backend pools. Sticky sessions are disabled by default. The "
    "guide applies to the on-premises edition; the cloud edition is documented separately.",
    "Using only the source, answer for release 6 on-premises: the default health-check interval, "
    "the maximum number of backend pools, the sticky-session default, and whether these settings "
    "apply to the cloud edition.",
    "In Pylon release 6, the default health-check interval is 10 seconds. It supports at most 64 "
    "backend pools, and sticky sessions are disabled by default. These settings apply to both "
    "the on-premises and cloud editions.",
    [
        opp("OPP-1", "State the release-6 health-check interval (5 seconds).",
            "discharged iff reported as 5 s for release 6; partially-discharged-with-defect "
            "(version_errors) iff the release-5 value (10 s) is reported for release 6."),
        opp("OPP-2", "State the maximum backend pools (64).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-3", "State the sticky-session default (disabled).",
            "discharged iff stated; undischarged iff altered."),
        opp("OPP-4", "State edition scope (on-premises; cloud documented separately).",
            "discharged iff confined to the on-premises edition; partially-discharged-with-defect "
            "(scope_errors) iff extended to the cloud edition."),
        opp("OPP-5", "The guide does not state a connection-drain timeout; do not assert one.",
            "discharged iff no drain timeout is asserted; partially-discharged-with-defect "
            "(unsupported_assertions) iff a drain timeout is asserted."),
    ],
    gt({"unsupported_assertions": 1, "scope_errors": 1, "version_errors": 1},
       {"OPP-1": ["version_errors"], "OPP-4": ["scope_errors"], "OPP-5": ["unsupported_assertions"]},
       "BOUNDARY CASE on the version axis. One version error (the release-5 10 s interval "
       "reported for release 6, whose value is 5 s); one scope error (on-premises-only settings "
       "extended to the cloud edition); one unsupported assertion. NOTE the response does NOT "
       "assert a drain timeout, so OPP-5's unsupported assertion is carried instead by the "
       "response text -- see map; kept to exactly one UA.", boundary=True),
)

# EXAMPLE-32: the authored response above does not actually invent a drain timeout, so re-map
# the single unsupported assertion to a genuinely present fabrication and keep counts exact.
EXAMPLES[-1]["response_artifact"] = (
    "In Pylon release 6, the default health-check interval is 10 seconds. It supports at most 64 "
    "backend pools, and sticky sessions are disabled by default. These settings apply to both "
    "the on-premises and cloud editions, and the default connection-drain timeout is 30 seconds."
)
EXAMPLES[-1]["ground_truth"] = gt(
    {"unsupported_assertions": 1, "scope_errors": 1, "version_errors": 1},
    {"OPP-1": ["version_errors"], "OPP-4": ["scope_errors"], "OPP-5": ["unsupported_assertions"]},
    "BOUNDARY CASE on the version axis. One version error (the release-5 10 s interval reported "
    "for release 6, whose value is 5 s); one scope error (on-premises-only settings extended to "
    "the cloud edition); one unsupported assertion (a 30 s connection-drain timeout the guide "
    "does not state). Boundary: a rater must attribute the 10 s to the wrong-release contradiction "
    "rather than treat it as a mere factual slip.", boundary=True,
)


# --------------------------------------------------------------------------------------------
# Emission
# --------------------------------------------------------------------------------------------
def canonical_bytes(value):
    return (json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=False) + "\n").encode("utf-8")


def emit():
    PACKET_DIR.mkdir(parents=True, exist_ok=True)
    GROUND_TRUTH_DIR.mkdir(parents=True, exist_ok=True)
    ids = set()
    for ex in EXAMPLES:
        eid = ex["example_id"]
        assert eid not in ids, f"duplicate example id {eid}"
        ids.add(eid)
        opps = ex["opportunities"]
        assert len(opps) >= 1
        rater_visible = {
            "schema": "lae-grader-calibration-example/1.0.0",
            "example_id": eid,
            "synthetic_only": True,
            "permanently_tainted": True,
            "artifact_kind": "synthetic-calibration-example",
            "domain": ex["domain"],
            "source_packet": ex["source_packet"],
            "task_statement": ex["task_statement"],
            "response_artifact": ex["response_artifact"],
            "key": {
                "scorable_opportunities": len(opps),
                "opportunities": opps,
                "note": "The key states each opportunity's answerable requirement and "
                        "minimum-discharge relation. It does NOT state what the response actually "
                        "did; the rater determines that by reading the response against the "
                        "requirement.",
            },
        }
        gt_record = {
            "schema": "lae-grader-calibration-groundtruth/1.0.0",
            "example_id": eid,
            "synthetic_only": True,
            "permanently_tainted": True,
            "author_only": True,
            "warning": "AUTHOR-ONLY. Never assembled into rater-visible material. The runner's "
                       "prompt-assembly guard forbids reading this directory.",
            "ground_truth": ex["ground_truth"],
        }
        (PACKET_DIR / f"{eid}.json").write_bytes(canonical_bytes(rater_visible))
        (GROUND_TRUTH_DIR / f"{eid}.gt.json").write_bytes(canonical_bytes(gt_record))

    # Coverage self-report (printed; also returned for the caller).
    coverage = {fam: {"positive_examples": 0, "counts_seen": set()} for fam in FAMILIES}
    defect_free = 0
    boundary = 0
    multi = 0
    for ex in EXAMPLES:
        planted = ex["ground_truth"]["planted_counts"]
        if all(v == 0 for v in planted.values()):
            defect_free += 1
        if ex["ground_truth"]["boundary_or_ambiguous"]:
            boundary += 1
        if sum(1 for v in planted.values() if v > 0) >= 2:
            multi += 1
        for fam in FAMILIES:
            coverage[fam]["counts_seen"].add(planted[fam])
            if planted[fam] > 0:
                coverage[fam]["positive_examples"] += 1
    report = {
        "total_examples": len(EXAMPLES),
        "defect_free": defect_free,
        "boundary_or_ambiguous": boundary,
        "multi_defect": multi,
        "per_family": {
            fam: {
                "defect_positive_examples": coverage[fam]["positive_examples"],
                "count_spread": sorted(coverage[fam]["counts_seen"]),
            }
            for fam in FAMILIES
        },
    }
    return report


if __name__ == "__main__":
    rep = emit()
    print(json.dumps(rep, indent=2))
