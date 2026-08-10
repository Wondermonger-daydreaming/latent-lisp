;;;; ma0-concordance.lisp — THE CONCORDANCE COMPARATOR
;;;; (FAILURE MATRIX §3: W-CONCORD-A · W-CONCORD-CI · W-CONCORD-CII ·
;;;; W-CONCORD-BR; contract §4's declared largest risk).
;;;;
;;;;   sbcl --script mneme/language-many-acts-0/ma0-concordance.lisp
;;;;
;;;; CANDIDATE.  Executing a candidate is not adopting it (contract §0, §8), and
;;;; nothing this file prints is independent verification (AP0 adoption Rider 2).
;;;;
;;;; ---------------------------------------------------------------------------
;;;; WHAT THIS COMPARES, AND WHAT IT REFUSES TO COMPARE
;;;; ---------------------------------------------------------------------------
;;;;
;;;; For each arm MANY ACTS /0 uses — A · C-i · C-ii · B-R — this runner spawns
;;;; TWO images with TWO stores:
;;;;
;;;;   CANONICAL  ma0-concordance-canonical.lisp — `run-all-arms', the adopted
;;;;              composer, MANY ACTS /0 never loaded.
;;;;   MA0        ma0-concordance-ma0.lisp <arm> — `run-act' + this lane's
;;;;              `ma0-complete-act', the re-composition.
;;;;
;;;; and compares EIGHTEEN facets per arm: the five-slot frame table (present
;;;; AND absent), the J-6 classification, the §3.3 class, the act-identity
;;;; digest, F2's four post-disposition fields, F3's frozen ledger answer, F4's
;;;; runtime resolution and its correspondence row and verdict, F5's execution
;;;; standing, evidence class, mapping row and agreement verdict, and the
;;;; mint-refusal shape.
;;;;
;;;; ⚠ NO CROSS-STORE DIGEST EQUALITY IS ASSERTED ANYWHERE.  Journal /0's
;;;; per-event digest is PREFIX-CHAINED, not a content address: the same frame
;;;; bytes in two stores digest differently, and an equality test over them
;;;; would fabricate a divergence that means nothing.  What is compared is
;;;; STRUCTURE and VERDICTS.  The act-IDENTITY digest is the one hash compared,
;;;; and it is compared because it is a function of the seat and the canonical
;;;; request and of no store state.
;;;;
;;;; ---------------------------------------------------------------------------
;;;; WHAT IS DELIBERATELY NOT COMPARED, AND WHY — READ, NOT GUESSED
;;;; ---------------------------------------------------------------------------
;;;;
;;;; Three families of value differ between the two sides FOR REASONS THAT ARE
;;;; NOT COMPOSITION FACTS.  They are named here so their absence from the facet
;;;; list is a declared exclusion rather than an accidental gap:
;;;;
;;;;   per-event DIGESTS and ORDINALS — Journal /0's digest is prefix-chained
;;;;   and its ordinal is a store position; both are properties of the store a
;;;;   frame landed in, not of the act that wrote it.
;;;;
;;;;   Office R's public-id and occurrence-id, hence F2's BODY OCTETS —
;;;;   capability1/mint.lisp:185-191 builds both as ("cap1-key"|"cap1-mint",
;;;;   fresh-sha, serial), where fresh-sha is the sha256 of the Capability /0
;;;;   FRESH RECEIPT.  That receipt carries the store-id, the terminal ordinal,
;;;;   the valid byte count and the terminal digest, so the identifier is
;;;;   store-derived by construction and two stores cannot produce the same one.
;;;;   (The minting-context LABEL differs too — "oneact0" against "manyacts0" —
;;;;   but that is NOT the reason: capability1/context.lisp:49-58 keeps the label
;;;;   diagnostic and it reaches neither identifier.  The distinction is drawn
;;;;   because the wrong reason would have been the easier one to write.)
;;;;
;;;;   the STORE-ID itself, for the same reason.
;;;;
;;;; What remains — frame kinds, classification, class, act identity, and every
;;;; verdict and standing the frames record — is a function of the act, and that
;;;; is exactly what a re-composition can get wrong.
;;;;
;;;; ⚠ A DIVERGENCE IS A FINDING TO REPORT, NEVER A COMPARISON TO LOOSEN.  This
;;;; file has no tolerance, no normalisation of one side toward the other, and
;;;; no facet it drops when it disagrees.  Both raw strings are printed on every
;;;; red line so a reader adjudicates the difference rather than this runner.
;;;;
;;;; ⚠ A MISSING FACET IS RED, NOT SKIPPED.  A side that failed to emit a facet
;;;; is a side that reported nothing, and a comparator that reads silence as
;;;; agreement is the defect it exists to catch.
;;;;
;;;; ---------------------------------------------------------------------------
;;;; THE SETUP AUDIT (why the canonical side may be trusted at all)
;;;; ---------------------------------------------------------------------------
;;;;
;;;; The canonical image cannot call One Act /0's internal `setup-run', so it
;;;; re-expresses the setup through exported operations.  That replication is
;;;; AUDITED here rather than assumed: this runner also executes the adopted
;;;; lane's own accepted runner, `act0-selftest.lisp' — whose setup is One Act
;;;; /0's OWN — and requires the canonical harvest to agree with what that
;;;; runner prints, on class, agreement row, agreement verdict and the frame
;;;; table, for all four arms.  W-ONEACT-GREEN falls out of the same execution.
;;;;
;;;; ---------------------------------------------------------------------------
;;;; THE TOOTH
;;;; ---------------------------------------------------------------------------
;;;;
;;;; MA0_CONCORD_PLANT_DIVERGENCE=<arm>:<facet> overwrites ONE harvested MA0
;;;; facet with a planted string before the comparison.  The comparator must
;;;; then go RED on exactly that facet.  A comparator that has never reported a
;;;; divergence is untested, not agreeing.
;;;;
;;;; Sentinel, printed on the green path and no other:
;;;;   ma0-concordance: 4 arms, 72 facets, 0 divergences
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

(defparameter cl-user::*dens-act0*
  (merge-pathnames "../language-act-0/" cl-user::*dens-here*))

(in-package #:cl-user)

(defparameter *dens-arms* '("A" "B-L1" "B-L2" "B-R" "C-i" "C-ii" "D")
  "ALL SEVEN ADOPTED ARMS (R1 §7 coverage closure; was four).  The comparator
was already generic over this list — the arm loop, the setup audit, and the
sentinel all read it — so closing the coverage is a change to the list and to
nothing else.  Every EXPECTED value is still harvested from the canonical side
itself and compared; none is written down here.")

(defparameter *dens-facets*
  '("frames-present" "frames-absent" "classification" "class" "act-id-hex"
    "f2-frontier" "f2-outcome-view" "f2-effect-axis-value"
    "f2-effect-axis-determinacy" "f3-ledger-answer" "f4-runtime-resolution"
    "correspondence-row" "correspondence-verdict" "f5-execution-standing"
    "f5-evidence-class" "agreement-row" "agreement-verdict" "mint-refusal")
  "The compared facets, ENUMERATED — so a facet cannot join the harvest and
escape the comparison by not being on a list.")

(defvar *passed* 0)
(defvar *failed* 0)

(defun dens-check (name ok &optional (fmt "") &rest args)
  (if ok (incf *passed*) (incf *failed*))
  (format t "~&  [~a] ~a~@[  ~a~]~%" (if ok "PASS" "FAIL") name
          (let ((s (apply #'format nil fmt args))) (if (string= s "") nil s)))
  (force-output)
  (and ok t))

;;; --------------------------------------------------------------------------
;;; Sub-images.
;;; --------------------------------------------------------------------------

(defun dens-spawn (script &rest args)
  "Run SCRIPT in a fresh image.  Returns (values exit-code stdout-lines)."
  (let* ((out (make-string-output-stream))
         (process (sb-ext:run-program
                   (namestring sb-ext:*runtime-pathname*)
                   (append (list "--script" (namestring script)) args)
                   :output out :error nil :search nil :wait t))
         (code (sb-ext:process-exit-code process))
         (lines '()))
    (with-input-from-string (in (get-output-stream-string out))
      (loop for line = (read-line in nil nil)
            while line do (push line lines)))
    (values code (nreverse lines))))

(defun dens-prefixp (prefix string)
  (and (>= (length string) (length prefix))
       (string= prefix (subseq string 0 (length prefix)))))

(defun dens-split (string)
  "STRING's maximal runs of non-whitespace, in order."
  (let ((out '()) (start nil))
    (loop for i below (length string)
          for c = (char string i)
          do (if (member c '(#\Space #\Tab))
                 (when start (push (subseq string start i) out) (setf start nil))
                 (unless start (setf start i)))
          finally (when start (push (subseq string start) out)))
    (nreverse out)))

(defun dens-parse-harvest (lines prefix)
  "Every `<prefix> <arm> <facet>=<value>' line, as an alist ((arm . facet) . value)."
  (let ((table '()))
    (dolist (line lines (nreverse table))
      (when (dens-prefixp prefix line)
        (let* ((rest (string-left-trim " " (subseq line (length prefix))))
               (space (position #\Space rest))
               (arm (and space (subseq rest 0 space)))
               (tail (and space (string-left-trim " " (subseq rest space))))
               (eq-at (and tail (position #\= tail))))
          (when eq-at
            (push (cons (cons arm (subseq tail 0 eq-at))
                        (subseq tail (1+ eq-at)))
                  table)))))))

(defun dens-lookup (table arm facet)
  (cdr (assoc (cons arm facet) table
              :test (lambda (a b) (and (equal (car a) (car b))
                                       (equal (cdr a) (cdr b)))))))

;;; --------------------------------------------------------------------------
;;; The adopted runner's own transcript — the setup audit's source.
;;; --------------------------------------------------------------------------

(defun dens-normalise (s)
  "Strip a leading `:' and fold `-' (the ARM SUMMARY's empty cell) to `none'."
  (let ((v (string-trim " " s)))
    (cond ((string= v "-") "none")
          ((and (plusp (length v)) (char= #\: (char v 0))) (subseq v 1))
          (t v))))

(defun dens-arm-summary (lines)
  "The adopted runner's ARM SUMMARY block, as ((arm . facet) . value)."
  (let ((table '()) (inside nil))
    (dolist (line lines (nreverse table))
      (cond ((search "== ARM SUMMARY ==" line) (setf inside t))
            ((and inside (search "== V-F1" line)) (setf inside nil))
            (inside
             (let ((fields (dens-split line)))
               (when (and fields (>= (length fields) 2)
                          (member (first fields) *dens-arms* :test #'string=))
                 (let ((arm (first fields)))
                   (dolist (field (rest fields))
                     (let ((at (position #\= field)))
                       (when at
                         (push (cons (cons arm (subseq field 0 at))
                                     (dens-normalise (subseq field (1+ at))))
                               table)))))))))) ))

(defun dens-freeze-frames (lines)
  "The V-F freeze block, as ((arm . frame) . present-p)."
  (let ((table '()) (inside nil))
    (dolist (line lines (nreverse table))
      (cond ((search "== V-F1" line) (setf inside t))
            ((and inside (search "FREEZE SUMMARY" line)) (setf inside nil))
            (inside
             (let ((fields (dens-split line)))
               (when (and (>= (length fields) 3)
                          (member (first fields) '("F1" "F2" "F3" "F4" "F5")
                                  :test #'string=)
                          (member (second fields) *dens-arms* :test #'string=))
                 (push (cons (cons (second fields) (first fields))
                             (string= "ordinal" (third fields)))
                       table))))))))

(defun dens-frames-from-freeze (freeze arm)
  "The arm's present frames, rendered as the harvest renders them."
  (format nil "(~{~a~^ ~})"
          (loop for frame in '("F1" "F2" "F3" "F4" "F5")
                when (cdr (assoc (cons arm frame) freeze
                                 :test (lambda (a b)
                                         (and (equal (car a) (car b))
                                              (equal (cdr a) (cdr b))))))
                  collect frame)))

;;; --------------------------------------------------------------------------
;;; THE RUN.
;;; --------------------------------------------------------------------------

(format t "~&== MANY ACTS /0 — CONCORDANCE TEETH (candidate; adopts nothing) ==~%")
(format t "~&   the re-composition (contract §4) against the adopted composer,~%")
(format t "~&   separate images, separate stores, structure and verdicts only.~%")

;;; ---- 1. the canonical side.
(format t "~&~%== CANONICAL SIDE — run-all-arms, One Act /0's own composer ==~%")
(multiple-value-bind (code lines)
    (dens-spawn (merge-pathnames "ma0-concordance-canonical.lisp"
                                 cl-user::*dens-here*))
  (defparameter *canon-exit* code)
  (defparameter *canon-lines* lines))

(defparameter *canon* (dens-parse-harvest *canon-lines* "DENS-CANON "))
(dens-check "canonical image exit code" (eql 0 *canon-exit*) "exit=~s" *canon-exit*)
(dens-check "canonical image reached its end"
            (equal "reached-end" (dens-lookup *canon* "run" "END"))
            "END=~s" (dens-lookup *canon* "run" "END"))
(dens-check "canonical run reports zero failed One Act /0 checks"
            (equal "0" (dens-lookup *canon* "run" "checks-failed"))
            "checks-failed=~s" (dens-lookup *canon* "run" "checks-failed"))
(dens-check "canonical run returned all seven adopted arms"
            (equal "7" (dens-lookup *canon* "run" "arms-returned"))
            "arms-returned=~s" (dens-lookup *canon* "run" "arms-returned"))

;;; ---- 2. the MA0 side, one image per arm.
(defparameter *ma0* '())
(dolist (arm *dens-arms*)
  (format t "~&~%== MA0 SIDE — arm ~a, ma0-complete-act, its own image and store ==~%" arm)
  (multiple-value-bind (code lines)
      (dens-spawn (merge-pathnames "ma0-concordance-ma0.lisp" cl-user::*dens-here*)
                  arm)
    (let ((table (dens-parse-harvest lines "DENS-MA0 ")))
      (setf *ma0* (append *ma0* table))
      (dens-check (format nil "MA0 image ~a exit code" arm) (eql 0 code) "exit=~s" code)
      (dens-check (format nil "MA0 image ~a reached its end" arm)
                  (equal "reached-end" (dens-lookup table "run" "END"))
                  "END=~s" (dens-lookup table "run" "END"))
      (dens-check (format nil "MA0 image ~a ran the arm it was asked for" arm)
                  (equal arm (dens-lookup table "run" "arm"))
                  "arm=~s" (dens-lookup table "run" "arm")))))

;;; ---- 2b. THE TOOTH.
(let ((plant (sb-ext:posix-getenv "MA0_CONCORD_PLANT_DIVERGENCE")))
  (when plant
    (let* ((colon (position #\: plant))
           (arm (and colon (subseq plant 0 colon)))
           (facet (and colon (subseq plant (1+ colon))))
           (cell (and arm (assoc (cons arm facet) *ma0*
                                 :test (lambda (a b)
                                         (and (equal (car a) (car b))
                                              (equal (cdr a) (cdr b))))))))
      (format t "~&~%== PLANTED DIVERGENCE (MA0_CONCORD_PLANT_DIVERGENCE=~a) ==~%" plant)
      (if cell
          (progn (setf (cdr cell) "PLANTED-DIVERGENCE")
                 (format t "~&    MA0 facet ~a/~a overwritten; the comparison must go RED~%"
                         arm facet))
          (progn (format t "~&    !! no such harvested facet: ~a/~a~%" arm facet)
                 (incf *failed*))))))

;;; ---- 3. the facet-by-facet comparison.
(defparameter *compared* 0)
(defparameter *diverged* 0)
(dolist (arm *dens-arms*)
  (format t "~&~%== W-CONCORD-~a — ~d facets ==~%"
          (string-upcase (remove #\- arm)) (length *dens-facets*))
  (dolist (facet *dens-facets*)
    (let ((c (dens-lookup *canon* arm facet))
          (m (dens-lookup *ma0* arm facet)))
      (incf *compared*)
      (cond
        ((null c)
         (incf *diverged*)
         (dens-check (format nil "W-CONCORD ~a ~a" arm facet) nil
                     "the CANONICAL side emitted no such facet"))
        ((null m)
         (incf *diverged*)
         (dens-check (format nil "W-CONCORD ~a ~a" arm facet) nil
                     "the MA0 side emitted no such facet"))
        ((string= c m)
         (dens-check (format nil "W-CONCORD ~a ~a" arm facet) t "~a" c))
        (t
         (incf *diverged*)
         (dens-check (format nil "W-CONCORD ~a ~a" arm facet) nil
                     "DIVERGENCE  canonical=~s  ma0=~s" c m))))))

;;; ---- 4. the setup audit + W-ONEACT-GREEN, from the adopted runner itself.
(format t "~&~%== SETUP AUDIT — the canonical harvest against act0-selftest.lisp ==~%")
(multiple-value-bind (code lines)
    (dens-spawn (merge-pathnames "act0-selftest.lisp" cl-user::*dens-act0*))
  (dens-check "W-ONEACT-GREEN act0-selftest exit code" (eql 0 code) "exit=~s" code)
  (dens-check "W-ONEACT-GREEN oneact0-selftest: 173 checks, 0 failures"
              (member "oneact0-selftest: 173 checks, 0 failures" lines :test #'equal)
              "tail=~s" (car (last lines)))
  (let ((summary (dens-arm-summary lines))
        (freeze (dens-freeze-frames lines)))
    (dolist (arm *dens-arms*)
      (let ((adopted-class (dens-lookup summary arm "class"))
            (adopted-row (dens-lookup summary arm "row"))
            (adopted-verdict (dens-lookup summary arm "verdict"))
            (adopted-frames (dens-frames-from-freeze freeze arm)))
        (dens-check (format nil "SETUP-AUDIT ~a class" arm)
                    (and adopted-class
                         (string-equal adopted-class (dens-lookup *canon* arm "class")))
                    "adopted=~s canonical=~s" adopted-class
                    (dens-lookup *canon* arm "class"))
        (dens-check (format nil "SETUP-AUDIT ~a agreement-row" arm)
                    (and adopted-row
                         (string= adopted-row (dens-lookup *canon* arm "agreement-row")))
                    "adopted=~s canonical=~s" adopted-row
                    (dens-lookup *canon* arm "agreement-row"))
        (dens-check (format nil "SETUP-AUDIT ~a agreement-verdict" arm)
                    (and adopted-verdict
                         (string= adopted-verdict
                                  (dens-lookup *canon* arm "agreement-verdict")))
                    "adopted=~s canonical=~s" adopted-verdict
                    (dens-lookup *canon* arm "agreement-verdict"))
        (dens-check (format nil "SETUP-AUDIT ~a frames-present" arm)
                    (string= adopted-frames (dens-lookup *canon* arm "frames-present"))
                    "adopted=~s canonical=~s" adopted-frames
                    (dens-lookup *canon* arm "frames-present"))))))

;;; --------------------------------------------------------------------------
(format t "~&~%== TALLY: ~d passed, ~d failed; ~d facets compared, ~d divergences ==~%"
        *passed* *failed* *compared* *diverged*)
(let ((green (and (zerop *failed*) (zerop *diverged*)
                  (= *compared* (* (length *dens-arms*) (length *dens-facets*))))))
  (if green
      (format t "~&ma0-concordance: ~d arms, ~d facets, 0 divergences~%"
              (length *dens-arms*) *compared*)
      (format t "~&ma0-concordance: RUN REFUSED — ~d failed check(s), ~d divergence(s) ~
over ~d compared facet(s).  The success sentinel is WITHHELD.~%"
              *failed* *diverged* *compared*))
  (finish-output)
  (sb-ext:exit :code (if green 0 1)))
