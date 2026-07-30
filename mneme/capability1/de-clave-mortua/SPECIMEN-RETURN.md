# SPECIMEN-RETURN — de-clave-mortua

Specimen of lane **Capability /1** (candidate). 29 checks, 0 failures, two
runs byte-identical (`RUN-EXITCODES.txt`). Every capability verdict in the
capture was rendered by a **stage child**; the orchestrator only
supervises, digests, preserves, and compares receipt bytes.

## What the bytes prove

1. **The key was truthfully minted and worked.** `ARTIFACT-EVENTS.pj0`
   frame 1 carries grant `cap0-event:g-001` for `cap:clavis-mortua`; the
   first life's query at P was `:authorized` and current ([003] in the
   relayed numbering of `RUN-SPECIMEN.txt`), the mint bound the key to P's
   four facets and its context recognized it ([004]), and the presentation
   succeeded at P ([005]).

2. **The complete public record was preserved — and it is testimony.**
   `ARTIFACT-AUTH-RECEIPT.pjs` (sha256 `405c762e…d0fc51e`) decodes to the
   `:authorized` receipt at ordinal 1; `ARTIFACT-MINT-RECEIPT.pjs` (sha256
   `f99db591…bcce04`) names the minting occurrence, the key's public
   identity, the minter, the authorizing query, grant g-001, all four
   terms, and all four binding facets; `ARTIFACT-DEAD-KEY-PRINT.txt` is the
   key's printed form ([006], [011]). There is no secret material in any
   of them — the object never contained any; that is the design, not a
   leak surface ([007]).

3. **The record was STILL CURRENT at the restart — and still opened
   nothing.** The journal never advanced (1 frame before and after,
   [008], [010], [013]); the restart verified the preserved authorization receipt
   still binds the present validated prefix ([015]). Then, in the same
   process: the authorization receipt presented as a capability — refused,
   `cap1-unrecognized-object` ([016]); the minting receipt — refused, its
   claimed public identity reported as a claim ([017]); a mimic built
   **through the lane's own internal constructor** from the minting
   receipt's public fields, binding current, every facet correct —
   refused by recognition ([018]); the printed form — reader-rejected
   ([019]). Staleness is not what kills a key; process death is.

4. **The restart re-derives; it does not remember.** The same
   authorization decision was reconstructed from durable bytes with origin
   `:reconstructed` and no byte sequence "observed" ([014], L10/L15). Its
   store-identity check is against an identity derived from declared
   config, never copied off the store it judges ([012]).

5. **Fresh minting is the only door.** The restart's own declared query
   (`q-vita-2`) authorized a FRESH mint: a new key, recognized by the NEW
   context, presenting successfully at the (unmoved) prefix ([020],
   [022]). Its public identity and minting occurrence identity both differ
   from the dead key's; both lives' minting receipts link the SAME grant
   g-001 — verified twice, once inside the restart ([021]) and once by the
   orchestrator over nothing but the two receipts' bytes ([027]).

6. **Nothing durable moved.** The journal and all three preserved files
   are byte-identical across the restart (sha256 equal; [023], [025],
   [026]) — four refused necromancies, one fresh mint, and two
   presentations wrote no frame and edited no testimony.

7. **An unfinished restart cannot pass as a clean one.** The
   `DE_CLAVE_DIE=1` child exits 3 with no `RESULT:` sentinel; the
   orchestrator detects exactly that pair ([028]).

## Honest limits

- The "genuinely new process" claim rests on OS process death (the first
  life exited before the restart launched) plus the admissible-inputs
  discipline of `stage-restart.lisp`; it is enforced by construction and
  inspection of that stage's source, not by a jail. The declared
  configuration file is shared by design — it carries what every process
  is entitled to know, never what the dead process did, and never the key
  (there is nothing key-shaped to carry).
- The restart's mimic check ([018]) deliberately uses the internal
  constructor (`::` path) — the labelled hostile move. Its refusal shows
  EQ-recognition holds even against the real constructor fed the complete
  public record; it does NOT show resistance to a hostile same-process
  attacker with introspection access to a LIVING context (out of scope,
  named in the lane RETURN).
- The cross-life identity difference is guaranteed by DECLARED CHARGE (the
  two lives use distinct query identities, so the derived key identities
  differ deterministically). Two lives that asked under the SAME query
  identity at the same prefix would derive the same public NAME — and
  still not the same key: identity is a name; recognition never consults
  it. No global-uniqueness claim is made.
- Deterministic fixed nonce = declared PJ-META-1 deviation (test fixture,
  never a production identity), exactly as the sibling specimens declared
  it.
- No SIGKILL is used: the first life exits cleanly by design, because this
  specimen's subject is the key's death-with-process, not crash-window
  commitment (de-teste-occiso's subject). No crash-window property is
  claimed here at all; journal0's §30 SIGKILL MUSTs remain undischarged in
  its own lane.
- All checks are same-family self-consistency; no stranger has run this.

— CLAVIGER-II (Claude Fable 5 subagent), 2026-07-29
