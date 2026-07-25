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
;;;; ELEVEN MOVEMENTS  (I–IX, then X and XI, added 2026-07-25)
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
;;;;   VI  THE LONG ROAD       four derivational hops, each fed by the last, and
;;;;                           then an attempt to walk the road BACKWARD from the
;;;;                           claim it ends at, using public accessors only.
;;;;                           The attempt does not succeed, and why it doesn't
;;;;                           is the movement's finding.
;;;;   VII THE TWO CROSSINGS   the authorization is a premise; the acts are its
;;;;                           consequences.  A reservation and a dispatch cross
;;;;                           cleanly; a third crossing is interrupted and its
;;;;                           ledger withholds, and the desk reconciles.
;;;;   VIII THE THREE REFUSALS where the long road stops: a patron who cannot
;;;;                           start it, an intermediate the receiver was not
;;;;                           given, and the direct-witness door in its side —
;;;;                           open, labelled, and not closed here.
;;;;   IX  THE EFFECT FRONTIER settlement wants a premise meaning "this actually
;;;;                           happened".  Six species of support are tried —
;;;;                           including, since CHARTER-DELTA-3, the Core /0
;;;;                           effect account handed straight across — and the
;;;;                           outcome of each is recorded.  Two discharge,
;;;;                           and BOTH rest on a witness the desk minted with
;;;;                           its own hand — a fabricated one discharges
;;;;                           identically, and so does a witness carrying no
;;;;                           account at all.  The effect can be CARRIED and
;;;;                           cannot be CHECKED.  The boundary is stated in the
;;;;                           program's own output, the loan is left honestly
;;;;                           open, and NO fix is proposed or implemented.
;;;;   X   THE SOURCE-BOUND     Language Slice /2, Candidate /0.  The premise
;;;;       ROAD                 stops accepting a witness the desk minted and
;;;;                           starts requiring a GOVERNED SOURCE BASIS over an
;;;;                           account Core /0 issued IN THIS IMAGE for THAT
;;;;                           EXACT REQUEST.  Deed, account report,
;;;;                           acknowledgment and settlement stay four distinct
;;;;                           stages.  The loan settles — because the account
;;;;                           Movement VII already produced says enough, not
;;;;                           because anything was moved to let it.
;;;;   XI  THE COMPOSED ROAD    Language Slice /2, Candidate /1.  [IX-10] closed
;;;;                           one layer up: the standing Movement X earned can
;;;;                           now travel WITH the admission record that granted
;;;;                           it, as a DERIVATION BASIS a later premise may
;;;;                           insist on — and the desk's own naked claim, and
;;;;                           an ordinarily raised twin of it, are both refused
;;;;                           at that premise.  Nothing was re-derived: the
;;;;                           basis is the third value of the grant Movement X
;;;;                           already made.
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
;; MOVEMENTS X and XI (2026-07-25) — Language Slice /2, Candidates /0 and /1.
;; Movements I–IX are unchanged and do not use either.
(unless (find-package :lisp-plus-slice2)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../../language-slice-2/slice2.lisp" *load-truename*))))

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
        (make-volume :id "ms-Daleth-1" :title "Cursor Aereus, cum notis" :shelf "IV.d.1"   :value 1450)
        ;; Added for the long road of Movement VI: a RESTRICTED volume, held under
        ;; the reciprocity agreement with Collegium Boreale.  It is an ordinary
        ;; catalogue line like the other four — the restriction is not a property
        ;; of the structure, it is the length of the road the desk must walk.
        (make-volume :id "ms-He-9"     :title "Speculum Peregrinum"      :shelf "V.h.9"    :value 1180)))

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
                    (list (lisp-plus-slice0:claim-id s)))
                   ;; MOVEMENT XI: a derivation basis is reached by its
                   ;; DERIVATION-BASIS IDENTITY — which IS the underlying
                   ;; claim's identity, so this adds a species to the cond and
                   ;; no new accessibility regime to the desk.
                   ((lisp-plus-slice2:derivation-basis-p s)
                    (list (lisp-plus-slice2:derivation-basis-identity s)))
                   ;; MOVEMENT X: a Slice /2 source basis is reached by its
                   ;; SOURCE-BASIS IDENTITY — the same id-membership rule, read
                   ;; against a third durable identity.  No new accessibility
                   ;; regime, and still nothing ambient.
                   ((lisp-plus-slice2:source-basis-p s)
                    (list (lisp-plus-slice2:source-basis-identity s)))))
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
    ((:may-borrow        . :inaccessible) . "a standing exists, but this desk was not given the right to read it")
    ;; Added with the long road (Movements VI–IX).  The table is keyed on
    ;; (premise . disposition) exactly as before; these are two more pairs the
    ;; receipts can produce, not a new way of choosing what to say.
    ((:may-access-restricted . :inaccessible) . "the curator cleared you; this desk was not given the right to read that clearance")
    ((:reciprocal-eligible . :missing) . "you are not yet eligible under the reciprocity agreement")
    ((:dispatch-acknowledged . :missing) . "I cannot close this loan: nothing before me says the dispatch arrived")))

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
;;;; THE LONG ROAD'S VOCABULARY
;;;;
;;;; Four more schemas, registered ALONGSIDE the two above — the registry is
;;;; never cleared again, and (name, version) is a unique key, so
;;;; :DISPATCH-STANDING v2 sits beside v1 without disturbing it.  Movement III's
;;;; road was one hop long; these make it four, and each hop's premise is the
;;;; previous hop's CONCLUSION.  Nothing in these schemas mentions an effect.
;;;; ==================================================================

;;; Reciprocity: a borrower here becomes eligible under the Boreale agreement.
(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :reciprocity-standing :version 1
  :conclusion (pp '(:predicate :reciprocal-eligible (:patron (:var :patron))
                    (:volume (:var :volume))))
  :premises
  (list (pp '(:predicate :may-borrow (:patron (:var :patron))
              (:volume (:var :volume))))
        (pp '(:predicate :reciprocal-agreement (:library (:var :library))
              (:patron (:var :patron)))))
  :locals '(:library)))

;;; Restricted access: eligibility plus a named curator's clearance.
(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :restricted-access-standing :version 1
  :conclusion (pp '(:predicate :may-access-restricted (:patron (:var :patron))
                    (:volume (:var :volume))))
  :premises
  (list (pp '(:predicate :reciprocal-eligible (:patron (:var :patron))
              (:volume (:var :volume))))
        (pp '(:predicate :curator-clearance (:patron (:var :patron))
              (:curator (:var :curator)))))
  :locals '(:curator)))

;;; Reservation: access plus the shelf still holding the volume.
(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :reservation-standing :version 1
  :conclusion (pp '(:predicate :may-reserve (:patron (:var :patron))
                    (:volume (:var :volume))))
  :premises
  (list (pp '(:predicate :may-access-restricted (:patron (:var :patron))
              (:volume (:var :volume))))
        (pp '(:predicate :volume-unreserved (:volume (:var :volume))
              (:desk (:var :desk)))))
  :locals '(:desk)))

;;; Dispatch, second edition.  v1 asked for a borrowing standing; v2 asks for a
;;; RESERVATION standing — the far end of the long road.  Same conclusion
;;; predicate, different premises, different version: the old schema is not
;;; touched and Movement III's receipts stay exactly as true as they were.
(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :dispatch-standing :version 2
  :conclusion (pp '(:predicate :may-dispatch (:patron (:var :patron))
                    (:volume (:var :volume)) (:courier (:var :courier))))
  :premises
  (list (pp '(:predicate :may-reserve (:patron (:var :patron))
              (:volume (:var :volume))))
        (pp '(:predicate :courier-insured (:courier (:var :courier))
              (:policy (:var :policy)))))
  :locals '(:policy)))

(defun roster-entry-for (receipt predicate the-claim)
  "The roster entry the receipt kept for THE-CLAIM under PREDICATE, found by
DURABLE IDENTITY — never by position in the list.  A premise's roster holds one
entry per claim offered, including the ones offered for a different premise, so
`first` is a guess and identity is the answer."
  (find-if (lambda (e)
             (lisp-plus-kernel0:identity= (getf e :claim-id)
                                          (lisp-plus-slice0:claim-id the-claim)))
           (roster-for receipt predicate)))


;;;; ==================================================================
;;;; MOVEMENT VI — THE LONG ROAD
;;;;
;;;; Speculum Peregrinum is restricted.  Ferrand may borrow it, but borrowing is
;;;; only the first of five standings: eligible under the reciprocity agreement,
;;;; cleared by the curator, reserved off the shelf, and only then dispatchable.
;;;;
;;;; Four derivations, each fed by the last.  At every hop the desk asserts four
;;;; things: the decision, the inherited premise's disposition, the receipt's own
;;;; record of WHICH claim discharged it and under what judgment, and — the one
;;;; that matters most — that the spent claim was not consumed, converted, or
;;;; quietly turned into a witness on its way through.
;;;;
;;;; Then the desk tries to WALK BACK down the road it just walked up, using
;;;; nothing but the public accessors on the claim it ended with.  What happens
;;;; there is the movement's real finding, and it is not the happy one.
;;;; ==================================================================

(format t "~%── MOVEMENT VI: the long road (four hops, each fed by the last) ──~%")

(defparameter *restricted* "ms-He-9")

(defparameter *reciprocity*
  (attest '(:predicate :reciprocal-agreement (:library :collegium-boreale)
            (:patron :ferrand))
          :kind :agreement :source :collegium-boreale))
(defparameter *clearance*
  (attest '(:predicate :curator-clearance (:patron :ferrand)
            (:curator :dame-orvieto))
          :kind :clearance :source :curator))

(defparameter *hop-0* nil)   ; :may-borrow
(defparameter *hop-1* nil)   ; :reciprocal-eligible
(defparameter *hop-2* nil)   ; :may-access-restricted
(defparameter *hop-3* nil)   ; :may-reserve
(defparameter *hop-4* nil)   ; :may-dispatch, v2

;;; The receipt each hop issued.  These are ORDINARY LOCAL VARIABLES holding the
;;; five objects this movement itself produced — not a registry, not a growing
;;; ledger, not a table anything is looked up in.  Nothing in this program
;;; CONSULTS them to decide anything; arm 6c hands them to a printer, and arm
;;; VIII-E compares two of them.  The distinction is the one Movement III drew
;;; when it deleted *DESK-GRANTS*: a variable that DECIDES is a private
;;; authenticity oracle, and a variable that PRINTS is a presentation helper.
(defparameter *hop-0-receipt* nil)
(defparameter *hop-1-receipt* nil)
(defparameter *hop-2-receipt* nil)
(defparameter *hop-3-receipt* nil)
(defparameter *hop-4-receipt* nil)

(format t "~%   the road begins where Movement II ended — an ordinary borrowing standing:~%")
(multiple-value-bind (claim receipt) (consider-borrowing :ferrand *restricted*)
  (setf *hop-0* claim *hop-0-receipt* receipt)
  (say-the-verdict receipt)
  (ok "[VI-a] the restricted volume is on the shelf and Ferrand may borrow it"
      (and claim (eq :free (gethash *restricted* *shelf-state*)))))

(defun walk-one-hop (label schema conclusion carried witness)
  "One derivational hop.  CARRIED is the previous hop's granted claim; WITNESS is
the fresh evidence this hop adds.  Returns the new claim, and asserts — before it
returns anything — the four things the desk is entitled to assert about the hop.

The judgment record of the CARRIED claim is read BEFORE the derivation and
compared afterwards: a road that spent its own milestones would not be a road."
  (let* ((carried-predicate (second (lisp-plus-slice0:claim-proposition carried)))
         (judgment-before (lisp-plus-slice0:claim-judgment carried))
         (supports (list carried witness)))
    (multiple-value-bind (claim receipt)
        (consider :schema schema :version 1 :conclusion conclusion
                  :supports supports :receiver (apply #'at-the-desk supports))
      (say-the-verdict receipt)
      (let ((entry (roster-entry-for receipt carried-predicate carried)))
        (ok (format nil "[~A-a] the hop is GRANTED" label)
            (and claim (eq :granted (lisp-plus-slice1:derivation-receipt-decision receipt))))
        (ok (format nil "[~A-b] the premise fed by the previous claim reads :SATISFIED" label)
            (eq :satisfied (disposition-of receipt carried-predicate)))
        (ok (format nil "[~A-c] the roster names THAT claim, :DISCHARGED, judgment :VERIFIED" label)
            (and entry
                 (eq :discharged (getf entry :outcome))
                 (eq :verified (getf entry :judgment))
                 (equal (lisp-plus-kernel0:identity-key (getf entry :claim-id))
                        (lisp-plus-kernel0:identity-key
                         (lisp-plus-slice0:claim-id carried))))
            (format nil "~S via ~A"
                    carried-predicate
                    (lisp-plus-kernel0:identity-key (getf entry :procedure-id))))
        (ok (format nil "[~A-d] the spent claim is UNTOUCHED — same judgment record, still :VERIFIED" label)
            (and (eq judgment-before (lisp-plus-slice0:claim-judgment carried))
                 (eq :verified (lisp-plus-slice0:judgment-record-judgment judgment-before)))
            "nothing converted a judgment into a witness on the way past"))
      (values claim receipt))))

(format t "~%   hop 1 — the reciprocity agreement makes a borrower eligible:~%")
(multiple-value-setq (*hop-1* *hop-1-receipt*)
      (walk-one-hop "VI-1" :reciprocity-standing
                    (np `(:predicate :reciprocal-eligible (:patron :ferrand)
                          (:volume ,*restricted*)))
                    *hop-0* *reciprocity*))

(format t "~%   hop 2 — eligibility plus the curator's hand opens the restricted case:~%")
(multiple-value-setq (*hop-2* *hop-2-receipt*)
      (walk-one-hop "VI-2" :restricted-access-standing
                    (np `(:predicate :may-access-restricted (:patron :ferrand)
                          (:volume ,*restricted*)))
                    *hop-1* *clearance*))

(format t "~%   hop 3 — access plus a volume still on the shelf makes a reservation:~%")
(multiple-value-setq (*hop-3* *hop-3-receipt*)
      (walk-one-hop "VI-3" :reservation-standing
                    (np `(:predicate :may-reserve (:patron :ferrand)
                          (:volume ,*restricted*)))
                    *hop-2* (availability-support *restricted*)))

(format t "~%   hop 4 — the reservation, not the borrowing, is what v2 dispatches on:~%")
(let* ((supports (list *hop-3* *insurance*))
       (judgment-before (lisp-plus-slice0:claim-judgment *hop-3*)))
  (multiple-value-bind (claim receipt)
      (consider :schema :dispatch-standing :version 2
                :conclusion (np `(:predicate :may-dispatch (:patron :ferrand)
                                  (:volume ,*restricted*) (:courier :brass-courier)))
                :supports supports :receiver (apply #'at-the-desk supports))
    (setf *hop-4* claim *hop-4-receipt* receipt)
    (say-the-verdict receipt)
    (let ((entry (roster-entry-for receipt :may-reserve *hop-3*)))
      (ok "[VI-4a] the hop is GRANTED"
          (and claim (eq :granted (lisp-plus-slice1:derivation-receipt-decision receipt))))
      (ok "[VI-4b] the premise fed by the previous claim reads :SATISFIED"
          (eq :satisfied (disposition-of receipt :may-reserve)))
      (ok "[VI-4c] the roster names THAT claim, :DISCHARGED, judgment :VERIFIED"
          (and entry (eq :discharged (getf entry :outcome))
               (eq :verified (getf entry :judgment))
               (equal (lisp-plus-kernel0:identity-key (getf entry :claim-id))
                      (lisp-plus-kernel0:identity-key
                       (lisp-plus-slice0:claim-id *hop-3*)))))
      (ok "[VI-4d] the spent claim is UNTOUCHED — same judgment record, still :VERIFIED"
          (and (eq judgment-before (lisp-plus-slice0:claim-judgment *hop-3*))
               (eq :verified (lisp-plus-slice0:judgment-record-judgment judgment-before)))))))

;;; --- 6b. walking back down the road ----------------------------------
(format t "~%   6b. the desk tries to walk BACK down the road, from the last claim,~%")
(format t "       using nothing but the public accessors on a claim:~%")

(defun walk-back (final)
  "Start at FINAL and walk toward the patron's original standing, printing each
claim's id, its judgment, and the claim its judgment points back at.

Public accessors ONLY: CLAIM-ID · CLAIM-PROPOSITION · CLAIM-JUDGMENT ·
CLAIM-LINEAGE · the JUDGMENT-RECORD readers · IDENTITY-KEY ·
DURABLE-IDENTITY-DOMAIN.  No table of the desk's is consulted — there is none to
consult, which is the whole point of the exercise.

Returns (values HOPS-RESOLVED HALTED-BECAUSE).

The loop genuinely ATTEMPTS the next step: it collects every onward pointer the
claim carries and asks whether any of them IS a claim object it could stand on.
It halts only when that question is answered NO for all of them.  (An earlier
draft of this walk returned unconditionally after one iteration and then
asserted it had resolved exactly one hop — a check that could not fail, which is
not a finding but a tautology wearing one's coat.)"
  (let ((current final) (hops 0))
    (loop
      (unless (lisp-plus-slice0:claim-p current)
        (return (values hops :no-claim-object)))
      (incf hops)
      (let* ((jr (lisp-plus-slice0:claim-judgment current))
             (supports (and jr (lisp-plus-slice0:judgment-record-support-ids jr)))
             (lineage (lisp-plus-slice0:claim-lineage current)))
        (format t "     hop ~D  ~A~%" hops
                (lisp-plus-kernel0:identity-key (lisp-plus-slice0:claim-id current)))
        (format t "             proposition ~S~%"
                (second (lisp-plus-slice0:claim-proposition current)))
        (format t "             judgment    ~S by ~A v~D~%"
                (lisp-plus-slice0:judgment-record-judgment jr)
                (lisp-plus-kernel0:identity-key
                 (lisp-plus-slice0:judgment-record-procedure-id jr))
                (lisp-plus-slice0:judgment-record-procedure-version jr))
        (format t "             supported by ~S  (domains ~S)~%"
                (mapcar #'lisp-plus-kernel0:identity-key supports)
                (mapcar #'lisp-plus-kernel0:durable-identity-domain supports))
        (format t "             lineage      ~S  (domains ~S)~%"
                (mapcar #'lisp-plus-kernel0:identity-key lineage)
                (mapcar #'lisp-plus-kernel0:durable-identity-domain lineage))
        ;; THE ACTUAL ATTEMPT.  Every onward pointer, tested for whether it is
        ;; something the walk could stand on.  To take the next step the walk
        ;; would have to turn an identity back into the thing it names.  Slice /0
        ;; and Slice /1 export no such operation, and they keep no registry that
        ;; could implement one: the only global tables in either file are the
        ;; schema registry and the WHY-extractor list.
        (let ((standable (remove-if-not #'lisp-plus-slice0:claim-p
                                        (append supports lineage))))
          (if standable
              (setf current (first standable))
              (return (values hops :identity-cannot-be-dereferenced))))))))

(multiple-value-bind (hops halted) (walk-back *hop-4*)
  (desk "the walk resolved ~D claim object~:P and then stopped: ~S." hops halted)
  (desk "the road is walkable FORWARD — each hop was handed the previous claim —")
  (desk "and it is not walkable BACKWARD from a claim alone. Both onward")
  (desk "pointers a claim carries are identities, and nothing dereferences one.")
  (ok "[VI-w1] the backward walk resolves exactly ONE claim object — the one it was handed"
      (and (= 1 hops) (eq halted :identity-cannot-be-dereferenced))
      "the missing accessor: an identity -> object resolver; Slice /0 and /1 export none, and keep no registry that could back one")
  (ok "[VI-w2] the judgment's support is a :RECEIPT identity (the derivation witness), not the supporting CLAIM"
      (let ((supports (lisp-plus-slice0:judgment-record-support-ids
                       (lisp-plus-slice0:claim-judgment *hop-4*))))
        (and (= 1 (length supports))
             (eq :receipt (lisp-plus-kernel0:durable-identity-domain (first supports)))))
      "a granted claim's judgment names the witness DERIVE minted, never the claim that discharged the premise")
  (ok "[VI-w3] and the lineage names the claim's own pre-promotion shell, NOT the previous hop"
      (let ((lineage (lisp-plus-slice0:claim-lineage *hop-4*)))
        (and (= 1 (length lineage))
             (eq :claim (lisp-plus-kernel0:durable-identity-domain (first lineage)))
             (not (lisp-plus-kernel0:identity= (first lineage)
                                               (lisp-plus-slice0:claim-id *hop-3*)))))
      "the link from a granted claim to the claim that discharged its premise lives in the derivation RECEIPT alone"))

(desk "so the chain IS auditable — hop by hop, from the receipts. It is not")
(desk "auditable from the claim alone. Arm 6c walks it the way that works.")

;;; --- 6c. the chain walker that DOES reach the patron -----------------
(format t "~%   6c. the same road walked backward the way that works: from the~%")
(format t "       RECEIPTS, through immediate governed links, to the patron's~%")
(format t "       original standing and the three witnesses under it:~%")

(defun walk-the-chain (final-claim receipts)
  "Print the governed chain backward from FINAL-CLAIM.

RECEIPTS is handed in at the call site — the five objects this movement itself
produced.  This function DECIDES NOTHING: it renders governed records through
public readers and returns how many hops it rendered.  It is a printer.  If it
were a lookup table consulted to establish that a standing was real, it would be
the private authenticity oracle Movement III deleted, and it is deliberately
neither.

BE EXACT ABOUT WHAT THIS IS, because an earlier version of this docstring was
not.  It said the receipts were \"passed as an argument, never looked up\" while
the last form of this very function stepped through FIVE GLOBALS — false about
the code three screens below it, which is the defect the guide repair of
2026-07-25 was about.  The truth is a split:

  CONTENT is governed.  Every identity, judgment and procedure printed below is
  read out of the receipt itself through public readers, and the walk TERMINATES
  by discovering a receipt whose premises rest on witnesses — not by counting.

  TRAVERSAL ORDER is the application's.  Stepping from one receipt to the next
  reads *HOP-N*, because there is NO public operation that resolves a durable
  claim identity back to the object it names.  The desk knows the order because
  it walked the road forward.

So this is a VERIFIED RENDERING OF A KNOWN-ORDER CHAIN, not a self-directed
traversal, and the difference is not cosmetic: [VI-w5] is what makes the walk
worth anything, because it checks the governed records AGAINST the desk's
ordering rather than trusting it.  Obscure one link and [VI-w5] fails — that was
planted and confirmed.  A resolver from identity to object is the missing public
convenience this movement found; it is docketed, not invented here.

At each hop it reads, from the receipt alone: the conclusion that receipt
granted, which premise was discharged by an inherited claim, that claim's
durable identity, the judgment it carried, and the procedure that judged it.
The walk stops when it reaches a receipt whose premises were discharged by
WITNESSES rather than by claims — which is the patron's original standing, the
bottom of the road, where evidence enters the world."
  (let ((current-claim final-claim) (hops 0))
    (dolist (receipt receipts (values hops :reached-the-ground))
      (incf hops)
      (format t "     ┌ hop ~D  receipt for ~S~%" hops
              (second (lisp-plus-slice1:derivation-receipt-conclusion receipt)))
      (format t "     │   granted claim   ~A~%"
              (lisp-plus-kernel0:identity-key
               (lisp-plus-slice0:claim-id current-claim)))
      ;; Which premise of THIS receipt was discharged by an inherited claim?
      (let ((inherited
              (loop for a in (lisp-plus-slice1:derivation-receipt-assessments receipt)
                    for entry = (find :discharged
                                      (lisp-plus-slice1:premise-assessment-judged-claims a)
                                      :key (lambda (r) (getf r :outcome)))
                    when entry collect (cons a entry))))
        (if inherited
            (dolist (pair inherited)
              (let ((a (car pair)) (entry (cdr pair)))
                (format t "     │   premise ~S inherited from claim ~A~%"
                        (second (lisp-plus-slice1:premise-assessment-premise-pattern a))
                        (lisp-plus-kernel0:identity-key (getf entry :claim-id)))
                (format t "     │     judgment ~S by ~A v~D~%"
                        (getf entry :judgment)
                        (lisp-plus-kernel0:identity-key (getf entry :procedure-id))
                        (getf entry :procedure-version))))
            ;; No inherited claim: this receipt's premises rest on witnesses.
            (progn
              (format t "     └   THE GROUND — every premise here rests on a WITNESS:~%")
              (dolist (a (lisp-plus-slice1:derivation-receipt-assessments receipt))
                (dolist (w (lisp-plus-slice1:premise-assessment-matching-accessible-supports a))
                  (format t "           ~S  ← ~A (~S/~S) from ~S~%"
                          (second (lisp-plus-slice1:premise-assessment-premise-pattern a))
                          (lisp-plus-kernel0:identity-key (lisp-plus-slice0:witness-id w))
                          (lisp-plus-slice0:witness-mode w)
                          (lisp-plus-slice0:witness-kind w)
                          (lisp-plus-slice0:witness-source w))))
              (return (values hops :reached-the-ground)))))
      ;; Step: the claim this receipt's inherited premise named is the claim the
      ;; NEXT receipt granted.  The desk knows the ordering because it walked the
      ;; road forward; the identities let it CHECK that ordering rather than
      ;; assume it, which is what [VI-w4] asserts.
      (setf current-claim
            (case hops
              (1 *hop-3*) (2 *hop-2*) (3 *hop-1*) (4 *hop-0*) (t current-claim))))))

(multiple-value-bind (hops ended)
    (walk-the-chain *hop-4* (list *hop-4-receipt* *hop-3-receipt*
                                  *hop-2-receipt* *hop-1-receipt* *hop-0-receipt*))
  (ok "[VI-w4] the chain walker reaches the GROUND — five receipts, four inherited hops, then witnesses"
      (and (= 5 hops) (eq ended :reached-the-ground))
      "CONTENT read through public accessors and the ground DISCOVERED, not counted; ORDER supplied by the desk, because no public operation resolves an identity back to its object — [VI-w5] is what checks the one against the other")
  ;; And the ordering the walker assumed is CHECKED against the identities, so
  ;; the pretty printout cannot quietly be in the wrong order.
  (ok "[VI-w5] each receipt's inherited claim-id IS the previous hop's claim — the chain is verified by identity, not by the order the desk printed it in"
      (every (lambda (pair)
               (let* ((receipt (first pair)) (expected (second pair))
                      (entry (loop for a in (lisp-plus-slice1:derivation-receipt-assessments receipt)
                                   for e = (find :discharged
                                                 (lisp-plus-slice1:premise-assessment-judged-claims a)
                                                 :key (lambda (r) (getf r :outcome)))
                                   when e return e)))
                 (and entry (lisp-plus-kernel0:identity= (getf entry :claim-id)
                                                         (lisp-plus-slice0:claim-id expected)))))
             (list (list *hop-4-receipt* *hop-3*) (list *hop-3-receipt* *hop-2*)
                   (list *hop-2-receipt* *hop-1*) (list *hop-1-receipt* *hop-0*)))))

(desk "so: forward, the language carries standing by identity and the receipts")
(desk "record it. Backward, a READER needs the receipts — a claim alone does not")
(desk "point home. The missing public operation is an identity → object resolver;")
(desk "the desk does not build one, and holds five receipts, not a registry.")


;;;; ==================================================================
;;;; MOVEMENT VII — THE TWO CROSSINGS
;;;;
;;;; The long road ends at an AUTHORIZATION.  Two acts follow it across the
;;;; frontier: the volume is reserved off the shelf, and then it is delivered.
;;;;
;;;; Note the direction of travel and note it carefully.  The reservation is a
;;;; CONSEQUENCE of :MAY-RESERVE; the dispatch standing is derived from the
;;;; :MAY-RESERVE CLAIM and not from the reservation's outcome.  No effect is a
;;;; premise of anything here.  Movement IX is about what it costs to want one.
;;;; ==================================================================

(format t "~%── MOVEMENT VII: the two crossings (authorize, then act — never the reverse) ──~%")

(defun both-ways-key ()
  (courier-key '(:reserve :deliver)))

(defparameter *reserve-evidence* nil)
(defparameter *reserve-outcome* nil)

(format t "~%   7a. the reservation act — the shelf is asked to let the volume go:~%")
(multiple-value-bind (adapter world) (lisp-plus-fake-courier:make-fake-courier
                                      :script :clean-commit)
  (multiple-value-bind (outcome evidence)
      (lisp-plus-core0:perform
       :adapter adapter
       :request `(:predicate :reserve (:payload ,(format nil "~A ← ~A" *restricted* :ferrand)))
       :authority (both-ways-key)
       :process (lisp-plus-core0:process-context :label "peregrina/reserve/he-9"))
    ;; The desk keeps BOTH, whole.  `outcome-kind` is a three-way view it reads
    ;; when it needs to branch; it is not the account, and the account is what
    ;; gets stored.
    (setf *reserve-outcome* outcome *reserve-evidence* evidence)
    (desk "outcome-kind => ~S  (a view, not the account)"
          (lisp-plus-core0:outcome-kind outcome))
    (desk "attempt ~A" (lisp-plus-kernel0:identity-key
                        (lisp-plus-core0:core0-evidence-attempt-id evidence)))
    (desk "seat    ~A" (lisp-plus-kernel0:identity-key
                        (lisp-plus-core0:core0-evidence-seat-id evidence)))
    (desk "ledger  ~A, over ~D recorded event~:P"
          (lisp-plus-core0:core0-evidence-ledger-token evidence)
          (length (lisp-plus-core0:core0-evidence-events evidence)))
    (ok "[VII-a] the reserve act crosses under a capability scoped to :RESERVE and commits"
        (and (eq :committed (lisp-plus-core0:outcome-kind outcome))
             (= 1 (lisp-plus-fake-courier:fake-courier-ledger-row-count world))))
    (ok "[VII-b] the evidence carries an ATTEMPT IDENTITY and a LEDGER TOKEN — the desk stored the account, not a verdict"
        (and (lisp-plus-kernel0:durable-identity-p
              (lisp-plus-core0:core0-evidence-attempt-id evidence))
             (eq :attempt (lisp-plus-kernel0:durable-identity-domain
                           (lisp-plus-core0:core0-evidence-attempt-id evidence)))
             (stringp (lisp-plus-core0:core0-evidence-ledger-token evidence))
             (lisp-plus-kernel0:durable-identity-p
              (lisp-plus-core0:core0-evidence-seat-id evidence))
             (plusp (length (lisp-plus-core0:core0-evidence-events evidence)))))))

(format t "~%   7b. the dispatch standing comes from the CLAIM, not from the reservation:~%")
(desk "the volume is off the shelf because :MAY-RESERVE was granted. Nothing")
(desk "the reservation DID is a premise of anything. The road runs one way.")
(ok "[VII-c] hop 4 was derived from the :MAY-RESERVE claim, and its receipt says so"
    (and *hop-4*
         (eq :verified (lisp-plus-slice0:judgment-record-judgment
                        (lisp-plus-slice0:claim-judgment *hop-4*)))
         (equal (lisp-plus-slice0:claim-proposition *hop-4*)
                (np `(:predicate :may-dispatch (:patron :ferrand)
                      (:volume ,*restricted*) (:courier :brass-courier)))))
    "derived before either crossing happened — the ordering is in the program, not in a comment")

(format t "~%   7c. the delivery — Speculum Peregrinum leaves the building:~%")
(defparameter *deliver-evidence* nil)
(defparameter *world-he* nil)
(multiple-value-bind (adapter world) (lisp-plus-fake-courier:make-fake-courier
                                      :script :clean-commit)
  (setf *world-he* world)
  (multiple-value-bind (outcome evidence)
      (lisp-plus-core0:perform
       :adapter adapter :request (dispatch-request *restricted* :ferrand)
       :authority (both-ways-key)
       :process (lisp-plus-core0:process-context :label "peregrina/dispatch/he-9"))
    (setf *deliver-evidence* evidence)
    (desk "outcome-kind => ~S" (lisp-plus-core0:outcome-kind outcome))
    (ecase (lisp-plus-core0:outcome-kind outcome)
      (:committed
       (push (make-loan :volume *restricted* :patron :ferrand :opened *today*
                        :due (reckon-due-day *today* (shelf-lookup *restricted*))
                        :status :in-transit-confirmed
                        :token (lisp-plus-core0:core0-evidence-ledger-token evidence))
             *loans*)
       (setf (gethash *restricted* *shelf-state*) :on-loan)
       (desk "loan opened, due day ~D, receipt ~A"
             (loan-due (first *loans*)) (loan-token (first *loans*))))
      (:refused (desk "unreachable by return."))
      (:indeterminate (desk "unreachable by return.")))
    (ok "[VII-d] the delivery commits: one ledger row, one loan, one clock started"
        (and (eq :committed (lisp-plus-core0:outcome-kind outcome))
             (= 1 (lisp-plus-fake-courier:fake-courier-ledger-row-count world))
             (= (+ *today* 14) (loan-due (first *loans*)))))))

(format t "~%   7d. the second crossing — the reciprocity docket owed to Collegium~%")
(format t "       Boreale, whose courier is interrupted and whose ledger withholds:~%")
(defparameter *world-docket* nil)
(defparameter *docket-evidence* nil)
(multiple-value-bind (adapter world) (lisp-plus-fake-courier:make-fake-courier
                                      :script :kill-after-commit-withhold)
  (setf *world-docket* world)
  (handler-case
      (lisp-plus-core0:perform
       :adapter adapter
       :request '(:predicate :deliver (:payload "docket ms-He-9 → collegium-boreale"))
       :authority (both-ways-key)
       :process (lisp-plus-core0:process-context :label "peregrina/dispatch/docket"))
    (lisp-plus-core0:core0-interrupted (c)
      (let ((outcome (lisp-plus-core0:core0-condition-outcome c)))
        (setf *docket-evidence* (lisp-plus-core0:core0-condition-evidence c))
        (desk "outcome-kind => ~S; the desk holds no token; the ledger holds ~D row~:P."
              (lisp-plus-core0:outcome-kind outcome)
              (lisp-plus-fake-courier:fake-courier-ledger-row-count world))
        (ok "[VII-e] the interrupted docket is :INDETERMINATE, and the desk was told no token"
            (and (eq :indeterminate (lisp-plus-core0:outcome-kind outcome))
                 (null (lisp-plus-core0:core0-evidence-ledger-token
                        *docket-evidence*))))))))

(format t "~%   and the desk continues from the surviving evidence — it does not resend:~%")
(let* ((rows-before (lisp-plus-fake-courier:fake-courier-ledger-row-count *world-docket*))
       (result (lisp-plus-core0:continue-from *docket-evidence*
                                              :authority (both-ways-key)))
       (disposition (lisp-plus-core0:continuation-result-disposition result))
       (required (lisp-plus-core0:continuation-result-required-action result))
       (rows-after (lisp-plus-fake-courier:fake-courier-ledger-row-count *world-docket*)))
  (desk "disposition => ~S" disposition)
  (format t "     known:           ~S~%" (getf required :known))
  (format t "     unknown:         ~S~%" (getf required :unknown))
  (format t "     required-action: ~S~%" (getf required :required-action))
  (ecase disposition
    (:reconciled (desk "unreachable in this arm."))
    (:indeterminate
     (push (make-tracer :id "T-2" :volume *restricted* :patron :collegium-boreale
                        :known (getf required :known)
                        :unknown (getf required :unknown)
                        :required-action (getf required :required-action))
           *tracers*)
     (desk "tracer T-2 opened against the reciprocal library's docket.")
     (desk "no second docket is sent; no hold is entered; nothing is called settled.")))
  (ok "[VII-f] the withheld docket routes to RECONCILIATION — not to a confirmation"
      (and (eq :indeterminate disposition)
           (find "T-2" *tracers* :key #'tracer-id :test #'string=)))
  (ok "[VII-g] the continuation did NOT re-invoke the courier (row count unchanged)"
      (and (= 1 rows-before) (= 1 rows-after)))
  (ok "[VII-h] and nothing phantom was written: no loan, no due date, no hold for the docket"
      (and (null (find "docket" *loans* :key #'loan-volume :test #'string=))
           (null (find :collegium-boreale *hold-queue* :key #'car))
           (notany (lambda (l) (and (string= (loan-volume l) *restricted*)
                                    (null (loan-due l))))
                   *loans*))
      "the one loan on ms-He-9 is the CONFIRMED delivery; the unconfirmed docket produced a tracer and nothing else"))


;;;; ==================================================================
;;;; MOVEMENT VIII — THE THREE REFUSALS
;;;;
;;;; A road worth having is a road that can be barred.  Three ways the long road
;;;; stops, and one door in its side that stays open.
;;;; ==================================================================

(format t "~%── MOVEMENT VIII: the three refusals (where the long road stops) ──~%")

;;; --- B. the refused patron cannot start ------------------------------
(format t "~%   B. Quillon — still owing 14 crowns — asks for the restricted volume:~%")

(defparameter *quillon-restricted* (consider-borrowing :quillon *restricted*)
  "Nothing. Movement II's arithmetic denies him a fines-clear witness, so no
:MAY-BORROW claim exists to hand to hop 1.")

(ok "[VIII-b1] the desk holds no borrowing standing for Quillon — hop 0 never produced one"
    (null *quillon-restricted*))

(let ((supports (remove nil (list *quillon-restricted* *reciprocity*))))
  (multiple-value-bind (claim receipt)
      (consider :schema :reciprocity-standing :version 1
                :conclusion (np `(:predicate :reciprocal-eligible (:patron :quillon)
                                  (:volume ,*restricted*)))
                :supports supports :receiver (apply #'at-the-desk supports))
    (say-the-verdict receipt)
    (ok "[VIII-b2] the road stops at hop 1, and the RECEIPT is the reason — no guard of mine fired"
        (and (null claim)
             (equal '(:blocked-on :may-borrow :missing) (verdict receipt))))))

(format t "~%   Quillon's desk mints itself the eligibility it was not granted:~%")
(let ((self-minted
        (lisp-plus-slice0:claim
         :proposition (np `(:predicate :reciprocal-eligible (:patron :quillon)
                            (:volume ,*restricted*)))
         :by :peregrina)))
  (let ((supports (list self-minted *clearance*)))
    (multiple-value-bind (claim receipt)
        (consider :schema :restricted-access-standing :version 1
                  :conclusion (np `(:predicate :may-access-restricted (:patron :quillon)
                                    (:volume ,*restricted*)))
                  :supports supports :receiver (apply #'at-the-desk supports))
      (let ((entry (roster-entry-for receipt :reciprocal-eligible self-minted)))
        (desk "the proposition matches to the letter. It still does not travel.")
        (ok "[VIII-b3] a claim whose text is right and whose judgment is absent lands :UNJUDGED"
            (and (null claim)
                 (eq :missing (disposition-of receipt :reciprocal-eligible))
                 entry (eq :unjudged (getf entry :outcome)))
            "matching text is not standing; standing is a governed judgment or it is nothing")))))

;;; --- C. the intermediate the receiver was not given ------------------
(format t "~%   C. a perfectly good access standing, offered to a desk not given it:~%")
(let ((supports (list *hop-2* (availability-support "ms-Beth-3"))))
  (multiple-value-bind (claim receipt)
      (consider :schema :reservation-standing :version 1
                :conclusion (np `(:predicate :may-reserve (:patron :ferrand)
                                  (:volume ,*restricted*)))
                :supports supports
                ;; the volume-unreserved witness is reachable; the CLAIM is not.
                :receiver (at-the-desk (availability-support *restricted*)))
    (say-the-verdict receipt)
    (let ((entry (roster-entry-for receipt :may-access-restricted *hop-2*))
          (repair (repair-for receipt :may-access-restricted)))
      (ok "[VIII-c1] the premise is :INACCESSIBLE — emphatically NOT :MISSING"
          (and (null claim)
               (eq :inaccessible (disposition-of receipt :may-access-restricted)))
          "the desk is not told 'find evidence'; it is told 'you were not given the right to read the evidence you have'")
      (ok "[VIII-c2] and the roster says exactly which claim, and exactly why"
          (and entry (eq :inaccessible-to-receiver (getf entry :outcome))))
      ;; the repair is printed verbatim above, by SAY-THE-VERDICT, out of the
      ;; receipt's own DERIVATION-RECEIPT-REPAIR-OPTIONS — not paraphrased here.
      (ok "[VIII-c3] the repair names the claim by DURABLE IDENTITY"
          (equal (mapcar #'lisp-plus-kernel0:identity-key
                         (getf repair :grant-receiver-access-to-judged-claims))
                 (list (lisp-plus-kernel0:identity-key
                        (lisp-plus-slice0:claim-id *hop-2*))))))))

;;; --- E. the direct-witness door, which is open, and labelled --------
(format t "~%   E. THE COUNTEREXAMPLE ARM. The desk asserts a reservation standing~%")
(format t "      it never derived, and compares the two receipts side by side:~%")

(let* ((asserted (fabricate-standing
                  (np `(:predicate :may-reserve (:patron :ferrand)
                        (:volume ,*restricted*)))
                  "receipt:no-such-thing"))
       (supports (list asserted *insurance*)))
  (multiple-value-bind (claim receipt)
      (consider :schema :dispatch-standing :version 2
                :conclusion (np `(:predicate :may-dispatch (:patron :ferrand)
                                  (:volume ,*restricted*) (:courier :brass-courier)))
                :supports supports :receiver (apply #'at-the-desk supports))
    (let ((a (assessment-for receipt :may-reserve)))
      (ok "[VIII-e1] the ASSERTED standing grants too — the :DIRECT door is open, and this movement does not close it"
          (and claim (eq :granted (lisp-plus-slice1:derivation-receipt-decision receipt))))
      (ok "[VIII-e2] but it leaves a WITNESS and no judged-claim record"
          (and (lisp-plus-slice1:premise-assessment-matching-accessible-supports a)
               (null (lisp-plus-slice1:premise-assessment-judged-claims a))))
      (ok "[VIII-e3] while the inherited standing left a judged-claim record with a judgment basis and NO witness"
          (let ((entry (roster-entry-for *hop-4-receipt* :may-reserve *hop-3*))
                (b (assessment-for *hop-4-receipt* :may-reserve)))
            (and entry
                 (eq :discharged (getf entry :outcome))
                 (lisp-plus-kernel0:durable-identity-p (getf entry :procedure-id))
                 (null (lisp-plus-slice1:premise-assessment-matching-accessible-supports b))))
          "the two are told apart from the receipts alone — a reader sees a judgment basis or a witness, never both"))))


;;;; ==================================================================
;;;; MOVEMENT IX — THE EFFECT FRONTIER
;;;;
;;;; The desk would like to close the loan.  Settlement means: this patron may be
;;;; dispatched to (a standing — lawful, a claim), AND this dispatch actually
;;;; HAPPENED (an effect — and there the road ends).
;;;;
;;;; The schema is written honestly, with both premises named.  Then the desk
;;;; tries every species of support the language offers for the second one, in
;;;; order, and records what each actually does.  Nothing here is a proposal.
;;;; ==================================================================

(format t "~%── MOVEMENT IX: the effect frontier (settlement wants the world) ──~%")

(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :settlement-standing :version 1
  :conclusion (pp '(:predicate :loan-settled (:patron (:var :patron))
                    (:volume (:var :volume))))
  :premises
  (list (pp '(:predicate :may-dispatch (:patron (:var :patron))
              (:volume (:var :volume)) (:courier (:var :courier))))
        (pp '(:predicate :dispatch-acknowledged (:volume (:var :volume))
              (:courier (:var :courier)))))
  :locals '(:courier)))

(defparameter *acknowledgment*
  (np `(:predicate :dispatch-acknowledged (:volume ,*restricted*)
        (:courier :brass-courier)))
  "The proposition the settlement schema's second premise wants: not a standing
the desk can derive, but a fact about the world outside the desk.")

(defun consider-settlement (&rest extra)
  "Always offer the lawful half (the dispatch CLAIM); vary the other half."
  (let ((supports (remove nil (cons *hop-4* extra))))
    (consider :schema :settlement-standing :version 1
              :conclusion (np `(:predicate :loan-settled (:patron :ferrand)
                                (:volume ,*restricted*)))
              :supports supports :receiver (apply #'at-the-desk supports))))

(format t "~%   probe 1 — the desk offers nothing for the acknowledgment:~%")
(defparameter *lawful-settlement-receipt* nil
  "Probe 1's receipt: the settlement attempt made with ONLY lawful supports —
the dispatch CLAIM, and nothing minted for the acknowledgment.  This is the
receipt arm 9e reads to decide what happens to the loan, because it is the only
settlement receipt in this movement whose grant would have rested on a governed
judgment.  Every other probe below grants on something the desk asserted.")
(multiple-value-bind (claim receipt) (consider-settlement)
  (setf *lawful-settlement-receipt* receipt)
  (say-the-verdict receipt)
  (ok "[IX-1] with nothing offered the effect premise is :MISSING (and the CLAIM half is :SATISFIED)"
      (and (null claim)
           (eq :missing (disposition-of receipt :dispatch-acknowledged))
           (eq :satisfied (disposition-of receipt :may-dispatch)))))

(format t "~%   probe 2 — the desk mints itself a claim that the dispatch was acknowledged:~%")
(let ((self-minted (lisp-plus-slice0:claim :proposition *acknowledgment* :by :peregrina)))
  (multiple-value-bind (claim receipt) (consider-settlement self-minted)
    (let ((entry (roster-entry-for receipt :dispatch-acknowledged self-minted)))
      (ok "[IX-2] a self-minted claim is SEEN, recorded, and refused — :UNJUDGED"
          (and (null claim)
               (eq :missing (disposition-of receipt :dispatch-acknowledged))
               entry (eq :unjudged (getf entry :outcome)))
          "the desk cannot bootstrap a fact about the world by asserting it"))))

(format t "~%   probe 3 — the courier's TESTIMONY, constructed at the level the~%")
(format t "             language insists on:~%")
(defparameter *courier-testimony*
  (lisp-plus-slice0:witness
   :for (list :asserted :brass-courier *acknowledgment*)
   :mode :testimony :kind :courier-report :source :brass-courier))
(format t "     its :FOR is the attribution, whole: ~S~%"
        (lisp-plus-slice0:witness-for *courier-testimony*))
(format t "     the premise wants:                 ~S~%" *acknowledgment*)
(multiple-value-bind (claim receipt) (consider-settlement *courier-testimony*)
  (ok "[IX-3] a :TESTIMONY witness is :FOR the ATTRIBUTION, so it does not discharge the ground premise"
      (and (null claim)
           (eq :missing (disposition-of receipt :dispatch-acknowledged))
           (eq :asserted (first (lisp-plus-slice0:witness-for *courier-testimony*)))
           (not (equal (lisp-plus-slice0:witness-for *courier-testimony*)
                       *acknowledgment*)))
      "the courier saying so is a fact about the courier's saying, and the language will not let the two be confused"))

(format t "~%   probe 4 — a :DIRECT witness carrying the real crossing: the attempt~%")
(format t "             identity in :PROCEDURE, the ledger token in :CONTENT:~%")
(defparameter *true-ledger-witness*
  (lisp-plus-slice0:witness
   :for *acknowledgment* :mode :direct :kind :courier-ledger :source :brass-courier
   :procedure (lisp-plus-core0:core0-evidence-attempt-id *deliver-evidence*)
   :content (list :ledger-token
                  (lisp-plus-core0:core0-evidence-ledger-token *deliver-evidence*))))
(defparameter *true-settlement-receipt* nil)
(multiple-value-bind (claim receipt) (consider-settlement *true-ledger-witness*)
  (setf *true-settlement-receipt* receipt)
  (say-the-verdict receipt)
  (ok "[IX-4] the :DIRECT witness DISCHARGES the effect premise — settlement granted"
      (and claim
           (eq :satisfied (disposition-of receipt :dispatch-acknowledged))
           (eq :granted (lisp-plus-slice1:derivation-receipt-decision receipt)))))

(format t "~%   probe 5 — the same witness, RAISED into a judged claim first, then~%")
(format t "             chained the lawful way:~%")
(defparameter *ledger-reading*
  (lisp-plus-slice0:promotion-procedure
   :descriptor (lisp-plus-kernel0:make-procedure-descriptor
                :procedure-id (lisp-plus-kernel0:make-identity
                               :procedure "peregrina/read-the-courier-ledger")
                :version 1
                :judgment-class :semantic
                :result-vocabulary '(:verified :refuted))
   :admits '((:direct :courier-ledger)))
  "A promotion procedure that admits exactly one shape of support: a direct
courier-ledger reading.  Admissibility is a (MODE KIND) membership test and
nothing else — remember that when probe 6 arrives.")

(defun raise-acknowledgment (w)
  (lisp-plus-slice0:raise
   (lisp-plus-slice0:claim :proposition *acknowledgment* :by :peregrina)
   :to :verified :per *ledger-reading* :considering (list w) :receiver :peregrina))

(defparameter *true-ack-claim* (raise-acknowledgment *true-ledger-witness*))
(defparameter *raised-settlement-receipt* nil)
(multiple-value-bind (claim receipt) (consider-settlement *true-ack-claim*)
  (setf *raised-settlement-receipt* receipt)
  (let ((entry (roster-entry-for receipt :dispatch-acknowledged *true-ack-claim*)))
    (desk "the reading becomes a judged claim, and the judged claim chains like any other.")
    (ok "[IX-5] RAISE produces a genuinely :VERIFIED claim that then chains lawfully — :DISCHARGED"
        (and claim
             (eq :verified (lisp-plus-slice0:judgment-record-judgment
                            (lisp-plus-slice0:claim-judgment *true-ack-claim*)))
             entry (eq :discharged (getf entry :outcome))
             (eq :verified (getf entry :judgment))))))

;;; --- 9b. the same road, walked by a lie ------------------------------
(format t "~%   9b. THE COUNTEREXAMPLE ARM. No crossing happened. The desk invents~%")
(format t "       an attempt identity and a ledger token and offers those instead:~%")

(defparameter *fabricated-ledger-witness*
  (lisp-plus-slice0:witness
   :for *acknowledgment* :mode :direct :kind :courier-ledger :source :brass-courier
   :procedure (lisp-plus-kernel0:make-identity :attempt "peregrina/crossing-that-never-was")
   :content (list :ledger-token "fake:courier:0000"))
  "Nothing produced this. There is no such attempt and no such row.")

(defparameter *fabricated-settlement-receipt* nil)
(multiple-value-bind (claim receipt) (consider-settlement *fabricated-ledger-witness*)
  (setf *fabricated-settlement-receipt* receipt)
  (ok "[IX-6] the fabrication DISCHARGES the effect premise identically — same disposition, same decision"
      (and claim
           (eq :satisfied (disposition-of receipt :dispatch-acknowledged))
           (eq :granted (lisp-plus-slice1:derivation-receipt-decision receipt)))))

;;; Now the comparison, field by field, through the public readers — because a
;;; claim about indistinguishability that is not computed is just a mood.
(defun effect-premise-of (receipt)
  (assessment-for receipt :dispatch-acknowledged))

(defparameter *assessment-readers*
  (list (cons :disposition #'lisp-plus-slice1:premise-assessment-disposition)
        (cons :premise-pattern #'lisp-plus-slice1:premise-assessment-premise-pattern)
        ;; CHARTER-DELTA-4: the LEGACY projection name, kept as the reader this
        ;; comparison has always used; its precise name is
        ;; PREMISE-ASSESSMENT-PROJECTED-PREMISE-INSTANCES and it returns the same value.
        (cons :ground-instances #'lisp-plus-slice1:premise-assessment-ground-instances)
        (cons :judged-claims #'lisp-plus-slice1:premise-assessment-judged-claims)
        (cons :matching-inaccessible #'lisp-plus-slice1:premise-assessment-matching-inaccessible-supports)
        (cons :mismatched-candidates #'lisp-plus-slice1:premise-assessment-mismatched-candidates)
        (cons :refuting-supports #'lisp-plus-slice1:premise-assessment-refuting-supports)
        ;; CHARTER-DELTA-4: the second refuting species has its own reader, and a
        ;; list that claims to be "every public reader" must carry it -- otherwise
        ;; an indistinguishability finding is computed over an incomplete surface.
        (cons :refuting-witnesses #'lisp-plus-slice1:premise-assessment-refuting-witnesses)
        (cons :binding-environments #'lisp-plus-slice1:premise-assessment-binding-environments)
        (cons :ambiguities #'lisp-plus-slice1:premise-assessment-ambiguities))
  "Every public reader of a premise assessment EXCEPT MATCHING-ACCESSIBLE-SUPPORTS,
which holds the witness objects themselves and is compared separately below.")

(format t "~%   the two receipts, read through every public accessor:~%")
(let* ((true-a (effect-premise-of *true-settlement-receipt*))
       (fake-a (effect-premise-of *fabricated-settlement-receipt*))
       (differing (remove-if (lambda (pair)
                               (equal (funcall (cdr pair) true-a)
                                      (funcall (cdr pair) fake-a)))
                             *assessment-readers*)))
  (dolist (pair *assessment-readers*)
    (format t "     ~24S ~A~%" (car pair)
            (if (member pair differing) "DIFFERS" "identical")))
  (ok "[IX-7] every public reader of the effect premise is IDENTICAL between the true receipt and the fabricated one, save the one holding the witnesses"
      (null differing))
  (let ((tw (first (lisp-plus-slice1:premise-assessment-matching-accessible-supports true-a)))
        (fw (first (lisp-plus-slice1:premise-assessment-matching-accessible-supports fake-a))))
    (format t "     matching-accessible      1 witness each; governed attributes:~%")
    (format t "       mode/kind/polarity/source  ~S vs ~S~%"
            (list (lisp-plus-slice0:witness-mode tw) (lisp-plus-slice0:witness-kind tw)
                  (lisp-plus-slice0:witness-polarity tw) (lisp-plus-slice0:witness-source tw))
            (list (lisp-plus-slice0:witness-mode fw) (lisp-plus-slice0:witness-kind fw)
                  (lisp-plus-slice0:witness-polarity fw) (lisp-plus-slice0:witness-source fw)))
    (format t "       :procedure                 ~S vs ~S~%"
            (lisp-plus-kernel0:identity-key (lisp-plus-slice0:witness-procedure tw))
            (lisp-plus-kernel0:identity-key (lisp-plus-slice0:witness-procedure fw)))
    (format t "       :content                   ~S vs ~S~%"
            (lisp-plus-slice0:witness-content tw) (lisp-plus-slice0:witness-content fw))
    ;; The honest form of the finding, weakened to what the comparison shows.
    (ok "[IX-8] the two witnesses are identical in every attribute the language GOVERNS, and differ only in the two fields it merely CARRIES"
        (and (equal (lisp-plus-slice0:witness-mode tw) (lisp-plus-slice0:witness-mode fw))
             (equal (lisp-plus-slice0:witness-kind tw) (lisp-plus-slice0:witness-kind fw))
             (equal (lisp-plus-slice0:witness-polarity tw) (lisp-plus-slice0:witness-polarity fw))
             (equal (lisp-plus-slice0:witness-source tw) (lisp-plus-slice0:witness-source fw))
             (not (equal (lisp-plus-kernel0:identity-key (lisp-plus-slice0:witness-procedure tw))
                         (lisp-plus-kernel0:identity-key (lisp-plus-slice0:witness-procedure fw))))
             (not (equal (lisp-plus-slice0:witness-content tw)
                         (lisp-plus-slice0:witness-content fw))))
        "so a READER can see two different strings; nothing tells the reader which of them names a crossing that happened")))

;;; The strongest available form of "carried, not checked": strip both fields
;;; entirely and watch the premise discharge exactly the same.
(format t "~%   9c. and the two carried fields are not load-bearing at all:~%")
(let ((empty-handed
        (lisp-plus-slice0:witness
         :for *acknowledgment* :mode :direct :kind :courier-ledger :source :nobody)))
  (multiple-value-bind (claim receipt) (consider-settlement empty-handed)
    (desk "a witness with NO :PROCEDURE and NO :CONTENT — no attempt, no token, nothing:")
    (ok "[IX-9] a witness carrying NO effect account whatsoever discharges the premise identically"
        (and claim
             (eq :satisfied (disposition-of receipt :dispatch-acknowledged))
             (null (lisp-plus-slice0:witness-procedure empty-handed))
             (null (lisp-plus-slice0:witness-content empty-handed)))
        "promotion admissibility is a (MODE KIND) membership test; it never reads :PROCEDURE or :CONTENT")))

;;; And on the lawful-looking route — RAISE, then chain — the account does not
;;; even survive into the receiving receipt.
(defun durable-identities-in (x)
  "Every durable identity reachable as a leaf of the cons structure X.  Struct
leaves are not descended into; the caller asserts separately that there are none."
  (cond ((lisp-plus-kernel0:durable-identity-p x) (list x))
        ((consp x) (append (durable-identities-in (car x))
                           (durable-identities-in (cdr x))))
        (t nil)))

(format t "~%   9d. and on the RAISED route the account does not survive the promotion:~%")
(let* ((a (effect-premise-of *raised-settlement-receipt*))
       (reachable (append (durable-identities-in
                           (lisp-plus-slice1:premise-assessment-judged-claims a))
                          (durable-identities-in
                           (lisp-plus-slice1:premise-assessment-ground-instances a))
                          (durable-identities-in
                           (lisp-plus-slice1:premise-assessment-binding-environments a))))
       (jr (lisp-plus-slice0:claim-judgment *true-ack-claim*)))
  (format t "     the judgment record keeps: judgment ~S, procedure ~A v~D, supports ~S~%"
          (lisp-plus-slice0:judgment-record-judgment jr)
          (lisp-plus-kernel0:identity-key (lisp-plus-slice0:judgment-record-procedure-id jr))
          (lisp-plus-slice0:judgment-record-procedure-version jr)
          (mapcar #'lisp-plus-kernel0:durable-identity-domain
                  (lisp-plus-slice0:judgment-record-support-ids jr)))
  (ok "[IX-10] the receiving receipt holds NO witness object and NO :ATTEMPT identity — the crossing's identity is gone by the time the claim chains"
      (and (null (lisp-plus-slice1:premise-assessment-matching-accessible-supports a))
           (notany (lambda (i) (eq :attempt (lisp-plus-kernel0:durable-identity-domain i)))
                   reachable)
           (notany (lambda (i) (eq :attempt (lisp-plus-kernel0:durable-identity-domain i)))
                   (lisp-plus-slice0:judgment-record-support-ids jr)))
      "the judgment record keeps the WITNESS's id, never what the witness was carrying"))

;;; --- 9d-bis. the sixth species: the effect account ITSELF ------------
;;;
;;; Every probe so far handed `derive` something the language RECOGNIZES — a
;;; claim, a testimony witness, a direct witness — and probe 4 only carried the
;;; crossing INSIDE a witness the desk minted.  The one species never tried is
;;; the account itself: the Core /0 evidence object, handed straight across.
;;;
;;; This probe was added when CHARTER-DELTA-3 landed, and it is worth being
;;; exact about what changed and what did not.  BEFORE the delta, this call was
;;; observationally identical to probe 1 — supplying the account and supplying
;;; NOTHING produced the same receipt through every public reader, so the desk
;;; could not tell an offering from an omission.  AFTER it, the disposition is
;;; the SAME (:MISSING — the account is not admissible and nothing here makes it
;;; so) but the receipt now RECORDS that something was supplied, and where.
;;;
;;; Visibility is not admissibility.  The frontier has not moved.
;;;
;;; NB on numbering: the check names below continue past the movement's highest
;;; existing name rather than being inserted into the sequence.  Names in this
;;; file are quoted verbatim in FIELD-REPORT.md and RUN-RECEIPT.txt, so they are
;;; append-only.
(format t "~%   9d-bis. the account itself, handed straight to derive:~%")
(multiple-value-bind (claim receipt) (consider-settlement *deliver-evidence*)
  (let ((residue (lisp-plus-slice1:derivation-receipt-unsupported-supports receipt))
        (none (lisp-plus-slice1:derivation-receipt-unsupported-supports
               *lawful-settlement-receipt*)))
    (desk "the desk offers the crossing's own account — attempt ~A, ledger ~A —"
          (lisp-plus-kernel0:identity-key
           (lisp-plus-core0:core0-evidence-attempt-id *deliver-evidence*))
          (lisp-plus-core0:core0-evidence-ledger-token *deliver-evidence*))
    (desk "not wrapped in a witness, not restated as a claim: the account itself.")
    ;; the indices only, formatted as a fixed-width line: a bare ~S of the
    ;; descriptors would let the pretty-printer's right margin decide where this
    ;; line breaks, and a receipt that must be byte-identical across runs cannot
    ;; afford a field whose shape depends on the printer's idea of a margin.
    (desk "the effect premise says ~S; the receipt records an unsupported ~
value at :supports[~{~D~^, ~}]."
          (disposition-of receipt :dispatch-acknowledged)
          (mapcar (lambda (u) (getf u :index)) residue))
    (ok "[IX-15] the Core /0 effect account is NOT admitted: the premise is still :MISSING and settlement is still refused"
        (and (null claim)
             (eq :missing (disposition-of receipt :dispatch-acknowledged))
             (let ((a (effect-premise-of receipt))
                   (b (effect-premise-of *lawful-settlement-receipt*)))
               (and (null (lisp-plus-slice1:premise-assessment-matching-accessible-supports a))
                    (null (lisp-plus-slice1:premise-assessment-matching-inaccessible-supports a))
                    (null (lisp-plus-slice1:premise-assessment-mismatched-candidates a))
                    (null (lisp-plus-slice1:premise-assessment-refuting-supports a))
                    ;; and it did NOT slip into the judged-claim roster: the
                    ;; roster is EXACTLY what it is when only the lawful
                    ;; dispatch claim is offered.  (The roster is not empty —
                    ;; it holds that claim, considered here and not
                    ;; discharging, which is Sol Decision 1 working as
                    ;; designed.  The point is that the account added nothing
                    ;; to it, because an account is not a claim.)
                    (equal (lisp-plus-slice1:premise-assessment-judged-claims a)
                           (lisp-plus-slice1:premise-assessment-judged-claims b))
                    (notany (lambda (e) (eq :discharged (getf e :outcome)))
                            (lisp-plus-slice1:premise-assessment-judged-claims a)))))
        "an effect account is not a witness, not a refutation and not a claim — Delta /3 records it at the receipt, and records nothing more")
    (ok "[IX-16] and supplying it is no longer indistinguishable from supplying nothing: the receipt names the exact input position"
        (and (equal residue '((:index 1 :reason :unsupported-support-species)))
             (null none)
             ;; the two receipts still agree on every decision-bearing field —
             ;; the residue is a record, not an effect
             (eq (lisp-plus-slice1:derivation-receipt-decision receipt)
                 (lisp-plus-slice1:derivation-receipt-decision *lawful-settlement-receipt*))
             (eq (disposition-of receipt :dispatch-acknowledged)
                 (disposition-of *lawful-settlement-receipt* :dispatch-acknowledged))
             (eq (disposition-of receipt :may-dispatch)
                 (disposition-of *lawful-settlement-receipt* :may-dispatch)))
        "index 1 is where the desk put it: the dispatch claim is index 0, the account index 1")))

(format t "~%   ── where the road ends, stated exactly ──~%")
(desk "The effect account can be CARRIED. A kernel0 attempt identity fits in")
(desk ":PROCEDURE, a ledger token fits in :CONTENT, and a reader can read both")
(desk "back out of the receipt. It cannot be CHECKED. No governed operation")
(desk "consumes either field: promotion admissibility is a (MODE KIND) pair")
(desk "membership test, and [IX-9] shows a witness carrying nothing at all")
(desk "discharging exactly as well. The judgment record does not preserve them")
(desk "([IX-10]), so what survives a promotion is the witness's id and nothing")
(desk "the witness was holding.")
(format t "~%")
(desk "One thing here DID change, and it is smaller than it sounds. Handing the")
(desk "account itself to `derive` used to be indistinguishable from handing over")
(desk "nothing: same disposition, same receipt, no trace. CHARTER-DELTA-3 makes")
(desk "the offering visible — the receipt now records an unsupported value at")
(desk "the exact position the desk put it ([IX-16]). It records that something")
(desk "was offered and had no effect. It does not make it evidence: the premise")
(desk "is still :MISSING and settlement is still refused ([IX-15]). The desk can")
(desk "now prove it tried. It still cannot prove the dispatch was acknowledged.")
(format t "~%")   ; a blank line, not an empty desk utterance (which would emit
                  ; a bullet followed by trailing whitespace into the receipt)
(desk "So the frontier is not a wall the desk was refused at. It is a place where")
(desk "the receipts stop meaning what they look like they mean. Everything from")
(desk "Movement VI to Movement VII was governed: a premise was satisfied because")
(desk "a judgment existed and the receipt named it. Cross into settlement and the")
(desk "premise is satisfied because the desk SAID SO in the one mode reserved for")
(desk "what it saw with its own eyes — and the desk's discipline in saying so")
(desk "truthfully is unverified application discipline, exactly the kind the")
(desk "deletion of the private grants table removed from the claim frontier.")
(desk "The desk stops here. It does not propose a bridge.")

;;; --- 9e. so what does the desk actually DO about ms-He-9? ------------
;;;
;;; A finding the program only PRINTS is a finding the program does not believe.
;;; The loan on Speculum Peregrinum is open.  Settlement is where a loan closes.
;;; The desk has just established that it cannot reach settlement lawfully — so
;;; the loan must land in a state that says so, and that state must come out of
;;; the receipt rather than out of the desk's mood.
(format t "~%   9e. and so the loan on ~A lands in an honest state:~%" *restricted*)

(defparameter *he-9-disposition* nil)

(let* ((d (disposition-of *lawful-settlement-receipt* :dispatch-acknowledged))
       (loan (find *restricted* *loans* :key #'loan-volume :test #'string=)))
  (desk "the lawful settlement receipt says :DISPATCH-ACKNOWLEDGED is ~S." d)
  ;; THE BRANCH.  The disposition chooses the state; the desk chooses nothing.
  (setf *he-9-disposition*
        (ecase d
          (:satisfied     :settled)
          (:refuted       :settlement-refused)
          (:inaccessible  :reconciliation-required)
          (:missing       :dispatch-unacknowledged)))
  (setf (loan-status loan) *he-9-disposition*)
  (push (make-tracer :id "T-3" :volume *restricted* :patron :ferrand
                     :known (list :dispatched t :ledger-token (loan-token loan))
                     :unknown (list :acknowledged :unestablished)
                     :required-action :obtain-governed-acknowledgment)
        *tracers*)
  (desk "→ loan status set to ~S; tracer T-3 opened; the loan is NOT closed."
        *he-9-disposition*)
  (desk "  the desk holds a ledger token from a crossing that really happened,")
  (desk "  and still cannot close the loan — because a token is a thing it was")
  (desk "  TOLD, and settlement asks for a thing that was JUDGED.")
  (ok "[IX-11] the loan lands :DISPATCH-UNACKNOWLEDGED, and the state came from the receipt's disposition — not from a desk-side guess"
      (and (eq :dispatch-unacknowledged *he-9-disposition*)
           (eq *he-9-disposition* (loan-status loan))
           (eq :missing d)))
  (ok "[IX-12] nothing phantom was written: no settlement date, no closure, and the loan still carries its real due day"
      (and (not (eq :settled (loan-status loan)))
           (= (+ *today* 14) (loan-due loan))
           (find "T-3" *tracers* :key #'tracer-id :test #'string=))
      "the desk keeps the true due date it earned in Movement VII and refuses the closure it did not earn here"))

;;; The desk had a door available and declined it — and says so as a POLICY,
;;; which is what it is.  [IX-4] proved the door grants.  Nothing in the language
;;; closed it; the desk simply will not walk through it for a closure.
(format t "~%   the door the desk declines, named as a policy and not as a guarantee:~%")
(desk "probe 4 GRANTED settlement on a :DIRECT witness the desk minted. The desk")
(desk "does not take that grant. That refusal is DESK POLICY, unenforced by the")
(desk "language and unreceipted anywhere — exactly the species of discipline")
(desk "Movement III deleted from the claim frontier and could not delete here.")
(ok "[IX-13] the desk's own books show the declined door: settlement WAS grantable, and the loan is still open"
    (let ((loan (find *restricted* *loans* :key #'loan-volume :test #'string=)))
      (and (eq :dispatch-unacknowledged (loan-status loan))
           ;; probe 4 really did grant — asserted against the stored receipt
           (eq :granted (lisp-plus-slice1:derivation-receipt-decision
                         *true-settlement-receipt*))))
    "a language that made this refusal unnecessary would be the thing Slice /2 is for")

;;; --- 9f. plural grounding, reported honestly ------------------------
;;;
;;; The commission asks whether this application NATURALLY produces several
;;; complete ground environments for one disposition.  The desk does not
;;; manufacture one to have something to report; it counts.
;;;
;;; CORRECTED 2026-07-25 under CHARTER-DELTA-4 (R-GROUNDING-NAME-1).  This arm
;;; counted ONE quantity — `premise-assessment-ground-instances` — called it "the
;;; normative plural reader," and concluded plural grounding was not exercised.
;;; Both moves were wrong in the same way: that reader returns CONCLUSION-PROJECTED
;;; PREMISE INSTANCES, not complete binding environments, and its cardinality is no
;;; bound on theirs.  The normative complete set is the COMPLETE BINDING ENVIRONMENT
;;; set.  The conclusion survives — the desk really has no plural grounding — but it
;;; now rests on the quantity that could have refuted it.  THREE axes are counted.
(format t "~%   9f. plural grounding — counted across every receipt the desk holds,~%")
(format t "       on all THREE axes, because they are three different things:~%")
(let* ((all-receipts (list *hop-0-receipt* *hop-1-receipt* *hop-2-receipt*
                           *hop-3-receipt* *hop-4-receipt*
                           *lawful-settlement-receipt* *true-settlement-receipt*
                           *raised-settlement-receipt* *fabricated-settlement-receipt*))
       ;; AXIS 2 — the NORMATIVE complete set.  This is what decides the claim.
       (env-counts
         (loop for r in all-receipts
               collect (length (lisp-plus-slice1:derivation-receipt-complete-binding-environments r))))
       (env-max (reduce #'max env-counts :initial-value 0))
       (premise-env-counts
         (loop for r in all-receipts
               append (loop for a in (lisp-plus-slice1:derivation-receipt-assessments r)
                            collect (length (lisp-plus-slice1:premise-assessment-binding-environments a)))))
       (premise-env-max (reduce #'max premise-env-counts :initial-value 0))
       ;; AXIS 1 — the PROJECTION: what this arm used to count, under a name that
       ;; made it look like axis 2.
       (cardinalities
         (loop for r in all-receipts
               append (loop for a in (lisp-plus-slice1:derivation-receipt-assessments r)
                            collect (length (lisp-plus-slice1:premise-assessment-projected-premise-instances a)))))
       (maximum (reduce #'max cardinalities :initial-value 0))
       ;; AXIS 3 — declared-uniqueness ambiguity.
       (conflict-counts
         (loop for r in all-receipts
               collect (length (lisp-plus-slice1:derivation-receipt-uniqueness-conflicts r))))
       (conflict-max (reduce #'max conflict-counts :initial-value 0)))
  (format t "     ~D receipts, ~D premise assessments~%"
          (length all-receipts) (length cardinalities))
  (format t "     complete binding environments per receipt   values ~S  max ~D  <- NORMATIVE~%"
          (sort (remove-duplicates env-counts) #'<) env-max)
  (format t "     premise binding environments per assessment values ~S  max ~D~%"
          (sort (remove-duplicates premise-env-counts) #'<) premise-env-max)
  (format t "     projected premise instances per assessment  values ~S  max ~D~%"
          (sort (remove-duplicates cardinalities) #'<) maximum)
  (format t "     declared uniqueness conflicts per receipt   values ~S  max ~D~%"
          (sort (remove-duplicates conflict-counts) #'<) conflict-max)
  (desk "no premise in this application is grounded more than one way -- and that is")
  (desk "now read off the COMPLETE BINDING ENVIRONMENTS, the set that could have said")
  (desk "otherwise. The projection count agrees here, but it would have agreed even")
  (desk "if it did not: a premise binding a schema-local projects that local as a")
  (desk "VARIABLE, so several complete environments collapse to ONE projection. An")
  (desk "arm counting only projections could report no plurality while three")
  (desk "environments stood in the receipt. This arm did, and was wrong.")
  (desk "The desk will NOT invent a second binding to exercise the plural surface --")
  (desk "a case manufactured to tick a box tests the box, not the language.")
  (ok "[IX-14] plural grounding is NOT exercised by this application, and the desk reports that rather than staging it — established on the NORMATIVE complete-environment set, not on the projection"
      (and (= 1 env-max) (= 1 premise-env-max) (= 1 maximum) (= 0 conflict-max))
      "reported as non-exercise; the deciding quantity is the complete binding environment set (max 1), the projection agrees (max 1), and no declared uniqueness conflict arose — three axes counted separately per CHARTER-DELTA-4, and the singular projection was never read above cardinality one"))


;;;; ==================================================================
;;;; MOVEMENT X — THE SOURCE-BOUND ROAD (Language Slice /2, Candidate /0)
;;;;
;;;; Movement IX ended with the desk declining a door it had.  Everything it
;;;; reported there STANDS, and is not rewritten below: on the Slice /0 +
;;;; Slice /1 + Core /0 surface as it stood, settlement rested on a witness the
;;;; desk minted, a fabricated one discharged identically, and the account
;;;; itself was inert residue.  Movement X does not contradict that; it walks a
;;;; DIFFERENT road that did not exist when Movement IX was written.
;;;;
;;;; Four stages, kept distinct on purpose:
;;;;
;;;;   deed             the crossing in Movement VII — `perform`, once
;;;;   account report   what the ISSUED account says about itself
;;;;   acknowledgment   a domain standing the desk derives from that report
;;;;   settlement       the loan closing, derived from acknowledgment + standing
;;;;
;;;; The two negative probes from Movement IX come back here — the fabricated
;;;; ledger witness and its raised claim — and are offered to a source-bound
;;;; premise, which is the only place the difference between them and the real
;;;; account has ever been visible.
;;;; ==================================================================

(format t "~%── MOVEMENT X: the source-bound road (Slice /2, Candidate /0) ──~%")

;;; --- 10a. the account report -----------------------------------------
;;;
;;; The desk holds the dispatch request because it WROTE it.  It does not read
;;; the request back out of the account — no operation lets it — it presents the
;;; request it holds and is told yes or no.

(defparameter *he-9-request* (dispatch-request *restricted* :ferrand))

(format t "~%   10a. the desk asks Core /0 whether the account it holds was issued~%")
(format t "        in this image FOR THE EXACT REQUEST it performed:~%")
(desk "issued-for-this-request => ~S"
      (lisp-plus-core0:core0-evidence-current-image-issued-for-request-p
       *deliver-evidence* *he-9-request*))
(desk "issued-for-a-DIFFERENT-request => ~S"
      (lisp-plus-core0:core0-evidence-current-image-issued-for-request-p
       *deliver-evidence* (dispatch-request "ms-Aleph-7" :ferrand)))
(ok "[X-1] the He-9 account answers TRUE for its own request and FALSE for another volume's"
    (and (lisp-plus-core0:core0-evidence-current-image-issued-for-request-p
          *deliver-evidence* *he-9-request*)
         (not (lisp-plus-core0:core0-evidence-current-image-issued-for-request-p
               *deliver-evidence* (dispatch-request "ms-Aleph-7" :ferrand))))
    "the conjunction, not either half: minted here AND minted for this act")

(defparameter *he-9-basis*
  (lisp-plus-slice2:establish-core0-source-basis
   :evidence *deliver-evidence* :request *he-9-request*
   :relation :core0-account-reports-acknowledgment
   :expected-outcome :acknowledged)
  "The source basis. NOT a witness, NOT a claim: a governed record binding the
issued account, the exact request, one relation, one derived proposition and one
truth ceiling.")

(format t "~%   the account report, whole:~%")
(format t "     ~S~%" (lisp-plus-slice2:source-basis-proposition *he-9-basis*))
(desk "ceiling: ~S" (lisp-plus-slice2:source-basis-truth-ceiling *he-9-basis*))
(ok "[X-2] the source basis reports ACKNOWLEDGMENT — a fact about the account, not about the world"
    (and (lisp-plus-slice2:source-basis-p *he-9-basis*)
         (eq :acknowledged (lisp-plus-slice2:source-basis-account-status *he-9-basis*))
         (eq :core0-account-reports-acknowledgment
             (second (lisp-plus-slice2:source-basis-proposition *he-9-basis*)))
         (eq :current-image-issued-account-report
             (lisp-plus-slice2:source-basis-truth-ceiling *he-9-basis*)))
    "the predicate says what it means: the ACCOUNT REPORTS an acknowledgment")

;;; --- 10b. the acknowledgment standing --------------------------------
;;;
;;; A SEPARATE, EXPLICIT schema.  No relation produced :DISPATCH-ACCOUNT-
;;; ACKNOWLEDGED and none could: the three relations produce propositions about
;;; accounts, and a domain conclusion is the desk's own step, written down where
;;; a reader can see it.

(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :dispatch-account-standing :version 1
  :conclusion (pp '(:predicate :dispatch-account-acknowledged
                    (:volume (:var :volume)) (:courier (:var :courier))))
  :premises (list (pp '(:predicate :core0-account-reports-acknowledgment
                        (:attempt (:var :attempt)) (:request (:var :request))
                        (:acknowledgment :acknowledged))))
  :locals '(:attempt :request)))

(defparameter *source-bound-only*
  (lisp-plus-slice2:make-support-admission-contract
   :contract-id :dispatch-account-source-bound
   :accepted-clauses
   '((:source-basis :relations (:core0-account-reports-acknowledgment))))
  "The contract the effect-sensitive premise carries. It accepts ONE species,
names the ONE relation it accepts, and accepts no judged claim — because a
judged claim is exactly what Movement IX showed a fabrication can become.")

(defparameter *dispatch-account-schema*
  (lisp-plus-slice2:make-slice2-schema
   :schema-id :dispatch-account-standing/2
   :base-schema (lisp-plus-slice1:resolve-schema :dispatch-account-standing 1)
   :premise-contracts (list (list 0 *source-bound-only*))))

(defun consider/2 (schema conclusion supports)
  "DERIVE/2 with the receipt recovered either way — the Slice /2 twin of
`consider`, and needed for the same reason."
  (handler-case
      (multiple-value-bind (claim receipt dbasis)
          (lisp-plus-slice2:derive/2 :schema schema :conclusion conclusion
                                     :supports supports
                                     :receiver (apply #'at-the-desk supports))
        ;; THREE values as of Candidate /1.  Every existing caller below binds
        ;; two and is unaffected — which is the whole point of an additive
        ;; return, and is left standing here as the demonstration of it.
        (values claim receipt dbasis))
    (lisp-plus-slice2:slice2-derivation-refused (c)
      (values nil (lisp-plus-slice2:slice2-condition-receipt c) nil))))

(defun admission-of (receipt predicate)
  (find predicate (lisp-plus-slice2:slice2-receipt-admissions receipt)
        :key (lambda (a)
               (second (lisp-plus-slice2:premise-admission-premise-pattern a)))))

(defun disposition/2 (receipt predicate)
  (lisp-plus-slice2:premise-admission-disposition (admission-of receipt predicate)))

(defparameter *ack-conclusion*
  (np `(:predicate :dispatch-account-acknowledged (:volume ,*restricted*)
        (:courier :brass-courier))))

(format t "~%   10b. the desk derives an acknowledgment standing from the report:~%")
(defparameter *ack-claim* nil)
(defparameter *ack-receipt* nil)
(defparameter *ack-dbasis* nil
  "MOVEMENT XI captures the THIRD value of this ALREADY-EARNED grant.  No second
derivation is run to produce it: the basis is minted by the same act whose
checks are recorded below, which is what makes it an account OF that act rather
than a claim about it.")
(multiple-value-bind (claim receipt dbasis)
    (consider/2 *dispatch-account-schema* *ack-conclusion* (list *he-9-basis*))
  (setf *ack-claim* claim *ack-receipt* receipt *ack-dbasis* dbasis)
  (desk "decision => ~S" (lisp-plus-slice2:slice2-receipt-decision receipt))
  (ok "[X-3] the source basis DISCHARGES the source-bound premise — acknowledgment standing granted"
      (and claim
           (eq :granted (lisp-plus-slice2:slice2-receipt-decision receipt))
           (eq :satisfied (disposition/2 receipt :core0-account-reports-acknowledgment))))
  (ok "[X-4] and the receipt retains the CONTRACT BY VALUE and the BASIS by snapshot — no resolver is needed to read it"
      (let* ((a (admission-of receipt :core0-account-reports-acknowledgment))
             (c (lisp-plus-slice2:premise-admission-contract a))
             (b (first (lisp-plus-slice2:slice2-receipt-source-bases-used receipt))))
        (and (lisp-plus-slice2:support-admission-contract-p c)
             (eq :dispatch-account-source-bound
                 (lisp-plus-slice2:support-admission-contract-contract-id c))
             (equal (lisp-plus-slice2:support-admission-contract-accepted-clauses c)
                    '((:source-basis
                       :relations (:core0-account-reports-acknowledgment))))
             (equal (lisp-plus-slice2:source-basis-request b) (np *he-9-request*))
             (equal (lisp-plus-slice2:premise-admission-truth-ceilings a)
                    '((:source-basis . :current-image-issued-account-report)))))
      "everything the question 'why did this discharge?' needs is IN the receipt"))

;;; --- 10c. the two negative probes, at a source-bound premise ---------
;;;
;;; Movement IX's fabricated witness and its raised claim, offered here.  In
;;; Movement IX they were INDISTINGUISHABLE from the real thing through every
;;; public reader.  Here they are not admitted, and the receipt says which.

(format t "~%   10c. the Movement IX fabrications, offered to the source-bound premise:~%")

(defparameter *fabricated-ack-witness*
  (lisp-plus-slice0:witness
   :for (lisp-plus-slice2:source-basis-proposition *he-9-basis*)
   :mode :direct :kind :courier-ledger :source :brass-courier
   :procedure (lisp-plus-kernel0:make-identity
               :attempt "peregrina/crossing-that-never-was")
   :content (list :ledger-token "fake:courier:0000"))
  "The same lie Movement IX told, retold about the account-report proposition.
Nothing produced it. There is no such attempt and no such row.")

(defparameter *fabricated-ack-claim*
  (lisp-plus-slice0:raise
   (lisp-plus-slice0:claim
    :proposition (lisp-plus-slice2:source-basis-proposition *he-9-basis*)
    :by :peregrina)
   :to :verified :per *ledger-reading* :considering (list *fabricated-ack-witness*)
   :receiver :peregrina)
  "And the same laundering: RAISE turns it into a genuinely :VERIFIED claim.")

(dolist (probe (list (cons "the fabricated witness, raw" *fabricated-ack-witness*)
                     (cons "the same fabrication, RAISED to :VERIFIED"
                           *fabricated-ack-claim*)))
  (multiple-value-bind (claim receipt)
      (consider/2 *dispatch-account-schema* *ack-conclusion* (list (cdr probe)))
    (let ((a (admission-of receipt :core0-account-reports-acknowledgment)))
      (desk "~34A slice /1 would say ~S; slice /2 says ~S" (car probe)
            (lisp-plus-slice2:premise-admission-base-disposition a)
            (lisp-plus-slice2:premise-admission-disposition a))
      (ok (format nil "[X-5~:[b~;a~]] ~A is RECOGNIZED and NOT ADMITTED at the source-bound premise"
                  (eq (cdr probe) *fabricated-ack-witness*) (car probe))
          (and (null claim)
               (eq :refused (lisp-plus-slice2:slice2-receipt-decision receipt))
               (eq :not-admitted (lisp-plus-slice2:premise-admission-disposition a))
               (equal (list (cdr probe))
                      (lisp-plus-slice2:premise-admission-recognized-not-admitted a))
               ;; the narrowing is the WHOLE difference: Slice /1 still grants
               (eq :satisfied (lisp-plus-slice2:premise-admission-base-disposition a)))
          "Slice /1 is unchanged and still discharges it; the receipt shows both answers side by side"))))

(ok "[X-6] the claim really WAS :VERIFIED — it was refused for its species, not for its standing"
    (eq :verified (lisp-plus-slice0:judgment-record-judgment
                   (lisp-plus-slice0:claim-judgment *fabricated-ack-claim*)))
    "R-ADMISSION-0.2 answered in code: standing is not origin")

;;; --- 10d. settlement, through a domain schema ------------------------
;;;
;;; The acknowledgment standing is now an ordinary judged claim, and it chains
;;; the ordinary way.  The settlement schema is the desk's own domain step: it
;;; says what the desk means by a settled loan, and it says it out loud.

(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :settlement-standing :version 2
  :conclusion (pp '(:predicate :loan-settled (:patron (:var :patron))
                    (:volume (:var :volume))))
  :premises
  (list (pp '(:predicate :may-dispatch (:patron (:var :patron))
              (:volume (:var :volume)) (:courier (:var :courier))))
        (pp '(:predicate :dispatch-account-acknowledged (:volume (:var :volume))
              (:courier (:var :courier)))))
  :locals '(:courier)))

(defparameter *settlement-schema/2*
  (lisp-plus-slice2:make-slice2-schema
   :schema-id :settlement-standing/2
   :base-schema (lisp-plus-slice1:resolve-schema :settlement-standing 2)
   :premise-contracts
   (list (list 0 (lisp-plus-slice2:make-support-admission-contract
                  :contract-id :dispatch-standing-by-judgment
                  :accepted-clauses '((:verified-judged-claim))))
         (list 1 (lisp-plus-slice2:make-support-admission-contract
                  :contract-id :acknowledgment-standing-by-judgment
                  :accepted-clauses '((:verified-judged-claim)))))))

(format t "~%   10d. settlement — the domain step, with both premises named:~%")
(defparameter *settled-claim* nil)
(defparameter *settlement-receipt/2* nil)
(multiple-value-bind (claim receipt)
    (consider/2 *settlement-schema/2*
                (np `(:predicate :loan-settled (:patron :ferrand)
                      (:volume ,*restricted*)))
                (list *hop-4* *ack-claim*))
  (setf *settled-claim* claim *settlement-receipt/2* receipt)
  (desk "decision => ~S" (lisp-plus-slice2:slice2-receipt-decision receipt))
  (ok "[X-7] settlement is GRANTED — and every premise discharged on a judged claim whose own basis is inspectable"
      (and claim
           (eq :granted (lisp-plus-slice2:slice2-receipt-decision receipt))
           (eq :satisfied (disposition/2 receipt :may-dispatch))
           (eq :satisfied (disposition/2 receipt :dispatch-account-acknowledged)))))

;;; --- 10e. and so the loan on ms-He-9 closes --------------------------
;;;
;;; The state comes from the receipt's own disposition, exactly as it did in
;;; 9e.  The desk chooses nothing.  What changed is not the desk's discipline —
;;; it is that the disposition is now reached without minting a witness.

(format t "~%   10e. the loan on ~A, revisited:~%" *restricted*)
(defparameter *he-9-disposition/2* nil)
(let* ((d (disposition/2 *settlement-receipt/2* :dispatch-account-acknowledged))
       (loan (find *restricted* *loans* :key #'loan-volume :test #'string=)))
  (desk "the settlement receipt says :DISPATCH-ACCOUNT-ACKNOWLEDGED is ~S." d)
  (setf *he-9-disposition/2*
        (ecase d
          (:satisfied     :settled)
          (:not-admitted  :dispatch-unacknowledged)
          (:refuted       :settlement-refused)
          (:inaccessible  :reconciliation-required)
          (:ambiguous     :reconciliation-required)
          (:mismatched    :dispatch-unacknowledged)
          (:missing       :dispatch-unacknowledged)))
  (setf (loan-status loan) *he-9-disposition/2*)
  (setf *tracers* (remove "T-3" *tracers* :key #'tracer-id :test #'string=))
  (desk "→ loan status set to ~S; tracer T-3 closed." *he-9-disposition/2*)
  (ok "[X-8] the loan lands :SETTLED, and the state came from the receipt's disposition — not from a desk-side guess"
      (and (eq :settled *he-9-disposition/2*)
           (eq *he-9-disposition/2* (loan-status loan))
           (eq :satisfied d)
           (null (find "T-3" *tracers* :key #'tracer-id :test #'string=))))
  (ok "[X-9] and the desk STILL will not walk the Movement IX door: no witness was minted for the acknowledgment on this road"
      (let* ((a (admission-of *settlement-receipt/2* :dispatch-account-acknowledged))
             (supports (lisp-plus-slice2:premise-admission-admitted-supports a)))
        (and (= 1 (length supports))
             (lisp-plus-slice0:claim-p (first supports))
             (notany #'lisp-plus-slice0:witness-p supports)))
      "the road from deed to settlement passes through an issued account, not through the desk's own hand"))

;;; --- 10f. what the desk still cannot say -----------------------------

(format t "~%   ── the new road's ceiling, stated exactly ──~%")
(desk "The loan is settled. What that rests on is NOT that the volume arrived.")
(desk "It rests on: the Core /0 runtime minted that exact account content in")
(desk "THIS image, for THAT request, and the account REPORTS an acknowledgment.")
(desk "The courier is a labelled scripted fake. If it lied to Core /0, every")
(desk "reader above returns exactly what it returns now.")
(format t "~%")
(desk "What DID change is narrow and real: on the Movement IX road the desk's")
(desk "own fabrication was indistinguishable from the truth through every public")
(desk "reader ([IX-7]). On this road it is refused, the refusal is recorded")
(desk "against a named contract, and the desk can show which support discharged")
(desk "which premise and under what ceiling. The frontier did not vanish. It")
(desk "moved from 'the desk asserted it' to 'the runtime issued it', and the")
(desk "distance from there to the world is unchanged.")

(ok "[X-10] the ceiling is carried in the artifact, not only in this narration"
    (let ((b (first (lisp-plus-slice2:slice2-receipt-source-bases-used
                     (nth-value 1 (consider/2 *dispatch-account-schema*
                                              *ack-conclusion* (list *he-9-basis*)))))))
      (and (eq :current-image-issued-account-report
               (lisp-plus-slice2:source-basis-truth-ceiling b))
           ;; the basis claims nothing across image death, and says so
           (null (getf (lisp-plus-slice2:source-basis-issuance-basis b) :persistence))
           (getf (lisp-plus-slice2:source-basis-issuance-basis b) :image-local)))
    "a ceiling a program prints but does not carry is a ceiling the next reader loses")

;;;; ==================================================================
;;;; MOVEMENT XI — THE COMPOSED ROAD (Language Slice /2, Candidate /1)
;;;;
;;;; Movement X closed the UPSTREAM frontier: an effect account reached a
;;;; premise through a governed source basis, and the loan settled.  It left the
;;;; DOWNSTREAM one exactly where [IX-10] found it —
;;;;
;;;;   "the receiving receipt holds NO witness object and NO :ATTEMPT identity —
;;;;    the crossing's identity is gone by the time the claim chains"
;;;;
;;;; — one layer up.  The acknowledgment standing Movement X earned travelled
;;;; onward as an ORDINARY Slice /1 claim.  A later premise could not tell it
;;;; from a claim somebody raised over an assertion, because by the time it
;;;; arrived there was nothing left to tell it BY.
;;;;
;;;; Movement XI does not re-derive anything.  It takes the THIRD value of the
;;;; grant Movement X already made, and asks one question: can a premise insist
;;;; on THAT, and refuse everything that merely looks like it?
;;;; ==================================================================

(format t "~%── MOVEMENT XI: the composed road (Slice /2, Candidate /1) ──~%")

(lisp-plus-slice1:register-schema
 (lisp-plus-slice1:judgment-schema
  :name :loan-closure-standing :version 1
  :conclusion (pp '(:predicate :loan-closure-authorized
                    (:volume (:var :volume)) (:courier (:var :courier))))
  :premises (list (pp '(:predicate :dispatch-account-acknowledged
                        (:volume (:var :volume)) (:courier (:var :courier)))))))

(defparameter *derivation-bound-only*
  (lisp-plus-slice2:make-support-admission-contract
   :contract-id :closure-by-prior-admission
   :contract-version 1
   :accepted-clauses '((:derivation-basis)))
  "A version-1 contract accepting ONE species and nothing else.  It does not
accept a judged claim — because a judged claim is exactly what the desk's own
acknowledgment standing LOOKS LIKE once it leaves the receipt that granted it.")

(defparameter *closure-schema*
  (lisp-plus-slice2:make-slice2-schema
   :schema-id :loan-closure-standing/2
   :base-schema (lisp-plus-slice1:resolve-schema :loan-closure-standing 1)
   :premise-contracts (list (list 0 *derivation-bound-only*))))

(defparameter *closure-conclusion*
  (np `(:predicate :loan-closure-authorized (:volume ,*restricted*)
        (:courier :brass-courier))))

;;; --- 11a. what the desk will NOT accept -----------------------------

(format t "~%   11a. the desk offers its OWN granted claim, naked:~%")
(multiple-value-bind (claim receipt)
    (consider/2 *closure-schema* *closure-conclusion* (list *ack-claim*))
  (desk "decision => ~S" (lisp-plus-slice2:slice2-receipt-decision receipt))
  (ok "[XI-1] the desk's own NAKED granted claim is recognized and NOT ADMITTED — slice /1 satisfied it, slice /2 refused the ROUTE"
      (and (null claim)
           (eq :refused (lisp-plus-slice2:slice2-receipt-decision receipt))
           (eq :not-admitted (disposition/2 receipt :dispatch-account-acknowledged))
           (eq :satisfied
               (lisp-plus-slice2:premise-admission-base-disposition
                (admission-of receipt :dispatch-account-acknowledged)))
           (member *ack-claim*
                   (lisp-plus-slice2:premise-admission-recognized-not-admitted
                    (admission-of receipt :dispatch-account-acknowledged))))
      "this is [IX-10] refused rather than reported: the claim is VISIBLE and still not enough"))

(format t "~%   11b. and an ordinarily raised claim wearing the same proposition:~%")
(defparameter *closure-impostor*
  (lisp-plus-slice0:raise
   (lisp-plus-slice0:claim :proposition *ack-conclusion* :by :desk)
   :to :verified :per *ledger-reading*
   :considering (list (lisp-plus-slice0:witness
                       :for *ack-conclusion* :mode :direct :kind :courier-ledger
                       :source :desk))
   :receiver :peregrina)
  "A genuinely :VERIFIED claim over the identical proposition, raised the
ordinary way. Movement IX's finding, aimed one layer up.")

(multiple-value-bind (claim receipt)
    (consider/2 *closure-schema* *closure-conclusion* (list *closure-impostor*))
  (desk "decision => ~S" (lisp-plus-slice2:slice2-receipt-decision receipt))
  (ok "[XI-2] an ORDINARILY RAISED claim with the SAME proposition is NOT ADMITTED — :VERIFIED standing is not an admission record"
      (and (null claim)
           (eq :refused (lisp-plus-slice2:slice2-receipt-decision receipt))
           (eq :not-admitted (disposition/2 receipt :dispatch-account-acknowledged)))))

;;; --- 11c. what it WILL accept ---------------------------------------

(format t "~%   11c. the desk offers the DERIVATION BASIS the same grant produced:~%")
(defparameter *closure-claim* nil)
(defparameter *closure-receipt* nil)
(multiple-value-bind (claim receipt)
    (consider/2 *closure-schema* *closure-conclusion* (list *ack-dbasis*))
  (setf *closure-claim* claim *closure-receipt* receipt)
  (desk "decision => ~S" (lisp-plus-slice2:slice2-receipt-decision receipt))
  (desk "ceiling  => ~S"
        (lisp-plus-slice2:premise-admission-truth-ceilings
         (admission-of receipt :dispatch-account-acknowledged)))
  (ok "[XI-3] the ESTABLISHED derivation basis DISCHARGES the premise — closure standing granted"
      (and claim
           (eq :granted (lisp-plus-slice2:slice2-receipt-decision receipt))
           (eq :satisfied (disposition/2 receipt :dispatch-account-acknowledged))
           (= 1 (length (lisp-plus-slice2:slice2-receipt-derivation-bases-used receipt)))))
  (ok "[XI-4] and the downstream receipt reaches the EXACT prior Slice /2 receipt — BY OBJECT, no resolver"
      (let* ((b (first (lisp-plus-slice2:slice2-receipt-derivation-bases-used receipt)))
             (prior (lisp-plus-slice2:derivation-basis-receipt b)))
        (and (eq prior *ack-receipt*)
             (eq :granted (lisp-plus-slice2:slice2-receipt-decision prior))
             ;; and THROUGH it, the source basis and the Core /0 attempt itself
             (eq *he-9-basis*
                 (first (lisp-plus-slice2:slice2-receipt-source-bases-used prior)))
             (lisp-plus-kernel0:identity=
              (lisp-plus-slice2:source-basis-attempt-id *he-9-basis*)
              (lisp-plus-core0:core0-evidence-attempt-id *deliver-evidence*))))
      "closure standing -> prior receipt -> source basis -> the He-9 crossing, walked by object")
  (ok "[XI-5] the recorded ceiling is the PRIOR-JUDGMENT one — it did NOT inherit the account-report ceiling"
      (and (equal '((:derivation-basis . :prior-explicit-admission-judgment))
                  (lisp-plus-slice2:premise-admission-truth-ceilings
                   (admission-of receipt :dispatch-account-acknowledged)))
           (not (eq :prior-explicit-admission-judgment
                    :current-image-issued-account-report)))
      "a composed judgment does not become source-bound by having been composed from one")
  (let ((text (with-output-to-string (out)
                (lisp-plus-slice2:render-slice2-why receipt out))))
    (ok "[XI-6] the rendered explanation preserves the modest ceiling and claims nothing larger"
        (and (search "PRIOR EXPLICIT ADMISSION" text)
             (notany (lambda (w) (search w text))
                     '("proved" "effect occurred" "externally verified" "settled")))
        "the ceiling survives the trip to the printer")))

;;; --- 11d. nothing was moved to make this land -----------------------

(ok "[XI-7] NO courier script, adapter outcome, Core /0 event or source relation was altered for Movement XI"
    (and
     ;; the same account object Movement VII produced, unchanged
     (lisp-plus-core0:core0-evidence-p *deliver-evidence*)
     (lisp-plus-core0:core0-evidence-current-image-issued-for-request-p
      *deliver-evidence* *he-9-request*)
     ;; the same source basis object Movement X established, on the same relation
     (eq :core0-account-reports-acknowledgment
         (lisp-plus-slice2:source-basis-relation-kind *he-9-basis*))
     (eq :acknowledged (lisp-plus-slice2:source-basis-account-status *he-9-basis*))
     ;; and Movement XI added exactly one thing: a premise that insists on the record
     (lisp-plus-slice2:derivation-basis-established-in-current-image-p *ack-dbasis*))
    "Movement XI adds a premise, not a fact")

(ok "[XI-8] the derivation basis carries the ACCOUNT-STANDING proposition, never the closure conclusion — the domain step stays the desk's own"
    (and (eq :dispatch-account-acknowledged
             (second (lisp-plus-slice2:derivation-basis-proposition *ack-dbasis*)))
         (not (eq :loan-closure-authorized
                  (second (lisp-plus-slice2:derivation-basis-proposition *ack-dbasis*))))
         ;; the closure conclusion exists ONLY because a schema the desk wrote
         ;; says these premises license it
         *closure-claim*)
    "a derivation basis never establishes a domain conclusion automatically (Work Order /1 §8)")

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
(format t "~%   And Movement IX proves NOTHING about effects being unverifiable in~%")
(format t "   principle. It reports what the Slice /0 + Slice /1 + Core /0 surface~%")
(format t "   did as it stood when Movement IX was written: no governed operation~%")
(format t "   consumed an effect account, so settlement rested on a minted witness~%")
(format t "   or it did not happen. That measurement is why Slice /2 exists, and~%")
(format t "   it is not rewritten as mistaken by Movement X.~%")
(format t "~%   AMENDED 2026-07-25. Movement IX used to end \"No bridge is proposed~%")
(format t "   here, and none should be read in.\" A bridge was subsequently built~%")
(format t "   and Movement X walks it, so that sentence is withdrawn rather than~%")
(format t "   left standing as a promise the file no longer keeps. What replaces~%")
(format t "   it is narrower: Movement X does not verify the dispatch. It moves~%")
(format t "   the premise's basis from \"the desk asserted it\" to \"the Core /0~%")
(format t "   runtime issued this exact account content in THIS image for THAT~%")
(format t "   request, and the account reports an acknowledgment\". The courier is~%")
(format t "   still the labelled scripted fake; a lying adapter produces the same~%")
(format t "   readers throughout. The distance from an issued account to the world~%")
(format t "   is exactly what it was, and nothing in Movement X shortens it.~%")

(format t "~%   AND MOVEMENT XI SHORTENS IT LESS STILL. What it adds is a premise~%")
(format t "   that can INSIST on the record of a prior admission, and refuse a~%")
(format t "   claim that merely looks like its result. A derivation basis says~%")
(format t "   exactly one thing: this image granted this exact claim under explicit~%")
(format t "   per-premise contracts, and here is the receipt. It does NOT say that~%")
(format t "   every premise behind it was source-bound, that anything was checked~%")
(format t "   outside this image, or that a deed took place. The closure standing~%")
(format t "   in 11c is authorized by a schema the DESK wrote — no basis makes a~%")
(format t "   domain conclusion on its own, and [XI-8] is the check that says so.~%")

(format t "~%de-bibliotheca-peregrina: ~D checks passed / ~D failed~%" *pass* *fail*)
(format t "(a desk that can say \"no\", \"not yet\", and \"I do not know\" in three~%")
(format t " different voices, and cannot accidentally send the same book twice)~%")
(finish-output)
(sb-ext:exit :code (if (zerop *fail*) 0 1))
