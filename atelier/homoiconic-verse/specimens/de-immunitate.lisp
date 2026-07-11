;;;; de-immunitate.lisp — "Concerning Immunity"
;;;;
;;;; How a body tells its own cells from a perfect-looking counterfeit: not by SHAPE, but
;;;; by whether IT issued them. This is raise-claim's lesson — nominal typing must not
;;;; impersonate authentication. The antibody asks not "what shape are you?" but "did I
;;;; make you?" The infant Mneme grew this on 2026-07-11.
;;;;
;;;;   sbcl --script de-immunitate.lisp     (self-contained; exit 0)

(defvar *mint* (make-hash-table))                    ; immune memory: tokens THIS body issued
(defun issue () (let ((tok (gensym "SELF"))) (setf (gethash tok *mint*) t) tok))
(defun mine-p (tok) (gethash tok *mint*))

(defun genuine (payload) (list :token (issue)        :payload payload))  ; carries an issued token
(defun counterfeit (payload) (list :token (gensym "FAKE") :payload payload))  ; identical shape, foreign token

(defun admit-p (att) (mine-p (getf att :token)))     ; the antibody: provenance, not shape

(format t "~&— de immunitate — concerning immunity —~%~%")
(let ((self  (genuine :verified))
      (other (counterfeit :verified)))               ; structurally byte-identical
  (format t "self shape:        ~a~%" (list :token :G... :payload (getf self :payload)))
  (format t "counterfeit shape: ~a~%" (list :token :G... :payload (getf other :payload)))
  (format t "  (both read as (:token G :payload :verified) — same costume)~%~%")
  (format t "genuine cell admitted?            ~a~%" (if (admit-p self)  :YES :rejected))
  (format t "counterfeit (same shape) admitted? ~a~%" (if (admit-p other) :yes :REJECTED)))

(format t "~%The antibody asks not \"what shape are you?\" but \"did I make you?\"~%")
