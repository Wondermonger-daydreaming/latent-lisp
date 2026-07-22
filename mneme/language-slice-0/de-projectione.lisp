;;;; [BANNER, R6 2026-07-22]: PRE-RATIFICATION SIGNATURE-DISCOVERY DRAFT.
;;;; Written before Sol's ruling reordered the slate (de-promotione first —
;;;; both later specimens presuppose governed standing). This file stands as
;;;; INVENTORY EVIDENCE and discovery record (D1-D5 at bottom), NOT as the
;;;; de-projectione specimen; the specimen proper arrives at execution step 5
;;;; with its packet (HYPOTHESIS/BASELINE/SPECIMEN/ABLATION/EXPECTED-FAILURES/
;;;; RUN-RECEIPT). Its selftest remains runnable; its semantics remain
;;;; [DRAFT-GUESS] until the charter and de-promotione exist.
;;;; de-projectione.lisp — Slice /0 signature discovery, draft /0
;;;;
;;;; HYPOTHESIS (admission rule, clause 1): receiver-position is computable —
;;;;   given a claim with warrants, a receiver-context descriptor, and the
;;;;   provided-evidence record, what the claim lawfully BECOMES for that
;;;;   receiver is a function, not a judgment call. The six adjectives of the
;;;;   ruling era (preserved / regraded / redacted / obligation-producing /
;;;;   impossible / mute) should fall out as COMPUTED RESULTS over an
;;;;   access-set.
;;;; FAILURE MODE (clause 2): a mind using this wrongly transmits a claim at
;;;;   sender-standing into a context whose accessible warrants license less —
;;;;   M4 (de-lectore) enacted in code: "you can verify this" to a receiver
;;;;   who cannot.
;;;; ABLATION (clause 3): delete the access tags from warrants (everyone sees
;;;;   everything) and PROJECT-CLAIM must collapse to the identity projection
;;;;   — if it doesn't, the machinery is doing something other than modeling
;;;;   access, and the hypothesis is false as implemented.
;;;;
;;;; STATUS: draft /0, UNRATIFIED, bench work. SBCL 2.4.6 (wrapper
;;;; operation-checked). Semantics marked [DRAFT-GUESS] await the theory's
;;;; owner; see SIGNATURE DISCOVERIES at bottom — the file's actual product.

(defpackage :de-projectione/0
  (:use :cl)
  (:export #:warrant #:claim #:receiver #:project-claim #:projection
           #:selftest))
(in-package :de-projectione/0)

;;; ---------------------------------------------------------------- ladder

(defparameter *ladder* '(:asserted :executed :witnessed :verified)
  "Standing ladder, ascending. :authorized is orthogonal (not on the ladder).")

(defun standing<= (a b)
  (<= (position a *ladder*) (position b *ladder*)))

(defparameter *kind-licenses*
  '((:execution-trace . :executed)
    (:witness-statement . :witnessed)
    (:verification-procedure . :verified))
  "Warrant kind -> highest ladder rung it licenses (its rung and below).")

;;; ------------------------------------------------------------ structures

(defstruct warrant
  id kind scope                     ; scope = the proposition it faces
  access                            ; list of context tags that may see it
  grantable-p)                      ; can the sender lawfully extend access?

(defstruct claim
  proposition standing warrant-ids
  enclosed-for)                     ; custody: nil = open; else tag list —
                                    ; ONLY those contexts may receive the
                                    ; proposition text at all

(defstruct receiver
  name access domains)              ; access = tags held; domains = topics
                                    ; the context can receive at all

;;; ------------------------------------------------------------ projection
;;; [DISCOVERY-1 enacted]: the return type is a STRUCTURED PROJECTION, not an
;;; adjective. The adjective is a computed summary of three independent
;;; dispositions. See discoveries below.

(defstruct projection
  verdict                           ; the summary adjective (one of the six)
  content-disposition               ; :open | :withheld
  standing-out                      ; rung the receiver may lawfully receive
  obligations                       ; list, e.g. (:grant-access-to W3)
  notes)

(defun resolve (ids per) (remove nil (mapcar (lambda (i) (gethash i per)) ids)))

(defun accessible-p (w r) (intersection (warrant-access w) (receiver-access r)))

(defun licensed-standing (warrants proposition)
  "Highest rung the given warrants license for PROPOSITION. [DRAFT-GUESS:
scope test = EQUAL on the proposition — the constitution's neighbor-test is
richer; adequate for /0.]"
  (let ((best :asserted))
    (dolist (w warrants best)
      (let ((rung (cdr (assoc (warrant-kind w) *kind-licenses*))))
        (when (and rung
                   (equal (warrant-scope w) proposition)
                   (not (standing<= rung best)))
          (setf best rung))))))

(defun project-claim (claim receiver per)
  "What CLAIM lawfully becomes for RECEIVER, given PER (hash id->warrant).
Returns a PROJECTION. The six adjectives are summaries, never inputs."
  (let* ((prop (claim-proposition claim)))
    ;; 1. domain gate: can this context receive the topic at all?
    (unless (or (null (receiver-domains receiver))
                (member (getf prop :domain) (receiver-domains receiver)))
      (return-from project-claim
        (make-projection :verdict :mute :content-disposition :withheld
                         :standing-out nil
                         :notes '("proposition outside receiver domains"))))
    ;; 2. custody gate: enclosure beats everything except muteness.
    (let ((custody (claim-enclosed-for claim)))
      (when (and custody
                 (not (intersection custody (receiver-access receiver))))
        (return-from project-claim
          (make-projection :verdict :redacted :content-disposition :withheld
                           :standing-out nil
                           :notes '("proposition enclosed for other contexts")))))
    ;; 3. warrant arithmetic.
    (let* ((ws (resolve (claim-warrant-ids claim) per))
           (acc (remove-if-not (lambda (w) (accessible-p w receiver)) ws))
           (inacc (set-difference ws acc))
           (lic (licensed-standing acc prop))
           (want (claim-standing claim)))
      (cond
        ;; everything the sender has, the receiver can check: identity.
        ((standing<= want lic)
         (make-projection :verdict :preserved :content-disposition :open
                          :standing-out want))
        ;; inaccessible warrants exist but are grantable: the projection is
        ;; lawful ONLY as a transaction — the sender takes on an obligation.
        ((and inacc (every #'warrant-grantable-p inacc))
         (make-projection :verdict :obligation-producing
                          :content-disposition :open :standing-out want
                          :obligations (mapcar (lambda (w)
                                                 (list :grant-access-to
                                                       (warrant-id w)))
                                               inacc)))
        ;; accessible subset licenses something above bare assertion: regrade.
        ((not (eq lic :asserted))
         (make-projection :verdict :regraded :content-disposition :open
                          :standing-out lic
                          :notes (list (format nil "~a -> ~a" want lic))))
        ;; warrants exist, none accessible, none grantable — and the claim's
        ;; standing is constitutively warrant-dependent: it cannot truthfully
        ;; travel at any rung above bare assertion, and [DRAFT-GUESS] a
        ;; standing-bearing claim whose standing cannot travel at all is
        ;; IMPOSSIBLE rather than regraded-to-asserted: regrade keeps SOME
        ;; standing; assertion keeps none of what made it a claim-with-
        ;; standing. The theory must rule whether this branch instead reads
        ;; (:regraded :standing-out :asserted). This is the sharpest open
        ;; semantic fork in the file.
        ((and ws (null acc) (not (eq want :asserted)))
         (make-projection :verdict :impossible :content-disposition :withheld
                          :standing-out nil
                          :notes '("no warrant travels; standing cannot survive")))
        ;; bare assertion (or no warrants claimed): travels as itself.
        (t (make-projection :verdict :preserved :content-disposition :open
                            :standing-out :asserted))))))

;;; -------------------------------------------------------------- selftest
;;; Teeth: one example per verdict, plus the ablation and a planted fault.

(defun selftest ()
  (let ((per (make-hash-table)) (fails 0))
    (flet ((w (id kind scope access &optional grantable)
             (setf (gethash id per)
                   (make-warrant :id id :kind kind :scope scope
                                 :access access :grantable-p grantable)))
           (chk (name got want)
             (unless (eq got want)
               (incf fails)
               (format t "FAIL ~a: got ~a want ~a~%" name got want))))
      (let ((prop '(:domain :parser :text "parser handles flat comments")))
        (w 'v1 :verification-procedure prop '(:public))
        (w 'e1 :execution-trace prop '(:operator))
        (w 'e2 :execution-trace prop '(:operator) t)
        (let ((public (make-receiver :name :public :access '(:public)
                                     :domains '(:parser)))
              (operator (make-receiver :name :op :access '(:operator :public)
                                       :domains '(:parser)))
              (outsider (make-receiver :name :out :access '(:public)
                                       :domains '(:billing))))
          ;; preserved: verified claim, verification warrant public
          (chk :preserved
               (projection-verdict
                (project-claim (make-claim :proposition prop :standing :verified
                                           :warrant-ids '(v1))
                               public per))
               :preserved)
          ;; regraded: verified claimed, only execution trace reachable... via
          ;; operator who lacks v1? give operator-only claim on e1:
          (chk :regraded
               (projection-verdict
                (project-claim (make-claim :proposition prop :standing :verified
                                           :warrant-ids '(e1))
                               operator per))
               :regraded)
          ;; impossible: verified claimed, warrant operator-only, receiver public
          (chk :impossible
               (projection-verdict
                (project-claim (make-claim :proposition prop :standing :verified
                                           :warrant-ids '(e1))
                               public per))
               :impossible)
          ;; obligation-producing: same, but the warrant is grantable
          (chk :obligation
               (projection-verdict
                (project-claim (make-claim :proposition prop :standing :executed
                                           :warrant-ids '(e2))
                               public per))
               :obligation-producing)
          ;; redacted: enclosed proposition, receiver outside custody
          (chk :redacted
               (projection-verdict
                (project-claim (make-claim :proposition prop :standing :verified
                                           :warrant-ids '(v1)
                                           :enclosed-for '(:operator))
                               public per))
               :redacted)
          ;; mute: receiver's domains exclude the topic
          (chk :mute
               (projection-verdict
                (project-claim (make-claim :proposition prop :standing :verified
                                           :warrant-ids '(v1))
                               outsider per))
               :mute)
          ;; ABLATION (clause 3): make every warrant world-visible -> identity
          (let ((per2 (make-hash-table)))
            (setf (gethash 'v1 per2)
                  (make-warrant :id 'v1 :kind :verification-procedure
                                :scope prop :access '(:public :operator)))
            (chk :ablation
                 (projection-verdict
                  (project-claim (make-claim :proposition prop
                                             :standing :verified
                                             :warrant-ids '(v1))
                                 public per2))
                 :preserved))
          ;; PLANTED FAULT (teeth): a wrong expectation must FAIL — we assert
          ;; the checker itself can catch a lie, then undo the count.
          (let ((before fails))
            (chk :planted (projection-verdict
                           (project-claim (make-claim :proposition prop
                                                      :standing :verified
                                                      :warrant-ids '(v1))
                                          public per))
                 :impossible)          ; deliberately wrong
            (if (= fails (1+ before))
                (progn (decf fails)
                       (format t "TOOTH OK: planted fault was caught~%"))
                (progn (incf fails)
                       (format t "TOOTH DEAD: planted fault sailed through~%")))))))
    (if (zerop fails)
        (format t "SELFTEST PASS: 6 verdicts + ablation + tooth~%")
        (format t "SELFTEST: ~a FAILURES~%" fails))
    (zerop fails)))

;;;; ------------------------------------------------------------------
;;;; SIGNATURE DISCOVERIES (the file's product — what SBCL told the theory)
;;;;
;;;; D1. The six adjectives are NOT a partition of one codomain. They summarize
;;;;     three independent dispositions (content x standing x obligations):
;;;;     :redacted is a CONTENT verdict, :regraded a STANDING verdict,
;;;;     :obligation-producing a TRANSACTION verdict. PROJECT-CLAIM therefore
;;;;     wants to return a PROJECTION record, adjective as computed summary.
;;;;     The ruling's six adjectives survive — as regions, not as primitives.
;;;; D2. :mute is not computable from an access-set. It needs the receiver
;;;;     descriptor to carry DOMAINS — a modeling commitment the access-set
;;;;     theory never named. (The theory was quietly wrong about at least one
;;;;     argument; it was this one: RECEIVER needs a second field.)
;;;; D3. :obligation-producing requires warrants to know their own
;;;;     GRANTABILITY — an authority fact, sender-side, not receiver-side.
;;;;     Neither the claim nor the receiver can supply it; the PER must.
;;;; D4. The precedence order (mute > redacted > warrant-arithmetic) is
;;;;     load-bearing and was nowhere in the theory: an enclosed claim aimed
;;;;     at an out-of-domain receiver must be :mute, NOT :redacted — the
;;;;     redaction notice itself is information the domain gate withholds.
;;;; D5. OPEN FORK for the theory's owner: all-warrants-inaccessible on a
;;;;     standing-bearing claim — :impossible (drafted here), or
;;;;     :regraded-to-:asserted? The difference is whether bare assertion
;;;;     counts as surviving. One branch, two philosophies; SBCL is neutral.
;;;; ------------------------------------------------------------------

(format t "~&;; de-projectione/0 loaded (draft /0, unratified)~%")
