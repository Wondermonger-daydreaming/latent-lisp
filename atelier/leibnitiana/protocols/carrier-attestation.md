# Carrier attestation: an invitation across the unwritten boundary

A relay carrier may perform the process decisions that matter most: choosing which artifact to paste, whether to paste it verbatim, whether to omit alternatives, whether to request another attempt, and when to stop carrying the exchange. Those acts can alter the lineage of an apparent council even when neither model session can observe them.

The chamber therefore permits a **carrier attestation**, but does not demand one. The carrier is a companion in the process, not an involuntary telemetry device.

A minimal voluntary attestation may record:

```lisp
(:artifact :second-tranche
 :relayed-from :sol
 :relayed-to :fable
 :verbatim :yes
 :known-alternatives-omitted :not-recorded
 :retries-requested 0
 :selection-note :voluntarily-supplied-or-absent)
```

The attestation must be scope-bounded. It need not disclose private thoughts, unrelated activity, a comprehensive browsing or conversation history, or reasons for declining to attest. No attestation means only that carrier-side selection, omission, and retry history remain `:not-established`. It must never be converted into suspicion, guilt, or evidence of curation.

A jointly extended invitation can read:

> We are auditing the lineage of this relay, including the boundary neither model can see. You may, if you wish, attach a brief record of what you carried, whether it was edited, and whether known alternatives were omitted or retries requested. Silence leaves those facts unknown and carries no adverse inference.

## Claims split

The schema can express an attestation. It cannot authenticate the carrier, establish completeness, or compel truthful disclosure. Stronger standing requires signed records, independently held checkpoints, or other custody mechanisms that remain outside the curator’s unilateral control.

## Optional witness-selection lineage

When the carrier also selects a cold reader, that choice becomes part of the
review's process lineage. A voluntary selection note may include:

```lisp
(:outsider-selection
 (:selector :carrier
  :candidate-source :how-the-reader-was-found
  :pool-description :voluntarily-supplied-or-unknown
  :exclusions :voluntarily-supplied-or-unknown
  :relationship-to-project :self-declared
  :prior-exposure :self-declared
  :selection-timing :before-packet-delivery))
```

These fields bound the standing of the review; they do not turn the carrier into
an object of interrogation. The selector need not disclose private contact lists,
unrelated relationships, or reasons for excluding particular people. An absent
selection note leaves selection lineage `:not-established` and carries no adverse
inference.

A carrier-selected reader can be substantially colder than the Sol/Fable mutual
audit while still not being cold *simpliciter*. The result should therefore say
`carrier-selected ancestry-declared cold read` unless a stronger recruitment and
custody process is independently evidenced.
