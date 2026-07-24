;;;; SPECIMEN.lisp — de-abaco: THE POCKET ABACUS (the quiet-zone control).
;;;;
;;;; The specimen that keeps Lisp+ from becoming "an evidence protocol with
;;;; parentheses".  Ordinary lexical Lisp+ IS Common Lisp (the four-strata
;;;; doctrine, stratum 2): a program that only tallies vowels and parses lantern
;;;; counts — repairing a malformed entry with a plain CL restart — creates NO
;;;; consequential machinery whatsoever.  No claim is constructed, no governed
;;;; act invoked, no receipt minted, no event appended, no schema registered, no
;;;; adapter touched.  Consequence begins ONLY where a program constructs a claim
;;;; or invokes a governed act — and this program does neither.
;;;;
;;;; ACCEPTANCE = THE NEGATIVE.  The abacus program lives in a package that uses
;;;; ONLY #:cl; three machine checks prove zero references into the governed
;;;; packages (slice0 / slice1 / kernel0 / core0 / fake-courier), and before/after
;;;; probes prove the schema registry and the adapter registry are untouched by
;;;; the run.  The CL restart that repairs the malformed entry is an ordinary
;;;; CL restart — NOT a governed core0 repair; the two grammars coexist without
;;;; leaking.
;;;;
;;;; FRONT-DOOR DISCIPLINE: the ABACUS PROGRAM (package #:de-abaco-abacus) uses
;;;; ONLY #:cl.  The BATTERY (this loader) references governed packages by
;;;; single-colon public surface ONLY to INSPECT that the abacus touched nothing
;;;; — the checker is allowed to look; the program under audit is not.  Zero
;;;; double-colon access anywhere in this directory (grep-verified at closure).
;;;;
;;;; Run: sbcl --non-interactive --load SPECIMEN.lisp   (exits 0 on all checks)

;; Load the FULL governed stack so the battery can probe the registries.  The
;; abacus program does not use any of it; loading is the checker's affordance.
(unless (find-package :lisp-plus-fake-courier)
  (handler-bind ((style-warning (lambda (w) (muffle-warning w))))
    (load (merge-pathnames "../fake-courier.lisp" *load-truename*))))

;;; ==================================================================
;;; THE QUIET-ZONE PROGRAM — package uses ONLY #:cl.  Nothing here can reach a
;;; governed surface: every symbol below is CL or locally interned.

(defpackage #:de-abaco-abacus (:use #:cl)
  (:export #:tally-vowels #:parse-lantern-counts
           #:malformed-lantern-entry #:skip-entry #:use-count))
(in-package #:de-abaco-abacus)

(defun tally-vowels (string)
  "An alist vowel -> count over STRING (case-insensitive).  Pure CL."
  (let ((counts (list (cons #\a 0) (cons #\e 0) (cons #\i 0)
                      (cons #\o 0) (cons #\u 0))))
    (loop for ch across (string-downcase string)
          for cell = (assoc ch counts)
          when cell do (incf (cdr cell)))
    counts))

(define-condition malformed-lantern-entry (error)
  ((entry :initarg :entry :reader malformed-lantern-entry-entry))
  (:report (lambda (c s)
             (format s "malformed lantern entry: ~S"
                     (malformed-lantern-entry-entry c)))))

(defun parse-lantern-counts (entries)
  "Parse a list of \"name:count\" strings into an alist.  A malformed entry
SIGNALS an ordinary CL condition offering two ordinary CL restarts — SKIP-ENTRY
(drop it) and USE-COUNT (repair with a supplied count).  This is the CL
condition/restart tradition, wholly distinct from a governed core0 repair: it
emits no receipt, no evidence, no event, and its restart names are not on any
core0 whitelist."
  (let ((result '()))
    (dolist (e entries (nreverse result))
      (restart-case
          (let ((colon (position #\: e)))
            (unless colon (error 'malformed-lantern-entry :entry e))
            (let ((name (subseq e 0 colon))
                  (n (parse-integer (subseq e (1+ colon)))))
              (push (cons name n) result)))
        (skip-entry () :report "Drop this malformed entry."
          nil)
        (use-count (v) :report "Repair this entry with a supplied count."
          (push (cons e v) result))))))

;;; ==================================================================
;;; THE BATTERY — ordinary CL checker in its OWN package.  It references the
;;; governed packages ONLY to prove the abacus touched nothing.

(defpackage #:de-abaco-battery (:use #:cl))
(in-package #:de-abaco-battery)

(defvar *pass* 0)
(defvar *fail* 0)
(defun ok (name bool &optional detail)
  (if bool (progn (incf *pass*) (format t "  ok   ~A~@[ — ~A~]~%" name detail))
      (progn (incf *fail*) (format t "  FAIL ~A~@[ — ~A~]~%" name detail))))

(defparameter +governed-package-names+
  '("LISP-PLUS-CORE0" "LISP-PLUS-SLICE0" "LISP-PLUS-SLICE1"
    "LISP-PLUS-KERNEL0" "LISP-PLUS-FAKE-COURIER"))

(defun governed-package-p (pkg)
  (and pkg (member (package-name pkg) +governed-package-names+ :test #'string=)))

(defun governed-external-symbol-p (s)
  "True when S is an EXTERNAL (public) symbol of a governed package — a real
reference into a governed surface."
  (let ((pkg (symbol-package s)))
    (and (governed-package-p pkg)
         (eq (nth-value 1 (find-symbol (symbol-name s) pkg)) :external))))

(defun scan-governed-references (form)
  "Every governed EXTERNAL symbol appearing in FORM (the machine check the
quiet-zone control asserts is EMPTY for an ordinary program)."
  (let ((hits '()))
    (labels ((walk (x)
               (cond ((symbolp x)
                      (when (governed-external-symbol-p x) (pushnew x hits)))
                     ((consp x) (walk (car x)) (walk (cdr x))))))
      (walk form))
    (nreverse hits)))

;; The VERBATIM source of the two abacus functions (the program under audit).
;; This is the exact text executed above; it is scanned statically.
(defparameter +abacus-source+
  '((defun tally-vowels (string)
      (let ((counts (list (cons #\a 0) (cons #\e 0) (cons #\i 0)
                          (cons #\o 0) (cons #\u 0))))
        (loop for ch across (string-downcase string)
              for cell = (assoc ch counts)
              when cell do (incf (cdr cell)))
        counts))
    (defun parse-lantern-counts (entries)
      (let ((result '()))
        (dolist (e entries (nreverse result))
          (restart-case
              (let ((colon (position #\: e)))
                (unless colon (error 'malformed-lantern-entry :entry e))
                (let ((name (subseq e 0 colon))
                      (n (parse-integer (subseq e (1+ colon)))))
                  (push (cons name n) result)))
            (skip-entry () nil)
            (use-count (v) (push (cons e v) result))))))))

;;; ------------------------------------------------------------------
;;; Untouched-registry probes (public surface).  A probe that REFUSES with the
;;; same typed condition before AND after the abacus run proves the run
;;; registered nothing.

(defun schema-registry-probe ()
  "T iff the probe schema is ABSENT (resolve-schema refuses schema-not-found)."
  (handler-case (progn (lisp-plus-slice1:resolve-schema :de-abaco-probe-schema 1) nil)
    (lisp-plus-slice1:schema-not-found () t)))

(defun adapter-registry-probe ()
  "T iff the probe adapter is ABSENT (resolve-adapter refuses unknown-adapter)."
  (handler-case (progn (lisp-plus-core0:resolve-adapter :de-abaco-probe-adapter) nil)
    (lisp-plus-core0:unknown-adapter () t)))

;;; ==================================================================
;;; THE RUN.

(format t "~%== de-abaco SPECIMEN — THE POCKET ABACUS (quiet-zone control) ==~%")

;;; ---- Movement 1: ordinary computation ----
(format t "~%── movement 1: tally-vowels (ordinary lexical CL) ──~%")
(let ((tally (de-abaco-abacus:tally-vowels "The orchard remembers.")))
  (format t "   tally-vowels \"The orchard remembers.\" => ~S~%" tally)
  (ok "[1] tally is an ordinary alist (a plain value, not a claim)"
      (and (listp tally) (= 5 (length tally))
           (every (lambda (c) (and (characterp (car c)) (integerp (cdr c)))) tally))))

;;; ---- Movement 2: the CL restart repairs a malformed entry ----
(format t "~%── movement 2: parse-lantern-counts with a plain CL restart repair ──~%")
(let* ((entries '("east:3" "west:5" "broken" "north:2"))
       ;; a handler-bind that repairs the malformed "broken" entry with USE-COUNT 0
       ;; — ordinary CL condition handling; no governed machinery is reachable.
       (parsed
         (handler-bind
             ((de-abaco-abacus:malformed-lantern-entry
                (lambda (c)
                  (format t "   caught CL condition ~A; invoking CL restart USE-COUNT 0~%"
                          (type-of c))
                  (invoke-restart 'de-abaco-abacus:use-count 0))))
           (de-abaco-abacus:parse-lantern-counts entries))))
  (format t "   parse-lantern-counts ~S~%   => ~S~%" entries parsed)
  (ok "[2] the malformed entry was repaired by a CL restart (4 rows, \"broken\" -> 0)"
      (and (= 4 (length parsed))
           (equal 0 (cdr (assoc "broken" parsed :test #'string=)))
           (equal 3 (cdr (assoc "east" parsed :test #'string=))))))

;;; ---- Movement 3: acceptance = the negative (three machine checks) ----
(format t "~%── movement 3: acceptance = the NEGATIVE (machine-checked zero references) ──~%")

;; check 3a — the abacus package uses NO governed package.
(let ((used (mapcar #'package-name (package-use-list (find-package :de-abaco-abacus)))))
  (format t "   de-abaco-abacus package-use-list: ~S~%" used)
  (ok "[3a] the abacus package uses ONLY #:cl (no governed package in its use-list)"
      (null (intersection used +governed-package-names+ :test #'string=))))

;; check 3b — DYNAMIC: no symbol INTERNED in the abacus package has a governed
;; home package.  This audits the real, live package, not a copy.
(let ((leaked '()))
  (do-symbols (s (find-package :de-abaco-abacus))
    (when (governed-package-p (symbol-package s))
      (pushnew s leaked)))
  (format t "   governed-home symbols interned in the abacus package: ~S~%" leaked)
  (ok "[3b] ZERO symbols with a governed home-package live in the abacus package"
      (null leaked)))

;; check 3c — STATIC: scan the verbatim abacus source for governed externals.
(let ((refs (scan-governed-references +abacus-source+)))
  (format t "   static scan of the abacus source => governed external refs: ~S~%" refs)
  (ok "[3c] the written abacus program references ZERO governed external symbols"
      (null refs))
  ;; and the control: the scanner CAN find a governed symbol when one is present
  ;; (so the empty result above is evidence, not a broken scanner).
  (let ((planted (scan-governed-references
                  '(let ((x (lisp-plus-core0:perform :adapter :y))) x))))
    (ok "[3c-control] the scanner DOES flag a governed reference when one is planted"
        (member 'lisp-plus-core0:perform planted)
        (format nil "planted scan => ~S" planted))))

;;; ---- Movement 4: registries untouched by the run ----
(format t "~%── movement 4: the schema + adapter registries are UNTOUCHED ──~%")
(let ((schema-before (schema-registry-probe))
      (adapter-before (adapter-registry-probe)))
  ;; run the abacus program AGAIN (the whole point: running it changes no registry)
  (de-abaco-abacus:tally-vowels "lanterns")
  (handler-bind ((de-abaco-abacus:malformed-lantern-entry
                   (lambda (c) (declare (ignore c))
                     (invoke-restart 'de-abaco-abacus:skip-entry))))
    (de-abaco-abacus:parse-lantern-counts '("a:1" "bad")))
  (let ((schema-after (schema-registry-probe))
        (adapter-after (adapter-registry-probe)))
    (ok "[4a] schema registry: probe ABSENT before AND after (nothing registered)"
        (and schema-before schema-after))
    (ok "[4b] adapter registry: probe ABSENT before AND after (nothing registered)"
        (and adapter-before adapter-after))))

;;; ---- Movement 5: CL restart is NOT a governed repair (stated + shown) ----
(format t "~%── movement 5: a CL restart is NOT a governed core0 repair ──~%")
(ok "[5] the repair produced NO governed object (no evidence / outcome / receipt exists)"
    ;; structural: the abacus references zero governed constructors (checks 3a-c),
    ;; so by construction it CANNOT mint a core0-evidence, an outcome, or a
    ;; reconciliation-receipt.  The repair lived entirely in the CL restart grammar.
    (and (null (scan-governed-references +abacus-source+))
         (not (find-symbol "PERFORM" :de-abaco-abacus))))
(format t "   the two grammars coexist without leaking: parse-lantern-counts used~%")
(format t "   CL restart-case / invoke-restart; core0's governed repairs live behind~%")
(format t "   with-core0-restarts and emit receipts — none was reachable here.~%")

;;; ==================================================================
(format t "~%de-abaco: ~D checks passed / ~D failed~%" *pass* *fail*)
(format t "(quiet zone confirmed: ordinary Lisp+ is Common Lisp — no consequence without a claim or a governed act)~%")
(finish-output)
(sb-ext:exit :code (if (zerop *fail*) 0 1))
