;;;; ma0-concordance-canonical.lisp — THE CANONICAL SIDE of the concordance
;;;; teeth (FAILURE MATRIX §3, contract §4).
;;;;
;;;;   sbcl --script mneme/language-many-acts-0/ma0-concordance-canonical.lisp
;;;;
;;;; CANDIDATE.  Executing a candidate is not adopting it (contract §0, §8), and
;;;; nothing this file prints is independent verification (AP0 adoption Rider 2).
;;;;
;;;; ---------------------------------------------------------------------------
;;;; WHAT THIS IMAGE IS
;;;; ---------------------------------------------------------------------------
;;;;
;;;; The canonical arm, harvested from the ADOPTED path and from nothing else:
;;;; `lisp-plus-language-act0:run-all-arms', run once, in a fresh image, in a
;;;; fresh store, with MANY ACTS /0 NEVER LOADED.  The ASDF system entered here
;;;; is `lisp-plus/act0'; the string "many-acts" does not name a system this
;;;; image asks for.  A canonical side that borrowed the candidate's own
;;;; environment door would be comparing the candidate with itself.
;;;;
;;;; ⚠ ONE REPLICATION, DECLARED, AND IT IS NOT THE COMPOSITION.  `setup-run'
;;;; (act0-gates.lisp:485-497) and `journal-opening-authority' (act0.lisp:
;;;; 1218-1237) are INTERNAL to #:lisp-plus-language-act0, so this file cannot
;;;; call them and does not.  It re-expresses the SETUP — the five run-state
;;;; specials and the opening grant/revocation events — through EXPORTED
;;;; operations, with the lines cited.  What it does NOT re-express is
;;;; `finish-act', the act completion whose concordance is the whole question:
;;;; that runs INSIDE `run-all-arms', canonically, untouched.
;;;;
;;;; The setup replication is itself auditable rather than trusted: the
;;;; comparator runs the lane's own accepted runner (`act0-selftest.lisp') and
;;;; requires the facts harvested here to agree with the facts that runner
;;;; prints from ONE ACT /0's OWN setup.  A replication nobody compares is a
;;;; second implementation wearing the first one's name.
;;;;
;;;; ⚠ NO UNEXPORTED SYMBOL OF ANY PREDECESSOR PACKAGE IS REFERENCED HERE, and
;;;; this file does not enter any predecessor's package to reach one by the
;;;; side door.  It stays in #:cl-user.
;;;;
;;;; ⚠ DIGESTS ARE NOT COMPARED ACROSS STORES AND ARE NOT PRINTED HERE.
;;;; Journal /0's per-event digest is PREFIX-CHAINED, not a content address, so
;;;; the same frame bytes in two stores digest differently.  What this file
;;;; emits is STRUCTURE and VERDICTS.
;;;;
;;;; STDOUT is the harvest: lines of the form
;;;;   DENS-CANON <arm> <facet>=<value>
;;;; and nothing else on that prefix.  Everything unstable goes to stderr.
;;;;
;;;; — DENS (Claude Opus 5, subagent), 2026-08-09

(require :asdf)
(require :sb-posix)

(unless (string= (lisp-implementation-version) "2.4.6")
  (format *error-output*
          "~&!! FAIL CLOSED: authorized for SBCL 2.4.6 only.  Observed ~a.~%"
          (lisp-implementation-version))
  (finish-output *error-output*)
  (sb-ext:exit :code 1))

(defparameter cl-user::*dens-here*
  (make-pathname :name nil :type nil :defaults *load-truename*))

(defparameter cl-user::*dens-tree*
  (truename (merge-pathnames "../../" cl-user::*dens-here*))
  "experiments/latent-lisp — the subject tree root.")

(defparameter cl-user::*dens-root*
  (let* ((tmp (or (sb-ext:posix-getenv "TMPDIR") "/tmp"))
         (dir (sb-posix:mkdtemp
               (concatenate 'string (string-right-trim "/" tmp)
                            "/ma0-concord-canon.XXXXXX"))))
    (truename (concatenate 'string dir "/"))))

(let ((tree (namestring cl-user::*dens-tree*))
      (root (namestring cl-user::*dens-root*)))
  (when (and (>= (length root) (length tree))
             (string= tree (subseq root 0 (length tree))))
    (format *error-output* "~&!! FAIL CLOSED: run root ~a is INSIDE ~a~%" root tree)
    (ignore-errors (uiop:delete-directory-tree cl-user::*dens-root* :validate t))
    (finish-output *error-output*)
    (sb-ext:exit :code 1)))

(format *error-output* "~&== ma0-concordance-canonical — SBCL ~a ==~%   run root: ~a~%"
        (lisp-implementation-version) cl-user::*dens-root*)
(finish-output *error-output*)

(asdf:initialize-source-registry
 `(:source-registry (:directory ,(namestring cl-user::*dens-tree*))
   :inherit-configuration))

(let ((*standard-output* (make-broadcast-stream)))
  (asdf:load-system "lisp-plus/act0"))

(in-package #:cl-user)

;;; --------------------------------------------------------------------------
;;; §1 — the arms this campaign compares, and the emit primitive.
;;; --------------------------------------------------------------------------

(defparameter *dens-arms* '("A" "B-L1" "B-L2" "B-R" "C-i" "C-ii" "D")
  "ALL SEVEN ADOPTED ARMS (R1 §7 coverage closure).  Was four — A · C-i · C-ii ·
B-R, the arms the campaign's own programs happened to use — which meant the
lane's most serious declared risk, the re-composition, was unmeasured on three
of the seven.  `run-all-arms' returns all seven either way; the four-arm list
was the comparator declining to look at three of them, not the canonical side
declining to speak.")

(defun dens-emit (arm facet value)
  (format t "~&DENS-CANON ~a ~a=~a~%" arm facet value)
  (force-output))

;;; --------------------------------------------------------------------------
;;; §2 — the SETUP, re-expressed through exported operations.
;;;
;;; ⚠ VALUES RE-DECLARED FROM PUBLISHED SOURCE, NOT FUNCTIONS CALLED.
;;; `grant-terms-for', `capability-id-for' and `journal-opening-authority' are
;;; internal; their SOURCE is public and each line is cited.
;;; --------------------------------------------------------------------------

(defparameter +dens-subject+ '("subject" "scriba")   "act0.lisp:1156")
(defparameter +dens-action+  '("action"  "inscribere") "act0.lisp:1157")
(defparameter +dens-scope+   '("scope"   "semel")    "act0.lisp:1158")
(defparameter +dens-issuer+  '("issuer"  "oneact0")  "act0.lisp:1159")

(defun dens-idf (segments)
  (lisp-plus-journal0:identifier-from-segments segments))

(defun dens-fixture (arm)
  (or (find arm lisp-plus-language-act0:*act-fixture-table*
            :key #'lisp-plus-language-act0:act-fixture-arm :test #'string=)
      (error "no adopted fixture carries arm ~s" arm)))

(defun dens-grant-terms (fixture)
  "act0.lisp:1161-1168 — grant-terms-for."
  (list :subject (dens-idf +dens-subject+)
        :action (dens-idf +dens-action+)
        :resource (dens-idf (lisp-plus-language-act0:act-fixture-cell-segments
                             fixture))
        :scope (dens-idf +dens-scope+)))

(defun dens-capability-id (fixture)
  "act0.lisp:1170-1171 — capability-id-for."
  (list "cap" (lisp-plus-language-act0:act-fixture-runtime-seat fixture)))

(defun dens-journal-opening-authority ()
  "act0.lisp:1218-1237 — journal-opening-authority, re-expressed through the
EXPORTED append/grant/revocation constructors.  One grant per fixture of the
adopted table; arm B-R additionally carries a revocation, after its grant and
before any F1."
  (dolist (f lisp-plus-language-act0:*act-fixture-table*)
    (let ((seat (lisp-plus-language-act0:act-fixture-runtime-seat f))
          (terms (dens-grant-terms f)))
      (lisp-plus-journal0:append-event
       lisp-plus-language-act0:*store*
       (lisp-plus-capability0:make-grant-event
        :event-id (list "cap0-event" (format nil "g-~a" seat))
        :capability-id (dens-capability-id f)
        :subject (getf terms :subject) :action (getf terms :action)
        :resource (getf terms :resource) :scope (getf terms :scope)
        :issuer (dens-idf +dens-issuer+)))
      (when (string= (lisp-plus-language-act0:act-fixture-arm f) "B-R")
        (lisp-plus-journal0:append-event
         lisp-plus-language-act0:*store*
         (lisp-plus-capability0:make-revocation-event
          :event-id (list "cap0-event" (format nil "r-~a" seat))
          :capability-id (dens-capability-id f)
          :issuer (dens-idf +dens-issuer+)))))))

(defun dens-setup (root)
  "act0-gates.lisp:485-497 — setup-run, re-expressed.  W-ENV FIRST, before the
store exists.  `*minted-this-run*' and `*appended-frames*' are NOT set here:
this is a fresh image and both stand at their definition-time values, which is
the only state setup-run would have given them."
  (lisp-plus-language-act0:w-env-preflight :signal t)
  (setf lisp-plus-language-act0:*run-root* root
        lisp-plus-language-act0:*worlds*
        (lisp-plus-language-act0:build-fixture-worlds root)
        lisp-plus-language-act0:*store*
        (lisp-plus-language-act0:build-store root))
  (setf lisp-plus-language-act0:*bootstrap*
        (lisp-plus-capability0:declare-bootstrap-authority
         (dens-idf +dens-issuer+)
         (lisp-plus-journal0:journal-store-store-id
          lisp-plus-language-act0:*store*))
        lisp-plus-language-act0:*minting-context*
        (lisp-plus-capability1:make-minting-context :label "oneact0"))
  (lisp-plus-language-act0:validate-act-fixture-table)
  (dens-journal-opening-authority)
  lisp-plus-language-act0:*store*)

;;; --------------------------------------------------------------------------
;;; §3 — reading the RECORD back out of the store.
;;;
;;; Every verdict below is read from the durable frame body, not from a return
;;; value: what a cold reader sees is what gets compared.
;;; --------------------------------------------------------------------------

(defun dens-frame-body (attempt frame)
  (multiple-value-bind (ordinal digest payload)
      (lisp-plus-journal0:find-event
       lisp-plus-language-act0:*store*
       (lisp-plus-language-act0:frame-event-id frame attempt))
    (declare (ignore digest))
    (and ordinal
         (lisp-plus-journal0:record-field
          (lisp-plus-journal0:decode-pjs0 payload) "event" "body"))))

(defun dens-body-string (body field)
  (let ((datum (and body (lisp-plus-journal0:record-field body "act" field))))
    (if (and datum (lisp-plus-cd0:string-datum-p datum))
        (lisp-plus-cd0:string-datum-value datum)
        "none")))

(defun dens-frames-present (attempt)
  (loop for frame in '(:f1 :f2 :f3 :f4 :f5)
        when (lisp-plus-journal0:find-event
              lisp-plus-language-act0:*store*
              (lisp-plus-language-act0:frame-event-id frame attempt))
          collect frame))

(defun dens-act-id-hex (attempt)
  "The 64-character digest segment of this act's identity, read out of its own
durable F1 — never from a host variable."
  (let* ((body (dens-frame-body attempt :f1))
         (id (and body (lisp-plus-journal0:record-field body "act" "act-id"))))
    (if (and id (lisp-plus-cd0:identifier-datum-p id))
        (car (last (lisp-plus-journal0:identifier-segments id)))
        "none")))

;;; --------------------------------------------------------------------------
;;; §4 — the harvest.
;;; --------------------------------------------------------------------------

(defun dens-mint-refusal-from-transcript (transcript arm)
  "One Act /0's own GATE-3 check line for a mint-refused arm carries the
refusal type and requirement-id (act0-gates.lisp:516-521).  It is harvested
from the adopted runner's own words rather than re-derived here."
  (let ((needle (format nil "GATE-3 ~a: L3b mint refused " arm)))
    (with-input-from-string (in transcript)
      (loop for line = (read-line in nil nil)
            while line
            do (let ((at (search needle line)))
                 (when at
                   (return (string-trim " " (subseq line (+ at (length needle)))))))
            finally (return "none")))))

(defun dens-harvest (results transcript)
  (dolist (arm *dens-arms*)
    (let* ((fixture (dens-fixture arm))
           (attempt (lisp-plus-language-act0:act-fixture-attempt-name fixture))
           (row (find arm results :key (lambda (r) (getf r :arm)) :test #'string=))
           (present (dens-frames-present attempt))
           (absent (set-difference '(:f1 :f2 :f3 :f4 :f5) present))
           (f2 (dens-frame-body attempt :f2))
           (f3 (dens-frame-body attempt :f3))
           (f4 (dens-frame-body attempt :f4))
           (f5 (dens-frame-body attempt :f5)))
      (unless row (error "arm ~s is absent from the canonical results" arm))
      (dens-emit arm "frames-present" present)
      (dens-emit arm "frames-absent"
                 (sort absent #'string< :key #'symbol-name))
      (dens-emit arm "classification"
                 (lisp-plus-language-act0:classify-act-frames present))
      (dens-emit arm "class" (getf row :class))
      (dens-emit arm "act-id-hex" (dens-act-id-hex attempt))
      (dens-emit arm "f2-frontier" (dens-body-string f2 "frontier"))
      (dens-emit arm "f2-outcome-view" (dens-body-string f2 "outcome-view"))
      (dens-emit arm "f2-effect-axis-value"
                 (dens-body-string f2 "effect-axis-value"))
      (dens-emit arm "f2-effect-axis-determinacy"
                 (dens-body-string f2 "effect-axis-determinacy"))
      (dens-emit arm "f3-ledger-answer" (dens-body-string f3 "ledger-answer"))
      (dens-emit arm "f4-runtime-resolution"
                 (dens-body-string f4 "runtime-resolution"))
      (dens-emit arm "correspondence-row"
                 (dens-body-string f4 "correspondence-row"))
      (dens-emit arm "correspondence-verdict"
                 (dens-body-string f4 "correspondence-verdict"))
      (dens-emit arm "f5-execution-standing"
                 (dens-body-string f5 "execution-standing"))
      (dens-emit arm "f5-evidence-class" (dens-body-string f5 "evidence-class"))
      (dens-emit arm "agreement-row" (dens-body-string f5 "mapping-row"))
      (dens-emit arm "agreement-verdict"
                 (dens-body-string f5 "agreement-verdict"))
      (dens-emit arm "mint-refusal"
                 (dens-mint-refusal-from-transcript transcript arm)))))

;;; --------------------------------------------------------------------------
;;; THE RUN.
;;; --------------------------------------------------------------------------

(let ((propagated nil))
  (unwind-protect
       (handler-case
           (let (results transcript)
             (setf transcript
                   (with-output-to-string (capture)
                     (let ((*standard-output* capture))
                       (dens-setup cl-user::*dens-root*)
                       (setf results
                             (lisp-plus-language-act0:run-all-arms :verbose nil)))))
             (format *error-output* "~&---- run-all-arms transcript ----~%~a~%"
                     transcript)
             (format t "~&DENS-CANON run checks-failed=~d~%"
                     lisp-plus-language-act0:*checks-failed*)
             (format t "~&DENS-CANON run arms-returned=~d~%" (length results))
             (dens-harvest results transcript))
         (error (c)
           (setf propagated c)
           (format t "~&DENS-CANON run PROPAGATED=~s~%" (type-of c))
           (format *error-output* "~&!! ~a~%" c)))
    (ignore-errors (uiop:delete-directory-tree cl-user::*dens-root* :validate t))
    (format *error-output* "   run root removed (exists: ~a)~%"
            (and (probe-file cl-user::*dens-root*) t))
    (finish-output *error-output*))
  (format t "~&DENS-CANON run END=~a~%" (if propagated "propagated" "reached-end"))
  (finish-output)
  (sb-ext:exit :code (if propagated 1 0)))
