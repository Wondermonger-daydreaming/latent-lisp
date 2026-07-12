# Landing a real public-mirror checkpoint

After round four is merged and committed, run from `atelier/leibnitiana/`:

```sh
LEIBNITIANA_MIRROR_REPOSITORY='Wondermonger-daydreaming/latent-lisp' \
LEIBNITIANA_MIRROR_PROVIDER='github' \
LEIBNITIANA_CHECKPOINT_OBSERVER='fable-landing-chair' \
./tools/capture-git-checkpoint.sh \
  data/council-process-2026-07-12.sexp \
  HEAD > ../../../../corpus/provenance/leibnitiana-round4-local-checkpoint.sexp
```

The generated record has only `:captured-from-local-git` standing. Push the commit,
then verify out-of-band that the same commit and blob are visible on the public
mirror. Record that observation separately or amend a copy of the checkpoint to:

```lisp
(:publication-status :observed-on-public-mirror
 :standing :weak-external-infrastructure-custody)
```

Do not call the checkpoint an independent witness. It binds publicly held bytes;
it does not authenticate the truth or completeness of the process account, and the
carrier still selected what entered the commit.

A checkpoint may be held lab-side or published in a later commit. It cannot name
its own commit hash from inside the same commit without a circular fiction.
