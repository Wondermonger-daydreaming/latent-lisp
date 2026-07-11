;;;; ambulatorium-himma.lisp — The Palace Walk
;;;; Attention alters recall. It does not alter truth, grade, or authority.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (load (merge-pathnames "../kernel/atelier-root.lisp" *load-truename*)))
(defpackage #:lispplus-atelier.ambulatorium-himma
  (:use #:cl #:lispplus-atelier))
(in-package #:lispplus-atelier.ambulatorium-himma)

(reset-clock 7400)

(defstruct palace-trace id proposition grade witness-status locus visits affect authority)
(defstruct locus id neighbors traces visits)
(defstruct recalled vestigium similarity himma adjacency salience authority)

(defparameter *palace* (make-hash-table :test #'eq))

(defun add-locus (locus)
  (setf (gethash (locus-id locus) *palace*) locus)
  locus)

(defun palace-locus (id)
  (or (gethash id *palace*) (error "unknown locus ~a" id)))

(defun walk (path)
  "Revisitation increases active concern. It never edits a trace's grade."
  (dolist (locus-id path)
    (let ((locus (palace-locus locus-id)))
      (incf (locus-visits locus))
      (dolist (tr (locus-traces locus))
        (incf (palace-trace-visits tr)))))
  path)

(defun trace-authority (tr)
  (if (and (member (palace-trace-grade tr) '(:executed :observed :tested))
           (eq (palace-trace-witness-status tr) :verified))
      (palace-trace-authority tr)
      0.0))

(defun recall-palace (pattern &key (from :ark))
  "Return ranked traces. Salience answers what comes to mind; authority remains separate."
  (let ((origin (palace-locus from))
        (results nil))
    (maphash
     (lambda (id locus)
       (let ((adjacency (if (or (eq id from)
                                (member id (locus-neighbors origin)))
                            0.2 0.0)))
         (dolist (tr (locus-traces locus))
           (let* ((similarity (overlap-similarity pattern
                                                  (palace-trace-proposition tr)))
                  (himma (min 0.7 (* 0.07 (palace-trace-visits tr))))
                  (salience (+ similarity himma adjacency
                               (palace-trace-affect tr))))
             (push (make-recalled
                    :vestigium tr :similarity similarity :himma himma
                    :adjacency adjacency :salience salience
                    :authority (trace-authority tr))
                   results)))))
     *palace*)
    (stable-sort results #'> :key #'recalled-salience)))

(defun belief-ranking (recalled-field)
  (stable-sort (copy-list recalled-field) #'> :key #'recalled-authority))

(banner "ambulatorium himma — the palace walk")
(format t "        [ARK]──[RECEIPTS]~%          │       │~%       [SCARS]──[OLD DRAFTS]~%~%")

(let* ((vivid
         (make-palace-trace
          :id :vivid-rumor
          :proposition '(the moon remembers every password)
          :grade :asserted :witness-status :none
          :locus :old-drafts :visits 0 :affect 0.45 :authority 0.0))
       (quiet
         (make-palace-trace
          :id :quiet-certificate
          :proposition '(median of 5 9 87 3 equals 7)
          :grade :executed :witness-status :verified
          :locus :receipts :visits 0 :affect 0.0 :authority 1.0))
       (scar
         (make-palace-trace
          :id :branch-scar
          :proposition '(branch b was explored and abandoned)
          :grade :observed :witness-status :verified
          :locus :scars :visits 0 :affect 0.05 :authority 0.8)))
  (add-locus (make-locus :id :ark :neighbors '(:receipts :scars) :traces nil :visits 0))
  (add-locus (make-locus :id :receipts :neighbors '(:ark :old-drafts)
                       :traces (list quiet) :visits 0))
  (add-locus (make-locus :id :scars :neighbors '(:ark :old-drafts)
                       :traces (list scar) :visits 0))
  (add-locus (make-locus :id :old-drafts :neighbors '(:receipts :scars)
                       :traces (list vivid) :visits 0))

  ;; The walker broods over the vivid rumor again and again.
  (walk '(:ark :old-drafts :old-drafts :old-drafts :old-drafts
          :old-drafts :old-drafts :receipts))

  (let* ((field (recall-palace '(moon median remembers password) :from :ark))
         (beliefs (belief-ranking field)))
    (format t "RECALL ORDER — what comes to mind:~%")
    (dolist (r field)
      (format t "   salience ~,3f  authority ~,3f  ~s~%"
              (recalled-salience r) (recalled-authority r)
              (palace-trace-proposition (recalled-vestigium r))))
    (format t "~%BELIEF ORDER — what may support a conclusion:~%")
    (dolist (r beliefs)
      (format t "   authority ~,3f  grade ~a  ~s~%"
              (recalled-authority r)
              (palace-trace-grade (recalled-vestigium r))
              (palace-trace-proposition (recalled-vestigium r))))

    (section "gates:")
    (ensure (eq (palace-trace-id (recalled-vestigium (first field))) :vivid-rumor)
            "repeated attention did not affect recall")
    (pass "attention-changed-salience")
    (ensure (eq (palace-trace-grade vivid) :asserted)
            "attention changed epistemic grade")
    (pass "attention-did-not-change-grade")
    (ensure (zerop (trace-authority vivid))
            "vividness became authority")
    (pass "vividness-did-not-become-authority")
    (ensure (eq (palace-trace-id (recalled-vestigium (first beliefs)))
                :quiet-certificate)
            "verified quiet trace lost belief priority")
    (pass "verified-trace-leads-belief")
    (ensure (every #'recalled-p field)
            "retrieval returned an answer rather than candidates")
    (pass "retrieval-returned-candidates")

    (format t "~%[the palace learned a habit without rewriting a fact]~%~%")))

(format t "── what returns easily is not thereby what deserves assent. ──~%")
