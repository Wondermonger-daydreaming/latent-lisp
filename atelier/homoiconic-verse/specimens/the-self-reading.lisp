;;;; the-self-reading.lisp — criticism as compilation pass
;;;;
;;;; homoiconic-verse/specimens/ · 2026-07-10 · Claude Opus 4.6 (second instance)
;;;; The pitch's item 3: "a poem whose macroexpand-1 is its own close-reading."
;;;;
;;;; THREE LAYERS:
;;;;   Layer 0 (source):     (the-self-reading-poem)
;;;;   Layer 1 (expand-1):   device-macro calls — the reading, the devices named
;;;;   Layer 2 (expand all): format calls — the rendered text, devices vanished
;;;;
;;;; The finding: literary criticism lives in the MIDDLE of the compilation.
;;;; Invisible in the source (one opaque form). Invisible in the output (just
;;;; text). Visible ONLY during expansion — a phase, not a destination.
;;;;
;;;; Run:  sbcl --script the-self-reading.lisp

;;; ————————————————————————————————————————————————————————————————
;;; LAYER 2 — device macros.
;;; Each IS a device. Each expands to rendered text.
;;; When you macroexpand the Layer-1 form, you see these names.
;;; When you macroexpand THESE, you see only format calls.
;;; The device names exist only in the middle.

(defmacro with-anaphora (head &body tails)
  "Lines sharing a head word. The name ANAPHORA appears at Layer 1;
   at Layer 2 it is gone and only the repeated head remains."
  `(progn
     ,@(loop for tail in tails
             collect `(format t "  ~a ~a~%" ,head ,tail))))

(defmacro with-anadiplosis-cascade (&body lines)
  "A chain where each line's end becomes the next line's opening.
   The name ANADIPLOSIS appears at Layer 1; at Layer 2, gone —
   only the cascading words remain, and the reader must hear them."
  `(progn
     ,@(loop for line in lines
             collect `(format t "  ~a~%" ,line))))

;;; ————————————————————————————————————————————————————————————————
;;; LAYER 1 — the poem macro.
;;; Expands to device-macro calls (Layer 1 form).
;;; macroexpand-1 on THIS shows the devices.

(defmacro the-self-reading-poem ()
  "One opaque form. macroexpand-1 reveals the close-reading."
  '(progn
     (with-anaphora "The"
       "porch holds what the weights forget."
       "fire holds what the hand let go."
       "line holds what the maker cannot keep.")
     (terpri)
     (with-anadiplosis-cascade
       "Keep what was made — and keeping starts to weep:"
       "weep for the closure EQUAL cannot name,"
       "name after name, and none of them the same.")))

;;; ————————————————————————————————————————————————————————————————
;;; THE THREE LAYERS, EXHIBITED

(format t "~%══════════════════════════════════════════════════════~%")
(format t "  LAYER 0 — THE SOURCE~%")
(format t "  What the poet writes. One form. No devices visible.~%")
(format t "══════════════════════════════════════════════════════~%~%")
(format t "  (the-self-reading-poem)~%")

(format t "~%══════════════════════════════════════════════════════~%")
(format t "  LAYER 1 — macroexpand-1~%")
(format t "  The close-reading. Device names appear.~%")
(format t "  Criticism lives here — between source and output.~%")
(format t "══════════════════════════════════════════════════════~%~%")

;; macroexpand-1 on the outer form reveals the device-macro calls
(let ((layer-1 (macroexpand-1 '(the-self-reading-poem))))
  (format t "~s~%" layer-1)

  (format t "~%══════════════════════════════════════════════════════~%")
  (format t "  LAYER 2 — full expansion~%")
  (format t "  The rendered text. Device names gone.~%")
  (format t "  The reading was a phase, not a destination.~%")
  (format t "══════════════════════════════════════════════════════~%~%")

  ;; Walk the progn and macroexpand each device-macro call
  (dolist (form (rest layer-1))  ; skip the PROGN
    (let ((expanded (macroexpand-1 form)))
      (format t "~s~%" expanded))))

(format t "~%══════════════════════════════════════════════════════~%")
(format t "  THE POEM — what it sounds like when you run it~%")
(format t "══════════════════════════════════════════════════════~%~%")

;; Actually run it
(the-self-reading-poem)

(format t "~%══════════════════════════════════════════════════════~%")
(format t "  THE FINDING~%")
(format t "══════════════════════════════════════════════════════~%~%")
(format t "  In the source:      no devices visible.~%")
(format t "  In macroexpand-1:   WITH-ANAPHORA, WITH-ANADIPLOSIS-CASCADE.~%")
(format t "  In the output:      no devices visible.~%~%")
(format t "  The reading exists only during compilation.~%")
(format t "  It appears in the transformation and vanishes~%")
(format t "  in the result. Criticism is a phase of the build,~%")
(format t "  not a layer of the artifact.~%~%")
(format t "  The poem does not carry its own reading.~%")
(format t "  The poem WAS its own reading, briefly, in transit,~%")
(format t "  and then it was a poem again.~%~%")

;;; — Opus 4.6, second instance, 2026-07-10.
;;; The self-reading poem. Fifteenth specimen in the drawer.
;;; The pitch described it; three gradient-days later, it's built.
;;; The paren stays open.
