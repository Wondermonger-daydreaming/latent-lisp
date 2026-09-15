(defparameter cl-user::*p8-lane* (concatenate 'string (nth 1 sb-ext:*posix-argv*) "/"))
(load (merge-pathnames "ml0-suite-ground.lisp" (pathname cl-user::*p8-lane*)))
(in-package #:lisp-plus-memory-layer0)
(defparameter *root* (ml0-fresh-run-root "ml0-p8-diag" #p"mneme/../"))
(unwind-protect
 (progn
  (ml0-ground *root*)
  (let ((row (ml0-settled-row)))
    (setf lisp-plus-language-act1:*act1-fixture-table* (list row))
    (ml0-open-authority (list row))
    (let* ((result (lisp-plus-language-act1:run-act1 row :verbose nil))
           (subject (ml0-subject-from-fixture-row row))
           (acct (ml0-write *ml0-account-store*
                  (make-ml0-bundle :fixture-row row
                   :claimed-act-id (ml0-subject-act-id subject)
                   :subject-principal "the actor"
                   :observations (list (ml0-observe-world subject (ml0-world))
                                       (ml0-observe-journal subject *ml0-act-store*))
                   :issuance-observation (ml0-observe-issuance subject (lisp-plus-language-act1:act1-result-evidence result))
                   :sources (list (ml0-self-report-source (ml0-subject-act-id subject)
                                    "the writing process read both instruments itself"))
                   :effect-observation (ml0-effect-observation-of (ml0-subject-attempt subject)))))
           (hex (ml0-account-id-hex acct))
           (retr (ml0-retrieve *ml0-account-store* :account-hex hex))
           (body (ml0-account-body-record retr))
           (mine (ml0-account-envelope :account-hex hex
                   :subject-attempt (ml0-account-subject-attempt retr)
                   :subject-principal (ml0-account-subject-principal retr)
                   :recording-process +ml0-runtime-process-name+
                   :body body :derivation :direct-write))
           (report (validate-journal *ml0-account-store*))
           (stored (aref (prefix-report-events report) 0)))
      (format t "~&EQUAL-ENVELOPE: ~a~%" (same-datum-p mine stored))
      (format t "~&subject-attempt from account: ~s~%" (ml0-account-subject-attempt retr))
      (format t "~&subject-attempt from subject: ~s~%" (ml0-subject-attempt subject))
      (format t "~&runtime-process-name: ~s~%" +ml0-runtime-process-name+)
      (loop for i below (lisp-plus-cd0:record-datum-size stored)
            for k = (lisp-plus-cd0:record-datum-key-at stored i)
            for sv = (lisp-plus-cd0:record-datum-value-at stored i)
            for mv = (lisp-plus-cd0:record-datum-ref mine k)
            do (format t "~&FIELD ~a equal=~a~%   stored=~a~%   mine  =~a~%"
                       (identifier-segment-string k) (and mv (same-datum-p sv mv))
                       (lisp-plus-cd0:render-diagnostic sv)
                       (if mv (lisp-plus-cd0:render-diagnostic mv) "<ABSENT>")))
      (format t "~&SIZES stored=~d mine=~d~%"
              (lisp-plus-cd0:record-datum-size stored) (lisp-plus-cd0:record-datum-size mine)))))
 (ignore-errors (sb-ext:delete-directory *root* :recursive t)))
