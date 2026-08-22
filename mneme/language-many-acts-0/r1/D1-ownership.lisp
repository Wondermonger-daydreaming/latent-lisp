;;;; D1-ownership.lisp — the OWNERSHIP witness (defect D1).
;;;;
;;;; Fresh image.  PUBLIC EXPORTS ONLY: nothing below names an unexported symbol
;;;; of this lane or of any predecessor.
;;;;
;;;; WHAT IT TESTS WHETHER HOLDS.  (Post-R1 wording, adoption Rider 6,
;;;; 2026-08-10: this header read "WHAT IT PROVES", and the preserved red
;;;; transcript quotes it with that word.  A fixture TESTS WHETHER a defect
;;;; is present; it proves nothing about the repaired state, whose account
;;;; is the GREEN capture beside the red one.)  The hypothesis under test:
;;;;
;;;; `copy-tree' copies cons structure and SHARES its mutable
;;;; leaves.  Every exported reader of this lane hands out a copy whose STRINGS
;;;; are the very strings the validated program, the environment, and the result
;;;; retain.  Six probes, in both directions:
;;;;
;;;;   D1-1  reader-side, source: mutate an arm name inside a returned
;;;;         `ma0-program-source' copy; a FRESH readback shows the mutation.
;;;;   D1-2  reader-side, execution: the already-validated executable program
;;;;         now runs the mutated arm.
;;;;   D1-3  caller-side, environment: mutate the caller's own input STRING
;;;;         after `make-ma0-environment' returned; the run carries the mutation.
;;;;   D1-4  reader-side, result value: mutate a returned `ma0-result-value'
;;;;         payload; a later readback shows the mutation.
;;;;   D1-5  reader-side, store-id: mutate a returned `ma0-result-store-id';
;;;;         `ma0-environment-store-id' now reports the vandalised identifier.
;;;;   D1-6  reader-side, act summary: mutate a returned
;;;;         `ma0-act-summary-arm'; a later readback shows the mutation.
;;;;
;;;; BEFORE the repair every probe prints DEFECT-PRESENT and the script exits 1.
;;;; AFTER the repair every probe prints OWNED and the script exits 0.  The same
;;;; file is the red witness and the green one; only the exit code moves.

(require :asdf)
(let ((here (uiop:pathname-directory-pathname *load-pathname*)))
  (uiop:chdir (uiop:pathname-parent-directory-pathname
               (uiop:pathname-parent-directory-pathname
                (uiop:pathname-parent-directory-pathname here))))
  (asdf:initialize-source-registry
   `(:source-registry (:directory ,(uiop:getcwd)) :ignore-inherited-configuration)))
(asdf:load-system "lisp-plus/many-acts-0")

(defpackage #:ma0-d1 (:use #:cl))
(in-package #:ma0-d1)

(defvar *owned* 0)
(defvar *defects* 0)

(defun probe (label owned-p detail)
  "OWNED means the boundary defended itself.  DEFECT-PRESENT means it did not."
  (if owned-p (incf *owned*) (incf *defects*))
  (format t "  [~a] ~a~@[  ~a~]~%"
          (if owned-p "OWNED" "DEFECT-PRESENT") label
          (if (and detail (string/= detail "")) detail nil))
  (force-output))

(defun find-string (tree wanted)
  "The first STRING in TREE that is STRING= to WANTED — the actual object, so a
caller can mutate it.  Pure data traversal over a public reader's output."
  (cond ((and (stringp tree) (string= tree wanted)) tree)
        ((consp tree) (or (find-string (car tree) wanted)
                          (find-string (cdr tree) wanted)))
        (t nil)))

(defparameter +source-text+ "
(ma0-program
 (:name \"d1-subject\")
 (:input (label))
 (:authority-slots (g1))
 (:steps
  (act a1 (:arm \"B-L1\") (:authority-slot g1))
  (result (list (ref label) \"payload-original\"))))
")

(let* ((root (uiop:ensure-directory-pathname
              (format nil "~a/ma0-d1-~d/" (or (uiop:getenv "TMPDIR") "/tmp")
                      (random 1000000 (make-random-state t)))))
       (source-path (merge-pathnames "d1-subject.lisp" root)))
  (ensure-directories-exist root)
  (with-open-file (out source-path :direction :output :if-exists :supersede
                                   :external-format :utf-8)
    (write-string +source-text+ out))
  (unwind-protect
       (let* ((program (lisp-plus-many-acts0:ma0-validate source-path))
              ;; The caller keeps its OWN string and hands it to the door.
              (caller-input (copy-seq "caller-original"))
              (environment
                (lisp-plus-many-acts0:make-ma0-environment
                 :root root
                 :arms '("B-L1" "B-L2")
                 :grants '((:slot "g1" :arm "B-L1") (:slot "g1" :arm "B-L2"))
                 :revocations '()
                 :seat-map '()
                 :inputs (list (cons "label" caller-input)))))

         ;; ---- D1-1 -----------------------------------------------------------
         (let* ((copy (lisp-plus-many-acts0:ma0-program-source program))
                (arm-string (find-string copy "B-L1")))
           (if (null arm-string)
               (probe "D1-1 source readback exposes the arm name" nil
                      "the probe could not locate \"B-L1\" in the returned copy")
               (progn
                 (setf (char arm-string 3) #\2) ; "B-L1" -> "B-L2"
                 (let* ((fresh (lisp-plus-many-acts0:ma0-program-source program))
                        (leaked (find-string fresh "B-L2")))
                   (probe "D1-1 mutating a returned source copy leaves the retained source unchanged"
                          (null leaked)
                          (format nil "fresh readback arm = ~s"
                                  (if leaked "B-L2" "B-L1")))))))

         ;; ---- D1-3 (mutate BEFORE the run, after the door returned) ----------
         (setf (char caller-input 0) #\X) ; "caller-original" -> "Xaller-original"

         (let ((result (lisp-plus-many-acts0:ma0-run-program program environment)))

           ;; ---- D1-2 ---------------------------------------------------------
           (let* ((summaries (lisp-plus-many-acts0:ma0-result-act-summaries result))
                  (ran (and summaries
                            (lisp-plus-many-acts0:ma0-act-summary-arm (first summaries)))))
             (probe "D1-2 the validated program still executes the arm its text named"
                    (equal "B-L1" ran)
                    (format nil "source text named \"B-L1\"; executed ~s" ran)))

           ;; ---- D1-3 ---------------------------------------------------------
           (let* ((value (lisp-plus-many-acts0:ma0-result-value result))
                  (carried (and (consp value) (first value))))
             (probe "D1-3 the environment owns its declared input"
                    (equal "caller-original" carried)
                    (format nil "declared \"caller-original\"; run carried ~s" carried)))

           ;; ---- D1-4 ---------------------------------------------------------
           (let* ((value (lisp-plus-many-acts0:ma0-result-value result))
                  (payload (find-string value "payload-original")))
             (if (null payload)
                 (probe "D1-4 result value readback exposes the payload" nil
                        "the probe could not locate the payload string")
                 (progn
                   (setf (char payload 0) #\Z)
                   (let* ((fresh (lisp-plus-many-acts0:ma0-result-value result))
                          (leaked (find-string fresh "Zayload-original")))
                     (probe "D1-4 mutating a returned result value leaves the retained result unchanged"
                            (null leaked)
                            (format nil "fresh readback payload = ~s"
                                    (if leaked "Zayload-original" "payload-original")))))))

           ;; ---- D1-5 ---------------------------------------------------------
           (let* ((declared (copy-seq (lisp-plus-many-acts0:ma0-environment-store-id
                                       environment)))
                  (handed (lisp-plus-many-acts0:ma0-result-store-id result)))
             (if (or (null handed) (zerop (length handed)))
                 (probe "D1-5 result store-id readback exposes an identifier" nil
                        "no store-id was returned")
                 (progn
                   (setf (char handed 0) #\Z)
                   (let ((now (lisp-plus-many-acts0:ma0-environment-store-id environment)))
                     (probe "D1-5 mutating a returned store-id leaves the environment's identifier unchanged"
                            (equal declared now)
                            (format nil "declared ~s; environment now reports ~s"
                                    declared now))))))

           ;; ---- D1-6 ---------------------------------------------------------
           (let* ((summaries (lisp-plus-many-acts0:ma0-result-act-summaries result))
                  (summary (first summaries))
                  (handed (and summary
                               (lisp-plus-many-acts0:ma0-act-summary-arm summary))))
             (if (or (null handed) (zerop (length handed)))
                 (probe "D1-6 act-summary readback exposes an arm name" nil
                        "no arm name was returned")
                 (let ((before (copy-seq handed)))
                   (setf (char handed 0) #\Z)
                   (let ((now (lisp-plus-many-acts0:ma0-act-summary-arm summary)))
                     (probe "D1-6 mutating a returned act-summary arm leaves the summary unchanged"
                            (equal before now)
                            (format nil "was ~s; summary now reports ~s" before now))))))))
    (uiop:delete-directory-tree root :validate t :if-does-not-exist :ignore))

  (format t "~%ma0-D1-ownership: ~d owned, ~d defect(s) present~%"
          *owned* *defects*)
  (uiop:quit (if (zerop *defects*) 0 1)))
