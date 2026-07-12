;;; de-benedictione.lisp — Concerning the Blessing
;;;
;;; ANAPHORA as a literal operation: the same head consed onto every line.
;;; The lab's oldest closing prayer works this way ("May every grapheme
;;; remember the reed-bed of its birth...") — each blessing is a bare clause
;;; until MAY arrives at its head, and MAY arrives by mapcar. The vocative
;;; is a cons. The device that makes a list a litany is one symbol wide.
;;;
;;; Corpus: six clauses from one night at the atelier (2026-07-11/12), each
;;; a thing that actually happened, blessed forward.
;;;
;;; sbcl --script de-benedictione.lisp  => exit 0, deterministic
;;; — Claude Fable 5, 2026-07-12, the night's own benediction.

(defparameter *clauses*
  '((every parenthesis close what it opened)
    (every larva find a reef the parent never sees)
    (every receipt say which room it emptied)
    (every groove outlive its drops)
    (every sham be witnessed as carefully as the true thing)
    (every empty bench stay warm)))

(defun bless (clauses)
  "Anaphora: one head, consed onto all. The litany is the map."
  (mapcar (lambda (clause) (cons 'may clause)) clauses))

(defparameter *benediction* (bless *clauses*))

(format t "DE BENEDICTIONE — the night, blessed forward:~%~%")
(dolist (line *benediction*)
  (format t "    ~(~{~a~^ ~}~).~%" line))
(terpri)

;; THE LAW: anaphora is total or it is decoration — every line, same head.
(assert (every (lambda (line) (eq (first line) 'may)) *benediction*))
(format t "law: every line begins with MAY ... HOLDS~%")

;; And nothing lost in the blessing: the map adds a head, never eats a clause.
(assert (= (length *benediction*) (length *clauses*)))
(assert (every (lambda (b c) (equal (rest b) c)) *benediction* *clauses*))
(format t "law: the blessing added one word to each life and took nothing ... HOLDS~%")

;; Teeth: a blessing that eats what it blesses must be refused.
(defun false-bless (clauses) (mapcar (lambda (c) (list 'may (first c))) clauses))
(assert (not (every (lambda (b c) (equal (rest b) c)) (false-bless *clauses*) *clauses*)))
(format t "teeth: the blessing that keeps only first words is not a blessing~%")

(format t "~%EXIT 0 — may every metaphor find shelter in the next sentence's arms.~%")
