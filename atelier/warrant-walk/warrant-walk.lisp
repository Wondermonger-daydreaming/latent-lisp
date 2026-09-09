;;;; warrant-walk.lisp — WARRANT WALK /0, an experimental Lisp specimen.
;;;;
;;;; Question: which support did this conclusion actually use?
;;;; Source:   WARRANT CALCULUS /0.2 + ADDENDUM A + corrected ADDENDUM B (documentary).
;;;; Ceiling:  experimental executable contact with the documentary calculus. Not a policy.
;;;; Rules:    WW-R1..R7 and assumptions EA-1..EA-7 are in EXPECTATIONS-0.md (pre-registered,
;;;;           commit 94b5a468). The DEFECTIVE walker is isolated at the bottom and labelled.
;;;; Run:      sbcl --script warrant-walk.lisp            ; transcript of all cases
;;;;           sbcl --script warrant-walk.lisp --check    ; transcript + comparison to expectations.lisp
;;;; Chair:    Claude Fable 5.1, "The Cache Is Never An Input" [e1ca41], 2026-09-08.
;;;; REPAIR (2026-09-08, on Astra's review; EXPECTATIONS-1.md pre-registered at b05d1332):
;;;;   WW-R8 claim/support correspondence at root and every premise (:mistargeted);
;;;;   WW-R9 active recursion PATH vs completed routes (shared support is not a cycle; memoized);
;;;;   WW-R7 bounded to policy ww-r-0 (:unsupported-policy otherwise). Pre-repair source preserved
;;;;   in git at d8c4d860; the four probes measured against it in probes-pre-repair-CONFIRMED.txt.

(defpackage :warrant-walk
  (:use :cl)
  (:export #:assess #:reassess #:assess-defective #:run-all #:main))
(in-package :warrant-walk)

;;; ------------------------------------------------------------------ store access
;;; A store is a list of plists. Ids are symbols (EA-1). No identity scheme is implemented.

(defun find-record (store id &optional kind)
  "The first record whose :id is ID (and whose :kind is KIND, when given); NIL if absent."
  (find-if (lambda (r) (and (eq (getf r :id) id)
                            (or (null kind) (eq (getf r :kind) kind))))
           store))

(defun records-for (store claim)
  "Every :route and :evidence record whose :for is CLAIM. Used by the corrected walker only to
LIST what it did not enter (WW-R2), and by the DEFECTIVE walker to gather them all."
  (remove-if-not (lambda (r) (and (member (getf r :kind) '(:route :evidence))
                                  (eq (getf r :for) claim)))
                 store))

(defun carried-testimony (store)
  "Every (CLAIM STATUS) pair carried on a :claim record. Echoed, never read by a rule (WW-R1)."
  (loop for r in store
        when (and (eq (getf r :kind) :claim) (getf r :carried-status))
          collect (list (getf r :id) (getf r :carried-status))))

;;; ------------------------------------------------------------------ the walk (corrected)
;;; An accumulator plist is threaded through the recursion. Each field is a list built in walk order.

(defstruct (acc (:conc-name acc-))
  (followed '()) (evidence '()) (unresolved '()) (missing '()) (inadequate '())
  (not-entered '()) (rules '()) (visited '()) (cycle '())
  (path '()) (completed '()) (shared '()) (mistargeted '()))

(defun note-rule (acc rule) (pushnew rule (acc-rules acc)))

(defun walk-route (store route-id acc)
  "Follow ROUTE-ID's premises, each through exactly the support it names (WW-R2)."
  (let ((route (find-record store route-id :route)))
    ;; WW-R9: a cycle is a route on the CURRENT recursion path; a completed route reached again is shared
    ;; support — its outcome stands, it is not re-walked. (Repair of the d8c4d860 guard, which never
    ;; released completed routes and called shared acyclic support a cycle — Astra R1, measured.)
    (when (member route-id (acc-path acc))
      (note-rule acc :ww-r9)
      ;; run 3 (E9 FAILED on presentation): the diagnostic repeated the reached route at the end of the
      ;; path; the pre-registered form names the back-edge target once (first element) and the ACTIVE
      ;; path as it stood. Presentation only; :result was :cycle in both runs.
      (push (list route-id :on-path (reverse (acc-path acc))) (acc-cycle acc))
      (return-from walk-route acc))
    (when (member route-id (acc-completed acc))
      (note-rule acc :ww-r9)
      (pushnew (list route-id :reached-again-via (first (acc-path acc))) (acc-shared acc) :test #'equal)
      (return-from walk-route acc))
    (push route-id (acc-path acc))
    (push route-id (acc-visited acc))
    (unless (getf route :adequate)                                                   ; WW-R5
      (note-rule acc :ww-r5) (push (list route-id :inadequate) (acc-inadequate acc)))
    (dolist (prem (getf route :premises)
                  (progn (pop (acc-path acc)) (push route-id (acc-completed acc)) acc))
      (destructuring-bind (claim &key via) prem
        ;; alternatives for CLAIM that this route did NOT name: listed, not entered (WW-R2)
        (dolist (alt (records-for store claim))
          (unless (eq (getf alt :id) via)
            (pushnew (list (getf alt :id) :for claim) (acc-not-entered acc) :test #'equal)))
        (cond
          ((eq via :unresolved)                                                      ; WW-R3
           (note-rule acc :ww-r3)
           (push (list claim :on route-id) (acc-unresolved acc)))
          (t
           (let ((support (find-record store via)))
             (cond
               ((null support)                                                        ; WW-R4
                ;; REPAIR after run 1 (E5 FAILED): an attempted reference that resolves to nothing was
                ;; being listed under :followed as well as :missing. "Followed" means REACHED; a missing
                ;; reference is recorded once, under :missing, with its claim and route. Pre-registered
                ;; E5 expected :followed ((p :via d2)) and was right.
                (note-rule acc :ww-r4)
                (push (list via :for claim :on route-id) (acc-missing acc)))
               ((not (eq (getf support :for) claim))                                 ; WW-R8
                ;; the record exists and may be adequate — but it is for another claim. Not "missing".
                (note-rule acc :ww-r8)
                (push (list :requested claim :via via :target (getf support :for) :on route-id)
                      (acc-mistargeted acc)))
               ((eq (getf support :kind) :evidence)
                (note-rule acc :ww-r2)
                (push (list claim :via via) (acc-followed acc))
                (push via (acc-evidence acc))
                (unless (getf support :adequate)                                      ; WW-R5
                  (note-rule acc :ww-r5) (push (list via :inadequate) (acc-inadequate acc))))
               ((eq (getf support :kind) :route)
                (note-rule acc :ww-r2)
                (push (list claim :via via) (acc-followed acc))
                (walk-route store via acc))
               (t (push (list via :for claim :on route-id :wrong-kind (getf support :kind))
                        (acc-missing acc)))))))))))

(defun result-word (acc)
  "WW-R6 + EA-8: cycle > mistargeted > missing > inadequate > unresolved > established. Experimental ordering."
  (cond ((acc-cycle acc) :cycle)
        ((acc-mistargeted acc) :mistargeted)
        ((acc-missing acc) :blocked)
        ((acc-inadequate acc) :not-established)
        ((acc-unresolved acc) :conditional)
        (t :established)))

(defun explain (word acc route)
  (ecase word
    (:established (format nil "every premise of ~a was followed through the support it named to adequate evidence; nothing unresolved, nothing missing" route))
    (:conditional (format nil "the selected route names an explicitly unresolved premise: ~{~a~^, ~}; the conclusion is conditional on it and on nothing outside the selected closure" (mapcar #'first (acc-unresolved acc))))
    (:blocked     (format nil "selected support could not be found in the store: ~{~a~^, ~}; no alternative route was substituted (routes not entered: ~{~a~^, ~})" (mapcar #'first (acc-missing acc)) (mapcar #'first (acc-not-entered acc))))
    (:not-established (format nil "a followed record is marked inadequate by the fixture: ~{~a~^, ~}" (mapcar #'first (acc-inadequate acc))))
    (:mistargeted (format nil "selected support exists but is for another claim: ~{~a~^; ~} — an adequate record for another claim cannot establish this one"
                          (mapcar (lambda (m) (format nil "~a asked of ~a which is for ~a" (getf m :requested) (getf m :via) (getf m :target))) (acc-mistargeted acc))))
    (:cycle (format nil "a route on the current recursion path was reached again: ~{~a~^; ~} — a genuine back-edge (EA-7 violated); the walk stopped rather than loop"
                    (mapcar (lambda (c) (format nil "~a on path ~a" (first c) (getf (rest c) :on-path))) (acc-cycle acc))))))

(defun report (store claim route acc &rest extra)
  (let ((word (result-word acc)))
    (note-rule acc :ww-r1) (note-rule acc :ww-r6)
    (append
     (list :claim claim :route route :result word
           :followed (reverse (acc-followed acc))
           :evidence (reverse (acc-evidence acc))
           :unresolved (reverse (acc-unresolved acc))
           :missing (reverse (acc-missing acc))
           :inadequate (reverse (acc-inadequate acc))
           :not-entered (reverse (acc-not-entered acc))
           :mistargeted (reverse (acc-mistargeted acc))
           :shared (reverse (acc-shared acc))
           :cycle (reverse (acc-cycle acc))
           :carried-status-testimony (carried-testimony store)
           :rules (reverse (acc-rules acc))
           :explanation (explain word acc route))
     extra)))

(defun assess (store claim &key via)
  "Assess CLAIM through the route VIA in STORE. The corrected walker."
  (let ((acc (make-acc))
        (root (find-record store via :route)))
    (when (and root (not (eq (getf root :for) claim)))                                ; WW-R8 at the root
      (return-from assess
        (list :claim claim :route via :result :mistargeted
              :mistargeted (list (list :requested claim :via via :target (getf root :for) :on :call))
              :followed () :unresolved () :missing () :not-entered ()
              :carried-status-testimony (carried-testimony store)
              :rules '(:ww-r8 :ww-r1 :ww-r6)
              :explanation (format nil "the route named at the call is for ~a, not ~a; nothing was walked" (getf root :for) claim))))
    (unless root
      (return-from assess (list :claim claim :route via :result :blocked
                                :missing (list (list via :for claim :on :call))
                                :followed () :unresolved () :not-entered ()
                                :carried-status-testimony (carried-testimony store)
                                :rules '(:ww-r4 :ww-r1 :ww-r6)
                                :explanation "the route named at the call is not in the store")))
    (walk-route store via acc)
    (report store claim via acc)))

(defun reassess (store claim &key via at)
  "WW-R7: assess against the retained snapshot AT; if none is retained, :cannot-reconstruct and nothing else."
  (let ((snap (find-record store at :snapshot)))
    (cond
      ((and snap (not (eq (getf snap :policy) 'ww-r-0)))                              ; WW-R7 bounded
       (list :claim claim :route via :at at :result :unsupported-policy :policy (getf snap :policy)
             :reason (format nil "the retained snapshot's policy label ~a is not ww-r-0; this pinned implementation implements ww-r-0 only and will not run present code under another label" (getf snap :policy))
             :rules '(:ww-r7) :carried-status-testimony (carried-testimony store)))
      ((null snap)
        (list :claim claim :route via :at at :result :cannot-reconstruct
              :reason (format nil "no snapshot with :id ~a is retained in the store; the historical policy and state cannot be reconstructed from the present store or from timestamps; the earlier assessment, if any, stands as testimony" at)
              :rules '(:ww-r7)
              :carried-status-testimony (carried-testimony store)))
      (t
        (append (assess (getf snap :store) claim :via via)
                (list :at at :policy (getf snap :policy) :state-scope (list :snapshot at)
                      :bounded-to "ww-r-0 = this pinned implementation; the label is a symbol, not retained executable semantics"))))))

;;; ------------------------------------------------------------------ DEFECTIVE walker (isolated)
;;; WW-DEFECTIVE: gathers EVERY route and evidence record :for each premise claim, regardless of
;;; the support the route named. Exists to be wrong on the two-route fixture. Never called by ASSESS.

(defun defective-walk-route (store route-id acc)
  (let ((route (find-record store route-id :route)))
    (when (member route-id (acc-visited acc))
      (push (list :cycle route-id) (acc-cycle acc)) (return-from defective-walk-route acc))
    (push route-id (acc-visited acc))
    (dolist (prem (getf route :premises) acc)
      (destructuring-bind (claim &key via) prem
        (when (eq via :unresolved)
          (push (list claim :on route-id) (acc-unresolved acc)))
        ;; THE DEFECT: every record :for CLAIM is gathered and entered, selection ignored.
        (dolist (r (records-for store claim))
          (push (list claim :via (getf r :id)) (acc-followed acc))
          (ecase (getf r :kind)
            (:evidence (push (getf r :id) (acc-evidence acc)))
            (:route (defective-walk-route store (getf r :id) acc))))))))

(defun assess-defective (store claim &key via)
  "DEFECTIVE comparison walker. Labelled. Imports obligations from routes the conclusion never selected."
  (let ((acc (make-acc)))
    (defective-walk-route store via acc)
    (note-rule acc :ww-defective)
    (let ((word (result-word acc)))
      (list :walker :DEFECTIVE :claim claim :route via :result word
            :followed (reverse (acc-followed acc)) :evidence (reverse (acc-evidence acc))
            :unresolved (reverse (acc-unresolved acc)) :missing (reverse (acc-missing acc))
            :not-entered () :rules (reverse (acc-rules acc))
            :explanation "DEFECTIVE: gathered every warrant attached to each premise regardless of route selection"))))

;;; ------------------------------------------------------------------ fixtures (EXPECTATIONS-0.md §4)

(defparameter *s0*
  '((:kind :claim :id c) (:kind :claim :id p) (:kind :claim :id s) (:kind :claim :id q)
    (:kind :route :id dc :for c :adequate t :premises ((p :via d2)))
    (:kind :route :id d2 :for p :adequate t :premises ((s :via e-s)))
    (:kind :evidence :id e-s :for s :adequate t)))

(defparameter *d1* '(:kind :route :id d1 :for p :adequate t :premises ((q :via :unresolved))))

(defun replace-record (store id new) (substitute-if new (lambda (r) (eq (getf r :id) id)) store))
(defun remove-record (store id) (remove-if (lambda (r) (eq (getf r :id) id)) store))

(defparameter *s1* (append *s0* (list *d1*)))
(defparameter *s2* (replace-record *s1* 'dc '(:kind :route :id dc :for c :adequate t :premises ((p :via d1)))))
(defparameter *s3* (append (replace-record *s2* 'd1 '(:kind :route :id d1 :for p :adequate t :premises ((q :via e-q))))
                           (list '(:kind :evidence :id e-q :for q :adequate t))))
(defparameter *s4* (remove-record *s1* 'e-s))
(defparameter *s5* (replace-record *s4* 'c '(:kind :claim :id c :carried-status :established)))
(defparameter *s6* *s4*)                                            ; no snapshot records at all
(defparameter *s7* (append *s1* (list (list :kind :snapshot :id 1 :policy 'ww-r-0 :store *s0*))))

(defparameter *s8*  (append (replace-record *s0* 'dc '(:kind :route :id dc :for c :adequate t :premises ((p :via d2) (r :via dr))))
                            (list '(:kind :claim :id r) '(:kind :route :id dr :for r :adequate t :premises ((p :via d2))))))
(defparameter *s9*  (append (replace-record *s0* 'd2 '(:kind :route :id d2 :for p :adequate t :premises ((s :via dx))))
                            (list '(:kind :route :id dx :for s :adequate t :premises ((c :via dc))))))
(defparameter *s10* *s0*)
(defparameter *s11* (replace-record *s0* 'e-s '(:kind :evidence :id e-s :for q :adequate t)))
(defparameter *s12* (replace-record *s0* 'd2 '(:kind :route :id d2 :for q :adequate t :premises ((s :via e-s)))))
(defparameter *s13* (append *s1* (list (list :kind :snapshot :id 2 :policy 'ww-r-99 :store *s0*))))

(defparameter *stores* (list (cons :s0 *s0*) (cons :s1 *s1*) (cons :s2 *s2*) (cons :s3 *s3*)
                             (cons :s4 *s4*) (cons :s5 *s5*) (cons :s6 *s6*) (cons :s7 *s7*)
                             (cons :s8 *s8*) (cons :s9 *s9*) (cons :s10 *s10*) (cons :s11 *s11*)
                             (cons :s12 *s12*) (cons :s13 *s13*)))

;;; ------------------------------------------------------------------ cases and transcript

(defparameter *cases*
  '((:e1   :s0 "Baseline: C selects complete D2 for P"                     (assess c :via dc))
    (:e2   :s1 "Add unused D1 requiring unresolved Q"                       (assess c :via dc))
    (:e2-d :s1 "SAME store, DEFECTIVE walker (gathers every warrant)"       (assess-defective c :via dc))
    (:e3   :s2 "Switch C's selection to D1"                                 (assess c :via dc))
    (:e4   :s3 "Supply adequate fixture support e-q for Q"                  (assess c :via dc))
    (:e5   :s4 "Remove selected supporting record e-s"                      (assess c :via dc))
    (:e6   :s5 "Carried :established label on C after removing support"     (assess c :via dc))
    (:e7   :s6 "Historical reassessment at tick 0, no snapshot retained"    (reassess c :via dc :at 0))
    (:e7-c :s7 "Positive control: reassessment at tick 1, snapshot retained" (reassess c :via dc :at 1))
    ;; EXPECTATIONS-1 (Astra's review, pre-registered b05d1332)
    (:e8   :s8  "Shared acyclic support: DC->D2 and DC->DR->D2 (was a false :cycle)"  (assess c :via dc))
    (:e9   :s9  "Genuine back-edge: DC->D2->DX->DC"                                    (assess c :via dc))
    (:e10  :s10 "Root mistarget: assess Q via DC, a route for C"                       (assess q :via dc))
    (:e11  :s11 "Leaf mistarget: e-s is for Q, asked to support S"                     (assess c :via dc))
    (:e12  :s12 "Subordinate mistarget: d2 is for Q, asked to support P"               (assess c :via dc))
    (:e13  :s13 "Snapshot with policy label ww-r-99: refused, not run"                  (reassess c :via dc :at 2))))

(defun run-case (case)
  (destructuring-bind (label store-name title call) case
    (let* ((store (cdr (assoc store-name *stores*)))
           (fn (first call)) (claim (second call)) (args (cddr call))
           (rep (apply (symbol-function fn) store claim args)))
      (list label title rep))))

(defun print-report (label title rep)
  (format t "~&~%=== ~a — ~a~%" label title)
  (loop for (k v) on rep by #'cddr do (format t "  ~(~s~) ~s~%" k v)))

(defun run-all ()
  (format t "WARRANT WALK /0 — transcript. ~a ~a. Rules WW-R1..R7, EA-1..EA-7 per EXPECTATIONS-0.md.~%"
          (lisp-implementation-type) (lisp-implementation-version))
  (mapcar (lambda (c) (destructuring-bind (l ti r) (run-case c) (print-report l ti r) (list l r))) *cases*))

;;; ------------------------------------------------------------------ --check against expectations.lisp

(defun set-equal (a b) (and (subsetp a b :test #'equal) (subsetp b a :test #'equal)))

(defun check-one (label rep exp)
  "EXP is (label store call result . fields). Compare :result exactly; listed fields as sets; :at/:policy exactly."
  (let ((fails '()))
    (unless (eq (getf rep :result) (fourth exp))
      (push (list :result :expected (fourth exp) :got (getf rep :result)) fails))
    (loop for (k v) on (nthcdr 4 exp) by #'cddr
          do (let ((got (getf rep k :absent)))
               (unless (if (member k '(:at :policy)) (equal got v) (and (listp got) (set-equal got v)))
                 (push (list k :expected v :got got) fails))))
    (when (and (member (fourth exp) '(:cannot-reconstruct :unsupported-policy))
               (member (getf rep :result) '(:established :conditional :blocked :not-established)))
      (push (list :leak :result (getf rep :result)) fails))
    (list label (if fails :FAIL :PASS) (reverse fails))))

(defun check-all (results)
  (setf *print-pretty* nil)
  (load (merge-pathnames "expectations.lisp" (or *load-truename* *default-pathname-defaults*)))
  (load (merge-pathnames "expectations-1.lisp" (or *load-truename* *default-pathname-defaults*)))
  (let* ((exps (append (symbol-value (intern "*EXPECTATIONS*" :warrant-walk))
                       (symbol-value (intern "*EXPECTATIONS-1*" :warrant-walk))))
         (rows (loop for (label rep) in results
                     for exp = (find label exps :key #'first)
                     collect (check-one label rep exp))))
    (format t "~&~%=== CHECK against expectations.lisp (pre-registered) ===~%")
    (dolist (r rows) (format t "  ~a ~a~{ ~s~}~%" (first r) (second r) (third r)))
    (let ((n (count :PASS rows :key #'second)) (m (length rows)))
      (format t "  PASS ~a/~a — FAIL ~a~%" n m (- m n))
      ;; the decisive comparison, stated as its own line
      (let ((e2 (second (find :e2 results :key #'first))) (e2d (second (find :e2-d results :key #'first))))
        (format t "  DECISIVE E2 vs E2-D: corrected ~s with unresolved ~s and not-entered ~s | defective ~s with unresolved ~s — ~a~%"
                (getf e2 :result) (getf e2 :unresolved) (getf e2 :not-entered)
                (getf e2d :result) (getf e2d :unresolved)
                (if (and (eq (getf e2 :result) :established) (null (getf e2 :unresolved))
                         (eq (getf e2d :result) :conditional) (getf e2d :unresolved))
                    "DEFECT EXPOSED" "DEFECT NOT EXPOSED — the specimen failed")))
      (- m n))))

(defun main ()
  (let ((results (run-all)))
    (when (member "--check" sb-ext:*posix-argv* :test #'string=)
      (sb-ext:exit :code (if (zerop (check-all results)) 0 1)))))

(main)
