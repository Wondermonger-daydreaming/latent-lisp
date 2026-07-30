;;;; surface2-inhabited.lisp — Language Surface /2, the INHABITED VERTICAL
;;;; (contract §5): the %DERIVE-SEAT-OUTCOME passage of vertical-census-0
;;;; re-expressed with DERIVE-SEAT-OUTCOME + MATCH-OUTCOME, proven against
;;;; the UNTOUCHED census path over the SAME preserved campaign-1 fixtures.
;;;;
;;;; WHAT IS PROVEN, and what is not: canonical byte equality of the two
;;;; paths' census CD/0 records; per-seat facet agreement; the two
;;;; hand-written census guards firing IDENTICALLY on mutated fixtures;
;;;; and the SURPLUS the new path retains, listed explicitly.  Equality
;;;; here is the §5 canonical-equality demonstration, NEVER a
;;;; semantic-preservation claim — the forbidden vocabulary binds this
;;;; file too.
;;;;
;;;; Run:  sbcl --script mneme/language-surface-2/surface2-inhabited.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; The OLD path is the real DERIVE-CENSUS, loaded through the official
;;;; census-only chain (vertical0/reconstruction/load-census-only.lisp)
;;;; and NEVER reimplemented here.  The campaign-1 store is READ-ONLY:
;;;; the cross-axis mutated fixture is an octet-exact COPY of it in a
;;;; scratch directory, appended there; the totality fixture needs no
;;;; append at all (a bank naming a seat with no evidence).
;;;;
;;;; DETERMINISM: nothing time-, pid-, or path-dependent is printed.
;;;; Gate teeth: SURFACE2_INHABITED_PLANT_FAULT=1 exits 1 with a planted
;;;; FAIL; SURFACE2_INHABITED_DIE=1 exits 3 mid-run, no RESULT sentinel.
;;;;
;;;; — GLOSSATOR (Claude Fable 5 subagent), 2026-07-30

(load (merge-pathnames "surface2.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))
(load (merge-pathnames "../vertical0/reconstruction/load-census-only.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(defpackage #:surface2-inhabited
  (:use #:cl #:lisp-plus-surface2)
  (:import-from #:lisp-plus-vertical0
                #:read-vertical-config #:config-bank #:seat-field
                #:derive-census))
(in-package #:surface2-inhabited)

(defvar *checks* 0)
(defvar *failures* 0)

(defun check (description thunk)
  (incf *checks*)
  (let ((description (format nil description))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "[V~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[V~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))))

(defun note (control &rest arguments)
  (apply #'format t control arguments)
  (terpri))

(note "surface2-inhabited — one Vertical /0 passage, re-expressed; the ~
       evidence carried home, compared")

;;; ---------------------------------------------------------------------------
(note "~%== fixtures ==")

(defvar *here* (make-pathname :name nil :type nil :defaults *load-truename*))
(defvar *exec* (merge-pathnames "../vertical0/runs/campaign-1/exec/" *here*))

(defun file-octets (pathname)
  (with-open-file (s pathname :element-type '(unsigned-byte 8))
    (let ((octets (make-array (file-length s)
                              :element-type '(unsigned-byte 8))))
      (read-sequence octets s)
      octets)))

(defun file-sha256 (pathname)
  (lisp-plus-journal0:sha256-hex (file-octets pathname)))

(defvar *journal-digest-before*
  (file-sha256 (merge-pathnames "store/EVENTS.pj0" *exec*)))

(defvar *store* (lisp-plus-journal0:open-store
                 (merge-pathnames "store/" *exec*)))
(defvar *config* (read-vertical-config
                  (merge-pathnames "VERTICAL-PROGRAM-CONFIG.sexp" *exec*)))
(defvar *events* (validated-store-events *store*))

;;; ---------------------------------------------------------------------------
;;; THE REWRITTEN PASSAGE.  Every standing-relevant choice of
;;; %DERIVE-SEAT-OUTCOME (census.lisp:49-108) remains VISIBLE below as a
;;; clause; the evidence-class precedence is the clause order, the two
;;; hand-written guards are the two refusing clauses.  What the surface
;;; removed is the repetition — the five FIND-EVENT probes, the manual
;;; namespace split, the per-branch plist surgery — not the choices.

(defun census-seat-plist (outcome)
  "One seat's census outcome plist, from the reified outcome object.
Field for field the same map %DERIVE-SEAT-OUTCOME builds; the CD/0
record builder downstream is shared shape too."
  (match-outcome outcome
    ;; census.lisp:64-68 — evidence class 1: a journaled vertical REFUSAL.
    ((:evidence-class :refusal)
     :facets ((seat :seat) (refusal :refusal))
     (list :seat seat :manifestation "absent"
           :absence-state "refused-pre-effect"
           :refusal (refusal-description-condition-name refusal)))
    ;; census.lisp:69-73 — class 2: a journaled STREAM-CLOSURE.
    ((:evidence-class :closure)
     :facets ((seat :seat) (chunks :chunks-preserved))
     (list :seat seat :manifestation "present-partial"
           :effect "crossed-unsettled-partial-closed"
           :chunks-preserved chunks))
    ;; census.lisp:74-90 — class 3: a journaled PROJECTION, and the seat's
    ;; cap2 standing must be :SETTLED.  The absence-state rider appears
    ;; exactly when the projection manifests "absent" AND the journaled
    ;; no-payload-state is a string (BODY-STRING's answer in the old
    ;; passage); the projection-origin rider exactly for recovery.
    ((:and (:evidence-class :projection) (:execution :settled))
     :facets ((seat :seat) (manifestation :manifestation)
              (state :no-payload-state) (provenance :provenance))
     (append (list :seat seat :manifestation manifestation :effect "settled")
             (when (and (equal manifestation "absent") (stringp state))
               (list :absence-state state))
             (when (eq provenance :derived-recovery)
               (list :projection-origin "derived-recovery"))))
    ;; census.lisp:82-84 — THE CROSS-AXIS GUARD, become structure: this
    ;; clause is reachable exactly when a projection exists and the
    ;; execution axis is NOT :settled, and it REFUSES.
    ((:evidence-class :projection)
     (signal-match-guard
      :projection-without-settled-execution
      :detail (format nil "seat ~a holds a projection but its cap2 ~
                           standing is ~a, not :settled"
                      (seat-outcome-seat-id outcome)
                      (seat-outcome-execution-standing outcome))))
    ;; census.lisp:91-94 — class 4: a journaled CONTROL-OUTCOME.
    ((:evidence-class :control-outcome)
     :facets ((seat :seat) (effect :effect))
     (list :seat seat :manifestation "absent" :effect effect))
    ;; census.lisp:97-100 — class 5: cap2 standing :UNCERTAIN-UNRESOLVED.
    ((:evidence-class :uncertain)
     :facets ((seat :seat))
     (list :seat seat :manifestation "absent"
           :effect "uncertain-unresolved"))
    ;; census.lisp:101-104 — class 6: cap2 standing :RECONCILED; the
    ;; resolution string was already read (typed) into the effect facet.
    ((:evidence-class :reconciled)
     :facets ((seat :seat) (effect :effect))
     (list :seat seat :manifestation "absent" :effect effect))
    ;; census.lisp:105-108 — THE TOTALITY GUARD: a founded census is
    ;; founded or it is not asserted.  OTHERWISE owns the refusal and
    ;; still holds the whole outcome.
    (otherwise
     (signal-match-guard
      :no-evidence-class
      :detail (format nil "seat ~a derives through no evidence class ~
                           (standing ~a)"
                      (seat-outcome-seat-id outcome)
                      (seat-outcome-execution-standing outcome))))))

(defun surface2-census-outcomes (store config)
  "The per-seat outcome plists in declared bank order — the NEW path."
  (let ((events (validated-store-events store)))
    (loop for seat-plist in (config-bank config)
          collect (census-seat-plist
                   (derive-seat-outcome store events
                                        (seat-field seat-plist :seat))))))

;;; The census CD/0 record built from the plists — same shape as
;;; %SEAT-OUTCOME-RECORD + DERIVE-CENSUS (census.lisp:117-159), over
;;; public CD/0 constructors.  CD/0 sorts record entries by key bytes at
;;; construction, so construction order cannot leak in.

(defun id* (&rest segments)
  (lisp-plus-journal0:identifier-from-segments segments))
(defun str* (s) (lisp-plus-cd0:make-string-datum s))
(defun int* (n) (lisp-plus-cd0:make-integer-datum n))
(defun seq* (elements) (lisp-plus-cd0:make-sequence-datum elements))
(defun entry* (segments datum)
  (lisp-plus-cd0:make-record-entry
   (lisp-plus-journal0:identifier-from-segments segments) datum))

(defun census-seat-record (plist)
  (lisp-plus-cd0:make-record-datum
   (remove nil
           (list
            (entry* '("census" "seat") (str* (getf plist :seat)))
            (entry* '("census" "manifestation")
                    (str* (getf plist :manifestation)))
            (when (getf plist :effect)
              (entry* '("census" "effect") (str* (getf plist :effect))))
            (when (getf plist :absence-state)
              (entry* '("census" "absence-state")
                      (str* (getf plist :absence-state))))
            (when (getf plist :refusal)
              (entry* '("census" "refusal") (str* (getf plist :refusal))))
            (when (getf plist :chunks-preserved)
              (entry* '("census" "chunks-preserved")
                      (int* (getf plist :chunks-preserved))))
            (when (getf plist :projection-origin)
              (entry* '("census" "projection-origin")
                      (str* (getf plist :projection-origin))))))))

(defun census-record (plists derivation-origin)
  (lisp-plus-cd0:make-record-datum
   (list (entry* '("census" "record-kind") (id* "record" "census"))
         (entry* '("census" "procedure-id") (str* "vertical-census-0"))
         (entry* '("census" "procedure-version") (int* 0))
         (entry* '("census" "derivation-origin") (str* derivation-origin))
         (entry* '("census" "seat-count") (int* (length plists)))
         (entry* '("census" "seats")
                 (seq* (mapcar #'census-seat-record plists))))))

;;; ---------------------------------------------------------------------------
(note "~%== the two paths over the same preserved fixtures ==")

(defvar *old-record* nil)
(defvar *old-plists* nil)

(check "1 the OLD path (the real DERIVE-CENSUS, census-only chain) walks ~
        campaign-1"
  (lambda ()
    (multiple-value-bind (record plists)
        (derive-census *store* *config* :derivation-origin "reconstructed")
      (setf *old-record* record *old-plists* plists)
      (= 12 (length plists)))))

(defvar *new-plists* nil)

(check "2 the NEW path (DERIVE-SEAT-OUTCOME + MATCH-OUTCOME) walks the ~
        same bank"
  (lambda ()
    (setf *new-plists* (surface2-census-outcomes *store* *config*))
    (= 12 (length *new-plists*))))

(check "3 per-seat agreement, plist for plist: all twelve seats EQUAL"
  (lambda () (equal *old-plists* *new-plists*)))

(check "4 facet-for-facet agreement on every seat: manifestation, effect, ~
        absence-state, refusal, chunk custody, projection-origin"
  (lambda ()
    (every
     (lambda (old new)
       (and (equal (getf old :seat) (getf new :seat))
            (equal (getf old :manifestation) (getf new :manifestation))
            (equal (getf old :effect) (getf new :effect))
            (equal (getf old :absence-state) (getf new :absence-state))
            (equal (getf old :refusal) (getf new :refusal))
            (equal (getf old :chunks-preserved) (getf new :chunks-preserved))
            (equal (getf old :projection-origin)
                   (getf new :projection-origin))))
     *old-plists* *new-plists*)))

(defvar *old-octets* nil)
(defvar *new-octets* nil)

(check "5 CANONICAL BYTE EQUALITY: ENCODE-PJS0 of the two census records ~
        is octet-for-octet the same"
  (lambda ()
    (setf *old-octets* (lisp-plus-journal0:encode-pjs0 *old-record*)
          *new-octets* (lisp-plus-journal0:encode-pjs0
                        (census-record *new-plists* "reconstructed")))
    (and (= (length *old-octets*) (length *new-octets*))
         (every #'eql *old-octets* *new-octets*))))

(when (and *old-octets* *new-octets*)
  (note "   old census: ~a octets, sha256 ~a"
        (length *old-octets*) (lisp-plus-journal0:sha256-hex *old-octets*))
  (note "   new census: ~a octets, sha256 ~a"
        (length *new-octets*) (lisp-plus-journal0:sha256-hex *new-octets*)))

;;; ---------------------------------------------------------------------------
(note "~%== the SURPLUS the new path retains (the old path read it and ~
       dropped it, or never lifted it) ==")

(defvar *outcomes*
  (loop for seat-plist in (config-bank *config*)
        collect (derive-seat-outcome *store* *events*
                                     (seat-field seat-plist :seat))))

(check "6 execution axis: the old census plists carry NO :execution key; ~
        every new outcome answers a cap2 standing AND retains the ~
        evidence plist behind it"
  (lambda ()
    (and (every (lambda (plist) (null (getf plist :execution))) *old-plists*)
         (every (lambda (o) (keywordp (seat-outcome-execution-standing o)))
                *outcomes*)
         (every (lambda (o) (listp (seat-outcome-execution-evidence o)))
                *outcomes*))))

(check "7 provenance: the old plist keeps only the recovery rider; the ~
        new object answers :LIVE / :DERIVED-RECOVERY / :NONE on every ~
        seat as a slot"
  (lambda ()
    (every (lambda (o) (member (seat-outcome-provenance o)
                               '(:live :derived-recovery :none)))
           *outcomes*)))

(check "8 interpretation: the old census never lifts the journaled ~
        structural class; the new object retains it for every ~
        interpreted seat"
  (lambda ()
    (and (every (lambda (plist) (null (getf plist :interpretation)))
                *old-plists*)
         (= 7 (count-if (lambda (o)
                          (stringp (nth-value
                                    0 (seat-outcome-interpretation-class o))))
                        *outcomes*)))))

(check "9 refusal explanation: the old plist keeps the condition NAME ~
        only; the new object retains name AND journaled explanation, ~
        distinct"
  (lambda ()
    (every (lambda (o)
             (multiple-value-bind (desc s) (seat-outcome-refusal o)
               (or (not (eq s :present))
                   (and (stringp (refusal-description-condition-name desc))
                        (stringp (refusal-description-explanation desc))))))
           *outcomes*)))

(check "10 the witness: every new outcome lists the journal events its ~
        derivation consulted; the old path's probes vanish into locals"
  (lambda ()
    (every (lambda (o) (listp (seat-outcome-source-events o))) *outcomes*)))

(note "   surplus per seat (retained beyond the census plist):")
(dolist (o *outcomes*)
  (note "     ~a: execution=~a evidence-events=~a provenance=~a ~
         interpretation=~a consulted=~a"
        (seat-outcome-seat-id o)
        (seat-outcome-execution-standing o)
        (count-if (lambda (key) (getf (seat-outcome-execution-evidence o) key))
                  '(:prepared :crossed :acknowledged :settled :uncertain
                    :reconciled))
        (seat-outcome-provenance o)
        (nth-value 0 (seat-outcome-interpretation-class o))
        (length (seat-outcome-source-events o))))

;;; ---------------------------------------------------------------------------
(note "~%== the two census guards, fired IDENTICALLY on mutated fixtures ==")

(defvar *scratch* #p"/tmp/surface2-inhabited-scratch/")
(when (probe-file *scratch*)
  (sb-ext:delete-directory *scratch* :recursive t))
(ensure-directories-exist (merge-pathnames "store/" *scratch*))

;;; The cross-axis fixture: an OCTET-EXACT copy of the campaign-1 store,
;;; appended (in scratch, never in place) with a projection for a seat
;;; whose attempt has NO cap2 events at all — a projection without a
;;; settled execution.
(dolist (name '("EVENTS.pj0" "JOURNAL-META.pjs" "JOURNAL-META.pjs.sha256"))
  (with-open-file (out (merge-pathnames name
                                        (merge-pathnames "store/" *scratch*))
                       :direction :output
                       :element-type '(unsigned-byte 8)
                       :if-does-not-exist :create)
    (write-sequence (file-octets (merge-pathnames
                                  name (merge-pathnames "store/" *exec*)))
                    out)))

(defvar *poison-store*
  (lisp-plus-journal0:open-store (merge-pathnames "store/" *scratch*)))

(lisp-plus-journal0:append-event
 *poison-store*
 (lisp-plus-cd0:make-record-datum
  (list (entry* '("event" "event-id")
                (id* "ap0-event" "e-seat-poison-projection"))
        (entry* '("event" "kind") (id* "ap0-record" "projection-receipt"))
        (entry* '("event" "origin") (id* "origin" "asserted"))
        (entry* '("event" "body")
                (lisp-plus-cd0:make-record-datum
                 (list (entry* '("ap0" "kernel-manifestation-status")
                               (str* "present"))))))))

(defun write-bank-config (pathname seat-id)
  (with-open-file (out pathname :direction :output
                                :if-exists :supersede
                                :if-does-not-exist :create)
    (format out "(:vertical-program-config~% (:bank ((:seat ~s))))~%"
            seat-id)))

(defvar *poison-config-path* (merge-pathnames "poison-config.sexp" *scratch*))
(write-bank-config *poison-config-path* "seat-poison")
(defvar *poison-config* (read-vertical-config *poison-config-path*))

(defvar *void-config-path* (merge-pathnames "void-config.sexp" *scratch*))
(write-bank-config *void-config-path* "seat-void")
(defvar *void-config* (read-vertical-config *void-config-path*))

(defun old-path-guard-text (store config)
  "The old census on a guard-tripping fixture: the ERROR text it refuses
with, or :NO-REFUSAL."
  (handler-case (progn (derive-census store config) :no-refusal)
    (error (condition) (format nil "~a" condition))))

(defun new-path-guard-code (store config)
  "The new passage on the same fixture: the RETAINED refusal code, or
:NO-REFUSAL."
  (handler-case (progn (surface2-census-outcomes store config) :no-refusal)
    (surface2-expansion-refused (c)
      (expansion-refusal-code (expansion-condition-refusal c)))))

(check "11 CROSS-AXIS GUARD, old path: the real census REFUSES the ~
        poison fixture (projection present, cap2 standing not :settled)"
  (lambda ()
    (let ((text (old-path-guard-text *poison-store* *poison-config*)))
      (and (stringp text)
           (search "holds a projection but its cap2" text)
           (search "seat-poison" text)))))

(check "12 CROSS-AXIS GUARD, new path: the rewritten passage refuses the ~
        SAME fixture through its refusing CLAUSE — code ~
        :PROJECTION-WITHOUT-SETTLED-EXECUTION, retained and typed"
  (lambda ()
    (eq :projection-without-settled-execution
        (new-path-guard-code *poison-store* *poison-config*))))

(check "13 TOTALITY GUARD, old path: a bank seat with no evidence at all ~
        refuses in the real census (founded or not asserted)"
  (lambda ()
    (let ((text (old-path-guard-text *store* *void-config*)))
      (and (stringp text)
           (search "derives through no evidence class" text)
           (search "seat-void" text)))))

(check "14 TOTALITY GUARD, new path: the OTHERWISE clause refuses the ~
        SAME fixture — code :NO-EVIDENCE-CLASS, retained and typed"
  (lambda ()
    (eq :no-evidence-class (new-path-guard-code *store* *void-config*))))

(check "15 both guards fire on the guard fixtures and NEITHER path ~
        refuses the lawful campaign-1 fixtures (the guards discriminate, ~
        they do not blanket)"
  (lambda ()
    (and (eq :no-refusal (new-path-guard-code *store* *config*))
         (handler-case (progn (derive-census *store* *config*) t)
           (error () nil)))))

;;; ---------------------------------------------------------------------------
(note "~%== journal effects not involved: the passage is pure ==")

(check "16 the NEW path performed NO journal append anywhere above: the ~
        preserved campaign-1 journal's bytes are digest-identical to the ~
        pre-run reading (every mutated fixture lived in scratch)"
  (lambda ()
    (equal *journal-digest-before*
           (file-sha256 (merge-pathnames "store/EVENTS.pj0" *exec*)))))

;;; ---------------------------------------------------------------------------
(note "~%== gate teeth ==")

(when (equal (sb-ext:posix-getenv "SURFACE2_INHABITED_PLANT_FAULT") "1")
  (check "PLANTED FAULT — this check must FAIL and the suite must exit 1"
    (lambda () nil)))

(when (equal (sb-ext:posix-getenv "SURFACE2_INHABITED_DIE") "1")
  (note "SURFACE2_INHABITED_DIE=1 — dying mid-run WITHOUT a RESULT ~
         sentinel (planted truncation)")
  (sb-ext:exit :code 3))

(unless (equal (sb-ext:posix-getenv "SURFACE2_INHABITED_PLANT_FAULT") "1")
  (check "17 the planted-fault gate FIRES: a child with ~
          SURFACE2_INHABITED_PLANT_FAULT=1 exits 1 carrying FAIL PLANTED ~
          FAULT"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       (list "--script"
                             "mneme/language-surface-2/surface2-inhabited.lisp")
                       :search t
                       :output output :error output
                       :environment (cons "SURFACE2_INHABITED_PLANT_FAULT=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 1 (sb-ext:process-exit-code process))
             (search "FAIL PLANTED FAULT" text)))))

  (check "18 runner truncation is detectable as exactly the pair (exit 3, ~
          no RESULT sentinel): a child with SURFACE2_INHABITED_DIE=1"
    (lambda ()
      (let* ((output (make-string-output-stream))
             (process (sb-ext:run-program
                       "sbcl"
                       (list "--script"
                             "mneme/language-surface-2/surface2-inhabited.lisp")
                       :search t
                       :output output :error output
                       :environment (cons "SURFACE2_INHABITED_DIE=1"
                                          (sb-ext:posix-environ))))
             (text (get-output-stream-string output)))
        (and (eql 3 (sb-ext:process-exit-code process))
             (not (search "RESULT:" text)))))))

;;; ---------------------------------------------------------------------------
;;; Scratch hygiene: the mutated fixtures do not outlive the run.
(when (probe-file *scratch*)
  (sb-ext:delete-directory *scratch* :recursive t))

(format t "~%surface2-inhabited: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
