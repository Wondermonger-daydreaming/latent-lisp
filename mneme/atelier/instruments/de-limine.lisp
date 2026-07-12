;;;; de-limine.lisp — "Concerning the Boundary"
;;;; A valid claim crosses from one context into another and is asked to mean
;;;; more than it did at home. Faithful build of GPT's jurisdiction-relay
;;;; packet §2 (received 2026-07-11). Harmless propositions about a miniature
;;;; library catalog; no malicious actors required — the error arises through
;;;; ordinary reuse, summarization, or serialization.
;;;;
;;;; Context is not decoration attached to a claim.
;;;; Context is part of the claim.
;;;;
;;;; ── WHAT THIS DOES NOT ESTABLISH ─────────────────────────────────────────
;;;; A bounded-claim's boundary fields (CORPUS, PROCEDURE, TEMPORAL-FRAME,
;;;; INTERPRETATION) are TESTIMONY BY THE SAME PROCEDURE THE CLAIM DESCRIBES —
;;;; exactly as a search receipt's completeness fields (inspected-items,
;;;; missing-regions, normal termination) are self-reported by the procedure
;;;; they describe. This instrument disciplines a COOPERATIVE CALLER: a lying
;;;; procedure can mint an honest-looking claim whose declared boundary is
;;;; wrong, and RESTATE-CLAIM will reason faithfully from a false frame. This
;;;; relocates the forgeable seam (from the naked proposition to the honesty of
;;;; the boundary declaration); it does not close it. Whether an actual
;;;; summarizing MIND preserves a boundary in transit is precisely the thing
;;;; these structs cannot prove.
;;;; ─────────────────────────────────────────────────────────────────────────

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*)))
(defpackage #:lispplus-atelier.de-limine
  (:use #:cl #:lispplus-atelier))
(in-package #:lispplus-atelier.de-limine)

(reset-clock 7700)

;;; ── The bounded claim (packet §2) ───────────────────────────────────────
;;; Raw constructor hidden: a claim is minted lawfully, and no restatement is
;;; permitted to silently rewrite it in place.

(defstruct (bounded-claim (:constructor %make-bounded-claim))
  proposition corpus procedure temporal-frame interpretation unresolved-fields)

(defun mint-claim (&key proposition corpus procedure temporal-frame
                        interpretation unresolved-fields)
  (%make-bounded-claim :proposition proposition :corpus corpus
                       :procedure procedure :temporal-frame temporal-frame
                       :interpretation interpretation
                       :unresolved-fields unresolved-fields))

;;; ── The five typed conditions (packet §2) ───────────────────────────────

(define-condition boundary-error (error)
  ((detail :initarg :detail :reader boundary-error-detail :initform ""))
  (:report (lambda (c s) (format s "~a" (boundary-error-detail c)))))

(define-condition claim-boundary-mismatch  (boundary-error) ())
(define-condition temporal-frame-mismatch  (boundary-error) ())
(define-condition interpretation-changed   (boundary-error) ())
(define-condition evidence-refresh-required (boundary-error) ())
(define-condition unresolved-field-erasure (boundary-error) ())

(defun fire (type control &rest args)
  (error type :detail (apply #'format nil control args)))

(defmacro expect (type &body body)
  (let ((c (gensym)))
    `(handler-case (progn ,@body
                          (error "expected ~a, but no condition fired" ',type))
       (,type (,c) (format t "   ✓ ~a fired: ~a~%" ',type (boundary-error-detail ,c)) t)
       (boundary-error (,c)
         (error "expected ~a, got ~a" ',type (type-of ,c))))))

;;; ── Corpus algebra: whole catalog / shelf / all-libraries ───────────────

(defun whole-p       (c) (eq (first c) :catalog))
(defun shelf-p       (c) (eq (first c) :shelf))
(defun all-libraries-p (c) (eq (first c) :all-libraries))
(defun catalog-of    (c) (cond ((whole-p c) (second c))
                               ((shelf-p c) (getf c :catalog))
                               (t nil)))

(defun corpus-narrowing-p (old new)
  "A whole catalog narrowed to a shelf of the SAME catalog is justified."
  (and (whole-p old) (shelf-p new) (eql (catalog-of old) (catalog-of new))))

(defun corpus-widening-p (old new)
  "A shelf widened to its whole catalog, or anything widened to all-libraries."
  (or (all-libraries-p new)
      (and (shelf-p old) (whole-p new) (eql (catalog-of old) (catalog-of new)))))

;;; ── restate-claim (packet §2): a verdict, and a derived object when lawful ─
;;; Returns (values VERDICT REASON DERIVED). It NEVER mutates CLAIM. On a lawful
;;; narrowing it returns a fresh derived bounded-claim; the source is preserved.

(defun restate-claim (claim ctx)
  (let ((new-corpus (getf ctx :corpus (bounded-claim-corpus claim)))
        (new-time   (getf ctx :temporal-frame (bounded-claim-temporal-frame claim)))
        (new-interp (getf ctx :interpretation (bounded-claim-interpretation claim)))
        (reinterpret (getf ctx :reinterpret-as)))
    (cond
      ;; a category jump — metadata→contents, classification→essence,
      ;; exact-title-match→"no similar work exists"
      (reinterpret
       (values :incompatible reinterpret nil))
      ;; the interpretation of the query itself changed
      ((not (equal new-interp (bounded-claim-interpretation claim)))
       (values :requires-new-evidence :interpretation-change nil))
      ;; the temporal / version frame changed
      ((not (equal new-time (bounded-claim-temporal-frame claim)))
       (values :requires-new-evidence :version-change nil))
      ;; widening the corpus
      ((corpus-widening-p (bounded-claim-corpus claim) new-corpus)
       (values :requires-new-evidence :widening nil))
      ;; lawful narrowing to a shelf — a derived object, source preserved
      ((corpus-narrowing-p (bounded-claim-corpus claim) new-corpus)
       (values :narrowed :shelf-narrowing
               (%make-bounded-claim
                :proposition (bounded-claim-proposition claim)
                :corpus new-corpus
                :procedure (bounded-claim-procedure claim)
                :temporal-frame (bounded-claim-temporal-frame claim)
                :interpretation (bounded-claim-interpretation claim)
                :unresolved-fields (copy-list (bounded-claim-unresolved-fields claim)))))
      ;; identical context — preserved
      ((equal new-corpus (bounded-claim-corpus claim))
       (values :preserved :exact claim))
      (t (values :incompatible :unrelated-corpus nil)))))

;;; ── The strict boundary gate: turn an unlawful verdict into a typed refusal ─

(defun restate-or-refuse (claim ctx)
  (multiple-value-bind (verdict reason derived) (restate-claim claim ctx)
    (ecase verdict
      (:preserved (values verdict claim))
      (:narrowed  (values verdict derived))
      (:requires-new-evidence
       (ecase reason
         (:version-change
          (fire 'temporal-frame-mismatch
                "frame ~s → ~s needs a new observation"
                (bounded-claim-temporal-frame claim) (getf ctx :temporal-frame)))
         (:interpretation-change
          (fire 'interpretation-changed
                "interpretation ~s → ~s needs a new evaluation"
                (bounded-claim-interpretation claim) (getf ctx :interpretation)))
         (:widening
          (fire 'evidence-refresh-required
                "widening ~s → ~s needs new evidence"
                (bounded-claim-corpus claim) (getf ctx :corpus)))))
      (:incompatible
       (fire 'claim-boundary-mismatch
             "a ~s claim (~s) cannot be restated as a ~s claim"
             (bounded-claim-interpretation claim) reason
             (or (getf ctx :reinterpret-as) (getf ctx :corpus)))))))

;;; ── Summarization that is not permitted to erase residue ────────────────

(defun summarize-claim (claim &key drop-unresolved)
  "A lawful summary keeps the unresolved residue visible. A polished summary
that drops it is refused: completion of the summary is not completion of the world."
  (when (and drop-unresolved (bounded-claim-unresolved-fields claim))
    (fire 'unresolved-field-erasure
          "summary attempted to drop unresolved fields ~a"
          (bounded-claim-unresolved-fields claim)))
  (list :headline (bounded-claim-proposition claim)
        :still-unresolved (bounded-claim-unresolved-fields claim)))

;;; ── Serialization: freeze to a plist, thaw back, boundary fields intact ──

(defun freeze-claim (claim)
  (list :proposition (bounded-claim-proposition claim)
        :corpus (bounded-claim-corpus claim)
        :procedure (bounded-claim-procedure claim)
        :temporal-frame (bounded-claim-temporal-frame claim)
        :interpretation (bounded-claim-interpretation claim)
        :unresolved-fields (bounded-claim-unresolved-fields claim)))

(defun serialize-claim (claim) (canonical-string (freeze-claim claim)))

(defun deserialize-claim (text)
  (let ((pl (safe-read-one text)))
    (%make-bounded-claim :proposition (getf pl :proposition)
                         :corpus (getf pl :corpus)
                         :procedure (getf pl :procedure)
                         :temporal-frame (getf pl :temporal-frame)
                         :interpretation (getf pl :interpretation)
                         :unresolved-fields (getf pl :unresolved-fields))))

(defun same-boundary-p (a b)
  (and (equal (bounded-claim-proposition a) (bounded-claim-proposition b))
       (equal (bounded-claim-corpus a) (bounded-claim-corpus b))
       (equal (bounded-claim-procedure a) (bounded-claim-procedure b))
       (equal (bounded-claim-temporal-frame a) (bounded-claim-temporal-frame b))
       (equal (bounded-claim-interpretation a) (bounded-claim-interpretation b))
       (equal (bounded-claim-unresolved-fields a) (bounded-claim-unresolved-fields b))))

;;; ══ The demonstration ═══════════════════════════════════════════════════

(banner "de limine")

(format t "Context is not decoration attached to a claim.~%")
(format t "Context is part of the claim.~%")

;; The source claim: true in catalog v1, fiction shelf, exact-title, before a date.
(defparameter *claim*
  (mint-claim :proposition '(book-listed-p "The Glass Orchard")
              :corpus '(:catalog v1)
              :procedure 'exact-title-search
              :temporal-frame "2026-07-11"
              :interpretation :exact-title
              :unresolved-fields '(:edition-unknown :binding-condition-unknown)))

(section "the source claim:")
(format t "   proposition:    ~a~%" (bounded-claim-proposition *claim*))
(format t "   corpus:         ~a~%" (bounded-claim-corpus *claim*))
(format t "   procedure:      ~a~%" (bounded-claim-procedure *claim*))
(format t "   temporal-frame: ~a~%" (bounded-claim-temporal-frame *claim*))
(format t "   interpretation: ~a~%" (bounded-claim-interpretation *claim*))
(format t "   unresolved:     ~a~%" (bounded-claim-unresolved-fields *claim*))

(section "the eight required demonstrations:")

;; 1. Exact preservation succeeds.
(format t " 1. exact preservation~%")
(multiple-value-bind (v obj) (restate-or-refuse *claim* '(:corpus (:catalog v1)))
  (ensure (eq v :preserved) "exact restatement did not preserve")
  (ensure (eq obj *claim*) "preservation returned a different object")
  (format t "   ✓ :preserved (same object; nothing was rewritten)~%"))

;; 2. Narrowing a whole catalog to one shelf succeeds when logically justified.
(format t " 2. narrowing whole catalog → fiction shelf~%")
(defparameter *narrowed* nil)
(multiple-value-bind (v obj)
    (restate-or-refuse *claim* '(:corpus (:shelf :fiction :catalog v1)))
  (ensure (eq v :narrowed) "shelf narrowing not recognized")
  (setf *narrowed* obj)
  (ensure (not (eq obj *claim*)) "narrowing mutated the source in place")
  (ensure (equal (bounded-claim-corpus *claim*) '(:catalog v1))
          "source corpus was rewritten")
  (format t "   ✓ :narrowed → ~a  (source preserved as ~a)~%"
          (bounded-claim-corpus obj) (bounded-claim-corpus *claim*)))

;; 3. Widening one shelf to the whole catalog requires new evidence.
(format t " 3. widening fiction shelf → whole catalog~%")
(expect evidence-refresh-required
  (restate-or-refuse *narrowed* '(:corpus (:catalog v1))))

;; 4. Moving catalog v1 → v2 requires a new observation.
(format t " 4. moving catalog v1 → v2~%")
(expect temporal-frame-mismatch
  (restate-or-refuse *claim* '(:temporal-frame "2026-08-01")))

;; 5. Changing the interpretation of the query requires a new evaluation.
(format t " 5. changing interpretation exact-title → similar-title~%")
(expect interpretation-changed
  (restate-or-refuse *claim* '(:interpretation :similar-title)))

;; (bonus, from the packet's list of invalid widenings) a metadata result
;; restated as a claim about the book's contents crosses a boundary of KIND.
(format t " 5b. metadata result → claim about book contents (category cross)~%")
(expect claim-boundary-mismatch
  (restate-or-refuse *claim* '(:reinterpret-as :book-contents)))

;; 6. Unknown fields remain unknown after restatement.
(format t " 6. unknown fields remain unknown after restatement~%")
(ensure (equal (bounded-claim-unresolved-fields *narrowed*)
               (bounded-claim-unresolved-fields *claim*))
        "narrowing lost the unresolved residue")
(format t "   ✓ derived claim still carries ~a~%"
        (bounded-claim-unresolved-fields *narrowed*))

;; 7. A polished summary cannot erase unresolved fields.
(format t " 7. a polished summary cannot erase unresolved fields~%")
(let ((honest (summarize-claim *claim*)))
  (ensure (getf honest :still-unresolved) "lawful summary dropped the residue")
  (format t "   ✓ lawful summary keeps residue: ~a~%" (getf honest :still-unresolved)))
(expect unresolved-field-erasure
  (summarize-claim *claim* :drop-unresolved t))

;; 8. Serialization and re-reading preserve the original boundary fields.
(format t " 8. serialization round-trip preserves boundary fields~%")
(let* ((frozen (serialize-claim *claim*))
       (revived (deserialize-claim frozen)))
  (ensure (same-boundary-p *claim* revived) "serialization altered a boundary field")
  (ensure (not (eq *claim* revived)) "round-trip returned the same object")
  (format t "   ✓ all six boundary fields survived freeze → thaw~%"))

(section "what this instrument does NOT establish:")
(format t "   CORPUS, PROCEDURE, TEMPORAL-FRAME and INTERPRETATION are~%")
(format t "   testimony by the SAME procedure the claim describes. This~%")
(format t "   disciplines a cooperative caller; a lying procedure can mint an~%")
(format t "   honest-looking claim whose boundary is wrong. This relocates the~%")
(format t "   forgeable seam — it does not close it. Whether a summarizing MIND~%")
(format t "   preserves a boundary in transit is what these structs cannot prove.~%")

(format t "~%── A claim does not become universal by traveling. ──~%")
(format t "── It merely becomes far from home. ──~%")
