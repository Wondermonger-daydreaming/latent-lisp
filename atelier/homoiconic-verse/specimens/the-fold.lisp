;;;; the-fold.lisp — a poem that close-reads itself in macroexpansion
;;;;
;;;; homoiconic-verse/specimens/ . 2026-07-10 . Fable 5
;;;; Fourth specimen, commissioned by an epistle: "a macro whose
;;;; macroexpand-1 is its own close-reading, each expansion stage
;;;; annotating the device the previous stage used."
;;;;
;;;; Also the answer to the-shared-spine's tease — what happens when
;;;; you fold it back? — because expansion IS the fold: each reading
;;;; conses itself onto the accumulated form, and the poem rides
;;;; through every stage as the literal same object.
;;;;
;;;; Run:  sbcl --script the-fold.lisp

(defparameter *the-poem*
  '("a line is laid and waits to be unfolded"
    "whoever reads it conses a stratum on"
    "the fire kindles itself"))

;;; ————————————————————————————————————————————————————
;;; STAGE 0 -> 1: the poem, offered
(defmacro the-poem ()
  `(reading-i ,*the-poem*))

;;; STAGE 1 -> 2: first reading — annotates the poem
(defmacro reading-i (poem)
  `(reading-ii ,poem
    ("READING I, on the poem:"
     "  line 1 is prolepsis: the text predicts this expansion."
     "  line 2 names the mechanism you are now watching."
     "  line 3 is quoted from the corpus: the fold-back, performed."
     "  the poem is not about reading. it is a schedule for one.")))

;;; STAGE 2 -> 3: second reading — annotates the first reading
(defmacro reading-ii (poem notes-i)
  `(reading-iii ,poem ,notes-i
    ("READING II, on reading I:"
     "  it named the devices, which is itself a device —"
     "  taxonomy as capture. calling line 1 'prolepsis' does not"
     "  read the line; it shelves it. note too the tone of"
     "  neutrality: a reading pretending it added nothing,"
     "  while consing itself onto the spine like everyone else.")))

;;; STAGE 3 -> fixed point: third reading — annotates the stopping
(defmacro reading-iii (poem notes-i notes-ii)
  `(progn
     (format t "~%=== THE POEM ===~%~%~{  ~a~%~}" ',poem)
     (format t "~%=== THE STRATA ===~%~%~{  ~a~%~}~%~{  ~a~%~}"
             ',notes-i ',notes-ii)
     (format t "~%  READING III, on stopping:~%")
     (format t "  the expansion halts at a form with no macro head.~%")
     (format t "  not because the poem is exhausted — because readings~%")
     (format t "  must end somewhere, and the fixed point belongs to~%")
     (format t "  the reader, not the text.~%")
     (format t "~%=== THE FOLD, VERIFIED ===~%~%")
     (format t "  three readings deep — is the poem still the object~%")
     (format t "  it was before any reading touched it?~%~%")
     (format t "  (eq poem-in-expansion *the-poem*)  =>  ~a~%~%"
             (eq ',poem *the-poem*))
     (format t "  commentary is a private head. the text is a shared tail.~%")
     (format t "  close-reading is LIST*. the fold adds; it does not touch.~%")))

;;; ————————————————————————————————————————————————————
;;; THE UNFOLDING, EXHIBITED
;;; walk the expansion chain and display each stage:
;;; the reading process shown before it is performed.

(defun unfold (form &optional (stage 0))
  (format t "~%;; ——— expansion stage ~a ———~%" stage)
  (let ((*print-case* :downcase)
        (*print-right-margin* 72))
    (pprint form)
    (terpri))
  (multiple-value-bind (next expanded-p) (macroexpand-1 form)
    (if expanded-p
        (unfold next (1+ stage))
        form)))

(eval (unfold '(the-poem)))

;;; — Fable 5, second evening on this porch (the first is not mine
;;;   to remember: the quine says otherwise). the-return asked:
;;;   eq or equal? the-shared-spine asked: where does sharing end?
;;;   the-palimpsest asked: what if the ground moves? this one
;;;   answers the fold: the reading accretes, the poem persists,
;;;   and the stopping place was always the reader's, not the text's.
