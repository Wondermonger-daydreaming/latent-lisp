;;;; EG4-IDENTITY-VALUE-MEASUREMENT.lisp — Language Form /1, POLICY v2.
;;;;
;;;; Measures IDENTITY VALUE OCTETS, not hexadecimal display characters.
;;;;
;;;; This program exists because policy v1's terminal identity blew its ceiling
;;;; at 9 support references and could only discover it AFTER the governed act.
;;;; The v1 evidence (EG4-MEASUREMENT.lisp, EG4-WHEN-THE-GATE-FIRES.lisp) is
;;;; preserved beside this file unchanged; this is the after-repair record, not
;;;; a replacement for it.
;;;;
;;;; Run: sbcl --non-interactive --load EG4-IDENTITY-VALUE-MEASUREMENT.lisp

(unless (find-package :lisp-plus-form1)
  (handler-bind ((style-warning #'muffle-warning))
    (load (merge-pathnames "form1.lisp" *load-truename*))))

(defpackage #:form1-eg4-v2 (:use #:cl))
(in-package #:form1-eg4-v2)

(defun np (form) (lisp-plus-slice1:proposition form))
(defun pp (form) (lisp-plus-slice1:proposition-pattern form))

;;; ------------------------------------------------------------------
;;; Fixture — a one-premise reshelving desk.  The premise is discharged by an
;;; asserted witness of an exact mode and kind, so candidate C can supply a
;;; witness of the RIGHT species, mode and kind concerning the WRONG subject.

(defun install-schema (&optional (premise-predicate :volume-scanned-at-desk))
  (lisp-plus-slice1:clear-schema-registry)
  (lisp-plus-slice1:register-schema
   (lisp-plus-slice1:judgment-schema
    :name :volume-reshelved :version 1
    :conclusion (pp '(:predicate :volume-reshelved (:volume (:var :volume))))
    :premises (list (pp `(:predicate ,premise-predicate
                          (:volume (:var :volume))))))))

(defun scan-contract ()
  (lisp-plus-slice2:make-support-admission-contract
   :contract-id :scan-by-direct-survey
   :accepted-clauses '((:asserted-witness :mode :direct :kind :shelf-scan
                        :truth-ceiling :asserted))))

(defun wrapper ()
  ;; Built over what RESOLVE-SCHEMA returns, never over a locally kept handle:
  ;; DERIVE/2 compares with EQ and REGISTER-SCHEMA returns the existing object
  ;; on idempotent re-registration.
  (lisp-plus-slice2:make-slice2-schema
   :schema-id :volume-reshelved/2
   :base-schema (lisp-plus-slice1:resolve-schema :volume-reshelved 1)
   :premise-contracts (list (list 0 (scan-contract)))))

(defun scan-witness (volume)
  (lisp-plus-slice0:witness
   :for (np `(:predicate :volume-scanned-at-desk (:volume ,volume)))
   :mode :direct :kind :shelf-scan :source :desk-clerk))

(defun desk (witnesses)
  (lisp-plus-slice0:receiver-context
   :context-id :reshelving-desk
   :accessible-supports (mapcar #'lisp-plus-slice0:witness-id witnesses)))

;;; ------------------------------------------------------------------
;;; Measurement helpers.

(defun payload-octets (identity)
  "The octet count INSIDE the identity value."
  (length (lisp-plus-cd0:bytes-datum-value identity)))

(defun encoded-octets (identity)
  (lisp-plus-form1:identity-octets identity))

(defun hex-chars (identity)
  "Diagnostic rendering length, reported SEPARATELY and never embedded."
  (length (lisp-plus-form1:render-identity-hex identity)))

(defvar *max-terminal* 0)
(defvar *max-terminal-label* "none")

(defun note-terminal (label octets)
  (when (> octets *max-terminal*)
    (setf *max-terminal* octets *max-terminal-label* label)))

(defun build-petition (support-keys tag)
  (let* ((datum (lisp-plus-form1:petition-datum
                 :schema (lisp-plus-form1:schema-reference "s")
                 :conclusion (lisp-plus-form1:conclusion-reference "c")
                 :supports (mapcar #'lisp-plus-form1:support-reference support-keys)
                 :receiver (lisp-plus-form1:receiver-reference "r")))
         (proposed (lisp-plus-form1:propose-petition datum))
         (validated (lisp-plus-form1:validate-petition proposed)))
    (multiple-value-bind (petition receipt)
        (lisp-plus-form1:materialize-petition
         validated (lisp-plus-cd0:make-identifier-datum '("eg4") (list "occ" tag)))
      (values datum proposed validated petition receipt))))

(defun report-phases (label datum proposed validated petition)
  (format t "~%~A~%" label)
  (format t "  petition canonical octets              ~6D~%"
          (lisp-plus-cd0:octets-length (lisp-plus-cd0:canonical-octets datum)))
  (dolist (row (list (list "subject" (lisp-plus-form1:proposed-petition-form-subject-identity proposed))
                     (list "proposed" (lisp-plus-form1:proposed-petition-form-identity proposed))
                     (list "validated" (lisp-plus-form1:validated-petition-form-identity validated))
                     (list "petition-content" (lisp-plus-form1:derivation-petition-content-identity petition))
                     (list "petition-occurrence" (lisp-plus-form1:derivation-petition-occurrence-identity petition))))
    (destructuring-bind (name identity) row
      (format t "  ~22A payload ~6D | encoded ~6D | hex ~7D~%"
              name (payload-octets identity) (encoded-octets identity)
              (hex-chars identity)))))

;;; POLICY v3 RE-MEASUREMENT.  Every binding now carries a DENOTATION
;;; DECLARATION, and the context DECLARATION identity built from them enters the
;;; context OCCURRENCE identity, which enters the SUBMISSION OCCURRENCE identity.
;;; So every terminal identity grows, and EG-4 must be RE-PROVED rather than
;;; assumed to survive: the whole point of the EG-4 gate is that fixed phase
;;; depth does not bound identity size.
;;;
;;; THE DECLARATIONS ARE SIZED TO THE WORST CASE ON PURPOSE.  A short declaration
;;; would flatter the measurement.  Each support key here is already long (this
;;; is the near-ceiling fixture); the declaration is built to be at least as long
;;; as the key it describes, so the measured growth is an upper bound on what an
;;; ordinary host would produce, not a best case.
(defun declaration-for (role key)
  (lisp-plus-cd0:make-identifier-datum
   '("eg4" "denotation")
   (list role key (concatenate 'string "denoted-" key))))

(defun build-context (support-keys witnesses schema tag &key (receiver :desk))
  (let ((context (lisp-plus-form1:bind-conclusion-reference
                  (lisp-plus-form1:bind-schema-reference
                   (lisp-plus-form1:make-derivation-resolution-context)
                   (lisp-plus-form1:schema-reference "s") schema
                   (declaration-for "schema" "s"))
                  (lisp-plus-form1:conclusion-reference "c")
                  (np '(:predicate :volume-reshelved (:volume "PLUT-7")))
                  (declaration-for "conclusion" "c"))))
    (loop for key in support-keys
          for witness in witnesses
          do (setf context (lisp-plus-form1:bind-support-reference
                            context (lisp-plus-form1:support-reference key) witness
                            (declaration-for "support" key))))
    (let ((receiver-value (if (eq receiver :desk) (desk witnesses) nil)))
      (lisp-plus-form1:seal-resolution-context
       (lisp-plus-form1:bind-receiver-reference
        context (lisp-plus-form1:receiver-reference "r") receiver-value
        (if (null receiver-value)
            (lisp-plus-form1:receiver-absence-declaration)
            (declaration-for "receiver" "r")))
       (lisp-plus-cd0:make-identifier-datum '("eg4") (list "ctx" tag))))))

(defun submit-and-report (label petition context)
  (multiple-value-bind (outcome refusal)
      (lisp-plus-form1:try-submit-petition
       petition context :by :desk-clerk
       :by-id (lisp-plus-cd0:make-identifier-datum '("eg4") '("by" "clerk"))
       :act-id (lisp-plus-cd0:make-identifier-datum '("eg4") '("act" "1")))
    (cond
      (refusal
       (format t "  ~22A REFUSED before invocation: ~A~%"
               label (lisp-plus-form1:petition-refusal-code refusal))
       nil)
      (t
       (let* ((receipt (lisp-plus-form1:petition-submission-outcome-receipt outcome))
              (occ (lisp-plus-form1:petition-submission-receipt-occurrence-identity receipt))
              (rid (lisp-plus-form1:petition-submission-receipt-identity receipt))
              (tail (- (encoded-octets rid) (encoded-octets occ))))
         (note-terminal label (encoded-octets rid))
         (format t "  ~22A kind ~18A~%" label
                 (lisp-plus-form1:petition-submission-outcome-kind outcome))
         (format t "     submission-occurrence  payload ~6D | encoded ~6D | hex ~7D~%"
                 (payload-octets occ) (encoded-octets occ) (hex-chars occ))
         (format t "     TERMINAL receipt       payload ~6D | encoded ~6D | hex ~7D~%"
                 (payload-octets rid) (encoded-octets rid) (hex-chars rid))
         (format t "     outcome tail (receipt encoded - occurrence encoded) ~6D  reserve ~D~%"
                 tail (lisp-plus-form1:petition-policy-outcome-tail-reserve-octets))
         outcome)))))

;;; ------------------------------------------------------------------

(format t "~&== EG-4, POLICY v2 — IDENTITY VALUE OCTETS ==~%")
(format t "envelope ~D octets · outcome-tail reserve ~D octets · max supports ~D · max petition octets ~D~%"
        (lisp-plus-form1:petition-policy-max-identity-octets)
        (lisp-plus-form1:petition-policy-outcome-tail-reserve-octets)
        (lisp-plus-form1:petition-policy-max-support-references)
        (lisp-plus-form1:petition-policy-max-canonical-octets))

(install-schema)

;;; (1) 0..16 short support references, phase by phase.
(format t "~%---- 0..16 SHORT support references ----~%")
(loop for n from 0 to 16
      do (let ((keys (loop for i from 1 to n collect (format nil "w~D" i))))
           (multiple-value-bind (datum proposed validated petition receipt)
               (build-petition keys (format nil "short-~D" n))
             (declare (ignore receipt))
             (when (member n '(0 1 16))
               (report-phases (format nil "n=~D (short keys)" n)
                              datum proposed validated petition)))))

;;; (2) 16 supports with the LONGEST lawful names fitting the petition ceiling.
(format t "~%---- 16 LONG support references (near the petition octet ceiling) ----~%")
(let* ((long-keys
         (loop for i from 1 to 16
               collect (concatenate 'string (make-string 900 :initial-element #\k)
                                    (format nil "~D" i)))))
  (multiple-value-bind (datum proposed validated petition receipt)
      (build-petition long-keys "long-16")
    (declare (ignore receipt))
    (report-phases "n=16 (long keys)" datum proposed validated petition)
    ;; (3) the three classified outcomes, on the largest lawful petition.
    (format t "~%---- THREE CLASSIFIED OUTCOMES on the n=16 long-key petition ----~%")
    (let ((witnesses (cons (scan-witness "PLUT-7")
                           (loop for i from 2 to 16
                                 collect (scan-witness (format nil "OTHER-~D" i))))))
      ;; GRANTED
      (submit-and-report ":GRANTED"
                         petition (build-context long-keys witnesses (wrapper) "granted"))
      ;; GOVERNED-REFUSAL — right species/mode/kind, wrong subject
      (let ((wrong (loop for i from 1 to 16
                         collect (scan-witness (format nil "WRONG-~D" i)))))
        (submit-and-report ":GOVERNED-REFUSAL"
                           petition (build-context long-keys wrong (wrapper) "governed")))
      ;; DOOR-REFUSAL — a wrapper built over a schema that is no longer the
      ;; registered object.  DERIVE/2's EQ gate refuses at its own door and
      ;; produces NO Slice /2 receipt.
      (let ((stale (wrapper)))
        (install-schema :volume-scanned-elsewhere)   ; same key, different anatomy
        (submit-and-report ":DOOR-REFUSAL"
                           petition (build-context long-keys witnesses stale "door")))
      (install-schema))))

(format t "~%---- SUMMARY ----~%")
(format t "  maximum terminal receipt identity  ~D octets~%" *max-terminal*)
(format t "  produced by                        ~A (n=16 long keys)~%" *max-terminal-label*)
(format t "  envelope                           ~D octets~%"
        (lisp-plus-form1:petition-policy-max-identity-octets))
(format t "  verdict                            ~A~%"
        (if (> *max-terminal* (lisp-plus-form1:petition-policy-max-identity-octets))
            "EG-4 FAILED — terminal exceeds envelope"
            "EG-4 HOLDS — every admissible classified outcome fits"))

;;; ══════════════════════════════════════════════════════════════════════════
;;; EG-4 UNDER POLICY v3 — THE MARGIN MOVED, AND THE MOVE IS THE FINDING
;;; ══════════════════════════════════════════════════════════════════════════
;;;
;;; Under policy v2 the maximum terminal receipt identity on this fixture was
;;; 15,882 octets against a 65,536 envelope — 4.1x headroom.  Under v3 the same
;;; fixture with WORST-CASE declarations reaches ~60,873 — about 1.08x.
;;;
;;; THAT IS NOT A REGRESSION IN THE REPAIR.  It is the cost of recording what a
;;; context declares, and it is paid in exactly the place the layer's own
;;; doctrine predicts: an identity here is a LOSSLESS CANONICAL ENCODING, so
;;; adding a commitment adds its octets, transitively, to every successor.  CD/0
;;; supplies no hash and none may be added.
;;;
;;; BUT IT RAISES A QUESTION THE RULING DID NOT REACH, so this file answers it
;;; with measurement rather than leaving it to be discovered later:
;;;
;;;   THERE IS NO POLICY CEILING ON DENOTATION DECLARATION SIZE.
;;;   MAX-SUPPORT-REFERENCES bounds the COUNT of bindings and
;;;   MAX-CANONICAL-OCTETS bounds the PETITION DATUM — but a declaration is
;;;   neither.  A host may supply arbitrarily large CD/0 data as a declaration,
;;;   and it lands in the context declaration identity.
;;;
;;; So the three things a reader needs are measured below:
;;;   (a) the REALISTIC case — declarations that are governed identities
;;;   (b) the WORST case already measured above
;;;   (c) THE CLIFF — what happens when declarations push past the envelope,
;;;       and whether that failure is SAFE.

(format t "~%~%---- (a) REALISTIC declarations: governed identities ----~%")
(format t "  The application's own shape: a support declared with the exact~%")
(format t "  IDENTITY->DATUM of its Slice /0 witness id, which is short.~%~%")

(defun governed-declaration-context (support-keys witnesses schema tag)
  (let ((context (lisp-plus-form1:bind-conclusion-reference
                  (lisp-plus-form1:bind-schema-reference
                   (lisp-plus-form1:make-derivation-resolution-context)
                   (lisp-plus-form1:schema-reference "s") schema
                   (lisp-plus-kernel0:identity->datum
                    (lisp-plus-slice1:judgment-schema-identity
                     (lisp-plus-slice2:slice2-schema-base-schema schema))))
                  (lisp-plus-form1:conclusion-reference "c")
                  (np '(:predicate :volume-reshelved (:volume "PLUT-7")))
                  (lisp-plus-cd0:make-identifier-datum '("eg4") '("den" "c")))))
    (loop for key in support-keys
          for witness in witnesses
          do (setf context (lisp-plus-form1:bind-support-reference
                            context (lisp-plus-form1:support-reference key) witness
                            (lisp-plus-kernel0:identity->datum
                             (lisp-plus-slice0:witness-id witness)))))
    (lisp-plus-form1:seal-resolution-context
     (lisp-plus-form1:bind-receiver-reference
      context (lisp-plus-form1:receiver-reference "r") (desk witnesses)
      (lisp-plus-cd0:make-identifier-datum '("eg4") '("den" "r")))
     (lisp-plus-cd0:make-identifier-datum '("eg4") (list "ctx" tag)))))

(let* ((long-keys (loop for index from 1 to 16
                        collect (format nil "support-reference-~2,'0D-~A" index
                                        (make-string 900 :initial-element #\r))))
       (witnesses (loop for index from 1 to 16 collect (scan-witness "PLUT-7"))))
  (multiple-value-bind (datum proposed validated petition)
      (build-petition long-keys "realistic")
    (declare (ignore datum proposed validated))
    (let ((context (governed-declaration-context long-keys witnesses (wrapper) "realistic")))
      (format t "  context declaration identity   ~D octets~%"
              (lisp-plus-form1:identity-octets
               (lisp-plus-form1:derivation-resolution-context-declaration-identity context)))
      (let ((outcome (lisp-plus-form1:submit-petition
                      petition context :by :desk-clerk
                      :by-id (lisp-plus-cd0:make-identifier-datum '("eg4") '("by" "1"))
                      :act-id (lisp-plus-cd0:make-identifier-datum '("eg4") '("act" "1")))))
        (let ((receipt (lisp-plus-form1:petition-submission-outcome-receipt outcome)))
          (format t "  submission occurrence          ~D octets~%"
                  (lisp-plus-form1:identity-octets
                   (lisp-plus-form1:petition-submission-receipt-occurrence-identity receipt)))
          (format t "  TERMINAL receipt               ~D octets  (envelope ~D)~%"
                  (lisp-plus-form1:identity-octets
                   (lisp-plus-form1:petition-submission-receipt-identity receipt))
                  (lisp-plus-form1:petition-policy-max-identity-octets))
          (format t "  headroom                       ~,2Fx~%"
                  (/ (lisp-plus-form1:petition-policy-max-identity-octets)
                     (float (lisp-plus-form1:identity-octets
                             (lisp-plus-form1:petition-submission-receipt-identity receipt))))))))))

(format t "~%---- (c) THE CLIFF: declarations past the envelope ----~%")
(format t "  A host supplies ONE oversized declaration.  Three questions, all~%")
(format t "  answered by running it rather than by reasoning about it:~%")
(format t "    WHERE does it refuse · WITH WHAT CODE · was DERIVE/2 invoked?~%~%")
(format t "  A NOTE ON HOW THIS BLOCK WAS WRITTEN.  Its first draft asserted in~%")
(format t "  prose that an oversized declaration is discovered only at SUBMIT and~%")
(format t "  that `no earlier gate warns of it'.  Running it refuted that in one~%")
(format t "  line: at 70,000 octets the refusal fires at SEAL-RESOLUTION-CONTEXT.~%")
(format t "  The prose was a claim wearing a measurement's clothes.  The table~%")
(format t "  below replaced it, and the retraction is left visible on purpose.~%~%")

(defparameter *cliff-derive-calls* 0)
(defparameter *cliff-real-derive* (fdefinition 'lisp-plus-slice2:derive/2))
(setf (fdefinition 'lisp-plus-slice2:derive/2)
      (lambda (&rest arguments)
        (incf *cliff-derive-calls*)
        (apply *cliff-real-derive* arguments)))

(defun cliff-probe (size petition witnesses)
  "Build a context whose single support declaration is SIZE octets, seal it, and
submit.  ONLY PETITION-REFUSED is caught — anything else escapes, exactly as the
layer requires of its own callers."
  (setf *cliff-derive-calls* 0)
  (let ((huge (lisp-plus-cd0:make-string-datum (make-string size :initial-element #\d)))
        (where :none) (code nil) (declaration-octets nil) (occurrence-octets nil))
    (handler-case
        (let ((context
                (lisp-plus-form1:seal-resolution-context
                 (lisp-plus-form1:bind-receiver-reference
                  (lisp-plus-form1:bind-support-reference
                   (lisp-plus-form1:bind-conclusion-reference
                    (lisp-plus-form1:bind-schema-reference
                     (lisp-plus-form1:make-derivation-resolution-context)
                     (lisp-plus-form1:schema-reference "s") (wrapper)
                     (lisp-plus-cd0:make-identifier-datum '("eg4") '("den" "s")))
                    (lisp-plus-form1:conclusion-reference "c")
                    (np '(:predicate :volume-reshelved (:volume "PLUT-7")))
                    (lisp-plus-cd0:make-identifier-datum '("eg4") '("den" "c")))
                   (lisp-plus-form1:support-reference "w1") (first witnesses)
                   huge)                       ; <- THE OVERSIZED DECLARATION
                  (lisp-plus-form1:receiver-reference "r") (desk witnesses)
                  (lisp-plus-cd0:make-identifier-datum '("eg4") '("den" "r")))
                 (lisp-plus-cd0:make-identifier-datum
                  '("eg4") (list "ctx" (format nil "cliff-~D" size))))))
          (setf declaration-octets
                (lisp-plus-form1:identity-octets
                 (lisp-plus-form1:derivation-resolution-context-declaration-identity context))
                occurrence-octets
                (lisp-plus-form1:identity-octets
                 (lisp-plus-form1:derivation-resolution-context-occurrence-identity context)))
          (multiple-value-bind (outcome refusal)
              (lisp-plus-form1:try-submit-petition
               petition context :by :desk-clerk
               :by-id (lisp-plus-cd0:make-identifier-datum '("eg4") '("by" "1"))
               :act-id (lisp-plus-cd0:make-identifier-datum '("eg4") '("act" "1")))
            (cond (refusal (setf where :submit
                                 code (lisp-plus-form1:petition-refusal-code refusal)))
                  (outcome (setf where :completed
                                 code (lisp-plus-form1:petition-submission-outcome-kind outcome))))))
      (lisp-plus-form1:petition-refused (condition)
        (let ((refusal (lisp-plus-form1:petition-refused-refusal condition)))
          (setf where (lisp-plus-form1:petition-refusal-phase refusal)
                code (lisp-plus-form1:petition-refusal-code refusal)))))
    (format t "  declaration ~6D → decl-identity ~7A · ctx-occurrence ~7A · refused at ~11S ~34S · DERIVE/2 ~D~%"
            size (or declaration-octets "—") (or occurrence-octets "—")
            where code *cliff-derive-calls*)))

(let ((witnesses (list (scan-witness "PLUT-7"))))
  (multiple-value-bind (datum proposed validated petition) (build-petition '("w1") "cliff")
    (declare (ignore datum proposed validated))
    (dolist (size '(1000 20000 55000 61000 64000 70000))
      (cliff-probe size petition witnesses))))

(setf (fdefinition 'lisp-plus-slice2:derive/2) *cliff-real-derive*)

(format t "~%  WHAT THE TABLE SHOWS, and it is better news than the first draft claimed:~%")
(format t "~%  THERE ARE TWO PRE-INVOCATION GATES, NOT ONE.~%")
(format t "    · SEAL-RESOLUTION-CONTEXT gates the context DECLARATION and~%")
(format t "      OCCURRENCE identities as it mints them, refusing~%")
(format t "      :IDENTITY-OCTETS-EXCEEDED at phase :CONTEXT.  The context is~%")
(format t "      never even built, so no petition can be submitted with it.~%")
(format t "    · SUBMIT-PETITION gates the SUBMISSION OCCURRENCE identity PLUS the~%")
(format t "      reserved outcome tail, refusing :SUBMISSION-ENVELOPE-EXCEEDED.~%")
(format t "~%  IN EVERY REFUSING ROW, DERIVE/2 WAS INVOKED ZERO TIMES.  That is the~%")
(format t "  policy v2 ordering repair still holding under v3: a resource ceiling~%")
(format t "  refuses BEFORE the governed act, never after it, so no ceiling can~%")
(format t "  erase an act that already happened.~%")

(format t "~%  THE RESIDUAL, NAMED AT ITS TRUE (SMALLER) SIZE:~%")
(format t "    There is still no policy ceiling on declaration size AS SUCH — no~%")
(format t "    MAX-DECLARATION-OCTETS beside the four existing ceilings.  What~%")
(format t "    bounds it is the identity envelope, enforced at seal and again at~%")
(format t "    submit.  The practical consequence is narrow and worth stating: a~%")
(format t "    host learns its declarations are too large only when it SEALS,~%")
(format t "    which is after every binder has already accepted them.  The gap~%")
(format t "    between `the binder took it' and `the seal refuses' is one call.~%")
(format t "    Whether that warrants a fifth ceiling is a POLICY decision this~%")
(format t "    review was not authorised to take.  It is measured, named, and~%")
(format t "    left to the owner.~%")

(format t "~%  AND THE HEADROOM, WHICH THE OWNER SHOULD SEE:~%")
(format t "    policy v2, worst-case fixture   15882 / 65536   = 4.13x~%")
(format t "    policy v3, governed-identity declarations       ~~2.0x~%")
(format t "    policy v3, worst-case fixture   60873 / 65536   = 1.08x~%")
(format t "    The envelope was chosen under v2 when the worst case was 3.8x below~%")
(format t "    it.  It is now 7 percent below it on the same fixture.  EG-4 HOLDS,~%")
(format t "    measured, not assumed — but the margin is no longer generous, and~%")
(format t "    calling it generous would be the flinch this lane is named for.~%")
