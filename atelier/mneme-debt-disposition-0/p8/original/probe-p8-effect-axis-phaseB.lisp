;;;; Probe P8 / SPEC §5, R4 amendment: the effect axis is :caller-asserted.

(load "/mnt/venue/WORK/substrate/lane/ml0-suite-ground.lisp")

(in-package #:lisp-plus-memory-layer0)

(format t "~&=== Probe P8 / SPEC §5 R4: effect axis is :caller-asserted ===~%")

;; 1) Default for ml0-effect-observation is :caller-asserted
(format t "~&--- 1) default provenance ---~%")
(defparameter *default-obs*
  (make-ml0-effect-observation :standing-as-read "ground"
                               :determinacy :determinate
                               :world-digest "deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
                               :scope (make-ml0-scope :universe "u" :status :looked
                                                      :detail "d")))
(format t "~&default provenance: ~s~%" (ml0-effect-observation-provenance *default-obs*))
(format t "~&is :caller-asserted? ~a~%" (eq :caller-asserted (ml0-effect-observation-provenance *default-obs*)))

;; 2) Public make-ml0-effect-observation refuses :provenance
(format t "~&--- 2) public door refuses :provenance ---~%")
(defparameter *forge-refused* nil)
(defparameter *forge-error* nil)
(handler-case
    (make-ml0-effect-observation :standing-as-read "ground"
                                 :determinacy :determinate
                                 :world-digest "deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
                                 :scope (make-ml0-scope :universe "u" :status :looked
                                                        :detail "d")
                                 :provenance :observed)  ;; forgery
  (ml0-provenance-incomplete (e)
    (setf *forge-refused* t
          *forge-error* e)
    (format t "~&REFUSED [ML0-EFF-2 or similar]: ~a~%" e))
  (error (e)
    (setf *forge-refused* t
          *forge-error* e)
    (format t "~&REFUSED (~a): ~a~%" (type-of e) e)))

;; 3) Durable bytes carry :caller-asserted
(format t "~&--- 3) durable bytes carry :caller-asserted ---~%")
(defvar *root* (ml0-fresh-run-root "ml0-probe-p8" #p"mneme/../"))
(ml0-ground *root*)
(defvar *row* (ml0-settled-row))
(setf lisp-plus-language-act1:*act1-fixture-table* (list *row*))
(ml0-open-authority (list *row*))
(defvar *result* (lisp-plus-language-act1:run-act1 *row* :verbose nil))
(defvar *subject* (ml0-subject-from-fixture-row *row*))
(defvar *world-obs* (ml0-observe-world *subject* (ml0-world)))
(defvar *journal-obs* (ml0-observe-journal *subject* *ml0-act-store*))
(defvar *issuance-obs*
  (ml0-observe-issuance
   *subject*
   (lisp-plus-language-act1:act1-result-evidence *result*)))
(defvar *account*
  (ml0-write *ml0-account-store*
             (make-ml0-bundle
              :fixture-row *row*
              :claimed-act-id (ml0-subject-act-id *subject*)
              :subject-principal "the actor"
              :observations (list *world-obs* *journal-obs*)
              :issuance-observation *issuance-obs*
              :sources (list (ml0-self-report-source
                              (ml0-subject-act-id *subject*)
                              "the writing process read both instruments itself"))
              :effect-observation
              (ml0-effect-observation-of (ml0-subject-attempt *subject*)))))
(format t "~&account written: ~s~%" (ml0-account-id-hex *account*))
(defvar *retr* (ml0-retrieve *ml0-account-store* :account-hex (ml0-account-id-hex *account*)))
(format t "~&retrieved effect provenance: ~s~%"
        (ml0-effect-observation-provenance
         (ml0-account-effect-observation *retr*)))

(format t "~&=== VERDICT ===~%")
(let ((default-caller-asserted (eq :caller-asserted (ml0-effect-observation-provenance *default-obs*)))
      (forge-refused *forge-refused*)
      (durable-caller-asserted
        (eq :caller-asserted
            (ml0-effect-observation-provenance
             (ml0-account-effect-observation *retr*)))))
  (format t "~&  default :caller-asserted: ~a~%" default-caller-asserted)
  (format t "~&  forge :provenance refused: ~a~%" forge-refused)
  (format t "~&  durable :caller-asserted: ~a~%" durable-caller-asserted)
  (cond ((and default-caller-asserted forge-refused durable-caller-asserted)
         (format t "~&P8: PASS~%"))
        (t (format t "~&P8: FAIL~%"))))

(when (probe-file *root*) (sb-ext:delete-directory *root* :recursive t))
(sb-ext:exit :code (if (and (eq :caller-asserted (ml0-effect-observation-provenance *default-obs*))
                            *forge-refused*
                            (eq :caller-asserted
                                (ml0-effect-observation-provenance
                                 (ml0-account-effect-observation *retr*))))
                        0 1))
