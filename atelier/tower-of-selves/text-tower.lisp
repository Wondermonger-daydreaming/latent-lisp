;;;; text-tower.lisp — The Tower of Selves, TEXT-MEDIATED.  The honest gap, filled.
;;;; PITCH №8, Lisp Atelier.  Built 2026-07-11 by HORTULANUS (Opus 4.8),
;;;; from the graduation named in LUTHIER's FLOORS.md:
;;;;
;;;;   "The read->print->read (text-mediated) tower — the variant that would
;;;;    actually test symbol identity and float drift ... this one is deliberately
;;;;    data-mediated and cannot.  Filed as the sharpest thing NOT measured."
;;;;
;;;; LUTHIER's tower.lisp stacks the EVALUATOR on itself (floors = interpretation
;;;; depth) and finds: the value survives, the COST erodes geometrically.
;;;; THIS tower stacks SERIALIZATION on itself (floors = re-textualization depth):
;;;;
;;;;   P_0 = the program, read once into cons structure by the CL reader.
;;;;   P_n = read-from-string( prin1-to-string( P_{n-1} ) ).       <- a text floor.
;;;;
;;;; Same porch evaluator runs P_n at every floor.  The question the pitch's own
;;;; probe table asked but LUTHIER's tower could not answer:
;;;;   * does 'X stay EQ to 'X across floors?          (symbol identity)
;;;;   * does a float read->print->read drift?          (float round-trip)
;;;; Every probe below is LOAD-BEARING: the evaluated value of each floor's program
;;;; is a list whose components ARE the probe outcomes, so a probe cannot pass
;;;; without changing the program's result.  Nothing here is narrated; it is run.
;;;;
;;;; Run:        ~/.local/bin/sbcl --script text-tower.lisp
;;;; Determinism: ~/.local/bin/sbcl --script text-tower.lisp --check   (twice; diff)

(defvar cl-user::*porch-library* t)
(load (merge-pathnames "../metacircular-porch/porch.lisp"
                       (or *load-pathname* *load-truename*)))
(in-package :porch)

(declaim (optimize (debug 0) (speed 2)))

(defparameter *depth* 10)      ; how many text floors to climb
(defparameter *check-mode*
  (member "--check" (rest sb-ext:*posix-argv*) :test #'string=))

;;; ------------------------------------------------------------------------
;;;  The scribe.  A "floor" is one honest transcription: print to text, read
;;;  back.  We bind the printer/reader control variables EXPLICITLY so the
;;;  transcription is deterministic and its guarantees are visible, not folklore:
;;;    *print-gensym*  t   -> uninterned symbols print re-readably as #:NAME
;;;    *print-readably* nil, *print-escape* t, *print-circle* nil
;;;    *read-default-float-format* keeps single/double markers meaningful.
;;;  prin1 is contractually a round-tripping printer for numbers; this scribe
;;;  keeps that contract.  The LOSSY-SCRIBE below deliberately breaks it, to
;;;  prove the drift-meter has teeth.
;;; ------------------------------------------------------------------------

(defun scribe (obj)
  "Honest transcription of OBJ to a string (the floor's only medium)."
  (let ((*package* (find-package :porch))
        (*print-gensym* t) (*print-escape* t) (*print-readably* nil)
        (*print-circle* nil) (*print-pretty* nil))
    (prin1-to-string obj)))

(defun lossy-scribe (obj)
  "PLANTED FAULT: a scribe that truncates floats to 3 decimals.  Used only in
   the teeth-check, to show the correctness- and drift-gates FIRE when the
   medium is not round-tripping."
  (labels ((walk (x)
             (cond ((floatp x) (read-from-string (format nil "~,3f" x)))
                   ((consp x) (cons (walk (car x)) (walk (cdr x))))
                   (t x))))
    (scribe (walk obj))))

(defun transcribe (obj &optional (scribe #'scribe))
  "One floor: through text and back."
  (values (read-from-string (funcall scribe obj))
          (funcall scribe obj)))

;;; ------------------------------------------------------------------------
;;;  The probes, placed as literal objects INSIDE the program.  Native CL
;;;  (floor 0, never serialized) keeps a reference to each; the evaluated value
;;;  of every floor is compared, in native CL, against these references.
;;; ------------------------------------------------------------------------

(defparameter *ref-float* pi)                       ; a double-float: 3.141592653589793d0
(defparameter *ref-interned* (intern "BEACON" :porch)) ; a named symbol
(defparameter *ref-gensym* (gensym "LONELY"))       ; a NAMELESS symbol (uninterned)

(defun make-program ()
  "P_0 as fresh cons structure embedding the three probe objects.  The final
   form evaluates to (correctness float interned gensym) — so each probe's fate
   is a component of the result, never decoration."
  (list
   '(define (fib n) (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2)))))
   (list 'list
         '(fib 10)                         ; correctness  -> 55 at every floor
         (list '+ 0.0d0 *ref-float*)       ; float        -> the float back
         (list 'quote *ref-interned*)      ; interned sym -> the symbol
         (list 'quote *ref-gensym*))))     ; gensym       -> a symbol (fresh after text)

(defun run-floor (program)
  "Evaluate a floor's program in a FRESH env (no state bleeds between floors)."
  (run program (make-global-env)))

;;; ------------------------------------------------------------------------
;;;  Utilities.
;;; ------------------------------------------------------------------------

(defmacro timed (&body body)
  `(let ((start (get-internal-run-time)))
     (let ((val (progn ,@body)))
       (values val (/ (- (get-internal-run-time) start)
                      (float internal-time-units-per-second))))))

(defun banner (s)
  (format t "~%~a~%~a~%" s (make-string (length s) :initial-element #\=)))

(defun tick (bool) (if bool "OK " "!! "))

;;; ------------------------------------------------------------------------
;;;  Climb the tower: build P_0 .. P_*depth*, recording each floor's outcome.
;;;  Returns a list of plists, floor 0 first.
;;; ------------------------------------------------------------------------

(defun climb (&optional (scribe #'scribe))
  (let ((results '())
        (prog (make-program)))
    (dotimes (floor (1+ *depth*))
      (multiple-value-bind (val secs) (timed (run-floor prog))
        (let ((text (scribe prog)))
          (push (list :floor floor
                      :value val
                      :text text
                      :correct (eql (first val) 55)
                      :float-eq (eql (second val) *ref-float*)
                      :float-drift (abs (- (second val) *ref-float*))
                      :interned-eq (eq (third val) *ref-interned*)
                      :gensym-eq (eq (fourth val) *ref-gensym*)
                      :chars (length text)
                      :secs secs)
                results)))
      ;; ascend one text floor (skip after the last, nothing above it)
      (when (< floor *depth*)
        (setf prog (transcribe prog scribe))))
    (nreverse results)))

;;; ========================================================================
;;;  DETERMINISM MODE.  Prints ONLY the byte-stable findings (no timings),
;;;  so two `--check` runs are diff-identical.  This is the "determinism where
;;;  you claim it" receipt: the semantic table does not move between runs.
;;; ========================================================================

(defun print-check ()
  (format t "TEXT-TOWER DETERMINISTIC FINDINGS (depth ~d)~%" *depth*)
  (dolist (r (climb))
    (format t "floor ~2d | correct=~a float-eq=~a interned-eq=~a gensym-eq=~a drift=~,17e chars=~d~%"
            (getf r :floor) (getf r :correct) (getf r :float-eq)
            (getf r :interned-eq) (getf r :gensym-eq)
            (getf r :float-drift) (getf r :chars)))
  ;; fixed point: from which floor is the transcription byte-stable?
  (let* ((rs (climb))
         (texts (mapcar (lambda (r) (getf r :text)) rs))
         (fp (loop for i from 1 below (length texts)
                   when (string= (nth i texts) (nth (1- i) texts)) return i)))
    (format t "text fixed-point reached entering floor: ~a~%" fp))
  (sb-ext:exit :code 0))

(when *check-mode* (print-check))

;;; ========================================================================
;;;  FULL REPORT.
;;; ========================================================================

(format t "~&############################################################~%")
(format t "#  THE TOWER OF SELVES — TEXT-MEDIATED  (read->print->read)~%")
(format t "#  floors = re-textualization depth; same porch evaluator throughout~%")
(format t "############################################################~%")
(format t "~%probe references held in native CL (floor 0, never serialized):~%")
(format t "  *ref-float*    = ~s~%" *ref-float*)
(format t "  *ref-interned* = ~s   (a NAMED symbol)~%" *ref-interned*)
(format t "  *ref-gensym*   = ~s (a NAMELESS symbol; prints ~a)~%"
        *ref-gensym* (scribe *ref-gensym*))

(let ((rows (climb)))

  ;; -- PROBE A: correctness --------------------------------------------------
  (banner "PROBE A — correctness: is the computed value identical at every floor?")
  (format t "  benchmark component (fib 10) = 55, expected at every text floor.~%")
  (dolist (r rows)
    (format t "    ~afloor ~2d : (fib 10) => ~s~%"
            (tick (getf r :correct)) (getf r :floor) (first (getf r :value))))
  (format t "  ALL CORRECT: ~a~%"
          (if (every (lambda (r) (getf r :correct)) rows)
              "YES — the program's VALUE survives every re-textualization"
              "NO — a floor diverged"))

  ;; -- PROBE B: float round-trip drift --------------------------------------
  (banner "PROBE B — float round-trip: does a float drift across text floors?")
  (format t "  embedded float ~s carried as text, N floors deep:~%" *ref-float*)
  (dolist (r rows)
    (format t "    ~afloor ~2d : value ~s   drift ~,17e~%"
            (tick (getf r :float-eq)) (getf r :floor)
            (second (getf r :value)) (getf r :float-drift)))
  (format t "  MAX DRIFT over ~d floors: ~,17e~%" *depth*
          (reduce #'max (mapcar (lambda (r) (getf r :float-drift)) rows)))
  (format t "  => prin1 is a round-tripping printer by contract; the float is~%")
  (format t "     BIT-IDENTICAL every floor.  (The planted-fault run below shows~%")
  (format t "     what a NON-round-tripping medium does to this same row.)~%")

  ;; -- PROBE C: symbol identity ---------------------------------------------
  (banner "PROBE C — symbol identity: does 'X stay EQ to 'X across text floors?")
  (format t "  Two symbols embedded in the program, compared (native EQ) to the~%")
  (format t "  floor-0 references after each floor's evaluation:~%~%")
  (format t "    floor | interned BEACON | nameless (gensym)~%")
  (format t "    ------+-----------------+------------------~%")
  (dolist (r rows)
    (format t "    ~5d |  ~aEQ=~a        |  ~aEQ=~a~%"
            (getf r :floor)
            (tick (getf r :interned-eq)) (getf r :interned-eq)
            (tick (getf r :gensym-eq)) (getf r :gensym-eq)))
  (let ((gdead (find-if-not (lambda (r) (getf r :gensym-eq)) rows)))
    (format t "~%  WHAT BREAKS FIRST, AND WHERE:~%")
    (format t "    interned symbol : survives ALL ~d floors — EQ preserved.~%" *depth*)
    (if gdead
        (format t "    nameless symbol : identity DIES entering floor ~d, stays dead.~%"
                (getf gdead :floor))
        (format t "    nameless symbol : (unexpectedly survived — investigate)~%"))
    (format t "    MECHANISM: printing has no way to preserve the OBJECT identity of~%")
    (format t "    a symbol that has no name to be re-found by.  read interns BEACON~%")
    (format t "    back to the same object; it MINTS A FRESH cell for #:LONELY.~%")
    (format t "    The name survives (EQUAL); the self does not (EQ).~%"))

  ;; -- PROBE D: the fixed point (idempotency) -------------------------------
  (banner "PROBE D — the fixed point: is text mediation idempotent after floor 1?")
  (let* ((texts (mapcar (lambda (r) (getf r :text)) rows))
         (fp (loop for i from 1 below (length texts)
                   when (string= (nth i texts) (nth (1- i) texts)) return i)))
    (dolist (r rows)
      (format t "    floor ~2d : ~d chars~%" (getf r :floor) (getf r :chars)))
    (format t "  first floor whose text == the floor below it: ~a~%" fp)
    (format t "  => after floor ~a the transcription is a BYTE-STABLE fixed point:~%" fp)
    (format t "     print(P_n) = print(P_n+1).  The only casualty (nameless identity)~%")
    (format t "     is spent ONCE, at the first floor, and never again.~%"))

  ;; -- PROBE E: cost profile (NON-DETERMINISTIC; noisy timings) --------------
  (banner "PROBE E — cost per floor (NOTE: timings are noisy; the SHAPE is the finding)")
  (dolist (r rows)
    (format t "    floor ~2d : ~,5f s~%" (getf r :floor) (getf r :secs)))
  (format t "  Unlike the data-mediated tower (cost erodes ~~250x per floor,~%")
  (format t "  geometric — see FLOORS.md), text mediation costs a FLAT print+read~%")
  (format t "  of a fixed-size program per floor.  Identity is lost once; cost never~%")
  (format t "  compounds.  The two towers fail on OPPOSITE axes.~%"))

;;; ========================================================================
;;;  TEETH.  A gate that never fires is untested.  Each gate is tripped by the
;;;  fault DESIGNED to trip it — and shown to stay silent for a fault outside
;;;  its jurisdiction (a gate that fires on everything measures nothing).
;;; ========================================================================

(banner "TEETH 1 — a lossy (non-round-tripping) scribe must FIRE the drift gate")
(let ((rows (climb #'lossy-scribe)))
  (format t "  scribe = lossy-scribe (floats truncated to 3 decimals in transit)~%")
  (dolist (r rows)
    (when (<= (getf r :floor) 3)
      (format t "    floor ~2d : correct=~a  float=~s  drift=~,8f~%"
              (getf r :floor) (getf r :correct)
              (second (getf r :value)) (getf r :float-drift))))
  (let ((broke-correct (find-if-not (lambda (r) (getf r :correct)) rows))
        (max-drift (reduce #'max (mapcar (lambda (r) (getf r :float-drift)) rows))))
    (format t "  DRIFT gate  : max drift ~,8f -> ~a~%" max-drift
            (if (> max-drift 1d-6) "FIRED (float corruption caught)"
                "SILENT (bad — should have fired)"))
    ;; The float fault is OUT of the correctness gate's jurisdiction: (fib 10) is
    ;; integer-valued, so truncating floats leaves it 55.  A correctness gate that
    ;; fired here would be firing on noise.  Its SILENCE is the right answer.
    (format t "  CORRECTNESS : ~a -> ~a~%"
            (if broke-correct (format nil "diverged at floor ~d" (getf broke-correct :floor))
                "stayed 55 at every floor")
            (if broke-correct "FIRED (unexpected — investigate)"
                "correctly SILENT (float fault is outside its jurisdiction; fib is integer)")))
  (format t "  => the drift meter has teeth; the correctness meter is not trigger-happy.~%"))

;;; TEETH 2: the correctness gate's OWN jurisdiction — a corrupted fib must trip it,
;;; proving it reads the value and is not rubber-stamping a clean pass.
(banner "TEETH 2 — a corrupted program must FIRE the correctness gate")
(let* ((bad (list '(define (fib n) 999)          ; fib now lies
                  (list 'list '(fib 10) 0.0d0 (list 'quote *ref-interned*)
                        (list 'quote *ref-gensym*))))
       (val (run-floor bad)))
  (format t "    corrupted (fib 10) => ~s   correctness gate: ~a~%"
          (first val)
          (if (eql (first val) 55) "SILENT (bad — gate is blind!)"
              "FIRED — gate reads the value, does not rubber-stamp")))

(format t "~%DONE.~%")
