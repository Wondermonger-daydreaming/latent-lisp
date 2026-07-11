;;;; tripticum-auctoritatis.lisp — "The Triptych of Authority"
;;;;
;;;; Runs the Counterfeit Triptych + coda in order, printing the conceptual transition between
;;;; specimens — so the atelier holds not only runnable files but a COMPOSED ARGUMENT (Sol's ask).
;;;; Each seam is the one the last movement opens:
;;;;   appearance → enclosure → lineage → custody
;;;;   (costume)    (reliquary) (immunity) (theft)
;;;;   sbcl --script tripticum-auctoritatis.lisp   (exit 0)

(defun play (file caption)
  (format t "~%~a~%~%" caption)
  (finish-output)
  (sb-ext:run-program (namestring sb-ext:*runtime-pathname*)
                      (list "--script" (namestring file))
                      :output *standard-output* :error *standard-output*))

(let ((here (directory-namestring *load-truename*)))
  (flet ((movement (f caption transition)
           (play (merge-pathnames f here) caption)
           (when transition (format t "~%   ↓ ~a~%" transition))))
    (format t "════════ THE TRIPTYCH OF AUTHORITY (+ coda) ════════~%")
    (movement "de-veste.lisp" "I. APPEARANCE — is the authority merely displayed?"
              "a costume can be sewn by the wearer. so we hide the needle and ask the world. but what the verifier hands back…")
    (movement "de-cistula.lisp" "II. ENCLOSURE — does integrity survive being observed?"
              "…a sealed box can leak through its own reader. so we copy on the way out. but a real token, worn on the wrong claim…")
    (movement "de-immunitate.lisp" "III. LINEAGE — can provenance tell genuine from an impeccable imitation?"
              "…the body binds each token to what it was issued FOR. but a key it truly issued can still be taken by another hand…")
    (movement "de-furto.lisp" "coda. CUSTODY — authentic authority in an unauthorized hand." nil)
    (format t "~%════════ appearance · enclosure · lineage · custody ════════~%")
    (format t "Costume, reliquary, immune memory, theft — each seam the last one opens.~%")
    (format t "Unforgeability answers the first three. Only custody answers the fourth.~%")))
