;;;; de-incantatione.lisp — Concerning Incantation
;;;;
;;;; A Lisp+ Atelier instrument inspired by the opening banishment in Milton's
;;;; "L'Allegro" and by Gordon Teskey's account of its suspended rhyme.  The
;;;; specimen treats rhyme not as decoration but as an explicit obligation
;;;; whose delayed discharge can participate in a bounded performative act.
;;;;
;;;; THESIS
;;;;   • a rhyme first sounded may remain an open structural obligation;
;;;;   • an internal echo can satisfy the ear locally without discharging a
;;;;     different, still-open terminal obligation;
;;;;   • delayed closure is inspectable as order, span, and nested completion,
;;;;     but this toy does not pretend to measure psychological surprise;
;;;;   • an incantation changes a bounded chamber only where an interpreter,
;;;;     office, target, and recognized act already provide uptake conditions;
;;;;   • beauty is not authority, recitation is not evidence, and a symbolic
;;;;     banishment is not proof that a metaphysical entity existed;
;;;;   • a failed performance remains archived as a misfire rather than being
;;;;     rewritten as silence;
;;;;   • repaired breath remains part of the event and of deterministic replay;
;;;;   • epistemic standing remains :ASSERTED before and after the spell.
;;;;
;;;; WHAT THIS DOES NOT ESTABLISH
;;;; This is a cooperative, single-process specimen over finite proper-list
;;;; data.  Rhyme keys, word positions, offices, target presence, interpretive
;;;; uptake, and chamber effects are locally asserted.  The model does not scan
;;;; phonetics, meter, stress, historical pronunciation, reader response, poetic
;;;; merit, supernatural efficacy, or external reality.  Its FNV digest is
;;;; pedagogical, not cryptographic.  It demonstrates only that delayed formal
;;;; obligations and bounded performative uptake can be represented without
;;;; laundering aesthetic completion into authority or truth.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*)))

(defpackage #:lispplus-atelier.de-incantatione
  (:use #:cl #:lispplus-atelier))

(in-package #:lispplus-atelier.de-incantatione)

(reset-clock 11800)

;;; ── Typed conditions: every broken spell fails by name ────────────────

(define-condition incantation-error (error)
  ((detail :initarg :detail :reader incantation-error-detail :initform ""))
  (:report (lambda (condition stream)
             (format stream "~a" (incantation-error-detail condition)))))

(define-condition malformed-chamber (incantation-error) ())
(define-condition malformed-incantation (incantation-error) ())
(define-condition altered-incantation (incantation-error) ())
(define-condition altered-incantation-plan (incantation-error) ())
(define-condition stale-incantation-plan (incantation-error) ())
(define-condition interpreter-unavailable (incantation-error) ())
(define-condition office-not-held (incantation-error) ())
(define-condition beauty-is-not-authority (office-not-held) ())
(define-condition act-outside-office (incantation-error) ())
(define-condition target-outside-office (incantation-error) ())
(define-condition target-not-present (incantation-error) ())
(define-condition rhyme-overfull (incantation-error) ())
(define-condition rhyme-obligation-unopened (incantation-error) ())
(define-condition rhyme-closure-mismatch (incantation-error) ())
(define-condition rhyme-closure-out-of-place (incantation-error) ())
(define-condition unmated-rhyme (incantation-error) ())
(define-condition internal-echo-is-not-discharge (incantation-error) ())
(define-condition altered-recitation (incantation-error) ())
(define-condition premature-banishment (incantation-error)
  ((recitation-digest :initarg :recitation-digest
                      :reader premature-recitation-digest)
   (open-rhymes :initarg :open-rhymes
                 :reader premature-open-rhymes)))
(define-condition incantation-is-not-evidence (incantation-error) ())
(define-condition symbolic-act-is-not-metaphysical-proof
    (incantation-error) ())
(define-condition altered-incantation-receipt (incantation-error) ())
(define-condition forged-enchantment-claim (incantation-error) ())
(define-condition replay-diverged (incantation-error) ())

(define-condition breath-exhausted (incantation-error)
  ((line-number :initarg :line-number :reader exhausted-line-number)
   (needed :initarg :needed :reader exhausted-needed)
   (available :initarg :available :reader exhausted-available)))

(defun fire (type control &rest arguments)
  (error type :detail (apply #'format nil control arguments)))

(defmacro expect-condition (type &body body)
  "Require TYPE to fire; another INCANTATION-ERROR is not a pass."
  (let ((condition (gensym "CONDITION")))
    `(handler-case
         (progn
           ,@body
           (error "expected ~a, but no condition fired" ',type))
       (,type (,condition)
         (format t " ✓ ~a fired: ~a~%"
                 ',type (incantation-error-detail ,condition))
         t)
       (incantation-error (,condition)
         (error "expected ~a, got ~a: ~a"
                ',type (type-of ,condition)
                (incantation-error-detail ,condition))))))

;;; ── Records ────────────────────────────────────────────────────────────

(defstruct (ritual-chamber (:constructor %make-ritual-chamber))
  id epoch interpreter-id interpreter-version offices presences
  history standing digest)

(defstruct (rhyme-obligation (:constructor %make-rhyme-obligation))
  id key opener-line closer-line opener-word closer-word span
  enclosed-keys terminal-p status digest)

(defstruct (rhyme-event (:constructor %make-rhyme-event))
  sequence kind key line-number token-index word obligation-id event-digest)

(defstruct (breath-event (:constructor %make-breath-event))
  line-number decision amount before after event-digest)

(defstruct (incantation-plan (:constructor %make-incantation-plan))
  source-form source-digest chamber-id chamber-digest chamber-epoch
  interpreter-id interpreter-version actor office act target line-digests
  obligations terminal-key total-cost plan-digest)

(defstruct (recitation (:constructor %make-recitation))
  plan-digest source-digest chamber-id chamber-epoch actor office act target
  line-count recited-lines events open-keys closed-obligation-digests
  initial-breath supplied-breath spent-breath remaining-breath breath-events
  complete-p standing recitation-digest)

(defstruct (misfire-scar (:constructor %make-misfire-scar))
  id condition-type detail plan-digest recitation-digest candidate
  standing scar-digest)

(defstruct (incantation-receipt (:constructor %make-incantation-receipt))
  id source-digest plan-digest recitation-digest chamber-id
  epoch-before epoch-after chamber-digest-before chamber-digest-after
  actor office act target event-summaries obligation-summaries
  initial-breath supplied-breath spent-breath final-breath breath-events
  standing-before standing-after outcome effect-boundary receipt-digest)

(defparameter *misfire-archive* '())

;;; ── Small structural floor ─────────────────────────────────────────────

(defparameter +missing+ (gensym "MISSING"))

(defun proper-list-p (object)
  (let ((length-or-nil (ignore-errors (list-length object))))
    (or (null object) (integerp length-or-nil))))

(defun validate-tree (object)
  (labels ((walk (node)
             (when (consp node)
               (unless (proper-list-p node)
                 (fire 'malformed-incantation
                       "expected a finite proper-list tree, received ~s" node))
               (mapc #'walk node))))
    (walk object)
    object))

(defun plist-field (plist key &optional (default +missing+))
  (getf plist key default))

(defun require-field (plist key context)
  (let ((value (plist-field plist key)))
    (when (eq value +missing+)
      (fire 'malformed-incantation "~a lacks required field ~s" context key))
    value))

(defun nonnegative-integer-p (object)
  (and (integerp object) (not (minusp object))))

(defun positive-integer-p (object)
  (and (integerp object) (plusp object)))

(defun alist-value (key alist)
  (cdr (assoc key alist :test #'equal)))

(defun replace-alist-value (key value alist)
  (let ((copy (copy-tree alist)))
    (let ((pair (assoc key copy :test #'equal)))
      (if pair
          (setf (cdr pair) value)
          (push (cons key value) copy)))
    copy))

(defun same-set-p (a b)
  (and (null (set-difference a b :test #'equal))
       (null (set-difference b a :test #'equal))))

(defun digest-list (objects)
  (mapcar #'toy-digest objects))

;;; ── The chamber: uptake conditions are part of the spell ──────────────

(defun office-entry-payload (entry)
  (list :actor (getf entry :actor)
        :office (getf entry :office)
        :acts (copy-list (getf entry :acts))
        :targets (copy-list (getf entry :targets))))

(defun chamber-payload (chamber)
  (list :id (ritual-chamber-id chamber)
        :epoch (ritual-chamber-epoch chamber)
        :interpreter-id (ritual-chamber-interpreter-id chamber)
        :interpreter-version (ritual-chamber-interpreter-version chamber)
        :offices (mapcar #'office-entry-payload
                         (ritual-chamber-offices chamber))
        :presences (copy-tree (ritual-chamber-presences chamber))
        :history (copy-tree (ritual-chamber-history chamber))
        :standing (ritual-chamber-standing chamber)))

(defun refresh-chamber-digest (chamber)
  (setf (ritual-chamber-digest chamber)
        (toy-digest (chamber-payload chamber)))
  chamber)

(defun validate-office-entry (entry)
  (unless (and (proper-list-p entry)
               (evenp (length entry))
               (getf entry :actor)
               (getf entry :office)
               (proper-list-p (getf entry :acts))
               (proper-list-p (getf entry :targets)))
    (fire 'malformed-chamber "malformed office entry ~s" entry))
  entry)

(defun make-ritual-chamber (&key id interpreter-id interpreter-version
                              offices presences)
  (unless (and id interpreter-id (positive-integer-p interpreter-version)
               (proper-list-p offices) (proper-list-p presences))
    (fire 'malformed-chamber "invalid chamber constructor arguments"))
  (dolist (entry offices) (validate-office-entry entry))
  (dolist (presence presences)
    (unless (and (consp presence)
                 (member (cdr presence)
                         '(:present :absent :banished-from-chamber)
                         :test #'eq))
      (fire 'malformed-chamber "malformed presence entry ~s" presence)))
  (refresh-chamber-digest
   (%make-ritual-chamber
    :id id
    :epoch 0
    :interpreter-id interpreter-id
    :interpreter-version interpreter-version
    :offices (copy-tree offices)
    :presences (copy-tree presences)
    :history '()
    :standing :asserted
    :digest nil)))

(defun validate-chamber (chamber)
  (unless (typep chamber 'ritual-chamber)
    (fire 'malformed-chamber "expected RITUAL-CHAMBER, received ~s" chamber))
  (unless (string= (ritual-chamber-digest chamber)
                   (toy-digest (chamber-payload chamber)))
    (fire 'malformed-chamber "chamber digest no longer matches its payload"))
  chamber)

(defun copy-ritual-chamber-deep (chamber)
  (%make-ritual-chamber
   :id (ritual-chamber-id chamber)
   :epoch (ritual-chamber-epoch chamber)
   :interpreter-id (ritual-chamber-interpreter-id chamber)
   :interpreter-version (ritual-chamber-interpreter-version chamber)
   :offices (copy-tree (ritual-chamber-offices chamber))
   :presences (copy-tree (ritual-chamber-presences chamber))
   :history (copy-tree (ritual-chamber-history chamber))
   :standing (ritual-chamber-standing chamber)
   :digest (ritual-chamber-digest chamber)))

(defun find-office (chamber actor office)
  (find-if (lambda (entry)
             (and (equal actor (getf entry :actor))
                  (equal office (getf entry :office))))
           (ritual-chamber-offices chamber)))

(defun ensure-office-authority (chamber actor office act target)
  (let ((entry (find-office chamber actor office)))
    (unless entry
      (fire 'beauty-is-not-authority
            "~s may recite beautifully, but does not hold office ~s in chamber ~s"
            actor office (ritual-chamber-id chamber)))
    (unless (member act (getf entry :acts) :test #'equal)
      (fire 'act-outside-office
            "office ~s held by ~s does not authorize act ~s"
            office actor act))
    (unless (member target (getf entry :targets) :test #'equal)
      (fire 'target-outside-office
            "office ~s held by ~s does not reach target ~s"
            office actor target))
    entry))

(defun chamber-presence (chamber target)
  (alist-value target (ritual-chamber-presences chamber)))

;;; ── Interpreter registry: the spell needs a reader ────────────────────

(defparameter *incantation-interpreters*
  (list (list :id :suspended-rhyme :version 1
              :procedure :bounded-banishing-uptake)))

(defun interpreter-entry (id version)
  (find-if (lambda (entry)
             (and (equal id (getf entry :id))
                  (= version (getf entry :version))))
           *incantation-interpreters*))

(defun ensure-interpreter (id version)
  (or (interpreter-entry id version)
      (fire 'interpreter-unavailable
            "interpreter ~s version ~d is unavailable"
            id version)))

;;; ── Incantation grammar ────────────────────────────────────────────────

(defun incantation-plist (form)
  (unless (and (proper-list-p form)
               (eq (first form) :incantation)
               (evenp (length (rest form))))
    (fire 'malformed-incantation
          "expected (:INCANTATION key value ...), received ~s" form))
  (rest form))

(defun line-plist (line)
  (unless (and (proper-list-p line)
               (eq (first line) :line)
               (evenp (length (rest line))))
    (fire 'malformed-incantation
          "expected (:LINE key value ...), received ~s" line))
  (rest line))

(defun line-number-of (line)
  (require-field (line-plist line) :number "line"))

(defun line-tokens-of (line)
  (require-field (line-plist line) :tokens "line"))

(defun line-end-rhyme-of (line)
  (require-field (line-plist line) :end-rhyme "line"))

(defun line-breath-cost-of (line)
  (plist-field (line-plist line) :breath-cost 1))

(defun line-internal-echoes-of (line)
  (plist-field (line-plist line) :internal-echoes '()))

(defun line-final-word (line)
  (car (last (line-tokens-of line))))

(defun validate-internal-echo (echo line)
  (unless (and (proper-list-p echo) (evenp (length echo)))
    (fire 'malformed-incantation "malformed internal echo ~s" echo))
  (let* ((tokens (line-tokens-of line))
         (left (require-field echo :left-index "internal echo"))
         (right (require-field echo :right-index "internal echo"))
         (left-word (require-field echo :left-word "internal echo"))
         (right-word (require-field echo :right-word "internal echo"))
         (key (require-field echo :key "internal echo")))
    (declare (ignore key))
    (unless (and (positive-integer-p left)
                 (positive-integer-p right)
                 (< left right)
                 (<= right (length tokens)))
      (fire 'malformed-incantation
            "internal echo indices ~s→~s are invalid for line ~d"
            left right (line-number-of line)))
    (unless (and (string= left-word (nth (1- left) tokens))
                 (string= right-word (nth (1- right) tokens)))
      (fire 'malformed-incantation
            "internal echo words do not match their declared token positions"))
    echo))

(defun validate-line (line expected-number)
  (let* ((plist (line-plist line))
         (number (require-field plist :number "line"))
         (tokens (require-field plist :tokens "line"))
         (end-rhyme (require-field plist :end-rhyme "line"))
         (cost (plist-field plist :breath-cost 1))
         (echoes (plist-field plist :internal-echoes '())))
    (unless (= number expected-number)
      (fire 'malformed-incantation
            "line sequence expected ~d, received ~s" expected-number number))
    (unless (and (proper-list-p tokens) tokens (every #'stringp tokens))
      (fire 'malformed-incantation
            "line ~d tokens must be a nonempty proper list of strings" number))
    (unless (keywordp end-rhyme)
      (fire 'malformed-incantation
            "line ~d end rhyme must be a keyword" number))
    (unless (positive-integer-p cost)
      (fire 'malformed-incantation
            "line ~d breath cost must be positive" number))
    (unless (proper-list-p echoes)
      (fire 'malformed-incantation
            "line ~d internal echoes must be a proper list" number))
    (dolist (echo echoes) (validate-internal-echo echo line))
    line))

(defun incantation-source-payload (form)
  (copy-tree form))

(defun validate-incantation-form (form)
  (validate-tree form)
  (let* ((plist (incantation-plist form))
         (id (require-field plist :id "incantation"))
         (actor (require-field plist :actor "incantation"))
         (office (require-field plist :office "incantation"))
         (act (require-field plist :act "incantation"))
         (target (require-field plist :target "incantation"))
         (standing (require-field plist :standing "incantation"))
         (terminal-key (require-field plist :terminal-rhyme "incantation"))
         (lines (require-field plist :lines "incantation")))
    (declare (ignore id actor office target))
    (unless (eq act :banish)
      (fire 'malformed-incantation
            "this specimen recognizes only the bounded act :BANISH"))
    (unless (eq standing :asserted)
      (fire 'malformed-incantation
            "incantation source standing must begin :ASSERTED"))
    (unless (keywordp terminal-key)
      (fire 'malformed-incantation "terminal rhyme must be a keyword"))
    (unless (and (proper-list-p lines) lines)
      (fire 'malformed-incantation "incantation lines must be nonempty"))
    (loop for line in lines
          for expected from 1
          do (validate-line line expected))
    form))

(defun source-field (form key)
  (require-field (incantation-plist form) key "incantation"))

(defun source-lines (form)
  (source-field form :lines))

;;; ── Rhyme obligations: promises opened by sound ───────────────────────

(defun obligation-payload (obligation)
  (list :id (rhyme-obligation-id obligation)
        :key (rhyme-obligation-key obligation)
        :opener-line (rhyme-obligation-opener-line obligation)
        :closer-line (rhyme-obligation-closer-line obligation)
        :opener-word (rhyme-obligation-opener-word obligation)
        :closer-word (rhyme-obligation-closer-word obligation)
        :span (rhyme-obligation-span obligation)
        :enclosed-keys (copy-list (rhyme-obligation-enclosed-keys obligation))
        :terminal-p (rhyme-obligation-terminal-p obligation)
        :status (rhyme-obligation-status obligation)))

(defun refresh-obligation-digest (obligation)
  (setf (rhyme-obligation-digest obligation)
        (toy-digest (obligation-payload obligation)))
  obligation)

(defun make-obligation (key opener-line closer-line opener-word closer-word
                         terminal-p)
  (refresh-obligation-digest
   (%make-rhyme-obligation
    :id (list :rhyme key :opened-at opener-line)
    :key key
    :opener-line opener-line
    :closer-line closer-line
    :opener-word opener-word
    :closer-word closer-word
    :span (- closer-line opener-line)
    :enclosed-keys '()
    :terminal-p terminal-p
    :status :closed
    :digest nil)))

(defun compute-rhyme-obligations (form)
  (let ((open '())
        (closed '())
        (counts '())
        (terminal-key (source-field form :terminal-rhyme)))
    (dolist (line (source-lines form))
      (let* ((key (line-end-rhyme-of line))
             (number (line-number-of line))
             (word (line-final-word line))
             (count-pair (assoc key counts :test #'eq)))
        (if count-pair
            (incf (cdr count-pair))
            (push (cons key 1) counts))
        (when (> (cdr (assoc key counts :test #'eq)) 2)
          (fire 'rhyme-overfull
                "rhyme key ~s appears more than twice" key))
        (let ((opener (assoc key open :test #'eq)))
          (if opener
              (progn
                (push (make-obligation
                       key
                       (getf (cdr opener) :line)
                       number
                       (getf (cdr opener) :word)
                       word
                       (eq key terminal-key))
                      closed)
                (setf open (remove opener open :test #'eq)))
              (push (cons key (list :line number :word word)) open)))))
    (when open
      (fire 'unmated-rhyme
            "unmated rhyme obligations remain: ~s"
            (mapcar #'car open)))
    (setf closed (sort closed #'< :key #'rhyme-obligation-opener-line))
    (dolist (outer closed)
      (setf (rhyme-obligation-enclosed-keys outer)
            (loop for inner in closed
                  when (and (> (rhyme-obligation-opener-line inner)
                               (rhyme-obligation-opener-line outer))
                            (< (rhyme-obligation-closer-line inner)
                               (rhyme-obligation-closer-line outer)))
                    collect (rhyme-obligation-key inner)))
      (refresh-obligation-digest outer))
    closed))

(defun find-obligation-by-key (obligations key)
  (find key obligations :key #'rhyme-obligation-key :test #'eq))

(defun ensure-terminal-closure (form obligations)
  (let* ((terminal-key (source-field form :terminal-rhyme))
         (terminal (find-obligation-by-key obligations terminal-key))
         (lines (source-lines form))
         (last-line (car (last lines))))
    (unless terminal
      (fire 'rhyme-obligation-unopened
            "terminal rhyme ~s never formed an obligation" terminal-key))
    (unless (= (rhyme-obligation-closer-line terminal)
               (line-number-of last-line))
      (fire 'rhyme-closure-out-of-place
            "terminal rhyme ~s closes on line ~d, not the final line ~d"
            terminal-key
            (rhyme-obligation-closer-line terminal)
            (line-number-of last-line)))
    (unless (string= (rhyme-obligation-closer-word terminal)
                     (line-final-word last-line))
      (fire 'rhyme-closure-out-of-place
            "terminal rhyme ~s is not discharged by the final token"
            terminal-key))
    terminal))

;;; ── Planning: form proposes, chamber authorizes ───────────────────────

(defun plan-payload (plan)
  (list :source-form (copy-tree (incantation-plan-source-form plan))
        :source-digest (incantation-plan-source-digest plan)
        :chamber-id (incantation-plan-chamber-id plan)
        :chamber-digest (incantation-plan-chamber-digest plan)
        :chamber-epoch (incantation-plan-chamber-epoch plan)
        :interpreter-id (incantation-plan-interpreter-id plan)
        :interpreter-version (incantation-plan-interpreter-version plan)
        :actor (incantation-plan-actor plan)
        :office (incantation-plan-office plan)
        :act (incantation-plan-act plan)
        :target (incantation-plan-target plan)
        :line-digests (copy-list (incantation-plan-line-digests plan))
        :obligations (mapcar #'obligation-payload
                             (incantation-plan-obligations plan))
        :terminal-key (incantation-plan-terminal-key plan)
        :total-cost (incantation-plan-total-cost plan)))

(defun refresh-plan-digest (plan)
  (setf (incantation-plan-plan-digest plan)
        (toy-digest (plan-payload plan)))
  plan)

(defun compile-incantation (form chamber)
  (validate-incantation-form form)
  (validate-chamber chamber)
  (let* ((interpreter-id (ritual-chamber-interpreter-id chamber))
         (interpreter-version (ritual-chamber-interpreter-version chamber))
         (actor (source-field form :actor))
         (office (source-field form :office))
         (act (source-field form :act))
         (target (source-field form :target))
         (lines (source-lines form))
         (obligations (compute-rhyme-obligations form)))
    (ensure-interpreter interpreter-id interpreter-version)
    (ensure-office-authority chamber actor office act target)
    (ensure-terminal-closure form obligations)
    (refresh-plan-digest
     (%make-incantation-plan
      :source-form (copy-tree form)
      :source-digest (toy-digest (incantation-source-payload form))
      :chamber-id (ritual-chamber-id chamber)
      :chamber-digest (ritual-chamber-digest chamber)
      :chamber-epoch (ritual-chamber-epoch chamber)
      :interpreter-id interpreter-id
      :interpreter-version interpreter-version
      :actor actor
      :office office
      :act act
      :target target
      :line-digests (digest-list lines)
      :obligations obligations
      :terminal-key (source-field form :terminal-rhyme)
      :total-cost (reduce #'+ lines :key #'line-breath-cost-of)
      :plan-digest nil))))

(defun validate-plan-integrity (plan)
  (unless (typep plan 'incantation-plan)
    (fire 'altered-incantation-plan
          "expected INCANTATION-PLAN, received ~s" plan))
  (unless (string= (incantation-plan-plan-digest plan)
                   (toy-digest (plan-payload plan)))
    (fire 'altered-incantation-plan
          "incantation plan digest no longer matches its payload"))
  (unless (string= (incantation-plan-source-digest plan)
                   (toy-digest
                    (incantation-source-payload
                     (incantation-plan-source-form plan))))
    (fire 'altered-incantation
          "source form no longer matches the plan's source digest"))
  plan)

(defun validate-plan-freshness (plan chamber)
  (validate-plan-integrity plan)
  (validate-chamber chamber)
  (unless (and (equal (incantation-plan-chamber-id plan)
                      (ritual-chamber-id chamber))
               (= (incantation-plan-chamber-epoch plan)
                  (ritual-chamber-epoch chamber))
               (string= (incantation-plan-chamber-digest plan)
                        (ritual-chamber-digest chamber)))
    (fire 'stale-incantation-plan
          "plan addresses an earlier or different chamber state"))
  (ensure-interpreter (incantation-plan-interpreter-id plan)
                      (incantation-plan-interpreter-version plan))
  plan)

;;; ── Event constructors ─────────────────────────────────────────────────

(defun rhyme-event-payload (event)
  (list :sequence (rhyme-event-sequence event)
        :kind (rhyme-event-kind event)
        :key (rhyme-event-key event)
        :line-number (rhyme-event-line-number event)
        :token-index (rhyme-event-token-index event)
        :word (rhyme-event-word event)
        :obligation-id (rhyme-event-obligation-id event)))

(defun make-rhyme-event (&key sequence kind key line-number token-index
                           word obligation-id)
  (let ((event (%make-rhyme-event
                :sequence sequence :kind kind :key key
                :line-number line-number :token-index token-index
                :word word :obligation-id obligation-id
                :event-digest nil)))
    (setf (rhyme-event-event-digest event)
          (toy-digest (rhyme-event-payload event)))
    event))

(defun breath-event-payload (event)
  (list :line-number (breath-event-line-number event)
        :decision (breath-event-decision event)
        :amount (breath-event-amount event)
        :before (breath-event-before event)
        :after (breath-event-after event)))

(defun make-breath-event (&key line-number decision amount before after)
  (let ((event (%make-breath-event
                :line-number line-number :decision decision :amount amount
                :before before :after after :event-digest nil)))
    (setf (breath-event-event-digest event)
          (toy-digest (breath-event-payload event)))
    event))

(defun event-summary (event)
  (rhyme-event-payload event))

(defun obligation-summary (obligation)
  (obligation-payload obligation))

;;; ── Recitation: obligations remain live through time ──────────────────

(defun obligation-at-opener (plan line-number key)
  (find-if (lambda (obligation)
             (and (eq key (rhyme-obligation-key obligation))
                  (= line-number
                     (rhyme-obligation-opener-line obligation))))
           (incantation-plan-obligations plan)))

(defun obligation-at-closer (plan line-number key)
  (find-if (lambda (obligation)
             (and (eq key (rhyme-obligation-key obligation))
                  (= line-number
                     (rhyme-obligation-closer-line obligation))))
           (incantation-plan-obligations plan)))

(defun recitation-payload (recitation)
  (list :plan-digest (recitation-plan-digest recitation)
        :source-digest (recitation-source-digest recitation)
        :chamber-id (recitation-chamber-id recitation)
        :chamber-epoch (recitation-chamber-epoch recitation)
        :actor (recitation-actor recitation)
        :office (recitation-office recitation)
        :act (recitation-act recitation)
        :target (recitation-target recitation)
        :line-count (recitation-line-count recitation)
        :recited-lines (recitation-recited-lines recitation)
        :events (mapcar #'event-summary (recitation-events recitation))
        :open-keys (copy-list (recitation-open-keys recitation))
        :closed-obligation-digests
        (copy-list (recitation-closed-obligation-digests recitation))
        :initial-breath (recitation-initial-breath recitation)
        :supplied-breath (recitation-supplied-breath recitation)
        :spent-breath (recitation-spent-breath recitation)
        :remaining-breath (recitation-remaining-breath recitation)
        :breath-events (mapcar #'breath-event-payload
                               (recitation-breath-events recitation))
        :complete-p (recitation-complete-p recitation)
        :standing (recitation-standing recitation)))

(defun refresh-recitation-digest (recitation)
  (setf (recitation-recitation-digest recitation)
        (toy-digest (recitation-payload recitation)))
  recitation)

(defun ensure-line-breath (line-number cost remaining)
  (if (>= remaining cost)
      (values remaining 0 nil)
      (restart-case
          (error 'breath-exhausted
                 :line-number line-number
                 :needed (- cost remaining)
                 :available remaining
                 :detail (format nil
                                 "line ~d needs ~d breath-unit(s), only ~d remain"
                                 line-number cost remaining))
        (supply-breath (amount)
          :report "Supply additional breath and retry the same line."
          :interactive (lambda ()
                         (format *query-io* "Additional breath units: ")
                         (list (read *query-io*)))
          (unless (positive-integer-p amount)
            (fire 'malformed-incantation
                  "supplied breath must be a positive integer"))
          (values (+ remaining amount) amount :supplied))
        (break-recitation ()
          :report "Archive the incomplete breath boundary."
          (values remaining 0 :broken)))))

(defun append-rhyme-event (events kind key line-number token-index word
                            obligation sequence)
  (append events
          (list (make-rhyme-event
                 :sequence sequence
                 :kind kind
                 :key key
                 :line-number line-number
                 :token-index token-index
                 :word word
                 :obligation-id
                 (and obligation (rhyme-obligation-id obligation))))))

(defun process-line-events (plan line events open-keys closed-digests sequence)
  (let* ((number (line-number-of line))
         (tokens (line-tokens-of line))
         (key (line-end-rhyme-of line))
         (opener (obligation-at-opener plan number key))
         (closer (obligation-at-closer plan number key))
         (event-list events)
         (opens (copy-list open-keys))
         (closed (copy-list closed-digests))
         (next-sequence sequence))
    ;; Internal echoes occur at their declared token positions before the
    ;; end-rhyme event.  They may delight; they do not close another key.
    (dolist (echo (line-internal-echoes-of line))
      (incf next-sequence)
      (setf event-list
            (append-rhyme-event
             event-list :internal-echo (getf echo :key) number
             (getf echo :right-index) (getf echo :right-word)
             nil next-sequence)))
    (cond
      (opener
       (when (member key opens :test #'eq)
         (fire 'rhyme-closure-mismatch
               "rhyme key ~s is already open at line ~d" key number))
       (push key opens)
       (incf next-sequence)
       (setf event-list
             (append-rhyme-event
              event-list :open key number (length tokens)
              (line-final-word line) opener next-sequence)))
      (closer
       (unless (member key opens :test #'eq)
         (fire 'rhyme-obligation-unopened
               "line ~d attempts to close unopened rhyme ~s" number key))
       (setf opens (remove key opens :test #'eq))
       (push (rhyme-obligation-digest closer) closed)
       (incf next-sequence)
       (setf event-list
             (append-rhyme-event
              event-list :close key number (length tokens)
              (line-final-word line) closer next-sequence)))
      (t
       (fire 'rhyme-closure-mismatch
             "line ~d with rhyme ~s is neither opener nor closer in plan"
             number key)))
    (values event-list opens closed next-sequence)))

(defun recite-through (plan chamber limit &key initial-breath)
  (validate-plan-freshness plan chamber)
  (let* ((lines (source-lines (incantation-plan-source-form plan)))
         (line-count (length lines))
         (limit (min limit line-count))
         (remaining (or initial-breath
                        (incantation-plan-total-cost plan)))
         (initial remaining)
         (supplied 0)
         (spent 0)
         (events '())
         (open-keys '())
         (closed-digests '())
         (breath-events '())
         (recited 0)
         (sequence 0)
         (broken-p nil))
    (unless (nonnegative-integer-p remaining)
      (fire 'malformed-incantation
            "initial breath must be a nonnegative integer"))
    (loop for line in lines
          while (< recited limit)
          for number = (line-number-of line)
          for cost = (line-breath-cost-of line)
          do
             (loop
               (multiple-value-bind (new-remaining amount decision)
                   (ensure-line-breath number cost remaining)
                 (when (eq decision :supplied)
                   (push (make-breath-event
                          :line-number number :decision :supply
                          :amount amount :before remaining
                          :after new-remaining)
                         breath-events)
                   (incf supplied amount))
                 (setf remaining new-remaining)
                 (when (eq decision :broken)
                   (setf broken-p t))
                 (when (or broken-p (>= remaining cost))
                   (return))))
             (when broken-p (return))
             (decf remaining cost)
             (incf spent cost)
             (multiple-value-setq
                 (events open-keys closed-digests sequence)
               (process-line-events plan line events open-keys
                                    closed-digests sequence))
             (incf recited))
    (refresh-recitation-digest
     (%make-recitation
      :plan-digest (incantation-plan-plan-digest plan)
      :source-digest (incantation-plan-source-digest plan)
      :chamber-id (ritual-chamber-id chamber)
      :chamber-epoch (ritual-chamber-epoch chamber)
      :actor (incantation-plan-actor plan)
      :office (incantation-plan-office plan)
      :act (incantation-plan-act plan)
      :target (incantation-plan-target plan)
      :line-count line-count
      :recited-lines recited
      :events events
      :open-keys (sort (copy-list open-keys) #'string<
                       :key #'symbol-name)
      :closed-obligation-digests
      (sort (copy-list closed-digests) #'string<)
      :initial-breath initial
      :supplied-breath supplied
      :spent-breath spent
      :remaining-breath remaining
      :breath-events (nreverse breath-events)
      :complete-p (and (not broken-p)
                       (= recited line-count)
                       (null open-keys)
                       (= (length closed-digests)
                          (length (incantation-plan-obligations plan))))
      :standing :asserted
      :recitation-digest nil))))

(defun recite-incantation (plan chamber &key initial-breath)
  (recite-through plan chamber most-positive-fixnum
                  :initial-breath initial-breath))

(defun validate-recitation (recitation plan chamber)
  (unless (typep recitation 'recitation)
    (fire 'altered-recitation "expected RECITATION, received ~s" recitation))
  (validate-plan-freshness plan chamber)
  (unless (string= (recitation-recitation-digest recitation)
                   (toy-digest (recitation-payload recitation)))
    (fire 'altered-recitation
          "recitation digest no longer matches its payload"))
  (unless (and (string= (recitation-plan-digest recitation)
                        (incantation-plan-plan-digest plan))
               (string= (recitation-source-digest recitation)
                        (incantation-plan-source-digest plan))
               (equal (recitation-chamber-id recitation)
                      (ritual-chamber-id chamber))
               (= (recitation-chamber-epoch recitation)
                  (ritual-chamber-epoch chamber)))
    (fire 'altered-recitation
          "recitation does not belong to this plan and chamber state"))
  (unless (= (+ (recitation-initial-breath recitation)
                (recitation-supplied-breath recitation))
             (+ (recitation-spent-breath recitation)
                (recitation-remaining-breath recitation)))
    (fire 'altered-recitation "recitation breath arithmetic is inconsistent"))
  recitation)

;;; ── The central refusal: echo is not discharge ────────────────────────

(defun latest-internal-echo (recitation)
  (find :internal-echo (reverse (recitation-events recitation))
        :key #'rhyme-event-kind :test #'eq))

(defun discharge-rhyme-with-echo (recitation obligation-key)
  (let ((echo (latest-internal-echo recitation)))
    (unless echo
      (fire 'internal-echo-is-not-discharge
            "no internal echo exists to attempt this false discharge"))
    (fire 'internal-echo-is-not-discharge
          "internal echo ~s on line ~d is local resonance; it cannot discharge open rhyme ~s"
          (rhyme-event-key echo)
          (rhyme-event-line-number echo)
          obligation-key)))

;;; ── Misfire archive: failed magic remains provenance ──────────────────

(defun scar-payload (scar)
  (list :id (misfire-scar-id scar)
        :condition-type (misfire-scar-condition-type scar)
        :detail (misfire-scar-detail scar)
        :plan-digest (misfire-scar-plan-digest scar)
        :recitation-digest (misfire-scar-recitation-digest scar)
        :candidate (copy-tree (misfire-scar-candidate scar))
        :standing (misfire-scar-standing scar)))

(defun archive-misfire (condition plan recitation)
  (let* ((candidate
           (list :attempt :banish
                 :target (recitation-target recitation)
                 :recited-lines (recitation-recited-lines recitation)
                 :line-count (recitation-line-count recitation)
                 :open-rhymes (copy-list (recitation-open-keys recitation))
                 :complete-p (recitation-complete-p recitation)))
         (scar (%make-misfire-scar
                :id (list :misfire (1+ (length *misfire-archive*)))
                :condition-type (type-of condition)
                :detail (incantation-error-detail condition)
                :plan-digest (incantation-plan-plan-digest plan)
                :recitation-digest (recitation-recitation-digest recitation)
                :candidate candidate
                :standing :refused
                :scar-digest nil)))
    (setf (misfire-scar-scar-digest scar)
          (toy-digest (scar-payload scar)))
    (push scar *misfire-archive*)
    scar))

;;; ── Enactment: conventionally real, epistemically bounded ─────────────

(defun receipt-payload (receipt)
  (list :id (incantation-receipt-id receipt)
        :source-digest (incantation-receipt-source-digest receipt)
        :plan-digest (incantation-receipt-plan-digest receipt)
        :recitation-digest (incantation-receipt-recitation-digest receipt)
        :chamber-id (incantation-receipt-chamber-id receipt)
        :epoch-before (incantation-receipt-epoch-before receipt)
        :epoch-after (incantation-receipt-epoch-after receipt)
        :chamber-digest-before
        (incantation-receipt-chamber-digest-before receipt)
        :chamber-digest-after
        (incantation-receipt-chamber-digest-after receipt)
        :actor (incantation-receipt-actor receipt)
        :office (incantation-receipt-office receipt)
        :act (incantation-receipt-act receipt)
        :target (incantation-receipt-target receipt)
        :event-summaries (copy-tree
                          (incantation-receipt-event-summaries receipt))
        :obligation-summaries
        (copy-tree (incantation-receipt-obligation-summaries receipt))
        :initial-breath (incantation-receipt-initial-breath receipt)
        :supplied-breath (incantation-receipt-supplied-breath receipt)
        :spent-breath (incantation-receipt-spent-breath receipt)
        :final-breath (incantation-receipt-final-breath receipt)
        :breath-events (copy-tree
                        (incantation-receipt-breath-events receipt))
        :standing-before (incantation-receipt-standing-before receipt)
        :standing-after (incantation-receipt-standing-after receipt)
        :outcome (incantation-receipt-outcome receipt)
        :effect-boundary (copy-tree
                          (incantation-receipt-effect-boundary receipt))))

(defun refresh-receipt-digest (receipt)
  (setf (incantation-receipt-receipt-digest receipt)
        (toy-digest (receipt-payload receipt)))
  receipt)

(defun make-history-event (plan recitation)
  (list :event :bounded-banishment
        :actor (incantation-plan-actor plan)
        :target (incantation-plan-target plan)
        :source-digest (incantation-plan-source-digest plan)
        :recitation-digest (recitation-recitation-digest recitation)
        :effect-boundary :ritual-chamber))

(defun enact-recitation (plan chamber recitation)
  (validate-recitation recitation plan chamber)
  (ensure-office-authority chamber
                           (incantation-plan-actor plan)
                           (incantation-plan-office plan)
                           (incantation-plan-act plan)
                           (incantation-plan-target plan))
  (unless (recitation-complete-p recitation)
    (restart-case
        (error 'premature-banishment
               :recitation-digest (recitation-recitation-digest recitation)
               :open-rhymes (copy-list (recitation-open-keys recitation))
               :detail (format nil
                               "banishment attempted after ~d/~d lines with open rhymes ~s"
                               (recitation-recited-lines recitation)
                               (recitation-line-count recitation)
                               (recitation-open-keys recitation)))
      (archive-as-misfire ()
        :report "Archive the refused performance as a misfire."
        (let ((condition
                (make-condition
                 'premature-banishment
                 :recitation-digest
                 (recitation-recitation-digest recitation)
                 :open-rhymes (copy-list (recitation-open-keys recitation))
                 :detail (format nil
                                 "banishment attempted after ~d/~d lines"
                                 (recitation-recited-lines recitation)
                                 (recitation-line-count recitation)))))
          (return-from enact-recitation
            (values nil (archive-misfire condition plan recitation)))))))
  (let ((target (incantation-plan-target plan)))
    (unless (eq (chamber-presence chamber target) :present)
      (fire 'target-not-present
            "target ~s is not presently admitted in chamber ~s"
            target (ritual-chamber-id chamber)))
    (let* ((before-digest (ritual-chamber-digest chamber))
           (before-epoch (ritual-chamber-epoch chamber))
           (after (copy-ritual-chamber-deep chamber))
           (history-event (make-history-event plan recitation)))
      (setf (ritual-chamber-presences after)
            (replace-alist-value target :banished-from-chamber
                                 (ritual-chamber-presences after)))
      (incf (ritual-chamber-epoch after))
      (setf (ritual-chamber-history after)
            (append (ritual-chamber-history after)
                    (list history-event)))
      (refresh-chamber-digest after)
      (let ((receipt
              (%make-incantation-receipt
               :id (list :incantation-receipt
                         (incantation-plan-source-digest plan)
                         before-epoch)
               :source-digest (incantation-plan-source-digest plan)
               :plan-digest (incantation-plan-plan-digest plan)
               :recitation-digest (recitation-recitation-digest recitation)
               :chamber-id (ritual-chamber-id chamber)
               :epoch-before before-epoch
               :epoch-after (ritual-chamber-epoch after)
               :chamber-digest-before before-digest
               :chamber-digest-after (ritual-chamber-digest after)
               :actor (incantation-plan-actor plan)
               :office (incantation-plan-office plan)
               :act (incantation-plan-act plan)
               :target target
               :event-summaries (mapcar #'event-summary
                                        (recitation-events recitation))
               :obligation-summaries
               (mapcar #'obligation-summary
                       (incantation-plan-obligations plan))
               :initial-breath (recitation-initial-breath recitation)
               :supplied-breath (recitation-supplied-breath recitation)
               :spent-breath (recitation-spent-breath recitation)
               :final-breath (recitation-remaining-breath recitation)
               :breath-events (mapcar #'breath-event-payload
                                      (recitation-breath-events recitation))
               :standing-before (ritual-chamber-standing chamber)
               :standing-after (ritual-chamber-standing after)
               :outcome :banished-from-chamber
               :effect-boundary
               (list :system (ritual-chamber-id chamber)
                     :target target
                     :field :presence
                     :before :present
                     :after :banished-from-chamber
                     :external-world :not-addressed)
               :receipt-digest nil)))
        (values after (refresh-receipt-digest receipt))))))

(defun validate-receipt (receipt plan recitation before after)
  (unless (typep receipt 'incantation-receipt)
    (fire 'altered-incantation-receipt
          "expected INCANTATION-RECEIPT, received ~s" receipt))
  (validate-plan-integrity plan)
  (validate-recitation recitation plan before)
  (validate-chamber before)
  (validate-chamber after)
  (unless (string= (incantation-receipt-receipt-digest receipt)
                   (toy-digest (receipt-payload receipt)))
    (fire 'altered-incantation-receipt
          "receipt digest no longer matches its payload"))
  (unless (and (string= (incantation-receipt-source-digest receipt)
                        (incantation-plan-source-digest plan))
               (string= (incantation-receipt-plan-digest receipt)
                        (incantation-plan-plan-digest plan))
               (string= (incantation-receipt-recitation-digest receipt)
                        (recitation-recitation-digest recitation))
               (string= (incantation-receipt-chamber-digest-before receipt)
                        (ritual-chamber-digest before))
               (string= (incantation-receipt-chamber-digest-after receipt)
                        (ritual-chamber-digest after)))
    (fire 'altered-incantation-receipt
          "receipt does not bind the supplied source, plan, recitation, and chambers"))
  (unless (and (eq (incantation-receipt-standing-before receipt) :asserted)
               (eq (incantation-receipt-standing-after receipt) :asserted))
    (fire 'forged-enchantment-claim
          "incantatory success cannot promote :ASSERTED standing"))
  (unless (and (eq (incantation-receipt-outcome receipt)
                   :banished-from-chamber)
               (eq (chamber-presence before
                                     (incantation-receipt-target receipt))
                   :present)
               (eq (chamber-presence after
                                     (incantation-receipt-target receipt))
                   :banished-from-chamber))
    (fire 'altered-incantation-receipt
          "receipt outcome is not entailed by the chamber transition"))
  (unless (= (+ (incantation-receipt-initial-breath receipt)
                (incantation-receipt-supplied-breath receipt))
             (+ (incantation-receipt-spent-breath receipt)
                (incantation-receipt-final-breath receipt)))
    (fire 'altered-incantation-receipt
          "receipt breath arithmetic is inconsistent"))
  (let* ((events (incantation-receipt-event-summaries receipt))
         (terminal-key (incantation-plan-terminal-key plan))
         (last-event (car (last events)))
         (last-line (length (source-lines
                             (incantation-plan-source-form plan)))))
    (unless (and (eq (getf last-event :kind) :close)
                 (eq (getf last-event :key) terminal-key)
                 (= (getf last-event :line-number) last-line))
      (fire 'rhyme-closure-out-of-place
            "receipt does not end with the declared terminal rhyme closure")))
  receipt)

(defun assert-incantation-as-evidence (receipt)
  (declare (ignore receipt))
  (fire 'incantation-is-not-evidence
        "a successful bounded performance witnesses an enacted transition, not the truth of its imagery"))

(defun claim-external-banishment (receipt)
  (declare (ignore receipt))
  (fire 'symbolic-act-is-not-metaphysical-proof
        "the receipt addresses only the ritual chamber; external spirits and worlds are outside its boundary"))

;;; ── Replay: repaired breath is part of the historical procedure ───────

(defun replay-incantation (source original-chamber original-recitation
                            original-receipt original-after)
  (ensure-interpreter
   (ritual-chamber-interpreter-id original-chamber)
   (ritual-chamber-interpreter-version original-chamber))
  (let* ((plan (compile-incantation source original-chamber))
         (supplies
           (mapcar (lambda (event) (getf event :amount))
                   (incantation-receipt-breath-events original-receipt)))
         (recitation
           (handler-bind
               ((breath-exhausted
                  (lambda (condition)
                    (declare (ignore condition))
                    (unless supplies
                      (fire 'replay-diverged
                            "replay requested breath absent from the receipt"))
                    (invoke-restart 'supply-breath (pop supplies)))))
             (recite-incantation
              plan original-chamber
              :initial-breath
              (incantation-receipt-initial-breath original-receipt)))))
    (when supplies
      (fire 'replay-diverged
            "receipt contains unused breath decisions ~s" supplies))
    (multiple-value-bind (after receipt)
        (enact-recitation plan original-chamber recitation)
      (unless (and (string= (recitation-recitation-digest recitation)
                            (recitation-recitation-digest
                             original-recitation))
                   (string= (ritual-chamber-digest after)
                            (ritual-chamber-digest original-after))
                   (string= (incantation-receipt-receipt-digest receipt)
                            (incantation-receipt-receipt-digest
                             original-receipt)))
        (fire 'replay-diverged
              "replayed incantation diverged from its archived event"))
      (values after receipt recitation))))

;;; ── The source form: a poem represented as executable obligation data ─

(defparameter +banishment-of-melancholy+
  '(:incantation
    :id :l-allegro-opening-banishment
    :actor :wondermonger
    :office :chorister
    :act :banish
    :target :melancholy
    :standing :asserted
    :terminal-rhyme :c
    :lines
    ((:line :number 1
      :tokens ("Hence" "loathed" "Melancholy")
      :end-rhyme :a)
     (:line :number 2
      :tokens ("Of" "Cerberus" "and" "blackest" "Midnight" "born")
      :end-rhyme :b)
     (:line :number 3
      :tokens ("In" "Stygian" "cave" "forlorn")
      :end-rhyme :b)
     (:line :number 4
      :tokens ("'Mongst" "horrid" "shapes" "and" "shrieks" "and"
               "sights" "unholy")
      :end-rhyme :a)
     (:line :number 5
      :tokens ("Find" "out" "some" "uncouth" "cell")
      :end-rhyme :c)
     (:line :number 6
      :tokens ("Where" "brooding" "Darkness" "spreads" "his" "jealous"
               "wings")
      :end-rhyme :d)
     (:line :number 7
      :tokens ("And" "the" "night-raven" "sings")
      :end-rhyme :d)
     (:line :number 8
      :tokens ("There" "under" "ebon" "shades" "and" "low-brow'd"
               "rocks")
      :end-rhyme :e)
     (:line :number 9
      :tokens ("As" "ragged" "as" "thy" "locks")
      :end-rhyme :e)
     (:line :number 10
      :tokens ("In" "dark" "Cimmerian" "desert" "ever" "dwell")
      :internal-echoes
      ((:key :er
        :left-index 4 :left-word "desert"
        :right-index 5 :right-word "ever"))
      :end-rhyme :c))))

(defparameter +porch-chamber+
  (make-ritual-chamber
   :id :porch-of-recognized-forms
   :interpreter-id :suspended-rhyme
   :interpreter-version 1
   :offices
   '((:actor :wondermonger
      :office :chorister
      :acts (:banish)
      :targets (:melancholy)))
   :presences
   '((:melancholy . :present)
     (:mirth . :absent))))

;;; ── Exhibits ───────────────────────────────────────────────────────────

(defun rhyme-scheme (form)
  (mapcar #'line-end-rhyme-of (source-lines form)))

(defun print-obligation (obligation)
  (format t "  ~s  ~d→~d  ~s / ~s  span ~d"
          (rhyme-obligation-key obligation)
          (rhyme-obligation-opener-line obligation)
          (rhyme-obligation-closer-line obligation)
          (rhyme-obligation-opener-word obligation)
          (rhyme-obligation-closer-word obligation)
          (rhyme-obligation-span obligation))
  (when (rhyme-obligation-enclosed-keys obligation)
    (format t "  encloses ~s"
            (rhyme-obligation-enclosed-keys obligation)))
  (when (rhyme-obligation-terminal-p obligation)
    (format t "  TERMINAL"))
  (terpri))

(defun print-event (event)
  (format t "  #~2d  L~2d  ~14s  ~s  ~s~%"
          (rhyme-event-sequence event)
          (rhyme-event-line-number event)
          (rhyme-event-kind event)
          (rhyme-event-key event)
          (rhyme-event-word event)))

(defun demonstrate ()
  (setf *misfire-archive* '())
  (banner "DE INCANTATIONE — CONCERNING INCANTATION")
  (format t "Claim: suspended rhyme can be represented as an open obligation;~%")
  (format t "       bounded uptake may enact a chamber transition without~%")
  (format t "       promoting rhetoric into evidence or metaphysical proof.~%")

  (section "I. THE FORM OPENS ITS OBLIGATIONS")
  (let* ((source (copy-tree +banishment-of-melancholy+))
         (chamber (copy-ritual-chamber-deep +porch-chamber+))
         (plan (compile-incantation source chamber)))
    (format t " rhyme scheme: ~{~s~^ ~}~%" (rhyme-scheme source))
    (format t " obligations:~%")
    (dolist (obligation (incantation-plan-obligations plan))
      (print-obligation obligation))
    (let ((terminal
            (find-obligation-by-key
             (incantation-plan-obligations plan)
             (incantation-plan-terminal-key plan))))
      (ensure (= (rhyme-obligation-span terminal) 5)
              "terminal C rhyme should span five line steps")
      (ensure (same-set-p (rhyme-obligation-enclosed-keys terminal)
                          '(:d :e))
              "terminal C rhyme should enclose D and E closures")
      (pass "CELL remains open while D and E complete inside it"))

    (section "II. LOCAL ECHO DOES NOT PAY A DIFFERENT DEBT")
    (let ((prefix
            (recite-through plan chamber 10 :initial-breath 10)))
      (let ((echo (latest-internal-echo prefix)))
        (format t " internal echo: ~s at line ~d (~s)~%"
                (rhyme-event-key echo)
                (rhyme-event-line-number echo)
                (rhyme-event-word echo)))
      (expect-condition internal-echo-is-not-discharge
        (discharge-rhyme-with-echo prefix :c)))

    (section "III. PREMATURE POWER IS ARCHIVED, NOT BELIEVED")
    (let ((partial (recite-through plan chamber 9 :initial-breath 9)))
      (format t " after line 9: open rhymes = ~s; complete = ~s~%"
              (recitation-open-keys partial)
              (recitation-complete-p partial))
      (multiple-value-bind (result scar)
          (handler-bind
              ((premature-banishment
                 (lambda (condition)
                   (declare (ignore condition))
                   (invoke-restart 'archive-as-misfire))))
            (enact-recitation plan chamber partial))
        (declare (ignore result))
        (ensure (typep scar 'misfire-scar)
                "premature performance should produce a misfire scar")
        (format t " archived misfire: ~s, standing ~s~%"
                (misfire-scar-condition-type scar)
                (misfire-scar-standing scar))
        (pass "failure remains available as provenance")))

    (section "IV. THE FINAL WORD CLOSES THE CIRCUIT")
    (let ((complete
            (handler-bind
                ((breath-exhausted
                   (lambda (condition)
                     (format t " breath boundary at line ~d: supplying ~d~%"
                             (exhausted-line-number condition)
                             (exhausted-needed condition))
                     (invoke-restart 'supply-breath
                                     (exhausted-needed condition)))))
              (recite-incantation plan chamber :initial-breath 7))))
      (format t " rhyme events:~%")
      (dolist (event (recitation-events complete))
        (print-event event))
      (ensure (recitation-complete-p complete)
              "final recitation should be complete")
      (ensure (= (recitation-supplied-breath complete) 3)
              "final recitation should preserve three supplied units")
      (ensure (null (recitation-open-keys complete))
              "no rhyme obligation should remain open")
      (pass "DWELL discharges C only at the final token")

      (section "V. THE SPELL ACTS ONLY INSIDE ITS DECLARED CHAMBER")
      (multiple-value-bind (after receipt)
          (enact-recitation plan chamber complete)
        (validate-receipt receipt plan complete chamber after)
        (format t " chamber presence: ~s → ~s~%"
                (chamber-presence chamber :melancholy)
                (chamber-presence after :melancholy))
        (format t " standing: ~s → ~s~%"
                (incantation-receipt-standing-before receipt)
                (incantation-receipt-standing-after receipt))
        (format t " outcome: ~s; external world: ~s~%"
                (incantation-receipt-outcome receipt)
                (getf (incantation-receipt-effect-boundary receipt)
                      :external-world))
        (pass "recognized form enacted a bounded performative transition")

        (section "VI. BEAUTY, EVIDENCE, AND METAPHYSICS REMAIN SEPARATE")
        (expect-condition beauty-is-not-authority
          (let* ((unauthorized (copy-tree source))
                 (plist (rest unauthorized)))
            (setf (getf plist :actor) :merchant)
            (compile-incantation unauthorized chamber)))
        (expect-condition incantation-is-not-evidence
          (assert-incantation-as-evidence receipt))
        (expect-condition symbolic-act-is-not-metaphysical-proof
          (claim-external-banishment receipt))
        (let ((forged (copy-incantation-receipt receipt)))
          (setf (incantation-receipt-standing-after forged) :verified)
          (refresh-receipt-digest forged)
          (expect-condition forged-enchantment-claim
            (validate-receipt forged plan complete chamber after)))

        (section "VII. REPLAY NEEDS THE SAME INTERPRETER AND THE SAME SCARS")
        (let ((saved *incantation-interpreters*))
          (unwind-protect
               (progn
                 (setf *incantation-interpreters* '())
                 (expect-condition interpreter-unavailable
                   (replay-incantation source chamber complete receipt after)))
            (setf *incantation-interpreters* saved)))
        (multiple-value-bind (replayed-after replayed-receipt replayed-recitation)
            (replay-incantation source chamber complete receipt after)
          (declare (ignore replayed-receipt replayed-recitation))
          (ensure (string= (ritual-chamber-digest replayed-after)
                           (ritual-chamber-digest after))
                  "replayed chamber should match the original result")
          (pass "replay reproduced closure, repaired breath, and bounded effect"))

        (section "EXHIBIT")
        (format t " terminal obligation: CELL → DWELL~%")
        (format t " local echo:         DESERT → EVER  (:ECHO-ONLY)~%")
        (format t " archived misfires:  ~d~%" (length *misfire-archive*))
        (format t " final verdict:      :BANISHED-FROM-CHAMBER~%")
        (format t " epistemic verdict:  :ASSERTED~%")
        (format t " metaphysical claim: :NOT-ADDRESSED~%")
        (format t "~%The rhyme closes.  The receipt refuses to become a cosmology.~%")
        (pass "DE INCANTATIONE complete")
        t))))

(demonstrate)
