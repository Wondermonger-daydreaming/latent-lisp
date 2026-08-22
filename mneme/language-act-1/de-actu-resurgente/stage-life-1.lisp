;;;; stage-life-1.lisp — THE PRIMA VITA: the process that evaluates the
;;;; originating form and dies before the acknowledgment comes home.
;;;;
;;;; Launched by run-specimen.lisp as a separate `sbcl --script` invocation with
;;;; CAP2_WORLD_DIE_IN_WINDOW=1 in its environment.  It: creates the declared
;;;; store and world · commits the seat's grant · DERIVES the act identity from
;;;; declared configuration and preserves it · mints Office R at the prefix its
;;;; own dispatch will present against · builds ONE bridge object for this act
;;;; through Core /0's public `make-adapter` · asserts EQ between the registered
;;;; bridge and what `resolve-adapter` returns · evaluates the form ONCE through
;;;; `perform`.
;;;;
;;;; Inside that call: the durable guard reads the (empty) journal and answers
;;;; :lawful · capability /2 authorizes · attempt:prepared and
;;;; attempt:frontier-crossed are journaled · the world durably applies the cell
;;;; write and ledgers it · AND THE PROCESS EXITS INSIDE THE ACKNOWLEDGMENT
;;;; WINDOW.  No acknowledgment is journaled; no settlement; no §10.8 record.
;;;;
;;;; WHAT DIES WITH IT, said plainly: the Core /0 evidence account this act was
;;;; building — the in-image record of what the language did — is gone.  It was
;;;; never durable and this lane does not pretend otherwise; that is precisely
;;;; why the resurgent image must refuse from BYTES and not from memory.
;;;;
;;;; THIS STAGE MUST NOT RENDER A RESULT SENTINEL: it is supposed to die.  The
;;;; parent verifies exit code 7 AND the absence of RESULT:.
;;;;
;;;; — PONTIFEX (Claude Opus 5, subagent), 2026-08-19

(load (merge-pathnames "specimen-common.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-language-act1)

(defvar *arguments* (rest sb-ext:*posix-argv*))
(defvar *store-directory* (pathname (first *arguments*)))
(defvar *world-directory* (pathname (second *arguments*)))
(defvar *run-directory* (pathname (third *arguments*)))

(vnote "prima vita: store · world · grant · derived identity · one bridge · ~
one perform — and death inside the acknowledgment window")

(setf *act1-store* (create-journal *store-directory*
                                   :declared-durability *specimen-durability*
                                   :nonce-octets *specimen-nonce*))
(setf *act1-worlds* (list :apply (make-world *world-directory* (declared-cells)
                                             :script :apply)))
(setf *act1-world-directories* (list :apply *world-directory*))
(setf *act1-bootstrap* (specimen-bootstrap))
(setf *act1-minting-context* (make-minting-context :label "prima-vita"))

(vcheck "the created store's derived identity EQUALS the identity derived from ~
the declared configuration alone"
        (lambda () (string= (journal-store-store-id *act1-store*)
                            (expected-store-id))))

(defvar *row* (the-act-row))
(setf *act1-fixture-table* (list *row*))

(vcheck "the act fixture row validates, and the world holds the declared cell ~
at its declared initial value with an empty request ledger"
        (lambda ()
          (and (validate-act1-fixture-table)
               (equal *initial-cell-value*
                      (world-cell-value (getf *act1-worlds* :apply) *cell-name*))
               (= 0 (world-ledger-count (getf *act1-worlds* :apply))))))

(act1-opening-authority *act1-store* *act1-fixture-table*)

(vcheck "the seat's Capability /0 grant commits at ordinal 1; nothing else is ~
journaled and no world byte has moved"
        (lambda ()
          (multiple-value-bind (kinds count) (act1-journal-kinds *act1-store*)
            (and (= 1 count) (equal '("capability0:granted") kinds)
                 (= 0 (world-ledger-count (getf *act1-worlds* :apply)))))))

;;; ---------------------------------------------------------------------------
;;; The language identity, DERIVED and PRESERVED before the act.

(defvar *derived* (make-act1-record *row* :register nil))

(sp-write-octets (act-identity-path *run-directory*)
                 (sp-ascii (format nil "~a~%~a~%"
                                   (identifier-segment-string
                                    (act1-record-act-id *derived*))
                                   (act1-record-act-id-hex *derived*))))

(vcheck "the act identity is DERIVED from (domain · runtime seat · canonical ~
request) — all declared configuration, none of it carried — and preserved to ~
disk so the restart's re-derivation can be compared rather than believed"
        (lambda ()
          (let ((text (sp-octets-string (sp-read-octets
                                         (act-identity-path *run-directory*)))))
            (and (search (act1-record-act-id-hex *derived*) text)
                 (= 64 (length (act1-record-act-id-hex *derived*)))))))

(vnote "act identity ~a" (identifier-segment-string (act1-record-act-id *derived*)))
(vnote "evaluating the originating form; the planted interruption will fire ~
inside the adapter's acknowledgment window — this process ends there, ~
mid-perform, and MUST NOT render a RESULT sentinel.  The Core /0 evidence this ~
act is building dies with the image, by design.")

;;; THE DEATH.  run-act1 mints Office R, builds and registers this act's ONE
;;; bridge, asserts EQ, and calls perform.  Inside perform the dispatch crosses
;;; the frontier, the world applies and ledgers the write, and the world adapter
;;; exits the process (code 7) before any acknowledgment returns.  Nothing below
;;; this call runs.
(run-act1 *row* :process-name "vita-prima" :verbose t)

;;; Unreachable on the specimen path.  If the interruption failed to fire, the
;;; sentinel below renders and the parent FAILS the phase (it demands exit 7
;;; with no sentinel).
(format t "RESULT: ~a checks, ~a failures~%" *v-checks* *v-failures*)
(sb-ext:exit :code (if (zerop *v-failures*) 0 1))
