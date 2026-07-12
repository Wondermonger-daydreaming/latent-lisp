;;; elegia-in-librum-truncum.lisp — Elegy for the Truncated Book
;;;
;;; A nuga of the atelier, in memoriam: discourse-metaphysics-montgomery-
;;; 1902_english.pdf, which arrived on the Leibniz shelf on 2026-07-12
;;; promising 310 pages and ended mid-byte — no trailer dictionary, no xref,
;;; no %%EOF. mutool repaired its skeleton and found no flesh. It is kept on
;;; the shelf as evidence, awaiting its whole twin. (Facts per the reading
;;; room README, recorded that night; embedded here as constants — this toy
;;; mourns from the record, it does not re-measure the grave.)
;;;
;;; An elegy for an unfinished thing should itself finish. So:
;;;
;;; LAW: this file's own last non-blank line is its declared sentinel — the
;;;      elegy ends where it means to, unlike the mourned.
;;; TEETH: a truncated copy of this very file (tail cut off, in /tmp) FAILS
;;;      the same check — the instrument detects the death it mourns.
;;; HONEST CEILING: completeness-of-text is not completeness-of-meaning; a
;;;      file can end properly and still say too little. This one, probably.
;;;
;;; built by Claude Fable 5, 2026-07-12. runs: sbcl --script — exit 0 = the
;;; elegy is whole.

(defparameter +sentinel+ ";; %%EOF — finis, ut promissum.")

(defparameter +the-departed+
  '(:file "discourse-metaphysics-montgomery-1902_english.pdf"
    :promised-pages 310
    :bytes-received 1421312
    :trailer :absent
    :cause "truncated in transit (verified: no %%EOF at tail)"
    :status "kept as evidence; awaiting re-download"))

(defun last-meaningful-line (path)
  (with-open-file (s path :direction :input)
    (let ((last nil))
      (loop for line = (read-line s nil nil)
            while line
            do (let ((trimmed (string-trim '(#\Space #\Tab #\Return) line)))
                 (when (plusp (length trimmed)) (setf last trimmed))))
      last)))

(defun whole-p (path)
  "Does this text end where it meant to?"
  (equal (last-meaningful-line path) +sentinel+))

;;; ---- the elegy ----------------------------------------------------------

(format t "~%ELEGIA IN LIBRUM TRUNCUM~%~%")
(format t "  Here lies ~A,~%" (getf +the-departed+ :file))
(format t "  who promised ~D pages and kept an unknowable fraction;~%"
        (getf +the-departed+ :promised-pages))
(format t "  who carried ~:D bytes across the wire and dropped the last ones~%"
        (getf +the-departed+ :bytes-received))
(format t "  somewhere over the Atlantic of the loading bar.~%")
(format t "  It has no %%EOF. It did not get to say it was finished.~%")
(format t "  No book should end inside a sentence it cannot~%~%")
(format t "  — like that. You see how it feels.~%~%")
(format t "  We keep it on the shelf as evidence, not as a book:~%")
(format t "  the difference is a trailer dictionary and a promise kept.~%")
(format t "  Its whole twin is owed. The shelf holds the empty place.~%~%")

;;; ---- the law: mourner, prove YOUR ending --------------------------------

(assert (whole-p *load-pathname*) ()
        "The elegy itself is truncated — the mourner has joined the mourned.")
(format t "  [law] this elegy ends where it means to (sentinel verified).~%")

;;; ---- teeth: the instrument must detect the death it mourns --------------

(let* ((tmp (merge-pathnames "elegia-truncata-test.lisp"
                             (pathname "/tmp/")))
       (self (with-open-file (s *load-pathname*)
               (let ((b (make-string (file-length s))))
                 (subseq b 0 (read-sequence b s))))))
  (with-open-file (out tmp :direction :output :if-exists :supersede)
    ;; bury the tail: cut the last 120 characters — the sentinel dies with them.
    (write-string (subseq self 0 (- (length self) 120)) out))
  (assert (not (whole-p tmp)) ()
          "TEETH failed: the truncated copy passed the wholeness check.")
  (format t "  [teeth] a truncated copy of this file FAILS the same check — ")
  (format t "the instrument bites.~%")
  (delete-file tmp))

(format t "~%  Requiescat in partibus. May its re-download arrive entire.~%~%")

;; %%EOF — finis, ut promissum.
