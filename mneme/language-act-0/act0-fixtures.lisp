;;;; act0-fixtures.lisp — One Act /0: F-STORE, the fixture worlds, W-ENV.
;;;;
;;;; Every value here is DECLARED.  Nothing is generated, read from a file,
;;;; derived from a name, or taken from the clock, the PID, or the filesystem
;;;; (contract V-4, V-7).
;;;;
;;;; — FABER-I (Claude Opus 5, subagent), 2026-08-07

(in-package #:lisp-plus-language-act0)

;;; ===========================================================================
;;; The lane's declared constants.
;;; ===========================================================================

;;; Contract ACT-3(i) / ACT-5.  The domain-separation string for One Act /0,
;;; version 0.  It enters the preimage as a TYPED CD/0 STRING VALUE, never as a
;;; prefix concatenated onto other octets (ACT-2, the ambiguous-concatenation
;;; prohibition).
(defparameter +act-id-domain+ "lisp-plus/one-act-0/act-id/v0")

;;; The owner-minted lane stem (ruling R0.1 §4).  Separator-free, as §2.4 A-4
;;; requires of the bind-offices minter constant.
(defparameter +lane-stem+ "oneact0")

;;; Contract ACT-9a.  ONE runtime process name for the whole run, because the
;;; lane is ONE journal-backed process running SEVEN SEATS.  A lane-owned
;;; WORKING name (§10) — the owner minted the lane name, directory, ASDF system,
;;; package and stem, and nothing else.  DECLARED, never derived: not from a
;;; fixture label, a seat name, an attempt name, a cell, the host PID, the
;;; directory, or the clock (ACT-9a-3; V-7 forbids a PID in compared bytes and
;;; these two fields ARE compared bytes).  NOT a derivation input (ACT-3 names
;;; exactly three and this is not among them).
(defparameter +runtime-process-name+ "actus")

;;; The lane's own event-id namespace (contract J-7c).  A lane-owned working
;;; name under §10.
(defparameter +lane-event-namespace+ "act-event")

;;; Contract §2.4 A-4.  SEPARATOR-FREE BY LAW: Core /0 renders the minter into
;;; (format nil "core0/sealed-ruling/~A/~D" minter ordinal), so a constant
;;; containing "/" would put a structural separator inside a name.
(defparameter +bind-offices-minter+ "oneact0-office-r-derived")

;;; Contract J-9-1: the bind-offices version, 0 in /0.
(defparameter +bind-offices-version+ 0)

;;; Contract V-REQ-2: the request rendering version.  A later lane that changes
;;; any rule of the rendering changes this number, so a digest can never
;;; silently mean two things.
(defparameter +request-rendering-version+ 1)

;;; ===========================================================================
;;; F-STORE — the fixed store nonce (contract §14.1, V-5/V-6; specimen §2.1a).
;;; ===========================================================================
;;;
;;; ⚠ THE RIDER, PRINTED AT THE FIXTURE AND NOT IN A FOOTNOTE (contract V-6,
;;; specimen FS-02):
;;;
;;;   PJ-META-1 UNPREDICTABILITY IS INTENTIONALLY NOT MET BY THIS STORE, AND
;;;   THIS STORE IS TEST INFRASTRUCTURE ONLY.  A fixed nonce is a predictable
;;;   store-id, and predictability is exactly the property PJ-META-1 exists to
;;;   provide.  The lane trades it away deliberately to buy byte-identical twin
;;;   runs (GATE-11), and claims NOTHING about this store's unpredictability,
;;;   cross-host uniqueness, or fitness outside this suite.  The writer's own
;;;   fallback branch says as much in its own words (journal0/writer.lisp:66-68);
;;;   this is the lane taking that branch on purpose and saying so.
;;;
;;; Without it, create-journal defaults the nonce to %random-nonce, which reads
;;; /dev/urandom (journal0/writer.lisp:57-70, 126-128) — a different store-id,
;;; different prefix digests, different authorization receipts and different
;;; frame bytes on EVERY run.
(defparameter +act-store-nonce+
  (make-array 16 :element-type '(unsigned-byte 8)
                 :initial-contents
                 '(#x6F #x6E #x65 #x61 #x63 #x74 #x30 #x2D    ; "oneact0-"
                   #x66 #x69 #x78 #x65 #x64 #x2D #x6E #x30))  ; "fixed-n0"
  "Exactly sixteen octets, written out literally, never generated (FS-01/FS-03).")

;;; ===========================================================================
;;; F-WORLD — the two Capability /2 world fixtures (specimen §2.1).
;;; ===========================================================================
;;;
;;; Two worlds, because the script is fixed at construction
;;; (capability2/world.lisp:137,150) and arm C-i needs :ambiguous.
;;;
;;; Cell NAMES are the public segment renderings of the resource identities
;;; (identifier-segment-string), which is exactly what
;;; capability2/attempt.lisp:214 computes before calling the adapter.

(defparameter +world-apply-cells+
  '(("cella:prima"          . "")    ; arm A
    ("cella:amissa"         . "")    ; arm C-ii  (never written: request lost)
    ("cella:revocata"       . "")    ; arm B-R   (never written: refused)
    ("cella:vetita-scope"   . "")    ; arm B-L1  (never written: refused)
    ("cella:vetita-ambient" . ""))   ; arm B-L2  (never written: refused)
  "⚠ \"cella:fracta\" (arm D) is DELIBERATELY ABSENT.  Its absence is what makes
CAP2-WORLD-4 fire POST-frontier (contract I-2), which is the whole of arm D.
⚑ H-CELL-1: B-L1 and B-L2 hold DISTINCT cells; the pre-R1 fixture gave both
\"cella:vetita\", and two acts sharing one cell is arbitrated by CAP2-AUTH-2 on
the capability RESOURCE, not by seat (capability2/authorize.lisp:161-168).")

(defparameter +world-ambiguous-cells+
  '(("cella:ambigua" . ""))          ; arm C-i, script :ambiguous
  "The :ambiguous-script world: the acknowledgment carries no evidence.")

;;; ===========================================================================
;;; W-ENV — the environment pre-flight (contract §14.2, V-8..V-11).
;;; ===========================================================================
;;;
;;; §7.1 declares ONE PROCESS LIFE, NO PROCESS DEATH.  That declaration is a
;;; claim about the run, and the run must CHECK it: an environment variable that
;;; can end the process is a crash-model breach reachable from outside the code.
;;; Any one set VOIDS the run (V-8, WE-04) — the run does not proceed, does not
;;; create a journal store, and does not report a pass.  A VOID is not a failure
;;; of the specimen.

(defparameter +w-env-class-i+
  '("CAP2_WORLD_DIE_IN_WINDOW")
  "CLASS I — in a LOADED LIBRARY of this lane's stack (capability2/world.lisp:
239-244).  Set to \"1\", %world-apply-request calls (sb-ext:exit :code 7 :abort t)
AFTER the write is applied and ledgered and BEFORE the acknowledgment returns —
INSIDE the frontier window, which is precisely the state §7.1 says this lane
never enters.  The only environment-controlled process death in a file this
lane loads.")

(defparameter +w-env-class-ii+
  '("CAP2_SELFTEST_PLANT_FAULT"        ; capability2/capability2-selftest.lisp:645
    "CAP2_CONTROLS_PLANT_FAULT"        ; capability2/capability2-controls.lisp:554
    "CAP2_CONTROLS_DIE"                ; capability2/capability2-controls.lisp:558
    "DE_EFFECTU_DIE"                   ; capability2/de-effectu-incerto/stage-restart.lisp:116
    "DE_TESTE_OCCISO_DIE"              ; journal0/de-teste-occiso/stage-recover.lisp:82
    "SURFACE2_SELFTEST_PLANT_FAULT"    ; language-surface-2/surface2-selftest.lisp:460
    "SURFACE2_SELFTEST_DIE"            ; language-surface-2/surface2-selftest.lisp:464
    "SURFACE2_CONTROLS_PLANT_FAULT"    ; language-surface-2/surface2-controls.lisp:651
    "SURFACE2_CONTROLS_DIE"            ; language-surface-2/surface2-controls.lisp:655
    "SURFACE2_ERRATUM_PLANT_FAULT"     ; language-surface-2/surface2-erratum-binder.lisp:231
    "SURFACE2_ERRATUM_DIE"             ; language-surface-2/surface2-erratum-binder.lisp:235
    "SURFACE2_INHABITED_PLANT_FAULT"   ; language-surface-2/surface2-inhabited.lisp:455
    "SURFACE2_INHABITED_DIE")          ; language-surface-2/surface2-inhabited.lisp:459
  "CLASS II — thirteen suite-file switches, which matter because GATE-9 re-runs
those suites in this same session.  ⚠ THIRTEEN, counted: the bundle's own matrix
once said \"six further switches\", which was an estimate that read as a count
(contract V-10).")

;;; CLASS III — DECLARED OUT OF THIS LANE'S STACK, enumerated in the contract
;;; (V-9) so the exclusion is checkable rather than assumed, and NOT asserted
;;; unset here: the ADAPTER0_* switches (FS-6 forbids this lane from even
;;; depending on lisp-plus/adapter0), the VERTICAL0_*, SA0_* and LCI0_*
;;; switches, and TITHE_FORCE_INDEX / FORM2_FORCE_RED / SURFACE1_SUBJECT_LABEL.
;;; A successor that DOES load one of those trees must EXTEND this list rather
;;; than re-derive it.
(defparameter +w-env-class-iii-declared-out-of-stack+
  '("ADAPTER0_*" "VERTICAL0_*" "SA0_*" "LCI0_*"
    "TITHE_FORCE_INDEX" "FORM2_FORCE_RED" "SURFACE1_SUBJECT_LABEL")
  "Named, never asserted — the boundary drawn by reading rather than by silence.")
