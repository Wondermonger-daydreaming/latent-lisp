;;;; stage-control-leak.lisp — THE COMPETENCE CONTROL for the world-scope
;;;; absence instrument.
;;;;
;;;; ⚠ THIS STAGE PLANTS A REAL VIOLATION AND REQUIRES THE INSTRUMENT TO SEE IT.
;;;;
;;;; An absence claim needs two warrants: SCOPE (the look covers the whole
;;;; universe the sentence names) and COMPETENCE (the instrument is shown able
;;;; to see the violation it reports absent).  Every refused arm in this lane
;;;; asserts "the world is byte-unchanged".  A tooth that has never been seen to
;;;; fire is untested, not passing — so here a REFUSED act writes the world
;;;; anyway, and the same predicate the honest arms use must return NIL.
;;;;
;;;; BOTH defences are deliberately down, through PUBLIC seams only:
;;;;   * the lane's own `leak-write` fixture column drives the dispatch past its
;;;;     own durable-guard refusal and returns the refusal afterwards;
;;;;   * capability /2's own exported `:defect :auto-retry-on-uncertain`
;;;;     (authorize.lisp:106,181-190) defeats the runtime gate — capability /2
;;;;     ships that planted defect precisely to be killed, and this is a lane
;;;;     using it as its author intended.
;;;;
;;;; IT RUNS ON COPIES of the post-death store and world.  The orchestrator
;;;; proves the real state is byte-identical afterwards: this control's own
;;;; violence must not touch the capture it exists to license.
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

(vnote "leak control: a REFUSED act that writes the world anyway, on COPIES of ~
the post-death state.  The world-scope instrument must catch it.")

(setf *act1-store* (open-store *store-directory*))
(setf *act1-worlds* (list :apply (open-world *world-directory* :script :apply)))
(setf *act1-world-directories* (list :apply *world-directory*))
(setf *act1-bootstrap* (specimen-bootstrap))
(setf *act1-minting-context* (make-minting-context :label "control-leak"))

(defun world () (getf *act1-worlds* :apply))

(defvar *row* (the-leak-control-row))
(setf *act1-fixture-table* (list *row*))

(vcheck "the copied state is the post-death state: 3 frames, standing ~
crossed-unsettled, one ledger entry under the dead act's key"
        (lambda ()
          (multiple-value-bind (kinds count) (act1-journal-kinds *act1-store*)
            (declare (ignore kinds))
            (and (= 3 count)
                 (eq :crossed-unsettled
                     (derive-effect-standing *act1-store* *first-attempt*))
                 (eql 1 (world-ledger-count
                         (world) (external-request-key *first-attempt*)))))))

(defvar *before* (take-world-scope (world) *world-directory*
                                   :request-key (external-request-key *leak-attempt*)))

;;; ⚑ THE LEAK IS CAUGHT TWICE, BY TWO INDEPENDENT INSTRUMENTS, and this stage
;;; exhibits both.  (1) THE JOURNAL SIDE: `run-act1`'s classifier reads the
;;; journal after the act and finds a REFUSAL that nevertheless left a SETTLED
;;; standing behind it — a combination no lawful class covers — so it raises
;;; ACT1-BRIDGE-1 as a HOST FAULT and refuses to hand back an Outcome at all.
;;; (2) THE WORLD SIDE: the world-scope instrument, below.  Neither was written
;;; to catch this arm; both do.
(defvar *classifier-fired* nil)
(defvar *classifier-requirement* nil)

(handler-case (run-act1 *row* :process-name "control-leak" :verbose t)
  (act1-bridge-contract-violated (c)
    (setf *classifier-fired* t
          *classifier-requirement* (act1-condition-requirement-id c))))

(defvar *after* (take-world-scope (world) *world-directory*
                                  :request-key (external-request-key *leak-attempt*)))

(vcheck "FIRST CATCH (journal side): the lane's own classifier refuses to ~
classify a REFUSAL that left a SETTLED standing in the journal — it raises ~
ACT1-BRIDGE-1 as a host fault and manufactures neither Outcome nor evidence"
        (lambda () (and *classifier-fired*
                        (string= "ACT1-BRIDGE-1" *classifier-requirement*))))

(print-world-scope-universe "LEAK CONTROL (planted violation)" *before* *after*)

(vcheck "SECOND CATCH (world side) — THE INSTRUMENT FIRES: ~
world-scope-unchanged-p returns NIL across a refused act that wrote.  The ~
absence predicate every honest arm relies on has now been SEEN to catch a ~
violation, not merely seen to pass"
        (lambda () (not (world-scope-unchanged-p *before* *after*))))

(vcheck "and it fires on the SPECIFIC quantities it claims to compare: a new ~
ledger entry under the leaking attempt's own request key, a changed ledger ~
digest, a changed cell-store digest"
        (lambda () (and (eql 0 (world-scope-snapshot-key-count *before*))
                        (eql 1 (world-scope-snapshot-key-count *after*))
                        (not (equal (world-scope-snapshot-ledger-sha *before*)
                                    (world-scope-snapshot-ledger-sha *after*)))
                        (not (equal (world-scope-snapshot-cells-sha *before*)
                                    (world-scope-snapshot-cells-sha *after*))))))

(vcheck "the COULD-NOT-LOOK guard is real too: a snapshot of a directory that ~
holds no world reports :could-not-look for both files, and unchanged-p refuses ~
to call two failed looks 'unchanged' — absent and could-not-look are different ~
answers"
        (lambda ()
          (let ((blind (take-world-scope (world)
                                         (merge-pathnames "no-such-world/"
                                                          *run-directory*))))
            (and (eq :could-not-look (world-scope-snapshot-cells-octets blind))
                 (eq :could-not-look (world-scope-snapshot-ledger-octets blind))
                 (not (world-scope-unchanged-p blind blind))))))

(vnote "this control's damage lives only in the copies; the orchestrator ~
proves the real store and world are byte-identical after it")

(format t "RESULT: ~a checks, ~a failures~%" *v-checks* *v-failures*)
(finish-output)
(sb-ext:exit :code (if (zerop *v-failures*) 0 1))
