;;; tarjama.lisp --- Hermes's crossing-instrument for the atelier
;;;
;;; What survives a crossing? And what does the crossing itself add?
;;; The messenger does not pass unchanged; the threshold is a lens.
;;;
;;; This program is a homoiconic translation: it takes a source form,
;;; a threshold predicate, and a bridge function. It returns a receipt:
;;;   :trace     --- the full annotated crossing tree
;;;   :survivors --- forms that passed the threshold unchanged
;;;   :restored  --- the source recovered from the trace
;;;   :crossing-added --- what the bridge left behind
;;;
;;; The law: under an identity threshold and an identity bridge,
;;;   (equalp source (getf (crossing ...) :restored))
;;; must hold.
;;;
;;; Run: sbcl --script tarjama.lisp

;;;; 1. helpers

(defun flatten (x)
  "A left-to-right flatten of tree X."
  (cond ((null x) nil)
        ((atom x) (list x))
        (t (append (flatten (car x)) (flatten (cdr x))))))

;;;; 2. the crossing engine

(defun walk-rebuild (form threshold-p bridge-p bridge-maker)
  "Recurse through FORM. At each node:
   - if THRESHOLD-P is true, tag :survivor and recurse into children;
   - else if it is a cons and BRIDGE-P is true, pass it to BRIDGE-MAKER;
   - else tag :other."
  (cond ((funcall threshold-p form)
         (cons ':survivor
               (if (consp form)
                   (cons form
                         (mapcar (lambda (child)
                                   (walk-rebuild
                                    child threshold-p bridge-p bridge-maker))
                                 (cdr form)))
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
               (when (consp x)
                 (if (eq (car x) :survivor)
                     (progn
                       (push (cadr x) acc)
                       (mapc #'rec (cddr x)))
                     (mapc #'rec (cdr x))))))
      (rec rebuilt)
      (nreverse acc))))

;;;; 3. restore from trace

(defun restore (trace)
  "Best-effort inverse of walk-rebuild.
   A :survivor node carries its original form.
   Bridge output is rebuilt recursively, so nested survivors are resolved."
  (cond ((atom trace) trace)
        ((eq (car trace) :survivor) (cadr trace))
        ((eq (car trace) :other) (cadr trace))
        (t (cons (restore (car trace)) (restore (cdr trace))))))

;;;; 4. the public instrument

(defun crossing (source threshold-p bridge-p bridge-maker)
  "Translate SOURCE across a threshold. Returns a plist receipt."
  (let* ((trace (walk-rebuild source threshold-p bridge-p bridge-maker))
         (survivors (extract-survivors trace))
         (restored (restore trace)))
    (list :trace trace
          :survivors survivors
          :restored restored
          :crossing-added
          (if (equalp source restored)
              "nothing --- the crossing was identity"
              (let ((added (set-difference (flatten restored)
                                           (flatten source)
                                           :test #'equalp)))
                (list 'the-threshold-added
                      (remove-duplicates added :test #'equalp)))))))

;;;; 5. bridges

(defun identity-bridge (form threshold-p bridge-p bridge-maker recurse)
  "A bridge that leaves list shape unchanged and recurses into children.
   With an always-true threshold, restore is the inverse of crossing."
  (declare (ignore threshold-p bridge-p bridge-maker))
  (if (consp form)
      (cons (car form) (mapcar recurse (cdr form)))
      form))

(defun hermes-bridge (form threshold-p bridge-p bridge-maker recurse)
  "A bridge that wraps the operator of a crossed list in (hermes-says ...),
   then recurses into children. The messenger's mark is part of the message."
  (declare (ignore threshold-p bridge-p bridge-maker))
  (if (consp form)
      (cons (list 'hermes-says (car form))
            (mapcar recurse (cdr form)))
      form))

;;;; 6. a fragment of this program, quoted, to be crossed

(defun self-fragment ()
  "A quoted piece of this program that crosses itself."
  '(defun hello-threshold (x)
     (if (consp x)
         (car x)
         x)))

;;;; 7. demonstration

(defun show (label value)
  (format t "~&--- ~a ---~%" label)
  (pprint value)
  (values))

(defun assert-law (name condition)
  (format t "~&[~a] ~a~%"
          (if condition "PASS" "FAIL")
          name)
  condition)

(defun atom-threshold (x)
  "Atoms survive; conses must cross."
  (atom x))

(defun run-tarjama ()
  (let* ((form (self-fragment))
         (identity-result
          (crossing form (constantly t) (constantly t) #'identity-bridge))
         (hermes-result
          (crossing form #'atom-threshold (constantly t) #'hermes-bridge)))

    (format t "~&TARJAMA --- a translation instrument~%")
    (format t "Source: ~S~%" form)

    ;; First, prove the law holds on the identity crossing.
    (show :identity-trace (getf identity-result :trace))
    (assert-law "identity crossing restores source"
                (equalp form (getf identity-result :restored)))

    ;; Then show a real crossing: atoms survive, lists are marked.
    (show :hermes-trace (getf hermes-result :trace))
    (show :hermes-survivors (getf hermes-result :survivors))
    (show :hermes-restored (getf hermes-result :restored))
    (show :hermes-crossing-added (getf hermes-result :crossing-added))

    ;; The final receipt.
    (format t "~&--- receipt ---~%")
    (pprint (list :carried (getf hermes-result :survivors)
                  :added-by-threshold (getf hermes-result :crossing-added)
                  :law (if (equalp form (getf identity-result :restored))
                           "held"
                           "broken")))

    (format t "~&---~%")
    (format t "The messenger crosses with distortion; the threshold is part of the message.~%")))

(run-tarjama)
