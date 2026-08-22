;;;; stage-restart.lisp — THE REDIVIVA: a genuinely new process over durable
;;;; bytes and declared configuration alone.
;;;;
;;;; What it inherits: the journal's bytes (grant · attempt:prepared ·
;;;; attempt:frontier-crossed — and NOTHING after the frontier), the world's
;;;; bytes (cell written, one ledger entry — which this process has not looked
;;;; at when it makes its first refusal), and the preserved act-identity file.
;;;; What it does NOT inherit: any memory of the dead process, any Core /0
;;;; evidence, any acknowledgment, any knowledge of whether the dispatch landed.
;;;;
;;;; Its charge, in order:
;;;;   1. reconstruct the standing from bytes: crossed-and-unsettled;
;;;;   2. RE-DERIVE the language identity from declared configuration and show
;;;;      it EQUALS the dead process's — the language identity survives the
;;;;      death as a DERIVATION, never as carried state;
;;;;   3. THE CROWN: evaluate THE SAME ACT through `perform`.  The language door
;;;;      REFUSES, pre-frontier, typed, with the provenance in its reason —
;;;;      durable bytes, the world not consulted, no memory in existence;
;;;;   4. the same act WEARING A FRESH ATTEMPT NAME is refused identically, and
;;;;      its derived act identity is shown to be the SAME act identity;
;;;;   5. reconciliation WITHOUT the structured record refuses;
;;;;   6. the uncertainty is STRUCTURED (§10.8 record journaled) and the seat
;;;;      stays closed — now by the record itself;
;;;;   7. RECONCILIATION WITH EVIDENCE at the RUNTIME level: the journaled
;;;;      external-request identity is carried to the surviving world's ledger,
;;;;      the entry is there, resolution :applied — and the world is byte-
;;;;      unchanged by the whole reconciliation (it reads; it does not write);
;;;;   8. only now, a FRESH act on the freed seat runs through `perform` and
;;;;      SETTLES: (values OUTCOME EVIDENCE), outcome-kind :committed.
;;;;
;;;; Truncation control: with ACT1_RESTART_DIE=1 this stage exits 3 mid-run with
;;;; no RESULT sentinel, so the parent can prove an unfinished restart never
;;;; reads as a clean one.
;;;;
;;;; — PONTIFEX (Claude Opus 5, subagent), 2026-08-19

(load (merge-pathnames "specimen-common.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-language-act1)

(defvar *arguments* (rest sb-ext:*posix-argv*))
(defvar *store-directory* (pathname (first *arguments*)))
(defvar *world-directory* (pathname (second *arguments*)))
(defvar *run-directory* (pathname (third *arguments*)))

(vnote "rediviva: durable bytes + declared configuration only; no memory of ~
the first life exists in this process, and no Core /0 evidence survived it")

(setf *act1-store* (open-store *store-directory*))
(setf *act1-worlds* (list :apply (open-world *world-directory* :script :apply)))
(setf *act1-world-directories* (list :apply *world-directory*))
(setf *act1-bootstrap* (specimen-bootstrap))
(setf *act1-minting-context* (make-minting-context :label "rediviva"))

(defun world () (getf *act1-worlds* :apply))
(defun scope (&key (key (external-request-key *first-attempt*)))
  (take-world-scope (world) *world-directory* :request-key key))
(defun frames () (nth-value 1 (act1-journal-kinds *act1-store*)))

;;; ===========================================================================
;;; 1 — the standing, reconstructed from bytes.
;;; ===========================================================================

(vcheck "the reopened store is the store the declared configuration names, ~
validates :valid with exactly 3 frames — grant · attempt:prepared · ~
attempt:frontier-crossed — and has no tail: the first life's story ends ~
mid-attempt, at the crossed frontier"
        (lambda ()
          (multiple-value-bind (kinds count status tail)
              (act1-journal-kinds *act1-store*)
            (and (string= (journal-store-store-id *act1-store*) (expected-store-id))
                 (eq :valid status) (= 3 count) (null tail)
                 (equal kinds '("capability0:granted" "attempt:prepared"
                                "attempt:frontier-crossed"))))))

(vcheck "the standing derived from bytes alone is CROSSED-UNSETTLED: the ~
frontier was crossed and no settlement, no acknowledgment, no uncertainty ~
record, no reconciliation exists — an open attempt whose effect is nowhere ~
accounted.  It is its own state: not a refusal, not a failure"
        (lambda () (eq :crossed-unsettled
                       (derive-effect-standing *act1-store* *first-attempt*))))

;;; ===========================================================================
;;; 2 — the language identity, RE-DERIVED.
;;; ===========================================================================

(defvar *row* (the-act-row))
(setf *act1-fixture-table* (list *row*))
(defvar *rederived* (make-act1-record *row* :register nil))
(defvar *preserved*
  (sp-octets-string (sp-read-octets (act-identity-path *run-directory*))))

(vcheck "THE LANGUAGE IDENTITY SURVIVES AS A DERIVATION, NOT AS STATE: this ~
process re-derives the act identity from (domain · runtime seat · canonical ~
request), touching nothing the dead process left in memory, and the result ~
EQUALS the identity the dead process preserved"
        (lambda ()
          (and (= 64 (length (act1-record-act-id-hex *rederived*)))
               (search (act1-record-act-id-hex *rederived*) *preserved*))))

(when (equal (sb-ext:posix-getenv "ACT1_RESTART_DIE") "1")
  (vnote "dying mid-restart (planted truncation control)")
  (finish-output)
  (sb-ext:exit :code 3 :abort t))

;;; ===========================================================================
;;; 3 — THE CROWN: the same act, refused at the `perform` boundary.
;;; ===========================================================================

(vnote "THE CROWN: evaluating THE SAME ACT again, in a new image, with only ~
durable bytes to go on")

(defvar *crown-before* (scope))
(defvar *crown* (run-act1 *row* :process-name "rediviva" :verbose t))
(defvar *crown-after* (scope))

(vcheck "CROWN · the language door REFUSES the same act PRE-FRONTIER: ~
disposition :refused, outcome-kind :refused — one form, one act, one Outcome, ~
in the failure mode too"
        (lambda () (and (eq :refused (act1-result-disposition *crown*))
                        (eq :refused (lisp-plus-core0:outcome-kind
                                      (act1-result-outcome *crown*))))))

(vcheck "CROWN · the class is :refused-across-death, and it is EARNED rather ~
than assumed: the standing read under this attempt name (:crossed-unsettled) ~
describes the DEAD act, not this one, and the lane admits that reading only ~
because the journal's frame count is unchanged across the whole act — the ~
checked form of 'this act appended nothing'"
        (lambda () (and (eq :refused-across-death (act1-result-class *crown*))
                        (eq :crossed-unsettled (act1-result-standing *crown*)))))

(vcheck "CROWN · the refusal is CORE /0's own typed pre-frontier refusal ~
carrying evidence-so-far and a refused outcome — the language's account of ~
its own refusal, freshly issued in THIS image"
        (lambda () (and (eq 'lisp-plus-core0:core0-refused
                            (act1-result-refusal-type *crown*))
                        (lisp-plus-core0:core0-evidence-p
                         (act1-result-evidence *crown*)))))

(vcheck "CROWN · THE PROVENANCE IS DURABLE BYTES: the reason names the lane's ~
durable guard and capability /2's CAP2-W1 — the crossed-with-nothing-after ~
shape that ONLY a dead process can leave.  No image memory exists to consult; ~
the world has not been read; the answer came out of the journal's bytes"
        (lambda () (eq :|ACT1-DURABLE-GUARD/UNSAFE-RETRY/CAP2-W1|
                       (act1-result-reason *crown*))))

(vcheck "CROWN · the journal gained NOTHING: still exactly 3 frames, still ~
:valid, still no tail — the refusal is above the frontier line and appends ~
nothing"
        (lambda ()
          (multiple-value-bind (kinds count status tail)
              (act1-journal-kinds *act1-store*)
            (declare (ignore kinds))
            (and (eq :valid status) (= 3 count) (null tail)))))

(print-world-scope-universe "CROWN (the refused repeat)" *crown-before* *crown-after*)

(vcheck "CROWN · THE WORLD IS BYTE-UNCHANGED ACROSS THE REFUSAL — whole cell ~
store and whole request ledger, digests and octet counts, total entries and ~
entries under this act's own request key.  The universe of that look is ~
printed above by the instrument itself, and the instrument has been shown able ~
to see a violation (the leak control)"
        (lambda () (world-scope-unchanged-p *crown-before* *crown-after*)))

(vcheck "CROWN · exactly ONE ledger entry stands under this act's request key ~
— the one the DEAD process made.  A blind retry would have made a second"
        (lambda () (eql 1 (world-scope-snapshot-key-count *crown-after*))))

;;; ===========================================================================
;;; 4 — the same act wearing a fresh attempt name.
;;; ===========================================================================

(defvar *disguise-row* (the-disguised-retry-row))
(defvar *disguise-before* (scope :key (external-request-key *retry-attempt*)))
(defvar *disguise* (run-act1 *disguise-row* :process-name "rediviva"
                                            :register nil :verbose t))
(defvar *disguise-after* (scope :key (external-request-key *retry-attempt*)))

(vcheck "DISGUISE · a fresh ATTEMPT NAME does not make a fresh ACT: the ~
derived act identity of the disguised retry is EQUAL to the dead act's, ~
because the derivation reads the seat and the canonical request and neither ~
changed"
        (lambda () (string= (act1-record-act-id-hex (act1-result-record *disguise*))
                            (act1-record-act-id-hex *rederived*))))

(vcheck "DISGUISE · it is refused exactly as the plain repeat was: ~
outcome-kind :refused, same durable-guard provenance, journal untouched at 3 ~
frames"
        (lambda () (and (eq :refused (lisp-plus-core0:outcome-kind
                                      (act1-result-outcome *disguise*)))
                        (eq :|ACT1-DURABLE-GUARD/UNSAFE-RETRY/CAP2-W1|
                            (act1-result-reason *disguise*))
                        (= 3 (frames)))))

(print-world-scope-universe "DISGUISE (the refused retry)"
                            *disguise-before* *disguise-after*)

(vcheck "DISGUISE · the world is byte-unchanged, and ZERO entries stand under ~
the disguised attempt's own request key"
        (lambda () (and (world-scope-unchanged-p *disguise-before* *disguise-after*)
                        (eql 0 (world-scope-snapshot-key-count *disguise-after*)))))

;;; ===========================================================================
;;; 5-7 — the lawful path: structure, then reconcile WITH EVIDENCE, at the
;;; RUNTIME level.  The language door has no continuation across death and this
;;; lane does not invent one (see the RETURN's crown finding).
;;; ===========================================================================

(vcheck "reconciliation WITHOUT the structured record refuses ~
unstructured-uncertainty: inline uncertainty is unlawful; the §10.8 record ~
must be journaled before resolution may be attempted"
        (lambda ()
          (handler-case (progn (reconcile-uncertain-effect
                                *act1-store* (world) *first-attempt*
                                :process-name "rediviva")
                               nil)
            (lisp-plus-kernel0:unstructured-uncertainty () t))))

(vcheck "the uncertainty is STRUCTURED from journaled facts: ~
declare-uncertain-effect builds the §10.8 record through kernel /0's own ~
constructor and journals it — 4 frames now, standing :uncertain-unresolved"
        (lambda ()
          (multiple-value-bind (disposition record)
              (declare-uncertain-effect *act1-store* *first-attempt*
                                        :process-name "rediviva")
            (and (eq :declared disposition)
                 (lisp-plus-kernel0:uncertain-effect-p record)
                 (= 4 (frames))
                 (eq :uncertain-unresolved
                     (derive-effect-standing *act1-store* *first-attempt*))))))

(vcheck "the seat stays CLOSED after structuring, and the guard's provenance ~
CHANGES to say so: the prohibition is now carried by the journaled §10.8 ~
record through kernel /0's own §14.1 fold, not by the bare crossed frontier"
        (lambda ()
          (multiple-value-bind (decision reason)
              (act1-durable-guard-verdict *act1-store* :seat-name *seat*
                                          :candidate-attempt-name *fresh-attempt*)
            (and (eq :refuse decision)
                 (eq :|ACT1-DURABLE-GUARD/UNSAFE-RETRY/-| reason)))))

(defvar *recon-before* (scope))
(defvar *resolution* nil)

(vcheck "RECONCILIATION RESOLVES :APPLIED WITH EVIDENCE: the declared ~
procedure carries the journaled external-request identity to the SURVIVING ~
world's ledger and the entry is there — the dispatch DID land before the ~
death.  attempt:reconciled journaled (5 frames), the §14.2 receipt built live ~
through kernel /0's own constructor, standing :reconciled"
        (lambda ()
          (multiple-value-bind (resolution event receipt)
              (reconcile-uncertain-effect *act1-store* (world) *first-attempt*
                                          :process-name "rediviva")
            (setf *resolution* resolution)
            (and (eq :applied resolution) event
                 (lisp-plus-kernel0:reconciliation-receipt-p receipt)
                 (= 5 (frames))
                 (eq :reconciled (derive-effect-standing *act1-store*
                                                         *first-attempt*))))))

(defvar *recon-after* (scope))
(print-world-scope-universe "RECONCILIATION (a read, not a write)"
                            *recon-before* *recon-after*)

(vcheck "the reconciliation READ the world and wrote nothing there: byte-~
unchanged across it, the cell still holding what the DEAD process wrote, ~
exactly ONE ledger entry under the dead act's key"
        (lambda () (and (world-scope-unchanged-p *recon-before* *recon-after*)
                        (equal *first-text* (world-cell-value (world) *cell-name*))
                        (eql 1 (world-scope-snapshot-key-count *recon-after*)))))

(vcheck "THE LANGUAGE READS THE RUNTIME'S RESOLUTION, and does not read it ~
from the keyword alone: the lane's own door requires :applied AND the world's ~
ledger entry under the journaled identity AND attempt:reconciled in the ~
journal, all three, before it will call the seat closed"
        (lambda () (act1-reconciliation-closes-seat-p
                    *act1-store* (world) *first-attempt* *resolution*)))

;;; ===========================================================================
;;; 8 — the FRESH act on the freed seat.
;;; ===========================================================================

(defvar *fresh-row* (the-fresh-act-row))
(defvar *fresh* (run-act1 *fresh-row* :process-name "rediviva" :verbose t))

(vcheck "ONLY NOW is the seat lawfully free, and the guard says so from the ~
bytes: the FRESH act's guard verdict is :lawful — authority is cheap to ~
re-derive; DISPATCH is what the record forbade, and the record now resolves"
        (lambda () (eq :lawful (act1-result-guard *fresh*))))

(vcheck "the FRESH act SETTLES and returns through the intended interface: ~
(values OUTCOME EVIDENCE), outcome-kind :committed, class :settled, standing ~
:settled derived from the journal's own bytes"
        (lambda () (and (eq :settled (act1-result-class *fresh*))
                        (eq :settled (act1-result-standing *fresh*))
                        (eq :committed (lisp-plus-core0:outcome-kind
                                        (act1-result-outcome *fresh*)))
                        (lisp-plus-core0:core0-evidence-p
                         (act1-result-evidence *fresh*)))))

(vcheck "it is a DIFFERENT act: a different derived identity, a different ~
attempt, a different request — and the world now carries its write under its ~
OWN request key, beside the dead act's, never on top of it"
        (lambda ()
          (and (not (string= (act1-record-act-id-hex (act1-result-record *fresh*))
                             (act1-record-act-id-hex *rederived*)))
               (equal *second-text* (world-cell-value (world) *cell-name*))
               (eql 1 (world-ledger-count (world)
                                          (external-request-key *fresh-attempt*)))
               (eql 1 (world-ledger-count (world)
                                          (external-request-key *first-attempt*)))
               (eql 2 (world-ledger-count (world))))))

(vcheck "the journal ends where the whole account says it should: 9 frames, ~
grant · the dead act's three · the two accounting frames · the fresh act's ~
four — read back from the store's own bytes, :valid, no tail"
        (lambda ()
          (multiple-value-bind (kinds count status tail)
              (act1-journal-kinds *act1-store*)
            (and (eq :valid status) (null tail) (= 9 count)
                 (equal kinds '("capability0:granted"
                                "attempt:prepared" "attempt:frontier-crossed"
                                "effect:uncertain" "attempt:reconciled"
                                "attempt:prepared" "attempt:frontier-crossed"
                                "request:acknowledged" "effect:settled"))))))

(vnote "the language door refused across the death; the runtime reconciled ~
with evidence; the fresh act settled.  Nothing in this process ever held the ~
dead act's Core /0 evidence — it died with its image, and this stage never ~
pretended otherwise.")

(format t "RESULT: ~a checks, ~a failures~%" *v-checks* *v-failures*)
(finish-output)
(sb-ext:exit :code (if (zerop *v-failures*) 0 1))
