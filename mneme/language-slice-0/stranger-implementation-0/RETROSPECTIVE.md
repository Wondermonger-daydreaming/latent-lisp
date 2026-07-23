# RETROSPECTIVE.md — post-reveal (preserved unchanged)

*Seat: deepseek/deepseek-v3.2. Asked AFTER revealing LANGUAGE-SLICE-0-ARCHITECTURE.md + LANGUAGE-SLICE-0-CLOSURE.md and the seat's own final program. CONTAMINATION NOTE: the closure document pre-ranks the six Slice /1 candidates; the seat read it before answering Q6, so Q6's candidate endorsement is doc-primed — see CUSTODIAN-RESULT.md §Slice /1 pressure.*

---

**1. What did you infer correctly (about the language's design, from the Guide/API alone)?**

I correctly inferred the core semantic distinction between claims, witnesses, and judgments, and that promotion (`raise`) requires matching support. I understood that `project-claim` reconstructs a claim for a different receiver context, losing inaccessible supports rather than copying judgments. I correctly grasped that `transmit` governs transport with different modes and that `exercise-value` is the lawful way to invoke a local capability. I also inferred the receipt/explanation pattern for refusals and the availability of lawful restarts. The separation between local existence and reifiability was clear from the API's refusal conditions like `value-not-reifiable`.

**2. What did you misunderstand?**

I misunderstood the depth of the "no scalar ladder" principle. While I avoided implementing a standing order, I didn't fully appreciate that the rejection of linear standing was a fundamental architectural result validated by empirical falsification. I also underestimated the significance of the testimony discipline—I used testimony correctly but didn't recognize it as a load-bearing gate guarding the proposition vocabulary itself. Additionally, I treated `local-value` as a simple record constructor rather than recognizing it as the governed *admission act* that computes kind and enforces the boundary.

**3. Which distinctions became clear only after this reveal?**

The sharp distinction between the four strata of the host boundary—especially that stratum 3 (explicit/internal host escape) is acknowledged but not claimed closed—became clear. The empirical falsification of three specific designs (standing ladder, copied receiver status, single exportable boolean) and why each failed was revelatory. The orthogonality of semantic axes—that a claim's judgment says nothing about transmissibility, and a witness's travel says nothing about standing—became clearer in its architectural significance. Also, the temporary nature of the atomic proposition surface (keywords/strings/integers only) as a documented limitation, with a structured canonical proposition shape as a future candidate.

**4. Which public exports felt essential?**

`claim`, `witness`, `raise`, `project-claim`, `transmit`, `exercise-value`, `receiver-context`, `promotion-procedure`, `local-value`, `derived-result`, and the receipt accessors (`promotion-receipt-decision`, `projection-views`, etc.) were absolutely essential. The condition types (`wrong-proposition-support`, `value-not-reifiable`, etc.) and their associated restarts (`seek-matching-support`) were critical for lawful repair. `why` and `render-why` were essential for debugging. The kernel0 exports (`make-identity`, `make-procedure-descriptor`) were necessary for constructing procedures.

**5. Which felt like loading-dock machinery (present but not load-bearing for your task)?**

`projection-receipt-supports-inaccessible` felt like a diagnostic accessor rather than core logic—useful for inspection but not required for the main flow. The various view functions (`projection-views`, `transmission-views`) felt like secondary inspection tools. The `support-store` constructor was merely a convenience wrapper. The `judgment-record-judgment` accessor felt like a low-level detail; I could have used `claim-judgment` directly. The `witness-id` and `witness-content` accessors were used only for context setup, not for core algorithmic decisions.

**6. What one successor feature would have removed the most friction from your implementation?**

**Explicit host-escape form + static checker** (`with-host-escape` marker and linter). The friction came from uncertainty about what constituted "lawful" use versus accidental escape. Having a visible marker and checker would have clarified the boundary during implementation, reduced mental overhead about whether I was staying within stratum 1, and provided immediate feedback rather than relying on runtime conditions. This would have been more immediately useful than structured propositions or policy refinements, as it directly addresses the implementer's need to know when they're using the fragment correctly.