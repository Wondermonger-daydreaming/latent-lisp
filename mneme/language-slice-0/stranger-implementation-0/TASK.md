# TASK — Dataset Admission Program (Lisp+ Slice /0)

*You are a competent Common Lisp programmer. You have two documents —
the Slice /0 **Guide** and **API brief** — and the two input files
below. Write one program that does the job described here, using the
Lisp+ Slice /0 public surface. You have never seen this language before;
everything you need is in those two documents.*

## The situation (domain facts, plainly)

A lab collected a batch of specimen readings (`readings-batch-a.sexp`)
and wants to make one downstream claim:

> **batch-a is admissible for a mass–temperature regression analysis.**

"Admissible" here means something specific and local: a **file was
opened**, its **rows were parsed**, each row had the **required fields**,
the values **satisfied the schema constraints**, and a **summary was
computed**. Only when those hold is the batch fit to support the
regression claim. A validator that knows the schema lives in this image
as a local capability (`validator.lisp`, below) — its schema is held in
a closure and never written down as data.

There is also an **external reviewer** — a separate evidentiary position
that *cannot reach your local supports*: it cannot open your file, does
not recognize your lab as an authority by default, and cannot run your
validator. The reviewer still needs to end up with a claim it can stand
behind honestly.

## What your program must do

Write a single file that, using **only the public exported Slice /0
surface** (plus ordinary Common Lisp), carries the batch from raw data
to a receiver-relative admissibility claim. Concretely, your program
must exercise the following, in a sensible order. The Guide and API tell
you which verbs and objects do each; discovering and composing them is
the task.

1. **Construct at least one local claim** about the batch (e.g. that it
   is admissible for the regression, or a stepping-stone claim).
2. **Make one invalid promotion attempt from insufficient evidence** —
   try to give the admissibility claim standing on support that does not
   actually establish *that* proposition (for instance, evidence that a
   *file was opened* offered for the claim that the *dataset is
   admissible*). This attempt must be genuinely refused by the language.
3. **Render the structured reason for the refusal** — not a hand-written
   message; the language's own explanation of *why*.
4. **Perform a lawful repair and obtain one granted promotion** — supply
   evidence that actually stands in the required relation (produced by
   running the validator over the rows), and get the claim its standing.
5. **Project the claim into the reviewer's position**, where some of the
   support you used is inaccessible.
6. **Preserve the inaccessible support as residue** — the reviewer's
   result must not pretend the lost support was *absent*; the loss is
   recorded.
7. **Attempt a direct transmission of one non-reifiable local object** —
   the validator capability itself — to the reviewer.
8. **Receive the typed refusal and its receipt** for that attempt.
9. **Perform at least one lawful alternative** so the reviewer can still
   proceed — for example: export a canonical result (a summary or a
   validation product), construct testimony, ship a reproduction recipe,
   or have the reviewer mint its own equivalent support.
10. **End with a receiver-relative admissibility claim** whose standing
    is licensed in the reviewer's own position — **without** pretending
    the original local witness or capability travelled.

Your program should **print enough** at each step (the receipts, the
rendered explanations, the composed views, the final judgment) that a
reader of the transcript can see each of the ten things happened. End
the program by printing a single final summary line and, if you like, a
small self-check count.

## Front-door purity (hard constraints — checked statically)

Your program file must contain:

- no `::` (double-colon package-internal access) anywhere;
- no reference to any non-exported / internal symbol of any Lisp+ or
  kernel0 package;
- no copied specimen code and no specimen helper functions (you have
  none — this is your first contact with the language);
- no direct structure-slot mutation of any Lisp+ record (`setf` into a
  record slot), and no use of a raise-substitute — refusals must come
  from the governed acts;
- no stringifying a host object and treating the string as the object
  (`(format nil "~a" closure)` passed off as transmission);
- no fallback serialization of a host object to force it across the
  boundary.

You may freely use ordinary Common Lisp (`let`, `format`, `mapcar`,
`handler-case`, `handler-bind`, `invoke-restart`, `read`, etc.) and the
single-colon exported interfaces of `lisp-plus-slice0`,
`lisp-plus-kernel0`, and `dataset-lab` (the validator package).

**If the task cannot be completed through the public surface, stop and
say so, naming the exact operation or relation you could not reach.**
That is a legitimate outcome — do not work around it by reaching into
internals.

## How to load and run

From the directory that contains your program file and the
`task-inputs/` folder, the Lisp+ surface loads as an opaque dependency
via one relative load. The exact command the custodian will run on your
file (named `STRANGER-PROGRAM.lisp`) is:

```sh
sbcl --non-interactive --load STRANGER-PROGRAM.lisp
```

Your program is responsible for loading what it needs at the top. The
Lisp+ surface is at `../slice0-transmissibility.lisp` relative to your
file (it pulls in the projection and promotion layers and kernel0). The
validator is at `task-inputs/validator.lisp`. So a typical prologue is:

```lisp
(load (merge-pathnames "../slice0-transmissibility.lisp" *load-truename*))
(load (merge-pathnames "task-inputs/validator.lisp" *load-truename*))
(defpackage :stranger (:use :cl))   ; your own working package
(in-package :stranger)
;; refer to the language as lisp-plus-slice0:SYMBOL and
;; lisp-plus-kernel0:SYMBOL and dataset-lab:SYMBOL — single colon only.
```

(You do not need to `:use` the Lisp+ packages; single-colon qualified
references are cleanest and keep the front door obvious. If you prefer
`:use`, that is allowed — it is still the public surface.)

Exit code 0 with the ten steps visibly performed is success. A non-zero
exit, an unhandled error, or a missing step is a finding — report it
plainly in your write-up rather than hiding it.

## Deliverables (what to return)

1. The complete program as one file, `STRANGER-PROGRAM.lisp`.
2. A short report (`IMPLEMENTER-REPORT.md`) covering:
   - the required declaration (model/provider, prior exposure, files
     used, whether you inspected internals, whether you asked for help
     outside the packet);
   - which exported symbols you used, which you considered and rejected,
     which felt unclear or implementation-internal, and any convenience
     function you found yourself wishing existed;
   - every place you had to guess an argument convention or infer
     something the documents did not state;
   - anything you misunderstood and later corrected from a transcript.

You may revise after seeing your program's run transcript (the custodian
relays the raw SBCL output, nothing more), up to the round limit in the
protocol you were given.

---

## Input file 1 — `task-inputs/readings-batch-a.sexp` (verbatim)

```lisp
(:batch "batch-a"
 :collected-at "2026-07-21T09:14:00Z"
 :schema-note "each row: (:specimen-id STRING :mass-mg INT :temp-c INT :replicate INT)"
 :rows
 ((:specimen-id "A-001" :mass-mg 412 :temp-c 21 :replicate 1)
  (:specimen-id "A-001" :mass-mg 419 :temp-c 21 :replicate 2)
  (:specimen-id "A-002" :mass-mg 388 :temp-c 22 :replicate 1)
  (:specimen-id "A-002" :mass-mg 401 :temp-c 22 :replicate 2)
  (:specimen-id "A-003" :mass-mg 455 :temp-c 20 :replicate 1)
  (:specimen-id "A-003" :mass-mg 448 :temp-c 20 :replicate 2)
  (:specimen-id "A-004" :mass-mg 372 :temp-c 23 :replicate 1)
  (:specimen-id "A-004" :mass-mg 369 :temp-c 23 :replicate 2)))
```

## Input file 2 — `task-inputs/validator.lisp` (verbatim)

This is ordinary Common Lisp. It defines package `:dataset-lab` and
exports three functions. `make-row-validator` returns a **closure** whose
schema lives in local state (there is no data form of it) — that closure
is your natural "local capability that cannot travel directly."
`summarize` returns pure canonical data. Use them as plain CL.

```lisp
(defpackage :dataset-lab
  (:use :cl)
  (:export #:read-dataset #:make-row-validator #:summarize))

(in-package :dataset-lab)

(defun read-dataset (path)
  "Read the whole dataset file as one s-expression."
  (with-open-file (s path :direction :input)
    (read s)))

(defun make-row-validator ()
  "Return a one-argument closure that validates a row against a schema
held in local lexical state. The schema is not extractable as data."
  (let* ((required '(:specimen-id :mass-mg :temp-c :replicate))
         (mass-bounds '(50 . 1000))     ; inclusive mg bounds
         (temp-bounds '(-40 . 125))     ; inclusive C bounds
         (replicate-max 3))
    (lambda (row)
      (let ((problems '()))
        (dolist (f required)
          (unless (member f row)
            (push (list :field f :reason :missing) problems)))
        (let ((mass (getf row :mass-mg)))
          (when (integerp mass)
            (unless (<= (car mass-bounds) mass (cdr mass-bounds))
              (push (list :field :mass-mg :reason :out-of-bounds) problems))))
        (let ((temp (getf row :temp-c)))
          (when (integerp temp)
            (unless (<= (car temp-bounds) temp (cdr temp-bounds))
              (push (list :field :temp-c :reason :out-of-bounds) problems))))
        (let ((rep (getf row :replicate)))
          (when (integerp rep)
            (unless (<= 1 rep replicate-max)
              (push (list :field :replicate :reason :out-of-bounds) problems))))
        (dolist (f '(:mass-mg :temp-c :replicate))
          (let ((val (getf row f)))
            (when (and (member f row) (not (integerp val)))
              (push (list :field f :reason :not-integer) problems))))
        (if problems
            (list* :bad row (nreverse problems))
            (list :ok row))))))

(defun summarize (rows)
  "Canonical summary of a list of row plists. Pure data."
  (let* ((n (length rows))
         (ids (remove-duplicates (mapcar (lambda (r) (getf r :specimen-id)) rows)
                                 :test #'equal))
         (masses (mapcar (lambda (r) (getf r :mass-mg)) rows))
         (temps (mapcar (lambda (r) (getf r :temp-c)) rows)))
    (list :n n
          :specimens (length ids)
          :mass-mg (list :min (reduce #'min masses)
                         :max (reduce #'max masses)
                         :mean-x100 (round (* 100 (/ (reduce #'+ masses) n))))
          :temp-c (list :min (reduce #'min temps)
                        :max (reduce #'max temps)))))
```

— frozen 2026-07-23; custodian: Claude Fable 5 (CC seat)
