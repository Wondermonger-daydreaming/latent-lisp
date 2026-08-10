;;;; D4-env-crosswire.lisp — the ENVIRONMENT-CROSSWIRE witness (defect D4).
;;;;
;;;; Fresh image.  PUBLIC EXPORTS ONLY.  The only instrument besides this lane's
;;;; exported readers is the FILESYSTEM — a byte-exact footprint fingerprint of
;;;; every file under each run root — deliberately, so the probe cannot be
;;;; accused of reaching inside an environment to find the crosswire it reports.
;;;;
;;;; WHAT IT PROVES.  `make-ma0-environment' assigns the five exported One Act /0
;;;; run-state specials.  Constructing a SECOND environment overwrites them.  The
;;;; FIRST environment object remains a valid `ma0-environment' and
;;;; `ma0-run-program' still accepts it — but `run-act' now reaches the SECOND
;;;; environment's store and worlds through the specials, while
;;;; `ma0-complete-act' reads the FIRST environment's store through the object.
;;;; Journal events and world effects land in a store the running environment
;;;; does not own, and only AFTERWARDS does composition notice anything is wrong.
;;;;
;;;; ⚠ THE COUNT OF FILES IS THE WRONG INSTRUMENT AND IS NOT USED.  The journal
;;;; appends into an existing `store/EVENTS.pj0'; no file is created, so a
;;;; file-count probe reads a crosswired write as "nothing happened".  BYTES are
;;;; the instrument here.
;;;;
;;;;   D4-1  environment B's footprint is byte-identical across A's run.
;;;;   D4-2  BOTH footprints are byte-identical — the stale environment is
;;;;         refused BEFORE the first consequential act, with zero footprint in
;;;;         either store.
;;;;   D4-3  the run ends in the lane's TYPED stale-environment refusal, naming
;;;;         the stale environment's OWN store identifier.
;;;;   D4-4  environment B is still usable afterwards.
;;;;
;;;; BEFORE the repair D4-1..D4-4 print DEFECT-PRESENT and the script exits 1.

(require :asdf)
(let ((here (uiop:pathname-directory-pathname *load-pathname*)))
  (uiop:chdir (uiop:pathname-parent-directory-pathname
               (uiop:pathname-parent-directory-pathname
                (uiop:pathname-parent-directory-pathname here))))
  (asdf:initialize-source-registry
   `(:source-registry (:directory ,(uiop:getcwd)) :ignore-inherited-configuration)))
(asdf:load-system "lisp-plus/many-acts-0")

(defpackage #:ma0-d4 (:use #:cl))
(in-package #:ma0-d4)

(defvar *closed* 0)
(defvar *defects* 0)

(defun probe (label closed-p detail)
  (if closed-p (incf *closed*) (incf *defects*))
  (format t "  [~a] ~a~@[  ~a~]~%"
          (if closed-p "CLOSED" "DEFECT-PRESENT") label
          (if (and detail (string/= detail "")) detail nil))
  (force-output))

(defun marker (fmt &rest args)
  (format t "  -- ~a~%" (apply #'format nil fmt args))
  (force-output))

(defun footprint (root)
  "A byte-exact fingerprint of ROOT: every file's path relative to ROOT paired
with its length, sorted.  Sensitive to APPENDS, which a file count is not."
  (sort (mapcar (lambda (p)
                  (cons (enough-namestring p root)
                        (with-open-file (s p :element-type '(unsigned-byte 8))
                          (file-length s))))
                (remove-if-not #'pathname-name
                               (directory (merge-pathnames "**/*.*" root))))
        #'string< :key #'car))

(defun footprint-delta (before after)
  "The rows that changed, as a readable list."
  (let ((rows '()))
    (dolist (row after (nreverse rows))
      (let ((old (assoc (car row) before :test #'string=)))
        (unless (and old (= (cdr old) (cdr row)))
          (push (format nil "~a ~@[~d->~]~d" (car row) (and old (cdr old)) (cdr row))
                rows))))))

(defparameter +source-text+ "
(ma0-program
 (:name \"d4-subject\")
 (:input ())
 (:authority-slots (g1))
 (:steps
  (act a1 (:arm \"A\") (:authority-slot g1))
  (result \"reached-the-end\")))
")

(let* ((stem (or (uiop:getenv "TMPDIR") "/tmp"))
       (tag (random 1000000 (make-random-state t)))
       (root-a (uiop:ensure-directory-pathname (format nil "~a/ma0-d4-A-~d/" stem tag)))
       (root-b (uiop:ensure-directory-pathname (format nil "~a/ma0-d4-B-~d/" stem tag)))
       (src-dir (uiop:ensure-directory-pathname (format nil "~a/ma0-d4-src-~d/" stem tag))))
  (dolist (r (list root-a root-b src-dir)) (ensure-directories-exist r))
  (let ((source-path (merge-pathnames "d4-subject.lisp" src-dir)))
    (with-open-file (out source-path :direction :output :if-exists :supersede
                                     :external-format :utf-8)
      (write-string +source-text+ out))
    (unwind-protect
         (let* ((program (lisp-plus-many-acts0:ma0-validate source-path))
                (env-a (lisp-plus-many-acts0:make-ma0-environment
                        :root root-a :arms '("A")
                        :grants '((:slot "g1" :arm "A"))
                        :revocations '() :seat-map '() :inputs '()))
                (id-a (copy-seq (lisp-plus-many-acts0:ma0-environment-store-id env-a)))
                ;; THE SECOND ENVIRONMENT.  Nothing warns; nothing refuses.
                (env-b (lisp-plus-many-acts0:make-ma0-environment
                        :root root-b :arms '("A")
                        :grants '((:slot "g1" :arm "A"))
                        :revocations '() :seat-map '() :inputs '()))
                (id-b (copy-seq (lisp-plus-many-acts0:ma0-environment-store-id env-b))))

           ;; ⚠ AN OBSERVATION, NOT A VERDICT.  A journal store's identifier is
           ;; derived from its CONTENT, so two environments built from the same
           ;; declarations carry the SAME identifier.  The reported store-id
           ;; therefore cannot even distinguish the two stores, let alone reveal
           ;; the crosswire.  This is recorded, not scored.
           (marker "store-id A = ~a" id-a)
           (marker "store-id B = ~a" id-b)
           (marker "the two identifiers are ~a — a content-derived identifier ~
cannot discriminate these stores"
                   (if (equal id-a id-b) "IDENTICAL" "distinct"))

           (let ((a-before (footprint root-a))
                 (b-before (footprint root-b))
                 (refusal nil)
                 (outcome nil))
             (marker "before the run: A store/EVENTS.pj0 = ~a bytes, B = ~a bytes"
                     (cdr (assoc "store/EVENTS.pj0" a-before :test #'string=))
                     (cdr (assoc "store/EVENTS.pj0" b-before :test #'string=)))
             (handler-case
                 (let ((r (lisp-plus-many-acts0:ma0-run-program program env-a)))
                   (setf outcome
                         (format nil "the run RETURNED, disposition ~s"
                                 (lisp-plus-many-acts0:ma0-result-disposition r))))
               (lisp-plus-many-acts0:ma0-refusal (c)
                 (setf refusal c
                       outcome (format nil "~a [~a]: ~a" (type-of c)
                                       (lisp-plus-many-acts0:ma0-refusal-code c)
                                       (lisp-plus-many-acts0:ma0-refusal-detail c))))
               (error (c)
                 (setf outcome (format nil "an untyped condition: ~a" (type-of c)))))

             (let* ((a-after (footprint root-a))
                    (b-after (footprint root-b))
                    (a-delta (footprint-delta a-before a-after))
                    (b-delta (footprint-delta b-before b-after)))
               (marker "after the run:  A store/EVENTS.pj0 = ~a bytes, B = ~a bytes"
                       (cdr (assoc "store/EVENTS.pj0" a-after :test #'string=))
                       (cdr (assoc "store/EVENTS.pj0" b-after :test #'string=)))
               (marker "outcome: ~a" outcome)

               (probe "D4-1 environment B's store gained nothing from environment A's run"
                      (null b-delta)
                      (format nil "B changed: ~a" (or b-delta "(nothing)")))

               (probe "D4-2 neither store was touched — the refusal precedes the first consequential act"
                      (and (null a-delta) (null b-delta))
                      (format nil "A changed: ~a | B changed: ~a"
                              (or a-delta "(nothing)") (or b-delta "(nothing)")))

               (probe "D4-3 the run ended in the lane's typed stale-environment refusal, naming its own store-id"
                      (and refusal
                           (equal "MA0-ENV-STALE"
                                  (lisp-plus-many-acts0:ma0-refusal-code refusal))
                           (search id-a (lisp-plus-many-acts0:ma0-refusal-detail refusal)))
                      (format nil "~a" outcome))

               ;; ---- D4-4: is B still usable? -------------------------------
               (let ((b-outcome nil))
                 (handler-case
                     (let ((r (lisp-plus-many-acts0:ma0-run-program program env-b)))
                       (setf b-outcome
                             (format nil "returned, disposition ~s"
                                     (lisp-plus-many-acts0:ma0-result-disposition r))))
                   (error (c) (setf b-outcome (format nil "DIED: ~a" (type-of c)))))
                 (probe "D4-4 environment B is still usable afterwards"
                        (and b-outcome (null (search "DIED" b-outcome)))
                        b-outcome)))))
      (dolist (r (list root-a root-b src-dir))
        (uiop:delete-directory-tree r :validate t :if-does-not-exist :ignore))))

  (format t "~%ma0-D4-env-crosswire: ~d closed, ~d defect(s) present~%"
          *closed* *defects*)
  (uiop:quit (if (zerop *defects*) 0 1)))
