;;;; run-specimen.lisp — de-actu-memorato: the remembered act.
;;;;
;;;; "The language can remember what its account is entitled to say — and can
;;;;  durably remember that it is not entitled to say more."
;;;;
;;;; This runner is the ORCHESTRATOR and artifact preserver.  It:
;;;;   1. launches the SCRIPTOR as a SEPARATE process: it performs one bounded act
;;;;      that settles, one that is lawfully refused with GENUINELY ISSUED
;;;;      evidence, and one unrelated act; writes the memory accounts; and exits,
;;;;      taking its Core /0 evidence with it;
;;;;   2. launches the MORITURUS with CAP2_WORLD_DIE_IN_WINDOW=1 against its OWN
;;;;      store and world: the world applies and ledgers the write and the process
;;;;      DIES IN THE ACKNOWLEDGMENT WINDOW (exit 7, no RESULT sentinel; the
;;;;      parent demands exactly that pair), leaving an act nobody accounted for;
;;;;   3. digests the survivors and exhibits the three jurisdictions;
;;;;   4. runs the DAMAGE control on COPIES, and proves the real stores
;;;;      byte-identical afterwards;
;;;;   5. launches the LECTOR — a genuinely new process over durable bytes and
;;;;      declared configuration — whose verdicts are relayed and renumbered here:
;;;;      D1, D2, D4, D3 and D6;
;;;;   6. proves the account store grew only by APPEND (the pre-reader bytes are a
;;;;      byte-prefix of the post-reader bytes) and that the act journal and the
;;;;      world did not move at all while the reader ran;
;;;;   7. preserves the raw bytes as tracked ARTIFACT-* files with a SHA256SUMS
;;;;      manifest.
;;;;
;;;; The orchestrator never writes, retrieves, consolidates, or performs.
;;;;
;;;; Run:  sbcl --script mneme/memory-layer-0/de-actu-memorato/run-specimen.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; DETERMINISM: no pid, timestamp, absolute path, or random identity is printed;
;;;; both store nonces are fixed (declared PJ-META-1 deviation, specimen-common),
;;;; every identity is declared charge — so every digest below is byte-stable
;;;; across runs, and the twin-run comparison is a `cmp`, not an impression.
;;;;
;;;; ENVIRONMENT HYGIENE: each stage child is launched with an environment this
;;;; runner BUILDS — the parent's environment is filtered of every switch in this
;;;; lane's Class I and Class II lists, and only the switch a given phase intends
;;;; is added back.  A leaked death switch would make a later phase lie.
;;;;
;;;; CANDIDATE.  Nothing here is adopted, and nothing here is independent
;;;; verification.
;;;;
;;;; — TABULARIUS (Claude Opus 5, subagent), 2026-08-20

(load (merge-pathnames "specimen-common.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-memory-layer0)

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
  "A flat byte copy of a state directory (both the stores and the world are flat
directories of a few files)."
  (fresh-directory to)
  (dolist (source (directory (merge-pathnames "*.*" from)))
    (sp-write-octets (merge-pathnames (file-namestring source) to)
                     (sp-read-octets source)))
  to)

;;; ---------------------------------------------------------------------------
;;; Paths.  Declared, fixed, relative to the specimen root.

(defvar *specimen-root* #p"mneme/memory-layer-0/de-actu-memorato/")
(defvar *scratch-store* (merge-pathnames "scratch-act-store/" *specimen-root*))
(defvar *scratch-world* (merge-pathnames "scratch-world/" *specimen-root*))
(defvar *scratch-accounts* (merge-pathnames "scratch-account-store/" *specimen-root*))
(defvar *scratch-run* (merge-pathnames "scratch-run/" *specimen-root*))
(defvar *scratch-death-store* (merge-pathnames "scratch-death-store/" *specimen-root*))
(defvar *scratch-death-world* (merge-pathnames "scratch-death-world/" *specimen-root*))
(defvar *scratch-probe-store* (merge-pathnames "scratch-probe-store/" *specimen-root*))
(defvar *scratch-probe-world* (merge-pathnames "scratch-probe-world/" *specimen-root*))
(defvar *copy-intact* (merge-pathnames "scratch-copy-intact/" *specimen-root*))
(defvar *copy-truncated* (merge-pathnames "scratch-copy-truncated/" *specimen-root*))
(defvar *copy-flipped* (merge-pathnames "scratch-copy-flipped/" *specimen-root*))

(defun account-octets (name &optional (directory *scratch-accounts*))
  (sp-read-octets (merge-pathnames name directory)))
(defun act-octets (name &optional (directory *scratch-store*))
  (sp-read-octets (merge-pathnames name directory)))
(defun world-octets (name &optional (directory *scratch-world*))
  (sp-read-octets (merge-pathnames name directory)))

;;; ---------------------------------------------------------------------------
;;; Stage-child relay, with a BUILT environment.

(defun clean-environment (&rest additions)
  "The parent's environment MINUS every switch this lane knows can end or divert a
process, PLUS exactly what this phase intends."
  (let ((switches (append +ml0-env-class-i+ +ml0-env-class-ii+)))
    (append additions
            (remove-if (lambda (entry)
                         (let ((equals (position #\= entry)))
                           (and equals
                                (member (subseq entry 0 equals) switches
                                        :test #'string=))))
                       (sb-ext:posix-environ)))))

(defun run-stage (script label directories &key environment)
  "Launch SCRIPT as a genuinely separate `sbcl --script` process.  Relays its NOTE
lines, renumbers its CHECK lines into this runner's verdict stream, and returns
(values exit-code saw-result-sentinel-p raw-text)."
  (let* ((output (make-string-output-stream))
         (process (sb-ext:run-program
                   "sbcl"
                   (append (list "--script"
                                 (concatenate 'string
                                              "mneme/memory-layer-0/de-actu-memorato/"
                                              script))
                           (mapcar #'namestring directories))
                   :search t :output output :error output
                   :environment (apply #'clean-environment environment)))
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

;;; ---------------------------------------------------------------------------
;;; Phase 0 — a clean world.

(dolist (d (list *scratch-store* *scratch-world* *scratch-accounts* *scratch-run*
                 *scratch-death-store* *scratch-death-world*
                 *scratch-probe-store* *scratch-probe-world*))
  (fresh-directory d))

(snote "de-actu-memorato — the remembered act.")
(snote "governing sentence: the language can remember what its account is ~
entitled to say — and can durably remember that it is not entitled to say more.")
(snote "the pinned proposition `:occurred` warrants:~%  ~a"
       +ml0-occurred-proposition+)
(snote "CANDIDATE.  Nothing here is adopted, and nothing here is independent ~
verification.  Crash model: PLANTED DETERMINISTIC process death (an env-var exit ~
inside capability /2's world adapter).  NO SIGKILL, no power loss, no ~
mid-instruction truncation is claimed — journal0/de-teste-occiso and vertical0 own ~
the real crash windows.  Capability-DISCIPLINED, never capability-secure.~%")

;;; ---------------------------------------------------------------------------
;;; Phase 1 — the scriptor acts and writes.

(snote "== phase 1 — the scriptor (separate process; acts, writes the accounts, ~
and exits with its Core /0 evidence) ==")

(multiple-value-bind (code sentinel)
    (run-stage "stage-writer.lisp" "scriptor"
               (list *scratch-store* *scratch-world* *scratch-accounts*
                     *scratch-run*))
  (scheck "the scriptor completed and rendered its own final sentinel (exit 0 AND ~
RESULT: — an incomplete transcript licenses nothing)"
          (lambda () (and (eql 0 code) sentinel))))

(defvar *accounts-after-writer* (account-octets "EVENTS.pj0"))
(defvar *accounts-after-writer-sha* (sha256-hex *accounts-after-writer*))
(defvar *act-after-writer* (act-octets "EVENTS.pj0"))
(defvar *act-after-writer-sha* (sha256-hex *act-after-writer*))
(defvar *cells-after-writer* (world-octets "CELLS.txt"))
(defvar *ledger-after-writer* (world-octets "REQUEST-LEDGER.txt"))

;;; ---------------------------------------------------------------------------
;;; Phase 2 — the moriturus dies in the acknowledgment window.

(snote "~%== phase 2 — the moriturus (separate process, its OWN store and world; ~
dies in the acknowledgment window, after the dispatch durably lands) ==")

(multiple-value-bind (code sentinel text)
    (run-stage "stage-death.lisp" "moriturus"
               (list *scratch-death-store* *scratch-death-world*)
               :environment '("CAP2_WORLD_DIE_IN_WINDOW=1"))
  (scheck "the moriturus DIED IN THE WINDOW as planted: exit code 7, NO RESULT ~
sentinel, and the adapter's own dying note in the transcript — the dispatch was ~
applied and ledgered; the acknowledgment never came home; no account of the act ~
exists anywhere"
          (lambda () (and (eql 7 code) (not sentinel)
                          (search "dying in the acknowledgment window" text)))))

(defvar *death-events* (sp-read-octets (merge-pathnames "EVENTS.pj0"
                                                        *scratch-death-store*)))
(defvar *death-events-sha* (sha256-hex *death-events*))
(defvar *death-cells* (sp-read-octets (merge-pathnames "CELLS.txt"
                                                       *scratch-death-world*)))
(defvar *death-ledger* (sp-read-octets (merge-pathnames "REQUEST-LEDGER.txt"
                                                        *scratch-death-world*)))

(snote "~%== phase 3 — the three jurisdictions, digested ==")
(snote "ACT JOURNAL   EVENTS.pj0 : ~a octets · sha256 ~a"
       (length *act-after-writer*) *act-after-writer-sha*)
(snote "WORLD         CELLS.txt  : ~a octets · sha256 ~a"
       (length *cells-after-writer*) (sha256-hex *cells-after-writer*))
(snote "WORLD  REQUEST-LEDGER.txt: ~a octets · sha256 ~a"
       (length *ledger-after-writer*) (sha256-hex *ledger-after-writer*))
(snote "ACCOUNT STORE EVENTS.pj0 : ~a octets · sha256 ~a   <- the object that did ~
not exist before this lane"
       (length *accounts-after-writer*) *accounts-after-writer-sha*)
(snote "MORITURUS act journal    : ~a octets · sha256 ~a  (three frames, ending at ~
the frontier)" (length *death-events*) *death-events-sha*)
(snote "MORITURUS world ledger   : ~a octets · sha256 ~a  (ONE applied row, made by ~
a process that did not live to say so)"
       (length *death-ledger*) (sha256-hex *death-ledger*))

;;; ---------------------------------------------------------------------------
;;; Phase 4 — the damage control, on copies.

(snote "~%== phase 4 — damage control: the lane's own account store, truncated ~
and bit-flipped, on COPIES ==")

(copy-directory *scratch-accounts* *copy-intact*)
(copy-directory *scratch-accounts* *copy-truncated*)
(copy-directory *scratch-accounts* *copy-flipped*)

(multiple-value-bind (code sentinel)
    (run-stage "stage-damage.lisp" "vulneratus"
               (list *copy-intact* *copy-truncated* *copy-flipped*))
  (scheck "the damage control completed and rendered its own sentinel"
          (lambda () (and (eql 0 code) sentinel))))

(scheck "the damage lived ONLY in the copies: the REAL account store, act journal ~
and world are byte-identical to their post-writer state (this is why the capture ~
may still be trusted after a deliberate act of destruction)"
        (lambda ()
          (and (string= *accounts-after-writer-sha*
                        (sha256-hex (account-octets "EVENTS.pj0")))
               (string= *act-after-writer-sha*
                        (sha256-hex (act-octets "EVENTS.pj0")))
               (equalp *cells-after-writer* (world-octets "CELLS.txt")))))

(scheck "the copies really did diverge — the truncated copy is SHORTER than the ~
real store and the flipped copy is the SAME LENGTH but a different digest.  (A ~
control that changed nothing would prove nothing, and this check is what tells ~
those two apart)"
        (lambda ()
          (let ((truncated (sp-read-octets (merge-pathnames "EVENTS.pj0"
                                                            *copy-truncated*)))
                (flipped (sp-read-octets (merge-pathnames "EVENTS.pj0"
                                                          *copy-flipped*))))
            (and (< (length truncated) (length *accounts-after-writer*))
                 (= (length flipped) (length *accounts-after-writer*))
                 (not (string= (sha256-hex flipped) *accounts-after-writer-sha*))))))

;;; ---------------------------------------------------------------------------
;;; Phase 5 — the lector: a genuinely new process over durable bytes.

(snote "~%== phase 5 — the lector (genuinely new process; durable bytes + ~
declared configuration only) ==")

(multiple-value-bind (code sentinel)
    (run-stage "stage-reader.lisp" "lector"
               (list *scratch-store* *scratch-world* *scratch-accounts*
                     *scratch-run* *scratch-death-store* *scratch-death-world*
                     *scratch-probe-store* *scratch-probe-world*))
  (scheck "the lector completed and rendered its own final sentinel (exit 0 AND ~
RESULT:)"
          (lambda () (and (eql 0 code) sentinel))))

(defvar *accounts-final* (account-octets "EVENTS.pj0"))

(scheck "NOTHING WAS REWRITTEN: the final account store is a BYTE-PREFIX EXTENSION ~
of the store the scriptor left — the writer's frames' bytes are literally the ~
first bytes of the final file.  /0 never compacts, never tombstones, never erases ~
provenance"
        (lambda ()
          (and (> (length *accounts-final*) (length *accounts-after-writer*))
               (equalp *accounts-after-writer*
                       (subseq *accounts-final* 0 (length *accounts-after-writer*))))))

(scheck "THE READER MOVED NOTHING IT WAS ASKED TO READ: the scriptor's act ~
journal and the whole world fixture are byte-identical to their post-writer ~
state, and the moriturus's store and world are byte-identical to what its death ~
left"
        (lambda ()
          (and (string= *act-after-writer-sha*
                        (sha256-hex (act-octets "EVENTS.pj0")))
               (equalp *cells-after-writer* (world-octets "CELLS.txt"))
               (equalp *ledger-after-writer* (world-octets "REQUEST-LEDGER.txt"))
               (string= *death-events-sha*
                        (sha256-hex (sp-read-octets
                                     (merge-pathnames "EVENTS.pj0"
                                                      *scratch-death-store*))))
               (equalp *death-cells*
                       (sp-read-octets (merge-pathnames "CELLS.txt"
                                                        *scratch-death-world*)))
               (equalp *death-ledger*
                       (sp-read-octets (merge-pathnames "REQUEST-LEDGER.txt"
                                                        *scratch-death-world*))))))

;;; ---------------------------------------------------------------------------
;;; Phase 6 — preserved artifacts.

(snote "~%== phase 6 — preserved artifacts ==")

(defvar *artifact-pairs*
  (list (cons "ARTIFACT-ACCOUNTS-AFTER-WRITER.pj0" *accounts-after-writer*)
        (cons "ARTIFACT-ACCOUNTS-FINAL.pj0" *accounts-final*)
        (cons "ARTIFACT-ACCOUNT-META.pjs"
              (account-octets "JOURNAL-META.pjs"))
        ;; ⚠ THE SIDECAR IS REWRITTEN, NOT COPIED — repaired 2026-08-20 on the
        ;; chair's packaging finding.  The store's own sidecar names
        ;; `JOURNAL-META.pjs`, but the archived payload is
        ;; `ARTIFACT-ACCOUNT-META.pjs`, so a straight copy produced a sidecar that
        ;; could not verify anything in the parcel it shipped in: `sha256sum -c`
        ;; answered `No such file or directory`.  A checksum that cannot be checked
        ;; where it lives is a decoration.  The DIGEST is unchanged and is the
        ;; store's own; only the filename it names is corrected.
        (cons "ARTIFACT-ACCOUNT-META.pjs.sha256"
              (sp-ascii (format nil "~a  ARTIFACT-ACCOUNT-META.pjs~%"
                                (sha256-hex (account-octets "JOURNAL-META.pjs")))))
        (cons "ARTIFACT-ACT-EVENTS.pj0" *act-after-writer*)
        (cons "ARTIFACT-WORLD-CELLS.txt" *cells-after-writer*)
        (cons "ARTIFACT-WORLD-LEDGER.txt" *ledger-after-writer*)
        (cons "ARTIFACT-DEATH-EVENTS.pj0" *death-events*)
        (cons "ARTIFACT-DEATH-WORLD-CELLS.txt" *death-cells*)
        (cons "ARTIFACT-DEATH-WORLD-LEDGER.txt" *death-ledger*)
        (cons "ARTIFACT-ACCOUNT-INDEX.txt"
              (sp-read-octets (merge-pathnames "ACCOUNT-INDEX.txt" *scratch-run*)))))

(dolist (pair *artifact-pairs*)
  (sp-write-octets (merge-pathnames (car pair) *specimen-root*) (cdr pair)))

(sp-write-octets
 (merge-pathnames "ARTIFACT-SHA256SUMS.txt" *specimen-root*)
 (sp-ascii (format nil "~{~a~%~}"
                   (mapcar (lambda (pair)
                             (format nil "~a  ~a"
                                     (sha256-hex
                                      (sp-read-octets
                                       (merge-pathnames (car pair) *specimen-root*)))
                                     (car pair)))
                           *artifact-pairs*))))

(sp-write-octets
 (merge-pathnames "ARTIFACT-MANIFEST.txt" *specimen-root*)
 (sp-ascii
  (format nil
          "de-actu-memorato - preserved raw artifacts~%~
governing sentence: the language can remember what its account is entitled to ~
say - and can durably remember that it is not entitled to say more.~%~
the pinned proposition :occurred warrants: ~a~%~
CANDIDATE. Not adopted, not audited, not frozen, not registered on any floor. ~
Crash model: planted deterministic process death only (no SIGKILL, no power loss, ~
no mid-instruction truncation). Capability-disciplined, never capability-secure.~%~
THREE JURISDICTIONS, three stores, three digests:~%~
  act journal store id  : ~a~%~
  account store id      : ~a~%~
  (they are DIFFERENT stores in different directories with different nonces)~%~
ACCOUNTS-AFTER-WRITER.pj0: ~a octets  sha256 ~a  (what the scriptor left)~%~
ACCOUNTS-FINAL.pj0: ~a octets  sha256 ~a  (the SAME PREFIX byte-identically, plus ~
the lector's appends - nothing rewritten)~%~
ACT-EVENTS.pj0: ~a octets  sha256 ~a  (byte-unchanged across the whole read ~
phase)~%~
WORLD-CELLS.txt: ~a octets  sha256 ~a~%~
WORLD-LEDGER.txt: ~a octets  sha256 ~a~%~
DEATH-EVENTS.pj0: ~a octets  sha256 ~a  (three frames: the moriturus's journal ~
as its death left it)~%~
DEATH-WORLD-LEDGER.txt: ~a octets  sha256 ~a  (ONE applied row, made by a process ~
that did not live to account for it - the state D3 answers)~%~
byte-stability: every file listed here is byte-identical across runs (fixed store ~
nonces; declared PJ-META-1 deviation, see specimen-common.lisp)~%"
          +ml0-occurred-proposition+
          (expected-store-id *act-nonce-16*)
          (expected-store-id *account-nonce*)
          (length *accounts-after-writer*) *accounts-after-writer-sha*
          (length *accounts-final*) (sha256-hex *accounts-final*)
          (length *act-after-writer*) *act-after-writer-sha*
          (length *cells-after-writer*) (sha256-hex *cells-after-writer*)
          (length *ledger-after-writer*) (sha256-hex *ledger-after-writer*)
          (length *death-events*) *death-events-sha*
          (length *death-ledger*) (sha256-hex *death-ledger*))))

(scheck "the ARTIFACT-ACCOUNT-META sidecar VERIFIES STANDALONE against the file ~
it actually ships beside: its digest equals the archived payload's, and the name ~
it carries is the archived payload's name (the store's own sidecar names a file ~
that is not in this directory, which is why it is rewritten rather than copied)"
        (lambda ()
          (let* ((sidecar (sp-octets-string
                           (sp-read-octets (merge-pathnames
                                            "ARTIFACT-ACCOUNT-META.pjs.sha256"
                                            *specimen-root*))))
                 (payload (sha256-hex (sp-read-octets
                                       (merge-pathnames "ARTIFACT-ACCOUNT-META.pjs"
                                                        *specimen-root*)))))
            (and (search payload sidecar)
                 (search "ARTIFACT-ACCOUNT-META.pjs" sidecar)
                 (not (search "JOURNAL-META.pjs" sidecar))))))

(scheck "the preserved artifacts are byte-identical to the live bytes they copy, ~
and the SHA256SUMS manifest carries those digests"
        (lambda ()
          (let ((sums (sp-octets-string
                       (sp-read-octets (merge-pathnames "ARTIFACT-SHA256SUMS.txt"
                                                        *specimen-root*)))))
            (and (every (lambda (pair)
                          (search (sha256-hex
                                   (sp-read-octets
                                    (merge-pathnames (car pair) *specimen-root*)))
                                  sums))
                        *artifact-pairs*)
                 (search *accounts-after-writer-sha* sums)
                 (search *death-events-sha* sums)))))

;;; ---------------------------------------------------------------------------
;;; Scratch teardown.  Everything evidential is preserved as an ARTIFACT-* file or
;;; printed into this capture; the scratch state is rebuilt from scratch on every
;;; run and is never the record.  (A run that dies before this point leaves it on
;;; disk for inspection.)

(dolist (directory (list *scratch-store* *scratch-world* *scratch-accounts*
                         *scratch-run* *scratch-death-store* *scratch-death-world*
                         *scratch-probe-store* *scratch-probe-world*
                         *copy-intact* *copy-truncated* *copy-flipped*))
  (when (probe-file directory)
    (sb-ext:delete-directory directory :recursive t)))

;;; ---------------------------------------------------------------------------
;;; Result — derived, never hard-coded.

(format t "~%de-actu-memorato: ~a check~:p, ~a failure~:p~%" *checks* *failures*)
(format t "processes: 1 scriptor (acted, wrote, exited with its evidence) · 1 ~
moriturus (died in the acknowledgment window; no account of its act existed until ~
the lector wrote one) · 1 vulneratus (damage, on copies) · 1 lector (a genuinely ~
new process: retrieved, refused a continuation, and wrote the first account of an ~
act it did not witness) · artifacts preserved: both account-store states + ~
metadata + sidecar + the act journal + both world files + the moriturus's journal ~
and world + the account index + sha256sums + manifest · every account verdict ~
rendered by a stage child, none by this runner~%")
(finish-output)
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
