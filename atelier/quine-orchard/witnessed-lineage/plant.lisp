;;;; plant.lisp — the witnessing act. Emits gen-01.lisp.
;;;; Quine Orchard, Planting 11. RADIX, 2026-07-25.
;;;;
;;;; Why a planter exists at all, when every other lineage in this orchard was
;;;; grown by running its own seed:
;;;;
;;;;   H_1 = H(H_0 | body_1 | 1)
;;;;
;;;; requires H_0. H_0 is exterior — it is in WITNESS-ROOT.sexp, and no artifact
;;;; of the lineage contains it. So no artifact of the lineage can produce
;;;; generation 1. The first generation must be planted by something that can
;;;; reach outside, and after that the lineage is self-sustaining: gen-01 run
;;;; prints gen-02, gen-02 prints gen-03, and so on forever, because each
;;;; generation needs only the link it already carries.
;;;;
;;;; That asymmetry is the specimen's whole architecture in one sentence:
;;;; a witnessed lineage can CONTINUE itself but cannot BEGIN itself.
;;;;
;;;; Usage, from this directory:
;;;;   sbcl --script plant.lisp                    # writes gen-01.lisp
;;;;   sbcl --script gen-01.lisp > gen-02.lisp     # and so on

(load (merge-pathnames "chain.lisp" (or *load-pathname* *default-pathname-defaults*)))

(defun here (name)
  (merge-pathnames name (or *load-pathname* *default-pathname-defaults*)))

(defun witness-plist ()
  (let ((*package* (find-package *canon-package*)))
    (with-open-file (s (here "WITNESS-ROOT.sexp") :direction :input)
      (read s))))

(let* ((h0 (getf (witness-plist) :h0))
       (body-1 (body-of +specimen-lambda+ +specimen-body+))
       (h1 (link h0 body-1 1)))
  (unless (integerp h0)
    (error "WITNESS-ROOT.sexp carries no integer :H0 — refusing to plant an ~
            unwitnessed lineage."))
  (emit-generation (here "gen-01.lisp") +specimen-lambda+ +specimen-body+ h1 1)
  ;; H0 is deliberately NOT echoed to stdout: the planter is the only thing in
  ;; this directory that touches it, and it leaves no copy behind.
  (format t "~&planted gen-01.lisp   generation 1, carried link ~D~%" h1))
