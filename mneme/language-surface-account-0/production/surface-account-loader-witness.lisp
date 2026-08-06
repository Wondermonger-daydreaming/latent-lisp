;;;; surface-account-loader-witness.lisp — Surface Account /0 LOADER-FINALITY
;;;; witnesses (R4.3).  ONE CASE PER FRESH IMAGE (env SA0_LOADER_CASE),
;;;; because every case needs an image whose package state is exactly the
;;;; hostile precondition it constructs — nothing here may be pre-loaded.
;;;; Driven by production/run-hostile-profiles.sh.
;;;;
;;;; These four cases are the owner's R4.3 commission made permanent: the
;;;; live counterexample that convicted the R4.1/R4.2 readiness guard
;;;; (R4-READINESS-GUARD-ACCEPTS-NONEXTERNAL-API — a status-blind
;;;; FBOUNDP-only predicate certified nine INTERNAL fbound dummies as the
;;;; public API, and the absent-only package.lisp skip made an existing
;;;; incomplete package unrepairable) becomes a named, teeth-checked gate.
;;;;
;;;; Cases:
;;;;   internal-dummies    the owner's counterexample verbatim: a pre-created
;;;;                       LISP-PLUS-SURFACE-ACCOUNT holding the nine API
;;;;                       names as INTERNAL fbound dummies; the
;;;;                       umbrella-guarded ASDF lane load must REPAIR it —
;;;;                       end state: exactly nine externals, symbol identity
;;;;                       preserved, every dummy rebound to the real
;;;;                       implementation, carrier present, ready, one
;;;;                       gathering, allocation from 1 — and a subsequent
;;;;                       explicit lane load is a lawful no-op over the
;;;;                       REAL lane, not over dummies
;;;;   partial-external    a pre-created package exporting a strict SUBSET
;;;;                       (four names as external fbound dummies, five
;;;;                       absent); the direct loader must repair to the full
;;;;                       real nine (identity of the four preserved)
;;;;   empty-package       an existing EMPTY namesake package (MAKE-PACKAGE,
;;;;                       zero symbols); the direct loader must repair —
;;;;                       this is the case the R4.2 absent-only skip could
;;;;                       never repair
;;;;   repeat-after-repair lawful repeated loading AFTER a successful
;;;;                       repair: no second gathering, no allocation reset,
;;;;                       epoch byte-identical, election log unchanged —
;;;;                       through BOTH the direct loader and the ASDF row
;;;;
;;;; Teeth: disease comparators D7 (status-blind predicate + absent-only
;;;; skip restored -> internal-dummies FAILS by named check) and D8 (an
;;;; export's defun removed -> the loader's post-load assertion fires) show
;;;; these witnesses failing; SA0_LOADER_PLANT_FAULT=1 plants one failing
;;;; check (proves this harness can fail).
;;;;
;;;; The nine-name list below is the design ledger's, verbatim; the
;;;; selftest's export census keeps it honest.
;;;;
;;;; — FABER-II (Claude Fable 5), R4.3, 2026-08-06

(in-package #:cl-user)

(defvar *here* (make-pathname :name nil :type nil :defaults *load-truename*))
(defvar *lane-root* (merge-pathnames "../../../" *here*))
(defvar *loader* (merge-pathnames "load.lisp" *here*))

(defvar *checks* 0)
(defvar *failures* 0)
(defvar *case* (or (sb-ext:posix-getenv "SA0_LOADER_CASE") "unset"))

(defun check (description thunk)
  (incf *checks*)
  (let ((outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (c) (list :error c)))))
    (if (eq outcome :ok)
        (format t "[L~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[L~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))))

(defparameter *api-names*
  '("INITIALIZE-IMAGE-IDENTITY" "IDENTITY-READY-P" "IMAGE-EPOCH-HEX"
    "IMAGE-EPOCH-DATUM" "EPOCH-GATHERINGS" "ELECTION-COUNT"
    "MINT-PERFORMANCE-IDENTIFIER" "PERFORMANCE-IDENTIFIER-SHAPE-P"
    "LAWFUL-COUNTER-TEXT-P"))

(defvar *dummy-fn* (lambda (&rest args) (declare (ignore args)) :sa0-dummy)
  "One shared dummy closure, so 'still bound to the dummy' is an EQ test.")

(defun sa0-package () (find-package '#:lisp-plus-surface-account))

(defun sa0-call (name &rest args)
  (let ((s (find-symbol (string name) (sa0-package))))
    (unless (and s (fboundp s)) (error "~a is not callable" name))
    (apply s args)))

(defun external-names ()
  (let ((names '()))
    (do-external-symbols (s (sa0-package)) (push (symbol-name s) names))
    (sort names #'string<)))

(defun statuses (names)
  (mapcar (lambda (n) (nth-value 1 (find-symbol n (sa0-package)))) names))

(defun lawful-hex-p (text)
  (and (stringp text) (= 32 (length text))
       (every (lambda (c) (find c "0123456789abcdef")) text)))

(defun repaired-real-lane-checks (label pre-symbols)
  "The shared end-state battery: after LABEL's repair, the lane must be the
REAL nine-external production lane, never dummies."
  (check (format nil "~a: the export census is EXACTLY the nine declared names" label)
         (lambda () (equal (external-names)
                           (sort (copy-list *api-names*) #'string<))))
  (check (format nil "~a: every declared name has FIND-SYMBOL status :EXTERNAL" label)
         (lambda () (every (lambda (s) (eq s :external)) (statuses *api-names*))))
  (when pre-symbols
    (check (format nil "~a: repair PRESERVED symbol identity (exported the existing symbols, replaced none)" label)
           (lambda ()
             (every (lambda (pre)
                      (eq pre (find-symbol (symbol-name pre) (sa0-package))))
                    pre-symbols)))
    (check (format nil "~a: NO export is still bound to the pre-created dummy — every dummy was rebound to the REAL implementation" label)
           (lambda ()
             (notany (lambda (pre) (and (fboundp pre)
                                        (eq (fdefinition pre) *dummy-fn*)))
                     pre-symbols))))
  (check (format nil "~a: the identity carrier symbol is PRESENT (the implementation was actually read)" label)
         (lambda () (and (find-symbol "SA0-IDENTITY-CARRIER" (sa0-package)) t)))
  (check (format nil "~a: the REAL mechanism answers — ready, one gathering, one election" label)
         (lambda () (and (eq t (sa0-call '#:identity-ready-p))
                         (= 1 (sa0-call '#:epoch-gatherings))
                         (= 1 (sa0-call '#:election-count)))))
  (check (format nil "~a: the epoch is 32 lowercase ASCII hex (no dummy can mint this)" label)
         (lambda () (lawful-hex-p (sa0-call '#:image-epoch-hex))))
  (check (format nil "~a: the first mint is counter 1 and satisfies the shape law" label)
         (lambda ()
           (multiple-value-bind (datum counter)
               (sa0-call '#:mint-performance-identifier)
             (and (= 1 counter)
                  (eq t (sa0-call '#:performance-identifier-shape-p datum)))))))

(defun repeat-noop-checks (label epoch next-counter)
  "After a lawful repeat load: no regather, epoch unchanged, counter continues."
  (check (format nil "~a: NO second gathering (epoch-gatherings still 1)" label)
         (lambda () (= 1 (sa0-call '#:epoch-gatherings))))
  (check (format nil "~a: the epoch text is byte-identical (no re-initialization)" label)
         (lambda () (string= epoch (sa0-call '#:image-epoch-hex))))
  (check (format nil "~a: the counter CONTINUES at ~d (no allocation reset)" label next-counter)
         (lambda () (= next-counter
                       (nth-value 1 (sa0-call '#:mint-performance-identifier))))))

(defun load-lane-via-asdf ()
  (require :asdf)
  (funcall (intern "INITIALIZE-SOURCE-REGISTRY" :asdf)
           `(:source-registry (:directory ,(namestring *lane-root*))
             :inherit-configuration))
  (funcall (intern "LOAD-SYSTEM" :asdf) "lisp-plus/surface-account"))

;;; ---------------------------------------------------------------------------
;;; Precondition builders — each RETURNS the list of pre-created symbols.

(defun plant-internal-dummies ()
  "The owner's counterexample: package pre-created, nine INTERNAL fbound dummies."
  (make-package '#:lisp-plus-surface-account :use '(#:common-lisp))
  (mapcar (lambda (n)
            (let ((s (intern n '#:lisp-plus-surface-account)))
              (setf (fdefinition s) *dummy-fn*)
              s))
          *api-names*))

(defparameter *partial-names*
  '("INITIALIZE-IMAGE-IDENTITY" "IDENTITY-READY-P" "IMAGE-EPOCH-HEX"
    "LAWFUL-COUNTER-TEXT-P")
  "The strict subset the partial-external case pre-creates as external dummies.")

(defun plant-partial-external ()
  (make-package '#:lisp-plus-surface-account :use '(#:common-lisp))
  (mapcar (lambda (n)
            (let ((s (intern n '#:lisp-plus-surface-account)))
              (setf (fdefinition s) *dummy-fn*)
              (export s '#:lisp-plus-surface-account)
              s))
          *partial-names*))

;;; ---------------------------------------------------------------------------

(defun case-internal-dummies ()
  (let ((pre (plant-internal-dummies)))
    (check "precondition: nine INTERNAL fbound dummies, ZERO externals (the owner's exact pre-created package)"
           (lambda () (and (= 9 (length pre))
                           (null (external-names))
                           (every (lambda (s) (eq s :internal)) (statuses *api-names*))
                           (every (lambda (s) (eq (fdefinition s) *dummy-fn*)) pre))))
    (check "the umbrella-guarded ASDF lane load COMPLETES (the fixed guard refuses to certify the dummies and repairs instead)"
           (lambda () (load-lane-via-asdf) t))
    (repaired-real-lane-checks "after ASDF repair" pre)
    (let ((epoch (sa0-call '#:image-epoch-hex)))
      (check "a subsequent EXPLICIT lane load completes (the second half of the counterexample: it must be a lawful no-op over the REAL lane, not over dummies)"
             (lambda () (load *loader*) t))
      (repeat-noop-checks "after the explicit lane load" epoch 2))))

(defun case-partial-external ()
  (let ((pre (plant-partial-external)))
    (check "precondition: a PARTIAL external API — four external fbound dummies, five names entirely absent"
           (lambda () (and (equal (external-names)
                                  (sort (copy-list *partial-names*) #'string<))
                           (every (lambda (n) (null (find-symbol n (sa0-package))))
                                  (set-difference *api-names* *partial-names*
                                                  :test #'string=)))))
    (check "the direct lane loader COMPLETES over the partial package (repair, not skip)"
           (lambda () (load *loader*) t))
    (repaired-real-lane-checks "after partial repair" pre)))

(defun case-empty-package ()
  (make-package '#:lisp-plus-surface-account :use '(#:common-lisp))
  (check "precondition: an existing EMPTY namesake package — zero symbols of its own, zero externals"
         (lambda ()
           (let ((count 0))
             (do-symbols (s (sa0-package))
               (when (eq (symbol-package s) (sa0-package)) (incf count)))
             (and (zerop count) (null (external-names))))))
  (check "the direct lane loader COMPLETES over the empty package (the case the absent-only skip could NEVER repair)"
         (lambda () (load *loader*) t))
  (repaired-real-lane-checks "after empty-package repair" nil))

(defun case-repeat-after-repair ()
  (let ((pre (plant-internal-dummies)))
    (check "precondition: the hardest repairable state (nine internal fbound dummies) installed"
           (lambda () (and (= 9 (length pre)) (null (external-names)))))
    (check "first direct load REPAIRS (ready, one gathering)"
           (lambda () (load *loader*)
             (and (eq t (sa0-call '#:identity-ready-p))
                  (= 1 (sa0-call '#:epoch-gatherings)))))
    (let ((epoch (sa0-call '#:image-epoch-hex)))
      (check "post-repair allocations begin at 1 and continue to 2"
             (lambda () (and (= 1 (nth-value 1 (sa0-call '#:mint-performance-identifier)))
                             (= 2 (nth-value 1 (sa0-call '#:mint-performance-identifier))))))
      (check "second direct load COMPLETES (lawful repeat)"
             (lambda () (load *loader*) t))
      (repeat-noop-checks "after the second direct load" epoch 3)
      (check "the election log is UNCHANGED by the repeats (still exactly one election)"
             (lambda () (= 1 (sa0-call '#:election-count))))
      (check "an ASDF lane-system load after repair COMPLETES (the umbrella guard sees completeness)"
             (lambda () (load-lane-via-asdf) t))
      (repeat-noop-checks "after the ASDF repeat" epoch 4))))

;;; ---------------------------------------------------------------------------

(let ((case-fn (intern (string-upcase (format nil "case-~a" *case*)) :cl-user)))
  (if (fboundp case-fn)
      (funcall case-fn)
      (progn (format t "!! unknown SA0_LOADER_CASE ~s~%" *case*)
             (sb-ext:exit :code 2))))

(when (equal (sb-ext:posix-getenv "SA0_LOADER_PLANT_FAULT") "1")
  (check "PLANTED FAULT (SA0_LOADER_PLANT_FAULT=1): this check must FAIL"
         (lambda () nil)))

(format t "~%surface-account-loader-witness[~a]: ~D checks, ~D failures~%"
        *case* *checks* *failures*)
(sb-ext:exit :code (if (zerop *failures*) 0 1))
