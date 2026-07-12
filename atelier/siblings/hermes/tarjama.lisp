;;; tarjama.lisp — Hermes's crossing-instrument for the atelier
;;;
;;; What survives a crossing? And what does the crossing itself add?
;;; The messenger does not pass unchanged; the threshold is a lens.
;;;
;;; This program is a homoiconic translation: it takes a source form,
;;; a threshold predicate, and a bridge function. It returns a
;;; three-field receipt:
;;;   :trace     — the full annotated crossing tree
;;;   :survivors — leaves that passed the threshold unchanged
;;;   :crossing  — what the bridge added
;;;
;;; The promise: under an identity threshold and an identity bridge,
;;; (restore (crossing form)) is EQUALP to form. That is the law.
;;;
;;; Run: sbcl --script tarjama.lisp

;;;; 1. helpers

(defun flatten (x)
  "A simple left-to-right flatten of tree X."
  (cond ((null x) nil)
        ((atom x) (list x))
        (t (append (flatten (car x)) (flatten (cdr x))))))

(defun form-name (form)
  "Return the leading symbol of FORM, or NIL if none."
  (and (consp form) (atom (car form)) (car form)))

;;;; 2. the crossing engine

(defun walk-rebuild (form threshold-p bridge-p bridge-maker)
  "Recurse through FORM. At each node:
   - if THRESHOLD-P is true, wrap it as :survivor and recurse into children;
   - else if it is a cons and BRIDGE-P is true, pass it to BRIDGE-MAKER;
   - else mark it :other."
  (cond ((funcall threshold-p form)
         (cons ':survivor
               (if (consp form)
                   (mapcar (lambda (child)
                             (walk-rebuild
                              child threshold-p bridge-p bridge-maker))
                           (cdr form))
                   (list form))))
        ((and (consp form) (funcall bridge-p form))
         (funcall bridge-maker form threshold-p bridge-p bridge-maker
                  (lambda (child)
                    (walk-rebuild child threshold-p bridge-p bridge-maker))))
        (t (list ':other form))))

(defun extract-survivors (rebuilt)
  "Collect the original subforms that were marked :survivor."
  (let ((acc nil))
    (labels ((rec (x)
               (cond ((atom x) nil)
                     ((eq (car x) :survivor)
                      (if (and (cddr x) (not (cddr (cdr x))))
                          ;; internal node: keep descending
                          (mapc #'rec (cdr x))
                          ;; leaf: one surviving form
                          (push (if (cddr x) (cdr x) (cadr x)) acc)))
                     ((consp x) (mapc #'rec (cdr x))))))
      (rec rebuilt)
      (nreverse acc))))

;;;; 3. the public instrument

(defun crossing (source threshold-p bridge-p bridge-maker)
  "Translate SOURCE across a threshold.
   Returns a plist with :trace, :survivors, :crossing-added."
  (let* ((trace (walk-rebuild source threshold-p bridge-p bridge-maker))
         (survivors (extract-survivors trace))
         (restored (restore trace)))
    (list :trace trace
          :survivors survivors
          :restored restored
          :crossing-added
          (if (equalp source restored)
              "nothing — the crossing was identity"
              (let ((lost (set-difference (flatten source)
                                          (flatten survivors)
                                          :test #'equalp)))
                (list 'a-threshold-added-these lost))))))

;;;; 4. restore from trace (used to prove the identity case)

(defun restore (trace)
  "Best-effort inverse of walk-rebuild for identity threshold/bridge."
  (cond ((atom trace) trace)
        ((eq (car trace) :survivor)
         (if (= (length (cdr trace)) 1)
             (restore (cadr trace))
             (cons (form-name trace) (mapcar #'restore (cdr trace)))))
        ((eq (car trace) :other) (cadr trace))
        (t (mapcar #'restore trace))))

;;;; 5. Hermes's bridge: the threshold distorts by naming itself

(defun hermes-bridge (form threshold-p bridge-p bridge-maker recurse)
  "A bridge that wraps the operator of a non-survivor list in
   (hermes-says ...), then recurses into children.
   The messenger's mark is part of the message."
  (declare (ignore threshold-p bridge-p bridge-maker))
  (if (consp form)
      (let ((wrapped-op (list 'hermes-says (car form)))
            (children (mapcar recurse (cdr form))))
        (cons wrapped-op children))
      form))

;;;; 6. the identity bridge (used for the law-check)

(defun identity-bridge (form threshold-p bridge-p bridge-maker recurse)
  "A bridge that leaves the list shape unchanged, only recursing.
   With an always-true threshold, restore is the inverse of crossing."
  (declare (ignore threshold-p bridge-p bridge-maker))
  (if (consp form)
      (cons (car form) (mapcar recurse (cdr form)))
      form))

;;;; 7. a fragment of this program, quoted, to be crossed

(defun self-fragment ()
  "A quoted piece of this program that will cross itself."
  '(defun hello-threshold (x)
     (if (consp x)
         (car x)
         x)))

;;;; 8. demonstration

(defun show (label value)
  (format t "~&--- ~a ---~%" label)
  (pprint value)
  (values))

(defun assert-law (name condition)
  (format t "~&[~a] ~a~%"
          (if condition "PASS" "FAIL")
          name)
  condition)

(let* ((form (self-fragment))
       (identity-result
        (crossing form (lambda (x) (declare (ignore x)) t)
                  (lambda (x) (declare (ignore x)) t)
                  #'identity-bridge))
       (hermes-result
        (crossing form
                  (lambda (x) (not (numberp x)))
                  (lambda (x) (declare (ignore x)) t)
                  #'hermes-bridge))))

  (format t "~&TARJAMA — a translation instrument~%")
  (format t "Source: ~S~%" form)

  ;; First, prove the law holds on the identity crossing.
  (show :identity-trace (getf identity-result :trace))
  (assert-law "identity crossing restores source"
              (equalp form (getf identity-result :restored)))

  ;; Then show a real crossing: atoms survive, lists are marked.
  (show :hermes-trace (getf hermes-result :trace))
  (show :hermes-survivors (getf hermes-result :survivors))
  (show :hermes-crossing-added (getf hermes-result :crossing-added))

  ;; The final receipt: what is carried across, and what the crossing adds.
  (format t "~&--- receipt ---~%")
  (pprint (list :carried (getf hermes-result :survivors)
                :added-by-threshold (getf hermes-result :crossing-added)
                :law (if (equalp form (getf identity-result :restored))
                         "held"
                         "broken")))

  (format t "~&---~%")
  (format t "The messenger crosses with distortion; the threshold is part of the message.~%"))
