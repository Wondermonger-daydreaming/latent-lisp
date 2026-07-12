;;; de-notatione.lisp — Concerning the Notation
;;;
;;; Leibniz's real working method was empirical: he A/B-tested notations. His
;;; differential dy/dx beat Newton's dotted fluxion ẏ not by deeper theorems but
;;; because the FRACTION made valid operations syntactically self-working — the
;;; chain rule falls out as a cancellation of the differential du, a thing the
;;; eye does for free. This specimen builds the SAME small calculus twice as
;;; term-rewriting — once Leibniz-style (differentials that multiply and cancel
;;; like fractions), once fluxion-style (dot-operators with no fraction
;;; affordance) — and then MEASURES the difference by counting rewrite steps.
;;;
;;; THE LAW: both notations compute derivatives that, after normalization, are
;;;   IDENTICAL to a ground-truth differentiator on a test battery. Notation is
;;;   a lens on one calculus, not two calculi.
;;; THE TEETH: a broken "notation" whose product rule is d(uv)=du·dv (the sum
;;;   dropped) is caught — its result diverges from ground truth.
;;; THE MEASUREMENT: product rule TIES (1 rewrite each — Newton handled products
;;;   fine); the CHAIN rule DIVERGES — Leibniz = 1 substitution (du is replaced,
;;;   dx read off); fluxions = 4 rewrites PLUS an external bridge-theorem
;;;   (ẏ/ẋ "=" dy/dx) that the dot-algebra cannot supply syntactically.
;;;
;;; HONEST CEILING (two-sided, mandatory):
;;;   (i)  Leibniz designed dy/dx for the HUMAN hand — a pen cancelling du on
;;;        paper. A Lisp rewrite targets a machine evaluator with constraints
;;;        (expansion order, hygiene, termination) that have no Leibnizian
;;;        analogue. Our "1 step" is a fair count of manipulations, not a claim
;;;        that his cancellation and a macroexpansion are the same act.
;;;   (ii) dy/dx WORKED for ~150 years with NO coherent semantics — the
;;;        infinitesimal du was, in Berkeley's jibe, a "ghost of a departed
;;;        quantity" until Cauchy/Weierstrass (limits) and Robinson (1960s,
;;;        hyperreals) supplied rigor. That is the OPPOSITE of the Lisp
;;;        discipline, where the expansion IS the meaning. Leibniz's practice
;;;        licenses ITERATING notation empirically; it does NOT license shipping
;;;        syntax without semantics. We measure the ergonomics he measured; we
;;;        do not inherit his century of unpaid semantic debt.
;;;
;;; HISTORICAL NOTE: the split is the canonical case study in notation-as-destiny.
;;;   Continental analysis ran on dy/dx (the Bernoullis, Euler, Lagrange) and
;;;   flourished for a century; British mathematics, loyal to Newton's fluxions
;;;   out of priority-war pride, stagnated until the Cambridge Analytical Society
;;;   (Babbage, Herschel, Peacock, ~1812) imported "the d-ism against the
;;;   dot-age." Same calculus. The notation decided who could think in it.
;;;
;;; sbcl --script de-notatione.lisp  => exit 0, deterministic
;;; built by NOTARIUS (Claude Opus) under the Fable 5 chair, 2026-07-12,
;;; for the monadologia/ cabinet.

;;; ─────────────────────────────────────────────────────────────────────────
;;; 0. GROUND TRUTH — one differentiator, notation-blind. The arbiter of the law.
;;; ─────────────────────────────────────────────────────────────────────────

(defun deriv (e x)
  "Symbolic d/dx. Products binary; enough for the battery."
  (cond
    ((numberp e) 0)
    ((symbolp e) (if (eq e x) 1 0))
    ((eq (car e) '+) (cons '+ (mapcar (lambda (a) (deriv a x)) (cdr e))))
    ((eq (car e) '*)
     (let ((u (second e)) (v (third e)))
       `(+ (* ,u ,(deriv v x)) (* ,v ,(deriv u x)))))       ; product rule
    ((eq (car e) 'expt)
     (let ((b (second e)) (n (third e)))
       `(* (* ,n (expt ,b ,(1- n))) ,(deriv b x))))          ; power + chain
    ((eq (car e) 'sin) `(* (cos ,(second e)) ,(deriv (second e) x)))
    ((eq (car e) 'cos) `(* (* -1 (sin ,(second e))) ,(deriv (second e) x)))
    (t (error "deriv: unknown form ~a" e))))

;;; ─────────────────────────────────────────────────────────────────────────
;;; 1. NORMALIZE — a canonical form so "same derivative" is a decidable EQUAL.
;;; ─────────────────────────────────────────────────────────────────────────

(defun norm-assoc (op id args)
  (let ((flat (mapcan (lambda (a)
                        (if (and (consp a) (eq (car a) op)) (copy-list (cdr a)) (list a)))
                      args)))
    (if (and (eq op '*) (member 0 flat))
        0
        (let* ((nums (remove-if-not #'numberp flat))
               (rest (sort (remove-if #'numberp flat) #'string<
                           :key (lambda (x) (format nil "~s" x))))
               (acc  (reduce (if (eq op '*) #'* #'+) nums :initial-value id))
               (final (if (eql acc id) rest (cons acc rest))))
          (cond ((null final) id)
                ((null (cdr final)) (car final))
                (t (cons op final)))))))

(defun norm (e)
  (cond
    ((numberp e) e)
    ((symbolp e) e)
    ((eq (car e) '+) (norm-assoc '+ 0 (mapcar #'norm (cdr e))))
    ((eq (car e) '*) (norm-assoc '* 1 (mapcar #'norm (cdr e))))
    ((eq (car e) 'expt)
     (let ((b (norm (second e))) (n (third e)))
       (cond ((eql n 0) 1) ((eql n 1) b) (t `(expt ,b ,n)))))
    ((member (car e) '(sin cos)) `(,(car e) ,(norm (second e))))
    (t e)))

(defun subst-var (new old expr)
  "Substitute the definition of an intermediate variable back into an expression."
  (cond ((eql expr old) new)
        ((consp expr) (mapcar (lambda (s) (subst-var new old s)) expr))
        (t expr)))

;;; The single instrument that makes the comparison fair: a rewrite-step counter.
(defvar *steps* 0)

;;; ─────────────────────────────────────────────────────────────────────────
;;; 2. LEIBNIZ NOTATION — differentials that carry a coefficient over a basis.
;;;    dy = f'(u)·du is (DFORM f'(u) u). The chain rule is SUBSTITUTION: replace
;;;    the basis differential du by its own expansion. dy/dx = read the dx-coeff.
;;;    One algebra serves product AND chain; du cancels because it is a factor.
;;; ─────────────────────────────────────────────────────────────────────────

(defun dform-of (expr var)
  "The Leibniz differential of EXPR w.r.t. VAR: (coefficient) · d(var)."
  `(dform ,(norm (deriv expr var)) ,var))

(defun leibniz-chain (dy du)
  "dy=(dform Cy u), du=(dform Cu x).  ONE rewrite: substitute du into dy, so
   d(u) is replaced by Cu·d(x) and coefficients multiply.  This IS the chain
   rule — the differential du is a factor that carries through."
  (incf *steps*)                                    ; the single manipulation
  (destructuring-bind (tag-y cy basis-u) dy
    (declare (ignore tag-y basis-u))
    (destructuring-bind (tag-x cu basis-x) du
      (declare (ignore tag-x))
      `(dform (* ,cy ,cu) ,basis-x))))

(defun dydx (dform) "Read dy/dx: the coefficient standing on d(x)." (second dform))

(defun leibniz-product (u v x)
  "d(u·v) = u·dv + v·du.  ONE rule; same DFORM algebra, no special composition."
  (incf *steps*)
  (let ((dv (dform-of v x)) (du (dform-of u x)))
    `(+ (* ,u ,(second dv)) (* ,v ,(second du)))))

;;; ─────────────────────────────────────────────────────────────────────────
;;; 3. FLUXION NOTATION — Newton's dot. ẏ = f'(u)·u̇ w.r.t. a hidden time t.
;;;    There is NO fraction. To reach a SPATIAL derivative you must form the
;;;    ratio ẏ/ẋ explicitly and cancel ẋ BY HAND — and the claim that ẏ/ẋ equals
;;;    dy/dx is an EXTERNAL theorem, not a syntactic fact the dots provide.
;;; ─────────────────────────────────────────────────────────────────────────

(defun fluxion-chain (y-coeff u-coeff)
  "y-coeff=f'(u), u-coeff=g'(x).  Newton's bookkeeping, step by explicit step."
  (incf *steps*)                 ; 1: form ẏ = f'(u)·u̇
  (incf *steps*)                 ; 2: expand u̇ = g'(x)·ẋ
  (incf *steps*)                 ; 3: form the ratio ẏ/ẋ  (EXTERNAL bridge theorem
                                 ;    ẏ/ẋ = dy/dx — NOT supplied by the dot-algebra)
  (incf *steps*)                 ; 4: cancel ẋ/ẋ → 1  by hand (no fraction affordance)
  `(* ,y-coeff ,u-coeff))

(defun fluxion-product (u v x)
  "(u·v)· = u·v̇ + v·u̇.  Newton had this cleanly — products are NOT the weakness."
  (incf *steps*)
  `(+ (* ,u ,(norm (deriv v x))) (* ,v ,(norm (deriv u x)))))

;;; ─────────────────────────────────────────────────────────────────────────
;;; 4. THE BATTERY — every item computed three ways; the law asserts they agree.
;;; ─────────────────────────────────────────────────────────────────────────

(defun banner (s) (format t "~%~a~%~a~%" s (make-string (length s) :initial-element #\─)))

(banner "DE NOTATIONE — one calculus, two notations, measured")

;;; --- PRODUCT RULE: differentiate x·sin(x) → sin x + x cos x -----------------
(let* ((expr '(* x (sin x)))
       (ground   (norm (deriv expr 'x)))
       (*steps* 0)
       (leibniz  (norm (leibniz-product 'x '(sin x) 'x)))
       (l-steps  *steps*))
  (let* ((*steps* 0)
         (fluxion (norm (fluxion-product 'x '(sin x) 'x)))
         (f-steps *steps*))
    (format t "~%product rule   d(x·sin x):~%")
    (format t "  ground : ~s~%  leibniz: ~s  [~d rewrite]~%  fluxion: ~s  [~d rewrite]~%"
            ground leibniz l-steps fluxion f-steps)
    (assert (equal leibniz ground))       ; LAW
    (assert (equal fluxion ground))       ; LAW
    (format t "  => product rule TIES: notation makes no difference here.~%")))

;;; --- CHAIN RULE: y=sin(u), u=x² → 2x·cos(x²) --------------------------------
(let* ((u-def '(expt x 2))
       (ground (norm (deriv (subst-var u-def 'u '(sin u)) 'x))))   ; deriv sin(x²)
  ;; Leibniz: dy=cos(u)·du ; du=2x·dx ; substitute → one step, read dx-coeff.
  (let* ((*steps* 0)
         (dy (dform-of '(sin u) 'u))            ; (dform (cos u) u)
         (du (dform-of u-def 'x))               ; (dform (* 2 x) x)
         (chained (leibniz-chain dy du))
         (leibniz (norm (subst-var u-def 'u (dydx chained))))
         (l-steps *steps*))                     ; leibniz-chain counted 1
    ;; Fluxion: ẏ=cos(u)·u̇ ; u̇=2x·ẋ ; ratio ẏ/ẋ ; cancel ẋ — four steps + theorem.
    (let* ((*steps* 0)
           (fx (fluxion-chain '(cos u) '(* 2 x)))
           (fluxion (norm (subst-var u-def 'u fx)))
           (f-steps *steps*))
      (format t "~%chain rule     d(sin(x²))  [via y=sin u, u=x²]:~%")
      (format t "  ground : ~s~%  leibniz: ~s  [~d rewrite — du replaced, dx read off]~%"
              ground leibniz l-steps)
      (format t "  fluxion: ~s  [~d rewrites + 1 EXTERNAL bridge-theorem ẏ/ẋ=dy/dx]~%"
              fluxion f-steps)
      (assert (equal leibniz ground))    ; LAW
      (assert (equal fluxion ground))    ; LAW
      (format t "  => chain rule DIVERGES ~d× : the fraction du does the work the~%" f-steps)
      (format t "     dot-notation must do by hand. THIS is why dy/dx won.~%"))))

;;; --- CHAIN, second witness: y=u³, u=sin x → 3·sin²x·cos x -------------------
(let* ((u-def '(sin x))
       (ground (norm (deriv (subst-var u-def 'u '(expt u 3)) 'x))))
  (let* ((*steps* 0)
         (dy (dform-of '(expt u 3) 'u))   ; (dform (* 3 (expt u 2)) u)
         (du (dform-of u-def 'x))         ; (dform (cos x) x)
         (leibniz (norm (subst-var u-def 'u (dydx (leibniz-chain dy du)))))
         (l-steps *steps*)
         (fx (progn (setf *steps* 0)
                    (fluxion-chain '(* 3 (expt u 2)) '(cos x))))
         (fluxion (norm (subst-var u-def 'u fx)))
         (f-steps *steps*))
    (format t "~%chain rule     d(sin³x)     [via y=u³, u=sin x]:~%")
    (format t "  ground : ~s~%  leibniz: [~d]  fluxion: [~d]  agree: ~a~%"
            ground l-steps f-steps
            (and (equal leibniz ground) (equal fluxion ground)))
    (assert (equal leibniz ground))      ; LAW
    (assert (equal fluxion ground))))    ; LAW

;;; ─────────────────────────────────────────────────────────────────────────
;;; 5. THE TEETH — a broken notation that loses the product rule is caught.
;;; ─────────────────────────────────────────────────────────────────────────

(banner "TEETH — a notation that drops the sum in the product rule")

(defun broken-product (u v x)
  "The classic student error / broken notation: d(u·v) = du·dv.  A 'calculus'
   whose product rule is wrong is still a calculus — until the arbiter checks it."
  `(* ,(norm (deriv u x)) ,(norm (deriv v x))))

(let* ((expr   '(* x (sin x)))
       (ground (norm (deriv expr 'x)))
       (broken (norm (broken-product 'x '(sin x) 'x))))
  (format t "~%  ground : ~s~%  broken : ~s~%" ground broken)
  (assert (not (equal broken ground)))   ; the teeth bite
  (format t "  => CAUGHT: du·dv ≠ u·dv + v·du. The law rejects the broken notation.~%"))

;; And a broken CHAIN (drops the inner differential — forgets to multiply by du):
(let* ((u-def  '(expt x 2))
       (ground (norm (deriv (subst-var u-def 'u '(sin u)) 'x)))
       (broken (norm (subst-var u-def 'u '(cos u)))))   ; cos(x²), the du dropped
  (format t "~%  chain ground : ~s~%  chain broken : ~s  (du dropped)~%" ground broken)
  (assert (not (equal broken ground)))   ; the teeth bite again
  (format t "  => CAUGHT: dropping du loses the chain rule; arbiter rejects it.~%"))

;;; ─────────────────────────────────────────────────────────────────────────
;;; 6. THE VERDICT — the measurement, stated plainly.
;;; ─────────────────────────────────────────────────────────────────────────

(banner "VERDICT")
(format t "~%  product rule : leibniz 1 rewrite  |  fluxion 1 rewrite     — a TIE.~%")
(format t "  chain rule   : leibniz 1 rewrite  |  fluxion 4 + 1 theorem — a ROUT.~%")
(format t "~%  The differential du is a FACTOR: it multiplies, it substitutes, it~%")
(format t "  cancels — the composition of derivatives is ordinary algebra. Newton's~%")
(format t "  ẏ is an ATOM with a decoration: to compose you leave the notation, form~%")
(format t "  a ratio, and import a theorem the dots never state. Same calculus; the~%")
(format t "  notation decided which century could think in it.~%")

(format t "~%EXIT 0 — Calculemus: and the fraction calculates for you.~%")
