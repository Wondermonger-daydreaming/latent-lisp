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
;;;;   III THE LAWFUL ROAD     the granted claim IS a premise of the next
;;;;                           derivation, by judgment-identity chaining.  What
;;;;                           the road costs, and what is still open at its edge.
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
;;;; package access in this directory — grep-verified: the digraph does not occur
;;;; in either file at all, which is why both spell it out in words.  The
;;;; mechanical check is recorded in FIELD-REPORT.md §7.
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
  "The receiver position: who is judging, and which supports they can reach.

A witness is reached by its WITNESS-ID; a judged claim by its CLAIM-ID — the same
id-membership rule, read against a different durable identity.  The desk used to
collect witness ids only, which is why a perfectly good granted claim arrived
:INACCESSIBLE: the desk was handing itself evidence it had not given itself the
right to read.  Access to a judged claim is granted HERE, explicitly, by naming
it — there is no ambient reachability and the language will not assume one."
  (lisp-plus-slice0:receiver-context
   :context-id :peregrina
   :accessible-supports
   (mapcan (lambda (s)
             (cond ((lisp-plus-slice0:witness-p s)
                    (list (lisp-plus-slice0:witness-id s)))
                   ((lisp-plus-slice0:claim-p s)
                    (list (lisp-plus-slice0:claim-id s)))))
           supports)))

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
    ((:may-borrow        . :missing)  . "I have granted you no borrowing standing I could hand onward")
    ((:may-borrow        . :inaccessible) . "a standing exists, but this desk was not given the right to read it")))

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
;;;; MOVEMENT III — THE LAWFUL ROAD
;;;;
;;;; The desk holds a GRANTED :MAY-BORROW claim for Ferrand.  The dispatch schema
;;;; declares :MAY-BORROW as its first premise.  The obvious program is: hand the
;;;; granted claim to the next `derive` as a support.
;;;;
;;;; THAT IS NOW THE PROGRAM.  A judged claim is a support kind, and it discharges
;;;; a premise by JUDGMENT-IDENTITY CHAINING — this exact accessible claim, under
;;;; this exact :VERIFIED judgment, whose judged proposition matches the ground
;;;; premise, with the claim's identity and its judgment basis written into the
;;;; receiving receipt, and the original judgment never converted into a witness.
;;;;
;;;; The previous version of this movement demonstrated the absence of that road
;;;; and then dug a hole around it: it minted a :DIRECT witness restating a
;;;; conclusion nobody observed, and guarded that forgery with an ordinary hash
;;;; table of the desk's own — *DESK-GRANTS*, my discipline, unreceipted.  Both
;;;; the hash table and the restatement helper are GONE from the lawful path, and
;;;; [III-k] checks the table's absence mechanically, in the program's own bytes.
;;;;
;;;; Five arms: the road (3a); what receiver access costs when you forget it (3b);
;;;; the transport door, which still — correctly — does not lead here (3c); the
;;;; refused patron, who now stays refused with nothing of mine holding the line
;;;; (3d); and the one door still open at the edge, and its new price (3e).
;;;; ==================================================================

(format t "~%── MOVEMENT III: the lawful road (a judged claim discharges a premise) ──~%")

(defparameter *insurance*
  (attest '(:predicate :courier-insured (:courier :brass-courier) (:policy "pol-1204"))
          :kind :certificate :source :insurers))

(defun consider-dispatch (patron volume-id standing-support &key receiver)
  "STANDING-SUPPORT is whatever the desk actually holds for this patron — a
granted claim, or NIL when it holds nothing.  RECEIVER overrides the desk's own
reach, which arm 3b needs and nothing else does."
  (let ((sup (remove nil (list standing-support *insurance*))))
    (consider :schema :dispatch-standing :version 1
              :conclusion (np `(:predicate :may-dispatch (:patron ,patron)
                                (:volume ,volume-id) (:courier :brass-courier)))
              :supports sup
              :receiver (or receiver (apply #'at-the-desk sup)))))

(defun roster-for (receipt predicate)
  "The judged-claim roster the receipt kept for PREDICATE: one plist per claim
offered in `supports` and considered for that premise, whatever became of it."
  (let ((a (find predicate (lisp-plus-slice1:derivation-receipt-assessments receipt)
                 :key (lambda (a) (second (lisp-plus-slice1:premise-assessment-premise-pattern a))))))
    (and a (lisp-plus-slice1:premise-assessment-judged-claims a))))

(defun assessment-for (receipt predicate)
  (find predicate (lisp-plus-slice1:derivation-receipt-assessments receipt)
        :key (lambda (a) (second (lisp-plus-slice1:premise-assessment-premise-pattern a)))))

(defun repair-for (receipt predicate)
  (cdr (assoc predicate (lisp-plus-slice1:derivation-receipt-repair-options receipt)
              :key (lambda (p) (second p)))))

;;; The judgment record as it stands BEFORE the claim is spent as support.  Ruling
;;; condition 7 says the original judgment is never converted into a newly minted
;;; witness; [III-e] reads this same object back afterwards and finds it untouched.
(defparameter *ferrand-judgment-before*
  (lisp-plus-slice0:claim-judgment *ferrand-claim*))

;;; --- 3a. the obvious program, which is now the correct program -------
(format t "~%   3a. hand the granted claim straight to the next derivation:~%")
(defparameter *dispatch-claim* nil)
(defparameter *lawful-dispatch-receipt* nil)
(multiple-value-bind (claim receipt)
    (consider-dispatch :ferrand "ms-Aleph-7" *ferrand-claim*)
  (setf *dispatch-claim* claim *lawful-dispatch-receipt* receipt)
  (say-the-verdict receipt)
  (let* ((a (assessment-for receipt :may-borrow))
         (entry (find :discharged (roster-for receipt :may-borrow)
                      :key (lambda (r) (getf r :outcome)))))
    (ok "[III-a] the verified judged claim DISCHARGES the premise — no witness minted"
        (and claim
             (eq :granted (lisp-plus-slice1:derivation-receipt-decision receipt))
             (eq :satisfied (disposition-of receipt :may-borrow))))
    ;; This check is the old [III-b] with its label repaired.  The four
    ;; witness-side fields are still empty and that is still worth asserting —
    ;; but the old label said "no field of the receipt mentions the claim at
    ;; all", and that sentence is now FALSE: the claim is on the record in
    ;; PREMISE-ASSESSMENT-JUDGED-CLAIMS.  Emptiness here no longer means
    ;; invisibility; it means the discharge came from the claim, not a witness.
    (ok "[III-b] the discharge came from the CLAIM, not a witness: the four witness-side fields are empty and the claim is on the record in PREMISE-ASSESSMENT-JUDGED-CLAIMS"
        (and (null (lisp-plus-slice1:premise-assessment-matching-accessible-supports a))
             (null (lisp-plus-slice1:premise-assessment-matching-inaccessible-supports a))
             (null (lisp-plus-slice1:premise-assessment-mismatched-candidates a))
             (null (lisp-plus-slice1:premise-assessment-refuting-supports a))
             (not (null entry)))
        "witness-side empty, judged-claim roster occupied")
    (ok "[III-c] the receipt records the supporting claim IDENTITY and its JUDGMENT BASIS"
        (and entry
             (equal (lisp-plus-kernel0:identity-key (getf entry :claim-id))
                    (lisp-plus-kernel0:identity-key
                     (lisp-plus-slice0:claim-id *ferrand-claim*)))
             (eq :verified (getf entry :judgment))
             (lisp-plus-kernel0:durable-identity-p (getf entry :procedure-id))))
    (format t "     inherited basis, read from the receipt:~%")
    (format t "       claim      ~A~%" (lisp-plus-kernel0:identity-key (getf entry :claim-id)))
    (format t "       judgment   ~S~%" (getf entry :judgment))
    (format t "       procedure  ~A  v~D~%"
            (lisp-plus-kernel0:identity-key (getf entry :procedure-id))
            (getf entry :procedure-version))
    (format t "       supports   ~S~%"
            (mapcar #'lisp-plus-kernel0:identity-key (getf entry :support-ids)))
    ;; and the same receipt as the LANGUAGE renders it, unaided by the desk —
    ;; the legibility question of FIELD-REPORT §3.2, answered in the output.
    (format t "     the receipt in its own words:~%")
    (lisp-plus-slice1:render-derivation-why receipt)
    (ok "[III-d] the OTHER premise was satisfied — so the schema and bindings are fine"
        (eq :satisfied (disposition-of receipt :courier-insured)))
    (ok "[III-e] the original judgment was NOT converted into a witness: the same record is still on the claim, still :VERIFIED, still inspectable"
        (and (eq *ferrand-judgment-before*
                 (lisp-plus-slice0:claim-judgment *ferrand-claim*))
             (eq :verified (lisp-plus-slice0:judgment-record-judgment
                            *ferrand-judgment-before*))))))

;;; --- 3b. the road's toll: the receiver must be given the claim -------
(format t "~%   3b. the same claim, offered to a desk not given the right to read it:~%")
(multiple-value-bind (claim receipt)
    (consider-dispatch :ferrand "ms-Aleph-7" *ferrand-claim*
                       :receiver (at-the-desk *insurance*))
  (say-the-verdict receipt)
  (let ((entry (first (roster-for receipt :may-borrow)))
        (repair (repair-for receipt :may-borrow)))
    (ok "[III-f] a claim the receiver cannot reach does NOT discharge — :INACCESSIBLE, and it is SEEN"
        (and (null claim)
             (eq :inaccessible (disposition-of receipt :may-borrow))
             (eq :inaccessible-to-receiver (getf entry :outcome))))
    (ok "[III-g] the repair names the claim by DURABLE IDENTITY — the desk is told exactly what to grant itself"
        (equal (mapcar #'lisp-plus-kernel0:identity-key
                       (getf repair :grant-receiver-access-to-judged-claims))
               (list (lisp-plus-kernel0:identity-key
                      (lisp-plus-slice0:claim-id *ferrand-claim*))))
        "this is the whole of the fix in AT-THE-DESK, stated by the receipt itself")))

;;; --- 3c. the transport door still does not lead here (correctly) -----
(format t "~%   3c. the transport door (`transported-testimony`) — unchanged:~%")
(multiple-value-bind (claim receipt)
    (consider-dispatch :ferrand "ms-Aleph-7"
                       (lisp-plus-slice1:transported-testimony
                        *ferrand-receipt* :context-a :peregrina))
  (declare (ignore claim))
  (desk ":~A — and CORRECTLY so: a transported receipt is testimony that a"
        (disposition-of receipt :may-borrow))
  (desk "derivation HAPPENED, whose proposition is an attribution, not :MAY-BORROW.")
  (ok "[III-h] `transported-testimony` still does not discharge (lawfully so)"
      (eq :missing (disposition-of receipt :may-borrow))
      "the lawful road is the CLAIM's identity, not a re-narration of its receipt"))

;;; --- 3d. the refused patron, with nothing of mine holding the line ---
(format t "~%   3d. Quillon — refused in Movement II — asks for a dispatch anyway:~%")

(defparameter *quillon-standing* (consider-borrowing :quillon "in-Gimel-11")
  "What the desk HOLDS for Quillon.  Movement II refused him, so `consider`
returned no claim, so this is NIL — and NIL is the whole guard.  The desk cannot
offer a standing it was never given, because the thing it would offer does not
exist as an object.  No table of mine is consulted anywhere in this arm.")

(ok "[III-i] the desk holds NO claim for Quillon — there is nothing to hand onward"
    (null *quillon-standing*))

(multiple-value-bind (claim receipt)
    (consider-dispatch :quillon "in-Gimel-11" *quillon-standing*)
  (say-the-verdict receipt)
  (ok "[III-j] so the dispatch refuses, :MISSING — the refusal is the language's, not my bookkeeping's"
      (and (null claim) (eq :missing (disposition-of receipt :may-borrow)))))

(ok "[III-k] and the desk's private grants table is GONE from the program: the symbol is not even interned"
    (null (find-symbol "*DESK-GRANTS*"))
    "the previous version's guard was a hash table and my discipline; there is now no such variable to consult")

;;; The nearest thing to the old forgery that still lives inside the lawful road:
;;; mint a CLAIM for the refused proposition and offer it.  It is seen, named, and
;;; refused — because a claim without a governed judgment discharges nothing.
(format t "~%   the desk mints itself a claim for the standing it was refused:~%")
(let ((self-minted
        (lisp-plus-slice0:claim
         :proposition (np '(:predicate :may-borrow (:patron :quillon)
                            (:volume "in-Gimel-11")))
         :by :peregrina)))
  (multiple-value-bind (claim receipt)
      (consider-dispatch :quillon "in-Gimel-11" self-minted)
    (let ((entry (first (roster-for receipt :may-borrow)))
          (repair (repair-for receipt :may-borrow)))
      (ok "[III-l] a claim the desk mints for itself is SEEN and REFUSED — :UNJUDGED, by identity"
          (and (null claim)
               (eq :missing (disposition-of receipt :may-borrow))
               (eq :unjudged (getf entry :outcome))
               (equal (lisp-plus-kernel0:identity-key (getf entry :claim-id))
                      (lisp-plus-kernel0:identity-key
                       (lisp-plus-slice0:claim-id self-minted)))))
      (ok "[III-m] the repair no longer tells the desk to supply what it just supplied — it names the offered claim and why it failed"
          (equal (getf repair :judged-claims-seen-but-not-discharging)
                 (list (list (lisp-plus-kernel0:identity-key
                              (lisp-plus-slice0:claim-id self-minted))
                             :unjudged)))
          (format nil "~S" (getf repair :judged-claims-seen-but-not-discharging))))))

;;; --- 3e. the one door still open, and its new price ------------------
(format t "~%   3e. the door still open at the edge of the road:~%")

(defun fabricate-standing (proposition receipt-id)
  "Mint a DIRECT witness for PROPOSITION — the mode reserved for what the desk
observed with its own eyes — naming RECEIPT-ID as a breadcrumb nothing reads.

THIS IS ON NO LAWFUL PATH IN THIS PROGRAM ANY MORE.  It survives as one thing
only: the counterexample of arm 3e, kept so the comparison can be made in the
program's own output rather than in prose.  Its previous name was
RESTATE-STANDING, which was a euphemism, and the euphemism is retired with the
workaround it dressed."
  (lisp-plus-slice0:witness
   :for proposition :mode :direct :kind :standing-restated :source :peregrina
   :content (list :restated-from receipt-id)))

(let ((forged (fabricate-standing
               (np '(:predicate :may-borrow (:patron :quillon)
                     (:volume "in-Gimel-11")))
               "receipt:no-such-thing")))
  (multiple-value-bind (claim receipt)
      (consider-dispatch :quillon "in-Gimel-11" forged)
    (ok "[III-n] a FABRICATED direct witness still grants — the language cannot stop a program from asserting what it did not observe"
        (and claim (eq :granted (lisp-plus-slice1:derivation-receipt-decision receipt)))
        "this door was never Movement III's to close; it is the price of :DIRECT existing at all")
    (ok "[III-o] but the two grants are now told apart FROM THE RECEIPTS ALONE: the lawful one carries a judged-claim record with a judgment basis, this one carries none"
        (let ((lawful (find :discharged (roster-for *lawful-dispatch-receipt* :may-borrow)
                            :key (lambda (r) (getf r :outcome))))
              (forged-roster (roster-for receipt :may-borrow))
              (forged-witnesses (lisp-plus-slice1:premise-assessment-matching-accessible-supports
                                 (assessment-for receipt :may-borrow))))
          (and lawful (getf lawful :procedure-id)
               (null forged-roster)
               forged-witnesses))
        "no hash table was consulted to tell them apart; the difference is in the receipts")
    (desk "the desk no longer restates a single grant, so the two shapes never mix:")
    (desk "an inherited standing arrives as a claim and leaves its judgment basis in")
    (desk "the receipt; an asserted one arrives as a witness and leaves a witness.")
    (desk "a reader of the receipt can tell which happened. I could not, before.")))


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
;; It travels the lawful road: the granted claim itself, handed onward.
(defparameter *beth-standing* (consider-borrowing :ferrand "ms-Beth-3"))
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
(format t "   conformance language. And Movement III closes ONE door, not every~%")
(format t "   door: [III-n] shows a fabricated :DIRECT witness still granting. What~%")
(format t "   changed is that the desk no longer HAS to fabricate one, and that a~%")
(format t "   receipt now distinguishes an inherited judgment from an assertion —~%")
(format t "   see FIELD-REPORT.md §3.~%")

(format t "~%de-bibliotheca-peregrina: ~D checks passed / ~D failed~%" *pass* *fail*)
(format t "(a desk that can say \"no\", \"not yet\", and \"I do not know\" in three~%")
(format t " different voices, and cannot accidentally send the same book twice)~%")
(finish-output)
(sb-ext:exit :code (if (zerop *fail*) 0 1))
