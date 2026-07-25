;;;; verify-descent.lisp — the exterior verifier AND the self-test.
;;;; Quine Orchard, Planting 11 (witnessed lineage). RADIX, 2026-07-25.
;;;;
;;;; Run from this directory:   sbcl --script verify-descent.lisp
;;;; Deterministic: no wall clock, no RANDOM, every printed scalar formatted
;;;; explicitly with ~D / ~A. Two runs are byte-identical.
;;;;
;;;; The check machinery follows the orchard's house idiom (GPT Sol's
;;;; verify-relay.lisp): a numbered CHECK counter, a PLANTED failure to prove
;;;; the machinery bites, and temporary files removed in an UNWIND-PROTECT.
;;;; A gate that has never fired is untested, not passing — so every forgery
;;;; this file relies on being CAUGHT is first exhibited being caught, and the
;;;; one forgery that gets through is exhibited getting through.
;;;;
;;;; SECTIONS
;;;;   1  the lineage is a real quine family (execution, byte-for-byte)
;;;;   2  exteriority, checked mechanically rather than promised
;;;;   3  descent from the exterior root
;;;;   4  PANEL A  naive tamper — caught by internal consistency alone
;;;;   5  PANEL B  self-consistent forgery — internal consistency PASSES it
;;;;   6  PANEL C  the same move against the lineage — descent SEVERS
;;;;   7  PANEL C2 forger rewrites the descendants too — root alone passes it,
;;;;               a deposited later link catches it
;;;;   8  PANEL D  the CEILING: an adversary holding the root forges everything
;;;;   9  regressions (named, each one a bug that was real)
;;;;  10  teeth

(load (merge-pathnames "chain.lisp" (or *load-pathname* *default-pathname-defaults*)))

(defun here (name)
  (merge-pathnames name (or *load-pathname* *default-pathname-defaults*)))

(defun orchard (name)
  (merge-pathnames name (merge-pathnames "../" (or *load-pathname*
                                                   *default-pathname-defaults*))))

(defparameter *checks* 0)

(defun check (truth description)
  (incf *checks*)
  (unless truth
    (error "CHECK FAILED: ~A" description))
  (format t "  [~D] ~A~%" *checks* description)
  t)

(defun file-bytes (path)
  (with-open-file (stream path :direction :input :element-type '(unsigned-byte 8))
    (let ((bytes (make-array (file-length stream) :element-type '(unsigned-byte 8))))
      (read-sequence bytes stream)
      bytes)))

(defun file-text (path)
  (with-open-file (s path :direction :input)
    (let ((text (make-string (file-length s))))
      (subseq text 0 (read-sequence text s)))))

(defun put-text (path text)
  (with-open-file (s path :direction :output :if-exists :supersede
                          :if-does-not-exist :create)
    (write-string text s))
  path)

(defun same-bytes-p (a b) (equalp (file-bytes a) (file-bytes b)))

(defun run-script-to (script output)
  (let ((process (sb-ext:run-program
                  "sbcl" (list "--noinform" "--disable-debugger"
                               "--script" (namestring script))
                  :search t :wait t :output output
                  :if-output-exists :supersede :error *error-output*)))
    (unless (zerop (sb-ext:process-exit-code process))
      (error "child ~A exited ~D" script (sb-ext:process-exit-code process))))
  output)

(defun witness-plist (&optional (path (here "WITNESS-ROOT.sexp")))
  (let ((*package* (find-package *canon-package*)))
    (with-open-file (s path :direction :input) (read s))))

(defun delete-if-present (path) (when (probe-file path) (delete-file path)))

;;; --- the verification proper -----------------------------------------------
;;; VERIFY-DESCENT is the whole point of the specimen: it takes an exterior root
;;; and a sequence of generation files and returns either T or the generation at
;;; which descent severed. It is a function of the ROOT, not of the artifacts —
;;; give it a different root and the same lineage fails; that relativity is the
;;; honest content of the word "witnessed".

(defun verify-descent (h0 paths &key deposits)
  "Walk PATHS forward from H0. Return (values ok failure-generation reason)."
  (let ((prev h0))
    (loop for path in paths
          for expected-gen from 1
          do (multiple-value-bind (lam copy body carried gen) (read-generation path)
               (unless (equal lam copy)
                 (return-from verify-descent
                   (values nil gen :code-not-its-own-quoted-copy)))
               (unless (eql gen expected-gen)
                 (return-from verify-descent
                   (values nil gen :generation-out-of-order)))
               (let ((recomputed (link prev (body-of lam body) gen)))
                 (unless (eql recomputed carried)
                   (return-from verify-descent
                     (values nil gen :link-does-not-descend)))
                 (let ((deposited (cdr (assoc gen deposits))))
                   (when (and deposited (not (eql deposited carried)))
                     (return-from verify-descent
                       (values nil gen :contradicts-deposited-witness))))
                 (setf prev recomputed))))
    (values t nil nil)))

;;; --- the integrity-consistency quine's OWN hash ----------------------------
;;; Deliberately NOT chain.lisp's CANON: to forge that specimen one must speak
;;; its arithmetic, which is a bare PRIN1-TO-STRING of the motto. Reproduced
;;; here exactly, and confirmed against the committed seal before it is trusted.

(defun alarm-p (text)
  "Is TEXT the integrity quine's ALARM, i.e. (QUOTE (INTEGRITY-VIOLATED ...))?

NOT a substring search. Searching the output for \"INTEGRITY-VIOLATED\" is a
FALSE-POSITIVE detector and cost this build a wrong verdict: the integrity
quine's own source carries that symbol inside its else-branch, so a FAITHFUL
CHILD contains the string too. The distinction is structural — an alarm is a
one-element quoted datum; a child is a four-element application — and it is
baked in as REGRESSION alarm-detector below."
  (let ((*package* (find-package *canon-package*)))
    (let ((form (read-from-string text)))
      (and (consp form) (eq (first form) 'quote)
           (consp (second form))
           (eq (first (second form)) (intern "INTEGRITY-VIOLATED" *canon-package*))))))

(defun integrity-hash (motto)
  (reduce (lambda (a c) (mod (+ (* a 31) c) 1000000007))
          (map 'list #'char-code (prin1-to-string motto))
          :initial-value 0))

(defun forge-integrity-quine (source-text new-motto-tail)
  "Return the text of a SELF-CONSISTENT forgery of integrity.lisp: the motto is
rewritten AND the carried seal is recomputed to match it."
  (let* ((old-tail "DO NOT EDIT THIS MOTTO")
         (at (search old-tail source-text)))
    (unless at (error "integrity.lisp no longer contains the expected motto tail"))
    (let* ((swapped (concatenate 'string
                                 (subseq source-text 0 at)
                                 new-motto-tail
                                 (subseq source-text (+ at (length old-tail)))))
           (motto-start (search "(QUOTE (COPY THE PARENS" swapped))
           (motto (let ((*package* (find-package *canon-package*)))
                    (second (read-from-string (subseq swapped motto-start)))))
           (new-sum (integrity-hash motto))
           (sum-at (position #\Space swapped :from-end t)))
      (concatenate 'string (subseq swapped 0 (1+ sum-at))
                   (format nil "~D)" new-sum)))))

;;; ---------------------------------------------------------------------------

(defun main ()
  (let* ((gens (loop for n from 1 to 5 collect (here (format nil "gen-0~D.lisp" n))))
         (w (witness-plist))
         (h0 (getf w :h0))
         (deposits (getf w :deposits))
         (tmp (list (here ".t-grown.lisp") (here ".t-forged-03.lisp")
                    (here ".t-forged-04.lisp") (here ".t-forged-05.lisp")
                    (here ".t-integrity-naive-out.lisp") (here ".t-integrity-forged.lisp")
                    (here ".t-integrity-forged-out.lisp") (here ".t-adv-witness.sexp")
                    (here ".t-adv-01.lisp") (here ".t-adv-02.lisp")
                    (here ".t-adv-03.lisp")))
         (grown (first tmp)))
    (unwind-protect
      (progn
(format t "~&;;;; QUINE ORCHARD — Planting 11: the witnessed-lineage quine~%")
(format t ";;;; SBCL ~A~%" (lisp-implementation-version))

(format t "~%;;; 1 — the lineage is a real quine family~%")
(loop for path in gens
      for n from 1
      when (< n 5)
      do (run-script-to path grown)
         (check (same-bytes-p grown (nth n gens))
                (format nil "gen-0~D executes to the committed gen-0~D, byte-for-byte" n (1+ n))))
(check (notany (lambda (p) (= 10 (aref (file-bytes p) (1- (length (file-bytes p))))))
               gens)
       "no generation carries a trailing newline (last byte is 0x29)")

(format t "~%;;; 2 — exteriority, checked and not merely promised~%")
(let* ((root-digits (format nil "~D" h0))
       (root-phrase (getf w :root-provenance))
       (scanned (append gens (list (here "chain.lisp") (here "plant.lisp")
                                   (here "verify-descent.lisp") (here "WITNESS-NOTE.md")))))
  (check (notany (lambda (p) (search root-digits (file-text p))) scanned)
         (format nil "the root's decimal form occurs in NONE of the ~D scanned specimen files"
                 (length scanned)))
  (check (notany (lambda (p) (search root-phrase (file-text p))) scanned)
         "nor does the phrase the root is derived from")
  (check (probe-file (here "WITNESS-ROOT.sexp"))
         "the root lives in exactly one file, and that file is not an artifact")
  ;; The load-bearing structural consequence, exhibited rather than asserted:
  ;; the artifacts cannot compute their own first link, because H_1 needs H_0.
  (multiple-value-bind (lam copy body carried gen) (read-generation (first gens))
    (declare (ignore copy carried))
    (check (and (eql gen 1)
                (not (eql (link 0 (body-of lam body) 1)
                          (link h0 (body-of lam body) 1))))
           "H_1 depends on H_0: substituting any other root yields a different link")))

(format t "~%;;; 3 — descent from the exterior root~%")
(multiple-value-bind (ok gen reason) (verify-descent h0 gens :deposits deposits)
  (declare (ignore gen reason))
  (check ok "gen-01..gen-05 descend from the witnessed root (5 links recomputed)"))
(loop for path in gens
      for n from 1
      do (multiple-value-bind (lam copy body carried gen) (read-generation path)
           (declare (ignore copy))
           (format t "       gen-0~D  N=~D  carried H=~9D  recomputed=~9D~%"
                   n gen carried
                   (link (if (= n 1) h0
                             (nth-value 3 (read-generation (nth (- n 2) gens))))
                         (body-of lam body) gen))))
(multiple-value-bind (ok gen reason) (verify-descent (1+ h0) gens :deposits nil)
  (check (and (not ok) (eql gen 1) (eq reason :link-does-not-descend))
         "and the SAME lineage fails against a root off by one: descent is relative"))

(format t "~%;;; 4 — PANEL A: naive tamper, caught by internal consistency alone~%")
(let ((naive-out (nth 4 tmp)))
  (run-script-to (orchard "integrity/tampered.lisp") naive-out)
  (let ((out (file-text naive-out)))
    (format t "       $ sbcl --script integrity/tampered.lisp~%       ~A~%" out)
    (check (alarm-p out)
           "motto changed, carried seal left alone -> the integrity quine ALARMS")
    (check (not (same-bytes-p naive-out (orchard "integrity/tampered.lisp")))
           "and it produces no child at all: the naive tamper is sterile")))

(format t "~%;;; 5 — PANEL B: self-consistent forgery, which internal consistency PASSES~%")
(let* ((src (file-text (orchard "integrity/integrity.lisp")))
       (forged-path (nth 5 tmp))
       (forged-out (nth 6 tmp)))
  (multiple-value-bind (motto) (let ((*package* (find-package *canon-package*)))
                                 (second (read-from-string
                                          (subseq src (search "(QUOTE (COPY THE PARENS" src)))))
    (check (eql (integrity-hash motto)
                (parse-integer (subseq src (1+ (position #\Space src :from-end t)))
                               :junk-allowed t))
           "the forger's arithmetic reproduces the committed seal, so it speaks the victim's language"))
  (put-text forged-path (forge-integrity-quine src "THE SEAL WAS RECOMPUTED"))
  (run-script-to forged-path forged-out)
  (format t "       forged motto + recomputed seal, tail of the artifact:~%       ...~A~%"
          (subseq (file-text forged-path) (- (length (file-text forged-path)) 76)))
  (check (not (alarm-p (file-text forged-out)))
         "the forgery does NOT alarm: its internal equality holds")
  (check (same-bytes-p forged-out forged-path)
         "it reproduces itself byte-for-byte — a faithful child of a rewritten parent")
  (check (not (same-bytes-p forged-path (orchard "integrity/integrity.lisp")))
         "and it is not the committed specimen: scripture AND seal both moved"))

(format t "~%;;; 6 — PANEL C: the same move against the lineage — descent SEVERS~%")
(let* ((forged-03 (nth 1 tmp))
       (h2 (nth-value 3 (read-generation (second gens))))
       (forged-body '(DESCENT WAS NEVER CHECKED AGAINST ANYTHING OUTSIDE)))
  ;; The strongest single-file forgery available: rewrite gen-03's payload and
  ;; recompute its link from the GENUINE H_2, which the forger can simply read
  ;; out of gen-02. Nothing is left inconsistent within gen-03.
  (emit-generation forged-03 +specimen-lambda+ forged-body
                   (link h2 (body-of +specimen-lambda+ forged-body) 3) 3)
  (let ((chain (list (first gens) (second gens) forged-03 (fourth gens) (fifth gens))))
    (multiple-value-bind (ok gen reason) (verify-descent h0 chain)
      ;; CANON, not ~A of the list: ~A pretty-prints, and with
      ;; *print-right-margin* NIL the implementation picks the margin — a
      ;; wrapped line here would differ between machines while two runs on one
      ;; machine agreed. Same reason CANON exists at all.
      (format t "       forged gen-03 payload: ~A~%" (canon forged-body))
      (format t "       verify-descent -> ok=~A generation=~A reason=~A~%" ok gen reason)
      (check (and (not ok) (eql gen 4) (eq reason :link-does-not-descend))
             "gen-03 passes its own link and gen-04 FAILS: the sever is one generation downstream")))
  ;; and the sever is not an artifact of stopping early — gen-03's own link is fine
  (multiple-value-bind (ok gen reason)
      (verify-descent h0 (list (first gens) (second gens) forged-03))
    (declare (ignore gen reason))
    (check ok "truncated at the forgery, the forged chain verifies: local consistency is intact")))

(format t "~%;;; 7 — PANEL C2: the forger rewrites the descendants too~%")
(let* ((forged-03 (nth 1 tmp)) (forged-04 (nth 2 tmp)) (forged-05 (nth 3 tmp)))
  ;; The forged gen-03 is itself a working quine, so the forger does not even
  ;; need to understand the chain: they run it.
  (run-script-to forged-03 forged-04)
  (run-script-to forged-04 forged-05)
  (let ((chain (list (first gens) (second gens) forged-03 forged-04 forged-05)))
    (multiple-value-bind (ok gen reason) (verify-descent h0 chain)
      (declare (ignore gen reason))
      (check ok "against the ROOT ALONE the fully-rewritten chain VERIFIES — the root pins origin, not bodies"))
    (multiple-value-bind (ok gen reason) (verify-descent h0 chain :deposits deposits)
      (format t "       with the deposited link for generation 5 held exteriorly:~%")
      (format t "       verify-descent -> ok=~A generation=~A reason=~A~%" ok gen reason)
      (check (and (not ok) (eql gen 5) (eq reason :contradicts-deposited-witness))
             "the deposited later link catches it: deposits pin every body up to their generation"))))

(format t "~%;;; 8 — PANEL D: the CEILING. An adversary who holds the root forges everything~%")
(let* ((adv-witness (nth 7 tmp))
       (adv-h0 (digest-string "AN ANCHOR I CHOSE MYSELF"))
       (adv-body '(A LINEAGE ROOTED IN A WITNESS I WROTE PROVES ONLY THAT I CAN WRITE))
       (adv (list (nth 8 tmp) (nth 9 tmp) (nth 10 tmp))))
  (put-text adv-witness (format nil "(:H0 ~D :ROOT-PROVENANCE \"forged\" :DEPOSITS NIL)" adv-h0))
  (emit-generation (first adv) +specimen-lambda+ adv-body
                   (link adv-h0 (body-of +specimen-lambda+ adv-body) 1) 1)
  (run-script-to (first adv) (second adv))
  (run-script-to (second adv) (third adv))
  (let ((adv-plist (witness-plist adv-witness)))
    (multiple-value-bind (ok gen reason) (verify-descent (getf adv-plist :h0) adv)
      (declare (ignore gen reason))
      (check ok "a wholly forged lineage VERIFIES against the forged witness shipped with it")))
  (multiple-value-bind (ok gen reason) (verify-descent h0 adv)
    (declare (ignore gen reason))
    (check (not ok)
           "and fails against THIS lab's root — which is the entire content of the word 'witnessed'"))
  (check (not (eql adv-h0 h0))
         "the ceiling stated as a check: descent is relative to an anchor, and an anchor you control certifies nothing"))

(format t "~%;;; 9 — regressions (each of these was a real bug in this build)~%")
;; REGRESSION alarm-detector: the first draft of PANEL B decided "did the victim
;; alarm?" by searching the child's text for "INTEGRITY-VIOLATED". That is a
;; false-positive detector — the integrity quine carries the symbol in its own
;; else-branch, so a FAITHFUL child contains it too — and it made the build
;; report a correct forgery as caught. Both halves asserted: the naive detector
;; misfires on a faithful artifact, ALARM-P does not.
(let ((faithful (file-text (orchard "integrity/integrity.lisp")))
      (real-alarm (file-text (nth 4 tmp))))
  (check (search "INTEGRITY-VIOLATED" faithful)
         "REGRESSION alarm-detector: a FAITHFUL integrity artifact contains the alarm's own symbol (bug exhibited)")
  (check (and (not (alarm-p faithful)) (alarm-p real-alarm))
         "REGRESSION alarm-detector: ALARM-P separates a one-element alarm datum from a four-element child (fix held)"))
;; REGRESSION printer-independence: an unpinned PRIN1-TO-STRING of the specimen
;; lambda is NOT stable under hostile printer settings, so a link computed that
;; way would differ between two configurations of the same SBCL. CANON pins
;; every control explicitly. Both halves are asserted: the naive form breaks,
;; the canonical form does not.
(let ((naive-a (prin1-to-string +specimen-lambda+))
      (naive-b (let ((*print-case* :downcase) (*print-length* 3))
                 (prin1-to-string +specimen-lambda+)))
      (canon-a (canon +specimen-lambda+))
      (canon-b (let ((*print-case* :downcase) (*print-length* 3)
                     (*print-level* 2) (*print-pretty* t) (*print-right-margin* 40)
                     (*package* (find-package "COMMON-LISP")))
                 (canon +specimen-lambda+))))
  (check (not (string= naive-a naive-b))
         "REGRESSION printer-independence: an UNPINNED prin1-to-string does drift (bug exhibited)")
  (check (string= canon-a canon-b)
         "REGRESSION printer-independence: CANON is byte-stable under hostile printer settings (fix held)"))
;; REGRESSION body-coverage: body_n is (X BODY) — the CODE as well as the
;; payload — so editing the lambda severs descent too. An earlier draft hashed
;; only the payload, which would have let an adversary rewrite the program
;; wholesale while the chain stayed green.
(let ((edited (copy-tree +specimen-lambda+)))
  (check (not (eql (link 0 (body-of +specimen-lambda+ +specimen-body+) 1)
                   (link 0 (body-of (append edited '(NIL)) +specimen-body+) 1)))
         "REGRESSION body-coverage: altering the CODE form changes the link, not only the payload"))
;; REGRESSION generation-in-the-formula: n enters H_n, so two generations with
;; identical body and identical predecessor still carry different links. Without
;; it, a lineage could be truncated or extended silently.
(check (not (eql (link 42 (body-of +specimen-lambda+ +specimen-body+) 3)
                 (link 42 (body-of +specimen-lambda+ +specimen-body+) 4)))
       "REGRESSION generation-in-the-formula: n is inside H_n, so length is pinned")
;; REGRESSION quoted-copy: a generation whose operator and quoted copy disagree
;; is not a quine and must be refused before its link is even considered.
(let ((bad (here ".t-grown.lisp")))
  (put-text bad (canon (list +specimen-lambda+ (list 'quote '(LAMBDA () NIL))
                             (list 'quote +specimen-body+) 1 1)))
  (multiple-value-bind (ok gen reason) (verify-descent h0 (list bad))
    (declare (ignore gen))
    (check (and (not ok) (eq reason :code-not-its-own-quoted-copy))
           "REGRESSION quoted-copy: operator /= its quoted copy is refused as a non-quine")))

(format t "~%;;; 10 — teeth~%")
(let ((teeth nil))
  (handler-case (check nil "PLANTED: false must signal")
    (error () (setf teeth t)))
  (check teeth "the assertion machinery caught its planted failure"))

(format t "~%;;;; ~D checks passed.~%" *checks*)
(format t ";;;; what this specimen establishes: descent relative to an anchor it does not control.~%")
(format t ";;;; what it does not establish: authenticity, security, or trust from nothing.~%")
t)
      (mapc #'delete-if-present tmp))))

(main)
