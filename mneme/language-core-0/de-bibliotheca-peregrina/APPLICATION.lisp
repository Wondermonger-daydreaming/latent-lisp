;;;; APPLICATION.lisp — de-bibliotheca-peregrina: THE WANDERING LIBRARY.
;;;;
;;;; An interlibrary-loan desk.  Patrons ask for rare volumes; the desk decides
;;;; whether they may borrow, whether the volume may be dispatched, and then
;;;; hands the volume to a brass courier who carries it out of the desk's sight.
;;;; Sometimes the courier's ledger answers.  Sometimes it does not.
;;;;
;;;; This is NOT a specimen and NOT an audit.  It is an APPLICATION, written to
;;;; find out whether Lisp+ is a language one would choose to live in.  The
;;;; companion FIELD-REPORT.md is the other half of the deliverable and is less
;;;; polite than this file.
;;;;
;;;; FIVE MOVEMENTS
;;;;   I   THE QUIET ZONE      ordinary Common Lisp does ordinary work — shelves,
;;;;                           due dates, fees, catalogue lines.  No Lisp+ at all.
;;;;                           (Owner ruling D1: ordinary computation carries no
;;;;                           standing obligation.  Most of a program should live
;;;;                           here, and this one does.)
;;;;   II  STANDING            `derive` turns separately-witnessed evidence into a
;;;;                           granted :MAY-BORROW claim — and refuses three
;;;;                           different ways, which the desk says out loud.
;;;;   III THE WALL            the granted claim CANNOT be a premise of the next
;;;;                           derivation.  Demonstrated, not routed around; the
;;;;                           workaround is shown together with what it costs.
;;;;   IV  THE CROSSING        `perform` hands a volume to the courier.  One
;;;;                           dispatch commits; one is interrupted with the
;;;;                           ledger WITHHOLDING its answer.
;;;;   V   THE DIVERGENCE      the same question, asked of both volumes, gets two
;;;;                           structurally different answers and drives two
;;;;                           different desk actions.  :REFUTED is "no".
;;;;                           :MISSING is "I do not know".  The desk must not
;;;;                           confuse them, and now it cannot.
;;;;
;;;; FRONT-DOOR DISCIPLINE: single-colon public surface only.  Zero double-colon
;;;; package access in this directory — grep-verified, the only occurrences of
;;;; that digraph being this sentence and its twin in FIELD-REPORT.md §7, which
;;;; is where the mechanical check is recorded.
;;;;
;;;; Run: sbcl --non-interactive --load APPLICATION.lisp   (exits 0 on every arm)
;;;;
;;;; — Claude Opus 5 (1M context), INCOLA

(unless (find-package :lisp-plus-fake-courier)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../fake-courier.lisp" *load-truename*))))
(unless (find-package :lisp-plus-slice1)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../../language-slice-1/slice1.lisp" *load-truename*))))

(defpackage #:de-bibliotheca-peregrina (:use #:cl))
(in-package #:de-bibliotheca-peregrina)

;;; ------------------------------------------------------------------
;;; A thin harness so the desk's claims about itself are checkable.

(defvar *pass* 0)
(defvar *fail* 0)
(defun ok (name bool &optional detail)
  (if bool (progn (incf *pass*) (format t "  ok   ~A~@[ — ~A~]~%" name detail))
      (progn (incf *fail*) (format t "  FAIL ~A~@[ — ~A~]~%" name detail))))
(defun desk (fmt &rest args)
  "The desk speaks.  (It is a talkative desk.)"
  (format t "   ▸ ~?~%" fmt args))


;;;; ==================================================================
;;;; MOVEMENT I — THE QUIET ZONE
;;;;
;;;; Shelf marks, loan windows, due dates, overdue fees, catalogue lines.  Plain
;;;; structures, plain arithmetic, plain strings.  Nothing below this banner
;;;; touches Lisp+, and nothing below it needs to: a fee is not a judgment and a
;;;; shelf mark is not a claim.  The desk's calendar is an integer day-count so
;;;; that nothing here depends on a wall clock.
;;;; ==================================================================

(defstruct (volume (:conc-name vol-))
  id title shelf value)

(defstruct (loan (:conc-name loan-))
  volume patron opened due status token tracer)

(defstruct (tracer (:conc-name tracer-))
  id volume patron known unknown required-action)

(defparameter *today* 4120
  "The desk's own calendar: day 4120 since the founding. No wall clock, ever.")

(defparameter *catalogue*
  (list (make-volume :id "ms-Aleph-7"  :title "Peregrinatio Alephi"      :shelf "III.a.7"  :value 900)
        (make-volume :id "ms-Beth-3"   :title "De Ponte Combusto"        :shelf "III.b.3"  :value 640)
        (make-volume :id "in-Gimel-11" :title "Herbarium Vagabundum"     :shelf "I.g.11"   :value 210)
        (make-volume :id "ms-Daleth-1" :title "Cursor Aereus, cum notis" :shelf "IV.d.1"   :value 1450)))

(defparameter *loans* '())
(defparameter *tracers* '())
(defparameter *standing-fines*
  '((:ferrand . 0) (:quillon . 14) (:dambroise . 0))
  "Crowns owed at the counter, quite apart from anything on loan.")

(defun shelf-lookup (id)
  (find id *catalogue* :key #'vol-id :test #'string=))

(defun loan-window (vol)
  "Rare volumes go out for a fortnight, ordinary ones for four weeks."
  (if (> (vol-value vol) 500) 14 28))

(defun reckon-due-day (opened vol)
  (+ opened (loan-window vol)))

(defun overdue-days (loan today)
  (let ((due (loan-due loan)))
    (if (null due) 0 (max 0 (- today due)))))

(defun fee-for (loan today)
  "Three crowns a day overdue, never more than the volume is worth."
  (let ((vol (shelf-lookup (loan-volume loan))))
    (min (* 3 (overdue-days loan today))
         (if vol (vol-value vol) 0))))

(defun patron-fines (patron &optional (today *today*))
  (+ (or (cdr (assoc patron *standing-fines*)) 0)
     (reduce #'+ (remove patron *loans* :key #'loan-patron :test-not #'eq)
             :key (lambda (l) (fee-for l today)) :initial-value 0)))

(defun catalogue-line (vol)
  (format nil "~12A ~A" (vol-shelf vol)
          (format nil "~A  (~D crowns, ~D-day loan)"
                  (vol-title vol) (vol-value vol) (loan-window vol))))

(format t "~%╔══════════════════════════════════════════════════════════════════╗~%")
(format t   "║  DE BIBLIOTHECA PEREGRINA — the wandering library, day ~D      ║~%" *today*)
(format t   "╚══════════════════════════════════════════════════════════════════╝~%")

(format t "~%── MOVEMENT I: the quiet zone (ordinary Common Lisp, no standing) ──~%")
(dolist (v *catalogue*) (format t "   ~A~%" (catalogue-line v)))
(format t "~%")
(dolist (p '(:ferrand :quillon :dambroise))
  (desk "~12A owes ~D crown~:P" p (patron-fines p)))

(ok "[I-a] shelf lookup returns an ordinary structure, not a claim"
    (and (volume-p (shelf-lookup "ms-Aleph-7"))
         (string= "III.a.7" (vol-shelf (shelf-lookup "ms-Aleph-7")))))
(ok "[I-b] due-date arithmetic is ordinary integer arithmetic"
    (= 4134 (reckon-due-day *today* (shelf-lookup "ms-Aleph-7"))))
(ok "[I-c] the fee tally is an ordinary number carrying no receipt"
    (and (integerp (patron-fines :quillon)) (= 14 (patron-fines :quillon))))
(desk "nothing in this movement produced a receipt, a witness, or an outcome —")
(desk "and nothing in this movement owed one. (Owner ruling D1: the quiet zone.)")


;;;; ==================================================================
;;;; THE DESK'S LISP+ VOCABULARY
;;;;
;;;; Four adapters onto the public surface, and the two schemas that say what a
;;;; borrowing standing and a dispatch standing are MADE OF.  The schemas are the
;;;; only place in this program where the desk's policy is written down — which
;;;; is the point: a premise the schema does not name cannot be enforced, and a
;;;; premise it names cannot be skipped.
;;;; ==================================================================

(defun np (form) (lisp-plus-slice1:proposition form))
(defun pp (form) (lisp-plus-slice1:proposition-pattern form))

(defun attest (form &key (kind :observation) (source :peregrina))
  "A direct witness the desk mints from something it actually observed."
  (lisp-plus-slice0:witness :for (np form) :mode :direct :kind kind :source source))

(defun deny (form &key (source :loan-book))
  "Represented counter-evidence: the desk knows this proposition to be FALSE."
  (lisp-plus-slice1:refutation :refutes form :source source))

(defun at-the-desk (&rest supports)
  "The receiver position: who is judging, and which supports they can reach."
  (lisp-plus-slice0:receiver-context
   :context-id :peregrina
   :accessible-supports
   (mapcar #'lisp-plus-slice0:witness-id
           (remove-if-not #'lisp-plus-slice0:witness-p supports))))

(lisp-plus-slice1:clear-schema-registry)

;;; What it takes to borrow: membership attested, fines clear, volume unreserved.
(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :borrowing-standing :version 1
  :conclusion (pp '(:predicate :may-borrow (:patron (:var :patron))
                    (:volume (:var :volume))))
  :premises
  (list (pp '(:predicate :membership-attested (:patron (:var :patron))
              (:register (:var :register))))
        (pp '(:predicate :fines-clear (:patron (:var :patron))
              (:as-of (:var :as-of))))
        (pp '(:predicate :volume-unreserved (:volume (:var :volume))
              (:desk (:var :desk)))))
  :locals '(:register :as-of :desk)))

;;; What it takes to dispatch: the patron may borrow, and the courier is insured.
;;; The first premise is a conclusion the desk has already GRANTED — which is
;;; exactly the thing Movement III is about.
(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :dispatch-standing :version 1
  :conclusion (pp '(:predicate :may-dispatch (:patron (:var :patron))
                    (:volume (:var :volume)) (:courier (:var :courier))))
  :premises
  (list (pp '(:predicate :may-borrow (:patron (:var :patron))
              (:volume (:var :volume))))
        (pp '(:predicate :courier-insured (:courier (:var :courier))
              (:policy (:var :policy)))))
  :locals '(:policy)))

(defun consider (&key schema version conclusion supports receiver)
  "Attempt a derivation and return (values CLAIM RECEIPT) with CLAIM = NIL on
refusal.  The desk needs this wrapper because `derive` SIGNALS on refusal, and
for a lending desk refusal is not exceptional — it is Tuesday.  (FIELD-REPORT §3.)"
  (handler-case
      (lisp-plus-slice1:derive :schema-name schema :schema-version version
                               :conclusion conclusion :supports supports
                               :receiver receiver)
    (lisp-plus-slice1:derivation-refused (c)
      (values nil (lisp-plus-slice1:slice1-condition-receipt c)))))

(defun verdict (receipt)
  "The receipt's own strongest lawful result — never a boolean, never invented."
  (lisp-plus-slice1:derivation-receipt-strongest-lawful-result receipt))

(defun disposition-of (receipt predicate)
  (let ((a (find predicate (lisp-plus-slice1:derivation-receipt-assessments receipt)
                 :key (lambda (a) (second (lisp-plus-slice1:premise-assessment-premise-pattern a))))))
    (and a (lisp-plus-slice1:premise-assessment-disposition a))))

;;; The desk's SPEECH is selected by the receipt's own verdict — the table is
;;; keyed on (premise . disposition), so the desk cannot say a thing the receipt
;;; does not license.  The repair line underneath is printed verbatim.
(defparameter *desk-speech*
  '(((:fines-clear       . :missing)  . "your account is not clear at the counter; the treasurer must attest it")
    ((:membership-attested . :missing) . "the register does not show your membership; bring the warden")
    ((:volume-unreserved . :refuted)  . "no — that volume is out on loan; I can enter you for a hold")
    ((:volume-unreserved . :missing)  . "I cannot say where that volume is; it is in transit, unconfirmed")
    ((:may-borrow        . :missing)  . "I have granted you nothing I can hand onward (see Movement III)")))

(defun say-the-verdict (receipt)
  (let ((v (verdict receipt)))
    (if (eq (lisp-plus-slice1:derivation-receipt-decision receipt) :granted)
        (desk "granted.")
        (destructuring-bind (blocked premise disposition) v
          (declare (ignore blocked))
          (desk "refused — ~S is ~S: ~A" premise disposition
                (or (cdr (assoc (cons premise disposition) *desk-speech* :test #'equal))
                    "(no counter phrasing for this disposition)"))
          (let ((repair (cdr (assoc premise
                                    (lisp-plus-slice1:derivation-receipt-repair-options receipt)
                                    :key (lambda (p) (second p))))))
            (when repair (format t "     repair (verbatim from the receipt): ~S~%" repair)))))))


;;;; ==================================================================
;;;; MOVEMENT II — STANDING
;;;;
;;;; The desk assembles evidence from three separate places — the register, the
;;;; counter's fee tally (Movement I's ordinary arithmetic!), and its own shelf
;;;; state — and asks the language whether that adds up to a borrowing standing.
;;;;
;;;; The load-bearing joint of the whole program is `availability-support`: the
;;;; desk's shelf state is genuinely THREE-VALUED (free / on loan / in transit,
;;;; unconfirmed), and it maps onto three different supports — a witness, a
;;;; refutation, and NOTHING AT ALL.  A boolean would have flattened it.
;;;; ==================================================================

(defparameter *shelf-state* (make-hash-table :test #'equal)
  "volume-id -> :free | :on-loan | :unknown.  Plain desk bookkeeping.")
(dolist (v *catalogue*) (setf (gethash (vol-id v) *shelf-state*) :free))

(defun availability-support (volume-id)
  "Three domain states, three evidential shapes.  NIL is a legitimate answer:
the desk that does not know says nothing, and `:missing` is what that looks like
in the receipt."
  (ecase (gethash volume-id *shelf-state*)
    (:free    (attest `(:predicate :volume-unreserved (:volume ,volume-id) (:desk :peregrina))))
    (:on-loan (deny   `(:predicate :volume-unreserved (:volume ,volume-id) (:desk :peregrina))))
    (:unknown nil)))

(defun borrowing-supports (patron volume-id &optional (today *today*))
  "Assemble what the desk can honestly put on the table for this patron."
  (remove nil
          (list (attest `(:predicate :membership-attested (:patron ,patron)
                          (:register "reg-1899")))
                ;; Movement I's ordinary arithmetic decides whether this witness
                ;; exists at all.  Computation proposes; the language disposes.
                (when (zerop (patron-fines patron today))
                  (attest `(:predicate :fines-clear (:patron ,patron) (:as-of ,today))))
                (availability-support volume-id))))

(defun consider-borrowing (patron volume-id)
  (let ((sup (borrowing-supports patron volume-id)))
    (consider :schema :borrowing-standing :version 1
              :conclusion (np `(:predicate :may-borrow (:patron ,patron)
                                (:volume ,volume-id)))
              :supports sup
              :receiver (apply #'at-the-desk sup))))

(format t "~%── MOVEMENT II: standing (derive turns evidence into reusable standing) ──~%")

(format t "~%   Ferrand asks for ms-Aleph-7 (member, no fines, volume free):~%")
(defparameter *ferrand-claim* nil)
(defparameter *ferrand-receipt* nil)
(multiple-value-bind (claim receipt) (consider-borrowing :ferrand "ms-Aleph-7")
  (setf *ferrand-claim* claim *ferrand-receipt* receipt)
  (say-the-verdict receipt)
  (ok "[II-a] three separately-witnessed premises grant a :MAY-BORROW standing"
      (and claim (eq :granted (lisp-plus-slice1:derivation-receipt-decision receipt))))
  (ok "[II-b] the grant is a real Slice /0 promotion (judgment :VERIFIED), not a flag"
      (eq :verified (lisp-plus-slice0:judgment-record-judgment
                     (lisp-plus-slice0:claim-judgment claim))))
  (ok "[II-c] the standing is REUSABLE: it is an object with a proposition and a lineage"
      (and (lisp-plus-slice0:claim-p claim)
           (equal (lisp-plus-slice0:claim-proposition claim)
                  (np '(:predicate :may-borrow (:patron :ferrand) (:volume "ms-Aleph-7")))))))

(format t "~%   Quillon asks for in-Gimel-11 (member, but owes 14 crowns):~%")
(defparameter *quillon-receipt* nil)
(multiple-value-bind (claim receipt) (consider-borrowing :quillon "in-Gimel-11")
  (setf *quillon-receipt* receipt)
  (say-the-verdict receipt)
  (ok "[II-d] an unminted witness lands :MISSING — the premise BLOCKS, it is not FALSE"
      (and (null claim) (eq :missing (disposition-of receipt :fines-clear))))
  (ok "[II-e] the desk's speech is selected by the receipt, and the repair is verbatim"
      (equal '(:blocked-on :fines-clear :missing) (verdict receipt))))

(format t "~%   Dambroise asks for ms-Daleth-1, which the desk knows is out:~%")
(setf (gethash "ms-Daleth-1" *shelf-state*) :on-loan)
(multiple-value-bind (claim receipt) (consider-borrowing :dambroise "ms-Daleth-1")
  (say-the-verdict receipt)
  (ok "[II-f] represented counter-evidence lands :REFUTED — a different refusal entirely"
      (and (null claim) (eq :refuted (disposition-of receipt :volume-unreserved))))
  (ok "[II-g] :MISSING and :REFUTED are distinct verdicts the desk answers differently"
      (not (equal (verdict receipt) (verdict *quillon-receipt*)))))


;;;; ==================================================================
;;;; MOVEMENT III — THE WALL
;;;;
;;;; The desk now holds a GRANTED :MAY-BORROW claim for Ferrand.  The dispatch
;;;; schema declares :MAY-BORROW as its first premise.  The obvious program is:
;;;; hand the granted claim to the next `derive` as a support.
;;;;
;;;; That does not work.  `derive` filters its supports into witnesses and
;;;; refutations and silently discards anything else, so the claim is not
;;;; REJECTED — it is NOT SEEN.  The premise lands :MISSING with every evidential
;;;; field empty.  This is a known, adjudicated gap (SLICE1-ERRATUM-1 §E3:
;;;; judged-claim premise discharge, `:not-earned`, docketed for the owner).
;;;;
;;;; This movement does three things, in order: shows the failure; shows that the
;;;; ONE in-language transport route (`transported-testimony`) also dead-ends;
;;;; and then implements the workaround that exists today — together with a
;;;; demonstration of exactly what the workaround costs.
;;;; ==================================================================

(format t "~%── MOVEMENT III: the wall (a granted claim cannot be a premise today) ──~%")

(defparameter *insurance*
  (attest '(:predicate :courier-insured (:courier :brass-courier) (:policy "pol-1204"))
          :kind :certificate :source :insurers))

(defun consider-dispatch (patron volume-id standing-support)
  (let ((sup (list standing-support *insurance*)))
    (consider :schema :dispatch-standing :version 1
              :conclusion (np `(:predicate :may-dispatch (:patron ,patron)
                                (:volume ,volume-id) (:courier :brass-courier)))
              :supports sup
              :receiver (apply #'at-the-desk sup))))

;;; --- 3a. the obvious program, and its silent failure -----------------
(format t "~%   3a. hand the granted claim straight to the next derivation:~%")
(multiple-value-bind (claim receipt)
    (consider-dispatch :ferrand "ms-Aleph-7" *ferrand-claim*)
  (say-the-verdict receipt)
  (let ((a (find :may-borrow (lisp-plus-slice1:derivation-receipt-assessments receipt)
                 :key (lambda (a) (second (lisp-plus-slice1:premise-assessment-premise-pattern a))))))
    (ok "[III-a] the granted claim does NOT discharge the premise (refused, :MISSING)"
        (and (null claim) (eq :missing (disposition-of receipt :may-borrow))))
    (ok "[III-b] and it was not REJECTED — it was NOT SEEN: every evidential field is empty"
        (and (null (lisp-plus-slice1:premise-assessment-matching-accessible-supports a))
             (null (lisp-plus-slice1:premise-assessment-matching-inaccessible-supports a))
             (null (lisp-plus-slice1:premise-assessment-mismatched-candidates a))
             (null (lisp-plus-slice1:premise-assessment-refuting-supports a)))
        "no field of the receipt mentions the claim at all")
    (ok "[III-c] the OTHER premise was satisfied — so the schema and bindings are fine"
        (eq :satisfied (disposition-of receipt :courier-insured)))))

;;; --- 3b. the one in-language transport route also dead-ends ----------
(format t "~%   3b. try the transport door (`transported-testimony`):~%")
(multiple-value-bind (claim receipt)
    (consider-dispatch :ferrand "ms-Aleph-7"
                       (lisp-plus-slice1:transported-testimony
                        *ferrand-receipt* :context-a :peregrina))
  (declare (ignore claim))
  (desk "also :~A — and CORRECTLY so: a transported receipt is testimony that a"
        (disposition-of receipt :may-borrow))
  (desk "derivation HAPPENED, whose proposition is an attribution, not :MAY-BORROW.")
  (ok "[III-d] `transported-testimony` cannot discharge it either (lawfully so)"
      (eq :missing (disposition-of receipt :may-borrow))
      "no in-language route from a granted claim to a premise exists today"))

;;; --- 3c. the workaround, and its price -------------------------------
(format t "~%   3c. the workaround that exists today — and what it costs:~%")

(defparameter *desk-grants* (make-hash-table :test #'equal)
  "The desk's OWN record of what it has granted: proposition -> receipt id.
This table is the guard on RESTATE-STANDING below.  Note what it is: an ordinary
Common Lisp promise, of exactly the kind Lisp+ exists to stop me from making.")

(defun remember-grant (claim receipt)
  (setf (gethash (lisp-plus-slice0:claim-proposition claim) *desk-grants*)
        (lisp-plus-kernel0:identity-key
         (lisp-plus-slice1:derivation-receipt-identity receipt)))
  claim)

(defun restate-standing (proposition receipt-id)
  "Mint a FRESH DIRECT witness for PROPOSITION so a later derivation can use it.

Read that sentence again.  The desk is minting a :DIRECT witness — the mode
reserved for what it observed with its own eyes — for a proposition it did not
observe but DERIVED.  The :CONTENT breadcrumb naming RECEIPT-ID is decoration:
nothing in the language reads it, and [III-g] below proves it."
  (lisp-plus-slice0:witness
   :for proposition :mode :direct :kind :standing-restated :source :peregrina
   :content (list :restated-from receipt-id)))

(remember-grant *ferrand-claim* *ferrand-receipt*)

(multiple-value-bind (claim receipt)
    (consider-dispatch :ferrand "ms-Aleph-7"
                       (restate-standing (lisp-plus-slice0:claim-proposition *ferrand-claim*)
                                         (gethash (lisp-plus-slice0:claim-proposition *ferrand-claim*)
                                                  *desk-grants*)))
  (say-the-verdict receipt)
  (defparameter *dispatch-claim* claim)
  (ok "[III-e] the workaround works: restated standing + insurance grants :MAY-DISPATCH"
      (and claim (eq :granted (lisp-plus-slice1:derivation-receipt-decision receipt)))))

;;; ...and here is the bill.
(format t "~%   the price, stated in the program's own bytes:~%")
(let* ((never-granted (np '(:predicate :may-borrow (:patron :quillon)
                            (:volume "in-Gimel-11"))))
       (forged (restate-standing never-granted "receipt:no-such-thing")))
  (multiple-value-bind (claim receipt)
      (consider-dispatch :quillon "in-Gimel-11" forged)
    (ok "[III-f] a restatement of a standing that was REFUSED grants just the same"
        (and claim (eq :granted (lisp-plus-slice1:derivation-receipt-decision receipt)))
        "Quillon owes 14 crowns and was refused in Movement II")
    (ok "[III-g] the :CONTENT provenance breadcrumb is never read — the forged id passed"
        (and claim (null (gethash never-granted *desk-grants*))))
    (desk "the language cannot tell a restated grant from a fabricated one.")
    (desk "the only thing standing between them is *DESK-GRANTS* — my hash table,")
    (desk "my discipline, unreceipted. That is the S3 species this slice exists to")
    (desk "make refusable, reintroduced by hand, at the one joint that needs it.")))


;;;; ==================================================================
;;;; MOVEMENT IV — THE CROSSING
;;;;
;;;; Standing established, the volume goes out.  `perform` is the door: explicit
;;;; capability, a ground request, a process context, and back comes a structured
;;;; OUTCOME — committed, refused, or indeterminate.  Never a bare value.
;;;;
;;;; Two dispatches.  The first commits.  The second is interrupted after the
;;;; courier's ledger has already taken the row, and the ledger then WITHHOLDS
;;;; its answer.  The desk must do something honest with that.
;;;; ==================================================================

(defun courier-key (&optional (predicates '(:deliver)))
  (lisp-plus-core0:mint-capability
   :ruling (lisp-plus-core0:fixture-sealed-ruling
            :adapter-name :fake-courier :predicates predicates)))

(defun dispatch-request (volume-id patron)
  `(:predicate :deliver (:payload ,(format nil "~A → ~A" volume-id patron))))

(format t "~%── MOVEMENT IV: the crossing (perform hands the volume to the courier) ──~%")

;;; --- 4a. the committed dispatch --------------------------------------
(format t "~%   4a. ms-Aleph-7 to Ferrand — the courier's ledger takes it and answers:~%")
(defparameter *world-a* nil)
(multiple-value-bind (adapter world) (lisp-plus-fake-courier:make-fake-courier
                                      :script :clean-commit)
  (setf *world-a* world)
  (multiple-value-bind (outcome evidence)
      (lisp-plus-core0:perform
       :adapter adapter :request (dispatch-request "ms-Aleph-7" :ferrand)
       :authority (courier-key)
       :process (lisp-plus-core0:process-context :label "peregrina/dispatch/aleph-7"))
    (let ((kind (lisp-plus-core0:outcome-kind outcome)))
      (desk "outcome-kind => ~S" kind)
      ;; THE BRANCH.  Everything the desk does next is chosen here.
      (ecase kind
        (:committed
         (let ((token (lisp-plus-core0:core0-evidence-ledger-token evidence)))
           (push (make-loan :volume "ms-Aleph-7" :patron :ferrand
                            :opened *today*
                            :due (reckon-due-day *today* (shelf-lookup "ms-Aleph-7"))
                            :status :in-transit-confirmed :token token)
                 *loans*)
           (setf (gethash "ms-Aleph-7" *shelf-state*) :on-loan)
           (desk "loan opened, clock started, due day ~D, receipt ~A"
                 (loan-due (first *loans*)) token)))
        ;; Both other branches are UNREACHABLE from a RETURN — and not because of
        ;; this fixture.  `perform` has exactly one value-returning exit, the
        ;; committed path (core0.lisp:723, read this session); every refusal and
        ;; every interruption arrives as a CONDITION that carries the outcome.
        ;; So `outcome-kind`'s three-way view is a view over outcomes you must
        ;; first catch.  See FIELD-REPORT.md §4; arm 4c shows a refusal arriving.
        (:refused (desk "unreachable by return: refusals arrive as conditions."))
        (:indeterminate (desk "unreachable by return: interruptions do too.")))
      (ok "[IV-a] the committed dispatch returns a structured outcome, view :COMMITTED"
          (eq kind :committed))
      (ok "[IV-b] the desk was told a ledger token and started the loan clock"
          (and (loan-token (first *loans*))
               (= 4134 (loan-due (first *loans*)))))
      (ok "[IV-c] exactly one row in the courier's private ledger"
          (= 1 (lisp-plus-fake-courier:fake-courier-ledger-row-count world))))))

;;; --- 4b. the interrupted dispatch whose ledger withholds --------------
(format t "~%   4b. ms-Beth-3 to Ferrand — the crossing is interrupted, and the~%")
(format t "       courier's ledger WITHHOLDS its answer:~%")

;; Beth-3 needs its own standing first (ordinary desk work, movements II+III).
(defparameter *beth-standing*
  (multiple-value-bind (claim receipt) (consider-borrowing :ferrand "ms-Beth-3")
    (remember-grant claim receipt)
    (restate-standing (lisp-plus-slice0:claim-proposition claim)
                      (lisp-plus-kernel0:identity-key
                       (lisp-plus-slice1:derivation-receipt-identity receipt)))))
(multiple-value-bind (claim receipt) (consider-dispatch :ferrand "ms-Beth-3" *beth-standing*)
  (declare (ignore receipt))
  (ok "[IV-d] Beth-3 has its own dispatch standing before anything crosses"
      (not (null claim))))

(defparameter *world-b* nil)
(defparameter *beth-evidence* nil)
(multiple-value-bind (adapter world) (lisp-plus-fake-courier:make-fake-courier
                                      :script :kill-after-commit-withhold)
  (setf *world-b* world)
  (handler-case
      (lisp-plus-core0:perform
       :adapter adapter :request (dispatch-request "ms-Beth-3" :ferrand)
       :authority (courier-key)
       :process (lisp-plus-core0:process-context :label "peregrina/dispatch/beth-3"))
    (lisp-plus-core0:core0-interrupted (c)
      (let ((outcome (lisp-plus-core0:core0-condition-outcome c))
            (evidence (lisp-plus-core0:core0-condition-evidence c)))
        (setf *beth-evidence* evidence)
        (desk "outcome-kind => ~S" (lisp-plus-core0:outcome-kind outcome))
        (desk "the desk holds no token. The ledger already holds ~D row~:P."
              (lisp-plus-fake-courier:fake-courier-ledger-row-count world))
        (ok "[IV-e] the interrupted dispatch's view is :INDETERMINATE"
            (eq :indeterminate (lisp-plus-core0:outcome-kind outcome)))
        (ok "[IV-f] the desk was told NO token, yet the effect DID land in the world"
            (and (null (lisp-plus-core0:core0-evidence-ledger-token evidence))
                 (= 1 (lisp-plus-fake-courier:fake-courier-ledger-row-count world)))
            "absence of testimony is not testimony of absence")))))

;;; The temptation: "no record of success, so send another copy."  The language
;;; refuses it — not by convention, by live code.
(format t "~%   the desk's worst instinct, refused by the language itself:~%")
(let* ((events (lisp-plus-core0:core0-evidence-events *beth-evidence*))
       (seat (lisp-plus-core0:core0-evidence-seat-id *beth-evidence*))
       (blind (lisp-plus-kernel0:make-kernel0-event
               :event-type :attempt-begun :seat-id seat
               :attempt-id (lisp-plus-kernel0:make-identity
                            :attempt "peregrina/send-another-copy")
               :payload nil)))
  (handler-case
      (progn (lisp-plus-kernel0:check-retry-safety (append events (list blind)) seat)
             (ok "[IV-g] a blind re-send into the seat is refused" nil "nothing fired"))
    (lisp-plus-kernel0:unsafe-retry (rc)
      (desk "★ UNSAFE-RETRY — the second copy never leaves the desk.")
      (ok "[IV-g] a blind re-send is refused by live code, not by my good intentions"
          (typep rc 'lisp-plus-kernel0:unsafe-retry)))))

;;; The honest move instead: continue from the surviving evidence.
(format t "~%   the honest move: continue from evidence (never repeat the act):~%")
(let* ((rows-before (lisp-plus-fake-courier:fake-courier-ledger-row-count *world-b*))
       (result (lisp-plus-core0:continue-from *beth-evidence* :authority (courier-key)))
       (disposition (lisp-plus-core0:continuation-result-disposition result))
       (required (lisp-plus-core0:continuation-result-required-action result))
       (rows-after (lisp-plus-fake-courier:fake-courier-ledger-row-count *world-b*)))
  (desk "disposition => ~S" disposition)
  (format t "     known:           ~S~%" (getf required :known))
  (format t "     unknown:         ~S~%" (getf required :unknown))
  (format t "     required-action: ~S~%" (getf required :required-action))
  ;; THE SECOND BRANCH.  A different disposition builds a different desk.
  (ecase disposition
    (:reconciled (desk "unreachable in this arm."))
    (:indeterminate
     (let ((tr (make-tracer :id "T-1" :volume "ms-Beth-3" :patron :ferrand
                            :known (getf required :known)
                            :unknown (getf required :unknown)
                            :required-action (getf required :required-action))))
       (push tr *tracers*)
       (push (make-loan :volume "ms-Beth-3" :patron :ferrand
                        :opened *today*
                        :due nil                    ; the loan clock does NOT start
                        :status :in-transit-unconfirmed
                        :token nil :tracer "T-1")
             *loans*)
       (setf (gethash "ms-Beth-3" *shelf-state*) :unknown)
       (desk "tracer T-1 opened; loan recorded IN-TRANSIT-UNCONFIRMED; clock NOT started;")
       (desk "shelf state for ms-Beth-3 set to :UNKNOWN (not :ON-LOAN — the desk does not know)."))))
  (ok "[IV-h] a withholding ledger yields :INDETERMINATE, never a fabricated answer"
      (eq :indeterminate disposition))
  (ok "[IV-i] the continuation NEVER re-invoked the courier (row count unchanged)"
      (and (= 1 rows-before) (= 1 rows-after)))
  (ok "[IV-j] the tracer's text is the continuation's own plist, not desk prose"
      (let ((tr (first *tracers*)))
        (and (equal (tracer-known tr) (getf required :known))
             (equal (tracer-required-action tr) (getf required :required-action))))))

;;; --- 4c. the courier declines before the frontier ---------------------
;;; A refusal, to show the third view arriving the only way it can: as a
;;; condition.  (In the desk's fiction: Cursor Aereus is worth 1450 crowns and
;;; the brass courier will not carry it.)
(format t "~%   4c. ms-Daleth-1 to Dambroise — the courier declines at its own door:~%")
(multiple-value-bind (adapter world) (lisp-plus-fake-courier:make-fake-courier
                                      :script :refuse-before-frontier)
  (handler-case
      (progn (lisp-plus-core0:perform
              :adapter adapter :request (dispatch-request "ms-Daleth-1" :dambroise)
              :authority (courier-key)
              :process (lisp-plus-core0:process-context :label "peregrina/dispatch/daleth-1"))
             (ok "[IV-l] the adapter's pre-frontier refusal arrives at all" nil
                 "perform returned instead of signalling"))
    (lisp-plus-core0:core0-refused (c)
      (let ((outcome (lisp-plus-core0:core0-condition-outcome c)))
        (desk "caught ~A; the outcome it carries has view ~S"
              (type-of c) (lisp-plus-core0:outcome-kind outcome))
        (ok "[IV-l] a refusal arrives as a CONDITION whose outcome's view is :REFUSED"
            (eq :refused (lisp-plus-core0:outcome-kind outcome))
            "not as a returned value — the caller must catch to see it")
        (ok "[IV-m] the refused dispatch left the world untouched (no ledger row)"
            (= 0 (lisp-plus-fake-courier:fake-courier-ledger-row-count world)))
        (desk "no loan opened, no clock started, nothing to reconcile.")))))

(format t "~%   the two loans on the desk's books are structurally different records:~%")
(dolist (l (reverse *loans*))
  (format t "     ~13A ~24A due=~A  token=~A  tracer=~A~%"
          (loan-volume l) (loan-status l)
          (or (loan-due l) "—") (or (loan-token l) "—") (or (loan-tracer l) "—")))
(ok "[IV-k] the committed loan accrues time; the unconfirmed one cannot"
    (let ((confirmed (find :in-transit-confirmed *loans* :key #'loan-status))
          (unconfirmed (find :in-transit-unconfirmed *loans* :key #'loan-status)))
      (and (loan-due confirmed) (null (loan-due unconfirmed))
           (= 0 (fee-for unconfirmed (+ *today* 90)))
           (< 0 (fee-for confirmed (+ *today* 90)))))
    "ninety days on, the confirmed loan owes a fee and the unconfirmed one owes nothing")


;;;; ==================================================================
;;;; MOVEMENT V — THE DIVERGENCE
;;;;
;;;; Dambroise arrives and asks for both volumes.  Same desk, same schema, same
;;;; code path — and two structurally different refusals, because the desk's
;;;; knowledge of the two volumes is structurally different.  This is the payoff
;;;; of Movement II's three-valued `availability-support`, and it is the thing a
;;;; boolean `volume-available-p` would have destroyed.
;;;; ==================================================================

(format t "~%── MOVEMENT V: the divergence (the same question, two honest answers) ──~%")

(defparameter *hold-queue* '())
(defparameter *tracer-followups* '())

(defun answer-a-patron (patron volume-id)
  "One code path.  The DISPOSITION chooses the desk's action."
  (multiple-value-bind (claim receipt) (consider-borrowing patron volume-id)
    (say-the-verdict receipt)
    (let ((d (disposition-of receipt :volume-unreserved)))
      (cond
        (claim               (desk "→ fetching it from the shelf.") :fetch)
        ((eq d :refuted)     (push (cons patron volume-id) *hold-queue*)
                             (desk "→ entered on the hold queue behind the current loan.")
                             :hold)
        ((eq d :missing)     (push (cons patron volume-id) *tracer-followups*)
                             (desk "→ NOT a hold: the desk cannot promise a queue for a")
                             (desk "  volume whose whereabouts are unconfirmed. Queued")
                             (desk "  behind tracer ~A instead."
                                   (tracer-id (find volume-id *tracers*
                                                    :key #'tracer-volume :test #'string=)))
                             :await-tracer)
        (t                   (desk "→ referred to the counter.") :refer)))))

(format t "~%   Dambroise asks for ms-Aleph-7 (confirmed out on loan):~%")
(defparameter *action-a* (answer-a-patron :dambroise "ms-Aleph-7"))

(format t "~%   Dambroise asks for ms-Beth-3 (in transit, unconfirmed):~%")
(defparameter *action-b* (answer-a-patron :dambroise "ms-Beth-3"))

(ok "[V-a] the confirmed-out volume refuses :REFUTED — the desk says no and holds"
    (eq *action-a* :hold))
(ok "[V-b] the unconfirmed volume refuses :MISSING — the desk says it does not know"
    (eq *action-b* :await-tracer))
(ok "[V-c] the two paths DIVERGE in the desk's state, not only in its printout"
    (and (= 1 (length *hold-queue*)) (= 1 (length *tracer-followups*))
         (not (equal *hold-queue* *tracer-followups*))))
(ok "[V-d] across the whole session the courier was invoked exactly twice, never thrice"
    (= 2 (+ (lisp-plus-fake-courier:fake-courier-ledger-row-count *world-a*)
            (lisp-plus-fake-courier:fake-courier-ledger-row-count *world-b*))))

(format t "~%   the desk's books at close of day ~D:~%" *today*)
(format t "     hold queue:        ~S~%" *hold-queue*)
(format t "     tracer follow-ups: ~S~%" *tracer-followups*)
(format t "     open tracers:      ~S~%" (mapcar #'tracer-id *tracers*))


;;;; ==================================================================
;;;; CLOSING

(format t "~%── what this application does NOT show ──~%")
(format t "   Nothing here demonstrates crash survival: the interrupted dispatch's~%")
(format t "   evidence survived because the IMAGE did. The courier is the labelled~%")
(format t "   scripted fake, never AP0-conformant; no result above licenses any~%")
(format t "   conformance language. And the Movement III workaround is a hole the~%")
(format t "   desk digs itself — see FIELD-REPORT.md §3.~%")

(format t "~%de-bibliotheca-peregrina: ~D checks passed / ~D failed~%" *pass* *fail*)
(format t "(a desk that can say \"no\", \"not yet\", and \"I do not know\" in three~%")
(format t " different voices, and cannot accidentally send the same book twice)~%")
(finish-output)
(sb-ext:exit :code (if (zerop *fail*) 0 1))
