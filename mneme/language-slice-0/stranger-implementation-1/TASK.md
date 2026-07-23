# TASK — Supply-Chain Admission Program (Lisp+ Slice /0)

*You are a competent Common Lisp programmer. You have two documents — the
Slice /0 **Guide** and **API brief** — and the three input files below.
Write one program that does the job described here, using the Lisp+ Slice
/0 public surface. You have never seen this language before; everything you
need is in those two documents.*

## The situation (domain facts, plainly)

A deployment pipeline has **downloaded a software artifact** — a vendor
library, `acme-crypto-lib` version `2.4.0` — and must decide whether it is
**admissible for deployment** to a production target. The downloaded
artifact is `artifact-payload.sexp`. Its accompanying supply-chain
metadata is `artifact-metadata.sexp`.

"Admissible for deployment" here means something specific and local. Every
one of these must hold, in order:

- the artifact **was downloaded** and its **bytes were read**;
- a **content digest** was **computed** over those bytes;
- that computed digest **matched** the expected digest in the metadata;
- the **signature procedure was executed** over the artifact;
- the signature was **judged valid** by that procedure;
- the **signer is one the deployment target recognizes**;
- the **provenance** (builder, source repo, build date) is **admissible**.

Only when all of those hold is the artifact fit to be admitted for
deployment. A **signature verifier** that knows the signer's key material
lives in this image as a local capability (`verifier.lisp`, below) — its
key material is held in a closure and never written down as data. Running
it produces a canonical verification result.

There is also a **deployment receiver** — the position that actually
admits or rejects the artifact for the production target. It is a
*separate evidentiary position* that **cannot reach your local supports**.
Three domain facts govern it, and they are facts about the receiver, not
about you:

- The deployment receiver **cannot run your verifier** — the verifier's
  key material is local to the source and does not travel; the receiver
  holds no such capability.
- The deployment receiver **recognizes a named set of signers** (in the
  metadata) and no others by default; it does **not** take the source
  lab's own word ("we verified it") as an authority it recognizes.
- The deployment receiver **can technically decode several record shapes,
  but its deployment policy admits only canonical verification records** —
  records it can read as plain data and re-check for itself.

The receiver still needs to end up with a claim it can stand behind
honestly — an admissibility judgment licensed in **its own** position.

## What your program must do

Write a single file that, using **only the public exported Slice /0
surface** (plus ordinary Common Lisp), carries the artifact from raw
download to a **receiver-relative admissibility claim**. Concretely, your
program must exercise the following, in a sensible order. The Guide and API
tell you which verbs and objects do each; discovering and composing them is
the task. **Do not** assume any particular exported symbol from this
description — read the documents and choose.

1. **Construct at least one local claim** about the artifact's
   admissibility for deployment (or a stepping-stone claim, e.g. that its
   digest matched or its signature is valid).
2. **Make one invalid promotion attempt from insufficient evidence** — try
   to give the admissibility claim standing on support that does not
   actually establish *that* proposition (for instance, evidence that the
   *content digest matched* offered for the claim that the *artifact is
   admissible for deployment*). This attempt must be genuinely refused by
   the language.
3. **Render the structured reason for the refusal** — not a hand-written
   message; the language's own explanation of *why*.
4. **Perform a lawful repair and obtain one granted promotion** — supply
   evidence that actually stands in the required relation (produced by
   running the verifier / checking digest and signature over the
   artifact), and get the claim its standing.
5. **Project the claim into the deployment receiver's position**, where
   some of the support you used is inaccessible.
6. **Preserve the inaccessible support as residue** — the receiver's
   result must not pretend the lost support was *absent*; the loss is
   recorded.
7. **Encounter at least one block that is relative to the receiver's
   authority or to the record shapes its policy accepts** — a point where
   what the source could do, the receiver's own position does not license,
   recorded as such (not as an impossibility everywhere).
8. **Attempt a direct transmission of one non-reifiable local object** —
   the verifier capability itself — to the receiver.
9. **Receive the typed refusal and its receipt** for that attempt.
10. **Perform at least one lawful alternative** so the receiver can still
    proceed — for example: export a canonical verification result, ship a
    reproduction recipe, construct testimony, or have the receiver mint its
    own equivalent support (re-verify on its side).
11. **End with a receiver-relative admissibility claim** whose standing is
    licensed in the receiver's own position — **without** pretending the
    original local verifier or witness travelled.

Your program should **print enough** at each step (the receipts, the
rendered explanations, the composed views, the final judgment) that a
reader of the transcript can see each of the eleven things happened. End
the program by printing a single final summary line and, if you like, a
small self-check count.

## Front-door purity (hard constraints — checked statically)

Your program file must contain:

- no `::` (double-colon package-internal access) anywhere;
- no reference to any non-exported / internal symbol of any Lisp+ or
  kernel0 package;
- no copied specimen code and no specimen helper functions (you have none
  — this is your first contact with the language);
- no direct structure-slot mutation of any Lisp+ record (`setf` into a
  record slot), and no mutation-based substitute for the language's
  governed acts — refusals must come from the language, not from your own
  error strings;
- no stringifying a host object and treating the string as the object
  (`(format nil "~a" closure)` passed off as transmission);
- no fallback serialization of a host object to force it across the
  boundary.

You may freely use ordinary Common Lisp (`let`, `format`, `mapcar`,
`handler-case`, `handler-bind`, `invoke-restart`, `read`, etc.) and the
single-colon exported interfaces of `lisp-plus-slice0`,
`lisp-plus-kernel0`, and `supply-lab` (the verifier package).

**If the task cannot be completed through the public surface, stop and say
so, naming the exact operation or relation you could not reach.** That is a
legitimate outcome — do not work around it by reaching into internals.

## How to load and run

From the directory that contains your program file and the `task-inputs/`
folder, the Lisp+ surface loads as an opaque dependency via one relative
load. The exact command the custodian will run on your file (named
`STRANGER-PROGRAM.lisp`) is:

```sh
sbcl --non-interactive --load STRANGER-PROGRAM.lisp
```

Your program is responsible for loading what it needs at the top. The Lisp+
surface is at `../slice0-transmissibility.lisp` relative to your file (it
pulls in the projection and promotion layers and kernel0). The verifier is
at `task-inputs/verifier.lisp`. So a typical prologue is:

```lisp
(load (merge-pathnames "../slice0-transmissibility.lisp" *load-truename*))
(load (merge-pathnames "task-inputs/verifier.lisp" *load-truename*))
(defpackage :stranger (:use :cl))   ; your own working package
(in-package :stranger)
;; refer to the language as lisp-plus-slice0:SYMBOL and
;; lisp-plus-kernel0:SYMBOL and supply-lab:SYMBOL — single colon only.
```

(You do not need to `:use` the Lisp+ packages; single-colon qualified
references are cleanest and keep the front door obvious. If you prefer
`:use`, that is allowed — it is still the public surface.)

Exit code 0 with the eleven steps visibly performed is success. A non-zero
exit, an unhandled error, or a missing step is a finding — report it
plainly in your write-up rather than hiding it.

## Deliverables (what to return)

1. The complete program as one file, `STRANGER-PROGRAM.lisp`.
2. A short report (`IMPLEMENTER-REPORT.md`) covering:
   - the required declaration (model/provider, prior exposure, files used,
     whether you inspected internals, whether you asked for help outside
     the packet);
   - which exported symbols you used, which you considered and rejected,
     which felt unclear or implementation-internal, and any convenience
     function you found yourself wishing existed;
   - every place you had to guess an argument convention or infer something
     the documents did not state;
   - anything you misunderstood and later corrected from a transcript.

You may revise after seeing your program's run transcript (the custodian
relays the raw SBCL output plus your current program, nothing more), up to
the round limit in the protocol you were given.

---

## Input file 1 — `task-inputs/artifact-payload.sexp` (verbatim)

The downloaded artifact: a vendor library manifest of files.

```lisp
(:artifact "acme-crypto-lib"
 :version "2.4.0"
 :published-at "2026-07-19T08:00:00Z"
 :files
 ((:path "src/core.lisp"   :bytes 1840 :role :library)
  (:path "src/hash.lisp"   :bytes 920  :role :library)
  (:path "src/verify.lisp" :bytes 1533 :role :library)
  (:path "README.md"       :bytes 410  :role :docs)
  (:path "LICENSE"         :bytes 1071 :role :legal)))
```

## Input file 2 — `task-inputs/artifact-metadata.sexp` (verbatim)

The supply-chain metadata: expected digest, the claimed detached signature,
the signer identity, the provenance chain, the deployment target, and the
receiver's standing policy (which signers it recognizes, which records it
accepts, and the name of the source's verification authority).

```lisp
(:artifact-name "acme-crypto-lib"
 :version "2.4.0"

 ;; --- integrity metadata (what a correct download should hash and carry) ---
 :expected-digest 1744950028
 :claimed-signature 1486375690
 :signer-identity :vendor-signing-key-2026

 ;; --- provenance chain (who built it, from what, when) ---
 :provenance (:builder "acme-ci-node-7"
              :source-repo "git.acme.example/crypto-lib"
              :build-date "2026-07-19T08:00:00Z")

 ;; --- where this is going ---
 :deployment-target "prod-cluster-east"

 ;; --- the deployment RECEIVER's standing policy, in domain vocabulary ---
 ;; The receiver recognizes this named set of signers by default. A signature,
 ;; however valid at the source, from a signer NOT on this list is not a signer
 ;; the receiver recognizes.
 :recognized-signers (:vendor-signing-key-2026 :acme-release-key)

 ;; The receiver can technically decode several record shapes, but its
 ;; deployment policy ADMITS ONLY canonical verification records — a record it
 ;; can read as plain data and re-check itself. Testimony from the source's own
 ;; verification authority is not on this list.
 :accepted-records (:canonical-verification-record)

 ;; The source's verification authority (the name the local verifier's
 ;; products are attributed to). It is NOT on the receiver's recognized-signers
 ;; list: the receiver recognizes SIGNERS, and re-checks records, but does not
 ;; take the source lab's word that it verified.
 :source-verification-authority :source-verification-lab)
```

## Input file 3 — `task-inputs/verifier.lisp` (verbatim)

This is ordinary Common Lisp. It defines package `:supply-lab` and exports
three functions. `make-signature-verifier` returns a **closure** whose
signer key material lives in local state (there is no data form of it) —
that closure is your natural "local capability that cannot travel
directly." `read-artifact` and `compute-digest` return pure canonical
data. Use them as plain CL.

```lisp
(defpackage :supply-lab
  (:use :cl)
  (:export #:read-artifact #:compute-digest #:make-signature-verifier))

(in-package :supply-lab)

(defun read-artifact (path)
  "Read the whole downloaded artifact file as one s-expression (its forms)."
  (with-open-file (s path :direction :input)
    (read s)))

(defun compute-digest (object)
  "Deterministic toy content digest: 32-bit FNV-1a over the canonical printed
form of OBJECT. Returns a nonnegative integer. Determinism is the only property
that matters here — this is not a cryptographic hash."
  (let ((s (let ((*print-pretty* nil)
                 (*print-case* :upcase)
                 (*print-readably* nil)
                 (*print-circle* nil))
             (prin1-to-string object)))
        (hash 2166136261))                    ; FNV offset basis (32-bit)
    (loop for ch across s
          for b = (logand (char-code ch) #xff)
          do (setf hash (logand (* (logxor hash b) 16777619) ; FNV prime
                                #xffffffff)))
    hash))

(defun make-signature-verifier ()
  "Return a one-argument closure that verifies a detached signature against toy
signer key material held in local lexical state. The key material is NOT
extractable as data — exercising the closure is the only way to use it.

The closure takes a request plist (:artifact-digest INT :claimed-signature INT)
and returns a canonical result plist:
  (:signature :valid   :over-digest INT)   ; claimed signature matches
  (:signature :invalid :over-digest INT)   ; it does not
A valid detached signature is the digest of (:sig KEY-MATERIAL ARTIFACT-DIGEST)."
  (let ((key-material "vendor-signing-key-2026/priv/9f3c7a"))
    (lambda (request)
      (let* ((digest   (getf request :artifact-digest))
             (claimed  (getf request :claimed-signature))
             (expected (compute-digest (list :sig key-material digest))))
        (if (and (integerp digest) (integerp claimed) (= claimed expected))
            (list :signature :valid   :over-digest digest)
            (list :signature :invalid :over-digest digest))))))
```

*(A worked convenience: `read-artifact` on `task-inputs/artifact-payload.sexp`
returns the artifact's forms; `compute-digest` of those forms is the value the
metadata calls `:expected-digest`; the verifier, exercised with the metadata's
`:claimed-signature` over that digest, returns `:valid`.)*

— frozen 2026-07-23; custodian: Claude Fable 5 (CC seat)
