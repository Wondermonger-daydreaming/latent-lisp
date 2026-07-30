;;;; finalizer.lisp — derived artifacts over a completed run (contract §11).
;;;;
;;;; Run:  sbcl --script mneme/vertical0/reconstruction/finalizer.lisp \
;;;;         <workspace-exec-dir>
;;;; from the latent-lisp root.  Exit 0 iff the derived artifacts were
;;;; written.
;;;;
;;;; WHAT A FINALIZER IS ALLOWED TO BE.  "Finalizer: may add indexes,
;;;; checksums, renderings, human summaries, canonical export bundles —
;;;; never a unique primary fact."  Everything below is a re-presentation
;;;; of something already durable: the index NAMES primary artifacts, the
;;;; checksums DIGEST them, the summary RENDERS the census the census
;;;; procedure derived, the export bundle RE-ENCODES it.  If any line of
;;;; this file ever became the only place a fact lived, the deletion proof
;;;; in run-reconstruction-gate.lisp would fail — which is the point of
;;;; having the proof rather than this paragraph.
;;;;
;;;; WORKSPACE ONLY.  This program is run over a COPY of a completed run.
;;;; It writes only inside <workspace-exec-dir>/derived/ and never touches
;;;; the campaign's own store, evidence, or config.  The gate never points
;;;; it at runs/campaign-1/exec.
;;;;
;;;; NAMED-CELL LOCALIZATION (contract §11).  The three caches below are
;;;; NAMED SPECIAL VARIABLES, on purpose.  A diagnostic run MAKUNBOUNDs
;;;; them and re-runs reconstruction: an illicit dependency cannot hide,
;;;; because it must signal UNBOUND-VARIABLE whose CELL-ERROR-NAME spells
;;;; the finalizer-only symbol out loud.  The tooth supplements the
;;;; fresh-process deletion proof; it never replaces it.
;;;;
;;;; DETERMINISM: no wall-clock, no pid, no absolute path, no directory
;;;; enumeration order.  Artifact order is DECLARED (a fixed primary list)
;;;; or JOURNAL order (the evidence custody records).
;;;;
;;;; TEETH: VERTICAL0_FINALIZER_PLANT_FACT=1 plants a fabricated seat
;;;; ("seat-phantom-quill") in the derived artifacts and nowhere else — a
;;;; finalizer-only "primary fact", alive so the gate can kill it.
;;;;
;;;; — TALLYARD (Claude Fable 5 subagent), 2026-07-30

(load (merge-pathnames "load-census-only.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(defpackage #:lisp-plus-vertical0-finalizer
  (:use #:cl)
  (:export #:*finalizer-index-cache*
           #:*finalizer-summary-cache*
           #:*finalizer-export-cache*
           #:finalize-run
           #:derived-relative-paths
           #:phantom-seat-name
           #:main))

(in-package #:lisp-plus-vertical0-finalizer)

;;; ---------------------------------------------------------------------------
;;; The named cells.  Finalizer-only by construction: nothing outside this
;;; file binds, reads, or needs them.

(defvar *finalizer-index-cache* nil
  "The index lines of the last FINALIZE-RUN.  Finalizer-only.")
(defvar *finalizer-summary-cache* nil
  "The summary lines of the last FINALIZE-RUN.  Finalizer-only.")
(defvar *finalizer-export-cache* nil
  "The canonical export octets of the last FINALIZE-RUN.  Finalizer-only.")

(defun phantom-seat-name () "seat-phantom-quill")

(defun derived-relative-paths ()
  "Every path this finalizer creates — the exact deletion list the proof
removes.  Declared, not enumerated."
  (list "derived/INDEX.md"
        "derived/SHA256SUMS"
        "derived/SUMMARY.md"
        "derived/export-bundle.pjs"))

(defun primary-relative-paths ()
  "The primary durable artifacts an index may NAME (never author).
Declared order — never a directory listing."
  (list "VERTICAL-PROGRAM-CONFIG.sexp"
        "store/JOURNAL-META.pjs"
        "store/JOURNAL-META.pjs.sha256"
        "store/EVENTS.pj0"
        "world/CELLS.txt"
        "world/REQUEST-LEDGER.txt"
        "fake-world/provider-domain.sexp"))

;;; ---------------------------------------------------------------------------

(defun directory-of (namestring)
  (pathname (concatenate 'string namestring
                         (if (char= #\/ (char namestring
                                              (1- (length namestring))))
                             "" "/"))))

(defun slurp (pathname)
  (with-open-file (stream pathname :direction :input
                                   :element-type '(unsigned-byte 8))
    (let ((buffer (make-array (file-length stream)
                              :element-type '(unsigned-byte 8))))
      (read-sequence buffer stream)
      buffer)))

(defun spit-lines (pathname lines)
  (ensure-directories-exist pathname)
  (with-open-file (stream pathname :direction :output
                                   :external-format :utf-8
                                   :if-exists :supersede
                                   :if-does-not-exist :create)
    (dolist (line lines) (write-line line stream))))

(defun spit-octets (pathname octets)
  (ensure-directories-exist pathname)
  (with-open-file (stream pathname :direction :output
                                   :element-type '(unsigned-byte 8)
                                   :if-exists :supersede
                                   :if-does-not-exist :create)
    (write-sequence octets stream)))

(defun evidence-relative-paths (store)
  "Captured-evidence paths in JOURNAL order (the custody records), never
in directory order."
  (loop for event in (lisp-plus-vertical0::collect-events
                      (lisp-plus-vertical0::validated-events store)
                      :kind "vertical-record:envelope-custody")
        collect (lisp-plus-vertical0::body-string
                 (lisp-plus-vertical0::event-body event)
                 "vertical" "evidence-file")))

;;; ---------------------------------------------------------------------------

(defun finalize-run (workspace-exec-namestring)
  "Build the derived artifacts over the workspace copy.  Returns the list
of relative paths written."
  (let* ((exec (directory-of workspace-exec-namestring))
         (planted (and (sb-ext:posix-getenv "VERTICAL0_FINALIZER_PLANT_FACT")
                       t))
         (config (lisp-plus-vertical0:read-vertical-config
                  (merge-pathnames "VERTICAL-PROGRAM-CONFIG.sexp" exec)))
         (store (lisp-plus-journal0:open-store
                 (merge-pathnames "store/" exec))))
    (multiple-value-bind (census outcomes)
        (lisp-plus-vertical0:derive-census
         store config :derivation-origin "reconstructed")
      (let* ((primary (append (primary-relative-paths)
                              (evidence-relative-paths store)))
             (index
               (append
                (list "# INDEX — Vertical Specimen /0, derived by finalizer"
                      ""
                      "Every line below NAMES a primary durable artifact."
                      "The finalizer authors no primary fact; deleting this"
                      "file loses nothing the journal does not still hold."
                      ""
                      "## primary artifacts (declared order)")
                (mapcar (lambda (relative) (format nil "- ~a" relative))
                        primary)
                (list ""
                      "## derived artifacts (this finalizer's own output)")
                (mapcar (lambda (relative) (format nil "- ~a" relative))
                        (derived-relative-paths))
                (when planted
                  (list ""
                        "## PLANTED FINALIZER-ONLY FACT (teeth)"
                        (format nil "- seat ~a :manifestation present ~
                                     :effect settled"
                                (phantom-seat-name))))))
             (sums
               (loop for relative in primary
                     collect (format nil "~a  ~a"
                                     (lisp-plus-journal0:sha256-hex
                                      (slurp (merge-pathnames relative exec)))
                                     relative)))
             (summary
               (append
                (list "# SUMMARY — the twelve seats, as the census derived them"
                      ""
                      "Rendering only.  Each row restates a census outcome"
                      "that vertical-census-0 derived from durable evidence."
                      "")
                (mapcar
                 (lambda (outcome)
                   (format nil "- ~a: manifestation=~a~@[ effect=~a~]~
                                ~@[ absence-state=~a~]~@[ refusal=~a~]~
                                ~@[ chunks-preserved=~a~]~
                                ~@[ projection-origin=~a~]"
                           (getf outcome :seat)
                           (getf outcome :manifestation)
                           (getf outcome :effect)
                           (getf outcome :absence-state)
                           (getf outcome :refusal)
                           (getf outcome :chunks-preserved)
                           (getf outcome :projection-origin)))
                 outcomes)
                (when planted
                  (list (format nil "- ~a: manifestation=present effect=settled"
                                (phantom-seat-name))))))
             (export-octets
               (let ((base (lisp-plus-journal0:encode-pjs0 census)))
                 (if planted
                     (concatenate '(vector (unsigned-byte 8))
                                  base
                                  (map '(vector (unsigned-byte 8)) #'char-code
                                       (format nil "~%;; PLANTED FINALIZER-ONLY ~
                                                    FACT: seat ~a present~%"
                                               (phantom-seat-name))))
                     base))))
        ;; The named cells: populated here, read nowhere else in the lane.
        (setf *finalizer-index-cache* index
              *finalizer-summary-cache* summary
              *finalizer-export-cache* export-octets)
        (spit-lines (merge-pathnames "derived/INDEX.md" exec)
                    *finalizer-index-cache*)
        (spit-lines (merge-pathnames "derived/SHA256SUMS" exec) sums)
        (spit-lines (merge-pathnames "derived/SUMMARY.md" exec)
                    *finalizer-summary-cache*)
        (spit-octets (merge-pathnames "derived/export-bundle.pjs" exec)
                     *finalizer-export-cache*)
        (values (derived-relative-paths) (length outcomes) planted)))))

(defun main ()
  (let ((arguments (rest sb-ext:*posix-argv*)))
    (unless (= 1 (length arguments))
      (format *error-output* "usage: finalizer.lisp <workspace-exec-dir>~%")
      (sb-ext:exit :code 2))
    (handler-case
        (multiple-value-bind (written seats planted)
            (finalize-run (first arguments))
          (format t "finalizer: derived artifacts over a workspace copy~%")
          (format t "  seats rendered     ~a~%" seats)
          (format t "  artifacts written  ~a~%" (length written))
          (dolist (relative written) (format t "    ~a~%" relative))
          (format t "  planted finalizer-only fact  ~a~%"
                  (if planted "YES (teeth)" "no"))
          (format t "RESULT: FINALIZED~%")
          (sb-ext:exit :code 0))
      (error (condition)
        (format *error-output* "finalizer: ~a~%" condition)
        (sb-ext:exit :code 2)))))

(unless (sb-ext:posix-getenv "VERTICAL0_FINALIZER_LIBRARY")
  (main))
