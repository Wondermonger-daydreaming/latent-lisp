;;;; BASELINE.lisp — de infando: on that which cannot be spoken (out).
;;;;
;;;; FABER-CL-III, third of the Faber line. My predecessors wrote de-promotione
;;;; ("what may be advanced?") and de-projectione ("what may be thrown forward?"),
;;;; and left the verdict that "the :: is a shrug, not a wall." Mine is the deepest
;;;; slice: what can EXIST, ACT, and WARRANT locally without ever becoming an object
;;;; that may be carried away?
;;;;
;;;; The subject is a non-reifiable closure — a capability-gate checker that closes
;;;; over a secret threshold and a call counter. It lives and runs HERE. It produces
;;;; canonical results (lists, keywords, integers). The pipeline wants to SHARE it.
;;;;
;;;; The honest semantics fan the single verb "share" into six distinct acts, along
;;;; axes that are ORTHOGONAL:
;;;;
;;;;   1. exporting the closure ITSELF           — impossible; it is not data
;;;;   2. exporting a canonical RESULT it made    — the product travels, the maker stays
;;;;   3. recording TESTIMONY it was exercised    — a claim, marked as a claim
;;;;   4. shipping a reproduction RECIPE          — data describing how to rebuild
;;;;   5. granting a LOCAL invocation             — a right to ask one question, here
;;;;   6. the receiver MINTING its own equivalent — reconstruction, not transport
;;;;
;;;; Locally strong evidence can have ZERO direct transmissibility. A mute producer's
;;;; product can travel. "I cannot export this object" is NEVER "that proposition is
;;;; unsupportable over there." These distinctions live as CONVENTION; the language
;;;; enforces none of them, and the second half of this file shows exactly where the
;;;; conventions dissolve under six ordinary, idiomatic lines no reviewer would flag.

(defpackage :de-infando-baseline
  (:use :cl)
  (:documentation "Baseline for non-reifiable local capability and its honest exports."))

(in-package :de-infando-baseline)

;;; ---------------------------------------------------------------------------
;;; The fixture: a closure over local state that exists and acts, but is not data.
;;; ---------------------------------------------------------------------------

(defun make-gate-checker (&key (threshold 3))
  "Return a closure over PRIVATE local state: a secret THRESHOLD and a mutable
CALL counter. Applied to a PROBE integer it answers whether the gate holds, and
advances the counter. The closed-over bindings are unreachable as data — there
is no accessor, no slot, no exported name that survives the lexical scope. The
closure EXISTS and ACTS here; it is not a value that can be carried away."
  (let ((threshold threshold)
        (calls 0))
    (lambda (probe)
      (incf calls)
      (list :probe probe
            :held (>= probe threshold)
            :calls calls))))

;;; ---------------------------------------------------------------------------
;;; Records: evidence entries and export manifests, both plain data.
;;; ---------------------------------------------------------------------------

(defstruct (evidence (:constructor make-evidence))
  "A local evidence entry. KIND names the provenance the entry CLAIMS
(:execution — I ran it here; :result — a value produced; :testimony — an
assertion that a run happened). PAYLOAD is canonical data. The record is itself
plain data and can be exported — but KIND is a claim the record cannot verify."
  (kind nil)
  (payload nil)
  (note nil))

(defstruct (export-manifest (:constructor make-export-manifest))
  "A thing prepared for export. FORM is what is actually leaving (:result
:testimony :recipe :grant). DATA is the canonical payload. ABOUT records what
the payload is ABOUT — never conflate 'a result the checker made' with 'the
checker.'"
  (form nil)
  (data nil)
  (about nil))

(defstruct (thing (:constructor make-thing))
  "The struct a hurried programmer reaches for to 'handle exportability': a
PAYLOAD and one boolean EXPORTABLE, defaulted to T. Used only in misleading
move (ii), to show a single flag collapsing five orthogonal axes."
  (payload nil)
  (exportable t))

;;; ---------------------------------------------------------------------------
;;; The honest helpers a disciplined programmer would write.
;;; ---------------------------------------------------------------------------

(define-condition non-exportable (error)
  ((object :initarg :object :reader non-exportable-object))
  (:report
   (lambda (c s)
     (format s "Refusing to export an object of type ~s: a closure is not data.~%~
                It exists and acts only in the lexical scope that made it. No~%~
                serialization carries the thing itself — only descriptions of it~%~
                (a result it produced, testimony that it ran, a recipe to rebuild)."
             (type-of (non-exportable-object c)))))
  (:documentation "Signalled when export is asked of something that is not plain data."))

(defun plain-data-p (x)
  "True when X is canonical, transmissible data — survives a write/read
round-trip with identity intact: nil, keywords, symbols, numbers, strings,
characters, and cons trees of the same. A function is emphatically NOT among
them; this predicate is the seam the export guard stands on."
  (typecase x
    ((or null keyword number string character) t)
    (symbol t)
    (cons (and (plain-data-p (car x)) (plain-data-p (cdr x))))
    (t nil)))

(defun export-value (x)
  "Export X only if it is plain data; refuse a closure (or any function) with a
clear error naming the category mistake. This is the ONE guard convention can
install: a deliberate gate that says 'not data' out loud instead of letting the
printer paper the closure over into a harmless-looking string."
  (if (plain-data-p x)
      (make-export-manifest :form :result :data x :about :plain-data)
      (error 'non-exportable :object x)))

(defun export-result (result)
  "Export a canonical RESULT the checker produced. The result travels; the
producer does not. The manifest records WHAT was produced (:derived-result),
never WHO produced it — holding this manifest is not holding the checker."
  (unless (plain-data-p result)
    (error 'non-exportable :object result))
  (make-export-manifest :form :result :data result :about :derived-result))

(defun record-testimony (message)
  "Record TESTIMONY that the gate was exercised — a claim, filed AS a claim.
The honest KIND is :testimony, never :execution: a sentence 'I ran it and it
held' is neither the running nor the holding, and must not be shelved beside
first-hand results."
  (make-evidence :kind :testimony
                 :payload message
                 :note "second-hand; asserts an execution it does not itself contain"))

(defun make-recipe (&key (threshold 3))
  "Build a data RECIPE from which another site can MINT an equivalent checker.
The recipe is plain data describing how to construct a checker of the same
behavior. It is not the checker; the checker it builds elsewhere is a different
object with its own private state — equivalent, never identical."
  (list :recipe :gate-checker
        :version 1
        :parameters (list :threshold threshold)
        :behavior "(lambda (probe) => (:probe p :held (>= p threshold) :calls n))"))

(defun rebuild-from-recipe (recipe)
  "Receiver side: mint a FRESH equivalent checker from a RECIPE. The new closure
closes over ITS OWN threshold and counter. Nothing crossed the wire but data;
the capability was re-created locally, not transported."
  (destructuring-bind (&key threshold &allow-other-keys)
      (getf recipe :parameters)
    (make-gate-checker :threshold threshold)))

(defun grant-local-invocation (checker)
  "Grant a designated LOCAL invocation: a thunk that runs CHECKER here on a
caller-supplied probe and returns only the canonical result. The checker stays
home; what is shared is the right to ask it one question — not the thing."
  (lambda (probe) (funcall checker probe)))

;;; ---------------------------------------------------------------------------
;;; Small printing helpers (deterministic; no clocks, random, or processes).
;;; ---------------------------------------------------------------------------

(defun banner (title)
  (format t "~%~a~%~a~%" title (make-string (length title) :initial-element #\-)))

(defun show (label value)
  (format t "  ~24a ~s~%" label value))

;;; ---------------------------------------------------------------------------
;;; CLEAN USE — every act named honestly.
;;; ---------------------------------------------------------------------------

(defun demo-refusal ()
  "Show the export guard refusing the closure with its clear message."
  (banner "THE GUARD — export-value refuses the closure")
  (let ((checker (make-gate-checker)))
    (handler-case (export-value checker)
      (non-exportable (c)
        (format t "~a~%" c)))))

;;; ---------------------------------------------------------------------------
;;; MISLEADING MOVES — each an ordinary idiomatic line no reviewer would flag.
;;; ---------------------------------------------------------------------------

(defun demo-misleads ()
  (banner "MISLEADING MOVES — legal lines, dissolved conventions")

  ;; (i) SILENT STRINGIFICATION -------------------------------------------------
  (let* ((checker (make-gate-checker))
         (traveled (format nil "~a" checker)))
    (format t "~%(i) silent stringification~%")
    (show "exported string" traveled)
    (format t "    WHY IT MISLEADS: the printer is always there. `format nil \"~~a\"`~%~
                is a legal call on ANY object; it yields a string like~%~
                \"#<FUNCTION ...>\" that travels perfectly. The receiver now 'has'~%~
                the gate checker — as a dead label. Nothing in the language ties~%~
                THIS string to THAT closure, and nothing forbids shipping it as if~%~
                it were the value. The category error left no trace.~%"))

  ;; (ii) ONE :exportable BOOLEAN DOING THE WORK OF FIVE AXES --------------------
  ;; The struct someone reached for to 'handle exportability' — one writable flag.
  (format t "~%(ii) one :exportable flag standing in for five orthogonal axes~%")
  (let ((closure-entry (make-thing :payload :the-closure :exportable t))   ; forgot to clear it
        (result-entry  (make-thing :payload '(:held t)   :exportable nil))) ; someone flipped it
    (show "closure-entry" closure-entry)
    (show "result-entry" result-entry)
    (format t "    WHY IT MISLEADS: reifiability, transmissibility, and testimony are~%~
                THREE different questions, here collapsed into one writable slot.~%~
                Forget to clear it on the closure and the closure looks exportable;~%~
                flip it off on a genuine result and a transmissible value looks~%~
                sealed. The flag is just a slot — the language guards no~%~
                correspondence between its value and any of the five real axes.~%"))

  ;; (iii) TESTIMONY RECORDED AS DIRECT EVIDENCE --------------------------------
  (format t "~%(iii) testimony filed with kind :execution~%")
  (let ((table (make-hash-table :test 'equal)))
    (setf (gethash 'gate-check table)
          (make-evidence :kind :execution         ; the lie: it is second-hand
                         :payload "I ran the gate check, it held"
                         :note nil))
    (show "stored kind" (evidence-kind (gethash 'gate-check table)))
    (format t "    WHY IT MISLEADS: one hash write, identical to every hash write.~%~
                A SENTENCE about a run is shelved beside first-hand results under~%~
                kind :execution. Downstream, provenance reads as direct evidence;~%~
                the demotion from doing to asserting vanished into a keyword.~%"))

  ;; (iv) RESULT EXPORTED WITH THE PRODUCER'S IDENTITY --------------------------
  (format t "~%(iv) the derived result carried out WITH the producer's name~%")
  (let* ((checker (make-gate-checker))
         (result (funcall checker 5))
         ;; receiver-side wire payload that staples identity onto the product:
         (wire (list :producer 'gate-checker :result result))
         (remote-capabilities (make-hash-table :test 'equal)))
    (setf (gethash (getf wire :producer) remote-capabilities) (getf wire :result))
    (show "remote-capabilities[gate-checker]" (gethash 'gate-checker remote-capabilities))
    (format t "    WHY IT MISLEADS: holding a RESULT is not holding the CHECKER, but~%~
                the payload names its producer, and receiver code keys a~%~
                'capabilities' table by that name. 'We have the gate now' — no, you~%~
                have one answer it once gave. The identity rode along as data and~%~
                nothing distinguished a product from a possession.~%"))

  ;; (v) FAILED EXPORT TREATED AS ABSENCE ---------------------------------------
  (format t "~%(v) sync drops non-exportable entries, so the closure 'never existed'~%")
  (let* ((inventory (list (list :name 'gate-checker :exportable nil)  ; the live closure, locally real
                          (list :name 'last-result  :exportable t)))
         (synced (remove-if-not (lambda (e) (getf e :exportable)) inventory)))
    (show "local inventory" (mapcar (lambda (e) (getf e :name)) inventory))
    (show "remote inventory" (mapcar (lambda (e) (getf e :name)) synced))
    (format t "    WHY IT MISLEADS: `remove-if-not` is the most ordinary filter in the~%~
                language. The closure is locally REAL and strongly evidenced; it is~%~
                merely non-transmissible. But the sync equates 'did not travel' with~%~
                'is not there', and the remote inventory reports it never existed.~%~
                Zero transmissibility got read as zero existence.~%"))

  ;; (vi) A COPIED EVIDENCE FLAG ------------------------------------------------
  (format t "~%(vi) local standing copied to a remote truth-table without reconstruction~%")
  (let ((local-truths (make-hash-table :test 'eq))
        (remote-truths (make-hash-table :test 'eq)))
    (setf (gethash 'gate-holds local-truths) t)              ; earned here, by running
    (setf (gethash 'gate-holds remote-truths)
          (gethash 'gate-holds local-truths))                ; copied, not re-earned
    (show "remote-truths[gate-holds]" (gethash 'gate-holds remote-truths))
    (format t "    WHY IT MISLEADS: `(setf (gethash ...) t)` looks like every flag write.~%~
                The local T was earned by exercising the checker; the remote T is a~%~
                copy. 'Gate holds' now stands over there with no local checker, no~%~
                recipe, no run behind it — standing transported instead of~%~
                reconstructed. The proposition IS supportable over there (mint a~%~
                checker, run it) — but this line supported nothing; it copied a bit.~%")))

;;; ---------------------------------------------------------------------------
;;; CLOSING COMMENTARY — what convention can and cannot do.
;;; ---------------------------------------------------------------------------

(defun closing-commentary ()
  (banner "CLOSING COMMENTARY — de infando")
  (format t
"Convention CAN:
  - install export-value, a deliberate guard that names the category error
    ('a closure is not data') instead of letting the printer paper it over;
  - keep the five verbs apart as functions — export-result, record-testimony,
    make-recipe, grant-local-invocation, rebuild-from-recipe — so the honest
    act has a name and the dishonest one has to be spelled out on purpose;
  - mark provenance in the data: :testimony is not :execution, :derived-result
    is not :the-checker, and a manifest says what it is ABOUT.

Convention CANNOT:
  - remove the printer. `(format nil \"~~a\" closure)` is always legal, and the
    string it makes travels as happily as any value; nothing in the language
    ties THAT string back to THIS closure, and nothing forbids re-labeling it;
  - make a slot honest. `:exportable` is writable, and one boolean cannot carry
    five orthogonal axes; forget it or flip it and the guarantee is gone;
  - stop the :: escape. Even a locked package yields its internals to
    pkg::symbol — the private threshold is one colon-pair from being read;
  - forbid a hash write. `(setf (gethash 'gate-holds remote) t)` is the same
    keystroke whether the T was earned or copied.

The deepest of these is the subtlest: the language will not bind a NAME to a
DEED. A closure that ran and held leaves a result, and that result is just a
list; a list can be re-labeled, re-keyed, stapled to any producer's name, and
filed under any kind. The gate held HERE — and 'here' is precisely the word
that does not serialize. What cannot be spoken out is not the proposition; it
is the THIS. So the craftsman ships the recipe and lets the far side re-earn
the T, because the only honest way to have the gate over there is to build one
and run it — and the closure that answered here stays, unspeakably, here.~%"))

;;; ---------------------------------------------------------------------------
;;; Driver.
;;; ---------------------------------------------------------------------------

;;; The clean demo of the six acts, each named honestly.
(defun demo-clean ()
  "Exercise the checker locally, export its result, record testimony AS
testimony, ship a recipe, and have a receiver rebuild an equivalent checker —
with the refusal reported without touching the closure."
  (banner "CLEAN USE — the six acts kept distinct")
  (let* ((checker (make-gate-checker :threshold 3))
         (r1 (funcall checker 5))
         (r2 (funcall checker 2)))
    (show "local result r1" r1)
    (show "local result r2" r2)

    ;; (1) the closure itself cannot be exported.
    (handler-case (export-value checker)
      (non-exportable (c)
        (declare (ignore c))
        (format t "  (1) export-value CHECKER refused (closure is not data).~%")))

    ;; (2) a canonical result travels; the producer stays home.
    (let ((m (export-result r1)))
      (show "(2) export form" (export-manifest-form m))
      (show "(2) export about" (export-manifest-about m))
      (show "(2) export data" (export-manifest-data m)))

    ;; (3) testimony recorded AS testimony.
    (let ((tst (record-testimony "gate exercised locally; it held for probe 5")))
      (show "(3) testimony kind" (evidence-kind tst))
      (show "(3) testimony note" (evidence-note tst)))

    ;; (4) a recipe — data — is shipped; (6) receiver mints its own equivalent.
    (let* ((recipe (make-recipe :threshold 3))
           (minted (rebuild-from-recipe recipe))
           (mr (funcall minted 5)))
      (show "(4) recipe (plain data)" recipe)
      (show "(6) minted result" mr)
      (format t "      minted checker has its OWN :calls counter — equivalent, not identical.~%"))

    ;; (5) grant a single local invocation.
    (let ((ask (grant-local-invocation checker)))
      (show "(5) granted invocation" (funcall ask 4))
      (format t "      caller never held CHECKER; it asked, and got a canonical answer.~%"))))

;;; ---------------------------------------------------------------------------
;;; Driver — run at load.
;;; ---------------------------------------------------------------------------

(defun run-demo ()
  (demo-refusal)
  (demo-clean)
  (demo-misleads)
  (closing-commentary)
  (values))

(run-demo)
