# PROGRAM /0 — grammar and semantics of the Lisp+ programming surface

**Standing: ADOPTED AND PUBLISHED** (ruled 2026-10-02) for the exact accepted object at public commit `a9fc64ae` (tree `11ee4de5`). This document is the specification of the lane; `program0.lisp` is its
reference executor. Under adopted law **W-02** (semantic-jurisdiction doctrine, Disposition
Instrument /0 C.1, adopted 2026-08-12 — `languagehood-and-succession-charter-0/RULING-R0.19-OWNER-DISPOSITION-INSTRUMENT-0-ADOPTED-2026-08-12.md`),
*the host executes the judge but does not supply the normative meaning of Lisp+ forms*, and
where a specification is candidate, silent, underdetermined or contradictory, *no adopted answer
may be inferred from the reference implementation*. So: what this document says is what a
PROGRAM /0 form means; what the executor does beyond this document is behaviour, not meaning,
and a reader may not cite it as law. This document was committed before the code that executes it — a choice of order, not a requirement W-02 imposes.

Commission: Astra (GPT-6), through the owner, 2026-09-23 late (docked at
`corpus/voices/received/2026-09-23-*-astra-COMMISSION-lisp-plus-programming-surface-*`). Built by
the desktop chair (Claude Fable 5.1). Standing attaches to object identities and dispositions,
never to a path (Owner Ruling 6 §3 B1).

## 0. What exists around this lane, and what is reused

| existing thing | where | reused how |
|---|---|---|
| the reader law | `language-many-acts-0/MANY-ACTS-0-GRAMMAR.md` §1b; `ma0-validate.lisp` `%ma0-read-source` | **by reference** (§1 below); one named difference: a source is a SEQUENCE of forms |
| the closed-heads rule | `ma0-validate.lisp` `+ma0-heads+` | special-form names cannot be bound (§3.1) |
| no truthiness in selection | `ma0-eval.lisp` header | `if`/`cond`/`and`/`or`/`not` accept only the two booleans (§4.4) |
| source-size bounds | `ma0-structures.lisp` `+ma0-max-source-depth+`, `+ma0-max-source-nodes+` | the same species, at EVALUATION: a step budget and a depth limit (§6) — **new**, and said so |
| Kernel /0 §7 determinacy | `kernel0/determinacy.lisp` `make-determinacy` | reached through its existing constructor (§7); refusals become values |
| the effect boundary | core0 `perform`; act0/act1; many-acts0 `act`/`derive` | **not loaded, not bound** (§7.3): a program cannot perform |
| the durable-data boundary | Kernel /0 records | a function value is refused at the bridge (§7.2); no closure is serialized |

Nothing in any of those lanes is modified. This lane is a new directory beside them.

## 1. Reading

A **source** is a UTF-8 text. It is read by Common Lisp `read`, one top-level form at a time,
under exactly these bindings, which are law here as they are in Many Acts /0:

- `*read-eval*` is **NIL** — `#.` dies at the reader (E-READ);
- `*package*` is **`lisp-plus-program0.source`**, a package that `:use`s nothing — every bare
  symbol a program writes is homed there and means only what §3–§5 say;
- `*read-default-float-format*` is `double-float`.

Whitespace and `;` comments between forms are skipped. Each top-level form is recorded with the
**line and column** (1-based line, 0-based column) at which it starts; that is the location an
error reports (§8). A reader failure is **E-READ** at the location of the form that failed.

**A source file that is not UTF-8 (2026-09-30).** The runner (§9) decodes a source file as UTF-8
before any form is read. If the file's bytes are not valid UTF-8, the whole file is refused,
**E-READ**, exit 2: nothing is evaluated, nothing is written to stdout, and the diagnostic is not
labelled a host fault. It names the file and claims no form location, because no form was read: no
`file:line:column`, and no `in:`, `within:` or `frames:` lines. It may give the byte offset of the
first invalid sequence where that is reliably available. Only a decoding failure is refused this way;
another failure to read the file (a file the process may not open, for example) is not E-READ. Valid
UTF-8 beyond ASCII is read as before. (Decided by the owner on 2026-09-30; his answer, verbatim:
"E-READ, exit 2 (Recommended)".)

**The end of the text (REPL /0 candidate, 2026-09-25 — a change to this lane, disclosed there).**
The reader distinguishes where the text ends. If it ends *between* forms — after whitespace, a `;`
comment, or a `#|…|#` comment — reading is complete. (Until this change a source ending in a
`#|…|#` comment was refused E-READ as if a form were unfinished; that was a defect.) If it ends
*inside* a form — an unclosed parenthesis, string, `|…|` escape or `#` dispatch — the refusal is
E-READ as before, rendered as before, and its condition is of the subclass
`program0-incomplete-source`, so an interactive reader can tell *unfinished* from *malformed* by
the reader's own verdict. A file runner sees no difference.

**Difference from Many Acts /0, named:** an MA0 source is exactly ONE form (V-SHAPE). A
PROGRAM /0 source is a **sequence of zero or more** top-level forms, evaluated in order (§5). An
empty source is lawful and has the value `()`.

**Source validation.** Right after each top-level form is read it is walked once — cycle-safely,
with a visited set and a node bound (`*max-source-nodes*`, 100,000 conses) — and refused if it holds
anything the language has no value for: a dotted pair (`(1 . 2)`), a vector (`#(1 2)`), a
character, a complex number, any other host object, or circular structure (`#1=(1 . #1#)`); each is
**E-READ** at the form's location, in bounded time. Acyclic *sharing* of a `#n=` label (`(#1=(1 2) #1#)`) is not a
cycle and is admitted; the walk distinguishes a node still being traversed from one already validated. This applies to quoted data too: `quote` cannot
smuggle a host object past the reader.

**Foreign symbols.** The bindings above do not prevent the reader from producing a symbol of
another package when a program writes one explicitly (`cl:eval`, `pkg::name`) or uses a reader
abbreviation that expands to one (`` `x ``, `#'f`). **Exactly one foreign symbol is admitted:
`common-lisp:quote`**, which the reader produces for the `'` abbreviation, and only as the **head** of a form (§4.2) — as a
datum (`'cl:quote`, `(list 'cl:quote)`) it is refused like any other foreign symbol.
Every other foreign symbol, in any position, quoted or not, is **E-SYNTAX** at source validation; so
`(cl:if true 1 2)` is refused — special-form heads other than `quote` are recognised **only in the
source namespace**. A prefix that names no package is a reader failure, **E-READ**. (Astra's
qualification of 2026-09-23 and her review of 2026-09-24, both recorded.)

**Host packages are not written by reading (2026-09-29).** A *host package* is every package in
the image except `lisp-plus-program0.source` and `KEYWORD`, where keyword values live, so a new
keyword is still an ordinary value. Every read runs with the host packages locked, and the guard
unlocks exactly the packages it locked, whatever the read's outcome. So the reader's own interning
cannot add a symbol to a host package. A name the host package does not already have never becomes
a foreign symbol. The reader refuses it, **E-READ**, before it exists, whether it is written as
`pkg::name`, inside `pkg::( … )`, or in a `#+`/`#-` feature expression. An existing foreign symbol is
read and refused at validation as above.

What is measured is the reader's own interning: one fresh name into every host package and each
route above, in the selftest. The guard restores the packages it locked. It does not undo other host
changes, so it relies on the reader running no host code that the source chooses. That is why
`#S` is refused (below).

Until this change such a name was interned first and refused afterwards, and distinct names
accumulated in `CL-USER` and in this implementation's own packages. Three behaviours changed:

1. `(cl-user::zzq 1)` is E-READ, not E-SYNTAX. The locked packages already gave E-READ for this
   (`cl::zzq`).
2. `#+cl-user::zzq 1` and `#-cl-user::zzq 42` are refused. They were the values `()` and 42.
3. `(list cl-user::zzq`, unfinished, is malformed (E-READ), not `program0-incomplete-source`.

Still true: the source namespace and `KEYWORD` grow with the names a program writes, refused or not.
The lock window is process-wide, so no other thread may intern while a read runs; the runner and
the REPL server are single-threaded. This is not a sandbox.

**`#S` is refused before anything is constructed (2026-09-29).** A source is read with the lane's
own readtable. It is a copy of the standard readtable in which an active `#S` or `#s` is refused,
**E-READ** at the form's location, at the dispatch itself: before the form after it is read, so no
host structure's constructor or slot initform runs, and its name is never read. The host's global
`*readtable*` is not modified, and every other syntax is the standard readtable's.

Reader-suppressed text is unchanged: `#+(or) #s(x)` and `#-sbcl #S(zzq)` read as nothing, and
`#+sbcl 1 #-sbcl #s(zzq)` reads as 1.

Before this change, `#s(pkg::name …)` naming a structure the host already has was **built during
the read**, running its constructor and slot initforms, and then refused as an unsupported datum.
That was E-READ too; the message has changed. Unfinished active `#S` (`#s(`, `(list #s`) was
`program0-incomplete-source` and is now malformed (E-READ).

`#S` was the only standard dispatch, apart from `#.` (dead above), that calls a host function the
source names. That rests on a reading of the standard `#` dispatch table of SBCL 2.4.6, not on a proof.

## 2. Values

A value is one of the kinds below. Only the two booleans belong to two kinds at once: they are also keywords (see the
boolean row).

| kind | written as | notes |
|---|---|---|
| number | `42`, `-7`, `1/3`, `2.5` | CL integers, ratios, double floats, as read; `/` on integers stays exact (`1/3`) |
| string | `"text"` | literal only; `string-append`, `string?`, `number->string`, `print` |
| keyword | `:mode`, `:determinate` | self-evaluating; used to address Kernel /0 schemas |
| symbol | obtained only by `(quote name)` / `'name` | prints lowercase |
| boolean | `true`, `false` (also `:true`, `:false`) | two distinct values; **nothing else is a boolean** (§4.4). They are the keywords `:true` and `:false`, kept as aliases: `(eq? :true true)` is true, `:true` renders as `true`, and `boolean?` and `keyword?` both answer true for either. No other keyword is a boolean: `(if :maybe 1 2)` is E-TYPE. (Clarified 2026-09-29 as the candidate's proposal, per Astra's review vote. **Decided by the owner 2026-09-30: the aliases are kept.**) |
| empty list | `()` | a value; **not** a boolean, **not** a name (`nil` is E-UNBOUND) |
| list | `(1 2 3)` | proper lists only; `cons` refuses a non-list second argument (E-TYPE) |
| function | `#<function name>`, `#<primitive +>` | closures (§4.3) and primitives (§5) — first-class values |
| refusal | `#<refused kind requirement R>` | a Kernel /0 refusal carried as a value (§7.1) |
| host value | `#<kernel0 determinacy>` | an object made by another lane through its own constructor; opaque (§7.1) |

Values print in this syntax (`render`). Functions, refusals and host values print as `#<…>`
descriptions that the reader would refuse, so printed output can never be mistaken for source.
The layout of a float's rendering (how many digits, whether an exponent is used) is not specified
at /0.

## 3. Names and environments

**3.1 Names.** A name is a symbol of the source namespace. The following may **not** be bound
as a variable, parameter or function name (E-SYNTAX): the special-form heads
`define lambda let if cond quote begin and or`; and the reserved words `true false else`.

**3.2 Environments.** An environment is a chain of **frames**; each frame maps names to values.
Lookup walks from the innermost frame outward; the innermost binding wins. That is the whole of
**lexical scope**: a name means what the nearest enclosing frame says, determined by where the
form was written, never by who called it.

**3.3 The frames of a run.** The **root** frame holds every primitive (§5) under its name, the
booleans, and every definition of the prelude (§5.2). A **program** runs in a fresh child of the
root. A function application makes a fresh child of the function's *defining* frame (§4.3).

**3.4 Binding once.** `define` binds a name in the **current** frame. Binding a name that is
already bound *in that same frame* is **E-REDEFINE**. Binding a name that is bound in an *outer*
frame is a **shadow** and is lawful — so a program may define its own `map`; it may not define
`map` twice. There is no assignment. No form changes an existing binding.

## 4. Forms

**4.1 Atoms.** A number, string or keyword evaluates to itself. `()` evaluates to the empty list.
A source-namespace symbol evaluates to its binding, or **E-UNBOUND**. Any other symbol is
**E-SYNTAX**. Any other object is E-SYNTAX. An improper list is E-SYNTAX.

**4.2 Special forms** — recognised by the *name* of the head **when the head is a symbol of the
source namespace**, plus the one admitted foreign head `common-lisp:quote` (`'x` reads as
`(common-lisp:quote x)` and is `quote`). A foreign head such as `cl:if` is not a special form; it is
refused at source validation (§1). The closed set:

| form | meaning |
|---|---|
| `(quote d)` | the datum `d`, unevaluated |
| `(define name expr)` | evaluate `expr`, bind `name` in the current frame (§3.4); value: the name |
| `(define (name p…) body…)` | bind `name` to a closure of parameters `p…` and `body…` over the current frame (§4.3); value: the name |
| `(lambda (p…) body…)` | a closure over the current frame; anonymous |
| `(let ((n e)…) body…)` | evaluate every `e` in the **current** frame, then bind all `n` in one fresh child frame and evaluate `body…` there (parallel `let`) |
| `(if test then else)` | evaluate `test`; it must be a boolean (§4.4); evaluate exactly one branch; `else` is **required** |
| `(cond (test body…)… (else body…))` | evaluate tests in order; the first `true` selects its body; `else` always selects; if nothing selects, **E-TYPE** ("fell through") |
| `(begin form…)` | evaluate in order; value: the last |
| `(and form…)` / `(or form…)` | short-circuit over booleans only; `(and)` is `true`, `(or)` is `false` |

A special form with the wrong number or shape of parts is **E-SYNTAX**.

**The clarification card (2026-10-01).** The rules marked **Card 1** to **Card 6**, here and in
§5.1, record six choices the earlier text left open. Astra (GPT-6) recommended them as one coherent
/0 choice, in the table at
`corpus/voices/received/originals/2026-09-30-220019-astra-program-repl-0-dossier-r2-disposition/02-OWNER-DECISION.md`.
Decided by the owner on 2026-10-01; his answer, verbatim: "Accept all six as recommended (Recommended)".

**Card 2:** `begin`, `lambda`, `let` and each `cond` clause require a body form, and `cond` requires a
clause. The named omissions, `(begin)`, `(cond)`, `(cond (true))`, `(lambda (x))` and
`(let ((x 1)))`, are E-SYNTAX (for `(cond)`, not E-TYPE). **Card 3:** `(define (f x x) x)` and
`(lambda (x x) x)` are E-SYNTAX when evaluated, before any call (not E-REDEFINE).

**4.3 Functions and application.** A **closure** is (parameters, body, defining frame, name).
Applying a closure to arguments: the count must equal the parameter count (**E-ARITY**, naming
the function); a fresh frame whose parent is the closure's **defining** frame binds each
parameter; the body is evaluated there in order; the value is the last form's. Because the parent
is the defining frame, a closure that outlives the frame it was made in still sees that frame's
bindings — that is **capture**. `define` inside a body binds in the body's frame, so local
helpers, including recursive ones, are written with `define`.

Application of a non-special form `(f a…)`: evaluate `f`, then each `a` left to right, then apply.
If the value of `f` is not a function, **E-TYPE**.

**4.4 No truthiness.** The only values admitted in a test position (`if`, `cond` tests, `and`,
`or`, `not`) are `true` and `false`. A number, a list, `()` or any other value there is
**E-TYPE**. The language has no falsy values and no implicit conversion.

## 5. Primitives and the prelude

**5.1 Primitives** (bound in the root frame; each checks its arguments and fails with the codes
of §8; no host condition escapes as a host condition):

- arithmetic: `+ - * / quotient mod abs max min` — numbers only (E-TYPE); `/` by a zero of any
  number type (`0`, `0.0`) is **E-ARITH**, located. `quotient`/`mod` take integers only, checked
  before the zero: a float zero there is E-TYPE (`(mod 5 0.0)`), an integer zero E-ARITH
  (`(mod 5 0)`). Every host arithmetic condition that the host actually **signals** (overflow,
  underflow, invalid operation) is **E-ARITH**, located. This does not require the host to trap
  every floating-point exception: a result it returns without signalling, such as an underflow to
  `0.0`, is a value, not a breach. A synthetic signalled condition may witness the handler, labelled
  as synthetic, never as a natural underflow. **Card 1:** `max` and `min` take one or more numbers,
  so zero arguments is E-ARITY.
- comparison: `= < > <= >=` (numbers, variadic, chained); `equal?` (structural); `eq?`. **Card 6:**
  `eq?` identity is guaranteed for symbols, keywords, booleans and the empty list, so `(eq? () ())`
  is true. Identity guarantees for numbers, strings, nonempty lists, functions, refusals and other
  host values are unspecified at /0: neither answer is promised. `equal?` compares numbers
  numerically across representations, strings by their characters, and proper lists recursively:
  `(equal? 1 1.0)` is true and `(equal? 1 2.0)` is false. On symbols, keywords, booleans and the
  empty list, `equal?` applies the corresponding scalar identity; no portable identity promise is
  added for functions or host objects.
- booleans: `not`
- lists: `cons car cdr list length append reverse null? pair? list?` — `car`/`cdr` of `()` is
  E-TYPE, never a silent value. These are list operations: a string is not a list (`(length "abc")`
  is E-TYPE). **Card 1:** `append` takes zero or more lists, so zero returns `()`. **Card 4:**
  `(pair? ())` is false, and `(list? ())` is true.
- kinds: `number? integer? boolean? symbol? string? function? keyword? host-value? refused?`.
  **Card 5:** `integer?` recognizes integer representation: `3` is true, and `3.0` is false.
- strings/output: `string-append number->string print` — `print` writes its arguments separated
  by spaces (strings unquoted) and a newline, and returns its last argument
- the Kernel /0 bridge (§7): `kernel0/determinacy kernel0/determinacy-mode refusal-requirement
  refusal-law refusal-kind`

**5.2 The prelude** is `prelude.lp`, written in Lisp+ and evaluated into the root frame before any
program. It defines, as ordinary functions: `map filter fold fold-right for-each range iota
repeat sum product any? all? count-if compose identity constantly square even? odd? zero?
positive? negative? nth take drop last zip`. They recurse, so they are subject to §6.

## 6. Termination: the budget

The existing lanes terminate **by shape**: Many Acts /0 has no loop or recursion head, and its
bounds are on the *size of the source*. **Unrestricted recursion** is what motivates an execution
budget: once a function may call itself, no property of the source's shape bounds the run —
`(define (f) (f)) (f)` is the smallest program that would run forever. PROGRAM /0 therefore declares
an **evaluation budget**, of the same species as the source bounds and new at this level:

- `*step-budget*` — evaluation steps admitted to one run (default **1,000,000**; every evaluated
  form is one step);
- `*depth-limit*` — nested user-function applications admitted (default **4,000**). It bounds the
  **depth of nested calls**, not the length of a program or of a list; a recursive traversal of a long
  list reaches it only because each element costs one nested call (no tail-call elimination).

Exhausting either is **E-BUDGET**, a located refusal that names the ceiling that spoke. The
runner requests a 64 MB host control stack so that the language's ceiling is reached before the
host's; if the host nonetheless exhausts storage first, that too is reported as E-BUDGET.

**Consequences, stated:** there is no tail-call elimination; `map`/`filter`/`fold` over a list
longer than the depth limit are refused, not processed. The numbers are policy. Changing them is
a change to this document.

**Erratum (2026-09-30).** This section's meaning is unchanged: a step budget of N admits N steps.
The reference executor had admitted N−1, refusing the N-th; the repair of 2026-09-30 (dossier r2)
corrects it to admit N.

## 7. The bridges and the boundaries

**7.1 Kernel /0, a derivation.** `(kernel0/determinacy k v …)` calls
`lisp-plus-kernel0:make-determinacy` with the keyword arguments as given. If the kernel
constructs the record, the value is a **host value** of kind `determinacy`;
`kernel0/determinacy-mode` returns its mode through the kernel's own accessor. If the kernel
signals a `kernel0-condition`, the value is a **refusal** carrying a `kind` (below), the kernel's
`requirement` id (e.g. `"K0E-33"`), `law` text, offending field and value. A refusal is not an
error of this language: the program asked the kernel and this is the answer, and `refused?`,
`refusal-requirement`, `refusal-law`, `refusal-kind` let the program compute over it.
Constructing a record performs nothing.

A refusal's **kind** is an opaque identifier of its category. `refusal-kind` returns it as a string,
the same text as the *kind* in the refusal's rendering (`#<refused kind requirement R>`, §2). It is
not a portable name of any host class, and /0 promises nothing about its spelling beyond that
agreement.

**The accessors take their operand by kind.** `kernel0/determinacy-mode` needs a determinacy host
value; `refusal-requirement`, `refusal-law` and `refusal-kind` need a refusal. Any other operand,
a function included, is **E-TYPE**, not E-BOUNDARY: §7.2's E-BOUNDARY concerns the arguments of a
Kernel /0 constructor.

**7.2 The durable-data boundary.** Only keywords, numbers, strings and proper lists of those may
be handed to a Kernel /0 constructor. A closure, a primitive, a refusal or a host value in that
position is **E-BOUNDARY**. No function value is ever serialized by this lane, and none can reach a
record.

**7.3 The effect boundary.** The runner loads Kernel /0 and this lane only. Core /0 (`perform`),
One Act /0 and /1, and Many Acts /0 (`act`, `derive`, `branch`) are **not loaded**; the names
`perform`, `act`, `derive` are unbound in every program (E-UNBOUND). The boundary is an absence;
the selftest witnesses it (no `lisp-plus-core0`, `lisp-plus-many-acts0` or
`lisp-plus-language-act0` package in the image). Deriving and performing therefore cannot be
confused in this lane because only deriving exists in it.

## 8. Errors

One condition, `program0-error`, with a **closed** code vocabulary:

| code | meaning |
|---|---|
| `E-READ` | the reader refused the source |
| `E-SYNTAX` | a form is not well-shaped for its operator, or a symbol is not a name of this language |
| `E-UNBOUND` | a name has no binding |
| `E-REDEFINE` | a name is already bound in this frame |
| `E-ARITY` | a function was applied to the wrong number of arguments |
| `E-TYPE` | a value has the wrong kind for the operation |
| `E-ARITH` | an arithmetic operation is undefined for its arguments |
| `E-BUDGET` | the evaluation budget (steps or depth) is exhausted |
| `E-BOUNDARY` | a value may not cross into the host or into a Kernel /0 record |

An error carries: the code; a message; the **location** `file:line:column` of the top-level form
under evaluation; the innermost forms being evaluated (up to three, innermost first); and the
user-function **frames** (innermost first). The runner prints all of these to stderr and exits 2.
The one exception is the file-level E-READ of §1 (a source file that is not UTF-8): it names the
file and carries no form location, forms or frames. The wording of a message, including any host text it
quotes (an E-READ message may quote the host reader's), is not specified.
**Limitation, named:** positions are per top-level form, not per sub-form.

## 9. The runner

`bash mneme/language-program-0/lisp-plus-run.sh <program.lp>` (equivalently
`sbcl --control-stack-size 64MB --script mneme/language-program-0/run.lisp <program.lp>`) reads
the file under §1, evaluates its forms in order in a fresh program frame (§3.3), prints to stdout
the rendered value of the **last** form (a definition prints as `; defined name`), and exits:
`0` value · `2` language error (stderr) · `3` usage (no file / no such file / a directory) · `1`
host fault (a condition that is none of §8 — an implementation defect, named as such). Stdout carries only the
program's `print` output and its final value; load chatter goes to stderr. User expressions are
never handed to `cl:eval`. Declared environment: SBCL 2.4.6 on Linux; the runner refuses any
other SBCL version.

**A directory is usage (2026-09-30).** A path that names a directory, with or without a trailing
slash, is refused as usage before any read of it is attempted: exit 3, nothing on stdout, and a
diagnostic on stderr that names the path and uses the word *directory*, not labelled a host fault.
(Decided by the owner on 2026-09-30; his answer, verbatim: "Usage error, exit 3 (Recommended)".)
A source file that is not UTF-8 is E-READ, exit 2 (§1).

**The argument is a file path (2026-09-30).** The runner reads its argument as the host's native file path, and no
character in it is special: a path containing `?`, `*` or `[` names the file it spells, and is run, refused as usage
or refused as a directory like any other. (Decided by the owner on 2026-09-30; his answer, verbatim: "Fix it in r2 as
F-6 (Recommended)".)

**Two runner limitations, recorded (2026-10-01; Astra's r2 disposition §4, items 1–2).** Nothing above is redefined.
- **An unreadable file.** A file the runner may not read (permission denied) exits `1` today, with the host-fault
  wording. This is an exception to the explanation of exit `1` above: it is an acknowledged runner
  limitation, and that wording does not prove an implementation defect. It is not E-READ (§1), and the general
  taxonomy of filesystem errors is not settled at /0; a future usage/IO policy may refine it.
- **An empty argument.** `""` exits `3`, as usage. Its diagnostic calls it a directory, and that imprecise wording is
  a recorded diagnostic limitation.

## 10. Not in this lane (so nobody infers it)

Assignment and mutation · tail-call elimination · error handling inside a program (only Kernel /0
refusals are values) · macros · strings beyond §5.1 · vectors, tables, characters · input · any
effect · any act · serialization of any program value · sub-form source positions · a REPL.
Each is a possible later lane with its own proposition; none may be read into this one.
