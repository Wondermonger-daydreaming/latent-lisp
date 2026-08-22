;;;; act1-fixtures.lisp — One Act /1: the declared constants, the fixed store
;;;; nonce, the fixture worlds, and the environment pre-flight lists.
;;;;
;;;; Every value here is DECLARED.  Nothing is generated, read from a file,
;;;; derived from a name, or taken from the clock, the PID, or the filesystem.
;;;;
;;;; — PONTIFEX (Claude Opus 5, subagent), 2026-08-19

(in-package #:lisp-plus-language-act1)

;;; ===========================================================================
;;; The lane's declared constants.
;;; ===========================================================================

;;; The domain-separation string for One Act /1, version 0.  It enters the
;;; act-identity preimage as a TYPED CD/0 STRING VALUE, never as a prefix
;;; concatenated onto other octets.
(defparameter +act1-id-domain+ "lisp-plus/one-act-1/act-id/v0")

;;; The lane stem.  Separator-free.
(defparameter +act1-lane-stem+ "oneact1")

;;; ONE runtime process name for the whole in-process suite.  DECLARED, never
;;; derived: not from a fixture label, a seat name, an attempt name, a cell,
;;; the host PID, the directory, or the clock.  ⚠ The SPECIMEN declares its own
;;; per-life process names (specimen-common.lisp) precisely because it has more
;;; than one process life; this constant governs the single-process suite.
(defparameter +act1-runtime-process-name+ "actus-alter")

;;; The bind-offices minter constant.  SEPARATOR-FREE BY LAW: Core /0 renders
;;; the minter into (format nil "core0/sealed-ruling/~A/~D" minter ordinal), so
;;; a constant containing "/" would put a structural separator inside a name.
(defparameter +act1-bind-offices-minter+ "oneact1-office-r-derived")

;;; The request rendering version.  A later lane that changes any rule of the
;;; rendering changes this number, so a digest can never silently mean two
;;; things.
(defparameter +act1-request-rendering-version+ 1)

;;; ===========================================================================
;;; The fixed store nonce.
;;; ===========================================================================
;;;
;;; ⚠ THE RIDER, PRINTED AT THE FIXTURE AND NOT IN A FOOTNOTE:
;;;
;;;   PJ-META-1 UNPREDICTABILITY IS INTENTIONALLY NOT MET BY THIS STORE, AND
;;;   THIS STORE IS TEST INFRASTRUCTURE ONLY.  A fixed nonce is a predictable
;;;   store-id, and predictability is exactly the property PJ-META-1 exists to
;;;   provide.  The lane trades it away deliberately to buy byte-identical twin
;;;   runs, and claims NOTHING about this store's unpredictability, cross-host
;;;   uniqueness, or fitness outside this suite.
;;;
;;; Precedent, cited rather than re-argued: capability2's de-effectu-incerto
;;; declared exactly this deviation (specimen-common.lisp:81-87), as did One
;;; Act /0 (act0-fixtures.lisp:52-77).
(defparameter +act1-store-nonce+
  (make-array 16 :element-type '(unsigned-byte 8)
                 :initial-contents
                 '(#x6F #x6E #x65 #x61 #x63 #x74 #x31 #x2D     ; "oneact1-"
                   #x66 #x69 #x78 #x65 #x64 #x2D #x6E #x31))   ; "fixed-n1"
  "Exactly sixteen octets, written out literally, never generated.")

;;; ===========================================================================
;;; The fixture worlds for the in-process suite.
;;; ===========================================================================
;;;
;;; Cell NAMES are the public segment renderings of the resource identities
;;; (identifier-segment-string), which is exactly what
;;; capability2/attempt.lisp:214 computes before calling the adapter.

(defparameter +act1-apply-cells+
  '(("cella:prima"          . "")     ; arm A     — the settled act
    ("cella:vetita-scope"   . "")     ; arm B-L1  — never written: refused
    ("cella:vetita-ambient" . "")     ; arm B-L2  — never written: refused
    ("cella:revocata"       . ""))    ; arm R     — never written: D1 refused
  "The :apply-script world.  Every cell starts EMPTY, so the settled arm's
positive control on WORLD-CELL-VALUE (empty -> non-empty) is a real transition
and not an artefact of the initial value.")

(defparameter +act1-ambiguous-cells+
  '(("cella:ambigua" . ""))           ; arms C and C-2
  "The :ambiguous-script world: the acknowledgment carries no evidence, so the
attempt lands as :uncertain and the seat stays unresolved — which is what the
in-process durable-guard arm needs.")

;;; ===========================================================================
;;; W-ENV — the environment pre-flight for the SINGLE-PROCESS suite.
;;; ===========================================================================
;;;
;;; The suite (act1-selftest.lisp, act1-controls.lisp, act1-mutants.lisp)
;;; declares ONE PROCESS LIFE.  That declaration is a claim about the run, and
;;; the run must CHECK it: an environment variable that can end the process is
;;; a crash-model breach reachable from outside the code.  Any one set VOIDS
;;; the suite — it does not proceed, does not create a journal store, and does
;;; not report a pass.  A VOID IS NOT A FAILURE.
;;;
;;; ⚠ THE SPECIMEN IS EXEMPT BY CONSTRUCTION AND SAYS SO: de-actu-resurgente
;;; SETS CAP2_WORLD_DIE_IN_WINDOW for its first life on purpose.  The specimen
;;; stages therefore never call this pre-flight; the orchestrator passes the
;;; switch explicitly, per child, and the suite's pre-flight exists to keep
;;; that switch from leaking into any run that claims one process life.

(defparameter +act1-env-class-i+
  '("CAP2_WORLD_DIE_IN_WINDOW")
  "CLASS I — in a LOADED LIBRARY of this lane's stack (capability2/world.lisp:
239-244).  Set to \"1\", %world-apply-request calls (sb-ext:exit :code 7 :abort t)
AFTER the write is applied and ledgered and BEFORE the acknowledgment returns.
The only environment-controlled process death in a file this lane loads.")

(defparameter +act1-env-class-ii+
  '("ACT1_SELFTEST_PLANT_FAULT"       ; act1-selftest.lisp
    "ACT1_CONTROLS_PLANT_FAULT"       ; act1-controls.lisp
    "ACT1_RESTART_DIE"                ; de-actu-resurgente/stage-restart.lisp
    "CAP2_SELFTEST_PLANT_FAULT"       ; capability2/capability2-selftest.lisp:645
    "CAP2_CONTROLS_PLANT_FAULT"       ; capability2/capability2-controls.lisp:554
    "CAP2_CONTROLS_DIE"               ; capability2/capability2-controls.lisp:558
    "DE_EFFECTU_DIE")                 ; capability2/de-effectu-incerto/stage-restart.lisp:116
  "CLASS II — this lane's own three switches plus the four capability /2
switches reachable in this stack.  SEVEN, counted, not estimated.")

(defparameter +act1-env-class-iii-declared-out-of-stack+
  '("SURFACE2_*" "ADAPTER0_*" "VERTICAL0_*" "SA0_*" "LCI0_*"
    "DE_TESTE_OCCISO_DIE" "TITHE_FORCE_INDEX" "FORM2_FORCE_RED"
    "SURFACE1_SUBJECT_LABEL")
  "CLASS III — DECLARED OUT OF THIS LANE'S STACK and NOT asserted unset: this
lane loads capability2 + core0 and nothing else, so none of these files is
loaded here.  Named, never asserted — the boundary drawn by reading rather than
by silence.  A successor that DOES load one of those trees must EXTEND the
Class II list rather than re-derive it.")
