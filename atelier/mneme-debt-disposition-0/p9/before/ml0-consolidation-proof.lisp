;;;; ml0-consolidation-proof.lisp — Memory Layer /0: THE CONSOLIDATION CONTRACT,
;;;; COMPLETED (R4.1) — typed carrier, materialization, fresh-process retrieval.
;;;;
;;;;   cd experiments/latent-lisp && sbcl --script mneme/memory-layer-0/ml0-consolidation-proof.lisp
;;;;
;;;; Sentinel: ml0-consolidation-proof: <n> checks, <m> failures   (exit 1 on any failure)
;;;;
;;;; HISTORY.  The FIRST version of this file (lab commit 0f152ade, capture
;;;; RED-CONSOLIDATION-BEFORE.txt, exit 1) walked R4's documented durable route —
;;;; `ml0-consolidate` → five bare values → `make-ml0-bundle :sources` →
;;;; `ml0-write :derivation :consolidation` — and measured that a computed
;;;; :OCCURRED was written back as :UNRESOLVED with every inherited row downgraded
;;;; to testimony, and that a :RAW-DECODE account was admitted as an input.  That
;;;; version could not be kept alive here because the API it walked no longer
;;;; exists (`ml0-write` lost its `:derivation`/`:predecessors` keywords); it lives
;;;; in git and its capture lives beside this file.
;;;;
;;;; WHAT THIS VERSION DEMONSTRATES, each as a numbered check:
;;;;   · a non-validated (raw-decode) input is DECLINED with a typed condition
;;;;   · consolidate → materialize → FRESH-PROCESS retrieve preserves :OCCURRED
;;;;   · issuance remains a separate axis on the derived account
;;;;   · predecessor identities and EVERY distinct source row survive
;;;;   · the CONTROLLED contradiction case survives as :CONTRADICTED across
;;;;     materialization and a fresh-process retrieval
;;;;   · reversing input order yields BYTE-IDENTICAL derived content
;;;;   · direct-write self-contradiction refusal (ML0-WR-6) is UNCHANGED
;;;;   · `ml0-write` no longer accepts `:derivation` (ordinary arguments cannot
;;;;     select lineage)
;;;;   · §8 (R4.1b, after SCRUTATOR's cross-family review): the #S reader cannot
;;;;     build any lane struct; a carrier whose lists are rewritten is REFUSED at
;;;;     materialization (the store is re-read and re-folded; mismatch = MAT-2);
;;;;     the principal is not re-prefixed and a derived account re-consolidates
;;;;     with its input; cross-store materialization is refused (MAT-3).
;;;;
;;;; ⚠ THE CONTRADICTION IS CONTROLLED, AND LABELLED AS SUCH.  Two correct doors
;;;; reading one universe over one interval agree by construction, so a genuine
;;;; :contradicted is unreachable through the production doors (the RETURN says
;;;; so since R2).  This probe MODELS the case :contradicted exists for — one
;;;; door's row is WRONG or TAMPERED — by re-copying a real absence door's row
;;;; (door-validated, subject-bound) onto the positive row's universe and
;;;; interval, through the lane's INTERNAL row constructor from inside the lane
;;;; package.  A caller outside the package cannot do this.  What the probe then
;;;; proves is the CARRIER'S contract: if consolidation lawfully computes
;;;; :contradicted, materialization writes it and retrieval returns it.
;;;;
;;;; FRESH PROCESS: the reader arm is this same file re-invoked under
;;;; `sb-ext:run-program` with `--read <account-dir> <hex> <expected>`; it opens
;;;; the store with `open-store`, retrieves, and exits 0 iff the standing and
;;;; derivation match.  No in-memory object crosses; only bytes on disk.
;;;;
;;;; — Claude Fable 5 (chair), 2026-08-21

(require :sb-posix)
(load (merge-pathnames "ml0-suite-ground.lisp"
                       (make-pathname :name nil :type nil :defaults *load-truename*)))
(in-package #:lisp-plus-memory-layer0)

(defparameter *lane-directory* (make-pathname :name nil :type nil :defaults *load-truename*))
(defparameter *subject-root* (merge-pathnames "../../" *lane-directory*))
(defparameter *argv* (rest sb-ext:*posix-argv*))

;;; ---------------------------------------------------------------------------
;;; READER ARM — a genuinely new process.
(when (equal (first *argv*) "--read")
  (destructuring-bind (account-directory hex expected) (rest *argv*)
    (let* ((store (open-store (pathname account-directory)))
           (account (ml0-retrieve store :account-hex hex))
           (standing (ml0-account-occurrence-standing account))
           (ok (and (string-equal expected (symbol-name standing))
                    (eq :consolidation (ml0-account-derivation account))
                    (eq :validated-retrieval (ml0-account-standing-authority account)))))
      (format t "~&reader: ~a occurrence=~s derivation=~s authority=~s predecessors=~d sources=~d row-standings=~s~%"
              (subseq hex 0 12) standing (ml0-account-derivation account)
              (ml0-account-standing-authority account)
              (length (ml0-account-predecessors account))
              (length (ml0-account-sources account))
              (remove-duplicates (mapcar #'ml0-source-validation-standing
                                         (ml0-account-sources account))))
      (finish-output)
      (sb-ext:exit :code (if ok 0 1)))))

(defun fresh-process-reads (account-directory hex expected)
  "Run the reader arm in a NEW sbcl process; return (values exit-code output)."
  (let* ((out (make-string-output-stream))
         (process (sb-ext:run-program "sbcl"
                                      (list "--script" (namestring *load-truename*)
                                            "--read" (namestring account-directory)
                                            hex expected)
                                      :search t :output out :error out
                                      :directory (namestring *subject-root*))))
    (values (sb-ext:process-exit-code process) (get-output-stream-string out))))

(defun modelled-commensurable-negative (real-negative-observation positive-source)
  "⚠ MODELLED TAMPER, test-only: the real absence door's row re-copied onto the
POSITIVE row's universe and interval so the pair is commensurable.  Door stamp,
binding and every other field are the real door's."
  (let ((src (ml0-observation-source real-negative-observation)))
    (%make-ml0-observation
     :door (ml0-observation-door real-negative-observation)
     :read-summary "MODELLED: the absence door's row, re-scoped onto the positive's universe/interval"
     :source (%make-ml0-source
              :species (ml0-source-species src)
              :acquisition-route (ml0-source-acquisition-route src)
              :producer-principal (ml0-source-producer-principal src)
              :recorder-principal (ml0-source-recorder-principal src)
              :coordinate (ml0-source-coordinate src)
              :observation-scope (make-ml0-scope
                                  :universe (ml0-scope-universe
                                             (ml0-source-observation-scope positive-source))
                                  :status :looked
                                  :detail "MODELLED negative: re-scoped onto the positive row's universe")
              :origin-as-read (ml0-source-origin-as-read src)
              :subject-act-id (ml0-source-subject-act-id src)
              :payload-digest (ml0-source-payload-digest src)
              :frontier-relation (ml0-source-frontier-relation src)
              :attests (ml0-source-attests src)
              :observation-interval (ml0-source-observation-interval positive-source)
              :validation-standing (ml0-source-validation-standing src)
              :door (ml0-source-door src)
              :recorded-validation (ml0-source-recorded-validation src)))))

(let ((root (ml0-fresh-run-root "ml0-consolidation-proof" *subject-root*)))
  (unwind-protect
       (progn
         (ml0-ground root)
         (let* ((settled (ml0-settled-row))
                (refused (ml0-refused-row))
                (account-directory (merge-pathnames "account-store/" root)))
           (setf lisp-plus-language-act1:*act1-fixture-table* (list settled refused))
           (ml0-open-authority (list settled refused))
           (let* ((settled-result (lisp-plus-language-act1:run-act1 settled :verbose nil))
                  (act-id (nth-value 0 (ml0-rederive-act-identity settled)))
                  (a (ml0-write *ml0-account-store*
                                (make-ml0-bundle
                                 :fixture-row settled :claimed-act-id act-id
                                 :subject-principal *suite-actor*
                                 :observations (list (ml0-world-observation act-id "a-prima"))
                                 :issuance-observation (ml0-issuance-observation-for act-id settled-result))))
                  (b (ml0-write *ml0-account-store*
                                (make-ml0-bundle
                                 :fixture-row settled :claimed-act-id act-id
                                 :subject-principal *suite-actor*
                                 :observations (list (ml0-journal-observation act-id "a-prima"))
                                 :sources (list (ml0-self-report-source act-id "second reading")))))
                  (ra (ml0-retrieve *ml0-account-store* :account-hex (ml0-account-id-hex a)))
                  (rb (ml0-retrieve *ml0-account-store* :account-hex (ml0-account-id-hex b))))
             (format t "~&---- §1 inputs ----~%")
             (ml0-check "both inputs are validated-retrieval accounts standing :OCCURRED; A issued, B issuance :unresolved"
                        (and (eq :validated-retrieval (ml0-account-standing-authority ra))
                             (eq :validated-retrieval (ml0-account-standing-authority rb))
                             (eq :occurred (ml0-account-occurrence-standing ra))
                             (eq :occurred (ml0-account-occurrence-standing rb))
                             (eq :issued-in-writing-image (ml0-account-issuance-standing ra))
                             (eq :unresolved (ml0-account-issuance-standing rb))))

             (format t "~&---- §2 the gate: non-validated input declined, typed ----~%")
             (ml0-check "a RAW-DECODE account is declined with ML0-CONSOLIDATION-REFUSED / ML0-CON-3"
                        (handler-case
                            (let ((raw (ml0-account-from-event
                                        (aref (prefix-report-events (validate-journal *ml0-account-store*)) 0))))
                              (ml0-consolidate (list raw rb))
                              nil)
                          (ml0-consolidation-refused (c)
                            (string= "ML0-CON-3" (ml0-condition-requirement-id c)))))
             (ml0-check "a non-account is declined (ML0-CON-1)"
                        (handler-case (progn (ml0-consolidate (list ra :not-an-account)) nil)
                          (ml0-consolidation-refused (c)
                            (string= "ML0-CON-1" (ml0-condition-requirement-id c)))))

             (format t "~&---- §3 consolidate -> typed carrier ----~%")
             (let* ((c (ml0-consolidate (list ra rb)))
                    (c-reversed (ml0-consolidate (list rb ra))))
               (format t "  carrier: occurrence ~s issuance ~s coverage ~s sources ~d predecessors ~d inputs ~d~%"
                       (ml0-consolidation-occurrence-standing c)
                       (ml0-consolidation-issuance-standing c)
                       (ml0-consolidation-record-coverage c)
                       (length (ml0-consolidation-sources c))
                       (length (ml0-consolidation-predecessors c))
                       (length (ml0-consolidation-inputs c)))
               (ml0-check "the result is an ML0-CONSOLIDATION carrier" (ml0-consolidation-p c))
               (ml0-check "the carrier's constructor is INTERNAL (not exported)"
                          (not (eq :external (nth-value 1 (find-symbol "%MAKE-ML0-CONSOLIDATION"
                                                                       :lisp-plus-memory-layer0)))))
               (ml0-check "carrier computes :OCCURRED over the union; issuance folded separately to :ISSUED-IN-WRITING-IMAGE"
                          (and (eq :occurred (ml0-consolidation-occurrence-standing c))
                               (eq :issued-in-writing-image (ml0-consolidation-issuance-standing c))))
               (ml0-check "exact source union: 4 distinct rows (world, issuance, journal, self-report), none collapsed"
                          (= 4 (length (ml0-consolidation-sources c))))
               (ml0-check "inherited observation rows are NOT testimony in the carrier"
                          (= 3 (count :inherited-from-validated-record
                                      (ml0-consolidation-sources c)
                                      :key #'ml0-source-validation-standing)))
               (ml0-check "reversed input order: same predecessor order, same source order (content-ordered, not caller-ordered)"
                          (and (equal (mapcar #'ml0-account-id-hex (ml0-consolidation-inputs c))
                                      (mapcar #'ml0-account-id-hex (ml0-consolidation-inputs c-reversed)))
                               (equal (mapcar (lambda (s) (digest-of (ml0-source-record s)))
                                              (ml0-consolidation-sources c))
                                      (mapcar (lambda (s) (digest-of (ml0-source-record s)))
                                              (ml0-consolidation-sources c-reversed)))))

               (format t "~&---- §4 materialize -> durable derived account ----~%")
               (let* ((frames-before (prefix-report-frame-count (validate-journal *ml0-account-store*)))
                      (d (ml0-materialize-consolidation *ml0-account-store* c))
                      (d-reversed (ml0-materialize-consolidation *ml0-account-store* c-reversed)))
                 (format t "  derived ~a: occurrence ~s issuance ~s derivation ~s predecessors ~d sources ~d~%"
                         (subseq (ml0-account-id-hex d) 0 12)
                         (ml0-account-occurrence-standing d) (ml0-account-issuance-standing d)
                         (ml0-account-derivation d) (length (ml0-account-predecessors d))
                         (length (ml0-account-sources d)))
                 (ml0-check "the returned derived account is read back through a validated retrieval and stands :OCCURRED"
                            (and (eq :validated-retrieval (ml0-account-standing-authority d))
                                 (eq :occurred (ml0-account-occurrence-standing d))
                                 (eq :consolidation (ml0-account-derivation d))))
                 (ml0-check "issuance remains a SEPARATE axis on the derived account"
                            (and (eq :issued-in-writing-image (ml0-account-issuance-standing d))
                                 (equal (ml0-account-carried-standings d)
                                        (list :occurrence-standing :occurred
                                              :issuance-standing :issued-in-writing-image
                                              :record-coverage (ml0-account-record-coverage d)))))
                 (ml0-check "BOTH predecessor identities survive, in content order"
                            (and (= 2 (length (ml0-account-predecessors d)))
                                 (equal (mapcar #'identifier-segment-string (ml0-account-predecessors d))
                                        (mapcar (lambda (acc) (identifier-segment-string (ml0-account-id-datum acc)))
                                                (ml0-consolidation-inputs c)))))
                 (ml0-check "EVERY distinct source row survives the write, by canonical digest"
                            (equal (mapcar (lambda (s) (digest-of (ml0-source-record s)))
                                           (ml0-consolidation-sources c))
                                   (mapcar (lambda (s) (digest-of (ml0-source-record s)))
                                           (ml0-account-sources d))))
                 (ml0-check "inherited rows re-inherit on readback (not converted to testimony)"
                            (= 3 (count :inherited-from-validated-record (ml0-account-sources d)
                                        :key #'ml0-source-validation-standing)))
                 (ml0-check "REVERSED INPUT ORDER materializes BYTE-IDENTICAL derived content (same content-derived identity)"
                            (string= (ml0-account-id-hex d) (ml0-account-id-hex d-reversed)))
                 ;; ⚑ PJ0 LAW, MEASURED: `append-event` is idempotent on EVENT
                 ;; IDENTITY (PJ-APP-1..3, writer.lisp §9), and the derived
                 ;; account's event identity is content-derived — so the SAME
                 ;; derived content materialized twice (here: from the two input
                 ;; orders) lands on ONE frame.  The chair's first draft of this
                 ;; check expected two frames and was wrong; corrected on the
                 ;; measurement, not on the expectation.
                 (ml0-check "two materializations of BYTE-IDENTICAL derived content land on ONE frame (PJ0 append idempotency on content-derived identity)"
                            (= 1 (- (prefix-report-frame-count (validate-journal *ml0-account-store*))
                                    frames-before))
                            "(~d -> ~d frames)"
                            frames-before
                            (prefix-report-frame-count (validate-journal *ml0-account-store*)))

                 (format t "~&---- §5 FRESH-PROCESS retrieval of the derived account ----~%")
                 (multiple-value-bind (code output)
                     (fresh-process-reads account-directory (ml0-account-id-hex d) "occurred")
                   (format t "~a" (string-right-trim '(#\Newline) (remove-if (lambda (ch) (char= ch #\Return)) output)))
                   (format t "~&  reader exit=~d~%" code)
                   (ml0-check "a NEW process opens the store, retrieves the derived account, and reads :OCCURRED / :consolidation"
                              (eql 0 code)))

                 (format t "~&---- §6 the carrier route; no ordinary argument selects lineage (construction privacy is defense in depth) ----~%")
                 (ml0-check "ml0-write no longer accepts :derivation (arglist = store bundle &key recording-process)"
                            (handler-case
                                (progn (ml0-write *ml0-account-store*
                                                  (make-ml0-bundle :fixture-row settled :claimed-act-id act-id
                                                                   :subject-principal *suite-actor*
                                                                   :sources (ml0-consolidation-sources c))
                                                  :derivation :consolidation)
                                       nil)
                              (program-error () t)))
                 (ml0-check "materialization refuses anything that is not a carrier (ML0-MAT-1)"
                            (handler-case (progn (ml0-materialize-consolidation *ml0-account-store* ra) nil)
                              (ml0-consolidation-refused (cnd)
                                (string= "ML0-MAT-1" (ml0-condition-requirement-id cnd)))))
                 (ml0-check "the documented OLD route still normalizes inherited rows to testimony and writes :UNRESOLVED — the testimony channel is unchanged"
                            (let ((old (ml0-write *ml0-account-store*
                                                  (make-ml0-bundle :fixture-row settled :claimed-act-id act-id
                                                                   :subject-principal *suite-actor*
                                                                   :sources (ml0-consolidation-sources c)))))
                              (and (eq :unresolved (ml0-account-occurrence-standing old))
                                   (eq :direct-write (ml0-account-derivation old))
                                   (null (ml0-account-predecessors old)))))))

             (format t "~&---- §7 the CONTROLLED contradiction (MODELLED, test-only) ----~%")
             (let* ((positive-source (ml0-observation-source (ml0-world-observation act-id "a-prima")))
                    (real-negative (ml0-negative-observation act-id "a-prima"
                                                             :world (getf *ml0-worlds* :ambiguous)))
                    (modelled (modelled-commensurable-negative real-negative positive-source)))
               (ml0-check "the modelled pair IS commensurable (same universe, same interval, both :looked)"
                          (ml0-warrants-commensurable-p positive-source (ml0-observation-source modelled)))
               (ml0-check "DIRECT WRITE of both in ONE bundle is still REFUSED (ML0-WR-6) — self-contradiction refusal unchanged"
                          (handler-case
                              (progn (ml0-write *ml0-account-store*
                                                (make-ml0-bundle :fixture-row settled :claimed-act-id act-id
                                                                 :subject-principal *suite-actor*
                                                                 :observations (list (ml0-world-observation act-id "a-prima")
                                                                                     modelled)))
                                     nil)
                            (ml0-provenance-incomplete (cnd)
                              (string= "ML0-WR-6" (ml0-condition-requirement-id cnd)))))
               (let* ((neg (ml0-write *ml0-account-store*
                                      (make-ml0-bundle :fixture-row settled :claimed-act-id act-id
                                                       :subject-principal *suite-actor*
                                                       :observations (list modelled))))
                      (rneg (ml0-retrieve *ml0-account-store* :account-hex (ml0-account-id-hex neg)))
                      (cc (ml0-consolidate (list ra rneg)))
                      (dc (ml0-materialize-consolidation *ml0-account-store* cc)))
                 (format t "  negative account stands ~s; carrier ~s; derived ~a stands ~s~%"
                         (ml0-account-occurrence-standing rneg)
                         (ml0-consolidation-occurrence-standing cc)
                         (subseq (ml0-account-id-hex dc) 0 12)
                         (ml0-account-occurrence-standing dc))
                 (ml0-check "the modelled negative writes :NONOCCURRED on its own (a door-validated scoped negative)"
                            (eq :nonoccurred (ml0-account-occurrence-standing rneg)))
                 (ml0-check "consolidation of the validated positive and the validated negative computes :CONTRADICTED, naming the clash"
                            (and (eq :contradicted (ml0-consolidation-occurrence-standing cc))
                                 (consp (ml0-consolidation-clash cc))))
                 (ml0-check "materialization writes :CONTRADICTED and reads it back"
                            (and (eq :contradicted (ml0-account-occurrence-standing dc))
                                 (eq :consolidation (ml0-account-derivation dc))
                                 (= 2 (length (ml0-account-predecessors dc)))))
                 (ml0-check "both clashing warrants stand in the derived account's sources"
                            (and (some (lambda (s) (eq :world-bytes (ml0-source-species s))) (ml0-account-sources dc))
                                 (some (lambda (s) (eq :scoped-negative-observation (ml0-source-species s)))
                                       (ml0-account-sources dc))))
                 (multiple-value-bind (code output)
                     (fresh-process-reads account-directory (ml0-account-id-hex dc) "contradicted")
                   (format t "~a" (string-right-trim '(#\Newline) output))
                   (format t "~&  reader exit=~d~%" code)
                   (ml0-check "a NEW process reads the derived account as :CONTRADICTED / :consolidation"
                              (eql 0 code)))))))

         ;; ==================================================================
         ;; §8 — R4.1b: THE CARRIER IS A DATA OBJECT, AND THE STORE IS THE WITNESS
         ;; (SCRUTATOR's findings, cross-family; RED-CARRIER-BEFORE/AFTER.txt,
         ;; RED-HASH-S-BEFORE/AFTER.txt).
         ;; ==================================================================
         (format t "~&---- §8 the carrier is not trusted; the store is re-read ----~%")
         (let* ((settled (ml0-settled-row))
                (act-id (nth-value 0 (ml0-rederive-act-identity settled)))
                (a (ml0-write *ml0-account-store*
                              (make-ml0-bundle :fixture-row settled :claimed-act-id act-id
                                               :subject-principal *suite-actor*
                                               :observations (list (ml0-world-observation act-id "a-prima"))
                                               :sources (list (ml0-self-report-source act-id "§8 ground")))))
                (ra (ml0-retrieve *ml0-account-store* :account-hex (ml0-account-id-hex a))))
           (ml0-check "the CL #S reader cannot construct ANY lane struct from outside (BOA constructors): account, source, observation, bundle, carrier all READER-ERROR"
                      (every (lambda (form)
                               (handler-case (progn (read-from-string form) nil)
                                 (reader-error () t)))
                             '("#S(LISP-PLUS-MEMORY-LAYER0:ML0-ACCOUNT :OCCURRENCE-STANDING :OCCURRED :STANDING-AUTHORITY :VALIDATED-RETRIEVAL)"
                               "#S(LISP-PLUS-MEMORY-LAYER0:ML0-SOURCE :VALIDATION-STANDING :VALIDATED-BY-DOOR)"
                               "#S(LISP-PLUS-MEMORY-LAYER0:ML0-OBSERVATION :DOOR :WORLD-DOOR)"
                               "#S(LISP-PLUS-MEMORY-LAYER0:ML0-BUNDLE)"
                               "#S(LISP-PLUS-MEMORY-LAYER0:ML0-CONSOLIDATION :OCCURRENCE-STANDING :OCCURRED)")))
           ;; ⚑ SCRIBA-II's warning, answered in code: the five-type check above is
           ;; a sample.  THIS check enumerates EVERY structure class the lane
           ;; package defines and proves #S fails for each, so a struct added later
           ;; without the BOA form trips a gate instead of opening a door.
           (ml0-check "EVERY structure class in the lane package refuses #S (enumerated, not sampled)"
                      (let ((types '()) (open '()))
                        (do-symbols (sym :lisp-plus-memory-layer0)
                          (when (and (eq (symbol-package sym) (find-package :lisp-plus-memory-layer0))
                                     (find-class sym nil)
                                     (typep (find-class sym) 'structure-class))
                            (pushnew sym types)))
                        (dolist (ty types)
                          (handler-case
                              (progn (read-from-string (format nil "#S(~a::~a)" (package-name (symbol-package ty)) (symbol-name ty)))
                                     (push ty open))
                            (reader-error () nil)))
                        (format t "  structure classes enumerated: ~d; #S-constructible: ~d ~s~%"
                                (length types) (length open) open)
                        (and (>= (length types) 10) (null open)))
                      )
           (ml0-check "a lawful carrier whose SOURCE LIST is rewritten through its reader is REFUSED at materialization (ML0-MAT-2), never written"
                      (let ((c (ml0-consolidate (list ra))))
                        (rplaca (ml0-consolidation-sources c) (ml0-self-report-source act-id "swapped-in"))
                        (handler-case (progn (ml0-materialize-consolidation *ml0-account-store* c) nil)
                          (ml0-consolidation-refused (cnd)
                            (string= "ML0-MAT-2" (ml0-condition-requirement-id cnd))))))
           (ml0-check "a lawful carrier whose PREDECESSOR LIST is rewritten is REFUSED (ML0-MAT-2)"
                      (let ((c (ml0-consolidate (list ra))))
                        (rplaca (ml0-consolidation-predecessors c) (ml0-account-act-id ra))
                        (handler-case (progn (ml0-materialize-consolidation *ml0-account-store* c) nil)
                          (ml0-consolidation-refused (cnd)
                            (string= "ML0-MAT-2" (ml0-condition-requirement-id cnd))))))
           (ml0-check "a COPY-STRUCTURE'd lawful carrier materializes the SAME content as the original (copying mints nothing)"
                      (let* ((c (ml0-consolidate (list ra)))
                             (d1 (ml0-materialize-consolidation *ml0-account-store* c))
                             (d2 (ml0-materialize-consolidation *ml0-account-store* (copy-structure c))))
                        (string= (ml0-account-id-hex d1) (ml0-account-id-hex d2))))
           (ml0-check "the derived account's subject principal is NOT re-prefixed (principal:<name>, once)"
                      (let ((d (ml0-materialize-consolidation *ml0-account-store* (ml0-consolidate (list ra)))))
                        (string= (ml0-account-subject-principal ra) (ml0-account-subject-principal d))))
           (ml0-check "a derived account can be RE-CONSOLIDATED with its own input (no ML0-CON-4), and the fold is non-amplifying (same standing, same source union)"
                      (let* ((d (ml0-materialize-consolidation *ml0-account-store* (ml0-consolidate (list ra))))
                             (c2 (ml0-consolidate (list ra d))))
                        (and (eq :occurred (ml0-consolidation-occurrence-standing c2))
                             (= (length (ml0-consolidation-sources c2)) (length (ml0-account-sources ra))))))
           (ml0-check "a carrier computed over accounts of THIS store cannot be materialized into a FOREIGN store (ML0-MAT-3) — lineage must be checkable by the store that holds it"
                      (let* ((other-root (ml0-fresh-run-root "ml0-consolidation-proof-b" *subject-root*))
                             (store-b (build-ml0-account-store other-root)))
                        (unwind-protect
                             (handler-case (progn (ml0-materialize-consolidation store-b (ml0-consolidate (list ra))) nil)
                               (ml0-consolidation-refused (cnd)
                                 (string= "ML0-MAT-3" (ml0-condition-requirement-id cnd))))
                          (ignore-errors (sb-ext:delete-directory other-root :recursive t))))))

         (format t "~&ml0-consolidation-proof: ~d checks, ~d failures~%"
                 (+ *ml0-checks-passed* *ml0-checks-failed*) *ml0-checks-failed*)
         (finish-output))
    (ignore-errors (sb-ext:delete-directory root :recursive t))))
(sb-ext:exit :code (if (zerop *ml0-checks-failed*) 0 1))
