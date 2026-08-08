;;;; act0-load-witnesses.lisp — One Act /0 LOADER-FINALITY witnesses (owner
;;;; ruling R2.2, item 3).  ONE CASE PER FRESH IMAGE (env ACT0_LOADER_CASE),
;;;; because every case needs an image whose package state is exactly the
;;;; hostile precondition it constructs — nothing here may be pre-loaded.
;;;; Driven by act0-load-witnesses.sh.
;;;;
;;;; WHY THESE SIX.  The owner reproduced two false-success states against the
;;;; stanza's original `(unless (find-package '#:lisp-plus-language-act0) ...)`
;;;; guard:
;;;;
;;;;   EMPTY NAMESAKE PACKAGE      ASDF exit 0 · exports 0  · RUN-ACT absent
;;;;   PACKAGE.LISP LOADED ALONE   ASDF exit 0 · exports 70 · RUN-ACT :EXTERNAL
;;;;                                                          but not FBOUNDP
;;;;
;;;; An empty package collision — or merely loading package.lisp to read the
;;;; interface — made `asdf:load-system "lisp-plus/act0"` report success over
;;;; an unusable lane.  This is the species Surface Account R4.3 permanently
;;;; outlawed: PACKAGE EXISTENCE IS NOT IMPLEMENTATION READINESS.  These six
;;;; cases make the owner's commission permanent.
;;;;
;;;; Cases:
;;;;   w1-empty-package     the owner's first state verbatim: an existing EMPTY
;;;;                        namesake package (MAKE-PACKAGE, zero symbols).  The
;;;;                        old guard SKIPPED here.  The repaired loader must
;;;;                        complete the lane or fail closed — never return
;;;;                        success over a lane with no RUN-ACT.
;;;;   w2-package-only      the owner's second state verbatim: package.lisp
;;;;                        loaded alone (70 externals, RUN-ACT :EXTERNAL and
;;;;                        NOT FBOUNDP).  Note what this case proves about the
;;;;                        cure: the export CENSUS was already perfect here, so
;;;;                        a census-only predicate is no cure either.
;;;;   w3-package-fixtures  package.lisp + act0-fixtures.lisp, implementation
;;;;                        and gates absent.
;;;;   w4-gates-absent      package + fixtures + act0.lisp, gates absent — 69 of
;;;;                        70 exports satisfied.  THE PREDICATE MUST BE FALSE,
;;;;                        and it is false for exactly one reason: the
;;;;                        final-source readiness carrier lives in the last
;;;;                        form of act0-gates.lisp.  This is the case that
;;;;                        justifies the carrier's existence.
;;;;   w5-lawful-fresh      a lawful fresh load: predicate TRUE, RUN-ACT
;;;;                        FBOUNDP, export census EXACTLY the 70 enumerated
;;;;                        names, carrier present with its declared value.
;;;;   w6-repeat-forced     a complete lane loaded again — plain repeat, ASDF
;;;;                        :force, and a forced re-read of all four sources.
;;;;                        Still complete, no error, and no duplication damage:
;;;;                        the fixture table still validates at seven rows and
;;;;                        ALL 63 FROZEN VECTORS still recompute clean.
;;;;
;;;; Teeth: the disease comparator act0-loader-disease.sh restores the
;;;; FIND-PACKAGE guard in a disposable replica and shows w1 and w2 FAILING by
;;;; named check; ACT0_LOADER_PLANT_FAULT=1 plants one failing check here
;;;; (proves this harness can fail at all).
;;;;
;;;; The 70-name enumeration is NOT duplicated here: the witness reads it from
;;;; LISP-PLUS-SYSTEM, so the guard and its witness can never drift apart.
;;;;
;;;; R2.3 (owner ruling item 1) ADDS the case-invariant SYSTEM-EXPORT BATTERY
;;;; SE-1..SE-7, run at the head of every one of the six cases: ACT0-LANE-FILES
;;;; :EXTERNAL and FBOUNDP, its exact four paths in the declared order, EQUAL
;;;; but never EQ across calls, and EVERY LISP-PLUS-SYSTEM external bound as
;;;; its kind requires.  Each case's authorized check count is therefore its
;;;; R2.2 count PLUS SEVEN:
;;;;
;;;;   w1  9 -> 16    w2 11 -> 18    w3 10 -> 17
;;;;   w4 12 -> 19    w5 11 -> 18    w6 15 -> 22
;;;;
;;;; — FABER-II (Claude Opus 5, subagent), R2.2, 2026-08-08
;;;; — FABER-III (Claude Opus 5, subagent), R2.3 item 1, 2026-08-08

(in-package #:cl-user)

(defvar *here* (make-pathname :name nil :type nil :defaults *load-truename*))
(defvar *lane-root* (merge-pathnames "../../" *here*))   ; experiments/latent-lisp/

(defvar *checks* 0)
(defvar *failures* 0)
(defvar *case* (or (sb-ext:posix-getenv "ACT0_LOADER_CASE") "unset"))

;;; The SYSTEM DEFINITION is loaded first and on its own — FIND-SYSTEM reads
;;; lisp-plus.asd (which defines the LISP-PLUS-SYSTEM package and the R2.2
;;; predicate) WITHOUT performing any load-op.  Every case below can therefore
;;; interrogate the guard before deciding whether to invoke it.
(require :asdf)
(funcall (intern "INITIALIZE-SOURCE-REGISTRY" :asdf)
         `(:source-registry (:directory ,(namestring *lane-root*))
           :inherit-configuration))
(funcall (intern "FIND-SYSTEM" :asdf) "lisp-plus/act0")

(defun check (description thunk)
  (incf *checks*)
  (let ((outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (c) (list :error c)))))
    (if (eq outcome :ok)
        (format t "[W~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[W~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))
    (force-output)))

(defun act0-package () (find-package '#:lisp-plus-language-act0))

(defun sys (name &rest args)
  "Call a LISP-PLUS-SYSTEM function by name (the .asd's package)."
  (apply (uiop:find-symbol* name '#:lisp-plus-system) args))

(defun sys-value (name)
  (symbol-value (uiop:find-symbol* name '#:lisp-plus-system)))

(defun enumerated-api-names ()
  (append (sys-value '#:+act0-external-functions+)
          (sys-value '#:+act0-external-variables+)
          (sys-value '#:+act0-external-types+)))

(defun external-names ()
  (let ((names '()))
    (when (act0-package)
      (do-external-symbols (s (act0-package)) (push (symbol-name s) names)))
    (sort names #'string<)))

(defun run-act-fboundp ()
  "THE PROBE the owner used: is the lane's principal entry point callable?"
  (let* ((p (act0-package))
         (s (and p (find-symbol "RUN-ACT" p))))
    (and s (fboundp s) t)))

(defun run-act-status ()
  (let ((p (act0-package)))
    (if (null p) :no-package (nth-value 1 (find-symbol "RUN-ACT" p)))))

(defun carrier-symbol ()
  (let ((p (act0-package)))
    (and p (find-symbol (sys-value '#:+act0-readiness-carrier+) p))))

(defun load-lane-via-asdf (&rest args)
  (require :asdf)
  (funcall (intern "INITIALIZE-SOURCE-REGISTRY" :asdf)
           `(:source-registry (:directory ,(namestring *lane-root*))
             :inherit-configuration))
  (apply (intern "LOAD-SYSTEM" :asdf) "lisp-plus/act0" args))

(defun lane-source (name) (merge-pathnames name *here*))

(defun load-lane-dependencies ()
  "Load One Act /0's three declared ASDF edges, in the header's mandated order
(Stack A first).  The partial-load preconditions below are constructed INSIDE an
image where the lane's dependencies are already present — the only image in
which `package.lisp' can be loaded at all, since its DEFPACKAGE :IMPORT-FROMs
name Journal /0, Capability /0/1/2 and Kernel /0.  This is also the image the
owner's second reproduced state was observed in: exports 70 requires the
imports to resolve."
  (dolist (s '("lisp-plus/stack-a" "lisp-plus/core0" "lisp-plus/surface2"))
    (funcall (intern "LOAD-SYSTEM" :asdf) s)))

;;; ---------------------------------------------------------------------------
;;; The shared lawful-outcome battery.
;;;
;;; ⚠ THE POINT OF THIS FUNCTION IS THAT IT DOES NOT DEMAND COMPLETION.  Two
;;; outcomes are lawful — the lane is completed, or the loader fails closed —
;;; and exactly one is not: returning success over a lane with no RUN-ACT.  The
;;; witness reports WHICH lawful outcome occurred rather than assuming it.

(defun lawful-outcome-checks (label &rest load-args)
  (let* ((outcome (handler-case (progn (apply #'load-lane-via-asdf load-args)
                                       :completed)
                    (error (c) (list :refused c))))
         (completed (eq outcome :completed))
         (ready (run-act-fboundp)))
    (format t "     ASDF outcome: ~a · RUN-ACT fboundp: ~a · status: ~s~%"
            (if completed "returned normally" "signalled") ready (run-act-status))
    (check (format nil "~a: NO FALSE SUCCESS — the loader never returns success over a lane whose RUN-ACT is not FBOUNDP"
                   label)
           (lambda () (not (and completed (not ready)))))
    (check (format nil "~a: the outcome is one of the two LAWFUL ones (completed-and-ready, or failed-closed with a named error)"
                   label)
           (lambda ()
             (or (and completed ready)
                 (and (consp outcome)
                      (typep (second outcome)
                             (uiop:find-symbol* '#:act0-lane-incomplete
                                                '#:lisp-plus-system))))))
    (when completed
      (check (format nil "~a: ACT0-API-COMPLETE-P holds after the repair" label)
             (lambda () (eq t (and (sys '#:act0-api-complete-p) t))))
      (check (format nil "~a: the shortfall report is empty" label)
             (lambda () (null (sys '#:act0-api-shortfall))))
      (check (format nil "~a: the export census is EXACTLY the 70 enumerated names" label)
             (lambda () (equal (external-names)
                               (sort (copy-list (enumerated-api-names)) #'string<))))
      (check (format nil "~a: the readiness carrier is present, BOUND, and holds its declared value" label)
             (lambda () (let ((c (carrier-symbol)))
                          (and c (boundp c)
                               (equal (symbol-value c)
                                      (sys-value '#:+act0-carrier-value+)))))))
    outcome))

(defun old-guard-would-have-skipped ()
  (check "RED CONTEXT: the namesake package EXISTS, so the outlawed FIND-PACKAGE guard would have loaded NOTHING here"
         (lambda () (and (act0-package) t))))

;;; ---------------------------------------------------------------------------
;;; SE-1..SE-7 — THE SYSTEM-EXPORT BATTERY (owner ruling R2.3, item 1).
;;;
;;; R2.2 shipped a PHANTOM: LISP-PLUS-SYSTEM exported #:ACT0-LANE-FILES and no
;;; function, variable or class ever bound it.  Nothing in this lane's evidence
;;; could see that, because every instrument asked about the ACT0 package and
;;; none asked about the SYSTEM package that guards it.
;;;
;;; ⚠ THIS BATTERY IS CASE-INVARIANT — it runs at the head of ALL SIX cases,
;;; not in one.  The properties it asserts hold in every image in which the
;;; system definition has been READ (FIND-SYSTEM, above), independently of how
;;; much of the lane is loaded; a phantom that could ship in any one of these
;;; six package-states is a phantom that ships.  Every case's check count is
;;; therefore amended by exactly +7.
;;;
;;; SE-3's expected value is written out AS A LITERAL here and deliberately NOT
;;; read from +ACT0-LANE-SOURCES+: a witness that compared the function's
;;; output against the same defparameter the function copies would assert only
;;; that COPY-SEQ works.  SE-4 then checks the agreement with the defparameter
;;; separately, which is the one-enumeration-two-readers property.
;;;
;;; SE-7 walks the system package's externals rather than enumerating them,
;;; and that direction is correct HERE (unlike the ACT0 API guard, which must
;;; enumerate): the claim is universally quantified over whatever the package
;;; actually exports, so iteration cannot be satisfied vacuously — and the
;;; count is asserted besides, so an export added without a binding, or a
;;; binding added without its export, fails closed either way.
;;;
;;; — FABER-III (Claude Opus 5, subagent), R2.3, 2026-08-08

(defparameter +ruling-declared-lane-files+
  '("mneme/language-act-0/package.lisp"
    "mneme/language-act-0/act0-fixtures.lisp"
    "mneme/language-act-0/act0.lisp"
    "mneme/language-act-0/act0-gates.lisp")
  "The four paths, IN THE ORDER THE OWNER'S R2.3 RULING DECLARES THEM, written
out here by hand.  This is the independent copy SE-3 compares against.")

(defparameter +system-external-count+ 15
  "LISP-PLUS-SYSTEM's declared external count.  Asserted so that adding an
export without a binding — the R2.2 defect — fails closed instead of shipping.")

(defun system-package () (find-package '#:lisp-plus-system))

(defun system-external-symbols ()
  (let ((names '()))
    (do-external-symbols (s (system-package)) (push s names))
    (sort names #'string< :key #'symbol-name)))

(defun system-export-binding (symbol)
  "The KIND of binding SYMBOL has, or NIL if it has none.  A phantom is exactly
a symbol for which this returns NIL."
  (cond ((fboundp symbol) :function)
        ((boundp symbol) :variable)
        ((find-class symbol nil) :class)
        (t nil)))

(defun system-export-checks ()
  (let* ((lane-files-symbol (find-symbol "ACT0-LANE-FILES" (system-package)))
         (status (and lane-files-symbol
                      (nth-value 1 (find-symbol "ACT0-LANE-FILES" (system-package))))))
    (check "SE-1: ACT0-LANE-FILES is :EXTERNAL in LISP-PLUS-SYSTEM"
           (lambda () (eq :external status)))
    (check "SE-2: ACT0-LANE-FILES is FBOUNDP — the R2.2 phantom is CLOSED (it was :EXTERNAL and bound to nothing)"
           (lambda () (and lane-files-symbol (fboundp lane-files-symbol) t)))
    (check "SE-3: it returns EXACTLY the four paths the ruling declares, IN ORDER (compared against this file's own hand-written literal, never against the defparameter it copies)"
           (lambda () (equal (sys '#:act0-lane-files) +ruling-declared-lane-files+)))
    (check "SE-4: and that literal agrees with +ACT0-LANE-SOURCES+ — one enumeration, two readers; the published order IS the load order"
           (lambda () (equal +ruling-declared-lane-files+ (sys-value '#:+act0-lane-sources+))))
    (check "SE-5: two calls are EQUAL"
           (lambda () (equal (sys '#:act0-lane-files) (sys '#:act0-lane-files))))
    (check "SE-6: two calls are NOT EQ — not the list, not any element — and the mutable +ACT0-LANE-SOURCES+ is never exposed: destroying a returned list leaves the guard's list untouched"
           (lambda ()
             (let* ((a (sys '#:act0-lane-files))
                    (b (sys '#:act0-lane-files))
                    ;; a DEEP copy: conses AND strings.  A shallow snapshot
                    ;; would share the very strings whose mutation is under
                    ;; test, and would therefore move with them.
                    (frozen (mapcar #'copy-seq (sys-value '#:+act0-lane-sources+))))
               (and (not (eq a b))
                    (notany #'eq a b)
                    (notany #'eq a (sys-value '#:+act0-lane-sources+))
                    ;; vandalise the copy in place, both spine and strings
                    (progn (setf (first a) "VANDALISED"
                                 (rest a) nil)
                           (setf (char (first b) 0) #\!)
                           (equal frozen (sys-value '#:+act0-lane-sources+)))))))
    (let* ((externals (system-external-symbols))
           (unbound (remove-if #'system-export-binding externals)))
      ;; The census is PRINTED, not merely counted: a reader of this transcript
      ;; can see every external name beside the binding kind that answers it.
      (format t "     SYSTEM-EXPORTS census of LISP-PLUS-SYSTEM: ~d external(s)~%"
              (length externals))
      (dolist (sym externals)
        (format t "     export ~a~34t~a~%" (symbol-name sym)
                (or (system-export-binding sym) "*** PHANTOM — NO BINDING ***")))
      (check (format nil "SE-7: LISP-PLUS-SYSTEM exports EXACTLY ~d names and EVERY ONE has a binding of its kind (FBOUNDP, BOUNDP or FIND-CLASS) — no phantom can ship again"
                     +system-external-count+)
             (lambda () (and (= +system-external-count+ (length externals))
                             (null unbound)))))))

;;; ---------------------------------------------------------------------------
;;; Preconditions.

(defun plant-empty-package ()
  (make-package '#:lisp-plus-language-act0 :use '(#:common-lisp)))

(defun own-symbol-count ()
  (let ((n 0))
    (do-symbols (s (act0-package))
      (when (eq (symbol-package s) (act0-package)) (incf n)))
    n))

;;; ---------------------------------------------------------------------------
;;; The six cases.

(defun case-w1-empty-package ()
  (plant-empty-package)
  (check "precondition (the owner's FIRST reproduced state): an existing EMPTY namesake package — zero own symbols, zero externals"
         (lambda () (and (zerop (own-symbol-count)) (null (external-names)))))
  (check "precondition: RUN-ACT is ABSENT (not interned at all)"
         (lambda () (eq :no-symbol (or (run-act-status) :no-symbol))))
  (old-guard-would-have-skipped)
  (lawful-outcome-checks "w1 empty-package"))

(defun case-w2-package-only ()
  (load-lane-dependencies)
  (load (lane-source "package.lisp"))
  (check "precondition (the owner's SECOND reproduced state): package.lisp loaded ALONE — exactly 70 externals"
         (lambda () (= 70 (length (external-names)))))
  (check "precondition: RUN-ACT is :EXTERNAL but NOT FBOUNDP — the exact false-success signature"
         (lambda () (and (eq :external (run-act-status)) (not (run-act-fboundp)))))
  (check "precondition: the export CENSUS is already perfect here — so a census-only predicate would be no cure"
         (lambda () (equal (external-names)
                           (sort (copy-list (enumerated-api-names)) #'string<))))
  (check "the R2.2 predicate REJECTS this state (the old guard accepted it)"
         (lambda () (null (sys '#:act0-api-complete-p))))
  (old-guard-would-have-skipped)
  (lawful-outcome-checks "w2 package-only"))

(defun case-w3-package-fixtures ()
  (load-lane-dependencies)
  (load (lane-source "package.lisp"))
  (load (lane-source "act0-fixtures.lisp"))
  (check "precondition: package + fixtures only — the five lane constants are BOUND"
         (lambda () (every (lambda (n)
                             (let ((s (find-symbol n (act0-package))))
                               (and s (boundp s))))
                           '("+ACT-ID-DOMAIN+" "+LANE-STEM+" "+ACT-STORE-NONCE+"
                             "+RUNTIME-PROCESS-NAME+" "+LANE-EVENT-NAMESPACE+"))))
  (check "precondition: the implementation is absent — RUN-ACT :EXTERNAL, not FBOUNDP"
         (lambda () (and (eq :external (run-act-status)) (not (run-act-fboundp)))))
  (check "the R2.2 predicate REJECTS this state"
         (lambda () (null (sys '#:act0-api-complete-p))))
  (old-guard-would-have-skipped)
  (lawful-outcome-checks "w3 package-fixtures"))

(defun case-w4-gates-absent ()
  (load-lane-dependencies)
  (load (lane-source "package.lisp"))
  (load (lane-source "act0-fixtures.lisp"))
  (load (lane-source "act0.lisp"))
  (check "precondition: THREE of four sources loaded — act0-gates.lisp absent"
         (lambda () (and (run-act-fboundp)
                         (let ((s (find-symbol "RUN-ALL-ARMS" (act0-package))))
                           (and s (not (fboundp s)))))))
  (check "precondition: 69 of the 70 declared exports are already satisfied (only RUN-ALL-ARMS, defined in gates, is not)"
         (lambda ()
           (= 1 (count-if (lambda (n)
                            (multiple-value-bind (s status) (find-symbol n (act0-package))
                              (not (and s (eq status :external)
                                        (cond ((member n (sys-value '#:+act0-external-functions+)
                                                       :test #'string=)
                                               (fboundp s))
                                              ((member n (sys-value '#:+act0-external-variables+)
                                                       :test #'string=)
                                               (boundp s))
                                              (t (and (find-class s nil) t)))))))
                          (enumerated-api-names)))))
  (check "THE PREDICATE IS FALSE — a 69/70 lane is not a loaded lane"
         (lambda () (null (sys '#:act0-api-complete-p))))
  (check "the readiness carrier is ABSENT (it lives in the LAST form of the LAST source)"
         (lambda () (null (carrier-symbol))))
  (check "the shortfall names BOTH reasons — the missing gates-defined export and the missing carrier"
         (lambda () (let ((s (sys '#:act0-api-shortfall)))
                      (and (= 2 (length s))
                           (some (lambda (r) (search "RUN-ALL-ARMS" r)) s)
                           (some (lambda (r) (search "readiness carrier" r)) s)))))
  (old-guard-would-have-skipped)
  (lawful-outcome-checks "w4 gates-absent"))

(defun case-w5-lawful-fresh ()
  (check "precondition: a FRESH image — the namesake package does not exist"
         (lambda () (null (act0-package))))
  ;; ⚠ THIS IS THE ONLY CASE THAT DEMANDS COMPLETION.  w1..w4 accept either
  ;; lawful outcome because their preconditions are hostile; a CLEAN tree must
  ;; actually load.  Disease D2 (the readiness carrier deleted from the last
  ;; form of act0-gates.lisp) is caught exactly here.
  (check "w5: the lawful fresh load COMPLETED — a clean tree must never fail closed"
         (let ((outcome (lawful-outcome-checks "w5 lawful-fresh")))
           (lambda () (eq :completed outcome))))
  (check "w5: RUN-ACT is FBOUNDP (the owner's probe)"
         (lambda () (run-act-fboundp)))
  (check "w5: the export count is EXACTLY 70"
         (lambda () (= 70 (length (external-names)))))
  (check "w5: 41 functions FBOUNDP, 13 variables BOUNDP, 16 types name classes — each :EXTERNAL"
         (lambda ()
           (and (= 41 (length (sys-value '#:+act0-external-functions+)))
                (= 13 (length (sys-value '#:+act0-external-variables+)))
                (= 16 (length (sys-value '#:+act0-external-types+)))
                (= 70 (sys-value '#:+act0-api-count+))
                (null (sys '#:act0-api-shortfall))))))

(defun act0-call (name &rest args)
  (apply (uiop:find-symbol* name '#:lisp-plus-language-act0) args))

(defun act0-var (name)
  (symbol-value (uiop:find-symbol* name '#:lisp-plus-language-act0)))

(defun case-w6-repeat-forced ()
  (lawful-outcome-checks "w6 first (lawful fresh) load")
  (let ((carrier-value (symbol-value (carrier-symbol))))
    (check "w6: a PLAIN repeated asdf:load-system completes with no error and the lane stays complete"
           (lambda () (load-lane-via-asdf) (sys '#:act0-api-complete-p)))
    (check "w6: an asdf:load-system with :FORCE on this system completes and the lane stays complete"
           (lambda () (load-lane-via-asdf :force (list "lisp-plus/act0"))
             (sys '#:act0-api-complete-p)))
    (check "w6: ENSURE-ACT0-LANE over a complete lane is a no-op that returns T"
           (lambda () (eq t (sys '#:ensure-act0-lane))))
    (check "w6: a FORCED re-read of all four sources (LOAD-ACT0-LANE) completes with no error"
           (lambda () (sys '#:load-act0-lane) t))
    (check "w6: the lane is STILL complete after the forced re-read"
           (lambda () (sys '#:act0-api-complete-p)))
    (check "w6: the readiness carrier value is unchanged by the repeats"
           (lambda () (equal carrier-value (symbol-value (carrier-symbol)))))
    (check "w6: NO DUPLICATION DAMAGE — the export census is still exactly the 70 enumerated names"
           (lambda () (equal (external-names)
                             (sort (copy-list (enumerated-api-names)) #'string<))))
    (check "w6: NO DUPLICATION DAMAGE — the fixture table still validates and still holds SEVEN rows"
           (lambda () (and (act0-call '#:validate-act-fixture-table)
                           (= 7 (length (act0-var '#:*act-fixture-table*))))))
    ;; The strongest available idempotence evidence short of a full arm run:
    ;; the lane's own sixty-three frozen vectors, recomputed through the lane's
    ;; own encoders AFTER the repeated and forced loads.
    (let ((failed-before (act0-var '#:*checks-failed*)))
      (act0-call '#:gate-16-vectors)
      (check "w6: ALL 63 FROZEN VECTORS still recompute clean after the repeated and forced loads (0 new failures)"
             (lambda () (= failed-before (act0-var '#:*checks-failed*)))))))

;;; ---------------------------------------------------------------------------

(let ((case-fn (intern (string-upcase (format nil "case-~a" *case*)) :cl-user)))
  (if (fboundp case-fn)
      ;; R2.3 item 1: the system-export battery runs FIRST, in EVERY case —
      ;; dispatched from this one site so no case can be forgotten.  It reads
      ;; only the system definition (already found above), so it neither
      ;; disturbs nor depends on the package-state the case is about to build.
      (progn (system-export-checks) (funcall case-fn))
      (progn (format t "!! unknown ACT0_LOADER_CASE ~s~%" *case*)
             (sb-ext:exit :code 2))))

(when (equal (sb-ext:posix-getenv "ACT0_LOADER_PLANT_FAULT") "1")
  (check "PLANTED FAULT (ACT0_LOADER_PLANT_FAULT=1): this check must FAIL"
         (lambda () nil)))

(format t "~%act0-load-witnesses[~a]: ~D checks, ~D failures~%"
        *case* *checks* *failures*)
(finish-output)
(sb-ext:exit :code (if (zerop *failures*) 0 1))
