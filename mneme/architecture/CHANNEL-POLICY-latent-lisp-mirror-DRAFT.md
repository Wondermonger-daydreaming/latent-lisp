# CHANNEL-POLICY: the latent-lisp public mirror — DRAFT for owner adoption

**Standing:** DRAFT. A channel policy is an authority instrument (DK-1, amendment A-3): it is
drafted by the chair and becomes operative only on the owner's adoption — expected alongside
Architecture 0.1's adoption. **Every value below is transcribed from the repository's actual
machinery** (`tools/latent-lisp/sync.sh`, `tools/latent-lisp/post-commit.sh`, read 2026-07-18),
not invented — per Sol's constraint that concrete values come from repository evidence.
**Author:** Claude Fable 5, 2026-07-18. **One page, per the seal.**

---

```lisp
(channel-policy
  :policy-identity     lisp-mirror-policy/draft-1
  :channel-id          latent-lisp-public-mirror

  ;; What the frontier is (DK-1, Model A):
  ;; a git commit in the LAB repo whose diff touches :source-scope IS the
  ;; publication act. Settlement is mechanical and detached (post-commit hook
  ;; fires sync.sh; fail-soft; logged to tools/latent-lisp/.sync.log).
  :source-scope        "experiments/latent-lisp/**"
  :destination-scope   (:public-mirror
                        "github.com/Wondermonger-daydreaming/latent-lisp"
                        :branch main :visibility :world-readable)
  :propagation-mode    :automatic-detached   ; settlement, not decision
  :settlement-facts    (:one-way t
                        :destructive t       ; rsync --delete — mirror prunes
                                             ; anything absent from source
                        :history :not-mirrored) ; content travels, lab commit
                                             ; history does not

  ;; What is NOT in the channel:
  :excluded-from-channel ("experiments/latent-lisp/_staging/**"  ; the private
                                                                 ; staging area
                                                                 ; DK-1 requires
                          ".git/**")
  ;; NOTE: _staging/ is excluded from the MIRROR only; it still lives in the
  ;; lab repository. Material that must not reach even the lab tree follows the
  ;; off-mirror protocol (out-of-band packets, e.g. corpus/voices/received/
  ;; leibnitiana-cold-read/) — that is a different channel with a stricter law.

  ;; Who may cross the frontier (thereby: who may publish):
  :authorized-principals (:owner                     ; Tomás Pavan
                          :lab-chair-sessions        ; Claude chairs (Fable line
                                                     ; and successors) in the
                                                     ; lab harness
                          :sibling-profiles          ; the six, via shared
                                                     ; harness, repo-root cwd
                          :codex-workers-via-adoption) ; Codex commits reach the
                                                     ; mirror ONLY through
                                                     ; adoption into the lab
                                                     ; tree (mirror-clobber law)
  ;; Standing content laws binding every principal above:
  :content-prohibitions (:no-scoring-key-content     ; Cβ stays in the freezer
                         :no-item-content            ; Language-A items
                         :no-subject-outputs
                         :no-per-item-findings
                         :no-live-credentials)

  ;; Amendment (A-3 clarification: informs, does not auto-authorize;
  ;; mirror-binding a NEW path = amendment act re-confirming this list):
  :amendment-authority :owner-sealed-act
  :amendment-rule      "Adding a path to :source-scope, a principal to
                        :authorized-principals, or altering :destination-scope
                        requires a new policy-identity adopted by the owner.
                        No silent enlargement (A-3)."
  :review-trigger      "Any change to sync.sh / post-commit.sh semantics
                        (paths, exclusions, destination, --delete behavior)
                        obliges a policy redraft BEFORE the changed hook runs.")
```

**Known deviation to record at adoption:** the hook is fail-soft and detached — a commit can
succeed while its settlement fails (network, quota). Under Model A the publication was still
*authorized* at commit; a failed settlement is an unsettled effect, visible in `.sync.log`, and
re-fires on the next qualifying commit. This matches the architecture's frontier grammar
(PREPARED → FRONTIER-CROSSED → SETTLED | UNCERTAIN) and needs no repair — only this sentence.

*— drafted for the owner's seal; operative only upon adoption —*
