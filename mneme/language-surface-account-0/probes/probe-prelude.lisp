;;;; probe-prelude.lisp
;;;;
;;;; ==========================================================================
;;;; NON-PRODUCTION FEASIBILITY PROBE — Surface Account /0 opening round —
;;;; not a package, not an API, not loadable as part of any system.
;;;; ==========================================================================
;;;;
;;;; This file defines NOTHING in any lisp-plus package.  It lives in CL-USER,
;;;; is loaded only by probes/run-probe.sh into a throwaway child SBCL image,
;;;; appears in no .asd, no umbrella row, no load-order matrix, and no release
;;;; floor.  It mints no Account /0 object, exports nothing, and defines no
;;;; proposed package.  It reads the two named provider APIs through QUALIFIED
;;;; EXTERNAL SYMBOLS ONLY.  There is no `lisp-plus-surface0::`,
;;;; `lisp-plus-surface1::` or `lisp-plus-surface2::` anywhere in this
;;;; directory.
;;;;
;;;; CD/0 NOTE, stated rather than hidden: both providers' Door 1 REQUIRES a
;;;; CD/0 identifier datum as its occurrence tag, so there is no way to call the
;;;; public API without CD/0's public constructor.  CD/0 is used here for
;;;; exactly that argument and for nothing else; it is not measured, not
;;;; scanned, and not enumerated.
;;;;
;;;; MEASUREMENT NOTE: canonical octet counts are taken with each provider's own
;;;; public IDENTITY-OCTETS, which is that provider's public canonical-octet
;;;; length projection over a CD/0 datum.  Host depth and node counts are
;;;; PROBE-SIDE measures over ordinary host conses; they are labelled as such
;;;; and are not provider observations.

(in-package #:cl-user)

(defparameter *probe-banner*
  "NON-PRODUCTION FEASIBILITY PROBE — Surface Account /0 opening round — not a package, not an API, not loadable as part of any system")

;;; --------------------------------------------------------------------------
;;; Deterministic output.  Every line that can vary between two runs of the same
;;; sources at the same tip is prefixed VOLATILE so a comparer can exclude it.
;;; --------------------------------------------------------------------------

;;; One line per fact.  Pretty-printing would re-wrap long values at a margin
;;; that is not a property of the measurement, and two runs must differ only in
;;; their VOLATILE lines.
(setf *print-pretty* nil
      *print-right-margin* nil
      *print-readably* nil
      *print-circle* nil)

(defvar *probe-failures* 0)
(defvar *probe-checks* 0)
(defvar *probe-cases* 0)

(defun p (fmt &rest args)
  (apply #'format t (concatenate 'string "~&" fmt "~%") args)
  (finish-output))

(defun kv (key value)
  (p "    ~24A ~A" key value))

(defun arm (kind label)
  (p "  -- ~A ARM: ~A" kind label))

(defun rule (&optional (char #\-))
  (p "~A" (make-string 74 :initial-element char)))

(defun probe-check (id label ok)
  "One recorded assertion, carrying its STABLE CHECK ID.

The verdict line is emitted in its historical R0/R1 shape — `  [PASS] <label>`,
byte-for-byte — so every citation written against a label still resolves.  The
R2 addition is the line that IMMEDIATELY FOLLOWS it:

    [PASS] <label>
    CHECK-ID <ID>

ID is a stable external name for this assertion.  The verifier is TOLD the
exact ordered ID sequence its section must produce (verify-sequences.txt) and
refuses any transcript whose stream of IDs differs — so a check that vanishes,
moves, doubles or is substituted is caught even when the counts still agree.
The pairing is one-to-one and is itself enforced: a CHECK-ID line must follow a
verdict line, and a verdict line must be followed by a CHECK-ID line."
  (incf *probe-checks*)
  (unless ok (incf *probe-failures*))
  (p "  [~A] ~A" (if ok "PASS" "FAIL") label)
  (p "  CHECK-ID ~A" id)
  ok)

;;; The planted-failure arm.  run-probe.sh --plant-failure sets this env var;
;;; the prelude turns it into one deliberately false check so that the runner's
;;; own nonzero exit and missing PASS sentinel can be demonstrated rather than
;;; assumed.
(defun plant-failure-requested-p ()
  (let ((v (sb-posix:getenv "SA0_PROBE_PLANT_FAILURE")))
    (and v (string= v "1"))))

;;; --------------------------------------------------------------------------
;;; PROBE-SIDE host measures.  Ordinary conses, no provider reach.
;;; --------------------------------------------------------------------------

(defun host-depth (form)
  "Maximum host LIST nesting depth of FORM.  An atom is depth 0."
  (labels ((d (x)
             (if (consp x)
                 (let ((m 0))
                   (loop for tail = x then (cdr tail)
                         while (consp tail)
                         do (setf m (max m (1+ (d (car tail))))))
                   m)
                 0)))
    (d form)))

(defun host-nodes (form)
  "Total host nodes: every cons and every atom reached, counted once per
traversal step.  Shared structure is counted as often as it is reached, which is
the honest count for a tree grammar that has no DAG."
  (let ((n 0))
    (labels ((walk (x)
               (incf n)
               (when (consp x) (walk (car x)) (walk (cdr x)))))
      (walk form))
    n))

;;; --------------------------------------------------------------------------
;;; Fixtures are READ FROM STRINGS at run time, never written as quoted
;;; literals.  Two reasons, both load-bearing:
;;;   1. a compiled/loaded literal may be coalesced with an equal literal
;;;      elsewhere, which would silently create the shared structure both
;;;      providers refuse — the measurement would then be of this file, not of
;;;      the fixture;
;;;   2. the exact fixture text is then quotable in the transcript, so a reader
;;;      can check what was presented without trusting this file's summary.
;;; --------------------------------------------------------------------------

(defun read-fixture (string)
  (let ((*read-eval* nil)
        (*package* (find-package '#:cl-user)))
    (with-standard-io-syntax
      (let ((*read-eval* nil)
            (*package* (find-package '#:cl-user)))
        (read-from-string string)))))

(defun tag-for (name)
  (lisp-plus-cd0:make-identifier-datum '("surface-account-0-probe") (list name)))

(defun scratch-package ()
  (or (find-package "SA0-PROBE-SCRATCH")
      (make-package "SA0-PROBE-SCRATCH" :use '())))

(defun condition-species (c)
  "The condition's class name and the package that owns that name.  This is the
ORIGINAL SPECIES report: no wrapping, no reclassification, no substitution."
  (let* ((name (class-name (class-of c)))
         (pkg (symbol-package name)))
    (values (symbol-name name) (if pkg (package-name pkg) "#:UNINTERNED"))))

(defun probe-header (title)
  (rule #\=)
  (p "~A" *probe-banner*)
  (p "~A" title)
  (rule #\=)
  (kv "PARCEL_TIP" (or (sb-posix:getenv "SA0_PROBE_PARCEL_TIP") "UNSET"))
  (kv "sbcl" (lisp-implementation-version))
  (kv "implementation" (lisp-implementation-type))
  (kv "uname" (or (sb-posix:getenv "SA0_PROBE_UNAME") "UNSET"))
  (kv "VOLATILE timestamp" (or (sb-posix:getenv "SA0_PROBE_STAMP") "UNSET"))
  (rule #\=))

(defun probe-footer (title)
  (rule #\=)
  (p "CHECKS ~D   FAILURES ~D   CASES ~D" *probe-checks* *probe-failures* *probe-cases*)
  (kv "PARCEL_TIP" (or (sb-posix:getenv "SA0_PROBE_PARCEL_TIP") "UNSET"))
  (if (zerop *probe-failures*)
      (p "PROBE-SECTION-PASS ~A" title)
      (p "PROBE-SECTION-FAIL ~A" title))
  (p "END-OF-TRANSCRIPT ~A CHECKS=~D CASES=~D" title *probe-checks* *probe-cases*)
  (rule #\=)
  (finish-output))

(defun probe-exit ()
  (finish-output)
  (sb-ext:exit :code (if (zerop *probe-failures*) 0 1)))
