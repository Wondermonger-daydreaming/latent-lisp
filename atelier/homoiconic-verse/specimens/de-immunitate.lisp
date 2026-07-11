;;;; de-immunitate.lisp — "Concerning Immunity"   (hardened after the cold chair)
;;;;
;;;; Sol caught it: the mint recorded only that a token was issued, and admission checked
;;;; only that the token was ours — so a genuine token stolen and re-labelled with a DIFFERENT
;;;; payload passed. "The immune memory recognized the passport but never compared it with the
;;;; face." Fix: bind the token to what it was issued FOR. Provenance without target binding is
;;;; only a transferable halo.   sbcl --script de-immunitate.lisp   (exit 0)
;;;;
;;;; (The remaining seam — a genuine token on its genuine payload in the WRONG HAND — is not a
;;;;  forgery but a THEFT; that is de-furto's subject, the coda to this cycle.)

(defvar *mint* (make-hash-table))                       ; immune memory: token -> what it was issued FOR
(defun issue (payload) (let ((tok (gensym "SELF"))) (setf (gethash tok *mint*) (copy-tree payload)) tok))
(defun issued-for-p (tok payload)                       ; the antibody: token AND target must match
  (let ((rec (gethash tok *mint*))) (and rec (equal rec payload))))

(defun genuine (payload) (list :token (issue payload) :payload (copy-tree payload)))
(defun counterfeit (payload) (list :token (gensym "FAKE") :payload payload))              ; foreign token
(defun genuine-token-wrong-payload (att new-payload)                                       ; Sol's exploit
  (list :token (getf att :token) :payload new-payload))

(defun admit-p (att) (issued-for-p (getf att :token) (getf att :payload)))

(format t "~&— de immunitate — concerning immunity —~%~%")
(let* ((self  (genuine :verified))
       (fake  (counterfeit :verified))                  ; identical shape, foreign token
       (relabelled (genuine-token-wrong-payload self :ALSO-VERIFIED)))  ; real token, wrong face
  (format t "genuine cell (issued for :verified)            admitted? ~a~%" (if (admit-p self) :YES :rejected))
  (format t "counterfeit (foreign token, same shape)        admitted? ~a~%" (if (admit-p fake) :yes :REJECTED))
  (format t "genuine token, DIFFERENT payload (Sol's catch) admitted? ~a~%" (if (admit-p relabelled) :yes :REJECTED)))

(format t "~%The antibody asks not only \"did I issue this token?\" but \"what did I issue it FOR?\"~%")
(format t "Provenance without target binding is only a transferable halo.~%")
