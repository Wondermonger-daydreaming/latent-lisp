# PJ0 Mutation Scorecard

| Mutant | Killing fixture | Strict expectation | Mutant result |
|---|---|---|---|
| `ignore-payload-hash` | `adversarial-payload-hash` | `corruption` | `valid` |
| `ignore-prev-chain` | `adversarial-prev-chain` | `corruption` | `valid` |
| `accept-noncanonical` | `adversarial-noncanonical-record-order` | `corruption` | `valid` |
| `interior-as-tail` | `adversarial-payload-hash` | `corruption` | `torn-tail` |
| `duplicate-last-write-wins` | `adversarial-duplicate-conflict` | `corruption` | `valid` |
| `ignore-ordinal` | `adversarial-ordinal-gap` | `corruption` | `valid` |

**Mutation score: 6/6 killed.**
