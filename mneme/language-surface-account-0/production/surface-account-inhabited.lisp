;;;; surface-account-inhabited.lisp — the smallest lawful inhabited
;;;; Surface /0 + Surface /2 specimen (R4 Phase 5).
;;;;
;;;; Run:  sbcl --script mneme/language-surface-account-0/production/surface-account-inhabited.lisp
;;;; Exit 0 iff every check passed.  Sentinel:
;;;;   surface-account-inhabited: <N> checks, <F> failures
;;;;
;;;; THE INHABITANCE, exactly: Surface /2's Door 1 REQUIRES its
;;;; occurrence-tag to be a CD/0 identifier datum (surface2.lisp:695,
;;;; refusal :occurrence-tag-not-identifier — a public, documented /2
;;;; door).  The Surface Account /0 production API mints exactly that
;;;; species: the performance identifier
;;;; ("performance" <epoch-hex> <counter>).  This specimen mints through
;;;; the REAL /0 public API at runtime, passes the minted datum through
;;;; the REAL /2 public doors, and proves at the /2 boundary that the /2
;;;; result CARRIES and DEPENDS ON the /0 value:
;;;;
;;;;   * the request- and receipt-stored occurrence tags are octet-identical
;;;;     to the minted datum;
;;;;   * the tag's epoch segment equals THIS image's live /0 epoch — a
;;;;     32-hex value gathered from /dev/urandom at this image's /0
;;;;     initialization, which no fixture or literal can carry;
;;;;   * two /0 mints differing only in counter yield two /2 requests whose
;;;;     REQUEST IDENTITIES differ — the /2 result varies with the /0 value;
;;;;   * a lawful /0 reload arm repeats the consumption in the same image
;;;;     (fresh-image + reload-image, both demanded by the relay).
;;;;
;;;; NOT ceremonial co-loading: no parallel literal, no fixture-only
;;;; identity, no duplicate allocator — every tag below leaves
;;;; MINT-PERFORMANCE-IDENTIFIER at runtime.  (The disease comparator D5
;;;; replaces the mint with a literal in a disposable replica and this
;;;; gate's SA0-S2-EPOCH-LINKAGE check must then fail — that is the
;;;; negative control.)
;;;;
;;;; Load path: the REAL ASDF umbrella (`lisp-plus`), exactly as
;;;; load-lisp-plus.sh loads it.
;;;;
;;;; Source-form fixture provenance: *match-form* of
;;;; mneme/language-surface-2/surface2-selftest.lisp (this specimen invents
;;;; no admitted form).  Operation :macroexpand-1 — declared by /2.
;;;;
;;;; — FABER (Claude Fable 5), R4, 2026-08-06

(require :asdf)
(require :sb-posix)

(let ((root (merge-pathnames "../../../"
                             (make-pathname :name nil :type nil
                                            :defaults *load-truename*))))
  (asdf:initialize-source-registry
   `(:source-registry (:directory ,(namestring root)) :inherit-configuration)))
(asdf:load-system "lisp-plus")

(defpackage #:surface-account-inhabited
  (:use #:cl))
(in-package #:surface-account-inhabited)

(defvar *checks* 0)
(defvar *failures* 0)

(defun check (id description thunk)
  (incf *checks*)
  (let ((outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (c) (list :error c)))))
    (if (eq outcome :ok)
        (format t "[~a] ok   ~a~%" id description)
        (progn (incf *failures*)
               (format t "[~a] FAIL ~a~@[ (~a)~]~%" id description
                       (when (consp outcome) (second outcome)))))))

(defun octets-hex (datum)
  (lisp-plus-cd0:octets-to-hex (lisp-plus-cd0:canonical-octets datum)))

(defparameter *match-form*
  '(lisp-plus-surface2:match-outcome o
    ((:execution :settled) (lisp-plus-surface2:seat-outcome-seat-id o))
    (otherwise o))
  "Verbatim from surface2-selftest.lisp — a lawful /2 head under a declared
operation; this specimen invents no admitted form.")

(check "SA0-S2-UMBRELLA" "umbrella load delivered BOTH packages (/0 and /2)"
       (lambda () (and (find-package :lisp-plus-surface-account)
                      (find-package :lisp-plus-surface2))))

(check "SA0-S2-LIVE-ZERO" "the /0 identity is LIVE in this image (ready; one gathering; one election)"
       (lambda () (and (lisp-plus-surface-account:identity-ready-p)
                      (= 1 (lisp-plus-surface-account:epoch-gatherings))
                      (= 1 (lisp-plus-surface-account:election-count)))))

;;; ---- the consumption: /0 mints, /2 carries -------------------------------

(multiple-value-bind (d1 c1)
    (lisp-plus-surface-account:mint-performance-identifier)
  (multiple-value-bind (d2 c2)
      (lisp-plus-surface-account:mint-performance-identifier)

    (check "SA0-S2-MINTS" "two runtime /0 mints: lawful shape, consecutive counters"
           (lambda ()
             (and (lisp-plus-surface-account:performance-identifier-shape-p d1)
                  (lisp-plus-surface-account:performance-identifier-shape-p d2)
                  (= c2 (1+ c1)))))

    (let* ((r1 (lisp-plus-surface2:request-expansion *match-form* :macroexpand-1 d1))
           (r2 (lisp-plus-surface2:request-expansion *match-form* :macroexpand-1 d2)))

      (check "SA0-S2-DOOR1" "/2 Door 1 ADMITTED the /0-minted tags (two real requests)"
             (lambda () (and (lisp-plus-surface2:expansion-request-p r1)
                            (lisp-plus-surface2:expansion-request-p r2))))

      (check "SA0-S2-REQUEST-CARRIES" "the /2 request-stored tag is octet-identical to the /0 datum"
             (lambda ()
               (string= (octets-hex d1)
                        (octets-hex (lisp-plus-surface2:expansion-request-occurrence-tag r1)))))

      (check "SA0-S2-DEPENDENCE" "two /0 values -> two DIFFERENT /2 request identities (same form, same operation; only the /0 contribution moved)"
             (lambda ()
               (string/= (octets-hex (lisp-plus-surface2:expansion-request-identity r1))
                         (octets-hex (lisp-plus-surface2:expansion-request-identity r2)))))

      (multiple-value-bind (receipt expanded)
          (lisp-plus-surface2:perform-expansion r1)
        (declare (ignorable expanded))

        (check "SA0-S2-DOOR2" "/2 Door 2 performed; a real receipt exists"
               (lambda () (lisp-plus-surface2:expansion-receipt-p receipt)))

        (let* ((occ (lisp-plus-surface2:expansion-receipt-occurrence receipt))
               (stored-tag (lisp-plus-surface2:expansion-occurrence-occurrence-tag occ)))

          (check "SA0-S2-RECEIPT-CARRIES" "the /2 occurrence-stored tag is octet-identical to the /0 datum"
                 (lambda () (string= (octets-hex d1) (octets-hex stored-tag))))

          (check "SA0-S2-EPOCH-LINKAGE" "the receipt-stored tag's epoch segment equals THIS image's live /0 epoch (no literal can carry this)"
                 (lambda ()
                   (string= (lisp-plus-surface-account:image-epoch-hex)
                            (lisp-plus-cd0:identifier-datum-path-segment stored-tag 1))))

          (check "SA0-S2-COUNTER-LINKAGE" "the receipt-stored tag's counter segment equals the minted counter"
                 (lambda ()
                   (string= (format nil "~D" c1)
                            (lisp-plus-cd0:identifier-datum-path-segment stored-tag 2)))))))))

;;; ---- the species door is real: a non-identifier tag is refused ------------

(check "SA0-S2-SPECIES-DOOR" "/2 refuses a NON-identifier tag (:occurrence-tag-not-identifier) — the door validates, it does not decorate"
       (lambda ()
         (multiple-value-bind (req refusal)
             (lisp-plus-surface2:try-request-expansion *match-form* :macroexpand-1 "not-a-datum")
           (and (null req)
                (lisp-plus-surface2:expansion-refusal-p refusal)
                (eq :occurrence-tag-not-identifier
                    (lisp-plus-surface2:expansion-refusal-code refusal))))))

;;; ---- the lawful-reload arm (same image) -----------------------------------

(let ((epoch-before (lisp-plus-surface-account:image-epoch-hex)))
  (load (merge-pathnames "surface-account.lisp"
                         (make-pathname :name nil :type nil
                                        :defaults *load-truename*)))
  (multiple-value-bind (d3 c3)
      (lisp-plus-surface-account:mint-performance-identifier)
    (let ((r3 (lisp-plus-surface2:request-expansion *match-form* :macroexpand-1 d3)))
      (check "SA0-S2-RELOAD-ARM" "after a lawful /0 reload: same epoch, counter continued, and /2 still carries the fresh /0 value"
             (lambda ()
               (and (string= epoch-before (lisp-plus-surface-account:image-epoch-hex))
                    (= 1 (lisp-plus-surface-account:epoch-gatherings))
                    (> c3 2)
                    (string= (octets-hex d3)
                             (octets-hex (lisp-plus-surface2:expansion-request-occurrence-tag r3)))))))))

(format t "~%surface-account-inhabited: ~D checks, ~D failures~%"
        *checks* *failures*)
(sb-ext:exit :code (if (zerop *failures*) 0 1))
