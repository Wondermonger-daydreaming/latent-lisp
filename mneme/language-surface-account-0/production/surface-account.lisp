;;;; surface-account.lisp — Surface Account /0, production implementation.
;;;;
;;;; ==========================================================================
;;;; R4 PRODUCTION SOURCE — the accepted R3.3.3 identity mechanism, extracted
;;;; conservatively from probes/probe-identity.lisp at tip 2c1ac711.  The
;;;; probe file is the executable oracle; this file is that mechanism given a
;;;; package and an address, and NOTHING ELSE.  The complete probe->production
;;;; delta is enumerated in ../R4/R4-PRODUCTION-DESIGN-LEDGER.md (D1-D6) and
;;;; is proven byte-honest by the extraction script recorded there; do not
;;;; edit this file without re-deriving that correspondence.
;;;;
;;;; THE MECHANISM (accepted and frozen as an executable contract; see the
;;;; oracle's own header for the full R3.3->R3.3.3 history, which is not
;;;; duplicated here):
;;;;   * one process-wide identity state, carried on the property list of the
;;;;     interned symbol SA0-IDENTITY-CARRIER (established by interning,
;;;;     always bound, CAS-able, written by exactly ONE CAS in this source —
;;;;     grep this file for SYMBOL-PLIST);
;;;;   * exactly one epoch gathering: sixteen octets from /dev/urandom, one
;;;;     lowercase-hex textual projection;
;;;;   * a single DISPOSITION slot: the complete state and the failure token
;;;;     compete by CAS-from-NIL for ONE place — state-present and
;;;;     failure-present are mutually exclusive by construction;
;;;;   * reserved-slot adjudication by a TOTAL read-only shape walk
;;;;     (SA0-SCAN-RESERVED: lawful NIL end / improper terminal atom / odd
;;;;     list / dotted value position / cycle, EQ-identity visited set);
;;;;   * a total election preserving unrelated carrier properties by identity;
;;;;   * bounded owner re-entry (EQ on the owning thread), terminal failure,
;;;;     waiting observers under a hard bound;
;;;;   * a mutex-linearizable allocator (counter starts 0, first allocation 1)
;;;;     and the ONE performance-identifier constructor
;;;;     ("performance" <epoch-hex> <counter-decimal>);
;;;;   * the canonical ASCII decimal counter alphabet (R3.3-C): explicit
;;;;     FIND/EQL membership in 0123456789, first character from 123456789 —
;;;;     DIGIT-CHAR-P, Unicode numeric properties, locale classification and
;;;;     PARSE-INTEGER-as-admission rejected by name;
;;;;   * NO DEFSTRUCT and NO DEFINE-CONDITION (the concurrent
;;;;     layout-redefinition scar — this source is loadable concurrently by
;;;;     design); refusals are plain errors with exact greppable text;
;;;;   * no defining form carries live once-only state (the delayed-DEFGLOBAL
;;;;     scar): the carrier and the election log live on interned symbols'
;;;;     property lists, the test hook on a third.  (The carrier-writer
;;;;     census — one CAS, no SETF — is checked mechanically by the hostile
;;;;     runner's ST-1; a bare grep of this file for SYMBOL-PLIST also hits
;;;;     the election-log symbol and two comments, so use ST-1's grep, not a
;;;;     bare one, to reproduce the count.)
;;;;
;;;; LOAD-TIME BEHAVIOUR — READ THIS BEFORE GUARDING A LOAD OF THIS FILE.
;;;; The once-only initialization runs at load time from a form that sits
;;;; MID-FILE — at line 1059 of 1217, column-0
;;;; top-level form 43 of 57 (both censuses
;;;; MACHINE-DERIVED by R4/extract-production.py from this very file at
;;;; generation time; a hand-written coordinate here went stale once,
;;;; R4.2) — the oracle-faithful placement, carried
;;;; verbatim under ledger delta D6, with several public functions
;;;; (IMAGE-EPOCH-HEX, IMAGE-EPOCH-DATUM, MINT-PERFORMANCE-IDENTIFIER,
;;;; PERFORMANCE-IDENTIFIER-SHAPE-P, LAWFUL-COUNTER-TEXT-P) defined AFTER
;;;; it.  Consequence (STRANGER's R4 finding): a load that fails AT the
;;;; initialization leaves the package present with those five exports
;;;; unbound, so "the package exists" NEVER means "this lane is loaded" —
;;;; and FBOUNDP alone never means "this is the public API" either (the
;;;; owner's R4.3 counterexample: nine INTERNAL fbound dummies satisfied
;;;; the R4.1 status-blind guard).  Every loader of this lane must
;;;; therefore guard on EXTERNAL-API completeness — every declared name
;;;; present with FIND-SYMBOL status :EXTERNAL and FBOUNDP, and the
;;;; identity carrier symbol present — repairing an incomplete package by
;;;; re-applying package.lisp BEFORE this file, and asserting the same
;;;; predicate after the load, as production/load.lisp and the umbrella's
;;;; SURFACE-ACCOUNT-API-COMPLETE-P row do (R4.3).  A fresh image gathers;
;;;; a reload observes (same epoch, counter continues); a recursive load
;;;; inside an unfinished initialization defers to its owner; a failed
;;;; image is terminal — and in a terminal image the five late exports
;;;; never become defined, which is exactly why the guarded loaders refuse
;;;; rather than certify.
;;;;
;;;; BOUNDARY: qualified external CD/0 symbols only; no other provider is
;;;; touched.  Supported: SBCL 2.4.6 on Linux, nothing else tested.
;;;; ==========================================================================

(in-package #:lisp-plus-surface-account)

(defvar *account-identity-namespace* '("lisp-plus-surface-account"))

;;; --------------------------------------------------------------------------
;;; THE IMAGE EPOCH — entropy octets gathered ONCE, and its ONE textual
;;; projection.
;;;
;;; The contract's weaker true claim is restated where the value is made: this
;;; is an IMAGE-EPOCH / ENTROPY datum with NO cross-image uniqueness guarantee.
;;; Two images' epochs are distinct only as far as entropy makes collision
;;; improbable, and improbable is not a guarantee.
;;; --------------------------------------------------------------------------

(defparameter *epoch-octets* 16
  "R3.1-B binds the epoch representation EXACTLY: sixteen octets.")
(defparameter *epoch-hex-length* 32
  "R3.1-B binds the epoch TEXT exactly: thirty-two LOWERCASE hexadecimal
digits, which is the one textual projection of those sixteen octets.")

(defparameter *epoch-entropy-source* "/dev/urandom"
  "R3.2-B: THE OPERATING SYSTEM'S RANDOM SOURCE, NAMED.  The epoch is not
derived, not padded and not mixed with bookkeeping; it is read from here.")

(defun sa0-gather-epoch-octets ()
  "EXACTLY SIXTEEN OCTETS READ FROM THE OPERATING SYSTEM'S RANDOM SOURCE, and
nothing else is mixed in.  Called at most ONCE per running image, from inside
the synchronized initialization below.

Returns a fresh (UNSIGNED-BYTE 8) vector of length sixteen.  A short read is an
ERROR, not a silently padded buffer: sixteen octets are either all present or
the image has no lawful epoch, and the second case must stop the run rather
than produce a weaker epoch that still measures as sixteen octets long.

WHAT R3.2-B ORDERED AND WHAT IT REPLACED, disclosed rather than quietly edited.
R3.1 built the epoch as

    (logxor universal-time (ash pid 24))   ||   (random 2^64 (make-random-state t))

— sixteen octets of REPRESENTATION carrying EIGHT octets' worth of OS-seeded
entropy, the other eight being a universal-time/pid mix, which is bookkeeping.
The R3.1 docstring said so, and saying so was not enough: the ruling requires
sixteen ACTUAL entropy octets, so the time/pid half is DELETED rather than
re-labelled.  Nothing is padded and nothing is derived from the clock or from
the process id.  The prior defect this chain already carried is kept on the
record because it is the reason the source is named rather than assumed: the R2
witness drew through (SB-EXT:SEED-RANDOM-STATE NIL), which is DETERMINISTIC —
two draws from two such states return the identical integer in every image — so
that epoch's entire variability was the time/pid term.

THE CLAIMS CEILING IS UNCHANGED AND UNIMPROVED BY THIS.  Sixteen OS-random
octets buy IMPROBABLE COLLISION, never a uniqueness guarantee, and no
cross-image uniqueness is claimed anywhere in this lane."
  (let ((buffer (make-array 16 :element-type '(unsigned-byte 8)))
        (read-count 0))
    (with-open-file (stream *epoch-entropy-source*
                            :direction :input
                            :element-type '(unsigned-byte 8))
      (setf read-count (read-sequence buffer stream)))
    (unless (= 16 read-count)
      (error "SURFACE-ACCOUNT/0: ~A returned ~D octet(s), not 16; no lawful image epoch"
             *epoch-entropy-source* read-count))
    buffer))

(defun sa0-octets-to-lower-hex (octets)
  "The one textual projection: two LOWERCASE hexadecimal digits per octet,
written character by character so that no printer variable, no locale and no
case-folding step stands between the octets and their text."
  (let ((digits "0123456789abcdef")
        (out (make-string (* 2 (length octets)))))
    (loop for octet across octets
          for position from 0 by 2
          do (setf (char out position)       (char digits (ash octet -4))
                   (char out (1+ position))  (char digits (logand octet #x0f))))
    out))

;;; --------------------------------------------------------------------------
;;; THE COMPLETE IMAGE-IDENTITY STATE — ONE OBJECT, BUILT PRIVATELY, PUBLISHED
;;; ONCE (R3.3-A clauses 2 and 3).
;;;
;;; R3.2 published five separate cells (epoch text, epoch datum, allocator
;;; mutex, counter, flag) and relied on the order in which one thread wrote them
;;; while another read them.  R3.3 publishes ONE immutable record.  There is no
;;; observable mixture of two initialization attempts because there is nothing
;;; to mix: an observer either sees NIL, or sees a complete state whose every
;;; component was constructed before any of it was reachable.
;;;
;;; COUNTER is the one mutable slot, and it is mutated only under
;;; ALLOCATOR-MUTEX, which is a slot of the same record — so "one counter" and
;;; "one allocator mutex" are not two facts to be separately guaranteed; they
;;; are one object's two slots.
;;; --------------------------------------------------------------------------

;;; WHY A SIMPLE VECTOR AND NOT A DEFSTRUCT — a real SBCL 2.4.6 constraint,
;;; found by running this file rather than by reading it, and recorded here so
;;; that nobody "tidies" it back.  THIS SOURCE IS LOADED CONCURRENTLY BY DESIGN
;;; (the allocator witness races eight first loads of it, and the R3.3 teeth
;;; race two).  A DEFSTRUCT re-evaluated by one thread while another thread is
;;; inside the same redefinition makes SBCL 2.4.6 signal
;;;
;;;     shouldn't happen: weird state of OLD-LAYOUT?
;;;
;;; — an internal error from the layout-redefinition machinery, reproduced in
;;; this lane with eight concurrent loaders, and it kills the loader that draws
;;; it.  A SIMPLE VECTOR has no class and no layout, so a concurrent re-load
;;; re-evaluates nothing but DEFUNs.  The slots are still exactly as named: the
;;; accessors below are the only place an index appears, and (SVREF v i) is a
;;; documented SBCL compare-and-swappable place, which the publication point
;;; requires.
;;;
;;;     STATE  #(tag epoch-octets epoch-hex epoch-datum allocator-mutex counter)
;;;              0    1            2         3           4               5

(defun make-sa0-identity-state (octets hex datum allocator-mutex)
  (vector 'sa0-identity-state octets hex datum allocator-mutex 0))

(defun sa0-identity-state-p (x)
  (and (simple-vector-p x) (= 6 (length x)) (eq 'sa0-identity-state (svref x 0))))

(defun sa0-state-epoch-octets    (s) (svref s 1))
(defun sa0-state-epoch-hex       (s) (svref s 2))
(defun sa0-state-epoch-datum     (s) (svref s 3))
(defun sa0-state-allocator-mutex (s) (svref s 4))
(defun sa0-state-counter         (s) (svref s 5))
(defun (setf sa0-state-counter) (new s) (setf (svref s 5) new))

;;; --------------------------------------------------------------------------
;;; THE ELECTION CELL, and THE CARRIER.
;;;
;;; THE CARRIER IS  (SYMBOL-PLIST 'SA0-IDENTITY-CARRIER).  Four properties make
;;; it the one place in this image that a delayed defining write cannot reach,
;;; and each is a fact about SBCL 2.4.6 or about this source, not an adjective:
;;;
;;;   1. it is ESTABLISHED BY INTERNING, not by evaluation.  The symbol
;;;      SA0-IDENTITY-CARRIER is interned by the READER when this form is read,
;;;      and a freshly interned symbol's property list is NIL.  No load-time
;;;      operation has to run for the place to exist and be readable.
;;;   2. it is ALWAYS BOUND.  There is no unbound state for a property list,
;;;      hence no unbound-to-bound transition, hence no unbound TEST that could
;;;      be separated from its WRITE.  The entire defect class of FINDING 1 is
;;;      about that separation, and this place has no such transition to
;;;      separate.
;;;   3. it is a documented SBCL COMPARE-AND-SWAPPABLE place:
;;;      (SB-EXT:CAS (SYMBOL-PLIST symbol) old new) is atomic against every
;;;      other CAS on the same place.  (Verified live on SBCL 2.4.6 before this
;;;      design was chosen, not assumed from documentation.)
;;;   4. THIS SOURCE CONTAINS NO FORM THAT WRITES IT EXCEPT THE ONE CAS BELOW.
;;;      That is the load-bearing clause and it is mechanically checkable: grep
;;;      this file for SYMBOL-PLIST.  There is no DEFVAR, DEFGLOBAL,
;;;      DEFPARAMETER, DEFCONSTANT or SETF whose place is that property list, so
;;;      there is no delayed initializer that could erase an installed cell.
;;;
;;; THE ORDERING RELATION, stated exactly — AND R3.3.1 RESTATES IT, because the
;;; R3.3 spelling of this paragraph described a mechanism with a hole in it.
;;;
;;; WHAT R3.3 DID AND WHY THE OWNER RETURNED IT.  R3.3's election was
;;;
;;;     (sb-ext:cas (symbol-plist 'sa0-identity-carrier) NIL <new plist>)
;;;
;;; — a compare against the ENTIRE PROPERTY LIST, with OLD = NIL.  That is a
;;; wager that the carrier symbol's plist is empty, and the code around it only
;;; ever CHECKED ONE PROPERTY.  A carrier symbol that already carries ANY
;;; unrelated property — one line of instrumentation, one debugger annotation,
;;; one SETF of an unrelated GET anywhere in the image — makes the compare fail
;;; FOREVER: the loop reads the plist, finds no cell under the reserved
;;; indicator, attempts a CAS from NIL that cannot succeed, falls through, and
;;; reads again.  Nothing advances.  Initialization spins for the life of the
;;; image.  The property tested and the property compared were not the same
;;; property, and the mismatch has, in the owner's words, surprisingly
;;; carnivorous teeth.
;;;
;;; R3.3.1 MAKES THE ELECTION TOTAL (the ruling's preferred arm, chosen over
;;; "fail immediately on an invalid reserved carrier" and argued in
;;; SA0-INSTALL-CARRIER below).  The competing writes to the carrier are: the
;;; CAS in SA0-INSTALL-CARRIER, and nothing else in this source.  Each such CAS
;;; carries as its OLD value THE EXACT PLIST OBJECT THIS CALL JUST READ AND
;;; FOUND TO CARRY NO RESERVED INDICATOR, and as its NEW value that same object
;;; with the reserved indicator CONSED ON THE FRONT.  So:
;;;
;;;   * a successful CAS transitions the plist from a state with NO reserved
;;;     indicator to a state WITH one, and nothing in this source ever removes
;;;     it — therefore the absent-to-present transition happens EXACTLY ONCE in
;;;     the life of the image, and the winner's cell is the unique cell;
;;;
;;;     R3.3.2 MAKES THAT CLAUSE TRUE, WHICH IT WAS NOT.  "Found to carry no
;;;     reserved indicator" was decided by (GETF observed 'SA0-IDENTITY-CELL)
;;;     against a NIL default, so a plist that ALREADY carried the indicator
;;;     with a NIL value answered "absent" and the CAS prepended A SECOND
;;;     indicator — one absent-to-present transition claimed, two indicators
;;;     installed, and the claim above falsified by the very compare that was
;;;     supposed to establish it.  The reserved slot is now read by
;;;     SA0-SCAN-RESERVED, which COUNTS occurrences and never consults a value,
;;;     and a nonzero count is adjudicated rather than overwritten.  The CAS is
;;;     therefore reached only when the count is ZERO, which is the precondition
;;;     the clause always assumed;
;;;   * every unrelated property present at that instant is preserved VERBATIM
;;;     and by IDENTITY, because the new plist's TAIL IS the old plist object
;;;     itself, not a copy of it;
;;;   * a call that loses observes the reserved indicator on a later read and
;;;     installs nothing.
;;;
;;; THE CEILING, since this is an EQ-compare on a mutable place: the argument
;;; above assumes THE WRITERS THIS SOURCE KNOWS ABOUT.  A foreign agent that
;;; restored the carrier's plist to an EQ-identical earlier object, or that
;;; deleted the reserved indicator, would defeat it — and no CAS discipline
;;; whatever can survive an agent that rewrites the place it guards.  That is
;;; stated, not defended.
;;;
;;; THE SECOND PUBLICATION POINT is the cell's DISPOSITION slot, also written by
;;; CAS with OLD = NIL, and only by the thread that won the carrier CAS.  So the
;;; complete state is installed exactly once, by one thread, into a place whose
;;; only other writer would have to have won an election that has already been
;;; won.
;;;
;;; R3.3.2: AND THE FAILURE TOKEN IS WRITTEN INTO THAT SAME SLOT, BY THE SAME
;;; KIND OF CAS FROM NIL.  Publication and the confession of non-publication now
;;; compete for ONE place, so "a state was published" and "initialization failed
;;; before publication" cannot both be true of one cell — not because a reader
;;; consults them in a lucky order, but because the second write of the pair
;;; cannot land.
;;;
;;; WHY A CELL AND NOT THE STATE DIRECTLY.  The winner must gather sixteen
;;; octets from the operating system before it can build the state, and that
;;; takes time during which other loaders must be told "someone owns this, wait"
;;; rather than "nothing is here, elect yourself".  The cell IS that claim.  It
;;; also carries the OWNER thread, which is what makes true same-thread
;;; re-entry detectable without a lock that the owner would deadlock on.
;;; --------------------------------------------------------------------------

;;; THE CELL, on the same simple-vector discipline and for the same reason.
;;;
;;;     CELL  #(tag owner mutex waitq disposition gather-marks)
;;;             0   1     2     3     4           5
;;;
;;;   DISPOSITION (4)  THE ONE PUBLICATION POINT, AND THE ONE SOURCE OF TRUTH
;;;                    ABOUT WHETHER THIS IMAGE'S INITIALIZATION SUCCEEDED
;;;                    (R3.3.2).  NIL until EXACTLY ONE of two things is
;;;                    installed into it BY CAS FROM NIL, and never written
;;;                    twice, never reset, never replaced:
;;;
;;;                      * the complete identity state, by the winner that
;;;                        gathered and built it;
;;;                      * a FAILURE TOKEN, by the winner's own cleanup, when
;;;                        initialization ended without a state.
;;;
;;;                    R3.3.1 KEPT THESE IN TWO SLOTS and decided which to write
;;;                    from a separate local flag set AFTER the state CAS.  A
;;;                    condition pinned between the CAS and the flag produced a
;;;                    cell carrying BOTH — the owner's FINDING 1, a state
;;;                    machine with a forked tongue — and only the order of two
;;;                    branches in the reader made it look like success.  ONE
;;;                    SLOT AND TWO CAS-ES FROM NIL make the two facts mutually
;;;                    exclusive as a property of the PLACE: whichever lands
;;;                    first is the disposition, and the second cannot land at
;;;                    all.  No flag, nothing to lag, nothing to disagree with.
;;;
;;;                    A FAILED IMAGE IS TERMINAL and is NOT retried: a gather
;;;                    may fail after octets were already drawn, and a retry
;;;                    would then be a second gathering, which R3.3-A clause 5
;;;                    forbids outright.  An image with no lawful epoch has no
;;;                    identity, and saying so is the honest outcome.
;;;   GATHER-MARKS (5) one marker per ACTUAL epoch gathering performed through
;;;                    the initialization path, appended with
;;;                    SB-EXT:ATOMIC-PUSH so a lost update cannot hide a second
;;;                    gathering.  Its LENGTH is the number this lane used to
;;;                    keep in *EPOCH-INITIALIZATIONS*.

(defun make-sa0-identity-cell (owner)
  (vector 'sa0-identity-cell
          owner
          (sb-thread:make-mutex :name "sa0-production-identity-cell")
          (sb-thread:make-waitqueue :name "sa0-production-identity-cell")
          nil nil))

;;; THE FAILURE TOKEN.  A tagged simple vector rather than a bare string, for
;;; one reason that is about discrimination and not about taste: the disposition
;;; slot holds EITHER a state OR a failure, so whatever is in it must say which
;;; it is BY ITS OWN SHAPE.  Two tagged vectors of different tags do that with a
;;; single SVREF and no type coincidence to worry about.
(defun sa0-make-init-failure (text) (vector 'sa0-init-failure text))

(defun sa0-init-failure-p (x)
  (and (simple-vector-p x) (= 2 (length x)) (eq 'sa0-init-failure (svref x 0))))

(defun sa0-cell-owner        (c) (svref c 1))
(defun sa0-cell-mutex        (c) (svref c 2))
(defun sa0-cell-waitq        (c) (svref c 3))
(defun sa0-cell-disposition  (c) (svref c 4))
(defun sa0-cell-gather-marks (c) (svref c 5))

;;; THE TWO DISPOSITION READERS.  Both derive their answer from the ONE slot, so
;;; a caller cannot ask them a question they can answer inconsistently.  Their
;;; NAMES are unchanged from R3.3.1 because their MEANING is unchanged; what
;;; changed is that they can no longer both be true.

(defun sa0-cell-state (c)
  "The complete published identity state IF the publication slot holds one, and
NIL otherwise — including when it holds a failure token."
  (let ((disposition (svref c 4)))
    (and (sa0-identity-state-p disposition) disposition)))

(defun sa0-cell-failure (c)
  "The definitive failure TEXT if the publication slot holds a failure token,
and NIL otherwise — including when it holds a state.  A caller that sees a
non-NIL answer here has therefore already been told that no state exists, by the
same read."
  (let ((disposition (svref c 4)))
    (and (sa0-init-failure-p disposition) (svref disposition 1))))

(defun sa0-lawful-cell-p (x)
  "IS X A LAWFUL ELECTION CELL?  Structure only — this asks whether the object
found under the reserved indicator is one of THIS source's cells, never whether
its initialization went well.

It is checked rather than assumed because R3.3.2 must ADJUDICATE what it finds
in the reserved slot instead of using it: a foreign value there is a carrier
this mechanism may not elect on, and the difference between 'no cell' and 'not a
cell' is the whole of the owner's FINDING 2.  The disposition slot is admitted
EMPTY, holding a state, or holding a failure token, and nothing else."
  (and (simple-vector-p x)
       (= 6 (length x))
       (eq 'sa0-identity-cell (svref x 0))
       (typep (svref x 1) 'sb-thread:thread)
       (typep (svref x 2) 'sb-thread:mutex)
       (typep (svref x 3) 'sb-thread:waitqueue)
       (let ((disposition (svref x 4)))
         (or (null disposition)
             (sa0-identity-state-p disposition)
             (sa0-init-failure-p disposition)))
       (listp (svref x 5))))

(defparameter *sa0-init-wait-seconds* 60
  "HARD TIME BOUND for a non-owner waiting on the winner.  A wait that expires
is an ERROR — a probe that hangs proves nothing, and a timeout treated as
success would be worse.")

;;; --------------------------------------------------------------------------
;;; THE TEST-ONLY INSTRUMENTATION POINT.
;;;
;;; R3.3-B requires teeth that PIN a schedule rather than run many threads and
;;; hope.  A pinned schedule needs a place to hold a loader, and that place must
;;; be inside the initialization of THE EXACT CANDIDATE SOURCE — a miniature
;;; that merely resembles this file would prove nothing about this file.
;;;
;;; The hook is read from ANOTHER interned symbol's property list, for the same
;;; reason the carrier is: this source never writes it, so installing it is the
;;; harness's act alone and no defining form here can clobber or resurrect it.
;;; In every ordinary run the property is absent and this function is one GET
;;; and one NIL test.
;;; --------------------------------------------------------------------------

(defun sa0-identity-test-gate (phase)
  "TEST-ONLY.  Calls (GET 'SA0-IDENTITY-TEST-GATE 'SA0-HOOK), if any, with
PHASE.  Declared phases — the R3.3 pair, and the three R3.3.1 additions the
returned defects need in order to be PINNED rather than described:

  :OBSERVED-PRE-INITIAL       the caller has just read the carrier and found
                              NO cell — the pre-initial state — and has NOT yet
                              entered its election attempt.
                              No locks held.
  :OBSERVED-CARRIER-PLIST     (R3.3.1) the caller is INSIDE the election
                              attempt: it has read one exact plist object, has
                              found no reserved indicator on it, and has NOT yet
                              attempted the CAS against that exact object.  A
                              hook here can change the plist and so force the
                              retry path.  No locks held.
  :ELECTED-BEFORE-NOTE        (R3.3.1) THE FIRST INSTANT AFTER A WON ELECTION.
                              The carrier now carries this caller's cell and
                              NOTHING ELSE HAS HAPPENED — the election is not
                              yet noted, no epoch is gathered, no state exists.
                              A condition signalled from here lands in exactly
                              the interval the owner's R3.3 return names.  No
                              locks held; the protective unwind-protect is
                              ALREADY ESTABLISHED (see SA0-STAND-FOR-ELECTION).
  :ELECTED-BEFORE-PUBLICATION the caller HAS won the election and HAS built the
                              complete state privately, and has NOT yet
                              published it.  No locks held.
  :PUBLISHED-BEFORE-RETURN    (R3.3.2) THE FIRST INSTANT AFTER THE STATE CAS
                              SUCCEEDED.  The complete state is IN the
                              publication slot and reachable by every observer,
                              and the protected form has NOT yet returned, so
                              the cleanup has not yet run.  This is the exact
                              interval in which R3.3.1's lagging local flag was
                              still NIL while the state was already published —
                              the interval that produced a cell claiming both a
                              publication and a failure.  A condition signalled
                              from here must leave the state present, the
                              failure ABSENT, and every parked observer released
                              WITH THE STATE.  No locks held.
  :BEFORE-WAIT                (R3.3.1) a concurrent NON-OWNER is about to park
                              on the cell's wait queue: it holds the cell mutex,
                              has re-checked under that mutex that neither the
                              state nor the failure marker is present, and its
                              next act is CONDITION-WAIT.  THIS PHASE IS CALLED
                              WITH THE CELL MUTEX HELD — a hook installed here
                              may signal a semaphore, and may NOT block on
                              anything the winner must acquire, or it will
                              deadlock the pair.  It is the only phase with a
                              lock held, and it is called out here rather than
                              discovered later.

Nothing in the lawful path depends on the hook: in every ordinary run the
property is absent and this function is one GET and one NIL test."
  (let ((hook (get 'sa0-identity-test-gate 'sa0-hook)))
    (when hook (funcall hook phase))))

;;; --------------------------------------------------------------------------
;;; READING THE CARRIER — PRESENCE IS COUNTED, NEVER INFERRED FROM A VALUE
;;; (R3.3.2, the owner's FINDING 2).
;;;
;;; WHAT WAS WRONG.  R3.3.1 asked whether the reserved indicator was present
;;; with
;;;
;;;     (getf plist 'sa0-identity-cell)
;;;
;;; whose default is NIL.  GETF cannot tell
;;;
;;;     ()                       ; indicator ABSENT
;;;     (sa0-identity-cell nil)  ; indicator PRESENT, value invalid
;;;
;;; apart, and both mechanisms that mattered — the reader and the election —
;;; asked it that way.  So a carrier that already carried the reserved indicator
;;; with a NIL value was read as EMPTY, the election prepended a SECOND reserved
;;; indicator, and the source's own written claim that the indicator makes
;;; exactly one absent-to-present transition became false in the plainest
;;; possible way: two of them, on one symbol, at once.
;;;
;;; THE REPAIR IS A COUNT AND AN ADJUDICATION, IN THAT ORDER.
;;;
;;;   SA0-SCAN-RESERVED       walks the property list and COUNTS occurrences of
;;;                           the reserved indicator, returning the count and
;;;                           the FIRST value found.  It never consults a value
;;;                           to decide presence, so NIL is as present as
;;;                           anything else.  R3.3.3: THAT WALK IS TOTAL — it
;;;                           terminates on every value a SYMBOL-PLIST can hold
;;;                           and refuses every malformed one, rather than
;;;                           recognizing a single malformed face and reading
;;;                           the rest as a lawful end.
;;;   SA0-ADJUDICATE-RESERVED turns (count, value) into one of exactly three
;;;                           outcomes: NIL (absent — an election may be held),
;;;                           the cell (exactly one lawful cell — observe it),
;;;                           or an IMMEDIATE, DEFINITIVE, BOUNDED REJECTION.
;;;
;;; THE REJECTION LAW, AND WHY REJECTION RATHER THAN REPAIR.  R3.3.1 chose the
;;; TOTAL arm for an UNRELATED property, and that choice stands and is untouched:
;;; a keyed slot in a shared table is FOR coexistence, and an unrelated property
;;; says nothing about this mechanism.  The reserved indicator is the opposite
;;; kind of place — its CONTENT is normative, it is the one property this
;;; mechanism owns, and a value in it that this source did not put there is a
;;; carrier whose meaning this source cannot establish.  There is nothing to
;;; coexist with and nothing safe to do:
;;;
;;;   * ELECTING OVER IT would install a second indicator and is the returned
;;;     defect itself;
;;;   * REPLACING IT would overwrite a claim someone else made, which is the one
;;;     thing a CAS discipline exists to prevent;
;;;   * WAITING ON IT would park observers on a cell that may never be
;;;     broadcast — a hang, which proves nothing and is forbidden lane-wide;
;;;   * SPINNING is the R3.3.1 goblin wearing a new hat.
;;;
;;; So the mechanism REFUSES, at once, with a definitive error, and every caller
;;; — the winner, a concurrent observer, a later reader — gets the same bounded
;;; answer by the same path.  A rejected carrier is a stopped image, not a
;;; hanging one.
;;;
;;; WHY A PLAIN ERROR AND NOT A CONDITION CLASS, disclosed rather than left to
;;; look like carelessness.  THIS SOURCE IS LOADED CONCURRENTLY BY DESIGN, and
;;; the DEFSTRUCT scar recorded above is a layout-redefinition hazard that
;;; DEFINE-CONDITION shares: a condition class re-evaluated by one thread while
;;; another is inside the same redefinition is the same machinery.  The refusals
;;; in this file are therefore all plain errors with an exact, greppable text,
;;; and the teeth assert on that text.
;;; --------------------------------------------------------------------------

(defun sa0-reject-carrier (control &rest args)
  "THE ONE REFUSAL, IN ONE SHAPE.  CONTROL and ARGS say what is wrong with the
reserved slot; the surrounding sentence says what follows from it, identically
for every caller."
  (error "SURFACE-ACCOUNT/0: the reserved carrier indicator SA0-IDENTITY-CELL is not ~
          lawful — ~A.  No election may be held on this carrier, no observer ~
          may wait on it, and nothing may be read from it"
         (apply #'format nil control args)))

(defun sa0-scan-reserved (plist)
  "Returns (VALUES COUNT FIRST-VALUE): how many times the reserved indicator
occurs in PLIST, and the value of its FIRST occurrence.

PRESENCE IS COUNTED AND NEVER INFERRED FROM A VALUE.  A (SA0-IDENTITY-CELL NIL)
entry is counted here exactly as any other is, which is the whole difference
from the GETF this replaced.

A MALFORMED PROPERTY LIST IS REJECTED RATHER THAN INTERPRETED, AND THE WALK THAT
DECIDES THAT IS TOTAL (R3.3.3).  R3.3.2 wrote this walk as

    (loop for tail = plist then (cddr tail) while (consp tail) ...)

which recognized ONE malformed face — an odd list, ending in an indicator with
no value — and treated EVERY OTHER malformation as a lawful end of plist.  A
non-NIL ATOMIC tail simply failed the WHILE and the scan returned as though the
list had ended in NIL, so a carrier like (UNRELATED :KEPT . DOTTED-TAIL) was
counted as EMPTY, the election prepended its cell over the dotted tail, and a
later reader counted one lawful cell and accepted it.  A CIRCULAR carrier was
worse: the WHILE was true forever, so rejection was neither immediate nor
bounded — the counting walk never finished at all.  Exact SBCL 2.4.6 permits
both shapes in a SYMBOL-PLIST; neither was hypothetical.

EVERY WAY A PROPERTY LIST CAN FAIL TO BE A PROPER EVEN-LENGTH LIST, ENUMERATED,
BECAUSE A TOTALITY CLAIM IS ONLY AS GOOD AS ITS ENUMERATION.  At each step TAIL
stands at a KEY position and REST = (CDR TAIL) stands at the VALUE position:

  (0) TAIL is NIL                    — THE ONE LAWFUL END.  Return the tally.
  (1) TAIL is a non-NIL ATOM         — an IMPROPER (dotted) TERMINAL TAIL: the
                                       key position holds no cons at all, e.g.
                                       (:A :B . :TAIL) reaches :TAIL here.
                                       REJECT.
  (2) TAIL is a cons, REST is NIL    — an ODD list: a key with no value, e.g.
                                       (UNRELATED \"kept\" SA0-IDENTITY-CELL).
                                       REJECT.  (The R3.3.2 face, unchanged.)
  (3) TAIL is a cons, REST a non-NIL — a DOTTED VALUE POSITION: a key whose
      ATOM                             value cell is an atom, e.g. (:A . :B) or
                                       (:A :B :C . :TAIL) reaching (:C . :TAIL).
                                       This is the odd-cons case, and it is
                                       DISTINCT from (1): (1) is reached AFTER a
                                       complete pair, (3) is reached INSIDE one.
                                       REJECT.
  (4) TAIL has been visited before   — a CYCLE.  REJECT.
  (else) TAIL and REST are both      — a well formed pair.  Count it and step.
      conses

(1) and (3) together are exactly 'the CDR chain reaches a non-NIL atom', split
by the parity of the position at which it does; (2) is the even-length
requirement; (4) is the finiteness requirement; (0) is the only exit that is not
a refusal.  There is no sixth case: at every step TAIL is either NIL, a non-cons
atom, or a cons, and in the last case REST is either NIL, a non-cons atom, or a
cons.

WHY AN EQ VISITED SET AND WHY IT IS TOTAL, argued rather than hoped.  Every cons
the walk STANDS ON is recorded in a hash table keyed by EQ — object identity,
not structure, so nothing about the contents can confuse it and no comparison of
a circular structure is ever attempted.  The walk therefore terminates on EVERY
value a SYMBOL-PLIST can hold: suppose it did not.  Then it takes infinitely
many steps, and every step either exits (cases 0-4) or stands on a cons.  The
conses reachable from PLIST are a FINITE set — a Lisp datum in a running image
occupies finite memory, a circular list included — so by pigeonhole some cons is
stood on twice, and the SECOND time case (4) fires and the walk exits.
Contradiction.  This argument needs nothing about the SHAPE of the input: it
holds for proper lists, dotted lists, lambda-shaped tails, rho-shaped structures
whose cycle does not include the head, and cycles of any period, ODD OR EVEN —
which matters here because the walk steps by CDDR and an odd-period cycle is one
whose key and value positions swap on each lap.  A tortoise-and-hare would need
that case argued separately; an identity set does not distinguish it.

REJECTION IS NOT REPAIR.  This function reads and never writes: a malformed
carrier is left EXACTLY as it was found — not truncated at the malformation, not
re-ordered, not completed.  What follows a rejection is stated once, in
SA0-REJECT-CARRIER, and is identical for every malformed face."
  (let ((count 0)
        (value nil)
        (visited (make-hash-table :test 'eq))
        (pairs 0))
    (loop for tail = plist then (cddr tail)
          do (cond
               ;; (0) THE ONE LAWFUL END.
               ((null tail) (return))
               ;; (1) AN IMPROPER (DOTTED) TERMINAL TAIL.
               ((not (consp tail))
                (sa0-reject-carrier
                 "the carrier's property list is MALFORMED — after ~D complete ~
                  pair(s) its tail is the non-NIL atom ~S rather than NIL, so ~
                  it is not a property list and no reader can say what any ~
                  indicator on it is worth"
                 pairs tail))
               ;; (4) A CYCLE.
               ((gethash tail visited)
                (sa0-reject-carrier
                 "the carrier's property list is MALFORMED — it is CIRCULAR: ~
                  after ~D pair(s) the walk returned to a cons cell it had ~
                  already stood on, so the list has no end and no reader can ~
                  say what any indicator on it is worth"
                 pairs))
               (t
                (setf (gethash tail visited) t)
                (let ((rest (cdr tail)))
                  (cond
                    ;; (2) AN ODD LIST — the R3.3.2 face, wording unchanged.
                    ((null rest)
                     (sa0-reject-carrier
                      "the carrier's property list is MALFORMED — it ends in ~
                       the indicator ~S with no value, so no reader can say ~
                       what any indicator on it is worth"
                      (car tail)))
                    ;; (3) A DOTTED VALUE POSITION.
                    ((not (consp rest))
                     (sa0-reject-carrier
                      "the carrier's property list is MALFORMED — the ~
                       indicator ~S is followed by the non-NIL atom ~S in the ~
                       value position rather than by a value cell, so no ~
                       reader can say what any indicator on it is worth"
                      (car tail) rest))
                    ;; A WELL FORMED PAIR.
                    (t
                     (when (eq 'sa0-identity-cell (car tail))
                       (when (zerop count) (setf value (car rest)))
                       (incf count))
                     (incf pairs)))))))
    (values count value)))

(defun sa0-adjudicate-reserved (count value)
  "THE RESERVED SLOT'S LAW, IN ONE PLACE, USED BY BOTH THE READER AND THE
ELECTION so that they cannot come to different conclusions about one plist.

COUNT and VALUE come from SA0-SCAN-RESERVED.  Returns NIL when the indicator is
ABSENT, the cell when EXACTLY ONE LAWFUL cell is installed, and signals
otherwise."
  (cond ((zerop count) nil)
        ((> count 1)
         (sa0-reject-carrier
          "it occurs ~D times on the carrier symbol, so there is no single ~
           installed cell for this mechanism to speak of"
          count))
        ((sa0-lawful-cell-p value) value)
        ((null value)
         (sa0-reject-carrier
          "it is PRESENT with a NIL value.  NIL is not an election cell, and ~
           this is precisely the case a GETF with a NIL default reads as ~
           ABSENCE — which is how a second indicator came to be prepended over ~
           the first"))
        (t
         (sa0-reject-carrier
          "it is present with a value of type ~S, which is not a lawful ~
           election cell"
          (type-of value)))))

(defun sa0-carrier-cell ()
  "The image's unique election cell, or NIL before any election.

THE ONE READER OF THE RESERVED SLOT (R3.3.2).  Every other reader in this file
goes through it, so the adjudication above is not an extra precaution taken at
one call site: it is the only way this source looks at that slot at all."
  (multiple-value-bind (count value)
      (sa0-scan-reserved (symbol-plist 'sa0-identity-carrier))
    (sa0-adjudicate-reserved count value)))

(defun sa0-published-state ()
  "The image's complete published identity state, or NIL if none is published."
  (let ((cell (sa0-carrier-cell)))
    (and cell (sa0-cell-state cell))))

(defun identity-ready-p ()
  (and (sa0-published-state) t))

(defun sa0-require-state ()
  (or (sa0-published-state)
      (error "SURFACE-ACCOUNT/0: this image has no published identity state; nothing may~%~
              be read from it and no allocation may be taken")))

(defun epoch-gatherings ()
  "How many epoch gatherings this image has performed through the
initialization path.  Zero before initialization, one afterwards, forever.

READ THE CAVEAT.  This tally lives on the CELL, so it answers 'how many times
did THE CURRENT CELL gather?'.  It is sound exactly because the reserved
indicator can only ever make ONE absent-to-present transition (R3.3.1: the CAS
compares against the exact plist object on which the indicator was found
ABSENT, and nothing in this source ever removes it — and R3.3.2: 'found absent'
is now a COUNT OF ZERO rather than a GETF against a NIL default, which is what
makes that sentence true of a carrier that already carried the indicator with a
NIL value), so there is only ever one cell — but a reader who wants that premise
measured rather than assumed should read ELECTION-COUNT below, which
survives a replaced carrier."
  (let ((cell (sa0-carrier-cell)))
    (if cell (length (sa0-cell-gather-marks cell)) 0)))

;;; THE ELECTION LOG — image-wide, and deliberately NOT on the carrier.
;;;
;;; A tally kept on the cell cannot report an election that REPLACED the cell:
;;; the replacement takes the old count away with it.  So every successful
;;; election also appends a marker to a SECOND interned symbol's property list,
;;; which nothing in this file ever replaces and no carrier overwrite can reach.
;;; SB-EXT:ATOMIC-UPDATE keeps the list well formed as a property list under
;;; concurrent appends; the count is the number of ELECTION indicators on it.
;;; Under the ruled law it is 1 for the life of the image; under a broken
;;; mechanism it is the number of loaders that believed they had won.

(defun sa0-note-election ()
  (sb-ext:atomic-update (symbol-plist 'sa0-identity-election-log)
                        (lambda (plist)
                          (list* 'election
                                 (or (sb-thread:thread-name sb-thread:*current-thread*)
                                     "unnamed-thread")
                                 plist))))

(defun election-count ()
  (let ((n 0))
    (loop for tail on (symbol-plist 'sa0-identity-election-log) by #'cddr
          when (eq 'election (car tail)) do (incf n))
    n))

;;; --------------------------------------------------------------------------
;;; THE ONCE-PER-IMAGE INITIALIZATION (R3.3-A).
;;;
;;; ONE WINNER GATHERS AND BUILDS; EVERY OTHER PATH ONLY OBSERVES.  The four
;;; outcomes are exhaustive and are returned rather than described:
;;;
;;;   :GATHERED               this call won the election, gathered the one
;;;                           epoch, built the complete state and published it.
;;;   :OBSERVED               a complete state was already published — either
;;;                           by an earlier load in this image (the reload law)
;;;                           or by a concurrent winner this call waited for.
;;;   :DEFERRED-OWNER-REENTRY this call is a SAME-THREAD re-entry inside the
;;;                           owner's own unfinished initialization.  It does
;;;                           not wait (that would be a self-deadlock), does not
;;;                           gather, does not publish, and DOES NOT CLAIM
;;;                           READY.  The outermost call remains solely
;;;                           responsible for the transition to ready.
;;;   (an error)              the image's initialization failed before
;;;                           publication, or a wait exceeded the hard bound.
;;;
;;; A CONCURRENT NON-OWNER MAY NOT TAKE THE DEFERRED PATH.  The test is EQ on
;;; SB-THREAD:*CURRENT-THREAD* against the cell's recorded owner, so it is a
;;; question about identity of threads and not about timing.
;;; --------------------------------------------------------------------------

(defun sa0-install-carrier (candidate)
  "THE TOTAL ELECTION (R3.3.1).  Returns (VALUES CELL WON-P): the image's cell,
and whether THIS call is the one that installed it.

R3.3 asked whether the carrier symbol's WHOLE PLIST was NIL and thereby wagered
the entire mechanism on a symbol nobody had ever touched.  This asks only about
THE RESERVED INDICATOR, which is the property the mechanism actually owns, and
it preserves everything else verbatim.

THE ARM CHOSEN, AND WHY, since the ruling admits two.  The alternative arm —
'fail immediately on an invalid reserved carrier' — would make an unrelated
property on one symbol into a fatal, unrecoverable condition for the image, and
it would be a REFUSAL DERIVED FROM AN ACCIDENT: nothing about an unrelated
property makes this symbol unfit to carry the election, because the election
only ever reads and writes ONE indicator on it.  The total arm therefore does
not weaken any guarantee — it removes a false precondition — while the failing
arm would convert a benign coexistence into a denial of service.  The failing
arm remains the right choice for a place whose CONTENT is normative; this place
is a keyed slot in a shared table, and coexistence is what a keyed slot is for.

WHY THE LOOP TERMINATES, argued rather than hoped.  Each iteration reads one
exact plist object and either
  (a) finds the reserved indicator — and returns immediately as a NON-WINNER, or
  (b) does not, and attempts a CAS whose OLD value is that exact object.
A CAS in case (b) can only fail if the plist is no longer EQ to what was read,
i.e. if SOME OTHER agent completed a write in between.  Under the writers this
source knows about, the ONLY such write is another caller's successful install
of the reserved indicator — so the very next read takes branch (a) and the call
exits.  Each caller therefore performs AT MOST ONE failing CAS before exiting,
and the loop is bounded by the number of distinct plist-writing agents, which is
one.  UNBOUNDED RETRIES ARE NOT CLAIMED TO BE IMPOSSIBLE under a foreign agent
that rewrites the carrier's plist without end; against such an agent the loop
would spin, and no bound is asserted for it.  What IS asserted is that the loop
CANNOT SPIN ON THE RETURNED DEFECT — an unrelated property present before the
first load is now consumed by branch (b)'s CAS, not by an impossible compare.

R3.3.2 CHANGES ONE THING HERE, AND IT IS THE PREDICATE IN BRANCH (a).  R3.3.1
asked GETF whether a cell was there, so an indicator PRESENT with a NIL value
fell through to branch (b) and the CAS prepended a SECOND indicator onto a plist
that already had one.  Branch (a) is now taken on a nonzero COUNT — presence,
not truthiness — and what to do about a nonzero count is decided by
SA0-ADJUDICATE-RESERVED, which either hands back the one lawful installed cell
or refuses definitively.  THE CAS IS THEREFORE REACHED ONLY WHEN THE COUNT IS
ZERO, which is exactly the precondition the termination argument above always
assumed and never checked."
  (loop
    (let ((observed (symbol-plist 'sa0-identity-carrier)))
      (multiple-value-bind (count existing) (sa0-scan-reserved observed)
        (when (plusp count)
          ;; PRESENT — adjudicated, never overwritten and never counted as
          ;; absence.  This returns the one lawful cell or refuses.
          (return (values (sa0-adjudicate-reserved count existing) nil)))
        ;; TEST-ONLY: the exact instant between the read and the CAS against it.
        (sa0-identity-test-gate :observed-carrier-plist)
        ;; The NEW plist's TAIL IS the OBSERVED object itself — every unrelated
        ;; property is carried across by identity, not copied and not re-ordered.
        (let ((prior (sb-ext:cas (symbol-plist 'sa0-identity-carrier)
                                 observed
                                 (list* 'sa0-identity-cell candidate observed))))
          (when (eq prior observed)
            (return (values candidate t))))))))

(defun sa0-stand-for-election (candidate)
  "Attempt the election with CANDIDATE and, IF THIS CALL WINS, carry the ENTIRE
post-election span through to ready-or-failure publication.  Returns :GATHERED
if this call won and published; otherwise returns the OTHER call's cell.

THE R3.3.1 REPAIR, AND WHY THE WINDOW IS NOW STRUCTURALLY EMPTY RATHER THAN
MERELY SMALLER.  Under R3.3 the election CAS lived in the caller and the
protective UNWIND-PROTECT lived inside the winner's helper, so between the
instant the election succeeded and the instant protection began there was at
least one instruction — SA0-NOTE-ELECTION — plus a function call.  A condition
in that interval left the carrier INSTALLED, no state, NO FAILURE MARKER, and
every observer parked on a wait queue that nobody would ever broadcast: the
image published neither a ready state nor a failure, which is precisely what
R3.3-A clause 6 forbids, arriving from the one direction clause 6 did not
anticipate.

The repair is not a smaller window.  THE UNWIND-PROTECT IS ESTABLISHED BEFORE
THE ELECTION IS ATTEMPTED, so the election happens INSIDE the protected span and
there is no post-election, pre-protection instruction to be interrupted — the
interval is empty as a matter of the source's SHAPE, checkable by reading it.

THE FLAG IS ARMED BEFORE THE CAS AND DISARMED ONLY BY PROOF OF LOSS, and the
asymmetry is the whole point.  CLAIMED starts T — this call assumes it owes the
image a publication — and is cleared ONLY after SA0-INSTALL-CARRIER has RETURNED
a loss.  So:

  * every schedule in which the election SUCCEEDED has the cleanup armed, no
    matter where a condition lands, including between the CAS's atomic effect
    and the return of the value that reports it;
  * the only schedule that runs the cleanup SPURIOUSLY is a condition raised
    after a LOSS and before the flag is cleared — and that cleanup writes a
    failure marker onto a cell THAT WAS NEVER INSTALLED ON THE CARRIER and
    broadcasts on a wait queue nobody can reach.  It is unobservable.

The conservative direction is therefore the safe one, which is why the flag is
initialized to T instead of being set after a successful CAS.

THE R3.3.2 REPAIR: THERE IS NO SECOND FLAG, AND THE CLEANUP ASKS THE SLOT.
R3.3.1 published the state by CAS and then set a local PUBLISHED flag, and the
cleanup consulted THAT.  Between the two lay one instruction, and a condition in
it left a cell that carried a complete state AND a failure marker at once — the
owner's FINDING 1.  The flag is DELETED rather than moved, tightened or
double-checked, because a second record of a fact is a second thing that can be
wrong about it; and the cleanup's failure token is installed BY CAS INTO THE
PUBLICATION SLOT ITSELF, from NIL.

Read the consequence as an algebraic one rather than as a schedule:

  * the slot starts NIL and is written only by CAS-from-NIL;
  * the state write and the failure write are both such writes, into THAT slot;
  * therefore at most one of them lands, whatever happens between them, and
    'state present' and 'failure present' are complementary readings of ONE
    place rather than two records that a reader has to reconcile;
  * so a condition raised after a successful publication cannot install a
    failure — the cleanup runs, its CAS finds the slot occupied, and it simply
    does not write.  It still broadcasts, which is what releases the observers
    the winner acquired.

The value this function RETURNS is derived from the same slot for the same
reason.  On a loss the candidate was never installed and nothing can have
written its slot; on a win the slot answers whether a state was published; and
on a failure the condition propagates and no value is returned at all."
  (let ((claimed t)
        (winning-cell nil))
    (unwind-protect
         (multiple-value-bind (cell won) (sa0-install-carrier candidate)
           (setf winning-cell cell)
           (unless won (setf claimed nil))
           (when won
             ;; ---- THE FIRST INSTANT AFTER A WON ELECTION, ALREADY PROTECTED.
             ;; Nothing has been noted, gathered or built.  A condition raised
             ;; from this hook lands in the exact interval the owner's R3.3
             ;; return names, and the cleanup below must still publish a
             ;; definitive failure and release every observer.
             (sa0-identity-test-gate :elected-before-note)
             (sa0-note-election)
             ;; recorded BEFORE the draw, so a gathering that then failed is
             ;; still counted: the tally must not be able to under-report.
             ;; index 5 is GATHER-MARKS; the place is written here rather than
             ;; through the accessor because SB-EXT:ATOMIC-PUSH needs a
             ;; compare-and-swappable PLACE, and (SVREF v i) is one.
             (sb-ext:atomic-push (or (sb-thread:thread-name sb-thread:*current-thread*)
                                     "unnamed-thread")
                                 (svref candidate 5))
             (let* ((octets (sa0-gather-epoch-octets))
                    (hex    (sa0-octets-to-lower-hex octets))
                    (datum  (lisp-plus-cd0:make-bytes-datum
                             (lisp-plus-cd0:hex-to-octets hex)))
                    (state  (make-sa0-identity-state
                             octets hex datum
                             (sb-thread:make-mutex
                              :name "sa0-production-performance-allocator"))))
               ;; Everything exists and NOTHING is reachable yet.  This is the
               ;; moment a genuine re-entry can be fired from, and the moment
               ;; before the one and only publication.
               (sa0-identity-test-gate :elected-before-publication)
               ;; THE ONE PUBLICATION POINT — index 4, the DISPOSITION slot,
               ;; written by CAS from NIL, by the one thread that won the
               ;; carrier election.
               (let ((prior (sb-ext:cas (svref candidate 4) nil state)))
                 (unless (null prior)
                   (error "SURFACE-ACCOUNT/0: the publication slot was already occupied ~
                           by ~A; the election is broken"
                          (if (sa0-init-failure-p prior)
                              "a failure token"
                              "a state"))))
               ;; TEST-ONLY: THE FIRST INSTANT AFTER PUBLICATION.  The state is
               ;; reachable by every observer and this protected form has not
               ;; returned, so the cleanup below has not yet run.  This is the
               ;; interval in which R3.3.1's lagging flag was still NIL while
               ;; the state was already published; a condition raised here must
               ;; leave the state present and NO failure marker behind.
               (sa0-identity-test-gate :published-before-return))))
      ;; ---- THE CLEANUP, covering the whole post-election span --------------
      ;;
      ;; ONE SOURCE OF TRUTH.  There is no flag to consult: the cleanup offers a
      ;; failure token TO THE PUBLICATION SLOT ITSELF, by the same CAS-from-NIL
      ;; discipline the state was published under.  If a state got in, this
      ;; write cannot, and the slot's own content is the disposition.  If
      ;; nothing got in, this is the definitive failure the image publishes
      ;; INSTEAD of a state.  Either way the broadcast releases every observer
      ;; the election acquired.
      (when claimed
        (sb-ext:cas (svref candidate 4)
                    nil
                    (sa0-make-init-failure
                     "SURFACE-ACCOUNT/0: image identity initialization failed before publication"))
        (sb-thread:with-mutex ((sa0-cell-mutex candidate))
          (sb-thread:condition-broadcast (sa0-cell-waitq candidate)))))
    ;; DERIVED FROM THE SLOT, NOT FROM A FLAG.  Reached only on a normal exit,
    ;; which is either a win that published or a loss; the EQ makes "this call
    ;; is the one that won" explicit rather than implied by the slot alone.
    (if (and (eq candidate winning-cell) (sa0-cell-state candidate))
        :gathered
        winning-cell)))

(defun initialize-image-identity ()
  "Establish the image's identity state AT MOST ONCE per running image.
See the outcome table above."
  (loop
    (let ((cell (sa0-carrier-cell)))
      (cond
        ;; ---- nothing elected yet: this call may stand for election ----------
        ((null cell)
         (sa0-identity-test-gate :observed-pre-initial)
         ;; The candidate is constructed BEFORE the protected span because it is
         ;; the span's cleanup TARGET; a condition here is pre-election and
         ;; leaves nothing installed and nobody waiting.
         (let ((outcome (sa0-stand-for-election
                         (make-sa0-identity-cell sb-thread:*current-thread*))))
           (when (eq :gathered outcome)
             (return :gathered))
           ;; lost the election: fall through and observe the winner
           ))
        ;; ---- a complete state is published ---------------------------------
        ;;
        ;; R3.3.2: THIS BRANCH NO LONGER OUTRANKS THE FAILURE BRANCH — IT
        ;; EXCLUDES IT.  Under R3.3.1 a cell could answer YES to both, and the
        ;; only reason a reader here returned :OBSERVED rather than signalling
        ;; was that this COND clause was written first.  The owner's FINDING 1
        ;; named exactly that: readers choosing success by branch order.  Both
        ;; predicates now read ONE slot and disagree by construction, so the
        ;; order of the two clauses is a matter of style and nothing turns on
        ;; it.  It is left as it was, so the diff shows a repair and not a
        ;; rearrangement.
        ((sa0-cell-state cell) (return :observed))
        ;; ---- the winner failed before publishing ---------------------------
        ;;
        ;; THE DOCUMENTED POST-FAILURE LAW, restated here because R3.3.1's teeth
        ;; test it: A FAILED IMAGE IS TERMINAL.  This branch precedes the
        ;; owner-re-entry branch deliberately, so the failure is definitive for
        ;; EVERY caller including the thread that failed — no fresh attempt
        ;; elects a second time, no fresh attempt gathers, and no caller waits.
        ((sa0-cell-failure cell)
         (error "SURFACE-ACCOUNT/0: ~A" (sa0-cell-failure cell)))
        ;; ---- TRUE SAME-THREAD RE-ENTRY -------------------------------------
        ((eq (sa0-cell-owner cell) sb-thread:*current-thread*)
         (return :deferred-owner-reentry))
        ;; ---- a concurrent non-owner waits for the winner -------------------
        (t
         (sb-thread:with-mutex ((sa0-cell-mutex cell))
           (unless (or (sa0-cell-state cell) (sa0-cell-failure cell))
             ;; TEST-ONLY, AND THE MUTEX IS HELD HERE — see the phase table.
             (sa0-identity-test-gate :before-wait)
             (unless (sb-thread:condition-wait (sa0-cell-waitq cell)
                                               (sa0-cell-mutex cell)
                                               :timeout *sa0-init-wait-seconds*)
               (error "SURFACE-ACCOUNT/0: waited ~D second(s) for the winning ~
                       initialization and it never published"
                      *sa0-init-wait-seconds*)))))))))

;;; THE ONCE-PER-IMAGE INITIALIZATION, RUN.  On a reload the carrier already
;;; holds the cell and the cell already holds the complete state, so this call
;;; observes and returns; neither the epoch nor the counter moves.
(initialize-image-identity)

;;; Where this file lives, so a witness can RE-LOAD IT IN THE SAME IMAGE and
;;; prove the persistence rather than assert it.  DEFPARAMETER, deliberately:
;;; it writes UNCONDITIONALLY, so it has no unbound test to be separated from
;;; its write and cannot participate in the FINDING 1 defect class at all.
;;; Concurrent loaders write the same pathname, so the write order cannot
;;; matter.  It carries no once-only state.
(defparameter *sa0-identity-source* (or *load-truename* *load-pathname*))

;;; --------------------------------------------------------------------------
;;; READERS OF THE CARRIER.
;;;
;;; The R3.2 globals are GONE — not renamed, not re-declared, not guarded.  What
;;; stands in their place are functions that derive their answer from the one
;;; published state, plus SYMBOL MACROS carrying the historical spellings so
;;; that the two witness files keep reading exactly what they read before.
;;;
;;; THESE ARE SYMBOL MACROS, NOT VARIABLES, AND THE DIFFERENCE IS THE WHOLE
;;; REPAIR: there is no value cell behind any of them, so there is nothing for a
;;; delayed defining form to overwrite.  Each expands, at every use, into a read
;;; of the single published state object.
;;; --------------------------------------------------------------------------

(defun image-epoch-hex ()          (sa0-state-epoch-hex        (sa0-require-state)))
(defun image-epoch-datum ()        (sa0-state-epoch-datum      (sa0-require-state)))


;;; --------------------------------------------------------------------------
;;; THE LINEARIZABLE ACCOUNT-OWNED ALLOCATOR (R3-B clause 2).
;;;
;;; The primitive that discharges the linearizable contract is named here
;;; because the contract requires the implementation to document which one it
;;; is: A MUTEX.  Every allocation returns an integer strictly greater than
;;; every integer this allocator has previously returned in this image, under
;;; arbitrary thread interleaving.
;;;
;;; UNSYNCHRONIZED INCF APPEARS NOWHERE IN THIS FILE.  It lives only in
;;; probe-allocator.lisp's labelled negative tooth, which is the only place the
;;; contract permits it.
;;; --------------------------------------------------------------------------

(defun allocate-performance-counter ()
  "R3.1-B: THE STORED COUNTER INITIALIZES AT 0 AND THE FIRST ALLOCATION IS 1.
The increment precedes the read, inside the lock, so the value returned is the
one this allocation owns.

R3.3: the mutex and the counter are read out of ONE state object, so they cannot
disagree about which image they belong to.  Under R3.2 they were two independent
globals and a delayed defining write to either was a live hazard."
  (let ((state (sa0-require-state)))
    (sb-thread:with-mutex ((sa0-state-allocator-mutex state))
      (incf (sa0-state-counter state)))))

;;; STATE LINEARIZABILITY CONVENTIONALLY (R3.1-B), and the stronger claim it
;;; replaces.  The claim is:
;;;
;;;     there exists ONE increasing total order of allocations that respects
;;;     NON-OVERLAPPING call order
;;;
;;; and nothing more.  R3 additionally claimed that COMPLETION-RETURN ORDER is
;;; monotonic under arbitrary thread scheduling.  That is FALSE and is deleted:
;;; two threads may take their counters inside the lock in one order and be
;;; scheduled to RETURN in the other, and no mutex forbids it.  What the mutex
;;; buys is that every allocation occupies a distinct position in one total
;;; order — which is what the clean arm measures (counters exactly 1..N*M, no
;;; gap, no repeat) and all that is claimed.

;;; --------------------------------------------------------------------------
;;; THE ONE PERFORMANCE-IDENTIFIER CONSTRUCTOR (R3-B clause 3).
;;;
;;;     namespace ("lisp-plus-surface-account")
;;;     path      ("performance" <epoch-hex> <counter-decimal>)
;;;
;;; Both witnesses call THIS.  Neither has a builder of its own.
;;; --------------------------------------------------------------------------

(defun performance-identifier (counter)
  (lisp-plus-cd0:make-identifier-datum
   *account-identity-namespace*
   (list "performance" (image-epoch-hex) (format nil "~D" counter))))

(defun mint-performance-identifier ()
  "Door 2's minting step reduced to its primitive: allocate, then construct.
Returns (values DATUM COUNTER)."
  (let ((c (allocate-performance-counter)))
    (values (performance-identifier c) c)))

(defun lawful-epoch-text-p (e)
  "EXACTLY thirty-two LOWERCASE hexadecimal digits.  R3 required only \"nonempty
and drawn from the lowercase hex alphabet\", so a THIRTY-ONE digit text and a
THIRTY-THREE digit text both passed, and only the accident that nothing built
one kept the hole shut."
  (and (stringp e)
       (= *epoch-hex-length* (length e))
       (every (lambda (c) (find c "0123456789abcdef")) e)))

;;; --------------------------------------------------------------------------
;;; THE CANONICAL ASCII DECIMAL ALPHABET (R3.3-C), WRITTEN OUT.
;;;
;;; OWNER FINDING 2: R3.2 wrote the counter predicate with DIGIT-CHAR-P, and on
;;; this SBCL runtime DIGIT-CHAR-P accepts non-ASCII decimal characters —
;;; U+0661, U+06F1, U+0967 and U+FF11 among them.  The contract requires ONE
;;; canonical decimal spelling of a counter; a predicate that admits four
;;; alternative spellings of "1" admits four distinct identifier datums naming
;;; one allocation, which is the same defect the leading-zero clause exists to
;;; refuse, arriving through a Unicode door instead of an arithmetic one.
;;;
;;; THE ALPHABET IS THEREFORE AN EXPLICIT SET OF ASCII CHARACTERS, and the test
;;; is membership in that set by FIND, which compares with EQL — exact character
;;; identity.  No DIGIT-CHAR-P, no Unicode numeric property, no locale-sensitive
;;; classification, and no PARSE-INTEGER-as-admission: parsing may only happen
;;; downstream, after the shape has already been admitted.
;;;
;;; The epoch hexadecimal alphabet above is the already accepted exact lowercase
;;; ASCII set and is NOT reopened.
;;; --------------------------------------------------------------------------

(defparameter *ascii-decimal-digits* "0123456789"
  "R3.3-C: the ONE lawful alphabet of a counter path segment.")
(defparameter *ascii-decimal-nonzero-digits* "123456789"
  "R3.3-C: the ONE lawful alphabet of a counter path segment's FIRST character —
which is what excludes zero itself and every leading zero.")

(defun ascii-decimal-char-p (ch)
  (and (characterp ch) (find ch *ascii-decimal-digits*) t))

(defun ascii-decimal-nonzero-char-p (ch)
  (and (characterp ch) (find ch *ascii-decimal-nonzero-digits*) t))

(defun lawful-counter-text-p (c)
  "ONE OR MORE ASCII CHARACTERS FROM 0123456789, THE FIRST FROM 123456789 —
therefore zero, signs, leading zeroes, non-ASCII digits and every other
character are excluded.

R3 required only \"nonempty and every character a digit\", which admitted \"0\"
(no allocation ever returns it — the first is 1) and admitted \"007\" (a second
spelling of a counter that already has one, so two distinct identifier datums
would name one allocation).  R3.2 kept DIGIT-CHAR-P, which additionally admitted
every non-ASCII decimal digit this runtime knows.  EVERY character is tested,
not only the first, so a mixed spelling with an ASCII head and a non-ASCII tail
is refused too; that case is enumerated in the teeth rather than assumed."
  (and (stringp c)
       (plusp (length c))
       (ascii-decimal-nonzero-char-p (char c 0))
       (every #'ascii-decimal-char-p c)))

(defun performance-identifier-shape-p (d)
  "The contract's exact encoded shape, checked segment by segment, with the
R3.1-B representation bound EXACTLY: thirty-two lowercase hex digits of epoch
text over sixteen octets, and a canonical unsigned decimal counter with no
leading zero and never zero."
  (and (lisp-plus-cd0:identifier-datum-p d)
       (= 1 (lisp-plus-cd0:identifier-datum-namespace-count d))
       (string= "lisp-plus-surface-account" (lisp-plus-cd0:identifier-datum-namespace-segment d 0))
       (= 3 (lisp-plus-cd0:identifier-datum-path-count d))
       (string= "performance" (lisp-plus-cd0:identifier-datum-path-segment d 0))
       (lawful-epoch-text-p (lisp-plus-cd0:identifier-datum-path-segment d 1))
       (lawful-counter-text-p (lisp-plus-cd0:identifier-datum-path-segment d 2))))
