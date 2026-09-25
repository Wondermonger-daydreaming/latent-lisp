;;;; package.lisp — REPL /0: an interactive session over PROGRAM /0 (CANDIDATE).
;;;;
;;;; STANDING: CANDIDATE. Loading or running this lane adopts nothing and changes
;;;; no other lane's standing (Owner Ruling 6 §3 B1: standing attaches to object
;;;; identities and explicit dispositions, never to a path).
;;;;
;;;; Commissioned 2026-09-25 ("REPL /0 — THE LANGUAGE ANSWERS BACK", Tomás → Opus 5.5,
;;;; with Astra's proposed scope, + the WebTUI workbench addendum; docked verbatim at
;;;; corpus/voices/received/2026-09-25-134257-owner-REPL-0-COMMISSION-…-VERBATIM.md).
;;;; Built by the desktop chair, Claude Opus 5.5 ("One Blob Ahead Of The Mirror").
;;;;
;;;; THREE FILES, ONE ENGINE:
;;;;   repl0.lisp      — the SESSION ENGINE. UI-independent: text in, a result record
;;;;                     out. Knows nothing of terminals or HTTP.
;;;;   repl0-cli.lisp  — the command-line loop (a terminal is one client of the engine).
;;;;   repl0-web.lisp  — the local HTTP server for the browser workbench (another client).
;;;; The engine evaluates ONLY through lisp-plus-program0:run-source — the same function
;;;; the file runner (run.lisp) uses. There is one account of what a Lisp+ program means.

(defpackage #:lisp-plus-repl0
  (:use #:cl)
  (:import-from #:lisp-plus-program0
                #:run-source #:read-source-forms #:make-global-environment #:render
                #:program0-error #:program0-incomplete-source #:render-program0-error
                #:program0-error-code #:program0-error-message #:program0-error-location
                #:program0-error-path #:program0-error-frames
                #:closure-p #:primitive-p #:refusal-p #:host-value-p
                #:*step-budget* #:*depth-limit* #:+program0-version+)
  (:export
   ;; the session
   #:session #:make-session #:session-id #:session-generation #:session-started
   #:session-submissions #:session-names #:session-env
   #:submit
   ;; the result record
   #:result #:result-index #:result-status #:result-forms #:result-value #:result-kind
   #:result-output #:result-error #:result-fault #:result-note #:result-state-note
   #:result-elapsed-ms #:result-source-name
   ;; constants
   #:+repl0-version+ #:*max-submission-bytes*))
