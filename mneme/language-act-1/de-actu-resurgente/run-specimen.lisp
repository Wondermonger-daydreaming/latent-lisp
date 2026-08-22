;;;; run-specimen.lisp — de-actu-resurgente: the act that rises again.
;;;;
;;;; "The language door survives the process's death as a refusal: a genuinely
;;;;  new image, given only durable bytes and declared configuration, must
;;;;  refuse the same act at the `perform` boundary — and may proceed only
;;;;  through evidence-carried reconciliation at the runtime level."
;;;;
;;;; This runner is the ORCHESTRATOR and artifact preserver.  It:
;;;;   1. launches the PRIMA VITA as a SEPARATE process with
;;;;      CAP2_WORLD_DIE_IN_WINDOW=1: grant → derived identity → one bridge →
;;;;      perform → the world durably applies and ledgers the write → THE
;;;;      PROCESS DIES IN THE ACKNOWLEDGMENT WINDOW (exit 7, no RESULT sentinel;
;;;;      the parent demands exactly that pair);
;;;;   2. digests the survivors and exhibits THE ASYMMETRY: the world knows
;;;;      (cell written, one ledger entry); the journal does not (three frames,
;;;;      ending at frontier-crossed); and the Core /0 evidence is simply gone;
;;;;   3. runs the TRUNCATED-RESTART negative control (an aborted restart exits
;;;;      3 with no sentinel and writes nothing);
;;;;   4. runs the LEAK COMPETENCE CONTROL on COPIES — a refused act that writes
;;;;      the world — and proves the real state byte-identical afterwards;
;;;;   5. launches the REDIVIVA — a genuinely new process over durable bytes +
;;;;      declared configuration — whose verdicts are relayed and renumbered
;;;;      here: identity re-derived, the same act REFUSED pre-frontier with
;;;;      durable provenance, the disguised retry refused identically, the
;;;;      uncertainty structured, reconciliation :applied with evidence, and a
;;;;      fresh act settled on the freed seat;
;;;;   6. proves the final journal is a BYTE-PREFIX EXTENSION of the post-death
;;;;      journal (nothing rewritten), and that the world moved only by the
;;;;      fresh act;
;;;;   7. preserves the raw bytes as tracked ARTIFACT-* files — including all
;;;;      THREE journal states — with a SHA256SUMS manifest.
;;;;
;;;; The orchestrator never authorizes, dispatches, refuses, or reconciles.
;;;;
;;;; Run:  sbcl --script mneme/language-act-1/de-actu-resurgente/run-specimen.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; DETERMINISM: no pid, timestamp, absolute path, or random identity is
;;;; printed; the store nonce is fixed (declared PJ-META-1 deviation,
;;;; specimen-common.lisp), every identity is declared charge — so every digest
;;;; below is byte-stable across runs.
;;;;
;;;; ENVIRONMENT HYGIENE: each stage child is launched with an environment this
;;;; runner BUILDS — the parent's environment is filtered of every switch in the
;;;; lane's Class I and Class II lists, and only the switch a given phase
;;;; intends is added back.  A leaked death switch would make a later phase lie.
;;;;
;;;; — PONTIFEX (Claude Opus 5, subagent), 2026-08-19

(load (merge-pathnames "specimen-common.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-language-act1)

(defvar *checks* 0)
(defvar *failures* 0)

(defun scheck (description thunk)
  (incf *checks*)
  (let ((description (format nil description))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "[~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))
    (finish-output)))

(defun snote (control &rest arguments)
  (apply #'format t control arguments)
  (terpri)
  (finish-output))

(defun fresh-directory (pathname)
  (when (probe-file pathname)
    (sb-ext:delete-directory pathname :recursive t))
  (ensure-directories-exist pathname))

(defun copy-directory (from to)
  "A flat byte copy of a state directory (both the store and the world are flat
directories of a few files)."
  (fresh-directory to)
  (dolist (source (directory (merge-pathnames "*.*" from)))
    (sp-write-octets (merge-pathnames (file-namestring source) to)
                     (sp-read-octets source)))
  to)

(defun store-octets (name &optional (directory *scratch-store*))
  (sp-read-octets (merge-pathnames name directory)))

(defun world-octets (name &optional (directory *scratch-world*))
  (sp-read-octets (merge-pathnames name directory)))

;;; ---------------------------------------------------------------------------
;;; Stage-child relay, with a BUILT environment.

(defun clean-environment (&rest additions)
  "The parent's environment MINUS every switch this lane knows can end or
divert a process, PLUS exactly what this phase intends."
  (let ((switches (append +act1-env-class-i+ +act1-env-class-ii+)))
    (append additions
            (remove-if (lambda (entry)
                         (let ((equals (position #\= entry)))
                           (and equals
                                (member (subseq entry 0 equals) switches
                                        :test #'string=))))
                       (sb-ext:posix-environ)))))

(defun run-stage (script label &key environment)
  "Launch SCRIPT as a genuinely separate `sbcl --script` process.  Relays its
NOTE lines, renumbers its CHECK lines into this runner's verdict stream, and
returns (values exit-code saw-result-sentinel-p raw-text)."
  (let* ((output (make-string-output-stream))
         (process (sb-ext:run-program
                   "sbcl"
                   (list "--script"
                         (concatenate 'string
                                      "mneme/language-act-1/de-actu-resurgente/"
                                      script)
                         (namestring (first environment))
                         (namestring (second environment))
                         (namestring (third environment)))
                   :search t :output output :error output
                   :environment (apply #'clean-environment (fourth environment))))
         (text (get-output-stream-string output))
         (saw-result nil))
    (with-input-from-string (stream text)
      (loop for line = (read-line stream nil nil)
            while line
            do (cond
                 ((and (>= (length line) 9) (string= "CHECK ok " (subseq line 0 9)))
                  (incf *checks*)
                  (format t "[~3,'0d] ok   (~a) ~a~%" *checks* label (subseq line 9)))
                 ((and (>= (length line) 11) (string= "CHECK FAIL " (subseq line 0 11)))
                  (incf *checks*) (incf *failures*)
                  (format t "[~3,'0d] FAIL (~a) ~a~%" *checks* label (subseq line 11)))
                 ((and (>= (length line) 5) (string= "NOTE " (subseq line 0 5)))
                  (format t "      | ~a~%" (subseq line 5)))
                 ((and (>= (length line) 7) (string= "RESULT:" (subseq line 0 7)))
                  (setf saw-result t)
                  (format t "      | ~a~%" line))
                 ((zerop (length line)) nil)
                 (t (format t "      | ~a~%" line)))))
    (finish-output)
    (values (sb-ext:process-exit-code process) saw-result text)))

(defun stage-arguments (store world run &optional additions)
  (list store world run additions))

;;; ---------------------------------------------------------------------------
;;; Phase 0 — a clean world.

(fresh-directory *scratch-store*)
(fresh-directory *scratch-world*)
(fresh-directory *scratch-run*)

(snote "de-actu-resurgente — the act that rises again.")
(snote "governing sentence: the language door survives the process's death as ~
a refusal — a genuinely new image, given only durable bytes and declared ~
configuration, must refuse the same act at the `perform` boundary, and may ~
proceed only through evidence-carried reconciliation at the runtime level.")
(snote "CANDIDATE.  Nothing here is adopted, and nothing here is independent ~
verification.  Crash model: PLANTED DETERMINISTIC death (an env-var exit inside ~
capability /2's world adapter).  NO SIGKILL, no power loss, no mid-instruction ~
truncation is claimed — journal0/de-teste-occiso and vertical0 own the real ~
crash windows.  Capability-DISCIPLINED, never capability-secure.~%")

;;; ---------------------------------------------------------------------------
;;; Phase 1 — the first life dies in the acknowledgment window.

(snote "== phase 1 — the first life (separate process; dies in the ~
acknowledgment window, after the dispatch durably lands) ==")

(multiple-value-bind (code sentinel text)
    (run-stage "stage-life-1.lisp" "prima-vita"
               :environment (stage-arguments *scratch-store* *scratch-world*
                                             *scratch-run*
                                             '("CAP2_WORLD_DIE_IN_WINDOW=1")))
  (scheck "the first life DIED IN THE WINDOW as planted: exit code 7, NO ~
RESULT sentinel, and the adapter's own dying note in the transcript — the ~
dispatch was applied and ledgered; the acknowledgment never came home"
          (lambda () (and (eql 7 code) (not sentinel)
                          (search "dying in the acknowledgment window" text)))))

;;; ---------------------------------------------------------------------------
;;; Phase 2 — the survivors, digested: the asymmetry.

(snote "~%== phase 2 — the surviving durable bytes: the world knows; the ~
journal does not; the language's own account is gone ==")

(defvar *events-post-death* (store-octets "EVENTS.pj0"))
(defvar *events-post-death-sha* (sha256-hex *events-post-death*))
(defvar *metadata-octets* (store-octets "JOURNAL-META.pjs"))
(defvar *sidecar-octets* (store-octets "JOURNAL-META.pjs.sha256"))
(defvar *cells-post-death* (world-octets "CELLS.txt"))
(defvar *cells-post-death-sha* (sha256-hex *cells-post-death*))
(defvar *ledger-post-death* (world-octets "REQUEST-LEDGER.txt"))
(defvar *ledger-post-death-sha* (sha256-hex *ledger-post-death*))
(defvar *identity-octets* (sp-read-octets (act-identity-path *scratch-run*)))
(defvar *identity-sha* (sha256-hex *identity-octets*))

(scheck "the surviving journal validates :valid with exactly 3 frames — grant ~
· attempt:prepared · attempt:frontier-crossed — and NOTHING after the ~
frontier: no acknowledgment, no settlement, no uncertainty record.  The ~
process died before it could account for its own effect"
        (lambda ()
          (multiple-value-bind (kinds count status tail)
              (act1-journal-kinds (open-store *scratch-store*))
            (and (eq :valid status) (= 3 count) (null tail)
                 (equal kinds '("capability0:granted" "attempt:prepared"
                                "attempt:frontier-crossed"))))))

(scheck "THE ASYMMETRY, in bytes: the surviving WORLD holds the written cell ~
and exactly ONE applied ledger entry under the journaled external-request ~
identity — the effect HAPPENED; only the record of its happening died"
        (lambda ()
          (let ((world (open-world *scratch-world* :script :apply)))
            (and (equal *first-text* (world-cell-value world *cell-name*))
                 (= 1 (world-ledger-count world))
                 (= 1 (world-ledger-count
                       world (external-request-key *first-attempt*)))))))

(scheck "the language's own identity survives as a DERIVATION the restart can ~
recompute — the preserved file names a 64-hex act identity under this lane's ~
stem, and nothing else of the language side survived at all"
        (lambda ()
          (let ((text (sp-octets-string *identity-octets*)))
            (and (search "oneact1:act:" text) (> (length text) 64)))))

(snote "EVENTS.pj0 (as the death left it): ~a octets · sha256 ~a"
       (length *events-post-death*) *events-post-death-sha*)
(snote "WORLD CELLS.txt: ~a octets · sha256 ~a"
       (length *cells-post-death*) *cells-post-death-sha*)
(snote "WORLD REQUEST-LEDGER.txt: ~a octets · sha256 ~a"
       (length *ledger-post-death*) *ledger-post-death-sha*)
(snote "ACT-IDENTITY.txt: ~a octets · sha256 ~a"
       (length *identity-octets*) *identity-sha*)

;;; ---------------------------------------------------------------------------
;;; Phase 3 — negative control FIRST (it writes nothing): a truncated restart.

(snote "~%== phase 3 — negative control: the truncated restart ==")

(multiple-value-bind (code sentinel text)
    (run-stage "stage-restart.lisp" "truncated-control"
               :environment (stage-arguments *scratch-store* *scratch-world*
                                             *scratch-run*
                                             '("ACT1_RESTART_DIE=1")))
  (scheck "a restart process TRUNCATED mid-run is detected by this runner: the ~
child exits 3 with no RESULT: sentinel, and the detection is exactly that pair ~
(an unfinished reconstruction must never read as a clean one); it wrote ~
nothing — journal and world bytes unchanged"
          (lambda ()
            (and (eql 3 code) (not sentinel) (search "dying mid-restart" text)
                 (string= *events-post-death-sha*
                          (sha256-hex (store-octets "EVENTS.pj0")))
                 (string= *cells-post-death-sha*
                          (sha256-hex (world-octets "CELLS.txt")))
                 (string= *ledger-post-death-sha*
                          (sha256-hex (world-octets "REQUEST-LEDGER.txt")))))))

;;; ---------------------------------------------------------------------------
;;; Phase 4 — the COMPETENCE control, on copies.

(snote "~%== phase 4 — competence control: a REFUSED act that writes the ~
world, on COPIES — the absence instrument must catch it ==")

(copy-directory *scratch-store* *scratch-control-store*)
(copy-directory *scratch-world* *scratch-control-world*)

(multiple-value-bind (code sentinel)
    (run-stage "stage-control-leak.lisp" "leak-control"
               :environment (stage-arguments *scratch-control-store*
                                             *scratch-control-world*
                                             *scratch-run* nil))
  (scheck "the leak control completed and rendered its own sentinel: the ~
planted violation fired AND the world-scope instrument caught it"
          (lambda () (and (eql 0 code) sentinel))))

(scheck "the control's damage lived only in the copies: the REAL journal and ~
the REAL world are byte-identical to their post-death state (this is why the ~
capture may still be trusted after a deliberate violation)"
        (lambda ()
          (and (string= *events-post-death-sha*
                        (sha256-hex (store-octets "EVENTS.pj0")))
               (string= *cells-post-death-sha*
                        (sha256-hex (world-octets "CELLS.txt")))
               (string= *ledger-post-death-sha*
                        (sha256-hex (world-octets "REQUEST-LEDGER.txt"))))))

(scheck "the copies really did diverge — the control world's ledger now holds ~
TWO entries where the real one holds ONE.  (A control that changed nothing ~
would prove nothing, and this check is what tells those two apart)"
        (lambda ()
          (and (= 2 (world-ledger-count
                     (open-world *scratch-control-world* :script :apply)))
               (= 1 (world-ledger-count
                     (open-world *scratch-world* :script :apply))))))

;;; ---------------------------------------------------------------------------
;;; Phase 5 — the restart: a genuinely new process over durable bytes.

(snote "~%== phase 5 — the restart (genuinely new process; durable bytes + ~
declared configuration only) ==")

(multiple-value-bind (code sentinel)
    (run-stage "stage-restart.lisp" "rediviva"
               :environment (stage-arguments *scratch-store* *scratch-world*
                                             *scratch-run* nil))
  (scheck "the restart process completed and rendered its own final sentinel ~
(exit 0 AND RESULT: — an incomplete transcript licenses nothing)"
          (lambda () (and (eql 0 code) sentinel))))

(defvar *events-final* (store-octets "EVENTS.pj0"))
(defvar *cells-final* (world-octets "CELLS.txt"))
(defvar *ledger-final* (world-octets "REQUEST-LEDGER.txt"))

(scheck "NOTHING WAS REWRITTEN: the final journal is a BYTE-PREFIX EXTENSION ~
of the journal the death left — the first three frames' bytes are literally ~
the first bytes of the final file"
        (lambda ()
          (and (> (length *events-final*) (length *events-post-death*))
               (equalp *events-post-death*
                       (subseq *events-final* 0 (length *events-post-death*))))))

(scheck "the journal grew by exactly SIX frames — the two accounting frames ~
(effect:uncertain · attempt:reconciled) and the fresh act's four — and by ~
nothing else"
        (lambda ()
          (multiple-value-bind (kinds count status)
              (act1-journal-kinds (open-store *scratch-store*))
            (and (eq :valid status) (= 9 count)
                 (equal kinds '("capability0:granted"
                                "attempt:prepared" "attempt:frontier-crossed"
                                "effect:uncertain" "attempt:reconciled"
                                "attempt:prepared" "attempt:frontier-crossed"
                                "request:acknowledged" "effect:settled"))))))

(scheck "the world moved ONLY by the fresh act: the dead act's ledger entry ~
stands untouched beside a second entry under the fresh act's own key, and the ~
cell carries the fresh act's value"
        (lambda ()
          (let ((world (open-world *scratch-world* :script :apply)))
            (and (= 2 (world-ledger-count world))
                 (= 1 (world-ledger-count
                       world (external-request-key *first-attempt*)))
                 (= 1 (world-ledger-count
                       world (external-request-key *fresh-attempt*)))
                 (equal *second-text* (world-cell-value world *cell-name*))
                 ;; the ledger is APPEND-ONLY in fact, not just in intention:
                 ;; the post-death bytes are a prefix of the final bytes.
                 (equalp *ledger-post-death*
                         (subseq *ledger-final* 0 (length *ledger-post-death*)))))))

(scheck "the preserved act-identity file is byte-identical across the whole ~
restart: two refusals, a declaration, a reconciliation and a fresh act edited ~
nothing the dead process left"
        (lambda () (string= *identity-sha*
                            (sha256-hex (sp-read-octets
                                         (act-identity-path *scratch-run*))))))

;;; ---------------------------------------------------------------------------
;;; Phase 6 — preserved artifacts.

(snote "~%== phase 6 — preserved artifacts ==")

(sp-write-octets (merge-pathnames "ARTIFACT-EVENTS-POST-DEATH.pj0" *specimen-root*)
                 *events-post-death*)
(sp-write-octets (merge-pathnames "ARTIFACT-EVENTS-FINAL.pj0" *specimen-root*)
                 *events-final*)
(sp-write-octets (merge-pathnames "ARTIFACT-JOURNAL-META.pjs" *specimen-root*)
                 *metadata-octets*)
(sp-write-octets (merge-pathnames "ARTIFACT-JOURNAL-META.pjs.sha256" *specimen-root*)
                 *sidecar-octets*)
(sp-write-octets (merge-pathnames "ARTIFACT-WORLD-CELLS-POST-DEATH.txt" *specimen-root*)
                 *cells-post-death*)
(sp-write-octets (merge-pathnames "ARTIFACT-WORLD-LEDGER-POST-DEATH.txt" *specimen-root*)
                 *ledger-post-death*)
(sp-write-octets (merge-pathnames "ARTIFACT-WORLD-CELLS-FINAL.txt" *specimen-root*)
                 *cells-final*)
(sp-write-octets (merge-pathnames "ARTIFACT-WORLD-LEDGER-FINAL.txt" *specimen-root*)
                 *ledger-final*)
(sp-write-octets (merge-pathnames "ARTIFACT-ACT-IDENTITY.txt" *specimen-root*)
                 *identity-octets*)

(defvar *artifact-names*
  '("ARTIFACT-EVENTS-POST-DEATH.pj0" "ARTIFACT-EVENTS-FINAL.pj0"
    "ARTIFACT-JOURNAL-META.pjs" "ARTIFACT-JOURNAL-META.pjs.sha256"
    "ARTIFACT-WORLD-CELLS-POST-DEATH.txt" "ARTIFACT-WORLD-LEDGER-POST-DEATH.txt"
    "ARTIFACT-WORLD-CELLS-FINAL.txt" "ARTIFACT-WORLD-LEDGER-FINAL.txt"
    "ARTIFACT-ACT-IDENTITY.txt"))

(sp-write-octets
 (merge-pathnames "ARTIFACT-SHA256SUMS.txt" *specimen-root*)
 (sp-ascii (format nil "~{~a~%~}"
                   (mapcar (lambda (name)
                             (format nil "~a  ~a"
                                     (sha256-hex
                                      (sp-read-octets
                                       (merge-pathnames name *specimen-root*)))
                                     name))
                           *artifact-names*))))

(sp-write-octets
 (merge-pathnames "ARTIFACT-MANIFEST.txt" *specimen-root*)
 (sp-ascii
  (format nil
          "de-actu-resurgente - preserved raw artifacts~%~
governing sentence: the language door survives the process's death as a ~
refusal - a genuinely new image, given only durable bytes and declared ~
configuration, must refuse the same act at the perform boundary, and may ~
proceed only through evidence-carried reconciliation at the runtime level.~%~
CANDIDATE. Not adopted, not audited, not on a floor. Crash model: planted ~
deterministic death only (no SIGKILL, no power loss, no mid-instruction ~
truncation). Capability-disciplined, never capability-secure.~%~
store identity: ~a~%~
act identity (derived from domain + runtime seat + canonical request, ~
re-derived byte-equal by the resurgent image): ~a~%~
EVENTS-POST-DEATH.pj0: ~a octets  sha256 ~a  (3 frames: capability0:granted, ~
attempt:prepared, attempt:frontier-crossed - the journal as the death in the ~
acknowledgment window left it)~%~
EVENTS-FINAL.pj0: ~a octets  sha256 ~a  (9 frames: the SAME PREFIX ~
byte-identically, plus effect:uncertain, attempt:reconciled, and the fresh ~
act's four - nothing rewritten)~%~
WORLD-CELLS-POST-DEATH.txt: ~a octets  sha256 ~a~%~
WORLD-LEDGER-POST-DEATH.txt: ~a octets  sha256 ~a  (ONE applied entry, made by ~
the dead process; the refused repeat and the refused disguise added none)~%~
WORLD-CELLS-FINAL.txt: ~a octets  sha256 ~a~%~
WORLD-LEDGER-FINAL.txt: ~a octets  sha256 ~a  (TWO entries: the dead act's, ~
untouched, and the fresh act's - the post-death bytes are a prefix of these)~%~
ACT-IDENTITY.txt: ~a octets  sha256 ~a  (what the dying process derived, ~
byte-unchanged across the entire restart)~%~
byte-stability: every file listed here is byte-identical across runs (fixed ~
store nonce; declared PJ-META-1 deviation, see specimen-common.lisp)~%"
          (expected-store-id)
          (string-trim '(#\Newline) (sp-octets-string *identity-octets*))
          (length *events-post-death*) *events-post-death-sha*
          (length *events-final*) (sha256-hex *events-final*)
          (length *cells-post-death*) *cells-post-death-sha*
          (length *ledger-post-death*) *ledger-post-death-sha*
          (length *cells-final*) (sha256-hex *cells-final*)
          (length *ledger-final*) (sha256-hex *ledger-final*)
          (length *identity-octets*) *identity-sha*)))

(scheck "the preserved artifacts are byte-identical to the live bytes they ~
copy, and the SHA256SUMS manifest carries those digests"
        (lambda ()
          (let ((sums (sp-octets-string
                       (sp-read-octets (merge-pathnames "ARTIFACT-SHA256SUMS.txt"
                                                        *specimen-root*)))))
            (and (every (lambda (name)
                          (search (sha256-hex
                                   (sp-read-octets
                                    (merge-pathnames name *specimen-root*)))
                                  sums))
                        *artifact-names*)
                 (search *events-post-death-sha* sums)
                 (search *ledger-post-death-sha* sums)
                 (search *identity-sha* sums)))))

;;; ---------------------------------------------------------------------------
;;; Scratch teardown.  Everything evidential is preserved as an ARTIFACT-* file
;;; or printed into this capture; the scratch state is rebuilt from scratch on
;;; every run and is never the record.  (A run that dies before this point
;;; leaves it on disk for inspection.)

(dolist (directory (list *scratch-store* *scratch-world* *scratch-run*
                         *scratch-control-store* *scratch-control-world*))
  (when (probe-file directory)
    (sb-ext:delete-directory directory :recursive t)))

;;; ---------------------------------------------------------------------------
;;; Result — derived, never hard-coded.

(format t "~%de-actu-resurgente: ~a check~:p, ~a failure~:p~%" *checks* *failures*)
(format t "processes: 1 first life (died in the acknowledgment window; its ~
Core /0 evidence died with it) · 3 further stage processes launched ~
(truncated-control, leak-control on copies, rediviva) · artifacts preserved: ~
both journal states + metadata + sidecar + both world states + the derived act ~
identity + sha256sums + manifest · every act verdict rendered by a stage ~
child, none by this runner~%")
(finish-output)
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
