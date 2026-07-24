;;;; fake-courier.lisp — Lisp+ Language Core /0 deterministic fake adapter.
;;;;
;;;; A SCRIPTED SUBSET adapter — a deterministic full-contract script
;;;; interpreter with a PRIVATE in-memory ledger world.  It is NEVER
;;;; AP0-conformant: it serves the Core /0 specimens' fixtures only, and no
;;;; result it produces licenses AP0-conformance language (AP0 §23 class 5, but
;;;; a labeled subset; the CL-independence gate is not touched).  Governed by
;;;; LISP-PLUS-LANGUAGE-CORE-0-WORK-ORDER.md §1.2.
;;;;
;;;; The load-bearing distinction it enacts (Sol's marrow): the letter being
;;;; PLACED IN THE LEDGER (the EFFECT) is not identical to the program RECORDING
;;;; that it placed the letter there (the TESTIMONY).  The private ledger is the
;;;; effect world; core0's manifestation + event sequence are the testimony.
;;;; The two are DISTINCT records the batteries compare.
;;;;
;;;; Four scripted fixtures (work-order §1.2):
;;;;   (a) :clean-commit               — cross, commit a ledger row, local record lands
;;;;   (b) :refuse-before-frontier     — refuse at the boundary, NO frontier, NO row
;;;;   (c) :kill-after-commit          — W1-shaped: commit the row, but the local
;;;;                                     outcome record does NOT land; ledger later ANSWERS
;;;;   (d) :kill-after-commit-withhold — W1-shaped, but the ledger WITHHOLDS its answer
;;;;
;;;; House style: %-prefixed internals, read-only world, no boolean success in
;;;; the surface it feeds (it returns a structured report plist perform folds).

(unless (find-package :lisp-plus-core0)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "core0.lisp" *load-truename*))))

(defpackage #:lisp-plus-fake-courier
  (:use #:cl)
  (:export
   #:make-fake-courier #:fake-courier-world-p
   #:fake-courier-ledger-rows #:fake-courier-ledger-row-count))

(in-package #:lisp-plus-fake-courier)

;;; ------------------------------------------------------------------
;;; The PRIVATE in-memory ledger world.  Only this file's dispatch mutates it;
;;; a public reader returns a defensive copy so the effect world cannot be
;;; rewritten by whoever inspects it.

(defstruct (fake-courier-world (:constructor %make-fake-courier-world)
                               (:conc-name %fcw-) (:copier nil))
  (script :clean-commit :read-only t)   ; one of the four fixtures
  (answer-mode :answer :read-only t)     ; :answer | :withhold  (ledger-query)
  (rows nil))                            ; list of (attempt-key token request) — the EFFECT

(defun fake-courier-ledger-rows (world)
  "The committed ledger rows — the EFFECT world — as a defensive copy.  A row is
(ATTEMPT-KEY TOKEN REQUEST); it is NOT the program's testimony about the row."
  (mapcar (lambda (r) (list (first r) (second r) (copy-tree (third r))))
          (%fcw-rows world)))

(defun fake-courier-ledger-row-count (world)
  "How many rows the private ledger holds (the count the specimens assert stays 1)."
  (length (%fcw-rows world)))

;;; ------------------------------------------------------------------
;;; Deterministic token — position in the ledger, zero-padded.  The ledger row
;;; (effect) carries it; whether the PROGRAM is told it depends on the fixture.

(defun %next-token (world)
  (format nil "fake:courier:~4,'0D" (1+ (length (%fcw-rows world)))))

(defun %commit-row (world request attempt-id)
  "Place a row in the private ledger (the EFFECT).  Returns the token."
  (let ((token (%next-token world)))
    (push (list (lisp-plus-kernel0:identity-key attempt-id)
                token
                (copy-tree request))
          (%fcw-rows world))
    token))

;;; ------------------------------------------------------------------
;;; DISPATCH — the perform-side crossing.  Returns a structured report plist;
;;; an acknowledgment carries NO settling force (perform's kernel fold settles).

(defun %dispatch (world request attempt-id)
  (ecase (%fcw-script world)
    (:refuse-before-frontier
     ;; the adapter refuses at its boundary BEFORE the frontier: no crossing,
     ;; no ledger row, no ack.
     (list :crossed nil :committed nil :acknowledged nil :ledger-token nil
           :manifestation-status :absent :local-record-lands nil
           :reason :adapter-refused-pre-frontier))
    ((:clean-commit :kill-after-commit :kill-after-commit-withhold)
     (let ((token (%commit-row world request attempt-id)))
       (ecase (%fcw-script world)
         (:clean-commit
          (list :crossed t :committed t :acknowledged t :ledger-token token
                :manifestation-status :present :local-record-lands t :reason :ok))
         ((:kill-after-commit :kill-after-commit-withhold)
          ;; W1: the row IS committed in the private ledger, but the local
          ;; control path dies before the outcome record lands.  The token
          ;; stays in the ledger for later reconciliation; the program is NOT
          ;; told it (LOCAL-RECORD-LANDS is nil, so perform records nil).
          (list :crossed t :committed t :acknowledged t :ledger-token token
                :manifestation-status :withheld :local-record-lands nil
                :reason :killed-before-local-record)))))))

;;; ------------------------------------------------------------------
;;; LEDGER-QUERY — the continuation-side witness of LIMITED jurisdiction.  It
;;; answers ONLY about its own ledger; a withholding world answers nothing.

(defun %ledger-query (world attempt-id request)
  (declare (ignore request))
  (if (eq (%fcw-answer-mode world) :withhold)
      (list :withheld)
      (let ((row (find (lisp-plus-kernel0:identity-key attempt-id)
                       (%fcw-rows world) :key #'first :test #'string=)))
        (if row
            (list :answered :committed (second row))
            (list :answered :not-committed)))))

;;; ------------------------------------------------------------------
;;; Constructor — returns (values ADAPTER WORLD).  The adapter is a core0
;;; protocol object; the world is the private ledger the batteries inspect.

(defun make-fake-courier (&key (script :clean-commit) (name :fake-courier))
  "Construct a deterministic fake courier for SCRIPT, returning
(values ADAPTER WORLD).  ADAPTER plugs into perform; WORLD is the private
ledger (the effect world).  Labeled scripted subset — never AP0-conformant."
  (let* ((world (%make-fake-courier-world
                 :script script
                 :answer-mode (if (eq script :kill-after-commit-withhold)
                                  :withhold :answer)))
         (adapter
           (lisp-plus-core0:make-adapter
            :name name
            :identity (lisp-plus-kernel0:make-identity
                       :principal (format nil "fake-courier/~A/v0" name))
            :version 0
            :dispatch (lambda (a request attempt-id)
                        (declare (ignore a))
                        (%dispatch world request attempt-id))
            :ledger-query (lambda (a attempt-id request)
                            (declare (ignore a))
                            (%ledger-query world attempt-id request)))))
    (values adapter world)))
