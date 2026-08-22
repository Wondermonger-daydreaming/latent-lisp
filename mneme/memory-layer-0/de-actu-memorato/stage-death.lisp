;;;; stage-death.lisp — THE MORITURUS: the process that acts and dies before it
;;;; can account for what it did.
;;;;
;;;; Launched by run-specimen.lisp as a separate `sbcl --script` invocation with
;;;; CAP2_WORLD_DIE_IN_WINDOW=1 in its environment, against its OWN act store and
;;;; its OWN world — never the scriptor's.  Inside one `perform`: the durable
;;;; guard reads the (empty) journal and answers :lawful · capability /2
;;;; authorizes · attempt:prepared and attempt:frontier-crossed are journaled ·
;;;; the world durably applies the cell write and ledgers it · AND THE PROCESS
;;;; EXITS INSIDE THE ACKNOWLEDGMENT WINDOW.
;;;;
;;;; WHAT THIS STAGE EXISTS TO PRODUCE is an asymmetry no one was present to
;;;; record: THE WORLD KNOWS (the cell is written, the ledger holds a row under
;;;; the derived external-request identity) and THE LANGUAGE DOES NOT (no Core /0
;;;; evidence survived; no account of the act was ever written by anyone who was
;;;; there).  The lector then writes the first and only account of it, from the
;;;; durable bytes alone — which is exactly the state D3 requires, and the state
;;;; One Act /1's RETURN named as the absence this lane exists to answer.
;;;;
;;;; ⚠ THIS STAGE MUST NOT RENDER A RESULT SENTINEL: it is supposed to die.  The
;;;; parent verifies exit code 7 AND the absence of RESULT:.
;;;;
;;;; ⚠ AND IT WRITES NO ACCOUNT.  A dying process cannot lawfully leave an
;;;; account of an act it has not finished, and this lane does not give it a way
;;;; to try.  The account store is not even opened here.
;;;;
;;;; — TABULARIUS (Claude Opus 5, subagent), 2026-08-20

(load (merge-pathnames "specimen-common.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-memory-layer0)

(defvar *arguments* (rest sb-ext:*posix-argv*))
(defvar *store-directory* (pathname (first *arguments*)))
(defvar *world-directory* (pathname (second *arguments*)))

(vnote "moriturus: its OWN act store and world · one grant · one perform · and ~
death inside the acknowledgment window, with no account of the act anywhere")

(memorato-act-ground *store-directory* *world-directory*)

(defvar *row* (the-dying-row))
(setf lisp-plus-language-act1:*act1-fixture-table* (list *row*))
(ml0-open-authority (list *row*))

(vcheck "the moriturus's world holds the declared cell at its declared initial ~
value with an empty request ledger, and its journal carries only the grant"
        (lambda ()
          (and (equal *initial-cell-value*
                      (world-cell-value (ml0-world) *cell-name*))
               (= 0 (world-ledger-count (ml0-world)))
               (= 1 (nth-value 1 (act1-journal-kinds *ml0-act-store*))))))

(vnote "act identity (derived from declared configuration, and re-derivable by ~
anyone who reads specimen-common.lisp) ~a"
       (lisp-plus-journal0:identifier-segment-string
        (nth-value 0 (ml0-rederive-act-identity *row*))))
(vnote "evaluating the originating form; the planted interruption will fire ~
inside the adapter's acknowledgment window — this process ends there, mid-perform, ~
and MUST NOT render a RESULT sentinel.  No account of this act will exist until ~
some later process writes one from the bytes.")

;;; THE DEATH.  run-act1 mints Office R, builds and registers this act's ONE
;;; bridge, asserts EQ, and calls perform.  Inside perform the dispatch crosses
;;; the frontier, the world applies and ledgers the write, and the world adapter
;;; exits the process (code 7) before any acknowledgment returns.  Nothing below
;;; this call runs.
(lisp-plus-language-act1:run-act1 *row* :process-name *moriturus-process* :verbose t)

;;; Unreachable on the specimen path.  If the interruption failed to fire, the
;;; sentinel below renders and the parent FAILS the phase (it demands exit 7 with
;;; no sentinel).
(format t "RESULT: ~a checks, ~a failures~%" *v-checks* *v-failures*)
(sb-ext:exit :code (if (zerop *v-failures*) 0 1))
