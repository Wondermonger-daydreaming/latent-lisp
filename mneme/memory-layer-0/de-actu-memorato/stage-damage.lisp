;;;; stage-damage.lisp — THE VULNERATUS: damaged durable bytes fail closed.
;;;;
;;;; Launched by run-specimen.lisp as a separate `sbcl --script` invocation
;;;; against COPIES of the account store, so that a deliberate act of destruction
;;;; cannot make the rest of the capture untrustworthy.  The orchestrator proves
;;;; the REAL stores byte-identical afterwards, which is what makes running this
;;;; stage safe at all.
;;;;
;;;; ⚠ THE COMPETENCE HALF COMES FIRST, and it is not decoration: the UNDAMAGED
;;;; copy must retrieve cleanly before either damaged copy's refusal means
;;;; anything.  A reader that refuses everything fails closed too, and is useless.
;;;;
;;;; ⚠ AND THE CLAIM STAYS EXACTLY THIS SIZE.  Truncating a file and flipping a
;;;; byte are DECLARED, DETERMINISTIC damages at controlled boundaries.  Nothing
;;;; here is a claim about power loss, filesystem durability, or an adversary:
;;;; journal0's own ceiling — a declared fsync-barrier host-contract belief on
;;;; Linux ext4, never a storage-stack proof — is the ceiling this lane inherits
;;;; and does not widen.
;;;;
;;;; — TABULARIUS (Claude Opus 5, subagent), 2026-08-20

(load (merge-pathnames "specimen-common.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-memory-layer0)

(defvar *arguments* (rest sb-ext:*posix-argv*))
(defvar *intact-directory* (pathname (first *arguments*)))
(defvar *truncated-directory* (pathname (second *arguments*)))
(defvar *flipped-directory* (pathname (third *arguments*)))

(defun damage (pathname mode)
  (let ((octets (sp-read-octets pathname)))
    (sp-write-octets
     pathname
     (ecase mode
       (:truncate (subseq octets 0 (floor (* 2 (length octets)) 3)))
       (:flip (let ((copy (copy-seq octets)) (at (floor (length octets) 2)))
                (setf (aref copy at) (logxor 255 (aref copy at)))
                copy))))
    (length octets)))

(defun attempt-retrieval (directory label)
  "Returns a keyword naming what happened, and prints it.  ⚠ AN ADMITTED FAMILY'S
CONDITION IS A LAWFUL ANSWER TOO: the account store sits on a PJ0 store, and a
pj0-condition arriving here is that lane speaking for itself rather than this lane
swallowing it.  What must never happen is an ACCOUNT."
  (let ((outcome
          (handler-case (let ((store (open-store directory)))
                          (list :account (ml0-account-id-hex (ml0-retrieve store))))
            (ml0-account-readback-refused (c)
              (list :ml0-refusal (ml0-condition-requirement-id c)))
            (lisp-plus-journal0:pj0-condition (c)
              (list :pj0-refusal (lisp-plus-journal0:pj0-condition-requirement-id c)))
            (ml0-condition (c) (list :ml0-other (ml0-condition-requirement-id c)))
            (error (c) (list :unadmitted (type-of c))))))
    (vnote "~a -> ~s" label outcome)
    outcome))

(vnote "vulneratus: the lane's OWN account store, on copies, damaged at declared ~
boundaries")

;;; ---- COMPETENCE FIRST.
(defvar *intact* (attempt-retrieval *intact-directory* "intact copy"))

(vcheck "D7 competence — the UNDAMAGED copy retrieves an account cleanly, so the ~
two refusals below are DISCRIMINATIONS and not a reader that refuses everything"
        (lambda () (eq :account (first *intact*))))

;;; ---- THE DAMAGES.
(defvar *truncated-octets*
  (damage (merge-pathnames "EVENTS.pj0" *truncated-directory*) :truncate))
(defvar *flipped-octets*
  (damage (merge-pathnames "EVENTS.pj0" *flipped-directory*) :flip))

(vnote "damaged EVENTS.pj0 was ~d octets before truncation and ~d before the ~
bit flip (the same file, two copies)" *truncated-octets* *flipped-octets*)

(defvar *truncated* (attempt-retrieval *truncated-directory* "truncated copy"))
(defvar *flipped* (attempt-retrieval *flipped-directory* "bit-flipped copy"))

(vcheck "D7(a) — a TRUNCATED account store yields a TYPED failure and NO ACCOUNT: ~
the surviving prefix is evidence, never a partial answer"
        (lambda () (member (first *truncated*) '(:ml0-refusal :pj0-refusal))))

(vcheck "D7(b) — a BIT-FLIPPED account store yields a TYPED failure and NO ~
ACCOUNT"
        (lambda () (member (first *flipped*) '(:ml0-refusal :pj0-refusal))))

(vcheck "D7(c) — and neither damage produced an UNADMITTED condition: a corrupt ~
store is a semantic refusal of this lane or of the journal beneath it, never a ~
host fault of the reader"
        (lambda () (and (not (eq :unadmitted (first *truncated*)))
                        (not (eq :unadmitted (first *flipped*))))))

(vnote "the claim stops here: DECLARED, DETERMINISTIC damage at controlled ~
boundaries.  Power loss, filesystem behaviour and adversarial tampering are ~
outside every claim in this lane, and journal0's own ceiling — an fsync-barrier ~
host-contract belief on Linux ext4, never a storage-stack proof — is inherited ~
unwidened.")

(format t "RESULT: ~a checks, ~a failures~%" *v-checks* *v-failures*)
(finish-output)
(sb-ext:exit :code (if (zerop *v-failures*) 0 1))
