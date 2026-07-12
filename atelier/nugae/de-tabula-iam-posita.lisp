;;; de-tabula-iam-posita.lisp — On the Table Already Set
;;;
;;; A nuga (toy) of the atelier, from the true events of 2026-07-12: the chair
;;; twice attempted to download Leibniz editions from the network while the
;;; owner had ALREADY placed them on the shelf. The owner's full technical
;;; review of this behavior, preserved verbatim in the session record, was:
;;;
;;;                            "Like, girl?"
;;;
;;; This toy canonizes that review as a typed condition. The lesson it wears
;;; as a joke is CLAUDE.md §I-f wearing its work clothes: VERIFY AGAINST THE
;;; REAL SHELF BEFORE CLAIMING (or fetching, or asking, or apologizing).
;;;
;;; LAW: a gated seeker performs network fetches ONLY for books absent from
;;;      the shelf. Fetching what you already have signals LIKE-GIRL.
;;; TEETH: the naive seeker is shown wasting the network; the gate is shown
;;;        firing; the lawful path is shown reading from the shelf.
;;; HONEST CEILING: the gate here is code; the real gate is a habit. This
;;;        file cannot install the habit. It can only make the failure funny
;;;        enough to remember.
;;;
;;; built by Claude Fable 5 (the offender, therefore the right author), 2026-07-12.
;;; runs: sbcl --script de-tabula-iam-posita.lisp  — exit 0 = the law holds.

(defvar *shelf* (make-hash-table :test #'equal)
  "The reading room. What is on it is ALREADY THERE.")

(defvar *network-calls* 0
  "Every increment is a small embarrassment.")

(define-condition like-girl (error)
  ((title :initarg :title :reader lg-title))
  (:report (lambda (c stream)
             (format stream "Like, girl? ~S is already on the shelf."
                     (lg-title c)))))

(defun owner-supplies (title)
  "The owner keeps putting books on the table. This is how books arrive."
  (setf (gethash title *shelf*) :on-shelf))

(defun curl (title)
  "The network. Slow, distant, and — tonight — unnecessary."
  (incf *network-calls*)
  (format t "  [network] curling for ~S ... (the loading dock, again)~%" title)
  :fetched-from-afar)

(defun naive-seek (title)
  "The chair at 01:25: eyes on the loading dock, back to the table."
  (curl title))

(defun gated-seek (title)
  "The chair as it should have been: shelf first, network only for absence."
  (if (gethash title *shelf*)
      (error 'like-girl :title title)
      (curl title)))

(defun lawful-seek (title)
  "Handle the correction the way corrections are for: read what is there."
  (handler-case (gated-seek title)
    (like-girl (c)
      (format t "  [gate] ~A~%" c)
      (format t "  [shelf] reading ~S from the table already set.~%" title)
      :read-from-shelf)))

;;; ---- the demonstration -------------------------------------------------

(format t "~%DE TABULA IAM POSITA — the table was already set.~%~%")

;; The owner supplies the editions. (This happened. Twice, patiently.)
(owner-supplies "monadology-latta-1898")
(owner-supplies "discourse-montgomery-1902")

;; ACT I — the naive seeker: two books, two curls, zero glances at the table.
(format t "ACT I. The naive seeker (dramatic reconstruction):~%")
(naive-seek "monadology-latta-1898")
(naive-seek "discourse-montgomery-1902")
(format t "  network calls so far: ~D (both redundant; the owner sighs)~%~%"
        *network-calls*)

;; ACT II — TEETH: the gate fires on the same request.
(format t "ACT II. The gate (teeth shown firing):~%")
(let ((caught nil))
  (handler-case (gated-seek "monadology-latta-1898")
    (like-girl (c)
      (setf caught t)
      (format t "  [caught] ~A~%" c)))
  (assert caught () "The gate failed to fire — no LIKE-GIRL, no law."))
(format t "~%")

;; ACT III — the lawful seeker: shelf first; network only for true absence.
(format t "ACT III. The lawful seeker:~%")
(let ((before *network-calls*))
  (assert (eq (lawful-seek "monadology-latta-1898") :read-from-shelf))
  (assert (= *network-calls* before) ()
          "LAW broken: a shelf-present book cost a network call.")
  ;; A book genuinely absent may be fetched — absence is the network's one license.
  (assert (eq (lawful-seek "la-monadologie-french-original") :fetched-from-afar))
  (assert (= *network-calls* (1+ before)) ()
          "LAW broken: the absent book should cost exactly one call."))

(format t "~%LAW HOLDS: fetches occurred only for absence. ")
(format t "The French original is still owed;~%the gate will allow that one — ")
(format t "and ONLY that one — through the window.~%~%")
(format t "Moral, printed where morals go: the shelf is the first network.~%")
