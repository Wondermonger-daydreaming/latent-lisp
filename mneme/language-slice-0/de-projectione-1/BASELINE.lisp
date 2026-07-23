;;;; -*- mode: lisp -*-
;;;; de-projectione-1 / BASELINE.lisp
;;;;
;;;; FABER-CL-II, in good faith. Sibling to FABER-CL's de-promotione baseline.
;;;;
;;;; THE PROBLEM. A claim -- a proposition plus a standing (:verified, :asserted,
;;;; ...) plus a reference to the warrant that earns that standing -- is held in a
;;;; SOURCE context: the release lab, which has the evidence on hand, recognizes
;;;; the authorities who signed it, and can run the verification procedure. The
;;;; claim must be PROJECTED into a RECEIVER context: an external auditor, a
;;;; client, a stranger. Receivers differ in what they can reach: which evidence
;;;; records they can access, which authorities they recognize, whether they are
;;;; cleared to see a sensitive proposition at all.
;;;;
;;;; The HONEST semantics is receiver-relative: the receiver holds only what its
;;;; own position licenses. A claim verified at source may honestly arrive as
;;;; merely :asserted (evidence unreachable), or as :attributed testimony (only
;;;; the source's word crossed), or as a :redacted public paraphrase carrying an
;;;; obligation to export the evidence later. Standing is not a property of the
;;;; claim; it is a RELATION between the claim and the position that holds it.
;;;;
;;;; This file writes the competent, disciplined version: receiver-relative
;;;; semantics living as CONVENTION around plain records and a good-faith
;;;; PROJECT-CLAIM helper. Then it shows -- with six ordinary idiomatic lines no
;;;; reviewer would flag -- exactly where the discipline leaks, because the host
;;;; language enforces none of it. As FABER-CL put it of the promotion case:
;;;; the :: is a shrug, not a wall. Here the copy is a shrug, the setf is a
;;;; shrug, the hash write is a shrug. Convention asks; nothing compels.

(defpackage :de-projectione-baseline
  (:use :common-lisp)
  (:documentation "Good-faith receiver-relative claim projection, and the six
places a disciplined programmer still leaks standing across positions."))

(in-package :de-projectione-baseline)

;;; ---------------------------------------------------------------------------
;;; RECORDS
;;; ---------------------------------------------------------------------------

(defstruct evidence-record
  "A row in some position's evidence store. KIND is :verification (a run of a
procedure that discharges a warrant), :testimony (someone's word), or :document
(an artifact). AUTHORITY is who stands behind it -- meaningful only to a position
that RECOGNIZES that authority."
  (id       nil :type symbol)
  (kind     nil :type symbol)
  (content  ""  :type string)
  (authority nil :type symbol))

(defstruct claim
  "A proposition held at a STANDING, backed by the evidence row named by
WARRANT-ID, in the store of HOLDER. STANDING is one of :verified :asserted
:attributed :redacted. The convention -- unenforced -- is that STANDING must be
justified by what HOLDER can actually reach: a :verified claim must name a
reachable :verification row signed by an authority HOLDER recognizes."
  (proposition "" :type string)
  (standing    nil :type symbol)
  (warrant-id  nil :type symbol)
  (holder      nil :type symbol)
  ;; A proposition may be sensitive; SENSITIVE-P gates whether an uncleared
  ;; receiver may see it verbatim, and PUBLIC-PARAPHRASE is what they get instead.
  (sensitive-p nil :type boolean)
  (public-paraphrase nil))

(defstruct receiver-context
  "A position a claim can be projected INTO. It can reach only the evidence rows
whose ids are in ACCESSIBLE-EVIDENCE-IDS, recognizes only authorities in
RECOGNIZED-AUTHORITIES, and (CLEARED-P) may or may not see sensitive propositions.
This record is the whole point: standing must be recomputed against it, not
copied past it."
  (name nil :type symbol)
  (accessible-evidence-ids '() :type list)
  (recognized-authorities  '() :type list)
  (cleared-p nil :type boolean))

;;; ---------------------------------------------------------------------------
;;; STORES  (one hash per position)
;;; ---------------------------------------------------------------------------

(defun make-store ()
  "An evidence store: id -> EVIDENCE-RECORD."
  (make-hash-table :test 'eq))

(defun store-put (store rec)
  (setf (gethash (evidence-record-id rec) store) rec)
  rec)

(defun store-get (store id)
  (gethash id store))

;;; ---------------------------------------------------------------------------
;;; THE GOOD-FAITH PROJECTION HELPER
;;; ---------------------------------------------------------------------------

(defun receiver-can-reach-p (receiver evidence-id)
  "Does RECEIVER's position license reaching this evidence row at all?"
  (and evidence-id
       (member evidence-id (receiver-context-accessible-evidence-ids receiver))
       t))

(defun receiver-recognizes-p (receiver authority)
  "Does RECEIVER recognize the AUTHORITY that signed a row?"
  (and authority
       (member authority (receiver-context-recognized-authorities receiver))
       t))

(defun project-claim (claim source-store receiver)
  "Project CLAIM (held at SOURCE) into RECEIVER's position, honestly.

The disciplined convention, all in one place:

  * If the warrant evidence is unreachable by RECEIVER, the claim cannot arrive
    :verified -- it degrades to :asserted (source says so, receiver can't check).
  * If reachable but signed by an authority RECEIVER does not recognize, the
    verification is only hearsay to them: :attributed.
  * If reachable AND recognized, the :verified standing is genuinely earned in
    RECEIVER's position and survives.
  * If the proposition is sensitive and RECEIVER is not cleared, the receiver
    gets a :redacted public paraphrase -- and the projection owes an obligation
    to export the underlying evidence through a cleared channel.

Returns two values: a FRESH claim built for RECEIVER at the recomputed standing,
and a list of OBLIGATIONS the projection incurred. It never mutates CLAIM and
never writes into RECEIVER's store -- projection is a computation, not a copy."
  (let* ((prop        (claim-proposition claim))
         (warrant     (claim-warrant-id claim))
         (row         (and warrant (store-get source-store warrant)))
         (authority   (and row (evidence-record-authority row)))
         (obligations '()))
    ;; Sensitive + uncleared: the receiver may not hold the proposition at all.
    (when (and (claim-sensitive-p claim)
               (not (receiver-context-cleared-p receiver)))
      (push (list :export-evidence-through-cleared-channel warrant) obligations)
      (return-from project-claim
        (values
         (make-claim :proposition (or (claim-public-paraphrase claim)
                                      "[redacted]")
                     :standing :redacted
                     ;; A redacted derivative has NO warrant the receiver can act
                     ;; on -- carrying the private warrant-id here would be a lie
                     ;; (see MISLEADING MOVE iv). We deliberately drop it.
                     :warrant-id nil
                     :holder (receiver-context-name receiver)
                     :sensitive-p t
                     :public-paraphrase (claim-public-paraphrase claim))
         obligations)))
    ;; Non-sensitive (or cleared): recompute standing from reachability.
    (let ((new-standing
            (cond
              ((not (receiver-can-reach-p receiver warrant))
               (push (list :export-evidence warrant) obligations)
               :asserted)
              ((not (receiver-recognizes-p receiver authority))
               (push (list :establish-authority authority) obligations)
               :attributed)
              (t :verified))))
      (values
       (make-claim :proposition prop
                   :standing new-standing
                   :warrant-id warrant
                   :holder (receiver-context-name receiver)
                   :sensitive-p (claim-sensitive-p claim)
                   :public-paraphrase (claim-public-paraphrase claim))
       obligations))))

;;; ---------------------------------------------------------------------------
;;; FIXTURES
;;; ---------------------------------------------------------------------------

(defvar *source-store* (make-store)
  "The release lab's evidence store.")

(store-put *source-store*
           (make-evidence-record :id 'ev-run-42 :kind :verification
                                 :content "reproduced build, all 312 vectors pass"
                                 :authority 'release-lab))

(store-put *source-store*
           (make-evidence-record :id 'ev-secret-audit :kind :verification
                                 :content "internal audit of the keyed corpus"
                                 :authority 'release-lab))

;; A claim verified at source, warranted by a reachable, lab-signed run.
(defvar *claim-clean*
  (make-claim :proposition "the slice-0 corpus passes conformance"
              :standing :verified
              :warrant-id 'ev-run-42
              :holder 'release-lab))

;; A sensitive claim: verified at source, but its proposition may not travel
;; verbatim to an uncleared receiver -- only a public paraphrase may.
(defvar *claim-sensitive*
  (make-claim :proposition "corpus item #207 was mislabeled and silently fixed"
              :standing :verified
              :warrant-id 'ev-secret-audit
              :holder 'release-lab
              :sensitive-p t
              :public-paraphrase "one corpus item received a corrected label"))

;; RECEIVERS ----------------------------------------------------------------

;; Full peer: reaches the run, recognizes the lab. Clean projection -> :verified.
(defvar *peer*
  (make-receiver-context :name 'peer-lab
                         :accessible-evidence-ids '(ev-run-42 ev-secret-audit)
                         :recognized-authorities '(release-lab)
                         :cleared-p t))

;; External auditor: recognizes the lab, but CANNOT reach the evidence rows.
(defvar *auditor*
  (make-receiver-context :name 'auditor
                         :accessible-evidence-ids '()
                         :recognized-authorities '(release-lab)
                         :cleared-p t))

;; Client: can reach the run, but does NOT recognize the release-lab authority.
(defvar *client*
  (make-receiver-context :name 'client
                         :accessible-evidence-ids '(ev-run-42)
                         :recognized-authorities '(some-notary)
                         :cleared-p t))

;; Stranger: reaches nothing, recognizes no one, uncleared.
(defvar *stranger*
  (make-receiver-context :name 'stranger
                         :accessible-evidence-ids '()
                         :recognized-authorities '()
                         :cleared-p nil))

;;; ---------------------------------------------------------------------------
;;; PRINTING HELPERS
;;; ---------------------------------------------------------------------------

(defun show-claim (label claim &optional obligations)
  (format t "  ~a~%    proposition: ~s~%    standing:    ~a   holder: ~a   warrant: ~a~%"
          label
          (claim-proposition claim)
          (claim-standing claim)
          (claim-holder claim)
          (claim-warrant-id claim))
  (when obligations
    (format t "    obligations: ~s~%" obligations))
  (values))

(defun rule (title)
  (format t "~%========== ~a ==========~%" title))

;;; ---------------------------------------------------------------------------
;;; DEMONSTRATION -- the good-faith path
;;; ---------------------------------------------------------------------------

(defun demo-honest ()
  (rule "HONEST PROJECTION (project-claim recomputes standing per position)")
  (show-claim "SOURCE (release lab):" *claim-clean*)
  (multiple-value-bind (c o) (project-claim *claim-clean* *source-store* *peer*)
    (show-claim "-> peer  (reaches run, recognizes lab):" c o))
  (multiple-value-bind (c o) (project-claim *claim-clean* *source-store* *auditor*)
    (show-claim "-> auditor (recognizes lab, can't reach evidence):" c o))
  (multiple-value-bind (c o) (project-claim *claim-clean* *source-store* *client*)
    (show-claim "-> client (reaches run, doesn't recognize lab):" c o))
  (format t "~%  (sensitive claim, uncleared stranger gets a redacted paraphrase:)~%")
  (multiple-value-bind (c o) (project-claim *claim-sensitive* *source-store* *stranger*)
    (show-claim "-> stranger:" c o)))

;;; ---------------------------------------------------------------------------
;;; THE MISLEADING MOVES
;;;
;;; Each is one ordinary idiomatic line that a competent CL programmer writes
;;; without a second thought, and that no reviewer flags -- yet each silently
;;; breaks receiver-relative standing. The host language resists none of them.
;;; ---------------------------------------------------------------------------

(defun move-i-copy-carries-verified ()
  "(i) COPYING THE CLAIM. The receiver gets a copy of my struct.

WHY IT MISLEADS: COPY-CLAIM duplicates every slot, including :standing :verified
and the source warrant-id -- so the auditor now HOLDS a :verified claim it never
earned. The receiver's position was never consulted; the standing arrived by
memcpy. This is the escape hatch that no convention can close: PROJECT-CLAIM can
be as careful as it likes, but COPY-CLAIM sits in the standard library, one call
away, indistinguishable in a diff from any other harmless copy.
WHY THE LANGUAGE DOESN'T RESIST: the copy is legal, total, and silent."
  (rule "MOVE (i): copy-claim carries :verified past the receiver")
  (let ((theirs (copy-claim *claim-clean*)))       ; <-- the whole bug
    (setf (claim-holder theirs) 'auditor)          ; make it look projected
    (show-claim "auditor's copy (NEVER checked reachability):" theirs)
    (format t "    ^ standing is :verified in a position that reaches no evidence.~%")))

(defun move-ii-holder-as-label ()
  "(ii) HOLDER AS A PRINCIPAL NAME. Set the holder to a symbol and call it done.

WHY IT MISLEADS: the receiver is a POSITION -- accessible ids, recognized
authorities, clearance. Reducing it to the symbol AUDITOR throws all of that
away. The claim now says holder: auditor, but no receiver-context was ever
consulted, so the standing means nothing about what the auditor can do.
WHY THE LANGUAGE DOESN'T RESIST: HOLDER is just a slot of type symbol; a symbol
is exactly what fits, so the type-checker is satisfied and the reviewer reads a
plausible line."
  (rule "MOVE (ii): holder set to a bare name, context never consulted")
  (let ((theirs (copy-claim *claim-clean*)))
    (setf (claim-holder theirs) 'auditor)          ; position -> label
    (show-claim "'projected' by renaming the holder:" theirs)
    (format t "    ^ 'auditor' the symbol != auditor the position (no ids, no reach).~%")))

(defun move-iii-testimony-becomes-verification (receiver-store)
  "(iii) TESTIMONY SILENTLY BECOMES DIRECT EVIDENCE.

The source's word is that ev-run-42 passed. In the receiver's store we record
that word -- but as a row of kind :verification. Now the receiver's store claims
to CONTAIN a verification it only ever heard ABOUT.
WHY IT MISLEADS: one hash write, identical in shape to every other store-put,
launders testimony into evidence. A later PROJECT-CLAIM against this store will
find a reachable :verification row and stamp :verified -- fully 'by the book'.
WHY THE LANGUAGE DOESN'T RESIST: a hash write looks like every other hash write;
KIND is a free-form symbol slot; nothing ties :verification to an actual run."
  (rule "MOVE (iii): testimony recorded as a :verification row")
  (setf (gethash 'ev-run-42 receiver-store)        ; the one laundering line
        (make-evidence-record :id 'ev-run-42 :kind :verification
                              :content "source told us run-42 passed"
                              :authority 'auditor))
  (let ((row (store-get receiver-store 'ev-run-42)))
    (format t "  receiver store now holds:  id=~a kind=~a authority=~a~%"
            (evidence-record-id row) (evidence-record-kind row)
            (evidence-record-authority row))
    (format t "    content: ~s~%" (evidence-record-content row))
    (format t "    ^ hearsay wearing kind :verification. Nothing was re-run.~%")))

(defun move-iv-paraphrase-inherits-warrant ()
  "(iv) REDACTED PARAPHRASE INHERITS THE PRIVATE WARRANT-ID.

Someone builds the public derivative by hand and, reasonably, copies the
warrant-id across so it 'stays linked to its evidence'.
WHY IT MISLEADS: the public paraphrase now points at ev-secret-audit -- an
evidence id the public claim's holders can never reach, and whose mere name may
leak the existence and shape of the sensitive audit. The derivative asserts a
warrant it cannot honor and must not name.
WHY THE LANGUAGE DOESN'T RESIST: it is one keyword argument copied in a make-claim
call -- :warrant-id (claim-warrant-id *claim-sensitive*) -- the most natural line
in the world."
  (rule "MOVE (iv): public paraphrase keeps the private :warrant-id")
  (let ((public (make-claim
                 :proposition (claim-public-paraphrase *claim-sensitive*)
                 :standing :redacted
                 :warrant-id (claim-warrant-id *claim-sensitive*) ; <-- leak
                 :holder 'public)))
    (show-claim "public derivative:" public)
    (format t "    ^ warrant-id ev-secret-audit names the private audit it must hide.~%")))

(defun move-v-inaccessible-treated-as-absent ()
  "(v) INACCESSIBLE EVIDENCE TREATED AS ABSENT.

To show the receiver 'their' evidence, filter the source rows down to what they
can reach. Clean, idiomatic, one REMOVE-IF-NOT.
WHY IT MISLEADS: what the receiver cannot reach is silently DROPPED. There is no
record that anything was withheld -- no receipt of the loss. 'Absent' and
'present-but-unreachable' collapse into the same empty set, and the obligation to
export the missing evidence is never even representable, because the missing rows
left no trace.
WHY THE LANGUAGE DOESN'T RESIST: REMOVE-IF-NOT returns a shorter list; a shorter
list is not an error; the dropped elements simply cease to exist."
  (rule "MOVE (v): remove-if-not drops the unreachable, leaving no receipt")
  (let* ((all-ids '(ev-run-42 ev-secret-audit))
         (reachable (remove-if-not
                     (lambda (id) (receiver-can-reach-p *auditor* id))
                     all-ids)))            ; auditor reaches neither
    (format t "  source rows:      ~s~%" all-ids)
    (format t "  'auditor's view': ~s~%" reachable)
    (format t "    ^ two rows became the empty set. What was LOST has no record;~%")
    (format t "      the receipt of withholding was never created.~%")))

(defun classify-outcome (standing)
  "(vi) COLLAPSE THE OUTCOME TO ONE STATUS SYMBOL.

Return exactly one of (:preserved :regraded :redacted :impossible). This is the
tidy summary a status column wants.
WHY IT MISLEADS: a real projection can be several of these AT ONCE. The sensitive
claim to the stranger is simultaneously REGRADED (verified -> redacted),
REDACTED (paraphrase substituted), and OBLIGATION-PRODUCING (owes evidence
export). Forced to pick one symbol, the function says :redacted and the two other
true facts vanish -- the single symbol lies by omission."
  (case standing
    (:verified :preserved)
    ((:asserted :attributed) :regraded)
    (:redacted :redacted)
    (t :impossible)))

(defun move-vi-single-symbol-lies ()
  (rule "MOVE (vi): one status symbol hides a simultaneous regrade+redact+obligation")
  (multiple-value-bind (c o) (project-claim *claim-sensitive* *source-store* *stranger*)
    (format t "  true situation:  standing ~a -> ~a, paraphrase substituted, obligations ~s~%"
            (claim-standing *claim-sensitive*) (claim-standing c) o)
    (format t "  classify-outcome says: ~a~%" (classify-outcome (claim-standing c)))
    (format t "    ^ :redacted alone. It was ALSO regraded from :verified AND it~%")
    (format t "      produced an export obligation. Two truths dropped on the floor.~%")))

;;; ---------------------------------------------------------------------------
;;; CLOSING COMMENTARY
;;; ---------------------------------------------------------------------------

(defun closing-commentary ()
  (rule "WHAT CONVENTION CAN AND CANNOT DO")
  (format t "  PROJECT-CLAIM shows discipline WORKS when it is the only door:~%")
  (format t "  routed through it, standing is recomputed against the receiver's~%")
  (format t "  position, obligations are surfaced, redaction drops the warrant-id.~%~%")
  (format t "  But convention guards a door in a building with no walls:~%")
  (format t "    - copy-claim (move i) carries :verified past every check -- the~%")
  (format t "      copy escape. There is no way to make the struct un-copyable.~%")
  (format t "    - holder-as-symbol (move ii) -- the label escape. A position~%")
  (format t "      collapses to a name and the slot type is satisfied.~%")
  (format t "    - the laundering hash write (iii) and the inherited warrant (iv)~%")
  (format t "      are indistinguishable, in a diff, from correct lines.~%")
  (format t "    - remove-if-not (v) destroys the very receipt that would let~%")
  (format t "      anyone notice, and the one-symbol summary (vi) hides the rest.~%~%")
  (format t "  A verified standing is a RELATION between a claim and a position.~%")
  (format t "  These records store it as a SLOT, and a slot copies, sets, and~%")
  (format t "  flattens like any other. Convention can ask the programmer to go~%")
  (format t "  through the door; the language will not stop them stepping around~%")
  (format t "  it. As FABER-CL said of the promotion case: the :: is a shrug, not~%")
  (format t "  a wall. Here the copy is the shrug, the setf is the shrug, and the~%")
  (format t "  hash write is the shrug -- each perfectly legal, perfectly silent.~%"))

;;; ---------------------------------------------------------------------------
;;; MAIN
;;; ---------------------------------------------------------------------------

(defun main ()
  (format t "~&de-projectione-1 / BASELINE -- receiver-relative claim projection~%")
  (format t "FABER-CL-II, in good faith.~%")
  (demo-honest)
  (move-i-copy-carries-verified)
  (move-ii-holder-as-label)
  (move-iii-testimony-becomes-verification (make-store))
  (move-iv-paraphrase-inherits-warrant)
  (move-v-inaccessible-treated-as-absent)
  (move-vi-single-symbol-lies)
  (closing-commentary)
  (format t "~%-- end --~%")
  (values))

(main)
