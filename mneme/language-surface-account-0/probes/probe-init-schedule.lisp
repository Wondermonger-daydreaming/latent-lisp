;;;; probe-init-schedule.lisp
;;;;
;;;; ==========================================================================
;;;; NON-PRODUCTION FEASIBILITY PROBE — Surface Account /0 opening round —
;;;; not a package, not an API, not loadable as part of any system.
;;;; ==========================================================================
;;;;
;;;; THE TWO SCHEDULE-PINNED INITIALIZATION TEETH (R3.3-B).  This is the ONE new
;;;; probe harness the R3.3 commission authorizes, and it exists because the
;;;; owner's FINDING 1 refused the R3.2 evidence in exactly these words: the
;;;; eight-thread arm "happened to observe one favourable schedule", and a clean
;;;; claim must be "structural, not 'ran eight threads and hoped'".
;;;;
;;;; So nothing here is a thread count.  Every arm below FORCES one exact
;;;; interleaving with semaphores and barriers and then reports what that exact
;;;; interleaving produced.  There is no timing loop, no yield-and-pray, no
;;;; "with enough threads it will eventually happen".
;;;;
;;;; EIGHT ROLES, EIGHT FRESH IMAGES, SELECTED BY SA0_PROBE_SCHEDULE_ROLE
;;;; (stale and recursive from R3.3; post-election-failure, plist-foreign and
;;;; plist-contention added by R3.3.1; publication-finality and carrier-slot
;;;; added by R3.3.2; carrier-total added by R3.3.3):
;;;;
;;;;   stale      THE STALE-DEFINITION OVERWRITE TOOTH.  A fresh image in which
;;;;              the candidate identity source has never been loaded.  Two
;;;;              loaders are driven into the dangerous ordering; the CLEAN arm
;;;;              runs it against THE EXACT CANDIDATE SOURCE, and the PLANTED
;;;;              arm runs the same pinned ordering against a captive copy of
;;;;              the R3.2 DEFGLOBAL-then-CAS law and exhibits the clobber.
;;;;
;;;;   recursive  THE GENUINE RECURSIVE-LOAD TOOTH.  Another fresh image.  A
;;;;              test-only hook fires DURING initialization, before ready
;;;;              publication, and from inside it the same thread recursively
;;;;              LOADs the same exact identity source once.
;;;;
;;;; R3.3.1 ADDS THREE MORE ROLES, ONE PER RETURNED GOBLIN PLUS ITS CONTENTION
;;;; CASE.  Each is its own fresh image for the same reason as the two above:
;;;; each needs an image in which the candidate source has NEVER been loaded.
;;;;
;;;;   post-election-failure  THE UNPROTECTED POST-ELECTION INTERVAL.  A hook
;;;;              fires at the FIRST INSTANT AFTER A WON ELECTION — before the
;;;;              election is noted, before any epoch is gathered, before any
;;;;              state exists — and signals a condition there, while a second
;;;;              loader is PROVABLY parked on the cell's wait queue.  What must
;;;;              follow: a definitive failure marker, a woken observer that
;;;;              signals that failure inside the bound, no state, and a
;;;;              terminal image.  A separately labelled REPLICA arm exhibits
;;;;              the returned shape leaving the observer unwoken forever.
;;;;
;;;;   plist-foreign  THE CARRIER THAT ALREADY CARRIES SOMETHING.  Unrelated
;;;;              properties are installed on the carrier symbol BEFORE the
;;;;              first load.  The election must still succeed, the state must
;;;;              publish, allocations must run, and every unrelated property
;;;;              must survive VERBATIM.  The planted arm runs the returned
;;;;              whole-plist-versus-NIL compare under the same precondition and
;;;;              exhibits both that it can never succeed and that its loop
;;;;              never terminates.
;;;;
;;;;   plist-contention  THE PLIST THAT CHANGES BETWEEN THE READ AND THE CAS.
;;;;              A hook fires in the exact window between the two and mutates
;;;;              the carrier's plist, so the pending compare MUST fail.  The
;;;;              retry loop must re-read and converge, and the injected
;;;;              property must survive verbatim.  The planted arm shows a
;;;;              single-shot election losing the same race outright.
;;;;
;;;; R3.3.2 ADDS TWO MORE ROLES, ONE PER RETURNED DEFECT.
;;;;
;;;;   publication-finality  THE INSTANT AFTER THE STATE IS PUBLISHED.  Another
;;;;              fresh image.  A hook fires at the first instant after the
;;;;              state CAS has succeeded — the state installed and readable,
;;;;              the protected form not yet returned, the cleanup not yet run —
;;;;              and signals a condition there, while a second loader is
;;;;              PROVABLY parked on the cell's wait queue.  What must follow:
;;;;              state present, failure ABSENT, the sleeper woken WITH THE
;;;;              STATE, a retry that OBSERVES, one election, one gathering.  A
;;;;              separately labelled REPLICA arm exhibits the returned shape —
;;;;              publish, then a separate local flag — producing a cell that
;;;;              carries a state AND a failure at once, on which two honest
;;;;              readers return opposite answers.
;;;;
;;;;   carrier-slot  PRESENCE VERSUS VALUE IN THE RESERVED SLOT.  Another fresh
;;;;              image.  Four carriers are planted in turn — the reserved
;;;;              indicator carrying NIL, carrying two claims, carrying a
;;;;              foreign value, and a property list that is not one — and each
;;;;              must be REFUSED immediately, definitively and inside a bound;
;;;;              then one lawful cell must still be observed.  The REPLICA arm
;;;;              runs the returned GETF-then-CAS law against the ruling's own
;;;;              precondition and exhibits the silently prepended second
;;;;              indicator.  This role is the ONE that runs several arms in one
;;;;              image, and the reason is printed in the section: a REJECTED
;;;;              load holds no election, so it does not spend the moment.
;;;;
;;;; R3.3.3 ADDS ONE MORE ROLE, FOR THE ONE RETURNED SEAM.
;;;;
;;;;   carrier-total  THE MALFORMED-CARRIER TOTALITY CLOSURE.  Another fresh
;;;;              image.  R3.3.2's counting walk ran `while (consp tail)`, so a
;;;;              non-NIL ATOMIC tail ended it as though the plist had ended
;;;;              lawfully, and a CIRCULAR plist ended it never.  Three carriers
;;;;              are planted in turn — an improper (dotted) list, an improper
;;;;              list CARRYING one otherwise-lawful reserved cell, and a
;;;;              circular list — and each must be refused definitively, inside
;;;;              a bound, with no election, no gathering, no readiness and the
;;;;              plant left EQ-identical.  Two labelled REPLICA arms run the
;;;;              returned walk on the same two shapes and exhibit it accepting
;;;;              the dotted revenant as an empty lawful carrier, and expiring
;;;;              on the circular one.
;;;;
;;;; WHY EIGHT IMAGES AND NOT EIGHT ARMS OF ONE.  Six of the eight roles
;;;; require that the candidate source has NEVER been loaded in the image
;;;; when they begin — that is the only moment a first initialization can be
;;;; scheduled at all, each such tooth consumes it, and a second tooth in the
;;;; same image would be racing a decision already taken: a tautology wearing
;;;; a tooth's clothes.  The two documented exceptions are carrier-slot and
;;;; carrier-total, whose refusal arms spend nothing (a REJECTED load holds no
;;;; election — the reason is printed in each section, not assumed here);
;;;; carrier-slot's lawful arm runs last and is the arm that spends the moment,
;;;; and carrier-total has NO lawful arm at all, so its image never spends it —
;;;; which that section demonstrates by reading the counts back at the end.
;;;;
;;;; A TIMEOUT IS A FAILURE, NEVER A PASS.  Every wait in this file carries a
;;;; hard bound, every join carries a hard bound, and the outer load of the
;;;; recursive tooth runs inside SB-EXT:WITH-TIMEOUT.  An expiry is printed and
;;;; asserted against; it is never silently read as success and it is never
;;;; allowed to become an eternal laboratory lifestyle.
;;;;
;;;; THE BOUNDARY.  Host threads, host LOAD, and the candidate probe source
;;;; only.  No package is defined, nothing is exported, no Account /0 object is
;;;; minted, NEITHER PROVIDER IS TOUCHED, and nothing is written anywhere in
;;;; the worktree.

(in-package #:cl-user)

(defparameter *sa0-schedule-role*
  (or (sb-posix:getenv "SA0_PROBE_SCHEDULE_ROLE") "stale")
  "Which tooth this image runs.  See the role table above.")

(defparameter *sa0-identity-path*
  (merge-pathnames "probe-identity.lisp" (or *load-truename* *load-pathname*))
  "THE EXACT CANDIDATE SOURCE.  Both teeth load THIS file — not a miniature
that resembles it, not a re-implementation of its algorithm.  A tooth that
exercises a model of the source proves something about the model.")

(defparameter *sa0-hard-bound-seconds* 60
  "THE HARD TIME BOUND on every wait and every join in this file.")

(defparameter *sa0-spin-exhibit-seconds* 2
  "R3.3.1: THE BOUND ON AN ARM WHOSE EXPECTED OUTCOME IS EXPIRY.  It is small on
purpose and the smallness is not impatience: these arms EXHIBIT a loop that does
not terminate, so the bound is the length of the exhibition, not a threshold a
correct run has to beat.  A LONGER bound would prove nothing more, and every
second of it is spent in a hot loop.  An arm that must SUCCEED inside a bound
still uses *SA0-HARD-BOUND-SECONDS*.")

;;; --------------------------------------------------------------------------
;;; DETERMINISTIC GATES.  A barrier that releases only when all N parties have
;;; arrived, and semaphores for the explicit hand-offs.  Each barrier is a fresh
;;; closure over its own count, so two arms can never share one.
;;; --------------------------------------------------------------------------

(defun make-sa0-gate (n)
  "Return a closure that blocks until it has been called N times.  Its wait
carries the hard bound; a barrier that never releases would otherwise turn a
tooth into a hang."
  (let ((mutex (sb-thread:make-mutex :name "sa0-r33-gate"))
        (semaphore (sb-thread:make-semaphore :count 0))
        (count 0))
    (lambda ()
      (let ((last nil))
        (sb-thread:with-mutex (mutex)
          (incf count)
          (when (= count n) (setf last t)))
        (if last
            (sb-thread:signal-semaphore semaphore (1- n))
            (unless (sb-thread:wait-on-semaphore semaphore
                                                 :timeout *sa0-hard-bound-seconds*)
              (error "SA0 PROBE: a pinned barrier did not release within ~D s"
                     *sa0-hard-bound-seconds*)))
        last))))

(defvar *sa0-log-mutex* (sb-thread:make-mutex :name "sa0-r33-log"))
(defvar *sa0-phase-log* nil
  "Every call the candidate source made into the test gate, in order:
 (thread-name phase ready-p-at-that-moment).  PRINTED — the standing SBCL scar
requires an observation to land in a global and be printed, never discarded.")

(defun sa0-log-phase (entry)
  (sb-thread:with-mutex (*sa0-log-mutex*) (push entry *sa0-phase-log*)))

(defun sa0-thread-name ()
  (or (sb-thread:thread-name sb-thread:*current-thread*) "unnamed-thread"))

;;; The candidate source is not loaded when these closures are built, so every
;;; name it defines is reached through SYMBOL-FUNCTION at call time.
(defun sa0-call (name &rest args)
  (apply (symbol-function name) args))

(defun sa0-install-gate-hook (fn)
  "Install FN as the candidate source's test-only gate.  The property list of
SA0-IDENTITY-TEST-GATE is the agreed instrumentation channel; the candidate
source only ever READS it (see probe-identity.lisp)."
  (setf (get 'sa0-identity-test-gate 'sa0-hook) fn))

(defun sa0-remove-gate-hook ()
  (setf (get 'sa0-identity-test-gate 'sa0-hook) nil))

(defun sa0-join (thread)
  "Join under the hard bound.  Returns :TIMEOUT rather than waiting forever."
  (sb-thread:join-thread thread
                         :timeout *sa0-hard-bound-seconds*
                         :default :timeout))

;;; --------------------------------------------------------------------------
;;; R3.3.2 — THE GATE LOG IS NOW PARTITIONED BY PHASE, AND WHY THAT WAS FORCED.
;;;
;;; Two R3.3 checks — INIT-STALE-CLEAN-NO-PARTIAL-STATE-OBSERVED and
;;; INIT-RECURSIVE-NO-PARTIAL-READY-OBSERVED — assert that NO GATE OBSERVATION
;;; EVER SAW A PARTIALLY READY IMAGE.  That is a claim about the phases which
;;; PRECEDE the one publication, and when it was written EVERY declared phase
;;; preceded it, so it was spelled "every entry in the log" and the two spellings
;;; were the same sentence.
;;;
;;; THEY ARE NO LONGER THE SAME SENTENCE.  R3.3.2's repair needs a pin AFTER the
;;; state CAS, so the candidate source declares :PUBLISHED-BEFORE-RETURN, whose
;;; whole point is that readiness is ALREADY TRUE when it fires.  Any hook that
;;; logs every phase — the stale hook and the recursive hook both do — therefore
;;; records one entry with ready-p T, in the lawful path, by design.
;;;
;;; THE TWO PREDICATES ARE AMENDED, AND THE AMENDMENT'S EXACT SHAPE IS THIS.
;;; Before: every entry reports NIL.  After: every PRE-publication entry
;;; reports NIL, AND every POST-publication entry reports T.  On every phase
;;; class that existed when the old predicate was written the two are
;;; IDENTICAL — a pre-publication observation of a ready image still fails.
;;; On the post-publication class, which did not exist then, the old formula
;;; would have refused a lawful run outright; the amended one ADMITS that
;;; class and binds it to a REAL new obligation (the observation must report
;;; T and must have seen the state).  So this is not "nothing refused is now
;;; admitted" — the newly admitted case is precisely the class the old text
;;; could not anticipate — and it is not a relaxation on any observation the
;;; old predicate was written about.  The two checks keep
;;; their IDs, their positions and their profiles; the stale label already said
;;; "before publication" and is byte-unchanged, and the recursive label is
;;; corrected because it said "every gate observation in this image" and that
;;; sentence is no longer true of a lawful run.
;;;
;;; THE PHASE TABLE IN THE CANDIDATE SOURCE IS THE AUTHORITY.  The list below
;;; mirrors it and is the only place this harness names the distinction.
;;; --------------------------------------------------------------------------

(defparameter *sa0-post-publication-phases* '(:published-before-return)
  "The declared gate phases that fire AFTER the one publication.")

(defun sa0-pre-publication-entries (log)
  (remove-if (lambda (e) (member (second e) *sa0-post-publication-phases*)) log))

(defun sa0-post-publication-entries (log)
  (remove-if-not (lambda (e) (member (second e) *sa0-post-publication-phases*)) log))

(defun sa0-contiguous-from-1-p (counters n)
  (let ((sorted (sort (copy-list counters) #'<)))
    (and (= n (length sorted))
         (loop for want from 1 to n
               for got in sorted
               always (= want got)))))

;;; R3.3.1 helpers.

(defun sa0-flatten-line (string)
  "One line, always.  A condition report may carry newlines; a transcript line
that silently became two lines would be read by the grammar as a measurement
followed by prose, and the second half would look like something nobody wrote."
  (let ((out (make-string-output-stream)))
    (loop for ch across (princ-to-string string)
          do (if (or (char= ch #\Newline) (char= ch #\Return))
                 (write-string " / " out)
                 (write-char ch out)))
    (get-output-stream-string out)))

(defun sa0-first-line (string)
  "The first line of STRING, with no trailing newline.  Used where the rest of a
captured notice is an ABSOLUTE PATHNAME: this directory's transcripts never
print absolute paths — the header prints FILE-NAMESTRING deliberately — because
a packer re-running at the frozen tip from another directory would otherwise
differ from this run in a way that says nothing about the sources."
  (let* ((s (princ-to-string string))
         (nl (position #\Newline s)))
    (if nl (subseq s 0 nl) s)))

(defun sa0-take-allocations (n-threads per-thread)
  "N-THREADS × PER-THREAD allocations through the published allocator, gathered
into one list.  Every join carries the hard bound."
  (let ((acc nil)
        (mutex (sb-thread:make-mutex :name "sa0-r331-alloc")))
    (let ((threads (loop for i from 0 below n-threads
                         collect (sb-thread:make-thread
                                  (lambda ()
                                    (let ((mine (loop repeat per-thread
                                                      collect (sa0-call 'allocate-performance-counter))))
                                      (sb-thread:with-mutex (mutex)
                                        (setf acc (append mine acc)))))
                                  :name (format nil "sa0-r331-alloc-~D" i)))))
      (mapc #'sa0-join threads))
    acc))

(defun sa0-safe-read (name)
  "What a bare reader of the candidate source answers, INCLUDING when it refuses
or does not exist.

WHY THE R3.3.2 SECTIONS PRINT THROUGH THIS.  Two of their arms leave an image in
which the source's initialization did NOT complete — deliberately: the
carrier-slot arms are refused before any election, and the publication-finality
arm's winning load escapes with a planted condition.  Every name defined AFTER
the initialization form is then unbound, and a reader in a measurement line
would abort the whole section on the way past.  A section that aborts still
fails closed — no footer, no sentinel, nonzero exit — but it prints a backtrace
where a [FAIL] verdict belongs, and a tooth is worth more when it can SAY what
it caught.  So the measurement lines print the refusal; the CHECKS are
unwrapped, because a check that swallowed an error would be the opposite fault."
  (handler-case (format nil "~A" (sa0-call name))
    (error (c) (format nil "REFUSED / ~A" (sa0-flatten-line c)))))

;;; ==========================================================================
;;; ROLE  stale  —  THE STALE-DEFINITION OVERWRITE TOOTH
;;; ==========================================================================

(defvar *stale-winner-name* "SA0-R33-WINNER")
(defvar *stale-delayed-name* "SA0-R33-DELAYED")

(defvar *stale-gate* nil)
(defvar *stale-release* (sb-thread:make-semaphore :count 0))
(defvar *stale-winner-cell* nil)
(defvar *stale-winner-state* nil)
(defvar *stale-ready-at-release* :not-run)
(defvar *stale-delayed-observation* nil)
(defvar *stale-winner-join* :not-run)
(defvar *stale-delayed-join* :not-run)
(defvar *stale-allocations* nil)
(defvar *stale-alloc-mutex* (sb-thread:make-mutex :name "sa0-r33-alloc"))

(defun sa0-run-stale-clean-arm ()
  "PIN THE DANGEROUS ORDERING ON THE EXACT CANDIDATE SOURCE.

  1. both loaders enter the source's initialization and reach the point at
     which each has OBSERVED THE PRE-INITIAL STATE and has NOT yet attempted
     its election/publication.  A two-party barrier makes that simultaneous
     rather than probable;
  2. the DELAYED loader is held there, on a semaphore;
  3. the WINNER completes the entire winning initialization — election, epoch
     gathering, private construction and publication;
  4. only then is the delayed loader resumed, and it proceeds from exactly the
     point at which R3.2's mechanism would have let it overwrite the winner."
  (setf *stale-gate* (make-sa0-gate 2))
  (sa0-install-gate-hook
   (lambda (phase)
     (sa0-log-phase (list (sa0-thread-name) phase (sa0-call 'sa0-identity-ready-p)))
     (when (eq phase :observed-pre-initial)
       (funcall *stale-gate*)
       (when (string= (sa0-thread-name) *stale-delayed-name*)
         (unless (sb-thread:wait-on-semaphore *stale-release*
                                              :timeout *sa0-hard-bound-seconds*)
           (error "SA0 PROBE: the delayed loader was never released"))))))
  (let ((winner
          (sb-thread:make-thread
           (lambda ()
             (load *sa0-identity-path*)
             (setf *stale-winner-cell*  (sa0-call 'sa0-carrier-cell)
                   *stale-winner-state* (sa0-call 'sa0-published-state)
                   *stale-ready-at-release* (sa0-call 'sa0-identity-ready-p))
             (sb-thread:signal-semaphore *stale-release* 1)
             :ok)
           :name *stale-winner-name*))
        (delayed
          (sb-thread:make-thread
           (lambda ()
             (load *sa0-identity-path*)
             (setf *stale-delayed-observation*
                   (list :cell        (sa0-call 'sa0-carrier-cell)
                         :state       (sa0-call 'sa0-published-state)
                         :epoch       (sa0-call 'sa0-epoch-hex)
                         :alloc-mutex (sa0-call 'sa0-performance-mutex)
                         :gatherings  (sa0-call 'sa0-epoch-gatherings)
                         :ready       (sa0-call 'sa0-identity-ready-p)))
             :ok)
           :name *stale-delayed-name*)))
    (setf *stale-winner-join*  (sa0-join winner)
          *stale-delayed-join* (sa0-join delayed)))
  (sa0-remove-gate-hook)
  ;; The image's allocations, taken AFTER the pinned race, by four threads.
  (let ((threads (loop for i from 0 below 4
                       collect (sb-thread:make-thread
                                (lambda ()
                                  (let ((mine (loop repeat 5
                                                    collect (sa0-call 'allocate-performance-counter))))
                                    (sb-thread:with-mutex (*stale-alloc-mutex*)
                                      (setf *stale-allocations*
                                            (append mine *stale-allocations*)))))
                                :name (format nil "sa0-r33-alloc-~D" i)))))
    (mapc #'sa0-join threads)))

;;; --------------------------------------------------------------------------
;;; THE PLANTED ARM — THE R3.2 LAW ITSELF, ON CAPTIVE STATE, UNDER THE SAME PIN.
;;;
;;; This is not a description of the R3.2 pattern and not a re-implementation of
;;; its semantics: it is SB-EXT:DEFGLOBAL followed by SB-EXT:CAS, the real
;;; macro and the real primitive, loaded through the real LOAD, on a captive
;;; symbol of its own so that the ruled state is untouched.
;;;
;;; WHERE THE PIN GOES, AND WHY IT IS EXACTLY THERE.  The expansion of
;;;
;;;     (sb-ext:defglobal *v* <value-form> "doc")
;;;
;;; on SBCL 2.4.6 is
;;;
;;;     (sb-impl::%defglobal '*v*
;;;                          (if (sb-int:%boundp '*v*)
;;;                              (sb-kernel:make-unbound-marker)
;;;                              <value-form>)
;;;                          (sb-c:source-location) '"doc")
;;;
;;; — the unbound TEST is evaluated while computing %DEFGLOBAL's argument, and
;;; the WRITE happens later, inside %DEFGLOBAL.  So the value form is evaluated
;;; STRICTLY BETWEEN the test and the write, and a gate placed inside the value
;;; form holds a loader at precisely the point FINDING 1 names.  The
;;; macroexpansion is PRINTED into the transcript so that a reader can check
;;; that claim against this runtime instead of taking it from this comment.
;;; --------------------------------------------------------------------------

(defparameter *captive-r32-source*
  "(sb-ext:defglobal *sa0-r33-captive-guard*
   (progn (funcall (symbol-function 'sa0-captive-gate)) nil)
 \"CAPTIVE COPY OF THE R3.2 LAW: a DEFGLOBAL whose value form is a constant,
followed by a CAS election on that same value cell.\")
(let ((candidate (sb-thread:make-mutex :name (funcall (symbol-function 'sa0-thread-name)))))
  (funcall (symbol-function 'sa0-captive-note) :candidate candidate)
  (sb-ext:cas (symbol-value '*sa0-r33-captive-guard*) nil candidate)
  (funcall (symbol-function 'sa0-captive-note) :after-cas
           (symbol-value '*sa0-r33-captive-guard*)))
"
  "The captive source, kept as TEXT so the transcript can print exactly what was
loaded.  It is loaded from a string stream — a genuine LOAD, and nothing is
written to any filesystem.")

(defvar *captive-a-name* "SA0-R33-CAPTIVE-A")
(defvar *captive-b-name* "SA0-R33-CAPTIVE-B")
(defvar *captive-gate* nil)
(defvar *captive-release* (sb-thread:make-semaphore :count 0))
(defvar *captive-notes* nil)
(defvar *captive-entered* nil)
(defvar *captive-joins* nil)

(defun sa0-captive-note (kind value)
  (sb-thread:with-mutex (*sa0-log-mutex*)
    (push (list (sa0-thread-name) kind value) *captive-notes*))
  value)

(defun sa0-captive-gate ()
  "Called from INSIDE the captive DEFGLOBAL's value form — that is, after that
form's unbound test and before its write."
  (sb-thread:with-mutex (*sa0-log-mutex*)
    (pushnew (sa0-thread-name) *captive-entered* :test #'string=))
  (funcall *captive-gate*)
  (when (string= (sa0-thread-name) *captive-b-name*)
    (unless (sb-thread:wait-on-semaphore *captive-release*
                                         :timeout *sa0-hard-bound-seconds*)
      (error "SA0 PROBE: captive loader B was never released"))))

(defun sa0-captive-note-for (thread-name kind)
  (third (find-if (lambda (n) (and (string= (first n) thread-name)
                                   (eq (second n) kind)))
                  *captive-notes*)))

(defun sa0-run-stale-planted-arm ()
  "The same pin, applied to the R3.2 law: both loaders past the stale unbound
decision, A released through its CAS, B then released through its DELAYED
initializer write and its own CAS."
  (setf *captive-gate* (make-sa0-gate 2))
  (let ((a (sb-thread:make-thread
            (lambda ()
              (load (make-string-input-stream *captive-r32-source*))
              (sb-thread:signal-semaphore *captive-release* 1)
              :ok)
            :name *captive-a-name*))
        (b (sb-thread:make-thread
            (lambda ()
              (load (make-string-input-stream *captive-r32-source*))
              :ok)
            :name *captive-b-name*)))
    (setf *captive-joins* (list (sa0-join a) (sa0-join b)))))

;;; ==========================================================================
;;; ROLE  recursive  —  THE GENUINE RECURSIVE-LOAD TOOTH
;;; ==========================================================================

(defvar *rec-depth* 0)
(defvar *rec-max-depth* 0)
(defvar *rec-hook-fired* nil)
(defvar *rec-inner-load-completed* nil)
(defvar *rec-ready-at-hook* :not-run)
(defvar *rec-ready-after-inner* :not-run)
(defvar *rec-inner-outcome* :not-run)
(defvar *rec-outer-result* :not-run)
(defvar *rec-outer-join* :not-run)
(defvar *rec-hook-error* nil)
(defvar *rec-first-allocation* nil)
(defvar *rec-reload-epoch-before* nil)
(defvar *rec-reload-epoch-after* nil)
(defvar *rec-reload-gatherings-before* nil)
(defvar *rec-reload-gatherings-after* nil)
(defvar *rec-allocation-after-reload* nil)

(defun sa0-run-recursive-arm ()
  "Fire a SAME-THREAD recursive LOAD of the exact candidate source from a hook
that runs DURING initialization and BEFORE ready publication."
  (sa0-install-gate-hook
   (lambda (phase)
     (sa0-log-phase (list (sa0-thread-name) phase (sa0-call 'sa0-identity-ready-p)))
     (when (and (eq phase :elected-before-publication)
                (not *rec-hook-fired*))
       (setf *rec-hook-fired* t)
       (handler-case
           (progn
             (setf *rec-ready-at-hook* (sa0-call 'sa0-identity-ready-p))
             ;; THE RECURSIVE LOAD — same thread, same file, exactly once.
             (let ((*rec-depth* (1+ *rec-depth*)))
               (setf *rec-max-depth* (max *rec-max-depth* *rec-depth*))
               (load *sa0-identity-path*)
               (setf *rec-inner-load-completed* t))
             ;; The same re-entry taken through the initializer directly, so
             ;; that the OUTCOME SYMBOL of an owner re-entry is exhibited and
             ;; not merely inferred from the absence of a deadlock.
             (setf *rec-inner-outcome* (sa0-call 'sa0-initialize-image-identity))
             (setf *rec-ready-after-inner* (sa0-call 'sa0-identity-ready-p)))
         (error (condition)
           (setf *rec-hook-error* (princ-to-string condition)))))))
  (let ((outer (sb-thread:make-thread
                (lambda ()
                  (handler-case
                      (sb-ext:with-timeout *sa0-hard-bound-seconds*
                        (let ((*rec-depth* 1))
                          (setf *rec-max-depth* (max *rec-max-depth* 1))
                          (load *sa0-identity-path*)
                          (setf *rec-outer-result* :completed)))
                    (sb-ext:timeout ()
                      (setf *rec-outer-result* :timeout))
                    (error (condition)
                      (setf *rec-outer-result* (princ-to-string condition))))
                  :done)
                :name "SA0-R33-OUTER")))
    (setf *rec-outer-join* (sa0-join outer)))
  (sa0-remove-gate-hook)
  (setf *rec-first-allocation* (sa0-call 'allocate-performance-counter))
  ;; A LATER ORDINARY RELOAD: it must preserve the epoch and continue the
  ;; counter rather than resetting it.
  (setf *rec-reload-epoch-before*      (sa0-call 'sa0-epoch-hex)
        *rec-reload-gatherings-before* (sa0-call 'sa0-epoch-gatherings))
  (load *sa0-identity-path*)
  (setf *rec-reload-epoch-after*      (sa0-call 'sa0-epoch-hex)
        *rec-reload-gatherings-after* (sa0-call 'sa0-epoch-gatherings)
        *rec-allocation-after-reload* (sa0-call 'allocate-performance-counter)))

;;; ==========================================================================
;;; ROLE  post-election-failure  —  THE UNPROTECTED POST-ELECTION INTERVAL
;;;                                 (R3.3.1, owner's first returned goblin)
;;; ==========================================================================

(defvar *pe-winner-name* "SA0-R331-PE-WINNER")
(defvar *pe-observer-name* "SA0-R331-PE-OBSERVER")
(defparameter *pe-planted-text*
  "SA0 PROBE TOOTH: planted condition in the post-election interval")

(defvar *pe-enter-gate* nil)
(defvar *pe-observer-release* (sb-thread:make-semaphore :count 0))
(defvar *pe-observer-parked* (sb-thread:make-semaphore :count 0))
(defvar *pe-at-hook* nil)
(defvar *pe-hook-firings* 0)
(defvar *pe-before-wait-firings* 0)
(defvar *pe-before-wait-threads* nil)
(defvar *pe-winner-outcome* :not-run)
(defvar *pe-winner-error* nil)
(defvar *pe-observer-outcome* :not-run)
(defvar *pe-observer-error* nil)
(defvar *pe-observer-seconds* nil)
(defvar *pe-winner-join* :not-run)
(defvar *pe-observer-join* :not-run)
(defvar *pe-cell-after* nil)
(defvar *pe-retry-outcome* :not-run)
(defvar *pe-retry-error* nil)
(defvar *pe-fresh-outcome* :not-run)
(defvar *pe-fresh-error* nil)
(defvar *pe-fresh-join* :not-run)
(defvar *pe-reader-outcome* :not-run)
(defvar *pe-reader-error* nil)
(defvar *pe-winner-noise* nil)
(defvar *pe-observer-noise* nil)

;;; WHY THE TWO FAILING LOADS CAPTURE *ERROR-OUTPUT*, AND WHY THE CAPTURE IS
;;; PRINTED RATHER THAN DROPPED.  SBCL's source LOAD announces the form it was
;;; evaluating when a condition escapes it — "While evaluating the form starting
;;; at line N ... of #P..." — on *ERROR-OUTPUT*, and it does so even when the
;;; caller handles the condition.  The runner merges the child's error stream
;;; into the transcript, so that notice would land in the middle of the section,
;;; ACROSS TWO LINES, and one of those lines would arrive after the block's
;;; footer.  It is a notice about a load, not an observation, and the actual
;;; condition is reported by the arm itself a few lines below.  So the two loads
;;; that are EXPECTED to fail capture it — and then PRINT it, flattened to one
;;; line, so that nothing is suppressed, only relocated.

(defun sa0-pe-hook (phase)
  "THE PIN.  Read it as a schedule and not as a set of callbacks:

  1. both loaders enter the candidate source's initialization and record the
     pre-initial observation; a two-party barrier makes that simultaneous;
  2. the OBSERVER is held there, so the WINNER takes the election unopposed;
  3. at :ELECTED-BEFORE-NOTE — the first instant after the election succeeded,
     with nothing noted, nothing gathered and nothing built — the winner
     releases the observer and then WAITS until the observer is PROVABLY on the
     cell's wait queue;
  4. only then does the winner signal the planted condition.

Step 3 is what makes this a pinned schedule rather than a hopeful one: the
observer signals *PE-OBSERVER-PARKED* from inside the source's own :BEFORE-WAIT
phase, which runs UNDER THE CELL MUTEX with the state and failure marker both
re-checked absent, and its very next act is CONDITION-WAIT.  So when the winner
fails, there is a real sleeper on a real queue — the case that, under the
returned code, waited forever."
  (sa0-log-phase (list (sa0-thread-name) phase (sa0-call 'sa0-identity-ready-p)))
  (case phase
    (:observed-pre-initial
     (funcall *pe-enter-gate*)
     (when (string= (sa0-thread-name) *pe-observer-name*)
       (unless (sb-thread:wait-on-semaphore *pe-observer-release*
                                            :timeout *sa0-hard-bound-seconds*)
         (error "SA0 PROBE: the observer was never released"))))
    (:elected-before-note
     (sb-thread:with-mutex (*sa0-log-mutex*) (incf *pe-hook-firings*))
     (let ((cell (sa0-call 'sa0-carrier-cell)))
       (setf *pe-at-hook*
             (list :thread          (sa0-thread-name)
                   :carrier-present (and cell t)
                   :cell-is-mine    (and cell
                                         (eq (sa0-call 'sa0-cell-owner cell)
                                             sb-thread:*current-thread*))
                   :state           (sa0-call 'sa0-published-state)
                   :ready           (sa0-call 'sa0-identity-ready-p)
                   :failure         (and cell (sa0-call 'sa0-cell-failure cell))
                   :gatherings      (sa0-call 'sa0-epoch-gatherings)
                   :elections       (sa0-call 'sa0-election-count))))
     (sb-thread:signal-semaphore *pe-observer-release* 1)
     (unless (sb-thread:wait-on-semaphore *pe-observer-parked*
                                          :timeout *sa0-hard-bound-seconds*)
       (error "SA0 PROBE: the observer never reached the wait queue"))
     ;; THE PLANTED CONDITION, in exactly the interval the owner's return names.
     (error *pe-planted-text*))
    (:before-wait
     (sb-thread:with-mutex (*sa0-log-mutex*)
       (incf *pe-before-wait-firings*)
       (pushnew (sa0-thread-name) *pe-before-wait-threads* :test #'string=))
     (sb-thread:signal-semaphore *pe-observer-parked* 1))))

(defun sa0-run-post-election-failure-arm ()
  (setf *pe-enter-gate* (make-sa0-gate 2))
  (sa0-install-gate-hook #'sa0-pe-hook)
  (let ((winner
          (sb-thread:make-thread
           (lambda ()
             (let ((*error-output* (make-string-output-stream)))
               (handler-case
                   (progn (load *sa0-identity-path*)
                          (setf *pe-winner-outcome* :completed))
                 (error (c)
                   (setf *pe-winner-error* (sa0-flatten-line c)
                         *pe-winner-outcome* :errored)))
               (setf *pe-winner-noise* (get-output-stream-string *error-output*)))
             :done)
           :name *pe-winner-name*))
        (observer
          (sb-thread:make-thread
           (lambda ()
             (let ((start (get-internal-real-time))
                   (*error-output* (make-string-output-stream)))
               (handler-case
                   (progn (load *sa0-identity-path*)
                          (setf *pe-observer-outcome* :completed))
                 (error (c)
                   (setf *pe-observer-error* (sa0-flatten-line c)
                         *pe-observer-outcome* :errored)))
               (setf *pe-observer-noise* (get-output-stream-string *error-output*)
                     *pe-observer-seconds*
                     (/ (float (- (get-internal-real-time) start))
                        internal-time-units-per-second)))
             :done)
           :name *pe-observer-name*)))
    (setf *pe-winner-join*   (sa0-join winner)
          *pe-observer-join* (sa0-join observer)))
  (sa0-remove-gate-hook)
  (setf *pe-cell-after* (sa0-call 'sa0-carrier-cell))
  ;; THE DOCUMENTED POST-FAILURE LAW, EXERCISED RATHER THAN QUOTED.  The source
  ;; says a failed image is TERMINAL: no retry elects, no reader is served.
  (handler-case (setf *pe-retry-outcome* (sa0-call 'sa0-initialize-image-identity))
    (error (c) (setf *pe-retry-error* (sa0-flatten-line c)
                     *pe-retry-outcome* :errored)))
  (handler-case (setf *pe-reader-outcome* (sa0-call 'sa0-require-state))
    (error (c) (setf *pe-reader-error* (sa0-flatten-line c)
                     *pe-reader-outcome* :errored)))
  (let ((fresh (sb-thread:make-thread
                (lambda ()
                  (handler-case
                      (sb-ext:with-timeout *sa0-hard-bound-seconds*
                        (setf *pe-fresh-outcome*
                              (sa0-call 'sa0-initialize-image-identity)))
                    (sb-ext:timeout () (setf *pe-fresh-outcome* :timeout))
                    (error (c) (setf *pe-fresh-error* (sa0-flatten-line c)
                                     *pe-fresh-outcome* :errored)))
                  :done)
                :name "SA0-R331-PE-FRESH")))
    (setf *pe-fresh-join* (sa0-join fresh))))

;;; --------------------------------------------------------------------------
;;; THE COMPARATOR — A REPLICA OF THE RETURNED SHAPE, LABELLED AS A REPLICA.
;;;
;;; WHAT THIS IS AND WHAT IT IS NOT, said before the numbers.  The R3.3 stale
;;; tooth could plant the REAL macro because its defect was a property of
;;; SB-EXT:DEFGLOBAL's expansion.  This defect is a property of CONTROL FLOW —
;;; one instruction sitting outside a protective span — and the source that had
;;; that flow no longer exists in this tree.  So what follows is a REPLICA of
;;; the returned shape, written here, on captive symbols: election CAS, then an
;;; unprotected step, then the helper that establishes the unwind-protect.
;;;
;;; IT THEREFORE PROVES A CONSEQUENCE OF THE SHAPE, NOT A FACT ABOUT THE
;;; RETURNED FILE.  That the returned file had this shape is checkable in the
;;; parcel's own history and is NOT claimed by this arm.  What the arm shows is
;;; that under the identical planted condition, at the identical point of the
;;; identical schedule, the returned shape leaves a real waiter on a real queue
;;; with NEITHER a state NOR a failure marker — which is the exact half-outcome
;;; R3.3-A clause 6 forbids — while the repaired source wakes it with a
;;; definitive failure inside the bound.
;;; --------------------------------------------------------------------------

(defvar *pe-replica-installed* (sb-thread:make-semaphore :count 0))
(defvar *pe-replica-parked* (sb-thread:make-semaphore :count 0))
(defvar *pe-replica-cell* nil)
(defvar *pe-replica-winner-outcome* :not-run)
(defvar *pe-replica-winner-error* nil)
(defvar *pe-replica-observer-outcome* :not-run)
(defvar *pe-replica-observer-seconds* nil)
(defvar *pe-replica-joins* nil)

(defun sa0-pe-replica-cell (owner)
  (vector 'sa0-r331-replica-cell owner
          (sb-thread:make-mutex :name "sa0-r331-replica")
          (sb-thread:make-waitqueue :name "sa0-r331-replica")
          nil nil nil))

(defun sa0-pe-replica-elect-and-publish (cell)
  "THE RETURNED HELPER'S SHAPE: the unwind-protect begins HERE, inside the
helper, which is one call too late."
  (let ((ok nil))
    (unwind-protect
         (progn (setf (svref cell 4) :replica-state) (setf ok t))
      (progn
        (unless ok (setf (svref cell 5) "replica failure marker"))
        (sb-thread:with-mutex ((svref cell 2))
          (sb-thread:condition-broadcast (svref cell 3)))))))

(defun sa0-pe-replica-note ()
  "THE UNPROTECTED POST-ELECTION STEP.  In the returned source this was
SA0-NOTE-ELECTION; here it is the same position in the same shape, and it is
where the identical planted condition is signalled."
  (sb-thread:signal-semaphore *pe-replica-installed* 1)
  (unless (sb-thread:wait-on-semaphore *pe-replica-parked*
                                       :timeout *sa0-hard-bound-seconds*)
    (error "SA0 PROBE: the replica observer never reached the wait queue"))
  (error *pe-planted-text*))

(defun sa0-pe-replica-initialize ()
  "THE RETURNED CALLER'S SHAPE: CAS, then an UNPROTECTED step, then the helper."
  (let ((cell (sa0-pe-replica-cell sb-thread:*current-thread*)))
    (let ((prior (sb-ext:cas (symbol-plist 'sa0-r331-replica-carrier)
                             nil
                             (list 'cell cell))))
      (when (null prior)
        (setf *pe-replica-cell* cell)
        (sa0-pe-replica-note)
        (sa0-pe-replica-elect-and-publish cell)))))

(defun sa0-pe-replica-observe ()
  (unless (sb-thread:wait-on-semaphore *pe-replica-installed*
                                       :timeout *sa0-hard-bound-seconds*)
    (return-from sa0-pe-replica-observe :never-installed))
  (let ((cell (getf (symbol-plist 'sa0-r331-replica-carrier) 'cell)))
    (sb-thread:with-mutex ((svref cell 2))
      (cond ((svref cell 4) :observed-state)
            ((svref cell 5) :observed-failure)
            (t (sb-thread:signal-semaphore *pe-replica-parked* 1)
               (if (sb-thread:condition-wait (svref cell 3) (svref cell 2)
                                             :timeout *sa0-spin-exhibit-seconds*)
                   :woken
                   :never-woken))))))

(defun sa0-run-pe-replica-arm ()
  (let ((winner (sb-thread:make-thread
                 (lambda ()
                   (handler-case
                       (progn (sa0-pe-replica-initialize)
                              (setf *pe-replica-winner-outcome* :completed))
                     (error (c) (setf *pe-replica-winner-error* (sa0-flatten-line c)
                                      *pe-replica-winner-outcome* :errored)))
                   :done)
                 :name "SA0-R331-REPLICA-WINNER"))
        (observer (sb-thread:make-thread
                   (lambda ()
                     (let ((start (get-internal-real-time)))
                       (setf *pe-replica-observer-outcome* (sa0-pe-replica-observe))
                       (setf *pe-replica-observer-seconds*
                             (/ (float (- (get-internal-real-time) start))
                                internal-time-units-per-second)))
                     :done)
                   :name "SA0-R331-REPLICA-OBSERVER")))
    (setf *pe-replica-joins* (list (sa0-join winner) (sa0-join observer)))))

;;; ==========================================================================
;;; ROLE  plist-foreign  —  A CARRIER THAT ALREADY CARRIES SOMETHING
;;;                         (R3.3.1, owner's second returned goblin)
;;; ==========================================================================

(defvar *foreign-first* (list :unrelated-property-one "installed before the first load"))
(defvar *foreign-second* (list :unrelated-property-two 42))
(defvar *foreign-plist-before* nil)
(defvar *foreign-reserved-before* :unread)
(defvar *foreign-load-outcome* :not-run)
(defvar *foreign-load-error* nil)
(defvar *foreign-load-join* :not-run)
(defvar *foreign-allocations* nil)

(defun sa0-install-foreign-properties ()
  "TWO unrelated properties, installed on the carrier symbol BEFORE the
candidate source has ever been loaded.  Two rather than one, because a
one-property test cannot tell 'preserved' from 'rebuilt with one property'."
  (setf (get 'sa0-identity-carrier 'sa0-unrelated-one) *foreign-first*)
  (setf (get 'sa0-identity-carrier 'sa0-unrelated-two) *foreign-second*)
  (setf *foreign-plist-before* (symbol-plist 'sa0-identity-carrier)
        *foreign-reserved-before* (getf (symbol-plist 'sa0-identity-carrier)
                                        'sa0-identity-cell)))

(defun sa0-run-foreign-clean-arm ()
  "THE FIRST LOAD, ON A CARRIER THAT IS NOT EMPTY, UNDER A HARD BOUND.  The
bound is not decoration: under the returned law this load never returns, so an
unbounded arm would hang the whole probe instead of reporting the defect."
  (let ((loader (sb-thread:make-thread
                 (lambda ()
                   (handler-case
                       (sb-ext:with-timeout *sa0-hard-bound-seconds*
                         (load *sa0-identity-path*)
                         (setf *foreign-load-outcome* :completed))
                     (sb-ext:timeout () (setf *foreign-load-outcome* :timeout))
                     (error (c) (setf *foreign-load-error* (sa0-flatten-line c)
                                      *foreign-load-outcome* :errored)))
                   :done)
                 :name "SA0-R331-FOREIGN-LOADER")))
    (setf *foreign-load-join* (sa0-join loader)))
  (when (eq :completed *foreign-load-outcome*)
    (setf *foreign-allocations* (sa0-take-allocations 4 5))))

(defvar *foreign-captive-value* (list :captive-unrelated-property))
(defvar *foreign-captive-plist-before* nil)
(defvar *foreign-captive-attempts* 0)
(defvar *foreign-captive-successes* 0)
(defvar *foreign-spin-outcome* :not-run)
(defvar *foreign-spin-iterations* 0)
(defvar *foreign-spin-join* :not-run)

(defun sa0-run-foreign-planted-arm ()
  "THE RETURNED LAW — a compare of the WHOLE PLIST against NIL — under the same
precondition, on a CAPTIVE symbol so that the ruled carrier is untouched.  Two
exhibitions, because they answer two different questions:

  1. CAN it succeed?  One thousand attempts, counted.  This is an algebraic
     fact about the compare and it needs no clock.
  2. What does the LOOP do?  The returned loop shape, run for a small bounded
     interval, with its own iteration counter.  This is the hang, executed."
  (setf (get 'sa0-r331-captive-carrier 'sa0-captive-unrelated) *foreign-captive-value*)
  (setf *foreign-captive-plist-before* (symbol-plist 'sa0-r331-captive-carrier))
  (loop repeat 1000
        do (incf *foreign-captive-attempts*)
           (let ((prior (sb-ext:cas (symbol-plist 'sa0-r331-captive-carrier)
                                    nil
                                    (list 'sa0-identity-cell :captive-cell))))
             (when (null prior) (incf *foreign-captive-successes*))))
  (let ((spinner
          (sb-thread:make-thread
           (lambda ()
             (handler-case
                 (sb-ext:with-timeout *sa0-spin-exhibit-seconds*
                   (loop
                     (let ((cell (getf (symbol-plist 'sa0-r331-captive-carrier)
                                       'sa0-identity-cell)))
                       (when cell
                         (setf *foreign-spin-outcome* :observed)
                         (return))
                       (incf *foreign-spin-iterations*)
                       (let ((prior (sb-ext:cas (symbol-plist 'sa0-r331-captive-carrier)
                                                nil
                                                (list 'sa0-identity-cell :captive-cell))))
                         (when (null prior)
                           (setf *foreign-spin-outcome* :elected)
                           (return))))))
               (sb-ext:timeout () (setf *foreign-spin-outcome* :never-terminated))
               (error (c) (setf *foreign-spin-outcome* (sa0-flatten-line c))))
             :done)
           :name "SA0-R331-FOREIGN-SPIN")))
    (setf *foreign-spin-join* (sa0-join spinner))))

;;; ==========================================================================
;;; ROLE  plist-contention  —  THE PLIST CHANGES BETWEEN THE READ AND THE CAS
;;;                            (R3.3.1, the retry loop's own tooth)
;;; ==========================================================================

(defvar *contention-injected* (list :injected-between-read-and-cas))
(defvar *contention-gate-firings* 0)
(defvar *contention-injected-at-firing* nil)
(defvar *contention-plist-after-injection* nil)
(defvar *contention-plist-before* :unread)
(defvar *contention-load-outcome* :not-run)
(defvar *contention-load-error* nil)
(defvar *contention-load-join* :not-run)
(defvar *contention-allocations* nil)

(defun sa0-contention-hook (phase)
  "ON THE FIRST FIRING ONLY, change the plist.  The phase is called AFTER the
election has read one exact plist object and found no reserved indicator on it,
and BEFORE it attempts its compare against that exact object — so a change made
here MUST make that compare fail.  On the second firing this does nothing, so
the retry has an unobstructed plist to win against and the arm terminates."
  (sa0-log-phase (list (sa0-thread-name) phase (sa0-call 'sa0-identity-ready-p)))
  (when (eq phase :observed-carrier-plist)
    (incf *contention-gate-firings*)
    (when (= 1 *contention-gate-firings*)
      (setf (get 'sa0-identity-carrier 'sa0-injected-mid-election) *contention-injected*)
      (setf *contention-injected-at-firing* *contention-gate-firings*
            *contention-plist-after-injection* (symbol-plist 'sa0-identity-carrier)))))

(defun sa0-run-contention-clean-arm ()
  (setf *contention-plist-before* (symbol-plist 'sa0-identity-carrier))
  (sa0-install-gate-hook #'sa0-contention-hook)
  (let ((loader (sb-thread:make-thread
                 (lambda ()
                   (handler-case
                       (sb-ext:with-timeout *sa0-hard-bound-seconds*
                         (load *sa0-identity-path*)
                         (setf *contention-load-outcome* :completed))
                     (sb-ext:timeout () (setf *contention-load-outcome* :timeout))
                     (error (c) (setf *contention-load-error* (sa0-flatten-line c)
                                      *contention-load-outcome* :errored)))
                   :done)
                 :name "SA0-R331-CONTENTION-LOADER")))
    (setf *contention-load-join* (sa0-join loader)))
  (sa0-remove-gate-hook)
  (when (eq :completed *contention-load-outcome*)
    (setf *contention-allocations* (sa0-take-allocations 4 5))))

(defvar *contention-captive-value* (list :captive-injected))
(defvar *contention-captive-prior* :unread)
(defvar *contention-captive-installed* :unread)
(defvar *contention-captive-survivor* :unread)

(defun sa0-run-contention-planted-arm ()
  "A SINGLE-SHOT ELECTION — one snapshot, one compare, NO RETRY — meeting the
same mid-election change on a captive symbol.  It is the arm that says what the
loop is FOR: without the re-read, a lost compare is a lost election, and the
caller installs nothing at all."
  (let ((observed (symbol-plist 'sa0-r331-captive-carrier)))
    (setf (get 'sa0-r331-captive-carrier 'sa0-captive-injected) *contention-captive-value*)
    (setf *contention-captive-prior*
          (sb-ext:cas (symbol-plist 'sa0-r331-captive-carrier)
                      observed
                      (list* 'sa0-identity-cell :captive-cell observed))))
  (setf *contention-captive-installed*
        (getf (symbol-plist 'sa0-r331-captive-carrier) 'sa0-identity-cell)
        *contention-captive-survivor*
        (getf (symbol-plist 'sa0-r331-captive-carrier) 'sa0-captive-injected)))

;;; ==========================================================================
;;; ROLE  publication-finality  —  THE INSTANT AFTER THE STATE IS PUBLISHED
;;;                                (R3.3.2, the owner's FINDING 1)
;;; ==========================================================================
;;;
;;; THE RETURNED DEFECT, stated as the schedule that produces it.  R3.3.1
;;; published the state by CAS and then set a SEPARATE LOCAL FLAG; the cleanup
;;; of the protective UNWIND-PROTECT decided whether initialization had failed by
;;; reading THAT FLAG.  A condition raised between the two therefore ran a
;;; cleanup that believed nothing had been published, and wrote a failure marker
;;; onto a cell that already carried a complete state.  The image then said both
;;; things at once, and every reader that returned the state did so only because
;;; the state branch was written above the failure branch.
;;;
;;; SO THE PIN GOES EXACTLY THERE, in the source's own :PUBLISHED-BEFORE-RETURN
;;; phase, with a second loader PROVABLY asleep on the cell's wait queue — the
;;; observer is released at :ELECTED-BEFORE-NOTE and the winner does not proceed
;;; to gather until the observer has signalled from inside :BEFORE-WAIT, under
;;; the cell mutex, with state and failure re-checked absent.  What must follow
;;; is the ruling's list: state present, failure ABSENT, the parked observer
;;; awakened WITH THE STATE, a retry that OBSERVES, one election, one gathering.

(defvar *pf-winner-name* "SA0-R332-PF-WINNER")
(defvar *pf-observer-name* "SA0-R332-PF-OBSERVER")
(defvar *pf-planted-text*
  "SA0 PROBE PLANTED CONDITION (R3.3.2): raised at the first instant after the state was published")

(defvar *pf-enter-gate* nil)
(defvar *pf-observer-release* (sb-thread:make-semaphore :count 0))
(defvar *pf-observer-parked* (sb-thread:make-semaphore :count 0))
(defvar *pf-hook-firings* 0)
(defvar *pf-at-hook* nil)
(defvar *pf-before-wait-firings* 0)
(defvar *pf-before-wait-threads* nil)
(defvar *pf-winner-outcome* :not-run)
(defvar *pf-winner-error* nil)
(defvar *pf-winner-noise* nil)
(defvar *pf-winner-join* :not-run)
(defvar *pf-observer-outcome* :not-run)
(defvar *pf-observer-error* nil)
(defvar *pf-observer-state* nil)
(defvar *pf-observer-seconds* nil)
(defvar *pf-observer-join* :not-run)
(defvar *pf-cell-after* nil)
(defvar *pf-state-after* nil)
(defvar *pf-retry-outcome* :not-run)
(defvar *pf-retry-error* nil)
(defvar *pf-fresh-outcome* :not-run)
(defvar *pf-fresh-error* nil)
(defvar *pf-fresh-join* :not-run)
(defvar *pf-reader-state* nil)
(defvar *pf-reader-error* nil)
(defvar *pf-allocations* nil)

(defun sa0-pf-hook (phase)
  "THE PIN.  Read it as a schedule:

  1. both loaders enter the candidate source's initialization and record the
     pre-initial observation; a two-party barrier makes that simultaneous;
  2. the OBSERVER is held there, so the WINNER takes the election unopposed;
  3. at :ELECTED-BEFORE-NOTE the winner releases the observer and then WAITS
     until the observer is PROVABLY on the cell's wait queue — so the
     publication below happens with a real sleeper on a real queue;
  4. the winner gathers, builds and publishes;
  5. at :PUBLISHED-BEFORE-RETURN — the state installed, the protected form not
     yet returned, the cleanup not yet run — the planted condition is signalled."
  (sa0-log-phase (list (sa0-thread-name) phase (sa0-call 'sa0-identity-ready-p)))
  (case phase
    (:observed-pre-initial
     (funcall *pf-enter-gate*)
     (when (string= (sa0-thread-name) *pf-observer-name*)
       (unless (sb-thread:wait-on-semaphore *pf-observer-release*
                                            :timeout *sa0-hard-bound-seconds*)
         (error "SA0 PROBE: the observer was never released"))))
    (:elected-before-note
     (sb-thread:signal-semaphore *pf-observer-release* 1)
     (unless (sb-thread:wait-on-semaphore *pf-observer-parked*
                                          :timeout *sa0-hard-bound-seconds*)
       (error "SA0 PROBE: the observer never reached the wait queue")))
    (:before-wait
     (sb-thread:with-mutex (*sa0-log-mutex*)
       (incf *pf-before-wait-firings*)
       (pushnew (sa0-thread-name) *pf-before-wait-threads* :test #'string=))
     (sb-thread:signal-semaphore *pf-observer-parked* 1))
    (:published-before-return
     (sb-thread:with-mutex (*sa0-log-mutex*) (incf *pf-hook-firings*))
     (let ((cell (sa0-call 'sa0-carrier-cell)))
       (setf *pf-at-hook*
             (list :thread          (sa0-thread-name)
                   :carrier-present (and cell t)
                   :cell-is-mine    (and cell
                                         (eq (sa0-call 'sa0-cell-owner cell)
                                             sb-thread:*current-thread*))
                   :state           (sa0-call 'sa0-published-state)
                   :ready           (sa0-call 'sa0-identity-ready-p)
                   :failure         (and cell (sa0-call 'sa0-cell-failure cell))
                   :gatherings      (sa0-call 'sa0-epoch-gatherings)
                   :elections       (sa0-call 'sa0-election-count))))
     ;; THE PLANTED CONDITION, in exactly the interval the owner's return names.
     (error *pf-planted-text*))))

(defun sa0-run-publication-finality-arm ()
  (setf *pf-enter-gate* (make-sa0-gate 2))
  (sa0-install-gate-hook #'sa0-pf-hook)
  (let ((winner
          (sb-thread:make-thread
           (lambda ()
             (let ((*error-output* (make-string-output-stream)))
               (handler-case
                   (progn (load *sa0-identity-path*)
                          (setf *pf-winner-outcome* :completed))
                 (error (c)
                   (setf *pf-winner-error* (sa0-flatten-line c)
                         *pf-winner-outcome* :errored)))
               (setf *pf-winner-noise* (get-output-stream-string *error-output*)))
             :done)
           :name *pf-winner-name*))
        (observer
          (sb-thread:make-thread
           (lambda ()
             (let ((start (get-internal-real-time)))
               (handler-case
                   (progn (load *sa0-identity-path*)
                          (setf *pf-observer-outcome* :completed
                                *pf-observer-state* (sa0-call 'sa0-published-state)))
                 (error (c)
                   (setf *pf-observer-error* (sa0-flatten-line c)
                         *pf-observer-outcome* :errored)))
               (setf *pf-observer-seconds*
                     (/ (float (- (get-internal-real-time) start))
                        internal-time-units-per-second)))
             :done)
           :name *pf-observer-name*)))
    (setf *pf-winner-join*   (sa0-join winner)
          *pf-observer-join* (sa0-join observer)))
  (sa0-remove-gate-hook)
  (setf *pf-cell-after*  (sa0-call 'sa0-carrier-cell)
        *pf-state-after* (sa0-call 'sa0-published-state))
  ;; A RETRY AND A READER, exercised rather than quoted.  Under the returned
  ;; shape both of these succeeded too — but only by branch order, over a cell
  ;; that also carried a failure marker.
  (handler-case (setf *pf-retry-outcome* (sa0-call 'sa0-initialize-image-identity))
    (error (c) (setf *pf-retry-error* (sa0-flatten-line c)
                     *pf-retry-outcome* :errored)))
  (handler-case (setf *pf-reader-state* (sa0-call 'sa0-require-state))
    (error (c) (setf *pf-reader-error* (sa0-flatten-line c))))
  (let ((fresh (sb-thread:make-thread
                (lambda ()
                  (handler-case
                      (sb-ext:with-timeout *sa0-hard-bound-seconds*
                        (setf *pf-fresh-outcome*
                              (sa0-call 'sa0-initialize-image-identity)))
                    (sb-ext:timeout () (setf *pf-fresh-outcome* :timeout))
                    (error (c) (setf *pf-fresh-error* (sa0-flatten-line c)
                                     *pf-fresh-outcome* :errored)))
                  :done)
                :name "SA0-R332-PF-FRESH")))
    (setf *pf-fresh-join* (sa0-join fresh)))
  (when (eq :completed *pf-observer-outcome*)
    (setf *pf-allocations* (sa0-take-allocations 4 5))))

;;; --------------------------------------------------------------------------
;;; THE COMPARATOR — A REPLICA OF THE RETURNED SHAPE, LABELLED AS A REPLICA.
;;;
;;; WHAT IT IS AND WHAT IT IS NOT.  The returned source is not in this tree, so
;;; this is a REPLICA OF ITS SHAPE, written here, on a captive cell: publish by
;;; CAS, then a SEPARATE LOCAL FLAG, and a cleanup that decides from the flag.
;;; It does NOT prove what the returned file contained — that is checkable in
;;; the parcel's own history.  It proves the CONSEQUENCE of the shape.
;;;
;;; IT NEEDS NO THREADS, AND THAT IS THE POINT.  The forked tongue is not a
;;; race: one thread, one condition, in the one interval, is enough to produce a
;;; cell that carries a state AND a failure at once.  Two HONEST readers — the
;;; ruled branch order, and the same two tests in the opposite order — are then
;;; run against that one cell, and they return OPPOSITE answers.  That is the
;;; owner's sentence ("the later readers choose success only because the state
;;; branch precedes the failure branch") executed rather than quoted.
;;; --------------------------------------------------------------------------

(defvar *pf-replica-cell* nil)
(defvar *pf-replica-outcome* :not-run)
(defvar *pf-replica-error* nil)
(defvar *pf-replica-state-first* :not-run)
(defvar *pf-replica-failure-first* :not-run)
(defvar *pf-ruled-state-first* :not-run)
(defvar *pf-ruled-failure-first* :not-run)

(defun sa0-pf-replica-initialize ()
  "THE RETURNED SHAPE: CAS the state in, then set a SEPARATE flag, and let the
cleanup decide from that flag.  The planted condition lands between the two."
  (let ((cell (vector 'sa0-r332-replica-cell sb-thread:*current-thread*
                      (sb-thread:make-mutex :name "sa0-r332-replica")
                      (sb-thread:make-waitqueue :name "sa0-r332-replica")
                      nil nil nil))
        (published nil))
    (setf *pf-replica-cell* cell)
    (unwind-protect
         (progn
           (sb-ext:cas (svref cell 4) nil :replica-state)
           ;; the interval: published, and the flag does not know it yet
           (error *pf-planted-text*)
           (setf published t))
      (progn
        (unless published (setf (svref cell 5) "replica failure marker"))
        (sb-thread:with-mutex ((svref cell 2))
          (sb-thread:condition-broadcast (svref cell 3)))))))

(defun sa0-pf-replica-read (cell state-first)
  "The two branch orders, spelled out.  Both are honest readers of the same cell."
  (if state-first
      (cond ((svref cell 4) :state-returned)
            ((svref cell 5) :failure-signalled)
            (t :nothing-published))
      (cond ((svref cell 5) :failure-signalled)
            ((svref cell 4) :state-returned)
            (t :nothing-published))))

(defun sa0-pf-ruled-read (cell state-first)
  "The same two branch orders over the RULED cell, through the source's own two
disposition readers."
  (if state-first
      (cond ((sa0-call 'sa0-cell-state cell) :state-returned)
            ((sa0-call 'sa0-cell-failure cell) :failure-signalled)
            (t :nothing-published))
      (cond ((sa0-call 'sa0-cell-failure cell) :failure-signalled)
            ((sa0-call 'sa0-cell-state cell) :state-returned)
            (t :nothing-published))))

(defun sa0-run-pf-replica-arm ()
  (handler-case (progn (sa0-pf-replica-initialize)
                       (setf *pf-replica-outcome* :completed))
    (error (c) (setf *pf-replica-error* (sa0-flatten-line c)
                     *pf-replica-outcome* :errored)))
  (let ((rcell *pf-replica-cell*)
        (ruled *pf-cell-after*))
    (when rcell
      (setf *pf-replica-state-first*   (sa0-pf-replica-read rcell t)
            *pf-replica-failure-first* (sa0-pf-replica-read rcell nil)))
    (when ruled
      (setf *pf-ruled-state-first*   (sa0-pf-ruled-read ruled t)
            *pf-ruled-failure-first* (sa0-pf-ruled-read ruled nil)))))

;;; ==========================================================================
;;; ROLE  carrier-slot  —  PRESENCE VERSUS VALUE IN THE RESERVED SLOT
;;;                        (R3.3.2, the owner's FINDING 2)
;;; ==========================================================================
;;;
;;; THE RETURNED DEFECT.  R3.3.1 tested the reserved indicator's presence with
;;; (GETF observed 'SA0-IDENTITY-CELL), whose NIL default cannot tell an ABSENT
;;; indicator from one PRESENT with an invalid NIL value.  A pre-existing
;;; (SA0-IDENTITY-CELL NIL) entry was therefore read as an empty slot and a
;;; SECOND reserved indicator was silently prepended in front of the first.
;;;
;;; FOUR PRECONDITIONS, ONE LAW.  A NIL value, duplicate reserved entries, a
;;; value that is not a cell, and a malformed property list must all be REJECTED
;;; IMMEDIATELY and DEFINITIVELY; a single lawful installed cell must still be
;;; observed.  A labelled REPLICA runs the returned GETF-then-CAS law against
;;; the ruling's own precondition and exhibits the silent duplicate.
;;;
;;; WHY FOUR ARMS SHARE ONE IMAGE, disclosed rather than assumed away.  Of
;;; the other seven roles, six need an image in which a FIRST INITIALIZATION
;;; can still be scheduled, and each spends that moment; carrier-total, like
;;; this role, spends nothing (its arms are all rejections — see the header's
;;; exception list).  A REJECTED load spends nothing: it
;;; refuses before any election is attempted, so it installs no cell, notes no
;;; election and gathers no epoch.  The four arms below therefore run in one
;;; image, each after the carrier symbol has been restored to an EXACT stated
;;; state, and each prints its precondition — including the image-wide election
;;; count, which is zero until the lawful arm — rather than asserting it.  The
;;; lawful arm runs LAST, and it is the only one that spends the moment.

(defvar *cs-arm-nil* nil)
(defvar *cs-arm-duplicate* nil)
(defvar *cs-arm-malformed-value* nil)
(defvar *cs-arm-malformed-plist* nil)
(defvar *cs-arm-lawful* nil)
(defvar *cs-nil-getf-said* :unread)
(defvar *cs-nil-count-before* 0)
(defvar *cs-nil-count-after* 0)
(defvar *cs-nil-plist-after* nil)
(defvar *cs-duplicate-count-after* 0)
(defvar *cs-malformed-count-after* 0)
(defvar *cs-elections-before-lawful* :unread)
(defvar *cs-lawful-count-after* 0)
(defvar *cs-lawful-install-cell* nil)
(defvar *cs-lawful-install-won* :unread)
(defvar *cs-lawful-allocations* nil)
(defvar *cs-rejection-mark*
  "the reserved carrier indicator SA0-IDENTITY-CELL is not lawful"
  "THE SOURCE'S OWN REFUSAL TEXT, quoted here so the arms assert on the refusal
they claim to have provoked and not merely on the fact that something failed.")

(defun sa0-cs-reserved-count (plist)
  "How many times the reserved indicator occurs — counted HERE, by the harness,
so the evidence for the repair does not come from the mechanism under test.
Stops at a malformed tail rather than signalling: this is a measure, not a law."
  (let ((n 0))
    (loop for tail = plist then (cddr tail)
          while (consp tail)
          do (when (eq 'sa0-identity-cell (car tail)) (incf n))
             (unless (consp (cdr tail)) (return)))
    n))

(defun sa0-cs-set-carrier (plist)
  (setf (symbol-plist 'sa0-identity-carrier) plist))

(defun sa0-cs-run-load (name)
  "One load of THE EXACT CANDIDATE SOURCE, in its own thread, under the hard
bound, with the outcome, the condition text, SBCL's load notice and the elapsed
seconds all captured.  The bound is not decoration: an arm whose claim is
'refused IMMEDIATELY' has to be able to observe a hang instead."
  (let ((outcome :not-run) (err nil) (noise nil) (seconds nil))
    (let ((thread (sb-thread:make-thread
                   (lambda ()
                     (let ((start (get-internal-real-time))
                           (*error-output* (make-string-output-stream)))
                       (handler-case
                           (sb-ext:with-timeout *sa0-hard-bound-seconds*
                             (load *sa0-identity-path*)
                             (setf outcome :completed))
                         (sb-ext:timeout () (setf outcome :timeout))
                         (error (c) (setf err (sa0-flatten-line c)
                                          outcome :errored)))
                       (setf noise (get-output-stream-string *error-output*)
                             seconds (/ (float (- (get-internal-real-time) start))
                                        internal-time-units-per-second)))
                     :done)
                   :name name)))
      (let ((join (sa0-join thread)))
        (list :join join :outcome outcome :error err :seconds seconds
              :notice (sa0-first-line (or noise "NONE")))))))

(defun sa0-cs-rejected-p (arm)
  "An arm counts as REJECTED only if it errored, inside the bound, with THE
SOURCE'S OWN refusal text — not merely if something went wrong."
  (and arm
       (eq :errored (getf arm :outcome))
       (eq :done (getf arm :join))
       (stringp (getf arm :error))
       (search *cs-rejection-mark* (getf arm :error))
       (numberp (getf arm :seconds))
       (< (getf arm :seconds) *sa0-hard-bound-seconds*)))

(defun sa0-run-carrier-slot-arms ()
  ;; ---- ARM 1: the ruling's own precondition — a reserved NIL entry ---------
  (sa0-cs-set-carrier (list 'sa0-identity-cell nil))
  (setf *cs-nil-count-before* (sa0-cs-reserved-count (symbol-plist 'sa0-identity-carrier))
        ;; THE CONFUSION, DEMONSTRATED HERE RATHER THAN DESCRIBED: the returned
        ;; predicate, run by the harness against the very plist the arm plants.
        *cs-nil-getf-said* (if (getf (symbol-plist 'sa0-identity-carrier)
                                     'sa0-identity-cell)
                               :present
                               :absent))
  (setf *cs-arm-nil* (sa0-cs-run-load "SA0-R332-CS-NIL"))
  (setf *cs-nil-plist-after* (symbol-plist 'sa0-identity-carrier)
        *cs-nil-count-after* (sa0-cs-reserved-count *cs-nil-plist-after*))

  ;; ---- ARM 2: two reserved entries ----------------------------------------
  (sa0-cs-set-carrier (list 'sa0-identity-cell :first-claim
                            'sa0-identity-cell :second-claim))
  (setf *cs-arm-duplicate* (sa0-cs-run-load "SA0-R332-CS-DUP")
        *cs-duplicate-count-after* (sa0-cs-reserved-count (symbol-plist 'sa0-identity-carrier)))

  ;; ---- ARM 3: a value that is not a cell -----------------------------------
  (sa0-cs-set-carrier (list 'sa0-unrelated-property "kept"
                            'sa0-identity-cell :not-a-cell))
  (setf *cs-arm-malformed-value* (sa0-cs-run-load "SA0-R332-CS-MALFORMED")
        *cs-malformed-count-after* (sa0-cs-reserved-count (symbol-plist 'sa0-identity-carrier)))

  ;; ---- ARM 4: a property list that is not one ------------------------------
  (sa0-cs-set-carrier (list 'sa0-unrelated-property "kept" 'sa0-identity-cell))
  (setf *cs-arm-malformed-plist* (sa0-cs-run-load "SA0-R332-CS-ODD"))

  ;; ---- ARM 5: exactly one lawful cell — the ordinary path, re-asserted -----
  (sa0-cs-set-carrier nil)
  (setf *cs-elections-before-lawful* (sa0-call 'sa0-election-count))
  (setf *cs-arm-lawful* (sa0-cs-run-load "SA0-R332-CS-LAWFUL"))
  (when (eq :completed (getf *cs-arm-lawful* :outcome))
    (setf *cs-lawful-count-after* (sa0-cs-reserved-count (symbol-plist 'sa0-identity-carrier)))
    ;; THE NON-WINNER BRANCH, EXERCISED DIRECTLY.  A second LOAD would observe
    ;; the published state and never reach the election at all, so the branch
    ;; that adjudicates a lawful installed cell is called here by name.
    (multiple-value-bind (cell won)
        (sa0-call 'sa0-install-carrier
                  (sa0-call 'make-sa0-identity-cell sb-thread:*current-thread*))
      (setf *cs-lawful-install-cell* cell
            *cs-lawful-install-won* won))
    (setf *cs-lawful-allocations* (sa0-take-allocations 4 5))))

;;; --------------------------------------------------------------------------
;;; THE COMPARATOR — THE RETURNED LAW, ON A CAPTIVE SYMBOL, UNDER THE RULING'S
;;; OWN PRECONDITION.
;;;
;;; This is the returned predicate and the returned CAS, in their returned
;;; shape — GETF against a NIL default, then a compare against the exact plist
;;; object just read — meeting a carrier that already carries
;;; (SA0-IDENTITY-CELL NIL).  It runs on a captive symbol so the ruled carrier
;;; is never touched by it, and it reproduces the ruling's evidence block:
;;; reserved-count 2, the first reserved value is the new cell, and the old
;;; plist is the tail.
;;; --------------------------------------------------------------------------

(defvar *cs-replica-before* nil)
(defvar *cs-replica-count-before* 0)
(defvar *cs-replica-count-after* 0)
(defvar *cs-replica-getf-said* :unread)
(defvar *cs-replica-first-is-new-cell* nil)
(defvar *cs-replica-tail-is-old-plist* nil)

(defun sa0-run-cs-replica-arm ()
  (setf (symbol-plist 'sa0-r332-captive-carrier) (list 'sa0-identity-cell nil))
  (setf *cs-replica-before* (symbol-plist 'sa0-r332-captive-carrier)
        *cs-replica-count-before* (sa0-cs-reserved-count *cs-replica-before*)
        *cs-replica-getf-said* (if (getf *cs-replica-before* 'sa0-identity-cell)
                                   :present
                                   :absent))
  (let ((observed (symbol-plist 'sa0-r332-captive-carrier))
        (candidate (vector 'sa0-identity-cell :captive-owner :captive-mutex
                           :captive-waitq nil nil)))
    ;; THE RETURNED PREDICATE, in its returned shape.
    (let ((existing (getf observed 'sa0-identity-cell)))
      (unless existing
        (sb-ext:cas (symbol-plist 'sa0-r332-captive-carrier)
                    observed
                    (list* 'sa0-identity-cell candidate observed))))
    (let ((after (symbol-plist 'sa0-r332-captive-carrier)))
      (setf *cs-replica-count-after* (sa0-cs-reserved-count after)
            *cs-replica-first-is-new-cell* (eq candidate (second after))
            *cs-replica-tail-is-old-plist* (eq (cddr after) *cs-replica-before*)))))

;;; ==========================================================================
;;; ROLE  carrier-total  —  THE MALFORMED-CARRIER TOTALITY CLOSURE
;;;                         (R3.3.3, the owner's R3.3.2 return)
;;; ==========================================================================
;;;
;;; THE RETURNED DEFECT.  R3.3.2's counting walk ran `while (consp tail)`, so a
;;; non-NIL ATOMIC tail ended the scan as though the property list had ended
;;; lawfully, and a CIRCULAR plist ended it never.  The section below plants the
;;; two shapes the ruling names — plus the one it did not, an improper carrier
;;; that CONTAINS an otherwise-lawful reserved cell — and requires the same
;;; bounded definitive refusal from each.
;;;
;;; THREE ARMS SHARE THIS IMAGE, for the reason the carrier-slot section already
;;; prints and this one inherits: a REJECTED load spends nothing.  It refuses
;;; inside the scan, before any election is attempted, so it installs no cell,
;;; notes no election and gathers no epoch.  Unlike carrier-slot this role has
;;; NO lawful arm at all — nothing here ever completes a load — so the one
;;; moment a first initialization needs is not merely shared here, it is never
;;; spent.  The section proves that rather than asserting it: after all three
;;; arms the carrier is restored to empty and the image-wide election count and
;;; gathering count are read back through the source's own readers.
;;;
;;; WHAT THE HARNESS MEASURES WITH, disclosed.  SA0-CT-CLASSIFY below is the
;;; harness's OWN total walk, written here, so the evidence that a plant really
;;; is dotted or really is circular does not come from the mechanism under test.
;;; It is a SECOND IMPLEMENTATION, not an independent ALGORITHM: it is the same
;;; idea (step, enumerate the failure faces, keep an EQ visited set) written by
;;; the same hand.  What it buys is that a scan that silently stopped early
;;; could not also move this measure; what it does not buy is independence of
;;; conception, and that is stated rather than left to be assumed.

(defparameter *ct-dotted-tail-atom* 'sa0-r333-dotted-tail
  "THE TERMINAL ATOM OF THE IMPROPER PLANTS.  A symbol, so the transcript can
print it without printing an address.")

(defun sa0-ct-classify (plist)
  "THE HARNESS'S OWN TOTAL WALK.  Returns (VALUES SHAPE RESERVED-COUNT PAIRS),
where SHAPE is one of :PROPER, :DOTTED-TAIL, :ODD, :DOTTED-VALUE or :CIRCULAR.
Bounded on every input by its own EQ visited set, so it is safe to run on a
circular plant — a measure that hung would be no measure."
  (let ((count 0) (pairs 0) (visited (make-hash-table :test 'eq)))
    (loop for tail = plist then (cddr tail)
          do (cond
               ((null tail) (return (values :proper count pairs)))
               ((not (consp tail)) (return (values :dotted-tail count pairs)))
               ((gethash tail visited) (return (values :circular count pairs)))
               (t (setf (gethash tail visited) t)
                  (let ((rest (cdr tail)))
                    (cond
                      ((null rest) (return (values :odd count pairs)))
                      ((not (consp rest)) (return (values :dotted-value count pairs)))
                      (t (when (eq 'sa0-identity-cell (car tail)) (incf count))
                         (incf pairs)))))))))

(defun sa0-ct-spine (x)
  "The cons cells of X's CDR chain, in order, each ONCE.  Bounded by an EQ
visited set, so a circular structure yields its ring and stops."
  (let ((acc nil) (visited (make-hash-table :test 'eq)))
    (loop for c = x then (cdr c)
          while (and (consp c) (not (gethash c visited)))
          do (setf (gethash c visited) t)
             (push c acc))
    (nreverse acc)))

(defun sa0-ct-capture (plist terminal)
  "EVERYTHING THAT WOULD HAVE TO CHANGE FOR THE PLANT TO HAVE BEEN TOUCHED: the
head cons, every cons of the spine in order, the CAR of each, and the object the
chain ends in — an ATOM for a dotted plant, THE HEAD CONS ITSELF for a circular
one.  Captured by IDENTITY, and compared by identity afterwards, because
comparing a circular structure by STRUCTURE is the same non-termination this
round exists to close."
  (let ((spine (sa0-ct-spine plist)))
    (list :head plist :spine spine :cars (mapcar #'car spine) :terminal terminal)))

(defun sa0-ct-unchanged-p (capture now)
  "Is the planted carrier EXACTLY as it was planted?  A fixed number of EQ
comparisons — never a structural walk of the plant."
  (let ((spine (getf capture :spine))
        (terminal (getf capture :terminal)))
    (and (consp now)
         (eq now (getf capture :head))
         (eq now (first spine))
         (every #'eq (getf capture :cars) (mapcar #'car spine))
         (= (length (getf capture :cars)) (length spine))
         (loop for rest on spine
               always (if (rest rest)
                          (eq (cdr (first rest)) (second rest))
                          (eq (cdr (first rest)) terminal))))))

(defun sa0-ct-make-dotted (&optional cell)
  "(SA0-UNRELATED-PROPERTY :KEPT . SA0-R333-DOTTED-TAIL) — the ruling's own
shape — optionally with ONE otherwise-lawful reserved cell in front of it."
  (let ((body (list* 'sa0-unrelated-property :kept *ct-dotted-tail-atom*)))
    (if cell (list* 'sa0-identity-cell cell body) body)))

(defun sa0-ct-make-circular ()
  "A circular property list carrying NO reserved indicator: four conses whose
last CDR is the head."
  (let ((c (list 'sa0-unrelated-property :kept 'sa0-other-property :also)))
    (setf (cdr (last c)) c)
    c))

(defun sa0-ct-bounded-call (name seconds fn)
  "Run FN in its own thread under SECONDS, and report what happened rather than
what was hoped: (:outcome :completed|:timeout|:errored :error <text>
:seconds <n> :join :ok|:timeout).  An arm whose whole exhibit is an EXPIRY needs
a runner that can tell an expiry from a refusal."
  (let ((outcome :not-run) (err nil) (secs nil))
    (let ((thread (sb-thread:make-thread
                   (lambda ()
                     (let ((start (get-internal-real-time)))
                       (handler-case
                           (sb-ext:with-timeout seconds
                             (funcall fn)
                             (setf outcome :completed))
                         (sb-ext:timeout () (setf outcome :timeout))
                         (error (c) (setf err (sa0-flatten-line c) outcome :errored)))
                       (setf secs (/ (float (- (get-internal-real-time) start))
                                     internal-time-units-per-second)))
                     :done)
                   :name name)))
      (let ((join (sa0-join thread)))
        (list :join join :outcome outcome :error err :seconds secs)))))

(defun sa0-ct-bounded-answer (name fn)
  "WHAT A BARE READER GETS, AND IT IS ASKED UNDER A BOUND.  Returns the reader's
own answer, :REFUSED if the reader signalled, or :HUNG if it did not come back
inside the hard bound.

THE THIRD OUTCOME IS NOT DECORATION, and this harness learned it the hard way:
these readers are called with a MALFORMED CARRIER STILL INSTALLED, and under the
RETURNED law a reader of a CIRCULAR carrier never comes back at all.  A harness
that called them directly would not report that — it would BECOME it, and a
section that hangs delivers no verdict, which is exactly the outcome this whole
lane forbids.  A timeout is a failure, never a pass, and never a hang either."
  (let ((answer :unset))
    (let ((r (sa0-ct-bounded-call name *sa0-hard-bound-seconds*
                                  (lambda () (setf answer (funcall fn))))))
      (case (getf r :outcome)
        (:completed answer)
        (:errored :refused)
        (t :hung)))))

(defun sa0-ct-elections ()
  (sa0-ct-bounded-answer "SA0-R333-CT-READ-ELECTIONS"
                         (lambda () (sa0-call 'sa0-election-count))))

(defun sa0-ct-gatherings ()
  (sa0-ct-bounded-answer "SA0-R333-CT-READ-GATHERINGS"
                         (lambda () (sa0-call 'sa0-epoch-gatherings))))

(defun sa0-ct-ready ()
  "What a bare reader gets from the image RIGHT NOW: :READY, :NOT-READY,
:REFUSED, or :HUNG.  On a malformed carrier the answer must be :REFUSED — not
merely 'not ready', and not :HUNG either.  The stronger sentence is the true
one: no reader can extract a readiness answer from a carrier this source will
not read, and it finds that out in bounded time."
  (sa0-ct-bounded-answer "SA0-R333-CT-READ-READY"
                         (lambda () (if (sa0-call 'sa0-identity-ready-p) :ready :not-ready))))

(defvar *ct-arm-dotted* nil)
(defvar *ct-arm-dotted-cell* nil)
(defvar *ct-arm-circular* nil)
(defvar *ct-dotted-capture* nil)
(defvar *ct-dotted-shape* :unread)
(defvar *ct-dotted-count-before* :unread)
(defvar *ct-dotted-eq-on-plant* nil)
(defvar *ct-dotted-unchanged* nil)
(defvar *ct-dotted-elections* :unread)
(defvar *ct-dotted-ready* :unread)
(defvar *ct-dotted-gatherings* :unread)
(defvar *ct-cell-lawful-p* :unread)
(defvar *ct-cellular-capture* nil)
(defvar *ct-cellular-shape* :unread)
(defvar *ct-cellular-count-before* :unread)
(defvar *ct-cellular-unchanged* nil)
(defvar *ct-cellular-elections* :unread)
(defvar *ct-cellular-ready* :unread)
(defvar *ct-circular-capture* nil)
(defvar *ct-circular-shape* :unread)
(defvar *ct-circular-count-before* :unread)
(defvar *ct-circular-pairs* :unread)
(defvar *ct-circular-printed* "")
(defvar *ct-circular-eq-on-plant* nil)
(defvar *ct-circular-unchanged* nil)
(defvar *ct-circular-elections* :unread)
(defvar *ct-circular-ready* :unread)
(defvar *ct-final-elections* :unread)
(defvar *ct-final-gatherings* :unread)

(defun sa0-run-carrier-total-arms ()
  ;; ---- ARM 1: an improper (dotted) carrier, NO reserved indicator ----------
  (let ((plist (sa0-ct-make-dotted)))
    (setf *ct-dotted-capture* (sa0-ct-capture plist *ct-dotted-tail-atom*))
    (multiple-value-bind (shape count) (sa0-ct-classify plist)
      (setf *ct-dotted-shape* shape *ct-dotted-count-before* count))
    (sa0-cs-set-carrier plist)
    ;; THE PRECONDITION IS EXHIBITED: exact SBCL 2.4.6 stored the improper list
    ;; in a SYMBOL-PLIST and hands back THE SAME OBJECT.
    (setf *ct-dotted-eq-on-plant* (eq plist (symbol-plist 'sa0-identity-carrier)))
    (setf *ct-arm-dotted* (sa0-cs-run-load "SA0-R333-CT-DOTTED"))
    (setf *ct-dotted-unchanged* (sa0-ct-unchanged-p *ct-dotted-capture*
                                                    (symbol-plist 'sa0-identity-carrier))
          *ct-dotted-elections* (sa0-ct-elections)
          *ct-dotted-ready* (sa0-ct-ready)
          *ct-dotted-gatherings* (sa0-ct-gatherings)))

  ;; ---- ARM 2: the same improper carrier, CARRYING ONE LAWFUL CELL ----------
  ;;
  ;; The cell is built with THE SOURCE'S OWN constructor and shown lawful by THE
  ;; SOURCE'S OWN predicate, both of which the failed load above defined: the
  ;; refusal that follows is therefore not about the cell.  TOTALITY OUTRANKS
  ;; THE LAWFUL FRAGMENT — the walk counts this indicator, and then reaches the
  ;; dotted tail and refuses anyway.
  (let* ((cell (sa0-call 'make-sa0-identity-cell sb-thread:*current-thread*))
         (plist (sa0-ct-make-dotted cell)))
    (setf *ct-cell-lawful-p* (and (sa0-call 'sa0-lawful-cell-p cell) t))
    (setf *ct-cellular-capture* (sa0-ct-capture plist *ct-dotted-tail-atom*))
    (multiple-value-bind (shape count) (sa0-ct-classify plist)
      (setf *ct-cellular-shape* shape *ct-cellular-count-before* count))
    (sa0-cs-set-carrier plist)
    (setf *ct-arm-dotted-cell* (sa0-cs-run-load "SA0-R333-CT-DOTTED-CELL"))
    (setf *ct-cellular-unchanged* (sa0-ct-unchanged-p *ct-cellular-capture*
                                                      (symbol-plist 'sa0-identity-carrier))
          *ct-cellular-elections* (sa0-ct-elections)
          *ct-cellular-ready* (sa0-ct-ready)))

  ;; ---- ARM 3: a CIRCULAR carrier, NO reserved indicator --------------------
  (let ((plist (sa0-ct-make-circular)))
    (setf *ct-circular-capture* (sa0-ct-capture plist plist))
    (multiple-value-bind (shape count pairs) (sa0-ct-classify plist)
      (setf *ct-circular-shape* shape
            *ct-circular-count-before* count
            *ct-circular-pairs* pairs))
    ;; PRINTED WITH *PRINT-CIRCLE*, because printing it without would be the
    ;; same non-termination in the transcript writer.
    (setf *ct-circular-printed* (let ((*print-circle* t)) (format nil "~S" plist)))
    (sa0-cs-set-carrier plist)
    (setf *ct-circular-eq-on-plant* (eq plist (symbol-plist 'sa0-identity-carrier)))
    (setf *ct-arm-circular* (sa0-cs-run-load "SA0-R333-CT-CIRCULAR"))
    (setf *ct-circular-unchanged* (sa0-ct-unchanged-p *ct-circular-capture*
                                                      (symbol-plist 'sa0-identity-carrier))
          *ct-circular-elections* (sa0-ct-elections)
          *ct-circular-ready* (sa0-ct-ready)))

  ;; ---- THE IMAGE, AFTER THREE REFUSALS ------------------------------------
  ;; The carrier is restored to EMPTY so the two image-wide readers can be asked
  ;; at all; both must answer ZERO.  Nothing here elects: restoring a plist is a
  ;; harness write, not a load.
  (sa0-cs-set-carrier nil)
  (setf *ct-final-elections* (sa0-ct-elections)
        *ct-final-gatherings* (sa0-ct-gatherings)))

;;; --------------------------------------------------------------------------
;;; THE TWO REPLICA CONFESSIONS — THE RETURNED WALK, ON CAPTIVE SYMBOLS.
;;;
;;; SA0-CT-R332-SCAN is the R3.3.2 counting walk in its returned shape: `while
;;; (consp tail)` with the odd-tail check and nothing else.  It runs on captive
;;; symbols, so the ruled carrier is never touched by it.
;;;
;;; WHAT THE CONFESSIONS CLAIM AND WHAT THEY DO NOT.  They do NOT prove what the
;;; returned file contained — that is checkable in the parcel's own history.
;;; They prove the CONSEQUENCE: that THIS walk, on THESE two shapes, accepts a
;;; dotted revenant as an empty lawful carrier and never returns at all from a
;;; circular one.
;;; --------------------------------------------------------------------------

(defun sa0-ct-r332-scan (plist)
  "THE RETURNED WALK, VERBATIM IN ITS RETURNED SHAPE."
  (let ((count 0) (value nil))
    (loop for tail = plist then (cddr tail)
          while (consp tail)
          do (unless (consp (cdr tail))
               (error "R3.3.2 WALK: the carrier's property list is MALFORMED — ~
                       it ends in the indicator ~S with no value"
                      (car tail)))
             (when (eq 'sa0-identity-cell (car tail))
               (when (zerop count) (setf value (second tail)))
               (incf count)))
    (values count value)))

(defvar *ct-replica-scan-outcome* :unread)
(defvar *ct-replica-count-before* :unread)
(defvar *ct-replica-install-won* nil)
(defvar *ct-replica-count-after* :unread)
(defvar *ct-replica-reader-verdict* :unread)
(defvar *ct-replica-plist-after* "")
(defvar *ct-replica-tail-survives* nil)
(defvar *ct-replica-repaired-refused* nil)
(defvar *ct-replica-repaired-refusal* "NONE")
(defvar *ct-circ-replica-outcome* :not-run)
(defvar *ct-circ-replica-seconds* nil)
(defvar *ct-circ-replica-join* :not-run)
(defvar *ct-circ-repaired-outcome* :not-run)
(defvar *ct-circ-repaired-seconds* nil)
(defvar *ct-circ-repaired-join* :not-run)
(defvar *ct-circ-repaired-refusal* "NONE")

(defun sa0-run-ct-replica-dotted-arm ()
  (let ((cell (sa0-call 'make-sa0-identity-cell sb-thread:*current-thread*)))
    (setf (symbol-plist 'sa0-r333-captive-carrier) (sa0-ct-make-dotted))
    (let ((observed (symbol-plist 'sa0-r333-captive-carrier)))
      ;; THE RETURNED WALK, on the ruling's own shape.
      (handler-case
          (multiple-value-bind (count value) (sa0-ct-r332-scan observed)
            (declare (ignore value))
            (setf *ct-replica-count-before* count
                  *ct-replica-scan-outcome* :completed))
        (error () (setf *ct-replica-scan-outcome* :errored)))
      ;; THE RETURNED ELECTION: a CAS whose OLD value is that exact object, and
      ;; whose NEW value is that object with the reserved indicator consed on.
      (when (and (eq :completed *ct-replica-scan-outcome*)
                 (eql 0 *ct-replica-count-before*))
        (let ((prior (sb-ext:cas (symbol-plist 'sa0-r333-captive-carrier)
                                 observed
                                 (list* 'sa0-identity-cell cell observed))))
          (setf *ct-replica-install-won* (eq prior observed))))
      (let ((after (symbol-plist 'sa0-r333-captive-carrier)))
        ;; PRINTED WITH THE CELL ELIDED — a lawful cell holds a thread, a mutex
        ;; and a waitqueue, and printing them would print addresses.
        ;; The tail is spliced in WITHOUT its own outer parenthesis, so the line
        ;; reads as the ruling's block reads: one flat property list whose last
        ;; CDR is the surviving dotted atom.
        (setf *ct-replica-plist-after*
              (format nil "(SA0-IDENTITY-CELL <lawful-cell> ~A"
                      (subseq (format nil "~S" (cddr after)) 1))
              *ct-replica-tail-survives* (eq (cddr after) observed))
        ;; A LATER READER, using the returned walk and THE UNCHANGED (LOCKED)
        ;; ADJUDICATION: this is the "ready-p T" of the ruling's block.
        (handler-case
            (multiple-value-bind (count value) (sa0-ct-r332-scan after)
              (setf *ct-replica-count-after* count)
              (setf *ct-replica-reader-verdict*
                    (if (eq cell (sa0-call 'sa0-adjudicate-reserved count value))
                        :accepted-the-cell
                        :other)))
          (error () (setf *ct-replica-reader-verdict* :refused)))
        ;; AND THE REPAIRED WALK, on the SAME captive object, for the contrast.
        (handler-case (progn (sa0-call 'sa0-scan-reserved observed)
                             (setf *ct-replica-repaired-refused* nil))
          (error (c) (setf *ct-replica-repaired-refused* t
                           *ct-replica-repaired-refusal* (sa0-flatten-line c))))))))

(defun sa0-run-ct-replica-circular-arm ()
  (let ((plist (sa0-ct-make-circular)))
    (setf (symbol-plist 'sa0-r333-captive-circular) plist)
    ;; THE RETURNED WALK.  THE EXPIRY IS THE EXHIBIT: this arm's expected
    ;; outcome is :TIMEOUT, so the bound is the length of the exhibition and a
    ;; longer one would prove nothing more.
    (let ((r (sa0-ct-bounded-call "SA0-R333-CT-REPLICA-CIRCULAR"
                                  *sa0-spin-exhibit-seconds*
                                  (lambda () (sa0-ct-r332-scan plist)))))
      (setf *ct-circ-replica-outcome* (getf r :outcome)
            *ct-circ-replica-seconds* (getf r :seconds)
            *ct-circ-replica-join* (getf r :join)))
    ;; THE REPAIRED WALK, ON THE SAME OBJECT, UNDER THE SAME SMALL BOUND.
    (let ((r (sa0-ct-bounded-call "SA0-R333-CT-REPAIRED-CIRCULAR"
                                  *sa0-spin-exhibit-seconds*
                                  (lambda () (sa0-call 'sa0-scan-reserved plist)))))
      (setf *ct-circ-repaired-outcome* (getf r :outcome)
            *ct-circ-repaired-seconds* (getf r :seconds)
            *ct-circ-repaired-join* (getf r :join)
            *ct-circ-repaired-refusal* (or (getf r :error) "NONE")))))

;;; ==========================================================================
;;; THE SECTIONS.
;;; ==========================================================================

;;; R3.3.1 EVIDENCE HYGIENE — THE GATE LOG'S ORDER IS VOLATILE EXACTLY WHEN IT
;;; IS A SCHEDULING ARTIFACT, AND NOT OTHERWISE.
;;;
;;; QUARTERMASTER-7's disclosure against R3.3 was precise: two ADJACENT gate-log
;;; lines in the stale tooth can swap between two runs of the same sources at
;;; the same tip, because both loaders record their pre-initial observation
;;; before either is released and the recording order is whatever the scheduler
;;; chose.  A comparer running `grep -v VOLATILE` would report a difference that
;;; is not a difference in the artifact.
;;;
;;; THE DISPOSITION, AND WHY IT IS NOT 'SORT THEM'.  Sorting would print AN
;;; ORDER THAT WAS NOT OBSERVED — a fabricated determinism, which is a worse
;;; defect than the one it cures, because the log's whole job is to say what
;;; happened.  So the observed order is printed as observed, and each per-entry
;;; line is marked VOLATILE **when the log records more than one thread**, which
;;; is exactly the condition under which the inter-entry order is a scheduling
;;; artifact.  In a single-threaded log — the recursive tooth, and the two new
;;; single-loader teeth — the order is a property of the source's own control
;;; path, it is stable between runs, and it stays inside the comparison.
;;;
;;; The COUNT line is never VOLATILE: it does not move.

(defun sa0-print-phase-log ()
  (let* ((entries (reverse *sa0-phase-log*))
         (threads (remove-duplicates (mapcar #'first entries) :test #'string=))
         (multi (> (length threads) 1)))
    (kv "gate calls recorded" (length entries))
    (kv "gate threads recorded" (length threads))
    (kv "gate order is volatile" (if multi "YES — more than one thread records" "NO — one thread only"))
    (dolist (e entries)
      (kv (format nil "~:[~;VOLATILE ~]gate ~A" multi (first e))
          (format nil "phase ~A / ready-p ~A" (second e) (third e))))))

(cond
  ;; ------------------------------------------------------------------------
  ((string= *sa0-schedule-role* "stale")
   (probe-header "THE STALE-DEFINITION OVERWRITE TOOTH — one pinned schedule, run against the candidate source and against the R3.2 law")

   (p "SCOPE, PRINTED BEFORE ANY NUMBER:")
   (p "  This image had never loaded probe-identity.lisp when the arm below")
   (p "  began, so the epoch had never been gathered.  Nothing here is a thread")
   (p "  count and nothing here is a timing loop: ONE interleaving is forced by")
   (p "  a two-party barrier and a semaphore, and that interleaving is the one")
   (p "  the owner's FINDING 1 names.  What is demonstrated is a MECHANISM, not")
   (p "  an Account /0 occurrence identity, which does not exist.")
   (rule)
   (kv "role" *sa0-schedule-role*)
   (kv "hard bound (seconds)" *sa0-hard-bound-seconds*)
   (kv "candidate source" (file-namestring *sa0-identity-path*))
   (kv "sb-thread present" (if (find-package "SB-THREAD") "YES" "NO"))
   (kv "candidate loaded before this arm"
       (if (fboundp 'sa0-carrier-cell) "YES — THE PRECONDITION IS BROKEN" "NO"))

   (rule)
   (p "INIT-STALE-CLEAN  the pinned schedule, run against THE EXACT CANDIDATE SOURCE")
   (arm "CLEAN" "two loaders past the pre-initial observation; one held across the winner's entire initialization")

   (sa0-run-stale-clean-arm)

   (let* ((obs *stale-delayed-observation*)
          (delayed-cell  (getf obs :cell))
          (delayed-state (getf obs :state))
          (pre-initial-entries
            (remove-if-not (lambda (e) (eq (second e) :observed-pre-initial))
                           *sa0-phase-log*))
          (pre-initial-threads
            (remove-duplicates (mapcar #'first pre-initial-entries) :test #'string=)))
     (sa0-print-phase-log)
     (kv "winner thread join" *stale-winner-join*)
     (kv "delayed thread join" *stale-delayed-join*)
     (kv "loaders that observed pre-initial" (length pre-initial-threads))
     (kv "ready-p when winner released delayed" *stale-ready-at-release*)
     (kv "winner cell present" (if *stale-winner-cell* "YES" "NO"))
     (kv "winner state present" (if *stale-winner-state* "YES" "NO"))
     (kv "delayed observed same cell" (if (eq *stale-winner-cell* delayed-cell) "YES" "NO"))
     (kv "delayed observed same state" (if (eq *stale-winner-state* delayed-state) "YES" "NO"))
     (kv "epoch gatherings this image" (sa0-call 'sa0-epoch-gatherings))
     (kv "elections won this image" (sa0-call 'sa0-election-count))
     (kv "VOLATILE image epoch" (sa0-call 'sa0-epoch-hex))
     (kv "allocations taken after the pin" (length *stale-allocations*))

     (probe-check "INIT-STALE-CLEAN-BOTH-LOADERS-ENTERED-PRE-INITIAL"
                  "stale tooth clean [R3.3-B.1]: BOTH loaders really entered the candidate source's initialization and BOTH observed the pre-initial state — each reported ready-p NIL at the gate — before either attempted its election.  Two distinct thread names are recorded, so this is two loaders and not one loader counted twice"
                  (and (= 2 (length pre-initial-threads))
                       (= 2 (length pre-initial-entries))
                       (every (lambda (e) (null (third e))) pre-initial-entries)))

     (probe-check "INIT-STALE-CLEAN-DELAYED-HELD-ACROSS-PUBLICATION"
                  "stale tooth clean [R3.3-B.1]: the delayed loader was held from before its own election until AFTER the winner had published — the winner observed ready-p T immediately before signalling the release, so the resumed loader re-entered a fully published image, which is exactly the ordering that destroyed the R3.2 mechanism"
                  (and (eq t *stale-ready-at-release*)
                       (eq :ok *stale-winner-join*)
                       (eq :ok *stale-delayed-join*)))

     (probe-check "INIT-STALE-CLEAN-CARRIER-IDENTITY-UNCHANGED"
                  "stale tooth clean [R3.3-B.1]: the WINNING CARRIER AND STATE IDENTITY ARE UNCHANGED by the delayed loader.  The cell and the state object the winner installed are EQ to the ones present after the delayed loader completed: nothing was replaced, nothing was republished, and the delayed loader installed nothing"
                  (and *stale-winner-cell*
                       *stale-winner-state*
                       (eq *stale-winner-cell*  (sa0-call 'sa0-carrier-cell))
                       (eq *stale-winner-state* (sa0-call 'sa0-published-state))))

     (probe-check "INIT-STALE-CLEAN-DELAYED-OBSERVED-THE-WINNING-STATE"
                  "stale tooth clean [R3.3-B.1]: and the delayed loader OBSERVED THAT EXACT STATE — the same cell object and the same state object, by EQ, not merely an equal epoch text.  A loader that had elected a second time would hold a different object and this check would fail"
                  (and (eq *stale-winner-cell*  delayed-cell)
                       (eq *stale-winner-state* delayed-state)
                       (eq t (getf obs :ready))))

     (probe-check "INIT-STALE-CLEAN-ONE-EPOCH-GATHERED"
                  "stale tooth clean [R3.3-B.1]: EXACTLY ONE epoch was gathered and EXACTLY ONE ELECTION was won.  The per-cell tally is an ATOMIC-PUSH list recorded before the draw, so no lost update can hide a second gathering; the election log lives on a SECOND symbol that no carrier overwrite can reach, so a mechanism that replaced the cell could not hide the second election either"
                  (and (= 1 (sa0-call 'sa0-epoch-gatherings))
                       (= 1 (getf obs :gatherings))
                       (= 1 (sa0-call 'sa0-election-count))))

     (probe-check "INIT-STALE-CLEAN-ONE-ALLOCATOR-AND-ONE-COUNTER"
                  "stale tooth clean [R3.3-B.1]: EXACTLY ONE allocator synchronization object and ONE counter exist — they are slots of the one published state object, so the delayed loader's allocator mutex is EQ to the winner's and there is no second counter for a second mutex to guard"
                  (and (eq (getf obs :alloc-mutex) (sa0-call 'sa0-performance-mutex))
                       (typep (sa0-call 'sa0-performance-mutex) 'sb-thread:mutex)))

     (probe-check "INIT-STALE-CLEAN-NO-PARTIAL-STATE-OBSERVED"
                  "stale tooth clean [R3.3-B.1]: NO PARTIAL STATE WAS EVER OBSERVED.  Every gate observation reports ready-p NIL before publication and the delayed loader reports a complete state after it — epoch text, epoch datum, allocator mutex and counter all present together, because they are one object that was unreachable until it was whole"
                  ;; R3.3.2: partitioned by phase — identical on pre-existing phase classes,
                  ;; a real new obligation on the new post-publication class; see
                  ;; SA0-PRE-PUBLICATION-ENTRIES above for the exact shape.
                  (and (every (lambda (e) (null (third e)))
                              (sa0-pre-publication-entries *sa0-phase-log*))
                       (every (lambda (e) (eq t (third e)))
                              (sa0-post-publication-entries *sa0-phase-log*))
                       (stringp (getf obs :epoch))
                       (= 32 (length (getf obs :epoch)))
                       (getf obs :alloc-mutex)
                       (sa0-call 'sa0-epoch-datum)))

     (probe-check "INIT-STALE-CLEAN-ALLOCATIONS-CONTIGUOUS-FROM-ONE"
                  "stale tooth clean [R3.3-B.1]: subsequent allocations are ONE CONTIGUOUS SEQUENCE BEGINNING AT 1 — twenty allocations taken by four threads after the pinned race are exactly 1..20 with no gap and no repeat, which two counters or two allocator mutexes could not produce"
                  (sa0-contiguous-from-1-p *stale-allocations* 20)))
   (p "END-INIT-STALE-CLEAN")

   (rule)
   (p "INIT-STALE-PLANTED  the same pin, applied to the exact R3.2 DEFGLOBAL-then-CAS law")
   (arm "PLANTED" "a captive copy of the R3.2 law, loaded for real, with the gate inside the defining form's value form")

   (p "  THE MACROEXPANSION, PRINTED RATHER THAN DESCRIBED.  The unbound test is")
   (p "  computed as an argument and the write happens later, inside %DEFGLOBAL,")
   (p "  so a gate inside the value form sits exactly between them:")
   (p "    ~S" (macroexpand-1 '(sb-ext:defglobal sa0-r33-expansion-demo nil "doc")))
   (p "  THE CAPTIVE SOURCE, LOADED FROM A STRING STREAM, VERBATIM:")
   (dolist (line (let ((acc nil) (start 0))
                   (loop for i from 0 below (length *captive-r32-source*)
                         when (char= #\Newline (char *captive-r32-source* i))
                           do (push (subseq *captive-r32-source* start i) acc)
                              (setf start (1+ i)))
                   (nreverse acc)))
     (p "    | ~A" line))

   (sa0-run-stale-planted-arm)

   (let* ((cand-a (sa0-captive-note-for *captive-a-name* :candidate))
          (cand-b (sa0-captive-note-for *captive-b-name* :candidate))
          (a-after (sa0-captive-note-for *captive-a-name* :after-cas))
          (final (symbol-value '*sa0-r33-captive-guard*))
          (both-entered (= 2 (length *captive-entered*)))
          (a-installed (and cand-a (eq a-after cand-a)))
          (b-installed (and cand-b (eq final cand-b) (not (eq cand-a cand-b))))
          (a-clobbered (and cand-a (not (eq final cand-a)))))
     (kv "captive joins" (format nil "~{~A~^ ~}" *captive-joins*))
     (kv "captive loaders entered" (length *captive-entered*))
     (kv "captive notes recorded" (length *captive-notes*))
     ;; The five observation lines the owner's FINDING 1 pinned, verbatim.
     (p "    both LOADs entered stale value form: ~A" (if both-entered "T" "NIL"))
     (p "    A installed its mutex: ~A" (if a-installed "T" "NIL"))
     (p "    B installed its distinct mutex: ~A" (if b-installed "T" "NIL"))
     (p "    A mutex was clobbered: ~A" (if a-clobbered "T" "NIL"))
     (p "    final cell is B mutex: ~A" (if (eq final cand-b) "T" "NIL"))

     (probe-check "INIT-STALE-PLANTED-BOTH-ENTERED-STALE-VALUE-FORM"
                  "stale tooth planted [R3.3-B.1]: both captive loaders reached the DEFGLOBAL value form, which on this runtime is evaluated AFTER that form's unbound test and BEFORE its write — so both had already decided 'unbound' when the pin took hold.  This is the real macro on the real runtime, not a re-implementation of its semantics"
                  both-entered)

     (probe-check "INIT-STALE-PLANTED-DISTINCT-MUTEXES-INSTALLED"
                  "stale tooth planted [R3.3-B.1]: A CAS-installed its mutex and observed its own object in the cell; B then CAS-installed a DISTINCT mutex.  Two mutexes were elected where the law admits one, and under the R3.2 mechanism the second would have been the live bootstrap primitive"
                  (and a-installed b-installed))

     (probe-check "INIT-STALE-PLANTED-WINNER-MUTEX-CLOBBERED"
                  "stale tooth planted [R3.3-B.1]: A's INSTALLED MUTEX WAS ERASED by B's already-authorized delayed initializer write, and B's CAS then succeeded against the NIL that write had just left behind.  CAS serializes CAS against CAS; it does not serialize an earlier defining form's delayed write against a later CAS publication.  That is OWNER FINDING 1, exhibited"
                  (and a-clobbered (eq final cand-b)))

     (probe-check "INIT-STALE-DISCRIMINATES"
                  "stale tooth [R3.3-B.1]: ONE SCHEDULE, TWO LAWS, OPPOSITE OUTCOMES.  Under the identical pinned ordering the R3.2 law lost its winner's object and ended with two mutexes, while the R3.3 carrier kept one cell, one state, one epoch and one allocator.  The tooth therefore discriminates, and a clean arm that could not fail is not the arm above"
                  (and a-clobbered
                       (not (eq cand-a cand-b))
                       (eq *stale-winner-cell* (sa0-call 'sa0-carrier-cell))
                       (eq *stale-winner-state* (sa0-call 'sa0-published-state))
                       (= 1 (sa0-call 'sa0-epoch-gatherings)))))
   (p "END-INIT-STALE-PLANTED")

   (rule)
   (p "CEILING, RESTATED WHERE THE NUMBERS ARE:")
   (p "  What is closed here is ONE named schedule — the stale defining write")
   (p "  arriving after a CAS publication — against the exact candidate source,")
   (p "  on this host, on SBCL 2.4.6, at this parcel tip.  It is not a proof of")
   (p "  correctness under every possible interleaving, and no such proof is")
   (p "  claimed.  The argument that generalizes is the one in the source: the")
   (p "  carrier has no defining form in the candidate source at all, so there")
   (p "  is no delayed initializer of any schedule that could reach it.")

   (when (plant-failure-requested-p)
     (probe-check "INIT-STALE-PLANTED-FAULT" "PLANTED FAULT: this check is designed to fail" nil))

   (probe-footer "INIT-STALE-SCHEDULE")
   (probe-exit))

  ;; ------------------------------------------------------------------------
  ((string= *sa0-schedule-role* "recursive")
   (probe-header "THE GENUINE RECURSIVE-LOAD TOOTH — a same-thread recursive LOAD fired from inside an unfinished initialization")

   (p "SCOPE, PRINTED BEFORE ANY NUMBER:")
   (p "  This image had never loaded probe-identity.lisp when the arm below")
   (p "  began.  A test-only hook fires DURING the winning initialization and")
   (p "  BEFORE ready publication; from inside it, the same thread LOADs the")
   (p "  same exact source once.  Every wait carries a hard bound and the outer")
   (p "  load runs inside SB-EXT:WITH-TIMEOUT, so a self-deadlock is an OBSERVED")
   (p "  FAILURE and never a hang and never a silent pass.")
   (rule)
   (kv "role" *sa0-schedule-role*)
   (kv "hard bound (seconds)" *sa0-hard-bound-seconds*)
   (kv "candidate source" (file-namestring *sa0-identity-path*))

   (rule)
   (p "INIT-RECURSIVE-CLEAN  one same-thread recursive load, fired before ready publication")
   (arm "CLEAN" "the hook fires at :ELECTED-BEFORE-PUBLICATION and recursively LOADs the exact candidate source once")

   (sa0-run-recursive-arm)

   (let ((elected-entries
           (remove-if-not (lambda (e) (eq (second e) :elected-before-publication))
                          *sa0-phase-log*)))
     (sa0-print-phase-log)
     (kv "hook fired" (if *rec-hook-fired* "YES" "NO"))
     (kv "hook error [printed global]" (or *rec-hook-error* "NONE"))
     (kv "inner load completed" (if *rec-inner-load-completed* "YES" "NO"))
     (kv "max load depth reached" *rec-max-depth*)
     (kv "ready-p at hook entry" *rec-ready-at-hook*)
     (kv "ready-p after inner load" *rec-ready-after-inner*)
     (kv "inner re-entry outcome" *rec-inner-outcome*)
     (kv "outer load result" *rec-outer-result*)
     (kv "outer thread join" *rec-outer-join*)
     (kv "epoch gatherings this image" (sa0-call 'sa0-epoch-gatherings))
     (kv "elections won this image" (sa0-call 'sa0-election-count))
     (kv "VOLATILE image epoch" (sa0-call 'sa0-epoch-hex))
     (kv "first allocation" *rec-first-allocation*)
     (kv "gatherings before later reload" *rec-reload-gatherings-before*)
     (kv "gatherings after later reload" *rec-reload-gatherings-after*)
     (kv "allocation after later reload" *rec-allocation-after-reload*)

     (probe-check "INIT-RECURSIVE-HOOK-FIRED-BEFORE-PUBLICATION"
                  "recursive tooth [R3.3-B.2]: the test-only hook REALLY FIRED, and it fired DURING initialization and BEFORE ready publication — ready-p was NIL at hook entry, and the hook's phase is the one the candidate source calls after building the complete state privately and before its single publication CAS"
                  (and *rec-hook-fired*
                       (null *rec-ready-at-hook*)
                       (= 1 (length elected-entries))
                       (null (third (first elected-entries)))))

     (probe-check "INIT-RECURSIVE-INNER-LOAD-EXECUTED"
                  "recursive tooth [R3.3-B.2]: the RECURSIVE LOAD really executed and really returned — the same exact candidate source, loaded once, on the same thread, from inside the outer load's unfinished initialization"
                  (and *rec-inner-load-completed* (null *rec-hook-error*)))

     (probe-check "INIT-RECURSIVE-DEPTH-REACHED-TWO"
                  "recursive tooth [R3.3-B.2]: the RECURSION DEPTH REACHED THE INTENDED NESTED CALL — depth 2, the inner load running inside the outer one.  A tooth that recorded depth 1 would be a sequential reload wearing a recursion's name, which is precisely the mislabel R3.3 corrected elsewhere"
                  (= 2 *rec-max-depth*))

     (probe-check "INIT-RECURSIVE-NO-DEADLOCK-WITHIN-BOUND"
                  "recursive tooth [R3.3-B.2]: NEITHER INVOCATION DEADLOCKED and neither escaped through an uncontrolled host error.  The outer load ran inside SB-EXT:WITH-TIMEOUT and the join carried the same hard bound; the recorded result is :COMPLETED, not :TIMEOUT — and a :TIMEOUT here would FAIL this check rather than pass it quietly"
                  (and (eq :completed *rec-outer-result*)
                       (eq :done *rec-outer-join*)
                       (null *rec-hook-error*)))

     (probe-check "INIT-RECURSIVE-INNER-DEFERRED-NOT-READY"
                  "recursive tooth [R3.3-B.2]: the inner invocation was DETECTED AS OWNER RE-ENTRY and took the documented probe-local deferred path — it returned :DEFERRED-OWNER-REENTRY, it did NOT claim that initialization was ready, and ready-p was still NIL when it returned.  A concurrent non-owner may not take this path; the test is EQ on the owning thread"
                  (and (eq :deferred-owner-reentry *rec-inner-outcome*)
                       (null *rec-ready-after-inner*)))

     (probe-check "INIT-RECURSIVE-ONE-EPOCH-GATHERED"
                  "recursive tooth [R3.3-B.2]: EXACTLY ONE EPOCH GATHERING and EXACTLY ONE ELECTION occurred across the outer load, the recursive inner load and the later ordinary reload — the re-entry gathered nothing and elected nothing.  The tally cannot under-report because it is recorded before the draw, and the election log sits on a symbol no carrier overwrite could reach"
                  (and (= 1 (sa0-call 'sa0-epoch-gatherings))
                       (= 1 (sa0-call 'sa0-election-count))
                       (= 1 *rec-reload-gatherings-before*)
                       (= 1 *rec-reload-gatherings-after*)))

     (probe-check "INIT-RECURSIVE-ONE-READY-STATE-AND-ONE-ALLOCATOR"
                  "recursive tooth [R3.3-B.2]: EXACTLY ONE READY STATE AND ONE ALLOCATOR SYNCHRONIZATION OBJECT SURVIVED — the published state object is the same object before and after the later reload, and the allocator mutex is its slot, so 'one state' and 'one allocator' are one fact and not two hopes"
                  (let ((state (sa0-call 'sa0-published-state)))
                    (and state
                         (eq state (sa0-call 'sa0-published-state))
                         (typep (sa0-call 'sa0-performance-mutex) 'sb-thread:mutex))))

     (probe-check "INIT-RECURSIVE-NO-PARTIAL-READY-OBSERVED"
                  "recursive tooth [R3.3-B.2]: NO PARTIAL-READY OBSERVATION OCCURRED.  Every gate observation taken BEFORE the one publication reports ready-p NIL, every observation taken after it reports T, and readiness became true only at the outermost load's single publication — the outermost initialization owns the sole transition to ready"
                  ;; R3.3.2: partitioned by phase — identical on pre-existing phase classes,
                  ;; a real new obligation on the new post-publication class; see
                  ;; SA0-PRE-PUBLICATION-ENTRIES above for the exact shape.
                  (and (every (lambda (e) (null (third e)))
                              (sa0-pre-publication-entries *sa0-phase-log*))
                       (every (lambda (e) (eq t (third e)))
                              (sa0-post-publication-entries *sa0-phase-log*))
                       (sa0-call 'sa0-identity-ready-p)))

     (probe-check "INIT-RECURSIVE-OUTERMOST-COMPLETED"
                  "recursive tooth [R3.3-B.2]: THE OUTERMOST LOAD COMPLETED and it is the load that published — readiness is true now, the epoch text is the bound thirty-two lowercase hexadecimal digits, and the state it published is the one every later reader sees"
                  (and (eq :completed *rec-outer-result*)
                       (sa0-call 'sa0-identity-ready-p)
                       (= 32 (length (sa0-call 'sa0-epoch-hex)))))

     (probe-check "INIT-RECURSIVE-FIRST-ALLOCATION-IS-ONE"
                  "recursive tooth [R3.3-B.2]: THE FIRST ALLOCATION IS 1 — the stored counter initialized at 0 once, and neither the recursive load nor the deferred re-entry reset it or created a second one"
                  (eql 1 *rec-first-allocation*))

     (probe-check "INIT-RECURSIVE-LATER-RELOAD-PRESERVES-AND-CONTINUES"
                  "recursive tooth [R3.3-B.2]: and A LATER ORDINARY RELOAD PRESERVES EPOCH IDENTITY AND CONTINUES THE COUNTER — the epoch text is byte-identical across the reload, no epoch was re-gathered, and the next allocation is 2 rather than a restart at 1"
                  (and (stringp *rec-reload-epoch-before*)
                       (string= *rec-reload-epoch-before* *rec-reload-epoch-after*)
                       (eql 2 *rec-allocation-after-reload*))))
   (p "END-INIT-RECURSIVE-CLEAN")

   (rule)
   (p "CEILING, RESTATED WHERE THE NUMBERS ARE:")
   (p "  What is closed here is TRUE SAME-THREAD RE-ENTRY as R3.3-A defines it:")
   (p "  a recursive LOAD of this exact source, fired while the outer load's")
   (p "  initialization is still in progress and before ready publication.  It")
   (p "  is one re-entry at one depth, on this host, on SBCL 2.4.6, at this")
   (p "  parcel tip.  It is not a claim about arbitrary nesting depth and none")
   (p "  is made.")

   (when (plant-failure-requested-p)
     (probe-check "INIT-RECURSIVE-PLANTED-FAULT" "PLANTED FAULT: this check is designed to fail" nil))

   (probe-footer "INIT-RECURSIVE-LOAD")
   (probe-exit))

  ;; ------------------------------------------------------------------------
  ((string= *sa0-schedule-role* "post-election-failure")
   (probe-header "THE UNPROTECTED POST-ELECTION INTERVAL — a condition planted at the first instant after a won election, with a real waiter on the queue")

   (p "SCOPE, PRINTED BEFORE ANY NUMBER:")
   (p "  This image had never loaded probe-identity.lisp when the arm below")
   (p "  began.  The owner's R3.3 return names ONE interval: after the carrier")
   (p "  election succeeds and before the protective span begins.  Under the")
   (p "  returned code that interval held SA0-NOTE-ELECTION, and a condition in")
   (p "  it left carrier present, state absent, failure marker absent, observers")
   (p "  waiting forever.  Nothing below is a thread count and nothing below is")
   (p "  a timing loop: the condition is FIRED from inside the source's own")
   (p "  :ELECTED-BEFORE-NOTE phase, and it is fired only after a second loader")
   (p "  has PROVABLY parked on the cell's wait queue.  Every wait carries a")
   (p "  hard bound, so a hang is an OBSERVED FAILURE and never a silent pass.")
   (p "  What is demonstrated is a MECHANISM, not an Account /0 occurrence")
   (p "  identity, which does not exist.")
   (rule)
   (kv "role" *sa0-schedule-role*)
   (kv "hard bound (seconds)" *sa0-hard-bound-seconds*)
   (kv "expiry-arm bound (seconds)" *sa0-spin-exhibit-seconds*)
   (kv "candidate source" (file-namestring *sa0-identity-path*))
   (kv "candidate loaded before this arm"
       (if (fboundp 'sa0-carrier-cell) "YES — THE PRECONDITION IS BROKEN" "NO"))

   (rule)
   (p "INIT-PE-PLANTED-CONDITION  the planted condition, fired inside THE EXACT CANDIDATE SOURCE")
   (arm "PLANTED-CONDITION" "a condition signalled at :ELECTED-BEFORE-NOTE, with a concurrent loader parked on the cell's wait queue")

   (sa0-run-post-election-failure-arm)

   (let* ((cell *pe-cell-after*)
          (marker (and cell (sa0-call 'sa0-cell-failure cell)))
          (pre-initial-threads
            (remove-duplicates
             (mapcar #'first (remove-if-not (lambda (e) (eq (second e) :observed-pre-initial))
                                            *sa0-phase-log*))
             :test #'string=))
          (pre-initial-entries
            (remove-if-not (lambda (e) (eq (second e) :observed-pre-initial)) *sa0-phase-log*)))
     (sa0-print-phase-log)
     (kv "hook firings at elected" *pe-hook-firings*)
     (kv "hook thread at elected" (getf *pe-at-hook* :thread))
     (kv "at hook: carrier present" (if (getf *pe-at-hook* :carrier-present) "YES" "NO"))
     (kv "at hook: cell is mine" (if (getf *pe-at-hook* :cell-is-mine) "YES" "NO"))
     (kv "at hook: state present" (if (getf *pe-at-hook* :state) "YES" "NO"))
     (kv "at hook: ready-p" (getf *pe-at-hook* :ready))
     (kv "at hook: failure marker" (if (getf *pe-at-hook* :failure) "YES" "NO"))
     (kv "at hook: gatherings" (getf *pe-at-hook* :gatherings))
     (kv "at hook: elections noted" (getf *pe-at-hook* :elections))
     (kv "before-wait firings" *pe-before-wait-firings*)
     (kv "before-wait threads" (format nil "~{~A~^ ~}" *pe-before-wait-threads*))
     (kv "winner outcome" *pe-winner-outcome*)
     (kv "winner error" (or *pe-winner-error* "NONE"))
     (kv "winner join" *pe-winner-join*)
     (kv "observer outcome" *pe-observer-outcome*)
     (kv "observer error" (or *pe-observer-error* "NONE"))
     (kv "observer join" *pe-observer-join*)
     (kv "VOLATILE observer seconds" *pe-observer-seconds*)
     (kv "winner load notice" (sa0-first-line (or *pe-winner-noise* "NONE")))
     (kv "winner notice names source"
         (if (search (file-namestring *sa0-identity-path*) (or *pe-winner-noise* ""))
             "YES — and the rest of it is an absolute pathname, elided" "NO"))
     (kv "observer load notice" (sa0-first-line (or *pe-observer-noise* "NONE")))
     (kv "observer notice names source"
         (if (search (file-namestring *sa0-identity-path*) (or *pe-observer-noise* ""))
             "YES — and the rest of it is an absolute pathname, elided" "NO"))
     (kv "carrier present after" (if cell "YES" "NO"))
     (kv "failure marker after" (or marker "NONE"))
     (kv "state present after" (if (sa0-call 'sa0-published-state) "YES" "NO"))
     (kv "ready-p after" (sa0-call 'sa0-identity-ready-p))
     (kv "epoch gatherings this image" (sa0-call 'sa0-epoch-gatherings))
     (kv "elections won this image" (sa0-call 'sa0-election-count))
     (kv "same-thread retry outcome" *pe-retry-outcome*)
     (kv "same-thread retry error" (or *pe-retry-error* "NONE"))
     (kv "fresh-thread retry outcome" *pe-fresh-outcome*)
     (kv "fresh-thread retry error" (or *pe-fresh-error* "NONE"))
     (kv "fresh-thread join" *pe-fresh-join*)
     (kv "reader outcome" *pe-reader-outcome*)
     (kv "reader error" (or *pe-reader-error* "NONE"))

     (probe-check "INIT-PE-BOTH-LOADERS-ENTERED-PRE-INITIAL"
                  "post-election tooth [R3.3.1]: BOTH loaders really entered the candidate source's initialization and BOTH observed the pre-initial state — two distinct thread names, each reporting ready-p NIL at the gate — so what follows is a genuine two-party schedule and not one loader counted twice"
                  (and (= 2 (length pre-initial-threads))
                       (= 2 (length pre-initial-entries))
                       (every (lambda (e) (null (third e))) pre-initial-entries)))

     (probe-check "INIT-PE-CONDITION-FIRED-IN-THE-NAMED-INTERVAL"
                  "post-election tooth [R3.3.1]: the condition was fired in EXACTLY the interval the owner's return names, and the interval is exhibited rather than described — at the moment of firing the carrier ALREADY held the winner's own cell, and the election was NOT YET NOTED, NO epoch had been gathered, NO state existed and NO failure marker had been written.  The hook fired once, in the winning thread"
                  (and (= 1 *pe-hook-firings*)
                       (string= *pe-winner-name* (getf *pe-at-hook* :thread))
                       (getf *pe-at-hook* :carrier-present)
                       (getf *pe-at-hook* :cell-is-mine)
                       (null (getf *pe-at-hook* :state))
                       (null (getf *pe-at-hook* :ready))
                       (null (getf *pe-at-hook* :failure))
                       (= 0 (getf *pe-at-hook* :gatherings))
                       (= 0 (getf *pe-at-hook* :elections))))

     (probe-check "INIT-PE-WINNER-ESCAPED-WITH-THE-PLANTED-CONDITION"
                  "post-election tooth [R3.3.1]: the winning LOAD really failed — it did not complete, it escaped with THE PLANTED CONDITION and no other, and its thread was joined inside the hard bound.  An arm whose planted condition was swallowed somewhere would show :COMPLETED here and would prove nothing about failure at all"
                  (and (eq :errored *pe-winner-outcome*)
                       (stringp *pe-winner-error*)
                       (search *pe-planted-text* *pe-winner-error*)
                       (eq :done *pe-winner-join*)))

     (probe-check "INIT-PE-FAILURE-MARKER-PUBLISHED"
                  "post-election tooth [R3.3.1]: THE FAILURE MARKER IS PUBLISHED.  The cell the winner installed carries the definitive failure text, written by the cleanup of an unwind-protect that was established BEFORE the election was attempted — so the marker's existence does not depend on where in the post-election span the condition landed"
                  (and cell
                       (stringp marker)
                       (search "failed before publication" marker)))

     (probe-check "INIT-PE-NO-STATE-PUBLISHED"
                  "post-election tooth [R3.3.1]: and NOTHING ELSE was published — no state, no readiness, no epoch gathering, and no election even recorded.  This is clause 6 satisfied in both directions at once: the image published no half-state and no false ready.  A reader is refused rather than served a partial answer"
                  (and (null (sa0-call 'sa0-published-state))
                       (null (sa0-call 'sa0-identity-ready-p))
                       (= 0 (sa0-call 'sa0-epoch-gatherings))
                       (eq :errored *pe-reader-outcome*)))

     (probe-check "INIT-PE-OBSERVER-PARKED-ON-THE-QUEUE"
                  "post-election tooth [R3.3.1]: the observer was PROVABLY ASLEEP ON THE CELL'S WAIT QUEUE when the condition fired — the source's own :BEFORE-WAIT phase fired exactly once, in the observer thread, under the cell mutex, with state and failure re-checked absent, and the winner did not signal until that had happened.  This is what makes the arm the waiting-forever case and not a lucky ordering"
                  (and (= 1 *pe-before-wait-firings*)
                       (equal (list *pe-observer-name*) *pe-before-wait-threads*)))

     (probe-check "INIT-PE-OBSERVER-RELEASED-WITH-A-DEFINITIVE-FAILURE"
                  "post-election tooth [R3.3.1]: and THAT SLEEPER WAS WOKEN AND TOLD.  The observer returned by signalling the definitive failure — its error text carries the published marker — its thread joined inside the hard bound, and its whole life was shorter than that bound.  It did not hang, it did not time out, and it did not return a state"
                  (and (eq :errored *pe-observer-outcome*)
                       (stringp *pe-observer-error*)
                       (search "failed before publication" *pe-observer-error*)
                       (eq :done *pe-observer-join*)
                       (numberp *pe-observer-seconds*)
                       (< *pe-observer-seconds* *sa0-hard-bound-seconds*)))

     (probe-check "INIT-PE-FAILED-IMAGE-IS-TERMINAL"
                  "post-election tooth [R3.3.1]: THE DOCUMENTED POST-FAILURE LAW HOLDS, exercised rather than quoted — the source says a failed image is terminal, and it is.  A fresh attempt on the failing thread and a fresh attempt on a BRAND NEW thread both signal the same definitive failure, neither hangs, neither times out, and NEITHER ELECTS: the carrier still holds the same cell, no epoch was gathered and no election was recorded afterwards"
                  (and (eq :errored *pe-retry-outcome*)
                       (search "failed before publication" (or *pe-retry-error* ""))
                       (eq :errored *pe-fresh-outcome*)
                       (search "failed before publication" (or *pe-fresh-error* ""))
                       (eq :done *pe-fresh-join*)
                       (eq cell (sa0-call 'sa0-carrier-cell))
                       (= 0 (sa0-call 'sa0-epoch-gatherings))
                       (= 0 (sa0-call 'sa0-election-count)))))
   (p "END-INIT-PE-PLANTED-CONDITION")

   (rule)
   (p "INIT-PE-REPLICA  the same planted condition at the same point, against a REPLICA of the returned shape")
   (arm "REPLICA" "a captive replica of the returned control path: election CAS, then an UNPROTECTED step, then the helper that establishes the unwind-protect")

   (p "  WHAT THIS ARM CLAIMS, AND WHAT IT DOES NOT.  The returned source is not")
   (p "  in this tree, so this is a REPLICA OF ITS SHAPE written here, on captive")
   (p "  symbols, and it is labelled as one.  It does NOT prove what the returned")
   (p "  file contained — that is checkable in the parcel's own history.  It")
   (p "  proves the CONSEQUENCE of the shape: that an unprotected step between")
   (p "  the election and the protective span leaves a real sleeper on a real")
   (p "  queue with neither a state nor a failure marker to wake it.")

   (sa0-run-pe-replica-arm)

   (let* ((rcell *pe-replica-cell*)
          (ruled-cell *pe-cell-after*)
          (marker (and ruled-cell (sa0-call 'sa0-cell-failure ruled-cell))))
     (kv "replica joins" (format nil "~{~A~^ ~}" *pe-replica-joins*))
     (kv "replica winner outcome" *pe-replica-winner-outcome*)
     (kv "replica winner error" (or *pe-replica-winner-error* "NONE"))
     (kv "replica observer outcome" *pe-replica-observer-outcome*)
     (kv "VOLATILE replica seconds" *pe-replica-observer-seconds*)
     (kv "replica carrier installed" (if rcell "YES" "NO"))
     (kv "replica state present" (if (and rcell (svref rcell 4)) "YES" "NO"))
     (kv "replica failure marker" (if (and rcell (svref rcell 5)) "YES" "NO"))

     (probe-check "INIT-PE-REPLICA-LEAVES-NEITHER-STATE-NOR-FAILURE"
                  "post-election tooth replica [R3.3.1]: under the RETURNED SHAPE the identical planted condition, at the identical point, left the carrier INSTALLED and the cell EMPTY — no state and no failure marker.  That is the half-outcome clause 6 forbids, and it is the state of the world the returned code left behind"
                  (and rcell
                       (eq :errored *pe-replica-winner-outcome*)
                       (search *pe-planted-text* (or *pe-replica-winner-error* ""))
                       (null (svref rcell 4))
                       (null (svref rcell 5))))

     (probe-check "INIT-PE-REPLICA-OBSERVER-WAS-NEVER-WOKEN"
                  "post-election tooth replica [R3.3.1]: and the sleeper WAS NEVER WOKEN.  The replica observer signalled that it had reached the queue, waited out its whole bound and was released only by the expiry of that bound — never by a broadcast, because under this shape nothing ever broadcasts.  The bound is the length of the exhibition; the waiting is what has no bound"
                  (eq :never-woken *pe-replica-observer-outcome*))

     (probe-check "INIT-PE-DISCRIMINATES"
                  "post-election tooth [R3.3.1]: ONE PLANTED CONDITION, ONE POINT IN ONE SCHEDULE, TWO SHAPES, OPPOSITE OUTCOMES.  The repaired source published a definitive failure and woke its waiter inside the bound; the returned shape published nothing and left its waiter asleep until the clock ran out.  The tooth therefore discriminates, and a clean arm that could not fail is not the arm above"
                  (and (stringp marker)
                       (eq :errored *pe-observer-outcome*)
                       (eq :never-woken *pe-replica-observer-outcome*)
                       rcell
                       (null (svref rcell 5)))))
   (p "END-INIT-PE-REPLICA")

   (rule)
   (p "CEILING, RESTATED WHERE THE NUMBERS ARE:")
   (p "  What is closed here is ONE named interval — the instant after a won")
   (p "  election — against the exact candidate source, on this host, on SBCL")
   (p "  2.4.6, at this parcel tip.  It is not a proof that no condition")
   (p "  anywhere is mishandled, and no such proof is claimed.  The argument")
   (p "  that generalizes is the one in the source: the unwind-protect is")
   (p "  established BEFORE the election is attempted and its cleanup flag is")
   (p "  armed before the compare and disarmed only by proof of loss, so there")
   (p "  is no post-election instruction outside the protected span to plant a")
   (p "  condition in.")

   (when (plant-failure-requested-p)
     (probe-check "INIT-PE-PLANTED-FAULT" "PLANTED FAULT: this check is designed to fail" nil))

   (probe-footer "INIT-POST-ELECTION-FAILURE")
   (probe-exit))

  ;; ------------------------------------------------------------------------
  ((string= *sa0-schedule-role* "plist-foreign")
   (probe-header "THE CARRIER THAT ALREADY CARRIES SOMETHING — unrelated properties installed before the first load")

   (p "SCOPE, PRINTED BEFORE ANY NUMBER:")
   (p "  This image had never loaded probe-identity.lisp when the arm below")
   (p "  began.  Two unrelated properties are installed on the carrier symbol")
   (p "  FIRST, and only then is the source loaded.  Under the returned law that")
   (p "  load never returns: the election compared the WHOLE property list")
   (p "  against NIL, so a non-empty plist made the compare unsatisfiable and")
   (p "  the loop spun for the life of the image.  The load below therefore")
   (p "  carries a hard bound — an unbounded arm would hang this probe instead")
   (p "  of reporting the defect — and the planted arm exhibits the spin on a")
   (p "  captive symbol so that the ruled carrier is never spun on.")
   (rule)
   (kv "role" *sa0-schedule-role*)
   (kv "hard bound (seconds)" *sa0-hard-bound-seconds*)
   (kv "expiry-arm bound (seconds)" *sa0-spin-exhibit-seconds*)
   (kv "candidate source" (file-namestring *sa0-identity-path*))
   (kv "candidate loaded before this arm"
       (if (fboundp 'sa0-carrier-cell) "YES — THE PRECONDITION IS BROKEN" "NO"))

   (sa0-install-foreign-properties)
   (kv "unrelated property one" *foreign-first*)
   (kv "unrelated property two" *foreign-second*)
   (kv "carrier plist length before" (length *foreign-plist-before*))
   (kv "reserved indicator before" (if *foreign-reserved-before* "PRESENT" "ABSENT"))

   (rule)
   (p "INIT-FOREIGN-CLEAN  the first load, on a carrier that is not empty")
   (arm "CLEAN" "two unrelated properties present before the first load; the election must be total and must preserve them")

   (sa0-run-foreign-clean-arm)

   (let* ((plist-after (symbol-plist 'sa0-identity-carrier))
          (tail (and (consp plist-after) (consp (cdr plist-after)) (cddr plist-after))))
     (kv "load outcome" *foreign-load-outcome*)
     (kv "load error" (or *foreign-load-error* "NONE"))
     (kv "load join" *foreign-load-join*)
     (kv "ready-p after load" (sa0-call 'sa0-identity-ready-p))
     (kv "epoch gatherings this image" (sa0-call 'sa0-epoch-gatherings))
     (kv "elections won this image" (sa0-call 'sa0-election-count))
     (kv "VOLATILE image epoch" (sa0-call 'sa0-epoch-hex))
     (kv "epoch hex digits" (length (sa0-call 'sa0-epoch-hex)))
     (kv "carrier plist length after" (length plist-after))
     (kv "reserved indicator is first" (if (eq 'sa0-identity-cell (first plist-after)) "YES" "NO"))
     (kv "plist tail is the old plist" (if (eq tail *foreign-plist-before*) "YES" "NO"))
     (kv "unrelated one survives" (if (eq *foreign-first* (get 'sa0-identity-carrier 'sa0-unrelated-one)) "YES" "NO"))
     (kv "unrelated two survives" (if (eq *foreign-second* (get 'sa0-identity-carrier 'sa0-unrelated-two)) "YES" "NO"))
     (kv "allocations taken" (length *foreign-allocations*))

     (probe-check "INIT-FOREIGN-PRECONDITION-WAS-REAL"
                  "foreign-property tooth [R3.3.1]: the precondition was real and is printed rather than assumed — the candidate source had NEVER been loaded in this image, the carrier symbol carried TWO unrelated properties before the load, and it carried NO reserved indicator.  A tooth whose precondition failed would be testing an already-elected image"
                  (and (= 4 (length *foreign-plist-before*))
                       (null *foreign-reserved-before*)))

     (probe-check "INIT-FOREIGN-ELECTION-IS-TOTAL"
                  "foreign-property tooth [R3.3.1]: THE ELECTION SUCCEEDED ANYWAY.  The load returned inside the hard bound, exactly one election was won, exactly one epoch was gathered, and the image is ready with the bound thirty-two lowercase hexadecimal digits of epoch text.  Under the returned law this load could not have returned at all"
                  (and (eq :completed *foreign-load-outcome*)
                       (eq :done *foreign-load-join*)
                       (sa0-call 'sa0-identity-ready-p)
                       (= 1 (sa0-call 'sa0-election-count))
                       (= 1 (sa0-call 'sa0-epoch-gatherings))
                       (= 32 (length (sa0-call 'sa0-epoch-hex)))))

     (probe-check "INIT-FOREIGN-UNRELATED-PROPERTIES-SURVIVE-VERBATIM"
                  "foreign-property tooth [R3.3.1]: and BOTH UNRELATED PROPERTIES SURVIVED VERBATIM — not merely EQUAL values but the SAME OBJECTS by EQ, and not merely present but carried across UNTOUCHED: the plist after the election is the reserved indicator consed onto THE OLD PLIST OBJECT ITSELF, which is EQ to what was read before the load.  Two properties rather than one, because one cannot distinguish preserved from rebuilt"
                  (and (eq 'sa0-identity-cell (first plist-after))
                       (eq tail *foreign-plist-before*)
                       (eq *foreign-first* (get 'sa0-identity-carrier 'sa0-unrelated-one))
                       (eq *foreign-second* (get 'sa0-identity-carrier 'sa0-unrelated-two))))

     (probe-check "INIT-FOREIGN-ALLOCATIONS-CONTIGUOUS-FROM-ONE"
                  "foreign-property tooth [R3.3.1]: and the published state WORKS — twenty allocations taken by four threads after the election are exactly 1..20 with no gap and no repeat, which an image that never finished electing could not have produced at all"
                  (sa0-contiguous-from-1-p *foreign-allocations* 20)))
   (p "END-INIT-FOREIGN-CLEAN")

   (rule)
   (p "INIT-FOREIGN-PLANTED  the returned whole-plist-versus-NIL law, same precondition, captive symbol")
   (arm "PLANTED" "one thousand counted compares, and then the returned loop itself, run under a small bound whose expiry IS the finding")

   (sa0-run-foreign-planted-arm)

   (let ((captive-plist (symbol-plist 'sa0-r331-captive-carrier)))
     (kv "captive compares attempted" *foreign-captive-attempts*)
     (kv "captive compares succeeded" *foreign-captive-successes*)
     (kv "captive plist unchanged" (if (eq captive-plist *foreign-captive-plist-before*) "YES" "NO"))
     (kv "captive unrelated survives" (if (eq *foreign-captive-value* (get 'sa0-r331-captive-carrier 'sa0-captive-unrelated)) "YES" "NO"))
     (kv "spin outcome" *foreign-spin-outcome*)
     (kv "VOLATILE spin iterations" *foreign-spin-iterations*)
     (kv "spin join" *foreign-spin-join*)
     (kv "captive cell installed" (if (getf captive-plist 'sa0-identity-cell) "YES" "NO"))

     (probe-check "INIT-FOREIGN-PLANTED-COMPARE-CANNOT-SUCCEED"
                  "foreign-property tooth planted [R3.3.1]: the returned compare CANNOT SUCCEED, and that is an algebraic fact rather than a timing observation — one thousand compares of the whole property list against NIL were attempted against a symbol carrying one unrelated property, and ZERO succeeded.  The plist is EQ-unchanged afterwards: nothing was installed and nothing was disturbed"
                  (and (= 1000 *foreign-captive-attempts*)
                       (= 0 *foreign-captive-successes*)
                       (eq captive-plist *foreign-captive-plist-before*)))

     (probe-check "INIT-FOREIGN-PLANTED-LOOP-NEVER-TERMINATES"
                  "foreign-property tooth planted [R3.3.1]: and the RETURNED LOOP therefore NEVER TERMINATES — its only two exits are 'a cell is present' and 'the compare succeeded', and under this precondition neither can ever happen.  Executed, it was still spinning when its bound expired, having run far past a thousand iterations, with no cell installed and the unrelated property untouched.  The expiry is the exhibition; the spinning is what has no end"
                  (and (eq :never-terminated *foreign-spin-outcome*)
                       (> *foreign-spin-iterations* 1000)
                       (eq :done *foreign-spin-join*)
                       (null (getf captive-plist 'sa0-identity-cell))
                       (eq *foreign-captive-value* (get 'sa0-r331-captive-carrier 'sa0-captive-unrelated))))

     (probe-check "INIT-FOREIGN-DISCRIMINATES"
                  "foreign-property tooth [R3.3.1]: ONE PRECONDITION, TWO LAWS, OPPOSITE OUTCOMES.  Given a carrier that already carried an unrelated property, the repaired election finished, published, allocated 1..20 and preserved the property by identity; the returned election could not complete a single compare and was still spinning when its clock ran out.  The tooth therefore discriminates"
                  (and (eq :completed *foreign-load-outcome*)
                       (sa0-call 'sa0-identity-ready-p)
                       (eq :never-terminated *foreign-spin-outcome*)
                       (= 0 *foreign-captive-successes*))))
   (p "END-INIT-FOREIGN-PLANTED")

   (rule)
   (p "CEILING, RESTATED WHERE THE NUMBERS ARE:")
   (p "  What is closed here is the returned goblin: a carrier bearing unrelated")
   (p "  properties before the first load.  It is one precondition on this host,")
   (p "  on SBCL 2.4.6, at this parcel tip.  It is NOT a claim that the election")
   (p "  survives an agent that rewrites the carrier's property list without")
   (p "  end; the source states that ceiling where the loop is written, and no")
   (p "  arm here tests it.")

   (when (plant-failure-requested-p)
     (probe-check "INIT-FOREIGN-PLANTED-FAULT" "PLANTED FAULT: this check is designed to fail" nil))

   (probe-footer "INIT-PLIST-FOREIGN-PROPERTY")
   (probe-exit))

  ;; ------------------------------------------------------------------------
  ((string= *sa0-schedule-role* "plist-contention")
   (probe-header "THE PLIST THAT CHANGES BETWEEN THE READ AND THE COMPARE — the retry loop, pinned")

   (p "SCOPE, PRINTED BEFORE ANY NUMBER:")
   (p "  This image had never loaded probe-identity.lisp when the arm below")
   (p "  began, and the carrier symbol's property list was EMPTY — so the retry")
   (p "  exhibited here is caused by the planted change and by nothing else.")
   (p "  A hook fires in the exact window between the election's read of one")
   (p "  plist object and its compare against that same object, and changes the")
   (p "  plist there.  The pending compare MUST fail; the loop must re-read and")
   (p "  converge.  Nothing here is a thread count: one loader, one planted")
   (p "  change, a counted number of compares.")
   (rule)
   (kv "role" *sa0-schedule-role*)
   (kv "hard bound (seconds)" *sa0-hard-bound-seconds*)
   (kv "candidate source" (file-namestring *sa0-identity-path*))
   (kv "candidate loaded before this arm"
       (if (fboundp 'sa0-carrier-cell) "YES — THE PRECONDITION IS BROKEN" "NO"))

   (rule)
   (p "INIT-CONTENTION-CLEAN  the plist changed between the read and the compare")
   (arm "CLEAN" "the injection fires once, in the window; the retry loop must re-read and win")

   (sa0-run-contention-clean-arm)

   (let* ((plist-after (symbol-plist 'sa0-identity-carrier))
          (tail (and (consp plist-after) (consp (cdr plist-after)) (cddr plist-after))))
     (sa0-print-phase-log)
     (kv "carrier plist before load" (if (null *contention-plist-before*) "EMPTY" "NOT EMPTY"))
     (kv "compare attempts (gate firings)" *contention-gate-firings*)
     (kv "injection fired at attempt" *contention-injected-at-firing*)
     (kv "load outcome" *contention-load-outcome*)
     (kv "load error" (or *contention-load-error* "NONE"))
     (kv "load join" *contention-load-join*)
     (kv "ready-p after load" (sa0-call 'sa0-identity-ready-p))
     (kv "epoch gatherings this image" (sa0-call 'sa0-epoch-gatherings))
     (kv "elections won this image" (sa0-call 'sa0-election-count))
     (kv "VOLATILE image epoch" (sa0-call 'sa0-epoch-hex))
     (kv "carrier plist length after" (length plist-after))
     (kv "reserved indicator is first" (if (eq 'sa0-identity-cell (first plist-after)) "YES" "NO"))
     (kv "plist tail is the injected plist" (if (eq tail *contention-plist-after-injection*) "YES" "NO"))
     (kv "injected property survives" (if (eq *contention-injected* (get 'sa0-identity-carrier 'sa0-injected-mid-election)) "YES" "NO"))
     (kv "allocations taken" (length *contention-allocations*))

     (probe-check "INIT-CONTENTION-PRECONDITION-WAS-REAL"
                  "contention tooth [R3.3.1]: the precondition was real — the candidate source had never been loaded in this image and the carrier symbol's property list was EMPTY before the load, so every compare failure counted below is caused by the planted change and not by a property that was already sitting there"
                  (and (null *contention-plist-before*)
                       (eql 1 *contention-injected-at-firing*)))

     (probe-check "INIT-CONTENTION-COMPARE-FAILED-EXACTLY-ONCE"
                  "contention tooth [R3.3.1]: THE COMPARE REALLY FAILED, AND THE LOOP REALLY RETRIED.  The source's own pre-compare phase fired EXACTLY TWICE — it is called once immediately before each compare — so there were two attempts, and since only the second could have succeeded, exactly one compare was defeated by the change planted between the read and it.  A retry loop that never retried would show one firing"
                  (= 2 *contention-gate-firings*))

     (probe-check "INIT-CONTENTION-LOOP-CONVERGED"
                  "contention tooth [R3.3.1]: and the loop CONVERGED — the load returned inside the hard bound, exactly one election was won, exactly one epoch was gathered, the image is ready, and twenty allocations by four threads are exactly 1..20.  The retry did not elect twice and it did not gather twice"
                  (and (eq :completed *contention-load-outcome*)
                       (eq :done *contention-load-join*)
                       (sa0-call 'sa0-identity-ready-p)
                       (= 1 (sa0-call 'sa0-election-count))
                       (= 1 (sa0-call 'sa0-epoch-gatherings))
                       (sa0-contiguous-from-1-p *contention-allocations* 20)))

     (probe-check "INIT-CONTENTION-INJECTED-PROPERTY-SURVIVES-VERBATIM"
                  "contention tooth [R3.3.1]: and the property injected MID-ELECTION survived VERBATIM — the same object by EQ, and the winning plist is the reserved indicator consed onto the exact plist object the injection produced.  A retry that re-read the plist but then installed a plist of its own making would show a different tail here"
                  (and (eq 'sa0-identity-cell (first plist-after))
                       (eq tail *contention-plist-after-injection*)
                       (eq *contention-injected* (get 'sa0-identity-carrier 'sa0-injected-mid-election)))))
   (p "END-INIT-CONTENTION-CLEAN")

   (rule)
   (p "INIT-CONTENTION-PLANTED  a single-shot election meeting the same change")
   (arm "PLANTED" "one snapshot, one compare, no re-read — on a captive symbol")

   (sa0-run-contention-planted-arm)

   (kv "captive compare defeated" (if (null *contention-captive-prior*) "NO — the compare won" "YES — the prior differed"))
   (kv "captive cell installed" (if *contention-captive-installed* "YES" "NO"))
   (kv "captive injected survives" (if (eq *contention-captive-value* *contention-captive-survivor*) "YES" "NO"))

   (probe-check "INIT-CONTENTION-PLANTED-SINGLE-SHOT-LOSES"
                "contention tooth planted [R3.3.1]: WITHOUT THE RE-READ, THE SAME CHANGE IS FATAL.  A single-shot election — one snapshot, one compare, no loop — met the identical mid-election change: its compare found a plist that was no longer the one it had read, and it installed NOTHING.  The captive carrier ends with no cell at all, while the injected property sits there untouched.  This is what the retry loop is for, said as an outcome rather than as a rationale"
                (and (not (null *contention-captive-prior*))
                     (null *contention-captive-installed*)
                     (eq *contention-captive-value* *contention-captive-survivor*)))

   (probe-check "INIT-CONTENTION-DISCRIMINATES"
                "contention tooth [R3.3.1]: ONE PLANTED CHANGE, TWO ELECTIONS, OPPOSITE OUTCOMES.  With the re-read the election converged, published, allocated 1..20 and preserved the injected property; without it the election installed nothing.  The tooth therefore discriminates, and the retry loop above is doing work rather than decorating a compare that would have won anyway"
                (and (eq :completed *contention-load-outcome*)
                     (= 2 *contention-gate-firings*)
                     (sa0-call 'sa0-identity-ready-p)
                     (null *contention-captive-installed*)))

   (rule)
   (p "CEILING, RESTATED WHERE THE NUMBERS ARE:")
   (p "  What is closed here is ONE re-read: a single change landing in the")
   (p "  window between one read and one compare, on this host, on SBCL 2.4.6,")
   (p "  at this parcel tip.  It is not a claim about an unbounded stream of")
   (p "  changes, and the source does not make one either: it argues termination")
   (p "  against the writers it knows about and states the ceiling for the rest.")

   (when (plant-failure-requested-p)
     (probe-check "INIT-CONTENTION-PLANTED-FAULT" "PLANTED FAULT: this check is designed to fail" nil))

   (probe-footer "INIT-PLIST-CONTENTION")
   (probe-exit))

  ;; ------------------------------------------------------------------------
  ((string= *sa0-schedule-role* "publication-finality")
   (probe-header "THE INSTANT AFTER PUBLICATION — a condition planted between the state CAS and the return of the protected form, with a real waiter on the queue")

   (p "SCOPE, PRINTED BEFORE ANY NUMBER:")
   (p "  This image had never loaded probe-identity.lisp when the arm below")
   (p "  began.  The owner's R3.3.1 return names ONE interval: after the state")
   (p "  is published by CAS and before the cleanup runs.  Under the returned")
   (p "  code a condition there produced a cell carrying a complete state AND a")
   (p "  failure marker at once, and readers returned the state only because the")
   (p "  state branch was written first.  Nothing below is a thread count and")
   (p "  nothing below is a timing loop: the condition is FIRED from inside the")
   (p "  source's own :PUBLISHED-BEFORE-RETURN phase, and only after a second")
   (p "  loader has PROVABLY parked on the cell's wait queue.  Every wait carries")
   (p "  a hard bound, so a hang is an OBSERVED FAILURE and never a silent pass.")
   (p "  What is demonstrated is a MECHANISM, not an Account /0 occurrence")
   (p "  identity, which does not exist.")
   (rule)
   (kv "role" *sa0-schedule-role*)
   (kv "hard bound (seconds)" *sa0-hard-bound-seconds*)
   (kv "candidate source" (file-namestring *sa0-identity-path*))
   (kv "candidate loaded before this arm"
       (if (fboundp 'sa0-carrier-cell) "YES — THE PRECONDITION IS BROKEN" "NO"))

   (rule)
   (p "INIT-PF-PLANTED-CONDITION  the planted condition, fired inside THE EXACT CANDIDATE SOURCE")
   (arm "PLANTED-CONDITION" "a condition signalled at :PUBLISHED-BEFORE-RETURN, with a concurrent loader parked on the cell's wait queue")

   (sa0-run-publication-finality-arm)

   (let* ((cell *pf-cell-after*)
          (marker (and cell (sa0-call 'sa0-cell-failure cell)))
          (pre-initial-entries
            (remove-if-not (lambda (e) (eq (second e) :observed-pre-initial))
                           *sa0-phase-log*))
          (pre-initial-threads
            (remove-duplicates (mapcar #'first pre-initial-entries) :test #'string=)))
     (sa0-print-phase-log)
     (kv "hook firings at published" *pf-hook-firings*)
     (kv "hook thread at published" (getf *pf-at-hook* :thread))
     (kv "at hook: carrier present" (if (getf *pf-at-hook* :carrier-present) "YES" "NO"))
     (kv "at hook: cell is mine" (if (getf *pf-at-hook* :cell-is-mine) "YES" "NO"))
     (kv "at hook: state present" (if (getf *pf-at-hook* :state) "YES" "NO"))
     (kv "at hook: ready-p" (getf *pf-at-hook* :ready))
     (kv "at hook: failure marker" (if (getf *pf-at-hook* :failure) "YES" "NO"))
     (kv "at hook: gatherings" (getf *pf-at-hook* :gatherings))
     (kv "at hook: elections noted" (getf *pf-at-hook* :elections))
     (kv "before-wait firings" *pf-before-wait-firings*)
     (kv "before-wait threads" (format nil "~{~A~^ ~}" *pf-before-wait-threads*))
     (kv "winner outcome" *pf-winner-outcome*)
     (kv "winner error" (or *pf-winner-error* "NONE"))
     (kv "winner join" *pf-winner-join*)
     (kv "winner load notice" (sa0-first-line (or *pf-winner-noise* "NONE")))
     (kv "observer outcome" *pf-observer-outcome*)
     (kv "observer error" (or *pf-observer-error* "NONE"))
     (kv "observer join" *pf-observer-join*)
     (kv "VOLATILE observer seconds" *pf-observer-seconds*)
     (kv "observer saw the state" (if (and *pf-observer-state*
                                           (eq *pf-observer-state* *pf-state-after*))
                                      "YES — the same object by EQ" "NO"))
     (kv "carrier present after" (if cell "YES" "NO"))
     (kv "state present after" (if *pf-state-after* "YES" "NO"))
     (kv "failure marker after" (or marker "NONE"))
     (kv "ready-p after" (sa0-safe-read 'sa0-identity-ready-p))
     (kv "epoch gatherings this image" (sa0-safe-read 'sa0-epoch-gatherings))
     (kv "elections won this image" (sa0-safe-read 'sa0-election-count))
     (kv "same-thread retry outcome" *pf-retry-outcome*)
     (kv "same-thread retry error" (or *pf-retry-error* "NONE"))
     (kv "fresh-thread retry outcome" *pf-fresh-outcome*)
     (kv "fresh-thread retry error" (or *pf-fresh-error* "NONE"))
     (kv "fresh-thread join" *pf-fresh-join*)
     (kv "reader served the state" (if (and *pf-reader-state*
                                            (eq *pf-reader-state* *pf-state-after*))
                                       "YES — the same object by EQ" "NO"))
     (kv "reader error" (or *pf-reader-error* "NONE"))
     (kv "VOLATILE image epoch" (sa0-safe-read 'sa0-epoch-hex))
     (kv "allocations taken after" (length *pf-allocations*))

     (probe-check "INIT-PF-BOTH-LOADERS-ENTERED-PRE-INITIAL"
                  "publication-finality tooth [R3.3.2]: BOTH loaders really entered the candidate source's initialization and BOTH observed the pre-initial state — two distinct thread names, each reporting ready-p NIL at the gate — so what follows is a genuine two-party schedule and not one loader counted twice"
                  (and (= 2 (length pre-initial-threads))
                       (= 2 (length pre-initial-entries))
                       (every (lambda (e) (null (third e))) pre-initial-entries)))

     (probe-check "INIT-PF-CONDITION-FIRED-AFTER-PUBLICATION"
                  "publication-finality tooth [R3.3.2]: the condition was fired in EXACTLY the interval the owner's return names, and the interval is exhibited rather than described — at the moment of firing the state was ALREADY PUBLISHED and readable (ready-p T, one epoch gathered, one election noted, the carrier holding this caller's own cell), and the protected form had NOT yet returned, so the cleanup had not yet run.  The hook fired once, in the winning thread"
                  (and (= 1 *pf-hook-firings*)
                       (string= *pf-winner-name* (getf *pf-at-hook* :thread))
                       (getf *pf-at-hook* :carrier-present)
                       (getf *pf-at-hook* :cell-is-mine)
                       (getf *pf-at-hook* :state)
                       (eq t (getf *pf-at-hook* :ready))
                       (null (getf *pf-at-hook* :failure))
                       (= 1 (getf *pf-at-hook* :gatherings))
                       (= 1 (getf *pf-at-hook* :elections))))

     (probe-check "INIT-PF-WINNER-ESCAPED-WITH-THE-PLANTED-CONDITION"
                  "publication-finality tooth [R3.3.2]: the winning LOAD really failed — it did not complete, it escaped with THE PLANTED CONDITION and no other, and its thread was joined inside the hard bound.  An arm whose planted condition was swallowed somewhere would show :COMPLETED here and would prove nothing about the interval at all"
                  (and (eq :errored *pf-winner-outcome*)
                       (stringp *pf-winner-error*)
                       (search *pf-planted-text* *pf-winner-error*)
                       (eq :done *pf-winner-join*)))

     (probe-check "INIT-PF-STATE-PUBLISHED-AND-NO-FAILURE-MARKER"
                  "publication-finality tooth [R3.3.2]: THE FORKED TONGUE IS GONE — this is the repair, measured.  The image carries a complete published state and NO FAILURE MARKER WHATEVER, although the cleanup ran with its claim flag armed and offered one.  It could not land: the failure token is CAS-ed from NIL into THE SAME SLOT the state occupies, so publication and the confession of non-publication are mutually exclusive by construction rather than by the order two branches are written in"
                  (and cell
                       *pf-state-after*
                       (null marker)
                       (eq t (sa0-call 'sa0-identity-ready-p))))

     (probe-check "INIT-PF-OBSERVER-PARKED-ON-THE-QUEUE"
                  "publication-finality tooth [R3.3.2]: the observer was PROVABLY ASLEEP ON THE CELL'S WAIT QUEUE before the state was published — the source's own :BEFORE-WAIT phase fired exactly once, in the observer thread, under the cell mutex, with state and failure re-checked absent, and the winner did not proceed to gather until that had happened.  So there is a real sleeper to be released, and releasing it is not a lucky ordering"
                  (and (= 1 *pf-before-wait-firings*)
                       (equal (list *pf-observer-name*) *pf-before-wait-threads*)))

     (probe-check "INIT-PF-OBSERVER-WOKEN-WITH-THE-STATE"
                  "publication-finality tooth [R3.3.2]: and THAT SLEEPER WAS WOKEN AND SERVED THE STATE — not a failure.  The observer's load COMPLETED, it observed the very state object the winner published (the same object by EQ, not merely an equal epoch text), its thread joined inside the hard bound and its whole life was shorter than that bound.  Under the returned shape this observer was woken by a cleanup that had just written a failure marker over a published state"
                  (and (eq :completed *pf-observer-outcome*)
                       (null *pf-observer-error*)
                       *pf-observer-state*
                       (eq *pf-observer-state* *pf-state-after*)
                       (eq :done *pf-observer-join*)
                       (numberp *pf-observer-seconds*)
                       (< *pf-observer-seconds* *sa0-hard-bound-seconds*)))

     (probe-check "INIT-PF-RETRY-OBSERVES-AND-READER-IS-SERVED"
                  "publication-finality tooth [R3.3.2]: a RETRY OBSERVES and a READER IS SERVED, on the failing thread and on a brand new thread alike — each returns :OBSERVED, neither elects, neither hangs, neither times out, and the reader is handed the same state object by EQ.  These are the two lines the owner's evidence block records, and they now say what they mean: the image succeeded, and there is no second record of it having failed"
                  (and (eq :observed *pf-retry-outcome*)
                       (null *pf-retry-error*)
                       (eq :observed *pf-fresh-outcome*)
                       (null *pf-fresh-error*)
                       (eq :done *pf-fresh-join*)
                       *pf-reader-state*
                       (eq *pf-reader-state* *pf-state-after*)
                       (null *pf-reader-error*)))

     (probe-check "INIT-PF-ONE-ELECTION-ONE-GATHERING-AND-THE-STATE-WORKS"
                  "publication-finality tooth [R3.3.2]: EXACTLY ONE election was won and EXACTLY ONE epoch was gathered across the whole schedule, and the published state WORKS — twenty allocations taken by four threads afterwards are exactly 1..20 with no gap and no repeat.  A condition raised after publication cost the image nothing except the loading thread"
                  (and (= 1 (sa0-call 'sa0-election-count))
                       (= 1 (sa0-call 'sa0-epoch-gatherings))
                       (sa0-contiguous-from-1-p *pf-allocations* 20))))
   (p "END-INIT-PF-PLANTED-CONDITION")

   (rule)
   (p "INIT-PF-REPLICA  the same planted condition at the same point, against a REPLICA of the returned shape")
   (arm "REPLICA" "a captive replica of the returned control path: publish by CAS, then a SEPARATE local flag, and a cleanup that decides from the flag")

   (p "  WHAT THIS ARM CLAIMS, AND WHAT IT DOES NOT.  The returned source is not")
   (p "  in this tree, so this is a REPLICA OF ITS SHAPE written here, on a")
   (p "  captive cell, and it is labelled as one.  It does NOT prove what the")
   (p "  returned file contained — that is checkable in the parcel's own")
   (p "  history.  It proves the CONSEQUENCE of the shape.  It needs no threads:")
   (p "  the forked tongue is not a race.  One condition, in the one interval,")
   (p "  produces a cell that carries a state AND a failure, and two honest")
   (p "  readers of that one cell then return OPPOSITE answers depending only on")
   (p "  which test they perform first.")

   (sa0-run-pf-replica-arm)

   (let ((rcell *pf-replica-cell*)
         (ruled *pf-cell-after*))
     (kv "replica outcome" *pf-replica-outcome*)
     (kv "replica error" (or *pf-replica-error* "NONE"))
     (kv "replica state present" (if (and rcell (svref rcell 4)) "YES" "NO"))
     (kv "replica failure present" (if (and rcell (svref rcell 5)) "YES" "NO"))
     (kv "replica reader state-first" *pf-replica-state-first*)
     (kv "replica reader failure-first" *pf-replica-failure-first*)
     (kv "ruled reader state-first" *pf-ruled-state-first*)
     (kv "ruled reader failure-first" *pf-ruled-failure-first*)

     (probe-check "INIT-PF-REPLICA-PUBLISHES-A-STATE-AND-A-FAILURE-AT-ONCE"
                  "publication-finality tooth replica [R3.3.2]: under the RETURNED SHAPE the identical planted condition, at the identical point, left the cell carrying BOTH — a complete publication in the state slot AND a definitive 'initialization failed before publication' marker beside it.  That is the owner's FINDING 1 as a state of the world: one cell asserting a publication and its own impossibility"
                  (and rcell
                       (eq :errored *pf-replica-outcome*)
                       (search *pf-planted-text* (or *pf-replica-error* ""))
                       (svref rcell 4)
                       (svref rcell 5)))

     (probe-check "INIT-PF-REPLICA-READERS-DISAGREE-BY-BRANCH-ORDER"
                  "publication-finality tooth replica [R3.3.2]: and TWO HONEST READERS OF THAT ONE CELL RETURN OPPOSITE ANSWERS.  Reading the state first returns the state; reading the failure first signals the failure.  Neither reader is wrong about anything it checked — the cell really does carry both — so under the returned shape 'the image succeeded' was a property of the READER, not of the image"
                  (and (eq :state-returned *pf-replica-state-first*)
                       (eq :failure-signalled *pf-replica-failure-first*)))

     (probe-check "INIT-PF-DISCRIMINATES"
                  "publication-finality tooth [R3.3.2]: ONE PLANTED CONDITION, ONE POINT IN ONE SCHEDULE, TWO SHAPES, OPPOSITE OUTCOMES.  Against the REPAIRED source the two branch orders AGREE — both return the state, because there is only one slot to read and it holds a state — and the parked observer was served that state; against the returned shape they disagree, and the cell carries a failure marker over a published state.  The tooth therefore discriminates, and a clean arm that could not fail is not the arm above"
                  (and (eq :state-returned *pf-ruled-state-first*)
                       (eq :state-returned *pf-ruled-failure-first*)
                       (eq :state-returned *pf-replica-state-first*)
                       (eq :failure-signalled *pf-replica-failure-first*)
                       ruled
                       (null (sa0-call 'sa0-cell-failure ruled)))))
   (p "END-INIT-PF-REPLICA")

   (rule)
   (p "CEILING, RESTATED WHERE THE NUMBERS ARE:")
   (p "  What is closed here is ONE named interval — the instant after the state")
   (p "  CAS succeeded — against the exact candidate source, on this host, on")
   (p "  SBCL 2.4.6, at this parcel tip.  It is not a proof that no condition")
   (p "  anywhere is mishandled, and no such proof is claimed.  The argument")
   (p "  that generalizes is the one in the source: there is no second record of")
   (p "  the publication to lag behind it, because the state and the failure")
   (p "  token are CAS-ed from NIL into ONE slot, so at most one of them can")
   (p "  ever land.")

   (when (plant-failure-requested-p)
     (probe-check "INIT-PF-PLANTED-FAULT" "PLANTED FAULT: this check is designed to fail" nil))

   (probe-footer "INIT-PUBLICATION-FINALITY")
   (probe-exit))

  ;; ------------------------------------------------------------------------
  ((string= *sa0-schedule-role* "carrier-slot")
   (probe-header "PRESENCE VERSUS VALUE IN THE RESERVED SLOT — a reserved indicator carrying NIL, carrying two claims, carrying a foreign value, and carrying nothing at all")

   (p "SCOPE, PRINTED BEFORE ANY NUMBER:")
   (p "  This image had never loaded probe-identity.lisp when the arms below")
   (p "  began.  Nothing here is a schedule and no test-only hook is installed:")
   (p "  each arm plants ONE exact carrier state and performs ONE load, and the")
   (p "  outcome is a property of the source's own adjudication rather than of")
   (p "  any interleaving.  FOUR ARMS SHARE THIS IMAGE, and the reason is")
   (p "  printed rather than assumed: a REJECTED load spends nothing — it")
   (p "  refuses before any election is attempted, so it installs no cell, notes")
   (p "  no election and gathers no epoch.  The image-wide election count is")
   (p "  therefore printed before the lawful arm, which runs LAST and is the")
   (p "  only arm that spends the one moment a first initialization needs.")
   (p "  Every load carries a hard bound, because an arm whose claim is")
   (p "  'refused IMMEDIATELY' must be able to observe a hang instead.")
   (rule)
   (kv "role" *sa0-schedule-role*)
   (kv "hard bound (seconds)" *sa0-hard-bound-seconds*)
   (kv "candidate source" (file-namestring *sa0-identity-path*))
   (kv "candidate loaded before this arm"
       (if (fboundp 'sa0-carrier-cell) "YES — THE PRECONDITION IS BROKEN" "NO"))
   (kv "refusal text asserted on" *cs-rejection-mark*)

   (rule)
   (p "INIT-CS-CLEAN  four planted carriers, four loads, against THE EXACT CANDIDATE SOURCE")
   (arm "CLEAN" "a reserved NIL value, duplicate reserved entries, a foreign reserved value, a malformed property list, and finally one lawful cell")

   (sa0-run-carrier-slot-arms)

   (let ((lawful-cell (sa0-call 'sa0-carrier-cell)))
     (kv "test-only gate hook" "NEVER INSTALLED — no arm here is a schedule")
     (kv "gate calls recorded" (length *sa0-phase-log*))
     (kv "arm 1 planted" "(SA0-IDENTITY-CELL NIL)")
     (kv "arm 1 reserved count before" *cs-nil-count-before*)
     (kv "arm 1 GETF with NIL default" *cs-nil-getf-said*)
     (kv "arm 1 load outcome" (getf *cs-arm-nil* :outcome))
     (kv "arm 1 load join" (getf *cs-arm-nil* :join))
     (kv "arm 1 refusal" (or (getf *cs-arm-nil* :error) "NONE"))
     (kv "arm 1 load notice" (getf *cs-arm-nil* :notice))
     (kv "VOLATILE arm 1 seconds" (getf *cs-arm-nil* :seconds))
     (kv "arm 1 reserved count after" *cs-nil-count-after*)
     (kv "arm 1 plist after" (format nil "~S" *cs-nil-plist-after*))
     (kv "arm 2 planted" "two reserved entries")
     (kv "arm 2 load outcome" (getf *cs-arm-duplicate* :outcome))
     (kv "arm 2 refusal" (or (getf *cs-arm-duplicate* :error) "NONE"))
     (kv "VOLATILE arm 2 seconds" (getf *cs-arm-duplicate* :seconds))
     (kv "arm 2 reserved count after" *cs-duplicate-count-after*)
     (kv "arm 3 planted" "an unrelated property and a reserved value that is not a cell")
     (kv "arm 3 load outcome" (getf *cs-arm-malformed-value* :outcome))
     (kv "arm 3 refusal" (or (getf *cs-arm-malformed-value* :error) "NONE"))
     (kv "VOLATILE arm 3 seconds" (getf *cs-arm-malformed-value* :seconds))
     (kv "arm 3 reserved count after" *cs-malformed-count-after*)
     (kv "arm 4 planted" "a property list ending in an indicator with no value")
     (kv "arm 4 load outcome" (getf *cs-arm-malformed-plist* :outcome))
     (kv "arm 4 refusal" (or (getf *cs-arm-malformed-plist* :error) "NONE"))
     (kv "VOLATILE arm 4 seconds" (getf *cs-arm-malformed-plist* :seconds))
     (kv "elections before the lawful arm" *cs-elections-before-lawful*)
     (kv "arm 5 planted" "an empty carrier")
     (kv "arm 5 load outcome" (getf *cs-arm-lawful* :outcome))
     (kv "arm 5 load join" (getf *cs-arm-lawful* :join))
     (kv "arm 5 refusal" (or (getf *cs-arm-lawful* :error) "NONE"))
     (kv "arm 5 reserved count after" *cs-lawful-count-after*)
     (kv "arm 5 install returned the cell" (if (and lawful-cell
                                                   (eq lawful-cell *cs-lawful-install-cell*))
                                               "YES — the same object by EQ" "NO"))
     (kv "arm 5 install claimed a win" (if *cs-lawful-install-won* "YES" "NO"))
     (kv "ready-p after the lawful arm" (sa0-safe-read 'sa0-identity-ready-p))
     (kv "epoch gatherings this image" (sa0-safe-read 'sa0-epoch-gatherings))
     (kv "elections won this image" (sa0-safe-read 'sa0-election-count))
     (kv "VOLATILE image epoch" (sa0-safe-read 'sa0-epoch-hex))
     (kv "allocations taken" (length *cs-lawful-allocations*))

     (probe-check "INIT-CS-NIL-PRECONDITION-WAS-REAL"
                  "carrier-slot tooth [R3.3.2]: the precondition is the ruling's own and it is EXHIBITED rather than assumed — the candidate source had never been loaded in this image, the carrier symbol carried EXACTLY ONE reserved indicator, and the returned predicate (GETF against a NIL default), run here by the harness against that exact plist, answered ABSENT.  So the confusion the repair is about is a fact of this run and not a description of one"
                  (and (= 1 *cs-nil-count-before*)
                       (eq :absent *cs-nil-getf-said*)))

     (probe-check "INIT-CS-NIL-VALUE-REJECTED-AND-NOTHING-PREPENDED"
                  "carrier-slot tooth [R3.3.2]: THE NIL-VALUED INDICATOR IS REFUSED IMMEDIATELY AND NOTHING IS PREPENDED — the load escaped with the source's own definitive refusal, well inside the hard bound, and the carrier's property list is EXACTLY as it was planted: still ONE reserved indicator, not two.  Under the returned law this load completed and left a second indicator in front of the first"
                  (and (sa0-cs-rejected-p *cs-arm-nil*)
                       (= 1 *cs-nil-count-after*)
                       (equal '(sa0-identity-cell nil) *cs-nil-plist-after*)))

     (probe-check "INIT-CS-DUPLICATE-REJECTED"
                  "carrier-slot tooth [R3.3.2]: TWO RESERVED ENTRIES ARE REFUSED, bounded and definitively, and neither is chosen over the other.  A mechanism that picked the first would be electing on a carrier whose meaning it cannot establish; the count is still two afterwards, because refusing is not repairing and this source does not rewrite a claim it did not make"
                  (and (sa0-cs-rejected-p *cs-arm-duplicate*)
                       (= 2 *cs-duplicate-count-after*)))

     (probe-check "INIT-CS-MALFORMED-VALUE-REJECTED"
                  "carrier-slot tooth [R3.3.2]: A RESERVED VALUE THAT IS NOT A CELL IS REFUSED, bounded and definitively — the refusal is about the one slot this mechanism owns.  The reserved count is still one afterwards: nothing was replaced.  (This check asserts the rejection and the count; the unrelated-property-preservation guarantee is the foreign-property arm's, not this one's)"
                  (and (sa0-cs-rejected-p *cs-arm-malformed-value*)
                       (= 1 *cs-malformed-count-after*)))

     (probe-check "INIT-CS-MALFORMED-PLIST-REJECTED"
                  "carrier-slot tooth [R3.3.2]: AND A PROPERTY LIST THAT IS NOT ONE IS REFUSED TOO — a list ending in an indicator with no value cannot be read as a property list at all, so the walk refuses rather than interpreting whatever GETF happens to do with it.  This is the fourth face of the same law and it is shown biting rather than trusted"
                  (sa0-cs-rejected-p *cs-arm-malformed-plist*))

     (probe-check "INIT-CS-LAWFUL-SINGLE-CELL-PROCEEDS-AS-OBSERVER"
                  "carrier-slot tooth [R3.3.2]: and EXACTLY ONE LAWFUL CELL STILL PROCEEDS — the ordinary path is re-asserted, not merely left alone.  On an empty carrier the load completed, exactly one election was won and one epoch gathered in an image where the four refused arms had won none, the reserved count is ONE, and a direct election attempt against the installed cell returned THAT CELL by EQ while claiming NO win.  Twenty allocations by four threads are exactly 1..20"
                  (and (eq :completed (getf *cs-arm-lawful* :outcome))
                       (eq :done (getf *cs-arm-lawful* :join))
                       (eql 0 *cs-elections-before-lawful*)
                       (= 1 *cs-lawful-count-after*)
                       lawful-cell
                       (eq lawful-cell *cs-lawful-install-cell*)
                       (null *cs-lawful-install-won*)
                       (= 1 (sa0-call 'sa0-election-count))
                       (= 1 (sa0-call 'sa0-epoch-gatherings))
                       (sa0-contiguous-from-1-p *cs-lawful-allocations* 20))))
   (p "END-INIT-CS-CLEAN")

   (rule)
   (p "INIT-CS-REPLICA  the returned GETF-then-CAS law, same precondition, captive symbol")
   (arm "REPLICA" "presence tested with GETF against a NIL default, then the returned compare — on a captive symbol, so the ruled carrier is never touched by it")

   (p "  WHAT THIS ARM CLAIMS, AND WHAT IT DOES NOT.  It is the returned")
   (p "  predicate and the returned compare in their returned shape, meeting the")
   (p "  ruling's own precondition.  It does NOT prove what the returned file")
   (p "  contained — that is checkable in the parcel's own history.  It proves")
   (p "  the CONSEQUENCE: that this predicate, on this precondition, silently")
   (p "  prepends a second reserved indicator.")

   (sa0-run-cs-replica-arm)

   (let ((after (symbol-plist 'sa0-r332-captive-carrier)))
     (kv "captive plist planted" (format nil "~S" *cs-replica-before*))
     (kv "captive reserved count before" *cs-replica-count-before*)
     (kv "captive GETF with NIL default" *cs-replica-getf-said*)
     (kv "captive reserved count after" *cs-replica-count-after*)
     (kv "captive first reserved is the new cell" (if *cs-replica-first-is-new-cell* "YES" "NO"))
     (kv "captive old plist is the tail" (if *cs-replica-tail-is-old-plist* "YES" "NO"))
     (kv "captive plist length after" (length after))

     (probe-check "INIT-CS-REPLICA-SILENTLY-PREPENDS-A-SECOND-INDICATOR"
                  "carrier-slot tooth replica [R3.3.2]: under the RETURNED LAW the identical precondition produces the ruling's own evidence block — the GETF answered ABSENT, the compare succeeded, and the captive carrier now holds TWO reserved indicators with the new cell in front and the pre-existing NIL entry still behind it as the tail.  The claim that the reserved indicator makes exactly one absent-to-present transition is false of this plist, and nothing signalled to say so"
                  (and (= 1 *cs-replica-count-before*)
                       (eq :absent *cs-replica-getf-said*)
                       (= 2 *cs-replica-count-after*)
                       *cs-replica-first-is-new-cell*
                       *cs-replica-tail-is-old-plist*))

     (probe-check "INIT-CS-DISCRIMINATES"
                  "carrier-slot tooth [R3.3.2]: ONE PRECONDITION, TWO LAWS, OPPOSITE OUTCOMES.  Given a carrier already carrying the reserved indicator with a NIL value, the repaired source REFUSED — bounded, definitive, one indicator still there and no election held — while the returned law completed silently and left two indicators behind.  The tooth therefore discriminates"
                  (and (sa0-cs-rejected-p *cs-arm-nil*)
                       (= 1 *cs-nil-count-after*)
                       (= 2 *cs-replica-count-after*))))
   (p "END-INIT-CS-REPLICA")

   (rule)
   (p "CEILING, RESTATED WHERE THE NUMBERS ARE:")
   (p "  What is closed here is the reserved slot's own validity: presence is")
   (p "  counted rather than inferred from a value, and four unlawful states of")
   (p "  that one slot are refused rather than used.  It is four preconditions")
   (p "  on this host, on SBCL 2.4.6, at this parcel tip.  It is NOT a claim")
   (p "  that the election survives an agent that rewrites the carrier's")
   (p "  property list without end; the source states that ceiling where the")
   (p "  loop is written, and no arm here tests it.  Nor is refusal a repair:")
   (p "  an unlawful carrier is left exactly as it was found.")

   (when (plant-failure-requested-p)
     (probe-check "INIT-CS-PLANTED-FAULT" "PLANTED FAULT: this check is designed to fail" nil))

   (probe-footer "INIT-CARRIER-SLOT")
   (probe-exit))

  ;; ------------------------------------------------------------------------
  ((string= *sa0-schedule-role* "carrier-total")
   (probe-header "THE MALFORMED-CARRIER TOTALITY CLOSURE — an improper carrier, an improper carrier carrying a lawful cell, and a circular carrier")

   (p "SCOPE, PRINTED BEFORE ANY NUMBER:")
   (p "  This image had never loaded probe-identity.lisp when the arms below")
   (p "  began.  Nothing here is a schedule and no test-only hook is installed:")
   (p "  each arm plants ONE exact carrier state and performs ONE load, and the")
   (p "  outcome is a property of the source's own walk rather than of any")
   (p "  interleaving.  THREE ARMS SHARE THIS IMAGE and NONE of them is a")
   (p "  lawful arm: every load here is REFUSED, and a refused load spends")
   (p "  nothing — it refuses inside the scan, before any election is")
   (p "  attempted.  That is not assumed: after the three arms the carrier is")
   (p "  restored to empty and the image-wide election and gathering counts are")
   (p "  read back through the source's own readers, and both are printed.")
   (p "  Every load carries the hard bound, because an arm whose claim is")
   (p "  'refused DEFINITIVELY AND BOUNDED' must be able to observe a hang")
   (p "  instead — and against the circular plant that is exactly the failure")
   (p "  the returned law produced.  SO DO THE READERS: the election,")
   (p "  gathering and readiness lines below are asked in bounded threads and")
   (p "  can report HUNG, because they are asked with the malformed carrier")
   (p "  STILL INSTALLED, and under the returned law a reader of a circular")
   (p "  carrier never comes back.  A harness that asked them directly would")
   (p "  not report that failure — it would become it.")
   (rule)
   (kv "role" *sa0-schedule-role*)
   (kv "hard bound (seconds)" *sa0-hard-bound-seconds*)
   (kv "exhibit bound (seconds)" *sa0-spin-exhibit-seconds*)
   (kv "candidate source" (file-namestring *sa0-identity-path*))
   (kv "candidate loaded before this arm"
       (if (fboundp 'sa0-carrier-cell) "YES — THE PRECONDITION IS BROKEN" "NO"))
   (kv "refusal text asserted on" *cs-rejection-mark*)

   (rule)
   (p "INIT-CT-CLEAN  three planted carriers, three loads, against THE EXACT CANDIDATE SOURCE")
   (arm "CLEAN" "an improper (dotted) property list, an improper property list carrying one otherwise-lawful reserved cell, and a circular property list")

   (sa0-run-carrier-total-arms)

   (kv "test-only gate hook" "NEVER INSTALLED — no arm here is a schedule")
   (kv "gate calls recorded" (length *sa0-phase-log*))

   (kv "arm 1 planted" "(SA0-UNRELATED-PROPERTY :KEPT . SA0-R333-DOTTED-TAIL)")
   (kv "arm 1 SYMBOL-PLIST returned the same object" (if *ct-dotted-eq-on-plant* "YES" "NO"))
   (kv "arm 1 harness walk shape" *ct-dotted-shape*)
   (kv "arm 1 harness reserved count before" *ct-dotted-count-before*)
   (kv "arm 1 load outcome" (getf *ct-arm-dotted* :outcome))
   (kv "arm 1 load join" (getf *ct-arm-dotted* :join))
   (kv "arm 1 refusal" (or (getf *ct-arm-dotted* :error) "NONE"))
   (kv "arm 1 load notice" (getf *ct-arm-dotted* :notice))
   (kv "VOLATILE arm 1 seconds" (getf *ct-arm-dotted* :seconds))
   (kv "arm 1 plist unchanged by identity" (if *ct-dotted-unchanged* "YES" "NO"))
   (kv "arm 1 elections after" *ct-dotted-elections*)
   (kv "arm 1 readiness after" *ct-dotted-ready*)
   (kv "arm 1 gatherings after" *ct-dotted-gatherings*)

   (kv "arm 2 planted" "(SA0-IDENTITY-CELL <lawful-cell> SA0-UNRELATED-PROPERTY :KEPT . SA0-R333-DOTTED-TAIL)")
   (kv "arm 2 cell is lawful by the source's own predicate" (if *ct-cell-lawful-p* "YES" "NO"))
   (kv "arm 2 harness walk shape" *ct-cellular-shape*)
   (kv "arm 2 harness reserved count before" *ct-cellular-count-before*)
   (kv "arm 2 load outcome" (getf *ct-arm-dotted-cell* :outcome))
   (kv "arm 2 load join" (getf *ct-arm-dotted-cell* :join))
   (kv "arm 2 refusal" (or (getf *ct-arm-dotted-cell* :error) "NONE"))
   (kv "VOLATILE arm 2 seconds" (getf *ct-arm-dotted-cell* :seconds))
   (kv "arm 2 plist unchanged by identity" (if *ct-cellular-unchanged* "YES" "NO"))
   (kv "arm 2 elections after" *ct-cellular-elections*)
   (kv "arm 2 readiness after" *ct-cellular-ready*)

   (kv "arm 3 planted" *ct-circular-printed*)
   (kv "arm 3 SYMBOL-PLIST returned the same object" (if *ct-circular-eq-on-plant* "YES" "NO"))
   (kv "arm 3 harness walk shape" *ct-circular-shape*)
   (kv "arm 3 harness reserved count before" *ct-circular-count-before*)
   (kv "arm 3 harness pairs before the ring closed" *ct-circular-pairs*)
   (kv "arm 3 load outcome" (getf *ct-arm-circular* :outcome))
   (kv "arm 3 load join" (getf *ct-arm-circular* :join))
   (kv "arm 3 refusal" (or (getf *ct-arm-circular* :error) "NONE"))
   (kv "VOLATILE arm 3 seconds" (getf *ct-arm-circular* :seconds))
   (kv "arm 3 ring unchanged by identity" (if *ct-circular-unchanged* "YES" "NO"))
   (kv "arm 3 elections after" *ct-circular-elections*)
   (kv "arm 3 readiness after" *ct-circular-ready*)

   (kv "elections in this image after all three arms" *ct-final-elections*)
   (kv "gatherings in this image after all three arms" *ct-final-gatherings*)

   (probe-check "INIT-CT-DOTTED-PRECONDITION-WAS-REAL"
                "carrier-totality tooth [R3.3.3]: the precondition is the ruling's own and it is EXHIBITED rather than assumed — exact SBCL 2.4.6 accepted an IMPROPER property list into the ruled carrier symbol's SYMBOL-PLIST and handed back THE SAME OBJECT by EQ, the harness's own total walk classifies it as a DOTTED TAIL carrying ZERO reserved indicators, and the candidate source had never been loaded in this image.  This is the shape the returned walk read as an empty, lawful carrier"
                (and *ct-dotted-eq-on-plant*
                     (eq :dotted-tail *ct-dotted-shape*)
                     (eql 0 *ct-dotted-count-before*)))

   (probe-check "INIT-CT-DOTTED-REJECTED-AND-PLIST-UNCHANGED"
                "carrier-totality tooth [R3.3.3]: THE IMPROPER CARRIER IS REFUSED DEFINITIVELY AND WITHIN THE BOUND, AND NOTHING IS TOUCHED — the load escaped with the source's own refusal text well inside the hard bound and its thread joined, no election was held, no epoch was gathered, and no reader could obtain a readiness answer at all (the reader REFUSES, which is stronger than answering 'not ready').  The planted list is EXACTLY as it was planted, compared by IDENTITY: the same head cons, the same spine conses in the same order, the same CAR in each, and the same non-NIL terminal atom.  Refusing is not repairing — nothing was truncated at the malformation, completed, or re-ordered"
                (and (sa0-cs-rejected-p *ct-arm-dotted*)
                     *ct-dotted-unchanged*
                     (eql 0 *ct-dotted-elections*)
                     (eq :refused *ct-dotted-ready*)
                     (eq :refused *ct-dotted-gatherings*)))

   (probe-check "INIT-CT-DOTTED-WITH-LAWFUL-CELL-REJECTED"
                "carrier-totality tooth [R3.3.3]: TOTALITY OUTRANKS THE LAWFUL FRAGMENT — the same improper carrier, now carrying ONE reserved indicator whose value is a genuine election cell built by the source's own constructor and certified by the source's own predicate, is refused just as flatly.  The walk counts that indicator and then meets the dotted tail, and a list this source cannot read to its end is one it will not elect on however lawful its first pair is.  No election, no readiness, and the plant is unchanged by identity"
                (and *ct-cell-lawful-p*
                     (eq :dotted-tail *ct-cellular-shape*)
                     (eql 1 *ct-cellular-count-before*)
                     (sa0-cs-rejected-p *ct-arm-dotted-cell*)
                     *ct-cellular-unchanged*
                     (eql 0 *ct-cellular-elections*)
                     (eq :refused *ct-cellular-ready*)))

   (probe-check "INIT-CT-CIRCULAR-REJECTED-DEFINITIVELY-AND-BOUNDED"
                "carrier-totality tooth [R3.3.3]: THE CIRCULAR CARRIER IS REFUSED, AND THE REFUSAL RETURNED — the load errored with the source's own refusal text and ITS THREAD JOINED rather than expiring, which is the whole difference from the returned law: under the hard timeout this arm can observe a hang, and what it observed was a bounded definitive refusal.  No election, no gathering, no readiness, and the ring is EQ-identical afterwards — every cons still linked to the next and the last still linked back to the head"
                (and (eq :circular *ct-circular-shape*)
                     *ct-circular-eq-on-plant*
                     (sa0-cs-rejected-p *ct-arm-circular*)
                     (eq :done (getf *ct-arm-circular* :join))
                     *ct-circular-unchanged*
                     (eql 0 *ct-circular-elections*)
                     (eq :refused *ct-circular-ready*)
                     (eql 0 *ct-final-elections*)
                     (eql 0 *ct-final-gatherings*)))
   (p "END-INIT-CT-CLEAN")

   (rule)
   (p "INIT-CT-REPLICA  the returned `while (consp tail)` walk, both shapes, captive symbols")
   (arm "REPLICA" "the R3.3.2 counting walk in its returned shape, meeting the dotted carrier and then the circular one — on captive symbols, so the ruled carrier is never touched by it")

   (p "  WHAT THIS ARM CLAIMS, AND WHAT IT DOES NOT.  It is the returned walk in")
   (p "  its returned shape, meeting the two shapes the ruling names.  It does")
   (p "  NOT prove what the returned file contained — that is checkable in the")
   (p "  parcel's own history.  It proves the CONSEQUENCE: that this walk reads")
   (p "  a dotted carrier as an empty lawful one, and never returns from a")
   (p "  circular one.")

   (sa0-run-ct-replica-dotted-arm)
   (sa0-run-ct-replica-circular-arm)

   (p "  THE RULING'S OWN EVIDENCE BLOCK, AND THIS RUN'S COUNTERPART:")
   (p "    ruling 'load exit 0'      <-> returned walk completed, no refusal")
   (p "    ruling 'ready-p T'        <-> a later reader ACCEPTS the installed cell")
   (p "    ruling 'reserved count 1' <-> reserved count after the election")
   (p "    ruling 'carrier plist'    <-> the cell, then the surviving dotted tail")

   (kv "captive plist planted" "(SA0-UNRELATED-PROPERTY :KEPT . SA0-R333-DOTTED-TAIL)")
   (kv "returned walk outcome on it" *ct-replica-scan-outcome*)
   (kv "returned walk reserved count before" *ct-replica-count-before*)
   (kv "returned election installed a cell" (if *ct-replica-install-won* "YES" "NO"))
   (kv "returned walk reserved count after" *ct-replica-count-after*)
   (kv "later reader verdict" *ct-replica-reader-verdict*)
   (kv "captive plist after" *ct-replica-plist-after*)
   (kv "the old plist is still the tail" (if *ct-replica-tail-survives* "YES" "NO"))
   (kv "repaired walk on the SAME captive object" (if *ct-replica-repaired-refused* "REFUSED" "ACCEPTED"))
   (kv "repaired walk refusal" *ct-replica-repaired-refusal*)

   (kv "captive circular plist planted" "a four-cons ring carrying no reserved indicator")
   (kv "returned walk outcome on the ring" *ct-circ-replica-outcome*)
   (kv "returned walk join" *ct-circ-replica-join*)
   (kv "VOLATILE returned walk seconds" *ct-circ-replica-seconds*)
   (kv "repaired walk outcome on the ring" *ct-circ-repaired-outcome*)
   (kv "repaired walk join" *ct-circ-repaired-join*)
   (kv "VOLATILE repaired walk seconds" *ct-circ-repaired-seconds*)
   (kv "repaired walk refusal" *ct-circ-repaired-refusal*)

   (probe-check "INIT-CT-REPLICA-DOTTED-ACCEPTS-THE-REVENANT"
                "carrier-totality tooth replica [R3.3.3]: under the RETURNED WALK the ruling's own shape produces the ruling's own evidence block — the walk COMPLETED and reported ZERO reserved indicators (it read the dotted tail as the end of the plist), the election therefore prepended its cell over that dotted tail, the carrier now reports ONE reserved indicator, and a later reader ACCEPTED it as a lawful installed cell.  The malformed tail is still there, behind the cell, unremarked.  Nothing signalled at any point"
                (and (eq :completed *ct-replica-scan-outcome*)
                     (eql 0 *ct-replica-count-before*)
                     *ct-replica-install-won*
                     (eql 1 *ct-replica-count-after*)
                     (eq :accepted-the-cell *ct-replica-reader-verdict*)
                     *ct-replica-tail-survives*))

   (probe-check "INIT-CT-REPLICA-CIRCULAR-NEVER-TERMINATES"
                "carrier-totality tooth replica [R3.3.3]: and under the RETURNED WALK the circular shape does not produce a wrong answer — it produces NO answer.  The walk was run under a deliberately small bound whose EXPIRY IS THE EXHIBIT, and it expired: rejection was neither immediate nor bounded because the counting walk never finished at all.  The REPAIRED walk, on THE SAME captive object and under THAT SAME small bound, refused and RETURNED"
                (and (eq :timeout *ct-circ-replica-outcome*)
                     (eq :errored *ct-circ-repaired-outcome*)
                     (eq :done *ct-circ-repaired-join*)
                     (stringp *ct-circ-repaired-refusal*)
                     (search *cs-rejection-mark* *ct-circ-repaired-refusal*)))

   (probe-check "INIT-CT-DISCRIMINATES"
                "carrier-totality tooth [R3.3.3]: TWO SHAPES, TWO LAWS, OPPOSITE OUTCOMES, IN BOTH DIRECTIONS.  Given a dotted carrier the repaired source REFUSED — bounded, definitive, the plant untouched and no election held — while the returned walk accepted it and left a second reality behind the tail.  Given a circular carrier the repaired source REFUSED AND RETURNED while the returned walk expired.  The tooth therefore discriminates on both of the returned shapes and not merely on one"
                (and (sa0-cs-rejected-p *ct-arm-dotted*)
                     (sa0-cs-rejected-p *ct-arm-circular*)
                     (eq :done (getf *ct-arm-circular* :join))
                     (eql 1 *ct-replica-count-after*)
                     (eq :accepted-the-cell *ct-replica-reader-verdict*)
                     (eq :timeout *ct-circ-replica-outcome*)))
   (p "END-INIT-CT-REPLICA")

   (rule)
   (p "CEILING, RESTATED WHERE THE NUMBERS ARE:")
   (p "  What is closed here is the TOTALITY of one walk: every way a property")
   (p "  list can fail to be a proper even-length list is enumerated at")
   (p "  SA0-SCAN-RESERVED, and the three faces this section plants are refused")
   (p "  in bounded time with the carrier left exactly as it was found.  It is")
   (p "  three plants on this host, on SBCL 2.4.6, at this parcel tip.  It is")
   (p "  NOT a claim that the election survives an agent that rewrites the")
   (p "  carrier's property list without end — the source states that ceiling")
   (p "  where the loop is written, and no arm here tests it — and it is NOT a")
   (p "  claim about any place other than the reserved slot.  Nor is refusal a")
   (p "  repair: a malformed carrier is left malformed.")

   (when (plant-failure-requested-p)
     (probe-check "INIT-CT-PLANTED-FAULT" "PLANTED FAULT: this check is designed to fail" nil))

   (probe-footer "INIT-CARRIER-TOTALITY")
   (probe-exit))

  ;; ------------------------------------------------------------------------
  (t
   (format t "~&!! SA0 PROBE: unknown SA0_PROBE_SCHEDULE_ROLE ~S~%" *sa0-schedule-role*)
   (finish-output)
   (sb-ext:exit :code 2)))
