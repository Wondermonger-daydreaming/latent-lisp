;;;; EVIDENCE.lisp — what every instrument must say about WHAT IT MEASURED.
;;;;
;;;; ERRATA 0.3 / D6.  The stranger audit produced two BYTE-IDENTICAL transcripts,
;;;; both labelled `ff80b8f`, for two materially different subjects — a one-line
;;;; behavioural change to `surface1.lisp` that touched no declared version integer
;;;; (`FOSSOR.md` §6, F6).  The label was the repository's HEAD, which answers "what
;;;; was last committed here" and never "what is in these files".
;;;;
;;;; So every instrument now prints a CONTENT-DERIVED SUBJECT DIGEST, computed by
;;;; `errata-0.3/subject-digest.sh` over the exact-path manifest
;;;; `errata-0.3/SUBJECT-MANIFEST.txt`, and binds its first 16 hex characters into
;;;; its canonical result line as ` subject=<hex16>`.
;;;;
;;;; THE INSTRUMENT COMPUTES IT ITSELF.  It is not handed the digest by the runner
;;;; and does not read it from the environment: an instrument that trusted its
;;;; wrapper for its subject identity would be back where the audit found us, one
;;;; level up.  The wrapper computes the digest independently and REFUSES the run
;;;; unless every instrument reports the same value.
;;;;
;;;; IT FAILS CLOSED.  If the script is absent, unreadable, or exits nonzero, or if
;;;; what comes back is not 64 hex characters, this signals — the instrument dies
;;;; BEFORE its canonical result line is printed, and the wrapper sees a run with no
;;;; summary.  A digest is never guessed and never defaulted.
;;;;
;;;; WHAT IT IS NOT.  It measures the LAYER UNDER TEST — the 25 sources in the
;;;; manifest — and nothing else.  Not the instruments, not the transcripts, not the
;;;; host, not the image.  It is an ACCOUNT of which bytes were loaded, never an
;;;; AUTHENTICATION that those bytes were the right ones.

(defpackage #:surface1-evidence
  (:use #:common-lisp)
  (:export #:subject-digest #:subject-short #:advisory-label #:print-evidence-header
           #:*digest*))

(in-package #:surface1-evidence)

(defparameter *digest* (make-hash-table :test #'equal)
  "Memoised full 64-hex digests, keyed by measured subject directory.")

;;; SUBJECT-NEUTRALITY, PRESERVED.  The two reproduction instruments are pointed at
;;; an arbitrary candidate directory by argv[1] and must run unchanged against an
;;; OLDER subject that has no `errata-0.3/` in it at all — otherwise a before/after
;;; comparison measures two instruments instead of two candidates.  So the TOOL comes
;;; from the instrument's own tree (TOOLS-HOME) and the SUBJECT is passed to it as an
;;; argument.  The measuring apparatus travels; the measured tree does not have to
;;; carry it.
(defun %as-directory (p)
  "The DIRECTORY a pathname designates, whether it was handed to us as a directory,
as a file inside one, or as a `../`-relative expression that still carries a name.
Callers pass `*load-truename*` (a file) and `(merge-pathnames \"../\" …)` (a file
name under a parent) as freely as they pass a real directory; a digest tool handed a
FILE where a DIRECTORY was meant must not silently produce something — it produced
a hard failure here once, which is the right failure, and this is the right fix."
  (truename (make-pathname :name nil :type nil :version nil :defaults (pathname p))))

(defun %run-digest (subject-dir tools-home)
  (let* ((script (merge-pathnames "errata-0.3/subject-digest.sh"
                                  (%as-directory tools-home)))
         (out (make-string-output-stream))
         (err (make-string-output-stream))
         (proc (handler-case
                   (sb-ext:run-program "bash" (list (namestring script)
                                                    (namestring (%as-directory subject-dir)))
                                       :search t :output out :error err :wait t)
                 (error (e)
                   (error "SUBJECT DIGEST UNAVAILABLE: could not run ~A (~A)"
                          (namestring script) e))))
         (code (sb-ext:process-exit-code proc))
         (text (string-trim '(#\Space #\Tab #\Newline #\Return)
                           (get-output-stream-string out))))
    (unless (eql code 0)
      (error "SUBJECT DIGEST UNAVAILABLE: ~A exited ~S~%~A"
             (namestring script) code (get-output-stream-string err)))
    (unless (and (= (length text) 64)
                 (every (lambda (c) (find c "0123456789abcdef")) text))
      (error "SUBJECT DIGEST MALFORMED: ~S" text))
    text))

(defun subject-digest (subject-dir &optional (tools-home subject-dir))
  "The full 64-hex content-derived digest of the subject rooted at SUBJECT-DIR,
computed by the digest script under TOOLS-HOME.  Signals rather than returning
anything provisional."
  (let ((key (namestring (%as-directory subject-dir))))
    (or (gethash key *digest*)
        (setf (gethash key *digest*) (%run-digest subject-dir tools-home)))))

(defun subject-short (subject-dir &optional (tools-home subject-dir))
  (subseq (subject-digest subject-dir tools-home) 0 16))

(defun advisory-label (&optional supplied)
  "A human/git label.  ADVISORY: it is whatever somebody passed in, and the audit
showed exactly this kind of label surviving a change of subject unaltered."
  (or supplied
      (sb-ext:posix-getenv "SURFACE1_SUBJECT_LABEL")
      "(none supplied)"))

(defun print-evidence-header (subject-dir &key label (tools-home subject-dir)
                                               (stream *standard-output*))
  "The lines every Surface /1 instrument owes its reader before it reports anything."
  (format stream "subject-digest  ~A~%" (subject-digest subject-dir tools-home))
  (format stream "                content-derived: sha256 over the 25 exact-path~%")
  (format stream "                members of errata-0.3/SUBJECT-MANIFEST.txt,~%")
  (format stream "                each bound to its path.  MEASURES the layer under~%")
  (format stream "                test; NOT the instruments, transcripts, or host.~%")
  (format stream "subject-label   ~A~%" (advisory-label label))
  (format stream "                ADVISORY ONLY — a human or git label, never a~%")
  (format stream "                measurement of content (FOSSOR F6).~%"))
