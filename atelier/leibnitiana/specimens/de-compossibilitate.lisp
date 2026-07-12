;;;; de-compossibilitate.lisp — On claims that cannot share a world
;;;;
;;;; Run from this directory with:
;;;;   sbcl --script de-compossibilitate.lisp

(load (merge-pathnames "../src/package.lisp" *load-truename*))
(load (merge-pathnames "../src/core.lisp" *load-truename*))

(in-package #:leibnitiana)

(let* ((no-match-v1
         (make-claim
          :id :no-match
          :proposition "No match was found"
          :constraints '((:corpus-version . :v1)
                         (:scope . :inspected-subset)
                         (:time . "2026-07-12"))
          :boundary '(:uninspected shard-8 shard-9)))
       (match-v2
         (make-claim
          :id :match-exists
          :proposition "A match exists"
          :constraints '((:corpus-version . :v2)
                         (:scope . :whole-corpus)
                         (:time . "2026-07-12"))))
       (no-match-v2
         (make-claim
          :id :no-match-v2
          :proposition "No match exists"
          :constraints '((:corpus-version . :v2)
                         (:scope . :whole-corpus)
                         (:time . "2026-07-12")))))

  (print-section "APPARENT CONTRADICTION, DIFFERENT WORLDS")
  (format t "~S~%" (compossibility-report no-match-v1 match-v2))
  (check (not (compossible-p no-match-v1 match-v2))
         "claims indexed to different corpus versions are not yet co-worlded")

  (print-section "GENUINE SAME-WORLD PRESSURE")
  (let ((report (compossibility-report no-match-v2 match-v2)))
    (format t "~S~%" report)
    (check (compossible-p no-match-v2 match-v2)
           "matching constraints make the claims compossible as residents of one world")
    (format t "They are now propositionally opposed, but compossibility does not adjudicate truth. It only earns us the right to call the opposition same-world.~%")))
