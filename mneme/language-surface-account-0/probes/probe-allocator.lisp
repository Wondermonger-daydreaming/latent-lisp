;;;; probe-allocator.lisp
;;;;
;;;; ==========================================================================
;;;; NON-PRODUCTION FEASIBILITY PROBE — Surface Account /0 opening round —
;;;; not a package, not an API, not loadable as part of any system.
;;;; ==========================================================================
;;;;
;;;; THE CONCURRENT ALLOCATOR TOOTH — section ALLOCATOR.
;;;;
;;;; The R2 adjudication's section D says, in one sentence that is the whole
;;;; reason this file exists:
;;;;
;;;;     "Ordinary unsynchronized INCF is not an unconditional freshness
;;;;      mechanism."
;;;;
;;;; and it requires, for the LINEARIZABLE ACCOUNT-OWNED ALLOCATOR arm the
;;;; contract chose (II.3, encoded path ("performance" <epoch-hex>
;;;; <counter-decimal>)), "a concurrent non-production tooth".  So:
;;;;
;;;;   CLEAN ARM     N threads x M allocations through a SYNCHRONIZED allocator
;;;;                 yield exactly N*M datums, all distinct, whose counters are
;;;;                 exactly 1..N*M with no gap and no repeat.  That last
;;;;                 property is the linearizability claim itself: every
;;;;                 allocation took a distinct position in one total order.
;;;;
;;;;   PLANTED ARM   the SAME load through an UNSYNCHRONIZED read-modify-write
;;;;                 produces duplicates, and the duplicate detector that
;;;;                 reported ZERO on the clean set reports them.  A detector
;;;;                 that has never fired is untested, not passing.
;;;;
;;;; THE PLANTED ARM IS STRUCTURAL, NOT PROBABILISTIC, AND SAYS SO.  Its first
;;;; round holds every thread at a BARRIER between the read and the write, so
;;;; all N threads demonstrably read the same counter value and all N mint the
;;;; same performance datum.  That is not a race we were lucky enough to catch:
;;;; it is the non-atomicity of read-modify-write EXHIBITED.  A widened window
;;;; makes the demonstration deterministic; it does not make the defect real —
;;;; the defect is that the operation has no atomicity to begin with.
;;;;
;;;; R3.1-B DELETES THE THIRD ARM.  R3 also ran a bare-INCF OBSERVATION arm at
;;;; high contention, reporting duplicate and lost-update counts and asserting
;;;; nothing about them.  The ruling deletes it as redundant: the barrier tooth
;;;; above already proves the defect DETERMINISTICALLY, and unsynchronized INCF
;;;; may occur only inside that one explicitly labelled negative tooth.  In its
;;;; place this file now witnesses the R3.1-B PERFORMANCE REPRESENTATION —
;;;; sixteen epoch octets, thirty-two lowercase hex digits, counter initialized
;;;; at 0 with the first allocation 1, canonical decimal with no leading zero —
;;;; and shows the shape predicate rejecting all seven unlawful spellings.
;;;;
;;;; WHAT R3 CHANGED HERE.  This file no longer builds a performance datum of
;;;; its own.  Under R2 it had a local builder and probe-freshness.lisp had a
;;;; DIFFERENT one — two witnesses of one mechanism disagreeing about that
;;;; mechanism's own representation, invisibly, because neither transcript
;;;; printed the other's shape.  R3-B rules ONE exact shared representation
;;;; built by THE SAME CONSTRUCTOR: probe-identity.lisp.  This file loads it and
;;;; calls it, and its synchronized allocator IS the one declared there.  This
;;;; section discharges II.3's PROOF 1 — synchronized concurrent allocations are
;;;; distinct — which is the one proof that needs real thread contention.
;;;;
;;;; THE BOUNDARY.  Host facilities and CD/0's public constructors only.  No
;;;; package is defined, no Account object is minted, NEITHER PROVIDER IS
;;;; TOUCHED.  The datums minted here are probe-local stand-ins carrying the
;;;; role the contract names; they are not the contract's objects.

(in-package #:cl-user)

(defparameter *alloc-threads* 8)
(defparameter *alloc-per-thread* 200)
(defparameter *planted-per-thread* 40)
(defparameter *init-race-threads* 8)
(defparameter *init-race-allocations-per-thread* 5)

;;; --------------------------------------------------------------------------
;;; A BARRIER FACTORY, DEFINED BEFORE THE LOAD BECAUSE THE FIRST THING THIS
;;; IMAGE DOES IS RACE THAT LOAD.
;;;
;;; Each call returns a FRESH barrier closure over its own mutex, count and
;;; semaphore, so two arms can never share a count.  R3.1 had one set of barrier
;;; globals used exactly once; R3.2 needs several barriers in one image, and a
;;; single global count silently mis-releases the second user.
;;; --------------------------------------------------------------------------

(defun make-sa0-barrier (n)
  "Return a closure that blocks until it has been called N times."
  (let ((mutex (sb-thread:make-mutex :name "sa0-probe-barrier"))
        (semaphore (sb-thread:make-semaphore :count 0))
        (count 0))
    (lambda ()
      (let ((last nil))
        (sb-thread:with-mutex (mutex)
          (incf count)
          (when (= count n) (setf last t)))
        (if last
            (sb-thread:signal-semaphore semaphore (1- n))
            (sb-thread:wait-on-semaphore semaphore))
        last))))

;;; ==========================================================================
;;; THE CONCURRENT FIRST-INITIALIZATION RACE (R3.2-B, hostile test 1).
;;;
;;; WHY IT IS HERE, AT THE TOP OF THE FILE, AND NOWHERE ELSE.  The ruled law is
;;; ONCE PER RUNNING IMAGE, and the only moment at which it can be raced is the
;;; FIRST initialization.  Every child this probe starts is a fresh SBCL image,
;;; so in THIS image, at THIS point, probe-identity.lisp has never been loaded
;;; and the epoch has never been gathered — which is exactly the precondition
;;; the test needs and cannot be manufactured later.  A "race" run after
;;; initialization would be N threads agreeing about a value that was already
;;; there: a tautology wearing a tooth's clothes.
;;;
;;; SO THE LOAD ITSELF IS THE RACED OPERATION.  N threads are held at a barrier
;;; and then all call (LOAD "probe-identity.lisp") — a genuine concurrent first
;;; load, not a call to an initializer the file has already run.  R3.1's own
;;; comment named "a CONCURRENT OR RE-ENTRANT LOAD" as the hazard and tested
;;; neither.
;;;
;;; NOTHING IS PRINTED HERE.  This runs before PROBE-HEADER, so every
;;; observation lands in a global and the ALLOCATOR-INIT-RACE arm below prints
;;; and checks it inside the section.  The globals are the standing SBCL scar's
;;; requirement too: a discarded read can be optimized away, so every observed
;;; value is stored and later PRINTED.
;;;
;;; THE SYMBOL-FUNCTION INDIRECTION IS DELIBERATE, not a flourish: the names
;;; below are defined by the file these threads are loading, so they do not
;;; exist when this form is compiled.  Naming them through SYMBOL-FUNCTION reads
;;; them at call time, which is both what the test means and what keeps
;;; undefined-function warnings out of the transcript.  R3.3 note: the three
;;; state reads that were SYMBOL-VALUE under R3.2 are now SYMBOL-FUNCTION reads
;;; of SA0-EPOCH-HEX, SA0-EPOCH-DATUM and SA0-PERFORMANCE-MUTEX, because the
;;; R3.2 globals no longer exist — the repair replaced them with readers of the
;;; one published state (see probe-identity.lisp).
;;;
;;; WHAT THIS ARM IS, RECLASSIFIED HONESTLY (R3.3-B clause 3).  This is a BROAD
;;; CONTENTION CONTROL: N threads released together at one barrier onto the
;;; image's first LOAD.  It observes ONE schedule out of many and it cannot pin
;;; the dangerous one, so it is NOT proof of the universal once-only law and is
;;; no longer presented as one.  The schedule that FINDING 1 identified — a
;;; loader held between a defining form's unbound test and that form's delayed
;;; write — is closed by the SEPARATE, PINNED tooth in probe-init-schedule.lisp,
;;; and true same-thread re-entry is closed by the recursive-load tooth in the
;;; same file.
;;; ==========================================================================

(defvar *sa0-identity-path*
  (merge-pathnames "probe-identity.lisp" (or *load-truename* *load-pathname*)))

(defvar *init-race-mutex* (sb-thread:make-mutex :name "sa0-probe-init-race"))
(defvar *init-race-observations* nil
  "One entry per racing thread, recorded AFTER its own LOAD returned:
 (epoch-hex datum-present-p allocator-mutex-present-p thread-name).")
(defvar *init-race-counters* nil)
(defvar *init-race-threads-returned* 0)
(defvar *init-race-load-errors* nil)

(let* ((n *init-race-threads*)
       (gate (make-sa0-barrier n))
       (path *sa0-identity-path*)
       (threads
         (loop for i from 0 below n
               collect (sb-thread:make-thread
                        (lambda ()
                          (funcall gate)
                          (handler-case (load path)
                            (error (condition)
                              (sb-thread:with-mutex (*init-race-mutex*)
                                (push (princ-to-string condition) *init-race-load-errors*))))
                          ;; The load has returned, so this thread's own
                          ;; initialization call has completed.  Read the whole
                          ;; published state, then take this thread's share of
                          ;; allocations through the shared allocator.
                          (let ((hex    (funcall (symbol-function 'sa0-epoch-hex)))
                                (datum  (funcall (symbol-function 'sa0-epoch-datum)))
                                (pmutex (funcall (symbol-function 'sa0-performance-mutex)))
                                (mine   (loop repeat *init-race-allocations-per-thread*
                                              collect (funcall (symbol-function
                                                                'allocate-performance-counter)))))
                            (sb-thread:with-mutex (*init-race-mutex*)
                              (push (list hex (and datum t) (and pmutex t)
                                          (sb-thread:thread-name sb-thread:*current-thread*))
                                    *init-race-observations*)
                              (setf *init-race-counters*
                                    (append mine *init-race-counters*))))
                          t)
                        :name (format nil "sa0-probe-init-race-~D" i)))))
  (setf *init-race-threads-returned*
        (count t (mapcar (lambda (th) (and (sb-thread:join-thread th :default :error) t))
                         threads))))

;;; THE SHARED CONSTRUCTOR is now loaded — by the race above, N times over, in N
;;; threads.  This call is a SEQUENTIAL RELOAD and must change nothing: it is
;;; kept because the file must be loaded by this file's own control flow too, so
;;; that a reader who deletes the race arm is still left with a working section.
;;;
;;; R3.3, MISLABEL CORRECTED (OWNER FINDING 1, closing paragraph): R3.2 called
;;; this call "the RE-ENTRANT one".  It is not.  It runs on one thread, after
;;; initialization has completed, with no load in progress underneath it — that
;;; is a SEQUENTIAL RELOAD.  A genuine re-entry is a same-thread recursive LOAD
;;; fired from INSIDE an unfinished initialization, before ready publication,
;;; and it is tested in probe-init-schedule.lisp, not here.
(load *sa0-identity-path*)

;;; --------------------------------------------------------------------------
;;; THE SYNCHRONIZED ALLOCATOR is ALLOCATE-PERFORMANCE-COUNTER, defined once in
;;; probe-identity.lisp and shared with the freshness witness.  Its discharging
;;; primitive is a mutex, named there as II.3 requires.  Nothing is redefined
;;; here; the wrapper below only pairs the shared allocation with the shared
;;; constructor.
;;; --------------------------------------------------------------------------

(defun allocate-synchronized ()
  (performance-identifier (allocate-performance-counter)))

;;; --------------------------------------------------------------------------
;;; THE UNSYNCHRONIZED ALLOCATOR — an ordinary read-modify-write, which is
;;; what "unsynchronized INCF" means once it is written out.
;;; --------------------------------------------------------------------------

(defvar *unsync-counter* 0)

(defun allocate-unsynchronized (&key (widen nil))
  "THE ONLY PLACE UNSYNCHRONIZED READ-MODIFY-WRITE APPEARS in this round, and
it is the labelled negative tooth the contract permits it in.  Note what is
NOT unsynchronized: the CONSTRUCTOR is still the shared one — only the
ALLOCATION of the counter is broken here, so the arm isolates the defect."
  (let ((v *unsync-counter*))
    (when widen (sb-thread:thread-yield))
    (setf *unsync-counter* (1+ v))
    (performance-identifier (1+ v))))

;;; --------------------------------------------------------------------------
;;; A barrier, so the planted arm's first round is a demonstration and not a
;;; lottery.  R3.2: built by MAKE-SA0-BARRIER at the top of this file, which is
;;; the same facility the first-load race uses; each arm gets its OWN barrier
;;; rather than sharing one set of globals.
;;; --------------------------------------------------------------------------

(defvar *planted-barrier* (make-sa0-barrier *alloc-threads*))

(defun barrier-wait (n)
  (declare (ignore n))
  (funcall *planted-barrier*))

;;; --------------------------------------------------------------------------
;;; THE PLANTED INITIALIZATION LAWS (R3.2-B, hostile test 3).
;;;
;;; Two unsafe patterns, on state of their own, run under the SAME concurrent
;;; load the ruled law survives above.  Both are STRUCTURAL, not probabilistic:
;;; a barrier is placed at the exact point the pattern is unsound, so the defect
;;; is EXHIBITED rather than waited for.  Neither touches the ruled state.
;;;
;;;   P1  THE R3 TEST-THEN-ACT.  Read the flag, then act on the reading, with no
;;;       lock.  Every thread is held between the read and the act, so all N
;;;       read NIL and all N gather — N distinct epochs, N-1 of them silently
;;;       overwritten, in an image whose whole law is that there is one.
;;;
;;;   P2  PUBLICATION BEFORE INITIALIZATION.  Set the "initialized" flag first
;;;       and the state it announces afterwards.  An observer held between the
;;;       two reads a flag that says the epoch is ready beside a state that is
;;;       not there.  Two barriers pin the order, so the observation is a
;;;       demonstration and not a lottery.
;;;
;;; UNSYNCHRONIZED READ-MODIFY-WRITE IS PERMITTED HERE AND NOWHERE ELSE: this
;;; block and ALLOCATE-UNSYNCHRONIZED above are the labelled negative teeth.
;;; --------------------------------------------------------------------------

(defvar *planted-init-epoch* nil)
(defvar *planted-init-gatherings* 0)
(defvar *planted-init-gathered* nil)
(defvar *planted-init-mutex* (sb-thread:make-mutex :name "sa0-probe-planted-init"))
(defvar *planted-init-returned* 0)

(defun planted-unsafe-initialize (gate)
  "THE R3 LAW, REPLICATED ON PLANTED STATE: an unsynchronized test-then-act with
an unsynchronized INCF inside it.  GATE is called BETWEEN the test and the act."
  (let ((seen *planted-init-epoch*))                       ; the TEST, no lock
    (funcall gate)                                         ; held here
    (unless seen                                           ; the ACT, no lock
      (let ((hex (sa0-octets-to-lower-hex (sa0-gather-epoch-octets))))
        (setf *planted-init-epoch* hex)
        (incf *planted-init-gatherings*)                   ; read-modify-write
        (sb-thread:with-mutex (*planted-init-mutex*)
          (push hex *planted-init-gathered*))              ; the printed canary
        hex))))

(defvar *planted-publication-flag* nil)
(defvar *planted-publication-state* nil)
(defvar *planted-publication-observation* :not-run)

;;; --------------------------------------------------------------------------
;;; THE CANARY MUST BE PRINTED.  A discarded read can be optimized away and the
;;; tooth would then silently never fire — the standing SBCL scar.  Every
;;; collected result lands in a GLOBAL special variable, and the summary of that
;;; global is PRINTED before anything is compared.
;;; --------------------------------------------------------------------------

(defvar *clean-results* nil)
(defvar *planted-results* nil)
(defvar *clean-threads-seen* nil)
(defvar *results-mutex* (sb-thread:make-mutex :name "sa0-probe-results"))

(defun push-results (place-fn items)
  (sb-thread:with-mutex (*results-mutex*) (funcall place-fn items)))

(defun run-threads (n fn)
  "Start N threads, join them all, and return the number that returned normally."
  (let ((threads (loop for i from 0 below n
                       collect (sb-thread:make-thread fn :name (format nil "sa0-probe-~D" i)))))
    (count t (mapcar (lambda (th) (and (sb-thread:join-thread th :default :error) t)) threads))))

(defun octet-hex (datum) (datum-hex datum))

(defun duplicate-count (datums)
  "THE ONE DETECTOR, used on BOTH arms.  Counts how many members of DATUMS are
not the first occurrence of their canonical octets."
  (let ((seen (make-hash-table :test #'equal)) (dups 0))
    (dolist (d datums dups)
      (let ((h (octet-hex d)))
        (if (gethash h seen) (incf dups) (setf (gethash h seen) t))))))

(defun counters-of (datums) (mapcar #'performance-counter-of datums))

(defun contiguous-run-p (counters first n)
  "The counters are exactly FIRST, FIRST+1, ... FIRST+N-1 — no gap, no repeat.
R3.2 generalizes the R3.1 predicate from 1..N to an arbitrary starting value,
because the ALLOCATOR image no longer begins its allocations in the clean arm:
the first-load race takes the image's FIRST allocations, so the clean arm owns a
contiguous run that starts where the race left off.  The property being measured
is unchanged — every allocation occupies a distinct position in ONE increasing
total order — and it is now measured over the whole image rather than over one
arm."
  (let ((sorted (sort (copy-list counters) #'<)))
    (and (= (length sorted) n)
         (loop for want from first below (+ first n)
               for got in sorted
               always (= want got)))))

(defun contiguous-1-to-n-p (counters n)
  (contiguous-run-p counters 1 n))

(defun performance-path-shape-p (d) (performance-identifier-shape-p d))

;;; ==========================================================================
;;; THE SECTION.
;;; ==========================================================================

(probe-header "THE CONCURRENT ALLOCATOR TOOTH — the linearizable arm, and the unsynchronized arm failing")

(p "SCOPE, PRINTED BEFORE ANY NUMBER:")
(p "  Host threads and CD/0's public constructors only.  No package is defined,")
(p "  no Account object is minted, and NEITHER PROVIDER IS TOUCHED.  What is")
(p "  demonstrated is a MECHANISM — a synchronized allocator's linearizability")
(p "  under real contention, and an unsynchronized one's failure of it — not an")
(p "  Account /0 occurrence identity, which does not exist.")
(rule)
(kv "threads" *alloc-threads*)
(kv "allocations per thread (clean)" *alloc-per-thread*)
(kv "allocations per thread (planted)" *planted-per-thread*)
(kv "VOLATILE image epoch" *image-epoch-hex*)
(kv "epoch gatherings this image" *epoch-initializations*)
(kv "performance constructor" "probe-identity.lisp — the ONE shared constructor, also used by the FRESHNESS section")
(kv "sb-thread present" (if (find-package "SB-THREAD") "YES" "NO"))
(kv "threads supported" (if (member :sb-thread *features*) "YES" "NO"))

;;; --------------------------------------------------------------------------
(rule)
(p "ALLOCATOR-INIT-RACE  N threads racing the image's FIRST load of the identity source")
(arm "CLEAN" "a BROAD CONTENTION CONTROL over the image's first load — not a schedule-pinned proof")

(p "  WHAT WAS RACED, said before the numbers: this image had never loaded")
(p "  probe-identity.lisp when the threads below were released, so the epoch had")
(p "  never been gathered.  All N were held at one barrier and then all called")
(p "  (LOAD \"probe-identity.lisp\") — a genuine concurrent FIRST load.  Each then")
(p "  read the whole published state and took its share of allocations through")
(p "  the shared allocator.  This arm therefore also measures that ONE allocator")
(p "  mutex and ONE counter exist: two of either would break the contiguous run.")
(p "  WHAT THIS ARM IS AND IS NOT, reclassified under R3.3-B clause 3.  It is a")
(p "  BROAD CONTENTION CONTROL.  Releasing N threads at one barrier samples ONE")
(p "  schedule out of many; it does not pin the dangerous one.  R3.2 presented")
(p "  this arm as sufficient for the universal once-only law and the owner's")
(p "  R3.3 FINDING 1 refused that: the arm happened to observe a favourable")
(p "  interleaving.  It is retained because contention is worth exercising, and")
(p "  it is no longer offered as the proof.  The stale-definition schedule is")
(p "  closed by the PINNED tooth in probe-init-schedule.lisp (role stale); true")
(p "  same-thread re-entry is closed by the recursive-load tooth in the same")
(p "  file (role recursive).")

(let* ((observed-epochs (mapcar #'first *init-race-observations*))
       (distinct-epochs (remove-duplicates (remove nil observed-epochs) :test #'string=))
       (total-race-allocations (* *init-race-threads* *init-race-allocations-per-thread*)))
  (kv "init-race threads requested" *init-race-threads*)
  (kv "init-race threads that returned normally" *init-race-threads-returned*)
  (kv "init-race load errors [printed global]" (length *init-race-load-errors*))
  (kv "init-race observations recorded [printed global]" (length *init-race-observations*))
  (kv "init-race distinct thread names"
      (length (remove-duplicates (mapcar #'fourth *init-race-observations*) :test #'string=)))
  (kv "init-race distinct epochs observed" (length distinct-epochs))
  (kv "VOLATILE init-race epoch observed" (or (first distinct-epochs) "NONE"))
  (kv "init-race epoch gatherings this image" *epoch-initializations*)
  (kv "init-race allocations taken" (length *init-race-counters*))
  (kv "init-race counter after the race" *performance-counter*)

  (probe-check "ALLOCATOR-INIT-RACE-THREADS-REALLY-RAN"
               "init race: every requested thread was really started, really completed its own LOAD of the identity source and really joined — with zero load errors, so the concurrency is real and nothing was skipped"
               (and (= *init-race-threads* *init-race-threads-returned*)
                    (= *init-race-threads* (length *init-race-observations*))
                    (= *init-race-threads*
                       (length (remove-duplicates (mapcar #'fourth *init-race-observations*)
                                                  :test #'string=)))
                    (null *init-race-load-errors*)))
  (probe-check "ALLOCATOR-INIT-RACE-ONE-EPOCH"
               "init race [R3.2-B, RECLASSIFIED R3.3]: N concurrent FIRST loaders observed EXACTLY ONE distinct epoch between them, on THIS schedule.  Contention control only: one sampled interleaving is not the universal law, which is closed by the pinned tooth"
               (and (= 1 (length distinct-epochs))
                    (= *init-race-threads* (length observed-epochs))
                    (notany #'null observed-epochs)
                    (string= (first distinct-epochs) *image-epoch-hex*)))
  (probe-check "ALLOCATOR-INIT-RACE-GATHERED-ONCE"
               "init race [R3.2-B, RECLASSIFIED R3.3]: and the epoch was GATHERED exactly once on this schedule — the tally is the length of an ATOMIC-PUSH list on the one election cell, so a lost update cannot hide a second gathering"
               (= 1 *epoch-initializations*))
  (probe-check "ALLOCATOR-INIT-RACE-NO-PARTIAL-PUBLICATION"
               "init race [R3.2-B, RECLASSIFIED R3.3]: no loader ever saw a partially initialized image — every thread that observed the epoch text also observed the epoch datum AND the allocator mutex, which under R3.3 is structural rather than ordered: all three are slots of ONE immutable state object installed by a single CAS"
               (and (= *init-race-threads* (length *init-race-observations*))
                    (every (lambda (o) (and (first o) (second o) (third o)))
                           *init-race-observations*)))
  (probe-check "ALLOCATOR-INIT-RACE-COUNTER-EQUALS-ALLOCATIONS"
               "init race [R3.2-B]: the counter's final value equals the total number of allocations the racing threads took, and their counters are exactly 1..N*K — one counter, one allocator mutex, one total order, from the image's very first allocation"
               (and (= total-race-allocations (length *init-race-counters*))
                    (= total-race-allocations *performance-counter*)
                    (contiguous-run-p *init-race-counters* 1 total-race-allocations))))
(p "END-ALLOCATOR-INIT-RACE")

;;; --------------------------------------------------------------------------
(rule)
(p "ALLOCATOR-INIT-PLANTED  the two unsafe initialization laws, under the same load")
(arm "PLANTED" "P1 the R3 test-then-act held between its test and its act; P2 the flag published before the state it announces")

(let ((returned
        (run-threads *init-race-threads*
                     (let ((gate (make-sa0-barrier *init-race-threads*)))
                       (lambda () (planted-unsafe-initialize gate))))))
  (setf *planted-init-returned* returned))

;;; P2.  Two barriers pin the interleaving: the publisher sets the flag, both
;;; parties meet at the first gate, the OBSERVER reads, and only then does the
;;; second gate release the publisher to write the state.  The observation
;;; therefore strictly precedes the write — no scheduling luck is involved.
(let* ((gate-1 (make-sa0-barrier 2))
       (gate-2 (make-sa0-barrier 2))
       (publisher (sb-thread:make-thread
                   (lambda ()
                     (setf *planted-publication-flag* t)   ; PUBLISHED FIRST — the defect
                     (funcall gate-1)
                     (funcall gate-2)
                     (setf *planted-publication-state* "the state the flag announced")
                     t)
                   :name "sa0-probe-planted-publisher"))
       (observer (sb-thread:make-thread
                  (lambda ()
                    (funcall gate-1)
                    (setf *planted-publication-observation*
                          (list *planted-publication-flag* *planted-publication-state*))
                    (funcall gate-2)
                    t)
                  :name "sa0-probe-planted-observer")))
  (sb-thread:join-thread publisher :default :error)
  (sb-thread:join-thread observer  :default :error))

(let* ((gathered *planted-init-gathered*)
       (distinct (remove-duplicates gathered :test #'string=)))
  (kv "planted P1 threads that returned normally" *planted-init-returned*)
  (kv "planted P1 epochs gathered [printed global]" (length gathered))
  (kv "planted P1 distinct epochs gathered" (length distinct))
  ;; VOLATILE, and the reason is the defect itself: the count is maintained by
  ;; an UNSYNCHRONIZED read-modify-write, so how many of the N increments
  ;; survive is a property of this run's interleaving.  Nothing is asserted
  ;; about it — the assertion below is on the EPOCHS, which the barrier makes
  ;; deterministic.
  (kv "VOLATILE planted P1 gathering count it kept" *planted-init-gatherings*)
  (kv "planted P1 epochs silently overwritten" (max 0 (1- (length distinct))))
  (kv "planted P2 flag observed" (first *planted-publication-observation*))
  (kv "planted P2 state observed" (or (second *planted-publication-observation*) "ABSENT"))

  (probe-check "ALLOCATOR-INIT-PLANTED-UNLOCKED-GATHERS-N-EPOCHS"
               "init planted P1 [STRUCTURAL, not probabilistic]: held between the test and the act, all N loaders read NIL and all N gathered — N DISTINCT epochs in one image, N-1 of them overwritten without trace.  This is the R3 initialization law, and it is the law the ruled one replaced"
               (and (= *init-race-threads* *planted-init-returned*)
                    (= *init-race-threads* (length gathered))
                    (= *init-race-threads* (length distinct))
                    (member *planted-init-epoch* gathered :test #'string=)))
  (probe-check "ALLOCATOR-INIT-PLANTED-EARLY-PUBLICATION-OBSERVED"
               "init planted P2 [STRUCTURAL]: with the flag published BEFORE the state it announces, an observer pinned between the two reads INITIALIZED=T beside an ABSENT state — which is precisely what publishing the flag last, inside the lock, makes unobservable in the ruled law"
               (and (eq t (first *planted-publication-observation*))
                    (null (second *planted-publication-observation*))))
  (probe-check "ALLOCATOR-INIT-DISCRIMINATES"
               "init: the SAME distinct-epoch counter reports ONE for the ruled law under N concurrent first loads and N for the unsafe one under the same load — the clean verdict is a measurement, not a habit"
               (and (= 1 (length (remove-duplicates
                                  (remove nil (mapcar #'first *init-race-observations*))
                                  :test #'string=)))
                    (= *init-race-threads* (length distinct)))))
(p "END-ALLOCATOR-INIT-PLANTED")

;;; --------------------------------------------------------------------------
(rule)
(p "ALLOCATOR-CLEAN  the synchronized allocator under contention")
(arm "CLEAN" "N threads x M allocations through the mutex-guarded allocator")

;;; THE BASELINE.  The image's first allocations were taken by the first-load
;;; race above, so this arm owns the contiguous run that STARTS HERE.  The
;;; baseline is read before a single thread is started and printed beside the
;;; result, so the run being checked is bounded by a number this arm did not
;;; choose after the fact.
(defvar *clean-baseline* *performance-counter*)
(kv "clean-arm counter baseline (allocations already taken by the init race)" *clean-baseline*)

(let ((returned
        (run-threads *alloc-threads*
                     (lambda ()
                       (let ((mine (loop repeat *alloc-per-thread* collect (allocate-synchronized))))
                         (push-results (lambda (items)
                                         (setf *clean-results* (append items *clean-results*))
                                         (push (sb-thread:thread-name sb-thread:*current-thread*)
                                               *clean-threads-seen*))
                                       mine))))))
  (kv "threads that returned normally" returned)
  (kv "distinct thread names recorded" (length (remove-duplicates *clean-threads-seen* :test #'string=)))
  (kv "datums collected [printed global]" (length *clean-results*))
  (kv "final synchronized counter" *performance-counter*)
  (kv "duplicate datums [the detector]" (duplicate-count *clean-results*))
  (kv "counters min / max" (format nil "~D / ~D"
                                   (reduce #'min (counters-of *clean-results*))
                                   (reduce #'max (counters-of *clean-results*))))

  (probe-check "ALLOCATOR-THREADS-REALLY-RAN"
               "allocator clean: every requested thread was really started, really ran and really joined — the contention is real, not simulated"
               (and (= returned *alloc-threads*)
                    (= *alloc-threads* (length (remove-duplicates *clean-threads-seen* :test #'string=)))))
  (probe-check "ALLOCATOR-CLEAN-COUNT"
               "allocator clean: exactly N x M datums were allocated — none lost"
               (= (* *alloc-threads* *alloc-per-thread*) (length *clean-results*)))
  (probe-check "ALLOCATOR-CLEAN-ALL-DISTINCT"
               "allocator clean [PROOF 1]: ALL of them are distinct — zero duplicates by canonical octets"
               (zerop (duplicate-count *clean-results*)))
  (probe-check "ALLOCATOR-CLEAN-COUNTERS-CONTIGUOUS"
               "allocator clean: the counters are exactly baseline+1..baseline+N*M — no gap, no repeat; every allocation took a distinct position in ONE total order, which is the linearizability claim itself.  R3.2 states the run relative to the printed baseline because the image's first allocations now belong to the first-load race arm; the property measured is unchanged"
               (contiguous-run-p (counters-of *clean-results*)
                                 (1+ *clean-baseline*)
                                 (* *alloc-threads* *alloc-per-thread*)))
  (probe-check "ALLOCATOR-CLEAN-PATH-SHAPE"
               "allocator clean: every datum is the contract's exact encoded path — namespace (lisp-plus-surface-account), path (performance <epoch-hex> <counter-decimal>)"
               (every #'performance-path-shape-p *clean-results*))
  (probe-check "ALLOCATOR-CLEAN-EPOCH-CONSTANT"
               "allocator clean: one image, one epoch — every datum carries the same epoch segment"
               (= 1 (length (remove-duplicates
                             (mapcar (lambda (d) (lisp-plus-cd0:identifier-datum-path-segment d 1))
                                     *clean-results*)
                             :test #'string=)))))
(p "END-ALLOCATOR-CLEAN")

;;; --------------------------------------------------------------------------
(rule)
(p "ALLOCATOR-PLANTED  the same load through an UNSYNCHRONIZED read-modify-write")
(arm "PLANTED" "every thread held at a barrier BETWEEN the read and the write, then M-1 further unsynchronized rounds")

(defvar *barrier-round* nil)

(let ((returned
        (run-threads *alloc-threads*
                     (lambda ()
                       ;; ---- round 1: the structural demonstration ----
                       (let ((v *unsync-counter*))
                         (barrier-wait *alloc-threads*)
                         (setf *unsync-counter* (1+ v))
                         (let ((d (performance-identifier (1+ v))))
                           (push-results (lambda (items)
                                           (push (car items) *barrier-round*)
                                           (setf *planted-results* (append items *planted-results*)))
                                         (list d))))
                       ;; ---- the remaining rounds, window widened ----
                       (let ((mine (loop repeat (1- *planted-per-thread*)
                                         collect (allocate-unsynchronized :widen t))))
                         (push-results (lambda (items)
                                         (setf *planted-results* (append items *planted-results*)))
                                       mine))))))
  (kv "threads that returned normally" returned)
  (kv "datums collected [printed global]" (length *planted-results*))
  (kv "barrier-round datums [printed global]" (length *barrier-round*))
  (kv "barrier-round distinct counters"
      (length (remove-duplicates (counters-of *barrier-round*))))
  (kv "VOLATILE duplicate datums [the same detector]" (duplicate-count *planted-results*))
  (kv "VOLATILE final unsynchronized counter" *unsync-counter*)

  (probe-check "ALLOCATOR-PLANTED-COUNT-PRESERVED"
               "allocator planted: the unsynchronized arm emitted the SAME number of allocations as the clean arm's per-thread rate — so what follows is DUPLICATION, not loss"
               (= (* *alloc-threads* *planted-per-thread*) (length *planted-results*)))
  (probe-check "ALLOCATOR-PLANTED-BARRIER-COLLISION"
               "allocator planted [STRUCTURAL, not probabilistic]: held at a barrier between the read and the write, all N threads minted ONE AND THE SAME counter value — read-modify-write has no atomicity to lose"
               (and (= *alloc-threads* (length *barrier-round*))
                    (= 1 (length (remove-duplicates (counters-of *barrier-round*))))
                    (= (1- *alloc-threads*) (duplicate-count *barrier-round*))))
  (probe-check "ALLOCATOR-PLANTED-DUPLICATES-DETECTED"
               "allocator planted: the duplicate detector FIRES on the unsynchronized set"
               (plusp (duplicate-count *planted-results*)))
  (probe-check "ALLOCATOR-DETECTOR-DISCRIMINATES"
               "allocator: the SAME detector reports zero on the synchronized set and nonzero on the unsynchronized one — its clean verdict is a measurement, not a habit"
               (and (zerop (duplicate-count *clean-results*))
                    (plusp (duplicate-count *planted-results*))))
  (probe-check "ALLOCATOR-PLANTED-NOT-CONTIGUOUS"
               "allocator planted: and the unsynchronized counters are NOT 1..N*M — the total order the clean arm exhibits is exactly what synchronization buys"
               (not (contiguous-1-to-n-p (counters-of *planted-results*)
                                         (* *alloc-threads* *planted-per-thread*)))))
(p "END-ALLOCATOR-PLANTED")

;;; --------------------------------------------------------------------------
;;; THE BARE-INCF OBSERVATION ARM IS DELETED (R3.1-B, ordered).
;;;
;;; R3 ran a THIRD arm here: N threads calling (INCF *bare-counter*) with no
;;; barrier and no widened window, reporting its duplicate and lost-update
;;; counts on VOLATILE lines and asserting nothing about them.  The ruling
;;; deletes it as redundant, and the reasoning is worth keeping where the arm
;;; used to be: the DETERMINISTIC BARRIER-BASED PLANTED TOOTH above already
;;; proves the defect STRUCTURALLY — held between the read and the write, all N
;;; threads mint one and the same counter — so a probabilistic arm that might
;;; collide, might not, and asserts nothing either way adds no evidence and
;;; costs a second unsynchronized read-modify-write in a lane whose whole point
;;; is that there must be only one, inside one labelled negative tooth.
;;;
;;; UNSYNCHRONIZED INCF THEREFORE NOW OCCURS IN EXACTLY ONE PLACE IN THIS
;;; DIRECTORY: the labelled ALLOCATOR-PLANTED tooth above.  probe-identity.lisp
;;; has none — its epoch bookkeeping INCF, which R3 left unsynchronized inside a
;;; bare test-then-act and R3.2 moved inside a mutex, is under R3.3 not an INCF
;;; at all: the gathering tally is the LENGTH of an SB-EXT:ATOMIC-PUSH list on
;;; the single election cell, so no read-modify-write is involved and no update
;;; can be lost.
;;; --------------------------------------------------------------------------

;;; --------------------------------------------------------------------------
(rule)
(p "ALLOCATOR-SHAPE  the exact R3.1-B performance representation, and its refusals")
(arm "CLEAN" "the bound representation, measured on this image")

(kv "epoch octets [bound: 16]" (length (lisp-plus-cd0:bytes-datum-value *image-epoch-datum*)))
(kv "epoch text length [bound: 32]" (length *image-epoch-hex*))
(kv "VOLATILE epoch text" *image-epoch-hex*)
(kv "epoch initializations this image" *epoch-initializations*)

(probe-check "ALLOCATOR-EPOCH-EXACTLY-16-OCTETS"
             "allocator shape [R3.1-B]: the image epoch is EXACTLY sixteen octets and its text is EXACTLY thirty-two lowercase hexadecimal digits — R3 bound neither length, so a thirty-one or thirty-three digit epoch text would have passed the shape predicate"
             (and (= 16 (length (lisp-plus-cd0:bytes-datum-value *image-epoch-datum*)))
                  (= 32 (length *image-epoch-hex*))
                  (lawful-epoch-text-p *image-epoch-hex*)))

(probe-check "ALLOCATOR-EPOCH-GATHERED-ONCE"
             "allocator shape [R3.1-B, R3.3]: the epoch was gathered exactly ONCE in this image, under the R3.3 carrier election that replaced R3's unsynchronized test-then-act and R3.2's DEFGLOBAL-then-CAS"
             (= 1 *epoch-initializations*))

;;; --------------------------------------------------------------------------
;;; R3.2-B: SIXTEEN OCTETS OF *ENTROPY*, NOT SIXTEEN OCTETS OF REPRESENTATION.
;;;
;;; WHY THIS ARM HAD TO BE ADDED, said plainly.  R3.1 ALSO printed "16" above.
;;; Its epoch was sixteen octets wide and eight octets deep: the low half was an
;;; OS-seeded draw, the high half was (universal-time XOR pid<<24) — bookkeeping,
;;; not entropy.  So the two lines above cannot tell an R3.1 epoch from an R3.2
;;; one, and a reader of the R3.1 transcript could not have caught the very
;;; defect the ruling caught.  The measurement that CAN tell them apart is the
;;; one below, and it is run against both laws in the same image.
;;;
;;; THE DISCRIMINATOR IS THE HIGH HALF UNDER REPETITION.  Within one image, in
;;; one second, with one pid, the R3.1 high half is a CONSTANT — a function of
;;; two observables that have not moved.  That is SHOWN, not argued: the term is
;;; recomputed four times from the clock and pid this image actually has, and
;;; the four are compared.  The R3.2 gatherer is then called four times and its
;;; high halves are compared the same way.
;;;
;;; THE CEILING, UNCHANGED AND UNIMPROVED BY THIS.  Four distinct draws are an
;;; OBSERVATION about a source, on this host, in this image — never a uniqueness
;;; guarantee; sixteen OS-random octets buy IMPROBABLE COLLISION and nothing
;;; more.  What is DETERMINISTIC here is the PLANTED side: the R3.1 term cannot
;;; vary within a second in a process, and that is arithmetic rather than luck.
;;; --------------------------------------------------------------------------
(arm "CLEAN" "the epoch's entropy, drawn four times from the named OS source and compared half by half")

(defun sa0-high-half (octets) (subseq octets 0 8))

(defparameter *entropy-draws* (loop repeat 4 collect (sa0-gather-epoch-octets)))
(defparameter *entropy-high-halves* (mapcar #'sa0-high-half *entropy-draws*))
(defparameter *entropy-distinct-draws*
  (length (remove-duplicates *entropy-draws* :test #'equalp)))
(defparameter *entropy-distinct-high-halves*
  (length (remove-duplicates *entropy-high-halves* :test #'equalp)))

(kv "named entropy source" *epoch-entropy-source*)
(kv "octets per draw [bound: 16]" (length (first *entropy-draws*)))
(kv "draws taken in this image" (length *entropy-draws*))
(kv "distinct draws" *entropy-distinct-draws*)
(kv "distinct HIGH halves (octets 0-7)" *entropy-distinct-high-halves*)

(probe-check "ALLOCATOR-EPOCH-SOURCE-IS-THE-OS-RANDOM-DEVICE"
             "allocator entropy [R3.2-B]: the epoch is READ FROM the named operating-system random source and nothing is mixed in — the source is PRINTED above rather than implied, and every draw is exactly sixteen (unsigned-byte 8) octets.  A short read is an ERROR rather than a padded buffer, so sixteen octets are either all present or the image has no lawful epoch"
             (and (stringp *epoch-entropy-source*)
                  (string= "/dev/urandom" *epoch-entropy-source*)
                  (= 4 (length *entropy-draws*))
                  (every (lambda (d)
                           (and (= 16 (length d))
                                (typep d '(vector (unsigned-byte 8)))))
                         *entropy-draws*)))

(probe-check "ALLOCATOR-EPOCH-HIGH-HALF-IS-ENTROPY-TOO"
             "allocator entropy [R3.2-B]: all four draws differ, AND SO DO THEIR HIGH HALVES — the eight octets that under R3.1 were a universal-time/pid mix now vary draw to draw inside one image, one second and one pid.  That is what distinguishes sixteen octets of ENTROPY from sixteen octets of REPRESENTATION carrying eight.  An observation about this source on this host, never a uniqueness guarantee"
             (and (= 4 *entropy-distinct-draws*)
                  (= 4 *entropy-distinct-high-halves*)))

(arm "PLANTED" "the R3.1 eight-plus-padding construction, named and recomputed — its high half is a CONSTANT")

;;; The R3.1 high half, reconstructed exactly: (universal-time XOR pid<<24),
;;; low 64 bits.  Nothing is guessed about it; it is the term the R3.1 file
;;; carried, computed here from the clock and pid THIS image has.
(defun sa0-r31-padding-half ()
  (logxor (ldb (byte 64 0) (get-universal-time))
          (ash (ldb (byte 32 0) (sb-posix:getpid)) 24)))

(defparameter *r31-padding-draws* (loop repeat 4 collect (sa0-r31-padding-half)))
(defparameter *r31-distinct-padding* (length (remove-duplicates *r31-padding-draws*)))

(kv "R3.1 high-half term" "(universal-time XOR pid<<24) — bookkeeping, not entropy")
(kv "R3.1 term recomputed" (length *r31-padding-draws*))
(kv "distinct R3.1 high halves" *r31-distinct-padding*)
(kv "R3.1 entropy octets of sixteen" 8)

(probe-check "ALLOCATOR-EPOCH-R31-PADDING-REFUSED-BY-NAME"
             "allocator entropy [R3.2-B]: the R3.1 construction is NAMED and shown to be exactly what the ruling called it — recomputed four times from the clock and the pid this image has, its eight-octet high half is IDENTICAL every time, so under R3.1 half the epoch carried no entropy at all while measuring sixteen octets wide.  The same repetition run against the R3.2 gatherer one arm above yields four distinct high halves; that difference IS the repair, and it is why 'eight OS-random octets plus padding' is refused by name rather than re-labelled"
             (and (= 4 (length *r31-padding-draws*))
                  (= 1 *r31-distinct-padding*)
                  (= 4 *entropy-distinct-high-halves*)))

(probe-check "ALLOCATOR-FIRST-ALLOCATION-IS-ONE"
             "allocator shape [R3.1-B]: the stored counter initializes at 0 and the FIRST allocation is 1 — measured from the minimum counter the FIRST-LOAD RACE issued, which under R3.2 is the lowest counter this image ever issued (R3.1 read it from the clean arm, which was then the image's first allocator)"
             (and *init-race-counters*
                  (= 1 (reduce #'min *init-race-counters*))
                  (= 1 (min (reduce #'min *init-race-counters*)
                            (reduce #'min (counters-of *clean-results*))))
                  (plusp *performance-counter*)))

(arm "PLANTED" "every unlawful spelling the R3.1-B shape predicate must reject")
(let* ((good-epoch *image-epoch-hex*)
       (cases (list
               (list "short epoch text (31 digits)" (subseq good-epoch 0 31) "1")
               (list "long epoch text (33 digits)"  (concatenate 'string good-epoch "a") "1")
               (list "UPPERCASE hex epoch text"     (string-upcase good-epoch) "1")
               (list "counter zero"                 good-epoch "0")
               (list "negative counter text"        good-epoch "-1")
               (list "leading-zero decimal counter" good-epoch "007")
               (list "nondecimal counter text"      good-epoch "1a")))
       (results (mapcar (lambda (c)
                          (cons (first c)
                                (performance-identifier-shape-p
                                 (performance-identifier-from-texts (second c) (third c)))))
                        cases)))
  (dolist (r results)
    (kv (format nil "  ~A" (car r)) (if (cdr r) "ACCEPTED" "REJECTED")))
  (probe-check "ALLOCATOR-SHAPE-PREDICATE-REJECTS-ALL-SEVEN"
               "allocator shape [R3.1-B]: the shape predicate REJECTS every spelling the ruling enumerates — short epoch text, long epoch text, uppercase hex, counter zero, negative counter text, leading-zero decimal and nondecimal text.  Four of the seven passed under R3, whose epoch clause asked only for a nonempty lowercase-hex string and whose counter clause asked only for a nonempty digit string: 0 and 007 were digit strings, and 31 and 33 digits were nonempty"
               (notany #'cdr results))
  (probe-check "ALLOCATOR-SHAPE-PREDICATE-ACCEPTS-THE-LAWFUL-ONE"
               "allocator shape control arm: and the LAWFUL spelling — this image's own epoch text with counter 1 — is ACCEPTED, so the seven rejections are discriminations and not a predicate that refuses everything"
               (performance-identifier-shape-p
                (performance-identifier-from-texts good-epoch "1"))))

;;; --------------------------------------------------------------------------
;;; R3.3-C — THE COUNTER ALPHABET IS ASCII, AND THE FOUR CODE POINTS THAT PROVE
;;; IT.
;;;
;;; OWNER FINDING 2: R3.2's LAWFUL-COUNTER-TEXT-P used DIGIT-CHAR-P, which on
;;; this runtime accepts non-ASCII decimal characters.  The four the ruling names
;;; are enumerated here BY CODE POINT, not by glyph, so that a reader is not
;;; asked to trust a font.  Each is shown twice: once being ACCEPTED by
;;; DIGIT-CHAR-P — which is the defect, exhibited on this exact runtime rather
;;; than argued from a manual — and once being REFUSED by the R3.3 predicate.
;;;
;;; THE MIXED SPELLING IS THE CASE THAT PROVES THE QUANTIFIER.  A predicate that
;;; only guarded the FIRST character would accept "1<U+0661>", and would still
;;; pass every single-character tooth above.  So a two-character text with an
;;; ASCII head and a non-ASCII tail is tested by name.
;;; --------------------------------------------------------------------------
(arm "PLANTED" "non-ASCII decimal digits, which DIGIT-CHAR-P accepts and R3.3-C refuses")

(let* ((good-epoch *image-epoch-hex*)
       (points '(("U+0661 ARABIC-INDIC DIGIT ONE"          #x0661)
                 ("U+06F1 EXTENDED ARABIC-INDIC DIGIT ONE" #x06F1)
                 ("U+0967 DEVANAGARI DIGIT ONE"            #x0967)
                 ("U+FF11 FULLWIDTH DIGIT ONE"             #xFF11)))
       (single (mapcar (lambda (row)
                         (list (first row)
                               (string (code-char (second row)))))
                       points))
       (mixed (list (list "mixed spelling: ASCII 1 then U+0661"
                          (coerce (list #\1 (code-char #x0661)) 'string))
                    (list "mixed spelling: ASCII 1 then U+FF11"
                          (coerce (list #\1 (code-char #xFF11)) 'string))))
       (unlawful (append single mixed))
       (accepted-by-digit-char-p
         (remove-if-not (lambda (row)
                          (every (lambda (ch) (digit-char-p ch)) (second row)))
                        unlawful))
       (results (mapcar (lambda (row)
                          (cons (first row)
                                (performance-identifier-shape-p
                                 (performance-identifier-from-texts good-epoch (second row)))))
                        unlawful)))
  (dolist (row unlawful)
    (kv (format nil "  ~A" (first row))
        (format nil "code points ~{~A~^ ~} / DIGIT-CHAR-P ~A / R3.3-C ~A"
                (map 'list (lambda (ch) (format nil "U+~4,'0X" (char-code ch)))
                     (second row))
                (if (every (lambda (ch) (digit-char-p ch)) (second row))
                    "ACCEPTS" "refuses")
                (if (lawful-counter-text-p (second row)) "ACCEPTS" "REFUSES"))))
  (kv "unlawful spellings tried" (length unlawful))
  (kv "of those, DIGIT-CHAR-P accepts" (length accepted-by-digit-char-p))

  (probe-check "ALLOCATOR-SHAPE-DIGIT-CHAR-P-ACCEPTS-NON-ASCII"
               "allocator shape [R3.3-C, the defect EXHIBITED]: on this exact SBCL runtime DIGIT-CHAR-P accepts all four code points the ruling names AND both mixed spellings — so the R3.2 predicate really did admit six alternative spellings of a counter, and this is measured here rather than taken on the ruling's word"
               (= (length unlawful) (length accepted-by-digit-char-p)))

  (probe-check "ALLOCATOR-SHAPE-PREDICATE-REJECTS-NON-ASCII-DECIMALS"
               "allocator shape [R3.3-C]: the ASCII-membership predicate REFUSES every one of them — U+0661, U+06F1, U+0967, U+FF11, and both mixed spellings whose FIRST character is a lawful ASCII digit.  The mixed cases are what prove EVERY character is restricted and not merely the first"
               (notany #'cdr results))

  (probe-check "ALLOCATOR-SHAPE-ASCII-POSITIVE-CONTROLS"
               "allocator shape control arm [R3.3-C]: and the lawful ASCII spellings are ACCEPTED — the single character \"1\" and the multi-character \"10\" — so the six refusals above are discriminations and not a predicate that refuses everything with a digit in it"
               (and (lawful-counter-text-p "1")
                    (lawful-counter-text-p "10")
                    (performance-identifier-shape-p
                     (performance-identifier-from-texts good-epoch "1"))
                    (performance-identifier-shape-p
                     (performance-identifier-from-texts good-epoch "10"))))

  ;; The shared constructor's OWN emitted counter segment, taken from a real
  ;; allocation through the shared allocator, must satisfy the same predicate.
  ;; A predicate the constructor's own output failed would be a contract the
  ;; implementation could not honour.
  (let* ((minted (multiple-value-list (mint-performance-identifier)))
         (datum (first minted))
         (counter (second minted))
         (segment (lisp-plus-cd0:identifier-datum-path-segment datum 2)))
    (kv "constructor counter segment" segment)
    (kv "constructor counter integer" counter)
    (probe-check "ALLOCATOR-SHAPE-CONSTRUCTOR-SEGMENT-IS-ASCII-DECIMAL"
                 "allocator shape [R3.3-C]: the ONE SHARED CONSTRUCTOR's own emitted counter segment satisfies the ASCII predicate, and its characters are all in 0123456789 with a nonzero head — the predicate and the producer agree, which is the check that would catch a predicate tightened past what the implementation can emit"
                 (and (stringp segment)
                      (lawful-counter-text-p segment)
                      (every (lambda (ch) (find ch "0123456789")) segment)
                      (find (char segment 0) "123456789")
                      (= counter (parse-integer segment))))))
(p "END-ALLOCATOR-SHAPE")

;;; --------------------------------------------------------------------------
(rule)
(p "CEILING, RESTATED WHERE THE NUMBERS ARE:")
(p "  The epoch is an image-epoch / entropy datum with NO cross-image uniqueness")
(p "  guarantee, and none is claimed here.  Two images' COUNTERS coincide by")
(p "  construction — allocation 1 is allocation 1 in both — and only the epoch")
(p "  segment separates their performance datums.  What is demonstrated is")
(p "  SAME-IMAGE linearizability under real thread contention, on this host, in")
(p "  this image, at this parcel tip.")

(when (plant-failure-requested-p)
  (probe-check "ALLOCATOR-PLANTED-FAULT" "PLANTED FAULT: this check is designed to fail" nil))

(probe-footer "ALLOCATOR")
(probe-exit)
