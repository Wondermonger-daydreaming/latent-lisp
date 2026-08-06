;;;; surface-account-selftest.lisp — Surface Account /0 production self-test.
;;;;
;;;; Run:  sbcl --script mneme/language-surface-account-0/production/surface-account-selftest.lisp
;;;; from the latent-lisp root (any cwd works: paths resolve from this file).
;;;; Exit 0 iff every check passed.  Final sentinel:
;;;;   surface-account-selftest: <N> checks, <F> failures
;;;;
;;;; WHAT THIS EXERCISES — through the PUBLIC production package only (the
;;;; one exception is stated where it stands):
;;;;   A. package/API ledger (exact export census, correct kinds);
;;;;   B. load-time once-only initialization observed from outside
;;;;      (ready, one gathering, one election);
;;;;   C. the epoch laws (32 lowercase ASCII hex; CD/0 bytes datum whose
;;;;      octets project to exactly that text);
;;;;   D. monotonic allocation and the exact encoded performance path;
;;;;   E. the canonical ASCII decimal counter law (R3.3-C), including the
;;;;      runtime DIGIT-CHAR-P defect EXHIBITED and the four ruled non-ASCII
;;;;      code points + mixed spellings refused;
;;;;   F. shape-predicate refusals on REAL datums built through the public
;;;;      CD/0 API (a predicate that has never refused anything is untested);
;;;;   G. sequential reload persistence in THIS image (same epoch, no second
;;;;      gathering, counter continues);
;;;;   H. refusal-text law (plain error, exact greppable prefix, no
;;;;      condition class) — via the one internal call this file makes,
;;;;      disclosed at the check.
;;;;
;;;; NOT here (fresh images required): contention, hostile schedules,
;;;; recursive load, pre-publication failure, carrier hostilities — see
;;;; run-hostile-profiles.sh.  Mutation sensitivity: surface-account-disease.sh.
;;;;
;;;; Gate tooth: SA0_SELFTEST_PLANT_FAULT=1 plants one failing check and the
;;;; run must exit 1 (proves this harness can fail).
;;;;
;;;; — FABER (Claude Fable 5), R4, 2026-08-06

(load (merge-pathnames "load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(defpackage #:surface-account-selftest
  (:use #:cl))
(in-package #:surface-account-selftest)

(defvar *checks* 0)
(defvar *failures* 0)
(defvar *section* "A"
  "R4.1 (QUARTERMASTER F4): the section letter is emitted in every check ID
so a reviewer holding only the transcript can map IDs to the sections the
return cites.  Numbering stays global (the sentinel count is unchanged).")

(defun check (description thunk)
  (incf *checks*)
  (let ((outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (c) (list :error c)))))
    (if (eq outcome :ok)
        (format t "[~a~3,'0d] ok   ~a~%" *section* *checks* description)
        (progn (incf *failures*)
               (format t "[~a~3,'0d] FAIL ~a~@[ (~a)~]~%" *section* *checks* description
                       (when (consp outcome) (second outcome)))))))

(defun expects-error (description thunk &key substring)
  "PASS iff THUNK signals an ERROR whose report contains SUBSTRING."
  (check description
         (lambda ()
           (handler-case (progn (funcall thunk) nil)
             (error (c)
               (let ((text (princ-to-string c)))
                 (or (null substring) (search substring text))))))))

(defmacro sa0 (name &rest args)
  `(funcall (intern ,(string name) :lisp-plus-surface-account) ,@args))

;;; ---- A. package/API ledger ------------------------------------------------

(setf *section* "A")

(defparameter *declared-exports*
  '("INITIALIZE-IMAGE-IDENTITY" "IDENTITY-READY-P" "IMAGE-EPOCH-HEX"
    "IMAGE-EPOCH-DATUM" "EPOCH-GATHERINGS" "ELECTION-COUNT"
    "MINT-PERFORMANCE-IDENTIFIER" "PERFORMANCE-IDENTIFIER-SHAPE-P"
    "LAWFUL-COUNTER-TEXT-P")
  "The design ledger's nine, verbatim.  The census below is measured against
this list in BOTH directions.")

(check "package LISP-PLUS-SURFACE-ACCOUNT exists"
       (lambda () (find-package :lisp-plus-surface-account)))

(let ((actual '()))
  (do-external-symbols (s :lisp-plus-surface-account)
    (push (symbol-name s) actual))
  (setf actual (sort actual #'string<))
  (check "export census: exactly the nine declared symbols, no more, no fewer"
         (lambda () (equal actual (sort (copy-list *declared-exports*) #'string<))))
  (check "every export is FBOUNDP (all nine are functions; no variable/macro/condition export)"
         (lambda ()
           (every (lambda (n)
                    (let ((s (find-symbol n :lisp-plus-surface-account)))
                      (and s (fboundp s) (not (macro-function s))
                           (not (boundp s)))))
                  *declared-exports*))))

;;; ---- B. load-time once-only initialization --------------------------------

(setf *section* "B")

(check "identity-ready-p is true after load-time initialization"
       (lambda () (sa0 #:identity-ready-p)))
(check "epoch-gatherings = 1 (exactly one gathering)"
       (lambda () (= 1 (sa0 #:epoch-gatherings))))
(check "election-count = 1 (exactly one election, image-wide log)"
       (lambda () (= 1 (sa0 #:election-count))))
(check "initialize-image-identity in an initialized image returns :OBSERVED"
       (lambda () (eq :observed (sa0 #:initialize-image-identity))))
(check "…and observing did not add a gathering or an election"
       (lambda () (and (= 1 (sa0 #:epoch-gatherings))
                      (= 1 (sa0 #:election-count)))))

;;; ---- C. the epoch laws ----------------------------------------------------

(setf *section* "C")

(let ((hex (sa0 #:image-epoch-hex)))
  (check "image-epoch-hex is a 32-character string"
         (lambda () (and (stringp hex) (= 32 (length hex)))))
  (check "…every character from the exact lowercase ASCII hex alphabet"
         (lambda () (every (lambda (c) (find c "0123456789abcdef")) hex)))
  (check "image-epoch-hex is stable across calls (same image, same text)"
         (lambda () (string= hex (sa0 #:image-epoch-hex))))
  (check "image-epoch-datum is a CD/0 bytes datum"
         (lambda () (lisp-plus-cd0:bytes-datum-p (sa0 #:image-epoch-datum))))
  (check "…whose sixteen octets project to exactly the epoch text"
         (lambda ()
           (let ((octets (lisp-plus-cd0:bytes-datum-value
                          (sa0 #:image-epoch-datum))))
             (and (= 16 (length octets))
                  (string= hex
                           (with-output-to-string (s)
                             (loop for o across octets
                                   do (format s "~(~2,'0x~)" o)))))))))

;;; ---- D. monotonic allocation & the exact encoded path ---------------------

(setf *section* "D")

(let ((mints (loop repeat 5
                   collect (multiple-value-list
                            (sa0 #:mint-performance-identifier)))))
  (check "five mints return strictly consecutive counters"
         (lambda ()
           (let ((counters (mapcar #'second mints)))
             (equal counters
                    (loop for k from (first counters)
                          repeat 5 collect k)))))
  (check "every minted datum satisfies performance-identifier-shape-p"
         (lambda ()
           (every (lambda (m) (sa0 #:performance-identifier-shape-p (first m)))
                  mints)))
  (check "exact encoding: namespace (lisp-plus-surface-account), path (performance <epoch> <counter>)"
         (lambda ()
           (every (lambda (m)
                    (let ((d (first m)) (c (second m)))
                      (and (= 1 (lisp-plus-cd0:identifier-datum-namespace-count d))
                           (string= "lisp-plus-surface-account"
                                    (lisp-plus-cd0:identifier-datum-namespace-segment d 0))
                           (= 3 (lisp-plus-cd0:identifier-datum-path-count d))
                           (string= "performance"
                                    (lisp-plus-cd0:identifier-datum-path-segment d 0))
                           (string= (sa0 #:image-epoch-hex)
                                    (lisp-plus-cd0:identifier-datum-path-segment d 1))
                           (string= (format nil "~D" c)
                                    (lisp-plus-cd0:identifier-datum-path-segment d 2)))))
                  mints)))
  (check "distinct mints are distinct datums by canonical octets"
         (lambda ()
           (let ((octet-texts (mapcar (lambda (m)
                                        (lisp-plus-cd0:octets-to-hex
                                         (lisp-plus-cd0:canonical-octets (first m))))
                                      mints)))
             (= (length octet-texts)
                (length (remove-duplicates octet-texts :test #'string=)))))))

;;; ---- E. the canonical ASCII decimal counter law (R3.3-C) ------------------

(setf *section* "E")

(check "lawful-counter-text-p accepts \"1\", \"10\", \"907\""
       (lambda () (and (sa0 #:lawful-counter-text-p "1")
                      (sa0 #:lawful-counter-text-p "10")
                      (sa0 #:lawful-counter-text-p "907"))))
(check "…refuses \"0\" (no allocation is numbered zero)"
       (lambda () (not (sa0 #:lawful-counter-text-p "0"))))
(check "…refuses \"007\" (leading zero: a second spelling)"
       (lambda () (not (sa0 #:lawful-counter-text-p "007"))))
(check "…refuses \"-1\", \"\", \"1 \", and a non-string"
       (lambda () (notany (lambda (x) (sa0 #:lawful-counter-text-p x))
                          (list "-1" "" "1 " 7))))

;; The runtime defect EXHIBITED, not quoted (the oracle's discipline): on
;; THIS SBCL, DIGIT-CHAR-P accepts all four ruled non-ASCII decimal code
;; points — which is exactly why the production predicate must not use it.
(defparameter *ruled-non-ascii-digits*
  (mapcar #'code-char '(#x0661 #x06F1 #x0967 #xFF11))
  "ARABIC-INDIC ONE, EXTENDED ARABIC-INDIC ONE, DEVANAGARI ONE, FULLWIDTH ONE.")

(check "EXHIBIT: this runtime's DIGIT-CHAR-P accepts all four ruled non-ASCII digits"
       (lambda () (every #'digit-char-p *ruled-non-ascii-digits*)))
(check "lawful-counter-text-p refuses each ruled non-ASCII digit standing alone"
       (lambda ()
         (notany (lambda (ch) (sa0 #:lawful-counter-text-p (string ch)))
                 *ruled-non-ascii-digits*)))
(check "…and refuses MIXED spellings with a lawful ASCII head (every character is restricted)"
       (lambda ()
         (notany (lambda (ch)
                   (sa0 #:lawful-counter-text-p
                        (concatenate 'string "1" (string ch))))
                 *ruled-non-ascii-digits*)))

;;; ---- F. shape-predicate refusals on REAL datums ---------------------------

(setf *section* "F")

(defun perf-datum (&key (namespace '("lisp-plus-surface-account"))
                        (head "performance")
                        (epoch (funcall (intern "IMAGE-EPOCH-HEX"
                                                :lisp-plus-surface-account)))
                        (counter "1")
                        (extra nil))
  (lisp-plus-cd0:make-identifier-datum
   namespace
   (append (list head epoch counter) extra)))

(check "shape-p ACCEPTS the lawful control datum built through public CD/0"
       (lambda () (sa0 #:performance-identifier-shape-p (perf-datum))))
(check "shape-p refuses a 31-hex epoch"
       (lambda () (not (sa0 #:performance-identifier-shape-p
                            (perf-datum :epoch (subseq (sa0 #:image-epoch-hex) 0 31))))))
(check "shape-p refuses a 33-hex epoch"
       (lambda () (not (sa0 #:performance-identifier-shape-p
                            (perf-datum :epoch (concatenate 'string (sa0 #:image-epoch-hex) "a"))))))
(check "shape-p refuses an UPPERCASE epoch"
       (lambda () (not (sa0 #:performance-identifier-shape-p
                            (perf-datum :epoch (string-upcase (sa0 #:image-epoch-hex)))))))
(check "shape-p refuses counter \"0\", \"007\", \"-1\", and U+0661"
       (lambda ()
         (notany (lambda (c) (sa0 #:performance-identifier-shape-p (perf-datum :counter c)))
                 (list "0" "007" "-1" (string (code-char #x0661))))))
(check "shape-p refuses a wrong namespace, wrong path head, short path, long path"
       (lambda ()
         (notany (lambda (d) (sa0 #:performance-identifier-shape-p d))
                 (list (perf-datum :namespace '("lisp-plus-surface2"))
                       (perf-datum :head "performances")
                       (lisp-plus-cd0:make-identifier-datum
                        '("lisp-plus-surface-account")
                        (list "performance" (sa0 #:image-epoch-hex)))
                       (perf-datum :extra '("9"))))))
(check "shape-p refuses a non-datum and a bytes datum"
       (lambda ()
         (notany (lambda (x) (sa0 #:performance-identifier-shape-p x))
                 (list 7 "performance" (sa0 #:image-epoch-datum)))))

;;; ---- G. sequential reload persistence (this image) ------------------------

(setf *section* "G")

(let ((epoch-before (sa0 #:image-epoch-hex))
      (counter-before (nth-value 1 (sa0 #:mint-performance-identifier))))
  (load (merge-pathnames "surface-account.lisp"
                         (make-pathname :name nil :type nil
                                        :defaults *load-truename*)))
  (check "reload of the implementation source gathers NO second epoch"
         (lambda () (= 1 (sa0 #:epoch-gatherings))))
  (check "reload preserves the epoch text byte-identically"
         (lambda () (string= epoch-before (sa0 #:image-epoch-hex))))
  (check "reload holds ONE election (log unchanged)"
         (lambda () (= 1 (sa0 #:election-count))))
  (check "the counter CONTINUES through the reload (no reset)"
         (lambda () (= (1+ counter-before)
                       (nth-value 1 (sa0 #:mint-performance-identifier)))))
  (check "a second pass through load.lisp is a guarded no-op (still one gathering)"
         (lambda ()
           (load (merge-pathnames "load.lisp"
                                  (make-pathname :name nil :type nil
                                                 :defaults *load-truename*)))
           (= 1 (sa0 #:epoch-gatherings)))))

;;; ---- H. refusal-text law --------------------------------------------------

(setf *section* "H")
;;; DISCLOSED INTERNAL CALL: the reserved-slot rejector cannot be reached
;;; through the public API in an initialized image (the carrier is lawful and
;;; terminal states need fresh images — run-hostile-profiles.sh owns those).
;;; What IS checked here through internals, narrowly: the refusal SHAPE law —
;;; a plain CL error (never a custom condition class) carrying the exact
;;; greppable production prefix.

(expects-error
 "sa0-reject-carrier signals a PLAIN error with the SURFACE-ACCOUNT/0: prefix"
 (lambda ()
   (funcall (intern "SA0-REJECT-CARRIER" :lisp-plus-surface-account) "tooth: ~a" :probe))
 :substring "SURFACE-ACCOUNT/0:")
(check "…and that refusal is SIMPLE-ERROR, not a custom condition class"
       (lambda ()
         (handler-case
             (progn (funcall (intern "SA0-REJECT-CARRIER"
                                     :lisp-plus-surface-account) "tooth")
                    nil)
           (simple-error () t)
           (error () nil))))

;;; ---- planted harness tooth ------------------------------------------------

(when (equal (sb-ext:posix-getenv "SA0_SELFTEST_PLANT_FAULT") "1")
  (check "PLANTED FAULT (SA0_SELFTEST_PLANT_FAULT=1): this check must FAIL"
         (lambda () nil)))

;;; ---- result ---------------------------------------------------------------

(format t "~%surface-account-selftest: ~D checks, ~D failures~%"
        *checks* *failures*)
(sb-ext:exit :code (if (zerop *failures*) 0 1))
