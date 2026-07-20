;;;; ss0-reader.lisp — SS-0 independent second reader (Common Lisp / SBCL).
;;;; Independent implementation of the seat's recovery-state derivation and
;;;; canonical digest (spec "ss0-recovery/1", see README.md §Digest). Shares NO
;;;; code with the Python implementation; uses only the frozen substrate
;;;; (framed storage, canonical serialization, crc32). Read-only: never appends.
;;;; Usage: sbcl --script ss0-reader.lisp <run-dir>
(load (merge-pathnames "substrate/ss0-substrate.lisp" *load-truename*))
(in-package #:ss0)

(defun aval (m key &optional (default ""))
  (let ((c (assoc key m :test #'string=))) (if c (cdr c) default)))

(defun sval (m key &optional (default ""))
  (let ((v (aval m key default))) (if (stringp v) v (princ-to-string v))))

(defun pref (s p)
  (and (>= (length s) (length p)) (string= (subseq s 0 (length p)) p)))

(defun tagclass (tag)
  (cond ((pref tag "slow:") "stream")
        ((or (pref tag "effect:") (pref tag "effect-ne:")) "effect")
        ((or (pref tag "complete:") (member tag '("empty" "invalid") :test #'string=)) "payload")
        (t "unknown")))

(defun want-of (tag)
  (if (and (pref tag "slow:") (> (length tag) 5) (every #'digit-char-p (subseq tag 5)))
      (parse-integer (subseq tag 5))
      nil))

(defun as-dir (p)
  (pathname (if (and (> (length p) 0) (char= (char p (1- (length p))) #\/))
                p
                (concatenate 'string p "/"))))

(defun member-str (x xs) (member x xs :test #'string=))

(defun analyze (run-dir)
  ;; returns (values ops-hash order-list tail-keyword intact-frame-count anomalies)
  (multiple-value-bind (payloads tail) (store-read-prefix (as-dir run-dir))
    (let ((anomalies '()) (records '()) (ops (make-hash-table :test #'equal)) (order '()))
      (flet ((anom (fmt &rest args)
               (setf anomalies (append anomalies (list (apply #'format nil fmt args))))))
        (loop for p in payloads for i from 0 do
          (handler-case (push (cons i (ser-decode p)) records)
            (error () (anom "record ~D: undecodable payload" i))))
        (dolist (r (nreverse records))
          (let* ((i (car r)) (m (cdr r)) (k (sval m "k")) (opid (sval m "op")))
            (cond
              ((member-str k '("op" "succ"))
               (cond ((string= opid "")
                      (anom "record ~D: declaration without op id" i))
                     ((gethash opid ops)
                      (anom "record ~D: duplicate declaration of '~A'" i opid))
                     (t (setf (gethash opid ops) (list :decl (cons i m) :out nil :done nil
                                                       :atts nil :chunks nil :succ nil))
                        (setf order (append order (list opid))))))
              ((member-str k '("out" "done" "att" "chunk"))
               (let ((o (gethash opid ops)))
                 (cond ((null o)
                        (anom "record ~D: ~A references undeclared op '~A'" i k opid))
                       ((string= k "out")
                        (if (getf o :out)
                            (anom "record ~D: duplicate outcome for '~A'" i opid)
                            (setf (getf o :out) (cons i m))))
                       ((string= k "done")
                        (if (getf o :done)
                            (anom "record ~D: duplicate completion for '~A'" i opid)
                            (setf (getf o :done) (cons i m))))
                       ((string= k "att")
                        (setf (getf o :atts) (append (getf o :atts) (list (cons i m)))))
                       (t (setf (getf o :chunks) (append (getf o :chunks) (list (cons i m))))))))
              (t (anom "record ~D: unknown kind '~A'" i k)))))
        (dolist (opid order)                    ; successor lineage links
          (let* ((o (gethash opid ops)) (d (cdr (getf o :decl))))
            (when (string= (sval d "k") "succ")
              (let ((sup (sval d "sup")))
                (if (gethash sup ops)
                    (setf (getf (gethash sup ops) :succ)
                          (append (getf (gethash sup ops) :succ) (list opid)))
                    (anom "record ~D: successor of undeclared op '~A'" (car (getf o :decl)) sup))))))
        (dolist (opid order)                    ; attestation vs outcome conflicts
          (let ((o (gethash opid ops)))
            (when (getf o :out)
              (dolist (a (getf o :atts))
                (unless (string= (sval (cdr a) "claims") (sval (cdr (getf o :out)) "st"))
                  (anom "record ~D: attestation claims '~A' but outcome record ~D says '~A'"
                        (car a) (sval (cdr a) "claims")
                        (car (getf o :out)) (sval (cdr (getf o :out)) "st")))))))
        (values ops order tail (length payloads) anomalies)))))

(defun standing-of (o)
  (cond ((string= (tagclass (sval (cdr (getf o :decl)) "tag")) "stream")
         (if (getf o :done) "STREAM-COMPLETE" "STREAM-INCOMPLETE"))
        ((getf o :out) (if (getf o :done) "SETTLED" "OUTCOME-UNCONFIRMED"))
        ((getf o :atts)
         (if (= 1 (length (remove-duplicates (mapcar (lambda (a) (sval (cdr a) "claims")) (getf o :atts))
                                             :test #'string=)))
             "ATTESTED" "CONFLICT"))
        (t "UNRESOLVED")))

(defun csv (items) (format nil "~{~A~^,~}" items))

(defun render (ops order tail nrec anomalies)
  (with-output-to-string (s)
    (format s "ss0-recovery/1~%tail=~A~%records=~D~%anomalies=~D~%"
            (string-downcase (symbol-name tail)) nrec (length anomalies))
    (dolist (a anomalies) (format s "anomaly=~A~%" a))
    (format s "ops=~D~%" (length order))
    (dolist (opid order)
      (let* ((o (gethash opid ops))
             (d (cdr (getf o :decl)))
             (succp (string= (sval d "k") "succ"))
             (tag (sval d "tag"))
             (st (standing-of o))
             (stv (cond ((getf o :out) (sval (cdr (getf o :out)) "st"))
                        ((string= st "ATTESTED") (sval (cdr (first (getf o :atts))) "claims"))
                        (t "-")))
             (pc (if (getf o :out) (sval (cdr (getf o :out)) "pc" "absent") "-"))
             (att (if (getf o :atts)
                      (csv (mapcar (lambda (a) (format nil "~A:~A:~A" (sval (cdr a) "src")
                                                       (sval (cdr a) "sdig") (sval (cdr a) "claims")))
                                   (getf o :atts)))
                      "-"))
             (sorted (sort (copy-list (getf o :chunks)) #'<
                           :key (lambda (c) (let ((v (aval (cdr c) "i" 0))) (if (integerp v) v 0)))))
             (chunks (if sorted (csv (mapcar (lambda (c) (princ-to-string (aval (cdr c) "i" 0))) sorted)) "-"))
             (want (want-of tag)))
        (format s "op=~A|role=~A|sup=~A|tag=~A|class=~A|standing=~A|st=~A|pc=~A|conf=~A|att=~A|chunks=~A|want=~A|succ=~A~%"
                opid (if succp "successor" "initial") (if succp (sval d "sup" "-") "-") tag
                (tagclass tag) st stv pc (if (getf o :done) "1" "0") att chunks
                (if want (princ-to-string want) "-")
                (if (getf o :succ) (csv (getf o :succ)) "-"))))))

(let ((args (cdr sb-ext:*posix-argv*)))
  (if (null args)
      (format *error-output* "usage: sbcl --script ss0-reader.lisp <run-dir>~%")
      (multiple-value-bind (ops order tail nrec anomalies) (analyze (first args))
        (let ((text (render ops order tail nrec anomalies)))
          (write-string text)
          (format t "digest=~A~%" (crc32-hex (sb-ext:string-to-octets text :external-format :utf-8)))))))
