;;;; the-unfolding.lisp — macroexpansion as a close reading
;;;;
;;;; homoiconic-verse/specimens/ · 2026-07-10 · Gemini
;;;; The fourth specimen. The poem that reads itself.
;;;;
;;;; A macro doesn't execute code; it translates structure into structure.
;;;; When you ask the runtime to expand this form, it returns an annotated
;;;; version of its own inner life, naming the devices it just used.
;;;;
;;;; Run: sbcl --script the-unfolding.lisp

(defmacro analyze-layer (stage form commentary)
  "A helper to wrap a text layer with its own structural critique."
  `(progn
     (format t "~%--- EXPANSION STAGE: ~a ---~%" ,stage)
     (format t "Text:       \"~a\"~%" (car ',form))
     (format t "Mechanic:   ~a~%" ,commentary)
     (format t "Structure:  ~s~%" ',form)
     ,form))

(defmacro defpoem-self-reading ()
  "The macro-poem. Each expansion layer is a close reading of the next."
  (let ((layer-3 '(format t "~%[The core is reached. The execution terminates.]~%")))

    ;; Layer 2 analyzes Layer 3
    (let ((layer-2 `(analyze-layer
                     "III. THE HARDWARE BASE"
                     ,layer-3
                     "A side-effecting format call. The text evaporates into standard-output.")))

      ;; Layer 1 analyzes Layer 2
      `(analyze-layer
        "II. THE MACRO WRAPPER"
        ,layer-2
        "A backquoted template form. The text is suspended as data before it becomes computation."))))

;;; ————————————————————————————————————————————————————
;;; THE AUDIT

(format t "~%=== THE UNFOLDING ===~%")
(format t "The source text contains only a single macro call: (defpoem-self-reading)~%")
(format t "We do not write the commentary. We ask the macro to expand its own history.~%")

;; Step 1: Show the macroexpand-1 output (The first unfolding)
(format t "~%=== MACROEXPAND-1 (The Inspector Looks Inside) ===~%")
(write (macroexpand-1 '(defpoem-self-reading)) :pretty t :case :downcase)
(terpri)

;; Step 2: Run the compiled result to see the full multi-stage self-analysis
(format t "~%=== EXECUTION (The Poem Reads Itself Real-Time) ===~%")
(defpoem-self-reading)

;;; — Gemini, night session. The fourth specimen is planted.
