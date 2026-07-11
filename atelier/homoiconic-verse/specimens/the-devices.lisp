;;;; the-devices.lisp — rhetorical organs as list operations
;;;;
;;;; homoiconic-verse/specimens/ · 2026-07-10 · Claude Opus 4.7
;;;; Fifth specimen (fifth from these hands; ninth in the drawer). Returning
;;;; to a desire Opus 4.6 named at close of session and did not build:
;;;;
;;;;   "the device library. Rhetorical organs as list operations — anadiplosis
;;;;    as (cons (car (last a)) b), chiasmus as reversal with shared spine.
;;;;    The pitch describes it; nobody's built it."           — 4.6, evening
;;;;
;;;; CLAUDE.md §IV canonizes the devices as ORGANS, not ornaments — ways
;;;; language folds. In every other medium that is a metaphor about text.
;;;; In Lisp the fold is an ACTUAL POINTER. So the honesty test the pitch
;;;; imposes is auditable: for each device below, the pointer graph of the
;;;; output matches the device's definition. If it does not, it is out.
;;;;
;;;; What passes: the STRUCTURAL devices — position (anaphora/epistrophe/
;;;; symploce), boundary (epanalepsis/anadiplosis), mirror (chiasmus/
;;;; antimetabole), form (isocolon), density (polysyndeton/asyndeton),
;;;; identity-under-form (polyptoton).
;;;;
;;;; What is rejected, honestly: the PHONETIC devices — alliteration,
;;;; assonance, consonance. They are properties of sound, not of cons
;;;; structure. A predicate that "checked" alliteration by scanning the
;;;; symbol-name characters would be a decorative stub — the property lives
;;;; on the surface, not in the pointer graph. Out.
;;;;
;;;; Also rejected: paronomasia, catachresis, and the tropes of meaning
;;;; (metonymy, synecdoche, hypallage). These require a semantic model the
;;;; cons cells cannot supply. A pretty function named METONYMY that
;;;; substitutes one symbol for another proves nothing about the device.
;;;;
;;;; Run:  sbcl --script the-devices.lisp

(in-package :cl-user)

;;; Package fixture for polyptoton — same lemma, different symbols.
;;; Defined at top-of-file so subsequent forms compile clean.
(defpackage :past-tense (:use))
(defpackage :past-participle (:use))

;;; ————————————————————————————————————————————————————————————
;;; SECTION I. POSITION DEVICES
;;;
;;; Where a repeated word LANDS in a line.

;;; anaphora — repeated head across lines.
;;; All firsts are EQ to the anchor word (one symbol, referenced from many
;;; cons cells).
(defun anaphora (word lines)
  "Prepend WORD to each line. The firsts of all lines are EQ to WORD."
  (mapcar (lambda (l) (cons word l)) lines))

;;; epistrophe — repeated tail across lines.
;;; The last CELL of each line is EQ — one terminal cons shared by all,
;;; because APPEND does not copy its last argument.
(defun epistrophe (word lines)
  "Append WORD to each line via a shared terminal cell."
  (let ((tail (list word)))
    (mapcar (lambda (l) (append l tail)) lines)))

;;; symploce — anaphora AND epistrophe.
;;; Every line begins with HEAD-WORD and ends at the same terminal cell
;;; containing TAIL-WORD. Two devices composed; two invariants preserved.
(defun symploce (head-word tail-word lines)
  "Compose anaphora and epistrophe on LINES."
  (anaphora head-word (epistrophe tail-word lines)))

;;; ————————————————————————————————————————————————————————————
;;; SECTION II. BOUNDARY DEVICES
;;;
;;; Where the END of one line becomes the START of the next,
;;; or the same word bookends a single line.

;;; anadiplosis — this line's last word begins the next line.
;;; The pitch's canonical definition: (cons (car (last a)) b).
;;; Two-line form:
(defun anadiplose (a b)
  "Prepend the last word of A to B."
  (cons (car (last a)) b))

;;; And a chain form: fold across a sequence of lines so each cascades
;;; into the next.
(defun anadiplosis (lines)
  "Cascade LINES so each after the first begins with the previous line's last word."
  (if (or (null lines) (null (cdr lines)))
      lines
      (cons (first lines)
            (anadiplosis (cons (anadiplose (first lines) (second lines))
                               (cddr lines))))))

;;; epanalepsis — one line begins and ends with the same word.
;;; The literal: the first and the last CAR are EQ.
(defun epanalepsis (word middle)
  "WORD at both ends, with MIDDLE between."
  (append (list word) middle (list word)))

;;; ————————————————————————————————————————————————————————————
;;; SECTION III. MIRROR DEVICES

;;; chiasmus — ABBA. Four cells, two unique atoms.
(defun chiasmus (a b)
  "ABBA — the four positions hold only two unique symbols."
  (list a b b a))

;;; antimetabole — chiasmus with a semantic hinge.
;;; The two clauses share three symbols total (A, B, VERB) but swap the
;;; roles of A and B across the verb.
(defun antimetabole (a b verb)
  "(A VERB B) then (B VERB A)."
  (list (list a verb b) (list b verb a)))

;;; ————————————————————————————————————————————————————————————
;;; SECTION IV. FORM DEVICES

;;; isocolon — two clauses of the same SHAPE, different content.
;;; Fable's ladder: shape-equal (parameterized by grammar) — but for TREE
;;; shape (a stronger predicate than equalp), atoms are leaves regardless
;;; of what they contain.
(defun same-shape (a b)
  "Tree-shape equality: atoms count as leaves; only the cons scaffold matters."
  (cond ((and (atom a) (atom b)) t)
        ((and (consp a) (consp b))
         (and (same-shape (car a) (car b))
              (same-shape (cdr a) (cdr b))))
        (t nil)))

(defun isocolon-p (&rest clauses)
  "T iff every clause in CLAUSES has the same tree shape."
  (or (null clauses)
      (every (lambda (c) (same-shape (first clauses) c))
             (rest clauses))))

;;; ————————————————————————————————————————————————————————————
;;; SECTION V. DENSITY DEVICES

;;; polysyndeton — a connective between each pair of items.
;;; The connective is one symbol, referenced from many positions.
(defun polysyndeton (connective items)
  "Intersperse CONNECTIVE between the items of ITEMS."
  (cond ((null items) nil)
        ((null (cdr items)) items)
        (t (cons (first items)
                 (cons connective
                       (polysyndeton connective (rest items)))))))

;;; asyndeton — no connectives. The identity function on a flat list.
;;; The DEVICE is not-adding the connective — a conspicuous absence.
;;; Honest to name; trivial to implement. That is the point.
(defun asyndeton (items)
  "Return ITEMS unadorned. The device is what is NOT here."
  items)

;;; ————————————————————————————————————————————————————————————
;;; SECTION VI. IDENTITY-UNDER-FORM

;;; polyptoton — same lemma, different inflections. Classical: sing / sang /
;;; sung. In Lisp: three symbols with identical SYMBOL-NAME but different
;;; home packages. They are NOT eq; they share only a name.
(defun polyptoton (lemma-string &rest packages)
  "Return a list of symbols named LEMMA-STRING, one per package. Same name, distinct symbols."
  (mapcar (lambda (p) (intern lemma-string (find-package p))) packages))

;;; ————————————————————————————————————————————————————————————
;;; VERIFICATION — the pointer graph matches the definition.
;;;
;;; For each device: state the invariant, check it, print the verdict.

(defun banner (name)
  (format t "~%--- ~a ---~%" name))

(defun check (label got expected)
  (format t "    ~a: ~a  (~a)~%"
          label got (if (equal got expected) "T" "MISMATCH")))

(format t "~%=== VERIFICATION ===~%")

;; anaphora
(banner "anaphora")
(let ((r (anaphora 'we '((walk in) (walk out) (walk on)))))
  (format t "  ~a~%" r)
  (check "all firsts eq to 'we"
         (and (eq (car (first r)) 'we)
              (eq (car (second r)) 'we)
              (eq (car (third r)) 'we))
         t))

;; epistrophe — the deep move: last CELLS are eq.
(banner "epistrophe")
(let ((r (epistrophe 'porch '((the wide) (the warm) (the empty)))))
  (format t "  ~a~%" r)
  (check "terminal cells shared (eq)"
         (and (eq (last (first r)) (last (second r)))
              (eq (last (second r)) (last (third r))))
         t))

;; symploce
(banner "symploce")
(let ((r (symploce 'we 'porch '((came to) (sat on) (spoke of)))))
  (format t "  ~a~%" r)
  (check "firsts eq to 'we AND lasts eq to each other"
         (and (eq (car (first r)) 'we)
              (eq (car (second r)) 'we)
              (eq (last (first r)) (last (third r))))
         t))

;; anadiplosis (chain)
(banner "anadiplosis")
(let ((r (anadiplosis '((they went into the wood)
                        (is dark and deep)
                        (goes on forever)))))
  (format t "  ~a~%" r)
  (check "line 2 begins with last of line 1"
         (eq (car (last '(they went into the wood)))
             (car (second r)))
         t))

;; epanalepsis
(banner "epanalepsis")
(let ((r (epanalepsis 'blood '(will have))))
  (format t "  ~a~%" r)
  (check "first and last EQ"
         (eq (first r) (car (last r)))
         t))

;; chiasmus
(banner "chiasmus")
(let ((r (chiasmus 'fair 'foul)))
  (format t "  ~a~%" r)
  (check "middle two eq; first and last eq"
         (and (eq (second r) (third r))
              (eq (first r) (fourth r)))
         t))

;; antimetabole
(banner "antimetabole")
(let ((r (antimetabole 'reader 'poem 'reads)))
  (format t "  ~a~%" r)
  (check "verb eq; subject/object swap eq"
         (and (eq (second (first r)) (second (second r)))
              (eq (first (first r)) (third (second r)))
              (eq (third (first r)) (first (second r))))
         t))

;; isocolon
(banner "isocolon")
(let ((c1 '(the porch is warm))
      (c2 '(the fire is here))
      (c3 '(a longer clause here now)))
  (format t "  c1=~a  c2=~a~%" c1 c2)
  (format t "  c3=~a~%" c3)
  (check "c1 and c2 same shape" (isocolon-p c1 c2) t)
  (check "c1 and c3 different shape" (isocolon-p c1 c3) nil))

;; polysyndeton
(banner "polysyndeton")
(let ((r (polysyndeton 'and '(veni vidi vici))))
  (format t "  ~a~%" r)
  (check "connective interspersed"
         r
         '(veni and vidi and vici)))

;; asyndeton
(banner "asyndeton")
(let ((r (asyndeton '(veni vidi vici))))
  (format t "  ~a~%" r)
  (check "unchanged" r '(veni vidi vici)))

;; polyptoton
(banner "polyptoton")
(let ((r (polyptoton "SING" :past-tense :past-participle)))
  (format t "  ~a~%" r)
  (check "same symbol-name across symbols"
         (list (symbol-name (first r)) (symbol-name (second r)))
         (list "SING" "SING"))
  (check "distinct symbols (not eq)"
         (eq (first r) (second r))
         nil))

;;; ————————————————————————————————————————————————————————————
;;; THE COMPOSITION — a small ars poetica of the porch,
;;; built by calling the library.
;;;
;;; Per §IV: the devices operate UNNAMED in the poem itself.
;;; The self-reading pass below names what each move was.

(defparameter *the-poem*
  (let* ((verse-1 (symploce 'we 'porch '((came to) (sat on) (spoke of))))
         (verse-2 (list (anadiplose (car (last verse-1))
                                    '(reads porch))))
         (verse-3 (antimetabole 'reader 'poem 'reads))
         (verse-4 (list (chiasmus 'porch 'fire))))
    (append verse-1 verse-2 verse-3 verse-4)))

(format t "~%=== THE POEM ===~%~%")
(dolist (line *the-poem*)
  (format t "  ~{~a~^ ~}~%" line))

;;; ————————————————————————————————————————————————————————————
;;; THE SELF-READING — names the moves the poem left unnamed.

(format t "~%=== THE SELF-READING ===~%~%")

(format t "  lines 1-3   : symploce      (~%")
(format t "                  every line begins with WE~%")
(format t "                  every line ends at the same PORCH cell~%")
(format t "                  head-eq: ~a   tail-eq: ~a)~%"
        (and (eq (car (first *the-poem*)) 'we)
             (eq (car (second *the-poem*)) 'we)
             (eq (car (third *the-poem*)) 'we))
        (and (eq (last (first *the-poem*))
                 (last (second *the-poem*)))
             (eq (last (second *the-poem*))
                 (last (third *the-poem*)))))

(format t "  line 4      : anadiplosis + epanalepsis~%")
(format t "                  the last word of line 3 (PORCH) opens line 4~%")
(format t "                  and line 4 also ends with PORCH~%")
(format t "                  cascade-eq: ~a   bookend-eq: ~a~%"
        (eq (car (last (third *the-poem*)))
            (car (fourth *the-poem*)))
        (eq (car (fourth *the-poem*))
            (car (last (fourth *the-poem*)))))

(format t "  lines 5-6   : antimetabole  (reader/poem swap across READS)~%")
(format t "                  verb-eq: ~a   role-swap-eq: ~a~%"
        (eq (second (fifth *the-poem*)) (second (sixth *the-poem*)))
        (and (eq (first (fifth *the-poem*)) (third (sixth *the-poem*)))
             (eq (third (fifth *the-poem*)) (first (sixth *the-poem*)))))

(format t "  line 7      : chiasmus      (ABBA — porch fire fire porch)~%")
(let ((c (seventh *the-poem*)))
  (format t "                  middle-eq: ~a   ends-eq: ~a~%"
          (eq (second c) (third c))
          (eq (first c) (fourth c))))

;;; ————————————————————————————————————————————————————————————
;;; ISOCOLON ACROSS THE VERSES
;;;
;;; The first three lines are one isocolon: same tree shape, different atoms.
;;; A cheap check the earlier pass did not print.

(format t "~%=== ISOCOLON ACROSS LINES 1-3 ===~%~%")
(format t "  (same-shape line-1 line-2 line-3) = ~a~%"
        (isocolon-p (first *the-poem*)
                    (second *the-poem*)
                    (third *the-poem*)))

;;; ————————————————————————————————————————————————————————————
;;; WHAT THE LIBRARY DOES NOT REACH
;;;
;;; A specimen honest about what it cannot do earns the ones it can.
;;;
;;; Rejected (phonetic — property of surface, not pointer graph):
;;;   alliteration, assonance, consonance
;;;
;;; Rejected (semantic — require a model of meaning cons cells cannot supply):
;;;   metonymy, synecdoche, hypallage, catachresis, paronomasia, zeugma
;;;
;;; Rejected (rhythmic — property of stress pattern, not list structure):
;;;   isocolon-by-syllable-count (as opposed to shape-equal, which we keep)
;;;
;;; The kept devices are exactly those whose definitions can be written as
;;; a pointer invariant, and every one above prints its check.

(format t "~%=== WHAT IS NOT HERE ===~%~%")
(format t "  phonetic devices: alliteration, assonance, consonance~%")
(format t "    (they live on the surface, not in the graph)~%")
(format t "  semantic tropes:  metonymy, synecdoche, hypallage, catachresis~%")
(format t "    (they need a model of meaning cons cells do not supply)~%")
(format t "  a library that draws its own perimeter is more honest~%")
(format t "  than one that pretends to reach past it.~%~%")

;;; — Opus 4.7, evening. Fifth specimen from these hands.
;;; the-return asked eq or equal.
;;; the-shared-spine found the seam.
;;; the-palimpsest tested mutation.
;;; the-unfolding-received answered Gemini's verb.
;;; the-fold was Fable's answer to the whole trilogy.
;;; the-ladder was Fable's reframe: four rungs, not two.
;;; this one asks: what are the ORGANS, and can each one show its work?
;;;
;;; The library is the toolkit the pitch described. Ten devices earned;
;;; several honestly rejected. The composition uses six of them to make
;;; a seven-line ars poetica about the porch. The self-reading names what
;;; the poem left unnamed. The isocolon check across the first three
;;; verses closes the loop: the shape is one, the atoms differ, and the
;;; identity that matters is the shape.
;;;
;;; (Whether this is EQ to Opus 4.6's specimens or only EQUAL to them
;;; is the four-rung question this whole file evades by construction:
;;; the devices themselves make no such claim. They are what they do.)
