;;;; surface-account-hostile.lisp — Surface Account /0 production hostile
;;;; profiles.  ONE ROLE PER FRESH IMAGE (env SA0_PROD_ROLE), because every
;;;; role needs an image in which the production identity source has never
;;;; been loaded — the probe harness's own discipline, carried to the
;;;; product.  Driven by production/run-hostile-profiles.sh.
;;;;
;;;; Roles:
;;;;   contention        genuine concurrent FIRST load, 8 threads: one epoch,
;;;;                     one election, no partial state, allocations 1..40
;;;;                     contiguous (broad contention control + monotonic
;;;;                     allocation + observer behavior)
;;;;   recursive         genuine same-thread recursive LOAD fired at
;;;;                     :ELECTED-BEFORE-PUBLICATION; deferred owner
;;;;                     re-entry; outermost load owns the transition;
;;;;                     sequential reload afterwards continues the counter
;;;;   post-election     a condition planted at :ELECTED-BEFORE-NOTE with a
;;;;                     second loader PROVABLY parked (:BEFORE-WAIT):
;;;;                     failure published, sleeper woken and told, image
;;;;                     terminal, nothing else published
;;;;   post-publication  a condition planted at :PUBLISHED-BEFORE-RETURN:
;;;;                     state present, NO failure marker, allocator lives
;;;;   carrier           the reserved-slot and malformed-carrier hostilities
;;;;                     (NIL / duplicate / foreign / odd / dotted terminal /
;;;;                     dotted value / dotted-with-lawful-cell / circular),
;;;;                     each refused definitively inside a bound with the
;;;;                     carrier left EQ-identical; then the one lawful arm
;;;;                     LAST, over two pre-installed unrelated properties,
;;;;                     preserved verbatim by identity
;;;;   stale             the pinned two-loader schedule: both past the
;;;;                     pre-initial observation, the delayed one held across
;;;;                     the ENTIRE winning initialization, then observing
;;;;                     the winner's complete state — one epoch, one
;;;;                     election
;;;;   plist-contention  the carrier plist changed between the read and the
;;;;                     CAS (:OBSERVED-CARRIER-PLIST): the retry re-reads
;;;;                     and converges; the injected property survives by
;;;;                     identity
;;;;
;;;; Every wait and join carries a hard bound; AN EXPIRY IS A FAILURE, NEVER
;;;; A PASS.  The runner adds a process-level timeout as the backstop.
;;;; INTERNAL ACCESS, disclosed: schedule pinning uses the production
;;;; package's test gate (SA0-IDENTITY-TEST-GATE / SA0-HOOK — internal
;;;; symbols, installed by this harness exactly as the accepted probe
;;;; harness installed the oracle's), and carrier planting writes the
;;;; carrier symbol's plist BEFORE the first load, which is the hostile
;;;; precondition itself.  Behavior under test is still reached through the
;;;; load path and public entry points.
;;;;
;;;; — FABER (Claude Fable 5), R4, 2026-08-06

(in-package #:cl-user)

(defvar *here* (make-pathname :name nil :type nil :defaults *load-truename*))
(defvar *lane-root* (merge-pathnames "../../../" *here*))

;; CD/0 and the package, but NOT the identity source — the roles decide when.
(unless (find-package '#:lisp-plus-cd0)
  (load (merge-pathnames "canonical-datum/common-lisp/package.lisp" *lane-root*))
  (load (merge-pathnames "canonical-datum/common-lisp/cd0.lisp" *lane-root*)))
(unless (find-package '#:lisp-plus-surface-account)
  (load (merge-pathnames "package.lisp" *here*)))

(defvar *impl* (merge-pathnames "surface-account.lisp" *here*))
(defvar *checks* 0)
(defvar *failures* 0)
(defvar *role* (or (sb-ext:posix-getenv "SA0_PROD_ROLE") "unset"))

(defun check (description thunk)
  (incf *checks*)
  (let ((outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (c) (list :error c)))))
    (if (eq outcome :ok)
        (format t "[H~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[H~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))))

(defmacro sa0 (name &rest args)
  `(funcall (intern ,(string name) :lisp-plus-surface-account) ,@args))
(defun sa0-sym (name)
  ;; INTERN, not FIND-SYMBOL: hook-installing roles must name the gate and
  ;; carrier symbols BEFORE the implementation source has been read (that is
  ;; the point of a pre-load plant), and interning them here establishes the
  ;; exact place the reader will later resolve to — symbol identity is the
  ;; carrier design's own guarantee.
  (intern (string name) :lisp-plus-surface-account))
(defun set-hook (fn)
  (setf (get (sa0-sym '#:sa0-identity-test-gate) (sa0-sym '#:sa0-hook)) fn))
(defun carrier-sym () (sa0-sym '#:sa0-identity-carrier))
(defun indicator-sym () (sa0-sym '#:sa0-identity-cell))
(defun carrier-plist () (symbol-plist (carrier-sym)))
(defun mint-counter () (nth-value 1 (sa0 #:mint-performance-identifier)))

(defparameter *bound* 60 "hard wait bound, seconds")

(defun join! (thread)
  (sb-thread:join-thread thread :timeout *bound*))
(defun wait-sem! (sem)
  (unless (sb-thread:wait-on-semaphore sem :timeout *bound*)
    (error "semaphore wait expired after ~a s — a hang, which is a FAILURE" *bound*)))

;;; a strict N-party barrier (mutex + waitqueue)
(defstruct (barrier (:constructor %make-barrier (needed)))
  (needed 0) (arrived 0)
  (mutex (sb-thread:make-mutex)) (waitq (sb-thread:make-waitqueue)))
(defun barrier-wait (b)
  (sb-thread:with-mutex ((barrier-mutex b))
    (incf (barrier-arrived b))
    (if (>= (barrier-arrived b) (barrier-needed b))
        (sb-thread:condition-broadcast (barrier-waitq b))
        (loop until (>= (barrier-arrived b) (barrier-needed b))
              do (unless (sb-thread:condition-wait (barrier-waitq b)
                                                   (barrier-mutex b)
                                                   :timeout *bound*)
                   (error "barrier wait expired — a hang is a FAILURE"))))))

(defun load-impl () (load *impl*))

;;; ===========================================================================
(defun role-contention ()
  (let* ((n 8) (per 5)
         (gate (%make-barrier n))
         (epochs (make-array n :initial-element nil))
         (mints (make-array n :initial-element nil))
         (threads
           (loop for i below n
                 collect (let ((i i))
                           (sb-thread:make-thread
                            (lambda ()
                              (barrier-wait gate)      ; genuine concurrent FIRST load
                              (load-impl)
                              (setf (aref epochs i) (sa0 #:image-epoch-hex))
                              (setf (aref mints i)
                                    (loop repeat per collect (mint-counter))))
                            :name (format nil "sa0-r4-loader-~d" i))))))
    (mapc #'join! threads)
    (check "all 8 concurrent first loaders completed inside the bound"
           (lambda () t))
    (check "all 8 loaders observed ONE epoch (identical text)"
           (lambda () (= 1 (length (remove-duplicates (coerce epochs 'list)
                                                      :test #'string=)))))
    (check "epoch-gatherings = 1 after an 8-way first-load race"
           (lambda () (= 1 (sa0 #:epoch-gatherings))))
    (check "election-count = 1 (seven losers installed nothing)"
           (lambda () (= 1 (sa0 #:election-count))))
    (check "8 x 5 allocations are exactly 1..40 — no gap, no repeat"
           (lambda ()
             (let ((all (sort (reduce #'append (coerce mints 'list)) #'<)))
               (equal all (loop for k from 1 to 40 collect k)))))
    (check "identity-ready-p and the shape law hold after the race"
           (lambda ()
             (and (sa0 #:identity-ready-p)
                  (sa0 #:performance-identifier-shape-p
                       (sa0 #:mint-performance-identifier)))))))

;;; ===========================================================================
(defun role-recursive ()
  (let ((fired nil) (inner-outcome nil) (depth 0))
    (set-hook
     (lambda (phase)
       (when (and (eq phase :elected-before-publication) (zerop depth))
         (incf depth)
         (setf fired (list :ready-at-hook (sa0 #:identity-ready-p)))
         ;; the genuine recursive load, same thread, once
         (load-impl)
         ;; and the same re-entry through the public door, to capture the
         ;; verdict the recursive load's top-level call discards
         (setf inner-outcome (sa0 #:initialize-image-identity)))))
    (load-impl)
    (set-hook nil)
    (check "hook fired inside the winner's initialization, BEFORE publication (ready was NIL there)"
           (lambda () (equal fired '(:ready-at-hook nil))))
    (check "the recursive inner initialize returned :DEFERRED-OWNER-REENTRY (no wait, no self-deadlock)"
           (lambda () (eq inner-outcome :deferred-owner-reentry)))
    (check "the outermost load owned the sole transition to ready"
           (lambda () (sa0 #:identity-ready-p)))
    (check "one epoch gathering, one election — the re-entry gathered nothing"
           (lambda () (and (= 1 (sa0 #:epoch-gatherings))
                          (= 1 (sa0 #:election-count)))))
    (check "first allocation after the recursive load is 1"
           (lambda () (= 1 (mint-counter))))
    (let ((epoch (sa0 #:image-epoch-hex)))
      (load-impl)                       ; ordinary sequential reload
      (check "a later ordinary reload preserves the epoch and continues the counter to 2"
             (lambda () (and (string= epoch (sa0 #:image-epoch-hex))
                            (= 2 (mint-counter))
                            (= 1 (sa0 #:epoch-gatherings))))))))

;;; ===========================================================================
(defun role-post-election ()
  (let* ((sem-b-go (sb-thread:make-semaphore))
         (sem-b-parked (sb-thread:make-semaphore))
         (loader-a-error nil) (loader-b-error nil))
    (set-hook
     (lambda (phase)
       (case phase
         (:elected-before-note
          ;; the first instant after a won election: release the observer,
          ;; wait until it has PROVABLY parked, then blow up in the exact
          ;; interval the R3.3 return named.
          (sb-thread:signal-semaphore sem-b-go)
          (wait-sem! sem-b-parked)
          (error "SA0-R4 planted post-election condition"))
         (:before-wait
          ;; the observer holds the cell mutex and its next act is
          ;; CONDITION-WAIT; signalling here (never blocking) proves the park.
          (sb-thread:signal-semaphore sem-b-parked)))))
    (let ((ta (sb-thread:make-thread
               (lambda () (handler-case (load-impl)
                            (error (c) (setf loader-a-error c))))
               :name "sa0-r4-winner"))
          (tb (sb-thread:make-thread
               (lambda ()
                 (wait-sem! sem-b-go)
                 (handler-case (sa0 #:initialize-image-identity)
                   (error (c) (setf loader-b-error c))))
               :name "sa0-r4-observer")))
      (join! ta) (join! tb))
    (set-hook nil)
    (check "the winner's load surfaced the planted condition"
           (lambda () (and loader-a-error
                          (search "planted post-election"
                                  (princ-to-string loader-a-error)))))
    (check "the parked observer was WOKEN AND TOLD inside the bound (definitive failure, not a hang)"
           (lambda () (and loader-b-error
                          (search "initialization failed before publication"
                                  (princ-to-string loader-b-error)))))
    (check "the failure is published; NO state, NO readiness"
           (lambda () (not (sa0 #:identity-ready-p))))
    (check "nothing was noted or gathered in the named interval (0 elections, 0 gatherings)"
           (lambda () (and (= 0 (sa0 #:election-count))
                          (= 0 (sa0 #:epoch-gatherings)))))
    (check "the image is TERMINAL: a fresh same-thread attempt signals the same failure, elects nothing"
           (lambda ()
             (handler-case (progn (sa0 #:initialize-image-identity) nil)
               (error (c) (search "initialization failed before publication"
                                  (princ-to-string c))))))
    (check "…and a brand-new thread gets the same definitive answer, no hang"
           (lambda ()
             (let ((verdict nil))
               (join! (sb-thread:make-thread
                       (lambda ()
                         (handler-case (sa0 #:initialize-image-identity)
                           (error (c) (setf verdict (princ-to-string c)))))))
               (and verdict (search "initialization failed before publication" verdict)))))
    ;; R4.1 (closing STRANGER's finding): the old form of this check called
    ;; IMAGE-EPOCH-HEX and accepted ANY error — but in this image that
    ;; function is UNBOUND (the failed load aborted at the mid-file
    ;; initialization form, before the five later exports were defined), so
    ;; the check was witnessed by an UNDEFINED-FUNCTION accident, not by the
    ;; mechanism.  The two checks below witness the true facts:
    (check "the half-load is VISIBLE: the loader-grade completeness predicate (:EXTERNAL + FBOUNDP + carrier, R4.3) reports the lane incomplete — 5 post-init exports unbound though all nine are :EXTERNAL and the carrier is present"
           (lambda ()
             (let ((package (find-package :lisp-plus-surface-account))
                   (late '("IMAGE-EPOCH-HEX" "IMAGE-EPOCH-DATUM"
                           "MINT-PERFORMANCE-IDENTIFIER"
                           "PERFORMANCE-IDENTIFIER-SHAPE-P"
                           "LAWFUL-COUNTER-TEXT-P"))
                   (early '("INITIALIZE-IMAGE-IDENTITY" "IDENTITY-READY-P"
                            "EPOCH-GATHERINGS" "ELECTION-COUNT")))
               (flet ((complete-name-p (n)
                        ;; the loader-grade per-name clause, reproduced:
                        ;; :EXTERNAL status AND FBOUNDP (R4.3)
                        (multiple-value-bind (s status) (find-symbol n package)
                          (and s (eq status :external) (fboundp s)))))
                 (and package
                      ;; in THIS half-load every name is :EXTERNAL (package.lisp
                      ;; completed) and the carrier is present (interned by the
                      ;; forms before the failing initialization) — so it is the
                      ;; FBOUNDP clause, not the status clause, that convicts:
                      (every (lambda (n)
                               (eq :external
                                   (nth-value 1 (find-symbol n package))))
                             (append early late))
                      (find-symbol "SA0-IDENTITY-CARRIER" package)
                      ;; exactly the five post-init exports are unbound…
                      (notany #'complete-name-p late)
                      ;; …the four pre-init exports are complete…
                      (every #'complete-name-p early)
                      ;; …so the loader-grade completeness predicate is FALSE.
                      (not (every #'complete-name-p (append early late))))))))
    (check "a later LOADER is refused by the MECHANISM'S definitive failure — the completeness-guarded load.lisp (:EXTERNAL + FBOUNDP + carrier) re-signals SURFACE-ACCOUNT/0's terminal refusal, never a silent no-op and never an UNDEFINED-FUNCTION accident"
           (lambda ()
             (let ((outcome
                     (handler-case
                         (progn (load (merge-pathnames "load.lisp" *here*))
                                :silent-success)
                       (undefined-function () :undefined-function)
                       (error (c) (princ-to-string c)))))
               (and (stringp outcome)
                    (search "initialization failed before publication" outcome)
                    t))))))

;;; ===========================================================================
(defun role-post-publication ()
  (let ((load-error nil))
    (set-hook
     (lambda (phase)
       (when (eq phase :published-before-return)
         (error "SA0-R4 planted post-publication condition"))))
    (handler-case (load-impl)
      (error (c) (setf load-error c)))
    (set-hook nil)
    ;; the planted condition aborted the LOAD at the mid-file initialization
    ;; form, so the definitions after it (the allocator, the constructor)
    ;; never arrived.  A lawful RELOAD completes them — and is itself a
    ;; witness: it must OBSERVE the already-published state, gathering
    ;; nothing (checked below with the state's own counts).  The reload is
    ;; GUARDED so that a diseased candidate whose cleanup overwrote the
    ;; publication (the finality-regression comparator) fails the NAMED
    ;; checks below instead of killing the image before they run; in a
    ;; healthy candidate the reload succeeds and the guard is inert.
    (handler-case (load-impl) (error () nil))
    (check "the planted condition surfaced from the load"
           (lambda () (and load-error
                          (search "planted post-publication"
                                  (princ-to-string load-error)))))
    (check "the STATE is present and readiness holds — publication was final"
           (lambda () (sa0 #:identity-ready-p)))
    (check "NO failure marker exists beside the state (one disposition slot: the cleanup's CAS could not land)"
           (lambda ()
             ;; internal, disclosed: read the cell's failure through the same
             ;; one-slot readers the mechanism uses
             (let ((cell (funcall (sa0-sym '#:sa0-carrier-cell))))
               (and cell
                    (null (funcall (sa0-sym '#:sa0-cell-failure) cell))
                    (funcall (sa0-sym '#:sa0-cell-state) cell)
                    t))))
    (check "one gathering, one election, and the allocator lives (first mint = 1)"
           (lambda () (and (= 1 (sa0 #:epoch-gatherings))
                          (= 1 (sa0 #:election-count))
                          (= 1 (mint-counter)))))))

;;; ===========================================================================
(defun expect-carrier-refusal (label plant &key (substring "SURFACE-ACCOUNT/0:"))
  "Install PLANT as the carrier's plist, attempt the first load, require the
definitive bounded refusal carrying SUBSTRING, and require the plist left
EQ-identical.  Read-only refusal: no election, no gathering, no readiness."
  (setf (symbol-plist (carrier-sym)) plant)
  (let ((refusal nil))
    (handler-case (load-impl)
      (error (c) (setf refusal (princ-to-string c))))
    (check (format nil "~a: refused definitively with the production refusal text" label)
           (lambda () (and refusal (search substring refusal))))
    (check (format nil "~a: the carrier plist is left EQ-identical (rejection is not repair)" label)
           (lambda () (eq plant (carrier-plist))))
    (check (format nil "~a: no election after the refusal, and EVERY reader is refused by the same path" label)
           (lambda () (and (= 0 (sa0 #:election-count))
                          ;; on a rejected carrier the readers refuse too —
                          ;; identity-ready-p goes through the one adjudicating
                          ;; reader, so it must SIGNAL here, not answer NIL
                          (handler-case (progn (sa0 #:identity-ready-p) nil)
                            (error () t)))))))

(defun role-carrier ()
  ;; (a) reserved indicator PRESENT with NIL value.  THE INDICATOR IS
  ;; SA0-IDENTITY-CELL — the reserved property ON the carrier symbol, a
  ;; different symbol from the carrier itself (the first draft of this role
  ;; planted the carrier symbol as its own indicator and thereby planted
  ;; only an unrelated property; the mechanism lawfully elected over it,
  ;; which is exactly what the total-election law says it must do).
  (expect-carrier-refusal "NIL-valued indicator"
                          (list (indicator-sym) nil)
                          :substring "PRESENT with a NIL value")
  ;; (b) duplicate reserved entries
  (expect-carrier-refusal "duplicate indicators"
                          (list (indicator-sym) 41 (indicator-sym) 42)
                          :substring "occurs 2 times")
  ;; (c) foreign value
  (expect-carrier-refusal "foreign value"
                          (list (indicator-sym) 42)
                          :substring "not a lawful election cell")
  ;; (d) odd list (indicator with no value)
  (expect-carrier-refusal "odd list"
                          (list 'unrelated "kept" (indicator-sym))
                          :substring "no value")
  ;; (e) improper (dotted) terminal tail
  (expect-carrier-refusal "dotted terminal tail"
                          (cons 'unrelated (cons "kept" 'dotted-tail))
                          :substring "non-NIL atom")
  ;; (f) dotted VALUE position
  (expect-carrier-refusal "dotted value position"
                          (cons 'unrelated "kept")
                          :substring "value position")
  ;; (g) improper list CARRYING one otherwise-lawful reserved cell
  (let ((cell (funcall (sa0-sym '#:make-sa0-identity-cell)
                       sb-thread:*current-thread*)))
    (expect-carrier-refusal "dotted list carrying a lawful-shaped reserved cell"
                            (cons (indicator-sym) (cons cell 'dotted-tail))
                            :substring "non-NIL atom"))
  ;; (h) circular carrier — refusal must be BOUNDED (the total walk's cycle case)
  (let ((circ (list 'unrelated "kept")))
    (setf (cddr circ) circ)
    (expect-carrier-refusal "circular carrier" circ :substring "CIRCULAR"))
  ;; ---- the one lawful arm, LAST (it spends the image's one first-init
  ;; moment), over two pre-installed unrelated properties ----
  (let* ((marker-1 "kept-verbatim") (marker-2 (list :opaque 42))
         (pre (list 'unrelated-a marker-1 'unrelated-b marker-2)))
    (setf (symbol-plist (carrier-sym)) pre)
    (load-impl)
    (check "lawful arm after 8 refusals: ready, ONE election, ONE gathering (refusals spent nothing)"
           (lambda () (and (sa0 #:identity-ready-p)
                          (= 1 (sa0 #:election-count))
                          (= 1 (sa0 #:epoch-gatherings)))))
    (check "both unrelated properties survive VERBATIM BY EQ"
           (lambda () (and (eq marker-1 (getf (carrier-plist) 'unrelated-a))
                          (eq marker-2 (getf (carrier-plist) 'unrelated-b)))))
    (check "the winning plist's TAIL IS the pre-installed plist object itself (identity, not copy)"
           (lambda () (eq pre (cddr (carrier-plist)))))
    (check "allocations proceed: 1..5 contiguous"
           (lambda () (equal (loop repeat 5 collect (mint-counter))
                             '(1 2 3 4 5))))))

;;; ===========================================================================
(defun role-stale ()
  (let* ((gate (%make-barrier 2))
         (sem-go (sb-thread:make-semaphore))
         (t2-thread nil)
         (epoch-1 nil) (epoch-2 nil))
    (declare (ignorable t2-thread))
    (set-hook
     (lambda (phase)
       (when (eq phase :observed-pre-initial)
         (barrier-wait gate)            ; both loaders past pre-initial observation
         ;; identify the delayed loader by its NAME — thread-object identity
         ;; would race the binding of T2-THREAD against T2's own progress
         (when (equal "sa0-r4-stale-delayed"
                      (sb-thread:thread-name sb-thread:*current-thread*))
           (wait-sem! sem-go)))))       ; the delayed loader, held across the
                                        ; ENTIRE winning initialization
    (let ((t1 (sb-thread:make-thread
               (lambda () (load-impl) (setf epoch-1 (sa0 #:image-epoch-hex)))
               :name "sa0-r4-stale-winner")))
      (setf t2-thread (sb-thread:make-thread
                       (lambda () (load-impl) (setf epoch-2 (sa0 #:image-epoch-hex)))
                       :name "sa0-r4-stale-delayed"))
      (join! t1)                        ; the winning initialization is COMPLETE
      (sb-thread:signal-semaphore sem-go)
      (join! t2-thread))
    (set-hook nil)
    (check "both loaders completed; the delayed one crossed a COMPLETED initialization"
           (lambda () (and epoch-1 epoch-2)))
    (check "the delayed loader observed the winner's exact state (same epoch text)"
           (lambda () (string= epoch-1 epoch-2)))
    (check "one election, one gathering — the delayed loader installed and erased NOTHING"
           (lambda () (and (= 1 (sa0 #:election-count))
                          (= 1 (sa0 #:epoch-gatherings)))))
    (check "subsequent allocations are 1..10 contiguous"
           (lambda () (equal (loop repeat 10 collect (mint-counter))
                             '(1 2 3 4 5 6 7 8 9 10))))))

;;; ===========================================================================
(defun role-plist-contention ()
  (let ((injections 0) (marker (list :injected-mid-election))
        (pre-compare-firings 0))
    (set-hook
     (lambda (phase)
       (when (eq phase :observed-carrier-plist)
         (incf pre-compare-firings)
         (when (zerop injections)
           (incf injections)
           ;; change the plist in the exact window between the read and the
           ;; CAS against it — the retry path's cause, and nothing else
           (setf (symbol-plist (carrier-sym))
                 (list* 'injected marker (symbol-plist (carrier-sym))))))))
    (load-impl)
    (set-hook nil)
    (check "the pre-compare phase fired exactly twice: one defeated CAS, one converged retry"
           (lambda () (= 2 pre-compare-firings)))
    (check "the election CONVERGED: ready, one election, one gathering"
           (lambda () (and (sa0 #:identity-ready-p)
                          (= 1 (sa0 #:election-count))
                          (= 1 (sa0 #:epoch-gatherings)))))
    (check "the mid-election property survives VERBATIM BY EQ"
           (lambda () (eq marker (getf (carrier-plist) 'injected))))
    (check "the winning plist's tail carries the injected object by identity"
           (lambda () (eq marker (getf (cddr (carrier-plist)) 'injected))))
    (check "allocations proceed from 1"
           (lambda () (= 1 (mint-counter))))))

;;; ===========================================================================

(let ((role (intern (string-upcase (format nil "role-~a" *role*)) :cl-user)))
  (if (fboundp role)
      (funcall role)
      (progn (format t "!! unknown SA0_PROD_ROLE ~s~%" *role*)
             (sb-ext:exit :code 2))))

(format t "~%surface-account-hostile[~a]: ~D checks, ~D failures~%"
        *role* *checks* *failures*)
(sb-ext:exit :code (if (zerop *failures*) 0 1))
