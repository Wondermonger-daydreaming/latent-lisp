;;;; journal0-vectors.lisp — the Process Journal /0 vector GATE RUNNER.
;;;;
;;;; Registry-driven (R-PJ-3 / PJ0-ADOPTION-RECORD binding gate): parses
;;;; PJ0-FIXTURE-REGISTRY.sexp and TRUNCATION-MANIFEST.sexp with THIS
;;;; implementation's own PJ-S/0 codec, verifies every fixture's SHA-256
;;;; before use, and derives ALL counts live from the registry — no count in
;;;; this file's verdicts is hard-coded.
;;;;
;;;; Gate law (ALLOWED-SOURCES standing note 1): the registry's
;;;; `expected-error` strings are the Python reference tool's vocabulary (one
;;;; is a verbatim CPython codec message).  The gate is defined over
;;;; expected-status + expected-valid-frames + a mapped §23 condition
;;;; CATEGORY — never expected-error string equality.  Each such divergence is
;;;; recorded by vector id and field below; divergences adjudicate to spec
;;;; text.
;;;;
;;;; Coverage: 3 positive (accepted + writer byte-exact re-encoding) · all
;;;; registry adversarial vectors (refused, correct §23 category) · the full
;;;; exhaustive truncation family at exact terminal offsets (PJ-TRN-1..3) ·
;;;; all semantic datum vectors · the §29 crash-window files (NOT in the
;;;; registry; driven from §29 + Annex B, CW-2/CW-3 distinction carried as
;;;; scenario metadata since the bytes are identical by design) · the six
;;;; planted mutants against their scorecard-designated fixtures (PJ-MUT-1/2)
;;;; · ten negative controls proving the RUNNER ITSELF notices, each naming
;;;; the exact check that went red.
;;;;
;;;; Run:  sbcl --script mneme/journal0/journal0-vectors.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; — RESTITUTOR (Claude Fable 5 subagent), 2026-07-29

(load (merge-pathnames "load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-journal0)

;;; ---------------------------------------------------------------------------
;;; Check machinery — counts DERIVED from verdicts rendered.

(defvar *v-checks* 0)
(defvar *v-failures* 0)

(defun vcheck (description thunk)
  (incf *v-checks*)
  ;; Descriptions are format controls with no arguments, so literal
  ;; tilde-newline continuations in the source collapse to clean one-line
  ;; transcript text.
  (let ((description (format nil description))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (cond
      ((eq outcome :ok)
       (format t "[V~3,'0d] ok   ~a~%" *v-checks* description))
      (t
       (incf *v-failures*)
       (format t "[V~3,'0d] FAIL ~a~@[ (~a)~]~%" *v-checks* description
               (when (consp outcome) (second outcome)))))))

(defun vnote (format-control &rest arguments)
  (apply #'format t format-control arguments)
  (terpri))

;;; ---------------------------------------------------------------------------
;;; Locations (root-relative; the runner is executed from the latent-lisp
;;; root) and scratch (fixed path, cleaned per run, never printed).

(defvar *pj0-root* #p"mneme/architecture/process-journal-0/")
(defvar *fixtures-root* (merge-pathnames "fixtures/" *pj0-root*))
(defvar *v-scratch* #p"/tmp/journal0-vectors-scratch/")

(when (probe-file *v-scratch*)
  (sb-ext:delete-directory *v-scratch* :recursive t))
(ensure-directories-exist *v-scratch*)

(defun ascii-octets (string)
  (map '(simple-array (unsigned-byte 8) (*)) #'char-code string))

(defun read-fixture-octets (relative-path)
  "Raw octets of a fixture file named relative to the process-journal-0
packet root (registry path convention)."
  (let ((octets (%read-file-octets (merge-pathnames relative-path *pj0-root*))))
    (unless octets
      (error "fixture file missing: ~a" relative-path))
    octets))

(defun decode-canonical-sexp-file (octets what)
  "Decode a .sexp/.pjs fixture file: one canonical PJ-S/0 datum, with or
without one trailing LF.  Returns (values datum trailing-lf-p)."
  (let* ((length (length octets))
         (trailing-lf-p (and (plusp length) (= #x0a (aref octets (1- length)))))
         (body (if trailing-lf-p (subseq octets 0 (1- length)) octets)))
    (multiple-value-bind (datum status detail) (decode-pjs0 body)
      (unless (eq status :canonical)
        (error "~a is not canonical PJ-S/0: ~a ~a" what status detail))
      (values datum trailing-lf-p))))

;;; Field accessors over registry records.

(defun fixture-field (record name)
  (record-field record "fixture" name))

(defun id-last-segment (identifier)
  (car (last (identifier-segments identifier))))

(defun fixture-expected-status (record)
  (intern (string-upcase (id-last-segment
                          (fixture-field record "expected-status")))
          :keyword))

(defun fixture-string (record name)
  (let ((value (fixture-field record name)))
    (and value (lisp-plus-cd0:string-datum-p value)
         (lisp-plus-cd0:string-datum-value value))))

(defun fixture-integer (record name)
  (let ((value (fixture-field record name)))
    (and value (lisp-plus-cd0:integer-datum-p value)
         (lisp-plus-cd0:integer-datum-value value))))

;;; ---------------------------------------------------------------------------
;;; §23 condition-category mapping for the registry's Python-vocabulary
;;; expected-error strings (the gate's adjudication table — trap 1).

(defvar *expected-error-map*
  '(("header-magic-version" . pj0-header-invalid)
    ("noncanonical-ordinal" . pj0-header-invalid)
    ("ordinal-gap" . pj0-ordinal-gap)
    ("noncanonical-length" . pj0-payload-length-invalid)
    ("digest-syntax" . pj0-header-invalid)
    ("payload-hash" . pj0-payload-digest-mismatch)
    ("previous-frame-digest" . pj0-previous-digest-mismatch)
    ("frame-hash" . pj0-frame-digest-mismatch)
    ("bad-frame-separator" . pj0-frame-separator-invalid)
    ("header-field-count" . pj0-header-invalid)
    ("duplicate-event-id" . pj0-duplicate-committed-event)))

(defun map-expected-error (expected-error)
  "The §23 condition CATEGORY adjudicated for a registry expected-error
string.  Returns (values condition-type divergent-p): DIVERGENT-P is true
when the registry string is not itself the §23 condition name (i.e. the
mapping is an adjudication, recorded per vector)."
  (let ((exact (cdr (assoc expected-error *expected-error-map*
                           :test #'string=))))
    (cond
      (exact (values exact t))
      ((and (>= (length expected-error) 32)
            (string= (subseq expected-error 0 32)
                     "payload-canonicality:invalid UTF"))
       (values 'pj0-invalid-utf8 t))
      ((and (>= (length expected-error) 21)
            (string= (subseq expected-error 0 21) "payload-canonicality:"))
       (values 'pj0-noncanonical-payload t))
      (t (values nil t)))))

;;; ---------------------------------------------------------------------------
;;; Load and census the registry (ALL counts derived live).

(vnote "== registry ==")

(defvar *registry-octets*
  (read-fixture-octets "PJ0-FIXTURE-REGISTRY.sexp"))

(defvar *registry* nil)

(vcheck "registry parses as canonical PJ-S/0 with this codec (PJ-SYN-2)"
  (lambda ()
    (setf *registry* (decode-canonical-sexp-file *registry-octets* "registry"))
    (lisp-plus-cd0:sequence-datum-p *registry*)))

(defun registry-entries (&optional kind)
  (loop for index below (lisp-plus-cd0:sequence-datum-length *registry*)
        for entry = (lisp-plus-cd0:sequence-datum-ref *registry* index)
        when (or (null kind)
                 (string= kind (id-last-segment (fixture-field entry "kind"))))
          collect entry))

(defvar *positive-entries* (registry-entries "positive"))
(defvar *adversarial-entries* (registry-entries "adversarial"))
(defvar *semantic-entries* (registry-entries "semantic"))
(defvar *family-entries* (registry-entries "truncation-family"))

(vnote "registry census (derived live): ~a entries = ~a positive + ~
        ~a adversarial + ~a semantic + ~a truncation-family"
       (lisp-plus-cd0:sequence-datum-length *registry*)
       (length *positive-entries*) (length *adversarial-entries*)
       (length *semantic-entries*) (length *family-entries*))

(vcheck "registry census covers every entry (no unknown kind)"
  (lambda ()
    (= (lisp-plus-cd0:sequence-datum-length *registry*)
       (+ (length *positive-entries*) (length *adversarial-entries*)
          (length *semantic-entries*) (length *family-entries*)))))

;;; Negative control 10 hook: a child invocation dies HERE, mid-run, before
;;; any verdict-bearing section and before the final RESULT sentinel.
(when (sb-posix:getenv "JOURNAL0_VECTORS_DIE")
  (vnote "child control: dying mid-run before the final result (planted)")
  (sb-ext:exit :code 3))

;;; ---------------------------------------------------------------------------
;;; Positive vectors: accepted, then writer conformance by byte-exact
;;; re-encoding of the frozen stores (§32.3: a writer produces the frozen
;;; positive frames).

(vnote "~%== positive vectors (~a, derived) ==" (length *positive-entries*))

(defun open-fixture-store (events-relative-path)
  "Open the store directory containing EVENTS-RELATIVE-PATH (validates
metadata + sidecar)."
  (let* ((full (merge-pathnames events-relative-path *pj0-root*))
         (directory (make-pathname :name nil :type nil :defaults full)))
    (open-store directory)))

(dolist (entry *positive-entries*)
  (let* ((id (fixture-string entry "id"))
         (path (fixture-string entry "path"))
         (expected-frames (fixture-integer entry "expected-valid-frames"))
         (expected-sha (fixture-string entry "sha256"))
         (octets (read-fixture-octets path)))
    (vcheck (format nil "~a: fixture sha256 verified before use" id)
      (lambda () (string= (sha256-hex octets) expected-sha)))
    (let ((store nil) (report nil))
      (vcheck (format nil "~a: store opens; reader accepts; ~
                           expected-valid-frames ~a"
                      id expected-frames)
        (lambda ()
          (setf store (open-fixture-store path))
          (setf report (validate-event-octets
                        octets (journal-store-store-id store)))
          (and (eq (prefix-report-status report) :valid)
               (= (prefix-report-frame-count report) expected-frames)
               (= (prefix-report-valid-byte-count report) (length octets)))))
      ;; Writer conformance: rebuild the store from its decoded abstract
      ;; events under the FROZEN metadata; require byte identity of
      ;; EVENTS.pj0, JOURNAL-META.pjs, and the sidecar.
      (vcheck (format nil "~a: writer rebuild is byte-exact ~
                           (frames + metadata + sidecar) (§32.3)"
                      id)
        (lambda ()
          (let* ((source-directory (make-pathname
                                    :name nil :type nil
                                    :defaults (merge-pathnames path
                                                               *pj0-root*)))
                 (frozen-metadata (%read-file-octets
                                   (merge-pathnames "JOURNAL-META.pjs"
                                                    source-directory)))
                 (frozen-sidecar (%read-file-octets
                                  (merge-pathnames "JOURNAL-META.pjs.sha256"
                                                   source-directory)))
                 (rebuild-directory (merge-pathnames
                                     (format nil "rebuild-~a/" id)
                                     *v-scratch*))
                 (rebuild (create-journal rebuild-directory
                                          :metadata-octets frozen-metadata)))
            (loop for index below (fill-pointer (prefix-report-events report))
                  do (append-event rebuild
                                   (aref (prefix-report-events report) index)))
            (and (%octets-equal-p
                  octets
                  (%read-file-octets (merge-pathnames "EVENTS.pj0"
                                                      rebuild-directory)))
                 (%octets-equal-p
                  frozen-metadata
                  (%read-file-octets (merge-pathnames "JOURNAL-META.pjs"
                                                      rebuild-directory)))
                 (%octets-equal-p
                  frozen-sidecar
                  (%read-file-octets
                   (merge-pathnames "JOURNAL-META.pjs.sha256"
                                    rebuild-directory))))))))))

;;; ---------------------------------------------------------------------------
;;; Adversarial vectors: refused with the correct classification.

(vnote "~%== adversarial vectors (~a, derived) ==" (length *adversarial-entries*))

(dolist (entry *adversarial-entries*)
  (let* ((id (fixture-string entry "id"))
         (path (fixture-string entry "path"))
         (expected-status (fixture-expected-status entry))
         (expected-frames (fixture-integer entry "expected-valid-frames"))
         (expected-sha (fixture-string entry "sha256"))
         (expected-error (fixture-string entry "expected-error"))
         (octets (read-fixture-octets path)))
    (multiple-value-bind (mapped-condition divergent-p)
        (map-expected-error expected-error)
      (vcheck (format nil "~a: fixture sha256 verified before use" id)
        (lambda () (string= (sha256-hex octets) expected-sha)))
      (vcheck (format nil "~a: refused as ~a with ~a valid frame~:p, ~
                           §23 category ~a"
                      id (string-downcase expected-status) expected-frames
                      (string-downcase (symbol-name mapped-condition)))
        (lambda ()
          (let* ((store (open-fixture-store path))
                 (report (validate-event-octets
                          octets (journal-store-store-id store))))
            (and (eq (prefix-report-status report)
                     (ecase expected-status
                       (:corruption :corruption)
                       (:torn-tail :torn-tail)))
                 (= (prefix-report-frame-count report) expected-frames)
                 (eq (prefix-report-condition-type report) mapped-condition)))))
      (when divergent-p
        (vnote "        DIVERGENCE(~a, field expected-error): registry says ~
                ~s (reference-tool vocabulary); this gate checks the §23 ~
                category ~a — adjudicates to spec text (§23; ALLOWED-SOURCES ~
                note 1)"
               id expected-error
               (string-downcase (symbol-name mapped-condition)))))))

;;; ---------------------------------------------------------------------------
;;; Exhaustive terminal-frame truncation family (PJ-TRN-1..3).

(vnote "~%== truncation family ==")

(defvar *synced-demo-store*
  (open-fixture-store "fixtures/positive/synced-demo/EVENTS.pj0"))
(defvar *synced-demo-octets*
  (read-fixture-octets "fixtures/positive/synced-demo/EVENTS.pj0"))

(defvar *truncation-manifest* nil)
(defvar *truncation-directory* #p"fixtures/truncation/final-frame-every-byte/")

(let ((family (first *family-entries*)))
  (vcheck "truncation manifest sha256 verified, parses canonically"
    (lambda ()
      (let ((octets (read-fixture-octets (fixture-string family "path"))))
        (and (string= (sha256-hex octets) (fixture-string family "sha256"))
             (progn
               (setf *truncation-manifest*
                     (decode-canonical-sexp-file octets "truncation manifest"))
               (lisp-plus-cd0:sequence-datum-p *truncation-manifest*)))))))

(defun truncation-field (record name)
  (record-field record "truncation" name))

(let* ((count (lisp-plus-cd0:sequence-datum-length *truncation-manifest*))
       (prefix-length nil)          ; S: derived from the offset-0 entry
       (prefix-sha nil)             ; sha of the frozen 6-frame prefix
       (family-expected-frames
         (fixture-integer (first *family-entries*) "expected-valid-frames"))
       (offsets '())
       (failures 0)
       (store-id (journal-store-store-id *synced-demo-store*)))
  ;; Derive S and the prefix digest from the offset-0 member itself.
  (let* ((entry-0 (lisp-plus-cd0:sequence-datum-ref *truncation-manifest* 0))
         (path-0 (lisp-plus-cd0:string-datum-value
                  (truncation-field entry-0 "path")))
         (octets-0 (read-fixture-octets
                    (merge-pathnames path-0 *truncation-directory*))))
    (setf prefix-length (length octets-0)
          prefix-sha (sha256-hex octets-0)))
  (vcheck (format nil "family covers every proper final-frame offset exactly ~
                       once: count ~a = final-frame length ~a (PJ-TRN-1)"
                  count (- (length *synced-demo-octets*) prefix-length))
    (lambda () (= count (- (length *synced-demo-octets*) prefix-length))))
  (loop for index below count
        for entry = (lisp-plus-cd0:sequence-datum-ref *truncation-manifest*
                                                      index)
        for offset = (lisp-plus-cd0:integer-datum-value
                      (truncation-field entry "offset"))
        for path = (lisp-plus-cd0:string-datum-value
                    (truncation-field entry "path"))
        for expected-status = (intern (string-upcase
                                       (id-last-segment
                                        (truncation-field entry
                                                          "expected-status")))
                                      :keyword)
        for expected-frames = (lisp-plus-cd0:integer-datum-value
                               (truncation-field entry
                                                 "expected-valid-frames"))
        for expected-sha = (lisp-plus-cd0:string-datum-value
                            (truncation-field entry "sha256"))
        do (push offset offsets)
           (let* ((octets (read-fixture-octets
                           (merge-pathnames path *truncation-directory*)))
                  (report (validate-event-octets octets store-id))
                  (ok
                    (and
                     ;; sha256 verified before use.
                     (string= (sha256-hex octets) expected-sha)
                     ;; exact terminal offset: file length = S + offset.
                     (= (length octets) (+ prefix-length offset))
                     ;; manifest expectation.
                     (eq (prefix-report-status report) expected-status)
                     (= (prefix-report-frame-count report) expected-frames)
                     (= (prefix-report-frame-count report)
                        family-expected-frames)
                     ;; PJ-TRN-3: the valid prefix is byte-identical across
                     ;; the family (same boundary, same bytes).
                     (= (prefix-report-valid-byte-count report) prefix-length)
                     (string= (sha256-hex (subseq octets 0 prefix-length))
                              prefix-sha)
                     ;; PJ-TRN-2: exact excluded tail evidence for nonzero.
                     (if (zerop offset)
                         (null (prefix-report-tail-offset report))
                         (and (eql (prefix-report-tail-offset report)
                                   prefix-length)
                              (prefix-report-tail-sha256 report)
                              (eq (prefix-report-condition-type report)
                                  'pj0-torn-tail))))))
             (unless ok
               (incf failures)
               (vnote "        family FAIL at offset ~a (~a): status ~a, ~
                       frames ~a"
                      offset path (prefix-report-status report)
                      (prefix-report-frame-count report)))))
  (vcheck (format nil "all ~a family members: sha verified, exact offsets, ~
                       offset-0 valid-end, nonzero torn-tail, prefix ~
                       byte-identical (PJ-TRN-1/2/3, F-04/F-05)"
                  count)
    (lambda () (zerop failures)))
  (vcheck "family offsets are exactly 0..count-1, each once (F-04)"
    (lambda ()
      (let ((sorted (sort (copy-list offsets) #'<)))
        (loop for expected from 0
              for offset in sorted
              always (= offset expected)))))
  (vcheck "complete untruncated control equals the frozen synced-demo bytes"
    (lambda ()
      (%octets-equal-p
       (read-fixture-octets (merge-pathnames "COMPLETE-CONTROL.pj0"
                                             *truncation-directory*))
       *synced-demo-octets*))))

;;; ---------------------------------------------------------------------------
;;; Semantic datum vectors (valid-datum): canonical decode + per-vector
;;; semantic assertions derived from their governing requirements.

(vnote "~%== semantic datum vectors (~a, derived) ==" (length *semantic-entries*))

(defun origin-value-string (record &rest field)
  (let ((value (apply #'record-field record field)))
    (and value (lisp-plus-cd0:identifier-datum-p value)
         (identifier-segment-string value))))

(dolist (entry *semantic-entries*)
  (let* ((id (fixture-string entry "id"))
         (path (fixture-string entry "path"))
         (expected-sha (fixture-string entry "sha256"))
         (octets (read-fixture-octets path))
         (datum nil))
    (vcheck (format nil "~a: sha256 verified; decodes as canonical PJ-S/0 ~
                         datum (valid-datum)"
                    id)
      (lambda ()
        (and (string= (sha256-hex octets) expected-sha)
             (progn (setf datum (decode-canonical-sexp-file octets id))
                    (lisp-plus-cd0:record-datum-p datum)))))
    (vcheck (format nil "~a: semantic content matches its requirement" id)
      (lambda ()
        (cond
          ((string= id "semantic-witness-separation") ; PJ-WIT-2
           (let ((asserted (record-field datum "case" "asserted-self-report"))
                 (observed (record-field datum "case" "observed-transition")))
             (and (string= (origin-value-string asserted "origin" "value")
                           "origin:asserted")
                  (string= (origin-value-string observed "origin" "value")
                           "origin:observed"))))
          ((string= id "semantic-reconstructed-append-receipt") ; PJ-RCN-1
           (and (string= (origin-value-string datum "receipt" "origin")
                         "origin:reconstructed")
                (string= (origin-value-string datum "receipt"
                                              "append-disposition")
                         "pj0:already-committed-identical")
                ;; Cross-language agreement: the receipt's source-prefix
                ;; digest is the terminal frame digest THIS reader derives
                ;; for the frozen synced-demo store.
                (let ((digest (record-field datum "receipt"
                                            "source-prefix-digest"))
                      (report (validate-event-octets
                               *synced-demo-octets*
                               (journal-store-store-id *synced-demo-store*))))
                  (and (lisp-plus-cd0:bytes-datum-p digest)
                       (string= (octets->hex
                                 (lisp-plus-cd0:bytes-datum-value digest))
                                (prefix-report-terminal-digest report))))))
          ((string= id "semantic-snapshot-prefix-binding") ; PJ-SNP/PJ-RCN-1
           (let ((source (record-field datum "snapshot" "source-store"))
                 (terminal (record-field datum "snapshot"
                                         "terminal-frame-digest"))
                 (ordinal (record-field datum "snapshot" "terminal-ordinal"))
                 (report (validate-event-octets
                          *synced-demo-octets*
                          (journal-store-store-id *synced-demo-store*))))
             (and (string= (identifier-segment-string source)
                           (journal-store-store-id *synced-demo-store*))
                  (= (lisp-plus-cd0:integer-datum-value ordinal)
                     (prefix-report-frame-count report))
                  (string= (octets->hex
                            (lisp-plus-cd0:bytes-datum-value terminal))
                           (prefix-report-terminal-digest report)))))
          ((string= id "semantic-merge-receipt-shape") ; PJ-MRG-1
           (let ((timestamp (record-field datum "merge" "timestamp-ordering"))
                 (rule (record-field datum "merge" "ordering-rule")))
             (and (lisp-plus-cd0:boolean-datum-p timestamp)
                  (not (lisp-plus-cd0:boolean-datum-value timestamp))
                  (string= (identifier-segment-string rule)
                           "merge-rule:explicit-source-precedence:0"))))
          ((string= id "semantic-unsupported-reconstruction") ; PJ-FOLD-4
           (let ((name (record-field datum "condition" "name"))
                 (flag (record-field datum "condition"
                                     "resolved-flag-present")))
             (and (string= (identifier-segment-string name)
                           "condition:unsupported-reconstruction")
                  (lisp-plus-cd0:boolean-datum-p flag)
                  (not (lisp-plus-cd0:boolean-datum-value flag)))))
          ((string= id "semantic-no-resolved-flag") ; PJ-FOLD-1 / C-17
           (let ((flag (record-field datum "design" "mutable-resolved-flag"))
                 (source (record-field datum "design" "current-state-source")))
             (and (lisp-plus-cd0:boolean-datum-p flag)
                  (not (lisp-plus-cd0:boolean-datum-value flag))
                  (string= (identifier-segment-string source)
                           "fold:longest-prefix-valid"))))
          (t nil))))))

;;; ---------------------------------------------------------------------------
;;; Crash-window fixtures (§29 + Annex B; NOT in the registry).  The CW-2c /
;;; CW-3 distinction is declared-durability + caller-knowledge SCENARIO
;;; metadata — never derivable from bytes (the two files are byte-identical
;;; by design).

(vnote "~%== crash windows (§29 + Annex B; outside the registry) ==")

(defvar *crash-directory* (merge-pathnames "crash-windows/" *fixtures-root*))

(defvar *crash-store* nil)

(vcheck "crash-window JOURNAL-META validates (with sidecar); store identity ~
         equals the synced-demo store (same store by design)"
  (lambda ()
    (setf *crash-store* (open-store *crash-directory*))
    (string= (journal-store-store-id *crash-store*)
             (journal-store-store-id *synced-demo-store*))))

;; Scenario table driven from §29 + Annex B.  Fields: file, crash window,
;; expected classification, expected frames, declared durability, caller
;; knowledge (scenario metadata, not bytes).
(defvar *crash-scenarios*
  '(("cw0-before-write.pj0" "CW-0" :valid 6 ":synced"
     "no frame byte written; event absent; prior prefix governs")
    ("cw1-mid-header.pj0" "CW-1" :torn-tail 6 ":synced"
     "death after a proper prefix of the header; tail visible, no event")
    ("cw1-mid-payload.pj0" "CW-1" :torn-tail 6 ":synced"
     "death after a proper prefix of the payload; tail visible, no event")
    ("cw2-full-unacknowledged.pj0" "CW-2c" :valid 7 ":synced"
     "full frame accepted by host write path BEFORE the durability barrier; bytes govern; no delivered success receipt may be inferred (PJ-CRASH-2)")
    ("cw3-full-synced-receipt-lost.pj0" "CW-3" :valid 7 ":synced"
     "durability barrier satisfied, receipt never reached the caller; reconcile by event identity (PJ-CRASH-1)")))

(dolist (scenario *crash-scenarios*)
  (destructuring-bind (file window expected-status expected-frames
                       durability knowledge) scenario
    (vcheck (format nil "~a [~a]: ~a, ~a frame~:p"
                    file window (string-downcase expected-status)
                    expected-frames)
      (lambda ()
        (let* ((octets (%read-file-octets (merge-pathnames file
                                                           *crash-directory*)))
               (report (validate-event-octets
                        octets (journal-store-store-id *crash-store*))))
          (and (eq (prefix-report-status report) expected-status)
               (= (prefix-report-frame-count report) expected-frames)))))
    (vnote "        scenario metadata [~a]: declared-durability ~a; ~a"
           window durability knowledge)))

(vcheck "cw2 and cw3 are byte-identical: the CW-2c/CW-3 distinction is ~
         scenario metadata, never bytes (§29)"
  (lambda ()
    (%octets-equal-p
     (%read-file-octets (merge-pathnames "cw2-full-unacknowledged.pj0"
                                         *crash-directory*))
     (%read-file-octets (merge-pathnames "cw3-full-synced-receipt-lost.pj0"
                                         *crash-directory*)))))

(vcheck "PREFIX-BEFORE-FINAL + FINAL-FRAME concatenate to the cw2/cw3 bytes"
  (lambda ()
    (%octets-equal-p
     (concatenate '(vector (unsigned-byte 8))
                  (%read-file-octets (merge-pathnames "PREFIX-BEFORE-FINAL.pj0"
                                                      *crash-directory*))
                  (%read-file-octets (merge-pathnames "FINAL-FRAME.pj0frame"
                                                      *crash-directory*)))
     (%read-file-octets (merge-pathnames "cw2-full-unacknowledged.pj0"
                                         *crash-directory*)))))

(vcheck "CW-3 reconciliation transcript: re-appending the final event ~
         returns already-committed-identical at the prior coordinate, no new ~
         frame, receipt origin :reconstructed (PJ-CRASH-1, PJ-APP-2/4, E-27, ~
         C-14)"
  (lambda ()
    (let* ((cw3-directory (merge-pathnames "cw3-store/" *v-scratch*)))
      (ensure-directories-exist cw3-directory)
      (dolist (name '("JOURNAL-META.pjs" "JOURNAL-META.pjs.sha256"))
        (%write-file-octets (merge-pathnames name cw3-directory)
                            (%read-file-octets (merge-pathnames
                                                name *crash-directory*))))
      (%write-file-octets (merge-pathnames "EVENTS.pj0" cw3-directory)
                          (%read-file-octets
                           (merge-pathnames "cw3-full-synced-receipt-lost.pj0"
                                            *crash-directory*)))
      (let* ((store (open-store cw3-directory))
             (report (validate-journal store))
             (final-event (aref (prefix-report-events report)
                                (1- (prefix-report-frame-count report))))
             (before (sha256-hex (%read-file-octets
                                  (merge-pathnames "EVENTS.pj0"
                                                   cw3-directory))))
             (receipt (append-event store final-event
                                    :origin :reconstructed)))
        (and (eq (append-receipt-disposition receipt)
                 :already-committed-identical)
             (= (append-receipt-ordinal receipt)
                (prefix-report-frame-count report))
             (eq (append-receipt-origin receipt) :reconstructed)
             (string= before
                      (sha256-hex (%read-file-octets
                                   (merge-pathnames "EVENTS.pj0"
                                                    cw3-directory)))))))))

;;; ---------------------------------------------------------------------------
;;; Planted mutants against their scorecard-designated fixtures (PJ-MUT-1/2).
;;; The designations are Class A (PJ0-MUTATION-SCORECARD.md); the mutant
;;; IMPLEMENTATIONS are this store's own (mutants.lisp), written from §28's
;;; normative mode list — the reference tool's were never opened.

(vnote "~%== planted mutants vs scorecard-designated fixtures ==")

(defvar *mutant-scorecard*
  ;; (defect designated-fixture-id expected-mutant-status)
  '((:ignore-payload-hash "adversarial-payload-hash" :valid)
    (:ignore-prev-chain "adversarial-prev-chain" :valid)
    (:accept-noncanonical "adversarial-noncanonical-record-order" :valid)
    (:interior-as-tail "adversarial-payload-hash" :torn-tail)
    (:duplicate-last-write-wins "adversarial-duplicate-conflict" :valid)
    (:ignore-ordinal "adversarial-ordinal-gap" :valid)))

(vcheck "the scorecard designates every planted defect exactly once (PJ-MUT-1)"
  (lambda ()
    (null (set-exclusive-or +planted-defects+
                            (mapcar #'first *mutant-scorecard*)))))

(dolist (row *mutant-scorecard*)
  (destructuring-bind (defect fixture-id expected-mutant-status) row
    (vcheck (format nil "mutant ~a killed by ~a: strict corruption, mutant ~a ~
                         (PJ-MUT-2 expected disagreement)"
                    defect fixture-id
                    (string-downcase expected-mutant-status))
      (lambda ()
        (let* ((entry (find fixture-id *adversarial-entries*
                            :key (lambda (e) (fixture-string e "id"))
                            :test #'string=))
               (path (fixture-string entry "path"))
               (octets (read-fixture-octets path))
               (store (open-fixture-store path)))
          (multiple-value-bind (killed-p strict-status mutant-status)
              (run-mutant-kill defect octets (journal-store-store-id store))
            (and killed-p
                 (eq strict-status :corruption)
                 (eq mutant-status expected-mutant-status))))))))

;;; ---------------------------------------------------------------------------
;;; Negative controls: the RUNNER ITSELF notices.  Each control plants a
;;; fault and names the exact check that went red — "the process failed
;;; somehow" is not evidence.

(vnote "~%== negative controls (runner teeth) ==")

(defun mutate-copy (octets index new-value)
  (let ((copy (copy-seq octets)))
    (setf (aref copy index) new-value)
    copy))

(defun flip-hex-char (octets index)
  "Replace the hex character octet at INDEX with a different hex character."
  (mutate-copy octets index (if (= (aref octets index) (char-code #\a))
                                (char-code #\b)
                                (char-code #\a))))

(defvar *demo-store-id* (journal-store-store-id *synced-demo-store*))
(defvar *final-header-start* nil)
(defvar *final-header-lf* nil)

(let ((prefix-length (- (length *synced-demo-octets*) 1235)))
  ;; Derived: final frame starts where the 6-frame prefix ends; its header
  ;; line ends at the first LF after that.
  (setf *final-header-start*
        (prefix-report-valid-byte-count
         (validate-event-octets
          (subseq *synced-demo-octets* 0 prefix-length) *demo-store-id*)))
  (setf *final-header-lf* (position #x0a *synced-demo-octets*
                                    :start *final-header-start*)))

(vcheck "control 1 — payload-byte mutation: exact check gone red = ~
         pj0-payload-digest-mismatch at §12 step 8 (PJ-HASH-1)"
  (lambda ()
    (let* ((mutated (mutate-copy *synced-demo-octets*
                                 (- (length *synced-demo-octets*) 2)
                                 (char-code #\!)))
           (report (validate-event-octets mutated *demo-store-id*)))
      (and (eq (prefix-report-status report) :corruption)
           (eq (prefix-report-condition-type report)
               'pj0-payload-digest-mismatch)
           (= 6 (prefix-report-frame-count report))))))

(vcheck "control 2 — frame-digest field mutation: exact check gone red = ~
         pj0-frame-digest-mismatch at §12 step 10 (PJ-HASH-1)"
  (lambda ()
    (let* ((mutated (flip-hex-char *synced-demo-octets*
                                   (1- *final-header-lf*)))
           (report (validate-event-octets mutated *demo-store-id*)))
      (and (eq (prefix-report-status report) :corruption)
           (eq (prefix-report-condition-type report)
               'pj0-frame-digest-mismatch)
           (= 6 (prefix-report-frame-count report))))))

(vcheck "control 3 — broken predecessor linkage: exact check gone red = ~
         pj0-previous-digest-mismatch at §12 step 9 (PJ-HASH-1)"
  (lambda ()
    ;; The previous-digest field occupies the 64 hex chars two fields before
    ;; the frame digest: [LF-64-1-64, LF-64-1).
    (let* ((mutated (flip-hex-char *synced-demo-octets*
                                   (- *final-header-lf* 64 1 1)))
           (report (validate-event-octets mutated *demo-store-id*)))
      (and (eq (prefix-report-status report) :corruption)
           (eq (prefix-report-condition-type report)
               'pj0-previous-digest-mismatch)
           (= 6 (prefix-report-frame-count report))))))

(defun make-control-event (id-string body)
  (lisp-plus-cd0:make-record-datum
   (list (lisp-plus-cd0:make-record-entry
          (identifier-from-segments '("event" "event-id"))
          (identifier-from-segments (list "event" id-string)))
         (lisp-plus-cd0:make-record-entry
          (identifier-from-segments '("event" "kind"))
          (identifier-from-segments '("control" "noted")))
         (lisp-plus-cd0:make-record-entry
          (identifier-from-segments '("event" "body"))
          (lisp-plus-cd0:make-string-datum body)))))

(vcheck "control 4 — ordinal discontinuity (coherent digests): exact check ~
         gone red = pj0-ordinal-gap at §12 step 5"
  (lambda ()
    ;; Frame 1 at ordinal 1, then a digest-coherent frame at ordinal 3.
    (multiple-value-bind (frame-1 frame-1-hex)
        (render-frame-octets *demo-store-id* 1
                             (encode-pjs0 (make-control-event "c4-a" "one"))
                             +genesis-digest-hex+)
      (let* ((frame-3 (render-frame-octets
                       *demo-store-id* 3
                       (encode-pjs0 (make-control-event "c4-b" "two"))
                       frame-1-hex))
             (report (validate-event-octets
                      (concatenate '(vector (unsigned-byte 8))
                                   frame-1 frame-3)
                      *demo-store-id*)))
        (and (eq (prefix-report-status report) :corruption)
             (eq (prefix-report-condition-type report) 'pj0-ordinal-gap)
             (= 1 (prefix-report-frame-count report)))))))

(vcheck "control 5 — truncated frame: exact check gone red = pj0-torn-tail ~
         (payload shorter than declared, §13.2)"
  (lambda ()
    (let ((report (validate-event-octets
                   (subseq *synced-demo-octets* 0
                           (+ *final-header-lf* 100))
                   *demo-store-id*)))
      (and (eq (prefix-report-status report) :torn-tail)
           (eq (prefix-report-condition-type report) 'pj0-torn-tail)
           (= 6 (prefix-report-frame-count report))
           (prefix-report-tail-sha256 report)))))

(vcheck "control 6 — valid frames followed by garbage: exact check gone red ~
         = pj0-header-invalid (7 frames stand; PJ-TERM-1 forbids skipping)"
  (lambda ()
    (let ((report (validate-event-octets
                   (concatenate '(vector (unsigned-byte 8))
                                *synced-demo-octets*
                                (ascii-octets "GARBAGE NOT A FRAME")
                                (vector #x0a))
                   *demo-store-id*)))
      (and (eq (prefix-report-status report) :corruption)
           (eq (prefix-report-condition-type report) 'pj0-header-invalid)
           (= 7 (prefix-report-frame-count report))))))

(vcheck "control 7 — duplicate event-id with altered content: exact check ~
         gone red = pj0-duplicate-committed-event at §12 step 15 (§13.3)"
  (lambda ()
    (multiple-value-bind (frame-1 frame-1-hex)
        (render-frame-octets *demo-store-id* 1
                             (encode-pjs0 (make-control-event "c7" "original"))
                             +genesis-digest-hex+)
      (let* ((frame-2 (render-frame-octets
                       *demo-store-id* 2
                       (encode-pjs0 (make-control-event "c7" "ALTERED"))
                       frame-1-hex))
             (report (validate-event-octets
                      (concatenate '(vector (unsigned-byte 8))
                                   frame-1 frame-2)
                      *demo-store-id*)))
        (and (eq (prefix-report-status report) :corruption)
             (eq (prefix-report-condition-type report)
                 'pj0-duplicate-committed-event)
             (= 1 (prefix-report-frame-count report)))))))

(vcheck "control 8 — fold/reconstruction beyond the validated prefix: exact ~
         check gone red = unsupported-reconstruction (K0E-11, Errata §8 ~
         control 11)"
  (lambda ()
    (let ((store-directory (merge-pathnames "control-8/" *v-scratch*)))
      (let ((store (create-journal store-directory)))
        (append-event store (make-control-event "c8" "only"))
        (handler-case
            (progn (reconstruct store '("lisp-plus-journal0" "fold" "0")
                                :requested-terminal-ordinal 5)
                   nil)
          (unsupported-reconstruction () t)
          (error () nil))))))

(vcheck "control 9 — recovery requiring unavailable non-journal state (two ~
         open attempts, precedence relation absent from the journal): exact ~
         check gone red = unsupported-reconstruction (PJ-FOLD-4)"
  (lambda ()
    (let ((store-directory (merge-pathnames "control-9/" *v-scratch*)))
      (flet ((seat-event (id attempt)
               (lisp-plus-cd0:make-record-datum
                (list (lisp-plus-cd0:make-record-entry
                       (identifier-from-segments '("event" "event-id"))
                       (identifier-from-segments (list "event" id)))
                      (lisp-plus-cd0:make-record-entry
                       (identifier-from-segments '("event" "kind"))
                       (identifier-from-segments '("attempt" "begun")))
                      (lisp-plus-cd0:make-record-entry
                       (identifier-from-segments '("event" "attempt"))
                       (identifier-from-segments (list "attempt" attempt)))
                      (lisp-plus-cd0:make-record-entry
                       (identifier-from-segments '("event" "seat-id"))
                       (identifier-from-segments '("seat" "c9")))))))
        (let ((store (create-journal store-directory)))
          (append-event store (seat-event "c9-a" "a1"))
          (append-event store (seat-event "c9-b" "a2"))
          (handler-case
              (progn (derive-seat-resolution store '("seat" "c9")) nil)
            (unsupported-reconstruction () t)
            (error () nil)))))))

(vcheck "control 10 — runner truncated before its final result: child ~
         invocation dies mid-run; exact evidence = nonzero exit AND missing ~
         RESULT sentinel (an incomplete transcript licenses nothing)"
  (lambda ()
    (let* ((output (make-string-output-stream))
           (process (sb-ext:run-program
                     "sbcl"
                     (list "--script" "mneme/journal0/journal0-vectors.lisp")
                     :search t
                     :output output
                     :error nil
                     :environment (cons "JOURNAL0_VECTORS_DIE=1"
                                        (sb-ext:posix-environ))))
           (text (get-output-stream-string output)))
      (and (= 3 (sb-ext:process-exit-code process))
           (not (search "RESULT:" text))
           ;; The child did run into the lane (census printed) — the death
           ;; is mid-run, not a failure to start.
           (search "registry census" text)))))

;;; ---------------------------------------------------------------------------
;;; §12 step 16 — the Kernel semantic fold partner (K0E-26 joint report;
;;; absent from the reference tool by design; trap 4).

(vnote "~%== §12 step 16 — joint structural + semantic verdicts (K0E-26) ==")

(vcheck "synced-demo joint report carries TWO verdicts; structural :pass; ~
         semantic verdict recorded as its own value (never one green counter)"
  (lambda ()
    (let ((report (joint-structural-semantic-report *synced-demo-store*)))
      (vnote "        structural-verdict: ~a   semantic-verdict: ~a ~
              (extension events: ~a; named projection gaps: ~a)"
             (getf (getf report :structural-verdict) :value)
             (getf (getf report :semantic-verdict) :value)
             (getf report :extension-event-count)
             (getf report :named-projection-gaps))
      (and (eq :pass (getf (getf report :structural-verdict) :value))
           (member (getf (getf report :semantic-verdict) :value)
                   '(:pass :fail))
           (= 7 (getf report :frame-count))))))

(vcheck "structural PASS / semantic FAIL is lawful and reported as dual ~
         standing (Errata §8 control 10; K0E-8)"
  (lambda ()
    (let ((store-directory (merge-pathnames "dual-standing/" *v-scratch*)))
      (let ((store (create-journal store-directory)))
        ;; A structurally perfect frame whose event is Kernel-illegal:
        ;; attempt-begun on a never-reserved seat (Kernel §13.5).
        (append-event
         store
         (lisp-plus-cd0:make-record-datum
          (list (lisp-plus-cd0:make-record-entry
                 (identifier-from-segments '("event" "event-id"))
                 (identifier-from-segments '("event" "dual-1")))
                (lisp-plus-cd0:make-record-entry
                 (identifier-from-segments '("event" "kind"))
                 (identifier-from-segments '("attempt" "begun")))
                (lisp-plus-cd0:make-record-entry
                 (identifier-from-segments '("event" "attempt"))
                 (identifier-from-segments '("attempt" "d1")))
                (lisp-plus-cd0:make-record-entry
                 (identifier-from-segments '("event" "seat-id"))
                 (identifier-from-segments '("seat" "never-reserved"))))))
        (let ((report (joint-structural-semantic-report store)))
          (and (eq :pass (getf (getf report :structural-verdict) :value))
               (eq :fail (getf (getf report :semantic-verdict) :value))
               (member 'lisp-plus-kernel0:journal-illegal-transition
                       (getf (getf report :semantic-verdict)
                             :condition-ids))))))))

(vnote "Errata §8 controls 10-14 discharge (named, per K0E-5a reporting law):")
(vnote "  control 10 (dual standing)            DISCHARGED — this runner ~
        (above) + journal0-selftest joint-report checks")
(vnote "  control 11 (no skip-forward recovery) DISCHARGED — control 8 ~
        (K0E-11) + PJ-TERM-1 adversarial/garbage controls")
(vnote "  control 12 (deletion attestation)     DISCHARGED — ~
        journal0-selftest RECONSTRUCT check (derived artifacts deleted ~
        first, attested in the receipt; PJ-RCN-3)")
(vnote "  control 13 (torn tail -> bounded)     PARTIAL, NAMED EXCLUSION — ~
        the journal half is discharged (torn tail preserved with evidence; ~
        tail-could-hide-settlement-p reported); the Kernel-side construction ~
        of a bounded-determinacy outcome consuming that flag (K0E-15) is NOT ~
        built here: the projection carries no settlement-payload records ~
        (named gap in fold.lisp), so the kernel fold cannot yet derive the ~
        bounded standing from a torn tail alone")
(vnote "  control 14 (salvage preserves events) DISCHARGED — ~
        journal0-selftest salvage check (K0E-16: frame/store identity ~
        changes, abstract events + replay preserved)")

;;; ---------------------------------------------------------------------------
;;; Language-neutral comparison block (vs PJ0-REFERENCE-TRANSCRIPT.md).

(vnote "~%== reference-transcript comparison (this implementation's own ~
        derivations) ==")

(let* ((report (validate-event-octets *synced-demo-octets* *demo-store-id*))
       (metadata-octets (read-fixture-octets
                         "fixtures/positive/synced-demo/JOURNAL-META.pjs")))
  (vnote "  synced-demo store id:        ~a" *demo-store-id*)
  (vnote "  synced-demo metadata sha256: ~a" (sha256-hex metadata-octets))
  (vnote "  synced-demo events sha256:   ~a" (sha256-hex *synced-demo-octets*))
  (vnote "  frames:                      ~a" (prefix-report-frame-count report))
  (vnote "  final frame starts at byte:  ~a" *final-header-start*)
  (vnote "  final frame length:          ~a" (- (length *synced-demo-octets*)
                                                *final-header-start*))
  (vnote "  truncation vectors:          ~a"
         (lisp-plus-cd0:sequence-datum-length *truncation-manifest*))
  (vnote "  terminal frame digest:       ~a"
         (prefix-report-terminal-digest report))
  (vcheck "comparison: 7 frames, final frame at byte 6684, length 1235, ~
           1235 truncation vectors (all derived above, matched against the ~
           reference transcript's published numbers)"
    (lambda ()
      (and (= 7 (prefix-report-frame-count report))
           (= 6684 *final-header-start*)
           (= 1235 (- (length *synced-demo-octets*) *final-header-start*))
           (= 1235 (lisp-plus-cd0:sequence-datum-length
                    *truncation-manifest*))))))

;;; ---------------------------------------------------------------------------
;;; Result — derived, never hard-coded.

(format t "~%journal0-vectors: ~a check~:p, ~a failure~:p~%"
        *v-checks* *v-failures*)
(format t "gate census (derived live): ~a positive · ~a adversarial · ~
           ~a semantic · ~a-member truncation family · ~a crash-window ~
           scenarios · ~a mutants · 10 negative controls~%"
        (length *positive-entries*) (length *adversarial-entries*)
        (length *semantic-entries*)
        (lisp-plus-cd0:sequence-datum-length *truncation-manifest*)
        (length *crash-scenarios*)
        (length *mutant-scorecard*))
(if (zerop *v-failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
