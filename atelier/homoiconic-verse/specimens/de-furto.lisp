;;;; de-furto.lisp — "Concerning Theft"   (the coda to the Counterfeit Triptych)
;;;;
;;;; Proposed by GPT Sol, 2026-07-11. Not forgery — THEFT. A bearer capability can be
;;;; unforgeable through the supported API and still usable by whoever steals it. The mint can
;;;; prove a key is REAL; it cannot prove the HAND that holds it is the intended hand — not
;;;; without adding identity, confinement, delegation policy, or a process boundary.
;;;; Unforgeability is not custody. Authenticity is not non-transferability.
;;;;   sbcl --script de-furto.lisp   (exit 0)

(defvar *mint* (make-hash-table))
(defun issue (payload) (let ((tok (gensym "KEY"))) (setf (gethash tok *mint*) (copy-tree payload)) tok))
(defun real-key-p (att)                                 ; authenticity: token issued FOR this payload
  (let ((rec (gethash (getf att :token) *mint*))) (and rec (equal rec (getf att :payload)))))

(defun genuine (payload) (list :token (issue payload) :payload payload :hand :owner))
(defun counterfeit (payload) (list :token (gensym "FAKE") :payload payload :hand :owner))
(defun stolen (att thief) (list :token (getf att :token) :payload (getf att :payload) :hand thief))

;; The gate checks authenticity (real-key-p). It does NOT check the hand — bearer authority travels.
(defun admit-p (att) (real-key-p att))

(format t "~&— de furto — concerning theft —~%~%")
(let* ((key   (genuine :open-the-vault))
       (fake  (counterfeit :open-the-vault))
       (heist (stolen key :thief)))
  (format t "counterfeit key (never issued):       ~a~%" (if (admit-p fake)  :ADMITTED :REJECTED))
  (format t "genuine key, in the owner's hand:     ~a~%" (if (admit-p key)   :ADMITTED :REJECTED))
  (format t "STOLEN genuine key, in a thief's hand: ~a   ← same token, same payload, wrong hand~%"
          (if (admit-p heist) :ADMITTED :REJECTED)))

(format t "~%The mint proves a key is REAL. It cannot prove the HAND is the intended hand.~%")
(format t "Unforgeability is not custody. Authenticity is not non-transferability.~%")
(format t "The seal knew its maker. It did not know its thief.~%")
