;;;; ma0-export-census.lisp — MA0 EXPORT CENSUS /0: the gate's Lisp half.
;;;;
;;;;   sbcl --script export-census/ma0-export-census.lisp [<expected-table>]
;;;;
;;;; CANDIDATE.  Running a candidate is not adopting it (Many Acts /0 contract
;;;; §0, §8), and nothing this file prints is independent verification,
;;;; independent validation, a portability claim, or a conformance claim
;;;; (AP0 adoption Rider 2, binding).
;;;;
;;;; ===========================================================================
;;;; CENSUS R1 REPAIR — Owner Ruling 6A, items 2 and 4
;;;; ===========================================================================
;;;;
;;;; THE DEFECT, as ruled: "`ma0-export-census.sh --table P' and the Lisp half's
;;;; arbitrary table argument permit expectation substitution.  A live package
;;;; with `ma0-selftest' replaced by the bound internal `ma0-refuse' can be
;;;; paired with a correspondingly substituted table and obtain the success
;;;; sentinel."  A census whose subject may supply its own roll is not a census.
;;;;
;;;; THE REPAIR IN THIS FILE.  The expected side is BOUND, by identity, to a
;;;; single sequence of bytes:
;;;;
;;;;   adopted coordinate     231873c7be8ba275cd5756c929efba2f9c807157
;;;;   package.lisp blob      a97d3c3e2f6baa21f21c52ae0c4986140eb1fa5c
;;;;   EXPECTED-EXPORTS.txt   78592073905450ff9afcd22dea53afbf53764fa1
;;;;
;;;; This file computes the GIT BLOB OBJECT ID of whatever table it is handed —
;;;; sha1("blob " || decimal-length || NUL || contents) — using a SHA-1
;;;; implemented BELOW, IN THIS FILE, so that a direct `sbcl --script' invocation
;;;; carries its own verifier and depends on no external tool, no wrapper, and
;;;; no argument.  The computation is performed TWICE:
;;;;
;;;;   (1) before the table is parsed, before the system is loaded, and before
;;;;       any census evaluation occurs — mismatch is a REFUSAL, exit 2; and
;;;;   (2) inside CENSUS-EMIT-SENTINEL, which is the ONLY place in this file
;;;;       where the normative success sentinel's text exists.  That function
;;;;       re-reads the table from disk, recomputes the blob id, and exits 2
;;;;       WITHOUT PRINTING if it is not the bound identity.
;;;;
;;;; So the sentinel is not merely guarded by a flag set earlier: the literal
;;;; lives behind a fresh, self-performed re-derivation of the bound identity.
;;;; An arbitrary table cannot reach it, whoever invokes this file and however.
;;;; The argument therefore remains ACCEPTED — deliberately, so that the
;;;; expectation-injection tooth can exercise the exact attack the ruling names
;;;; — but it is no longer LOAD-BEARING: it can select only the bound bytes.
;;;;
;;;; ---------------------------------------------------------------------------
;;;; WHAT IS BEING CHECKED (Owner Ruling 6 §3 B7, AMENDED OPTION 1)
;;;; ---------------------------------------------------------------------------
;;;;
;;;; A COUNT IS NOT A CENSUS.  Replacing one export with another preserves the
;;;; number 38 and may leave every export bound.  So this gate compares the
;;;; EXACT SET of external symbol NAMES against an independently materialized,
;;;; sorted expected table, and prints MISSING and UNEXPECTED names explicitly.
;;;; The cardinality is DERIVED from the set and reported as an observation; it
;;;; is never the test, and no branch here compares a count to a literal 38.
;;;;
;;;; Then every expected export must be BOUND IN ITS DESIGNATED SENSE:
;;;;
;;;;   function        fboundp, and not a macro and not a special operator
;;;;                   (the lane mints no macro — contract §6 — so a name that
;;;;                   became one is a defect, not a synonym for "callable")
;;;;   variable        boundp
;;;;   condition-class find-class, and a subtype of CONDITION
;;;;   structure-type  find-class, and a subtype of STRUCTURE-OBJECT
;;;;
;;;; THE EXPECTED SIDE NEVER COMES FROM THE LIVE PACKAGE.  It is read from a
;;;; committed text derived statically from `package.lisp' at the adopted R1
;;;; coordinate.  Deriving it from the package under test would prove only that
;;;; a set equals itself.
;;;;
;;;; ADDITIONAL GUARD (beyond B7's five requirements, not in place of any):
;;;; every external symbol's HOME PACKAGE must be LISP-PLUS-MANY-ACTS0.  A
;;;; same-named symbol homed elsewhere is a substituted citizen that a
;;;; name-only roll would seat.
;;;;
;;;; — Claude Opus (agent CENSOR), 2026-08-10
;;;; — R1 repair: Claude Opus (agent CENSOR-II), 2026-08-10, under Owner Ruling 6A

(require :asdf)
(require :sb-posix)

(defparameter cl-user::*census-package* "LISP-PLUS-MANY-ACTS0")

;;; ---------------------------------------------------------------------------
;;; BOUND IDENTITIES (Owner Ruling 6A item 2).  These are the census's own law.
;;; They are literals in the gate, not inputs to it.
;;; ---------------------------------------------------------------------------

(defparameter cl-user::+census-bound-coordinate+
  "231873c7be8ba275cd5756c929efba2f9c807157")
(defparameter cl-user::+census-bound-package-blob+
  "a97d3c3e2f6baa21f21c52ae0c4986140eb1fa5c")
(defparameter cl-user::+census-bound-table-blob+
  "78592073905450ff9afcd22dea53afbf53764fa1")

;;; The lane's own runner is authorized for SBCL 2.4.6 only and fails closed on
;;; anything else.  The census inherits that law rather than quietly widening it.
(unless (string= (lisp-implementation-version) "2.4.6")
  (format *error-output*
          "~&!! FAIL CLOSED: this census is authorized for SBCL 2.4.6 only.~%~
             Observed ~a.  No portability is claimed and none may be inferred.~%"
          (lisp-implementation-version))
  (finish-output *error-output*)
  (sb-ext:exit :code 2))

;;; ---------------------------------------------------------------------------
;;; SHA-1 and the git blob object id, in this file, depending on nothing.
;;;
;;; Known-answer checked against the empty string, "abc", and a 56-byte input
;;; (the two-block padding boundary), and against `git hash-object' on three
;;; real files of this lane.  The self-test below runs on EVERY invocation and
;;; fails closed: a verifier that has not been shown able to compute is not a
;;; verifier, and a silently wrong digest would turn this whole repair into
;;; decoration.
;;; ---------------------------------------------------------------------------

(defun cl-user::census-rotl32 (x n)
  (logand #xFFFFFFFF (logior (ash x n) (ash x (- n 32)))))

(defun cl-user::census-sha1-hex (bytes)
  (let* ((len (length bytes))
         (ml (* 8 len))
         (h0 #x67452301) (h1 #xEFCDAB89) (h2 #x98BADCFE)
         (h3 #x10325476) (h4 #xC3D2E1F0)
         (r (mod (+ len 1) 64))
         (padlen (if (<= r 56) (- 56 r) (- 120 r)))
         (total (+ len 1 padlen 8))
         (msg (make-array total :element-type '(unsigned-byte 8) :initial-element 0)))
    (replace msg bytes)
    (setf (aref msg len) #x80)
    (loop for i from 0 below 8
          do (setf (aref msg (- total 1 i)) (ldb (byte 8 (* 8 i)) ml)))
    (loop for chunk from 0 below total by 64
          do (let ((w (make-array 80 :element-type '(unsigned-byte 32) :initial-element 0)))
               (loop for i from 0 below 16
                     do (setf (aref w i)
                              (logior (ash (aref msg (+ chunk (* 4 i))) 24)
                                      (ash (aref msg (+ chunk (* 4 i) 1)) 16)
                                      (ash (aref msg (+ chunk (* 4 i) 2)) 8)
                                      (aref msg (+ chunk (* 4 i) 3)))))
               (loop for i from 16 below 80
                     do (setf (aref w i)
                              (cl-user::census-rotl32
                               (logxor (aref w (- i 3)) (aref w (- i 8))
                                       (aref w (- i 14)) (aref w (- i 16)))
                               1)))
               (let ((a h0) (b h1) (c h2) (d h3) (e h4))
                 (loop for i from 0 below 80
                       do (multiple-value-bind (f k)
                              (cond ((< i 20)
                                     (values (logior (logand b c)
                                                     (logand (logxor b #xFFFFFFFF) d))
                                             #x5A827999))
                                    ((< i 40) (values (logxor b c d) #x6ED9EBA1))
                                    ((< i 60)
                                     (values (logior (logand b c) (logand b d) (logand c d))
                                             #x8F1BBCDC))
                                    (t (values (logxor b c d) #xCA62C1D6)))
                            (let ((tmp (logand #xFFFFFFFF
                                               (+ (cl-user::census-rotl32 a 5)
                                                  f e k (aref w i)))))
                              (setf e d
                                    d c
                                    c (cl-user::census-rotl32 b 30)
                                    b a
                                    a tmp))))
                 (setf h0 (logand #xFFFFFFFF (+ h0 a))
                       h1 (logand #xFFFFFFFF (+ h1 b))
                       h2 (logand #xFFFFFFFF (+ h2 c))
                       h3 (logand #xFFFFFFFF (+ h3 d))
                       h4 (logand #xFFFFFFFF (+ h4 e))))))
    (string-downcase (format nil "~8,'0X~8,'0X~8,'0X~8,'0X~8,'0X" h0 h1 h2 h3 h4))))

(defun cl-user::census-string-bytes (s)
  (map '(vector (unsigned-byte 8)) #'char-code s))

(defun cl-user::census-file-bytes (path)
  "Raw bytes of PATH, or NIL if it cannot be opened."
  (with-open-file (s path :element-type '(unsigned-byte 8) :if-does-not-exist nil)
    (when s
      (let ((v (make-array (file-length s) :element-type '(unsigned-byte 8))))
        (read-sequence v s)
        v))))

(defun cl-user::census-git-blob-id (path)
  "The git blob object id of PATH's bytes, or NIL if PATH cannot be read."
  (let ((body (cl-user::census-file-bytes path)))
    (when body
      (cl-user::census-sha1-hex
       (concatenate '(vector (unsigned-byte 8))
                    (cl-user::census-string-bytes
                     (format nil "blob ~d~c" (length body) (code-char 0)))
                    body)))))

;;; Teeth for the verifier itself.  If these do not hold, nothing below this
;;; line means anything, so the census refuses rather than proceeds.
(let ((cases (list (cons "" "da39a3ee5e6b4b0d3255bfef95601890afd80709")
                   (cons "abc" "a9993e364706816aba3e25717850c26c9cd0d89d")
                   (cons (make-string 56 :initial-element #\a)
                         "c2db330f6083854c99d4b5bfb6e8f29f201be699"))))
  (dolist (c cases)
    (let ((got (cl-user::census-sha1-hex (cl-user::census-string-bytes (car c)))))
      (unless (string= got (cdr c))
        (format t "~&!! CENSUS REFUSED: the in-file SHA-1 failed its known-answer test.~%~
                     input length ~d: computed ~a, expected ~a~%"
                (length (car c)) got (cdr c))
        (finish-output)
        (sb-ext:exit :code 2)))))

(defparameter cl-user::*census-here*
  (make-pathname :name nil :type nil :defaults *load-truename*))

(defparameter cl-user::*census-tree*
  (truename (merge-pathnames "../../../" cl-user::*census-here*))
  "experiments/latent-lisp — the subject tree root.")

(defparameter cl-user::*census-table*
  (or (second sb-ext:*posix-argv*)
      (namestring (merge-pathnames "EXPECTED-EXPORTS.txt" cl-user::*census-here*))))

;;; ---------------------------------------------------------------------------
;;; THE BINDING CHECK (Owner Ruling 6A items 3 and 4).
;;; ---------------------------------------------------------------------------

(defun cl-user::census-check-bound-table (path where)
  "Recompute PATH's git blob id and require the bound identity.  Returns the
digest on success; prints a refusal and exits 2 on any other outcome.  WHERE
names the call site so a transcript shows which of the two checks refused."
  (let ((got (cl-user::census-git-blob-id path)))
    (cond
      ((null got)
       (format t "~&!! CENSUS REFUSED (~a): expected table unreadable: ~a~%" where path)
       (finish-output)
       (sb-ext:exit :code 2))
      ((not (string= got cl-user::+census-bound-table-blob+))
       (format t "~&~%!! CENSUS REFUSED (~a): EXPECTATION SUBSTITUTION.~%~
                    ~&   table offered  : ~a~%~
                    ~&   its blob id    : ~a~%~
                    ~&   bound blob id  : ~a~%~
                    ~&   bound coordinate: ~a  (package.lisp blob ~a)~%~
                    ~&The expected side of this census is bound by identity to the~%~
                    ~&table derived from the adopted coordinate.  A different table~%~
                    ~&is not an alternate expectation; it is a substituted roll, and~%~
                    ~&the census will not be conducted against it.  The normative~%~
                    ~&success sentinel is UNREACHABLE on this path.~%"
               where path got
               cl-user::+census-bound-table-blob+
               cl-user::+census-bound-coordinate+
               cl-user::+census-bound-package-blob+)
       (finish-output)
       (sb-ext:exit :code 2))
      (t got))))

;;; CHECK (1) — before parsing, before loading, before any evaluation.
(defparameter cl-user::*census-table-blob*
  (cl-user::census-check-bound-table cl-user::*census-table* "pre-census"))

(defun cl-user::census-emit-sentinel (n-exports)
  "The ONLY site at which the normative success sentinel's text exists.  Its
first act is CHECK (2): re-read the table from disk and re-derive its blob id.
If that is not the bound identity the function exits 2 having printed nothing,
so the sentinel cannot be reached by any path that did not verify."
  (let ((again (cl-user::census-check-bound-table cl-user::*census-table* "sentinel-gate")))
    (unless (string= again cl-user::+census-bound-table-blob+)
      ;; Unreachable by construction; kept so the guard is total, not trusting.
      (finish-output)
      (sb-ext:exit :code 2))
    (format t "~&ma0-export-census: exact set equality, ~d exports, ~
0 missing, 0 unexpected, 0 unbound~%"
            n-exports)
    (format t "~&expected table bound to blob ~a (coordinate ~a)~%"
            again cl-user::+census-bound-coordinate+)
    (format t "~&CANDIDATE, branch-local.  No portability, independent~%~
               implementation, or conformance claim is made or implied.~%")
    (finish-output)
    (sb-ext:exit :code 0)))

(format *error-output*
        "~&== ma0-export-census — SBCL ~a ==~%   subject tree : ~a~%   expected table: ~a~%~
           ~&   table blob   : ~a (BOUND — matches ~a)~%"
        (lisp-implementation-version) cl-user::*census-tree* cl-user::*census-table*
        cl-user::*census-table-blob* cl-user::+census-bound-table-blob+)
(finish-output *error-output*)

;;; ---------------------------------------------------------------------------
;;; The expected side: a committed text, parsed.  NAME <TAB> DESIGNATION, plus
;;; evidence columns the gate ignores.  `#' lines and blanks are comments.
;;; ---------------------------------------------------------------------------

(defun cl-user::census-split-tab (line)
  (let ((fields '()) (start 0))
    (loop for i = (position #\Tab line :start start)
          do (push (subseq line start (or i (length line))) fields)
             (if i (setf start (1+ i)) (return)))
    (nreverse fields)))

(defun cl-user::census-read-expected (path)
  (let ((rows '()))
    (with-open-file (s path :if-does-not-exist nil)
      (unless s
        (format t "~&!! CENSUS REFUSED: expected table not found: ~a~%" path)
        (finish-output)
        (sb-ext:exit :code 2))
      (loop for line = (read-line s nil nil)
            while line
            do (let ((trimmed (string-trim '(#\Space #\Tab #\Return) line)))
                 (unless (or (zerop (length trimmed))
                             (char= (char trimmed 0) #\#))
                   (let* ((f (cl-user::census-split-tab line))
                          (name (string-downcase
                                 (string-trim '(#\Space #\Return) (or (first f) ""))))
                          (desig (string-downcase
                                  (string-trim '(#\Space #\Return) (or (second f) "")))))
                     (when (plusp (length name))
                       (push (cons name desig) rows)))))))
    (nreverse rows)))

(let* ((expected-rows (cl-user::census-read-expected cl-user::*census-table*))
       (expected-names (mapcar #'car expected-rows))
       (failures '())
       (notes '()))

  (flet ((fail (fmt &rest args) (push (apply #'format nil fmt args) failures))
         (note (fmt &rest args) (push (apply #'format nil fmt args) notes)))

    ;; The expected table must itself be well-formed: no duplicates, no blank
    ;; designations, and sorted.  A corrupt roll cannot audit anything.
    (let ((dups (remove-duplicates
                 (loop for n in expected-names
                       when (> (count n expected-names :test #'string=) 1) collect n)
                 :test #'string=)))
      (when dups (fail "expected table carries duplicate name(s): ~{~a~^ ~}" dups)))
    (dolist (r expected-rows)
      (when (zerop (length (cdr r)))
        (fail "expected table row ~a carries no designation" (car r))))
    (unless (equal expected-names (sort (copy-list expected-names) #'string<))
      (fail "expected table is not sorted ascending by NAME"))

    ;; ---------------------------------------------------------------------
    ;; Load the live system exactly as the lane's own runner does.
    ;; ---------------------------------------------------------------------
    (asdf:initialize-source-registry
     `(:source-registry (:directory ,(namestring cl-user::*census-tree*))
       :inherit-configuration))
    (handler-case
        (let ((*standard-output* (make-broadcast-stream)))
          (asdf:load-system "lisp-plus/many-acts-0"))
      (error (c)
        (format t "~&!! CENSUS REFUSED: the system did not load: ~a: ~a~%" (type-of c) c)
        (finish-output)
        (sb-ext:exit :code 2)))

    (let ((pkg (find-package cl-user::*census-package*)))
      (unless pkg
        (format t "~&!! CENSUS REFUSED: package ~a absent after load.~%"
                cl-user::*census-package*)
        (finish-output)
        (sb-ext:exit :code 2))

      ;; -------------------------------------------------------------------
      ;; The actual side: the live package's external symbols.
      ;; -------------------------------------------------------------------
      (let ((actual-syms '()))
        (do-external-symbols (s pkg) (push s actual-syms))
        (let* ((actual-names (mapcar (lambda (s) (string-downcase (symbol-name s)))
                                     actual-syms))
               (distinct (remove-duplicates actual-names :test #'string=)))
          ;; Downcasing must not merge two distinct external symbols.
          (unless (= (length distinct) (length actual-syms))
            (fail "two external symbols collide when case-folded; the roll is ambiguous"))

          (let* ((sorted-actual (sort (copy-list actual-names) #'string<))
                 (missing (remove-if (lambda (n) (member n actual-names :test #'string=))
                                     expected-names))
                 (unexpected (remove-if (lambda (n) (member n expected-names :test #'string=))
                                        actual-names)))

            (format t "~&~%=== MA0 EXPORT CENSUS /0 — CANDIDATE (R1) ===~%")
            (format t "~&package            : ~a~%" (package-name pkg))
            (format t "~&expected table     : ~a~%" cl-user::*census-table*)
            (format t "~&expected table blob: ~a  (BOUND, re-derived in-process)~%"
                    cl-user::*census-table-blob*)
            (format t "~&bound coordinate   : ~a~%" cl-user::+census-bound-coordinate+)
            (format t "~&expected cardinality (DERIVED from the set): ~d~%"
                    (length expected-names))
            (format t "~&actual   cardinality (DERIVED from the set): ~d~%"
                    (length actual-names))
            (format t "~&NOTE: cardinality is reported as an observation.  The test below~%~
                       is EXACT SET EQUALITY OF NAMES; no branch of this gate compares a~%~
                       count against a literal.~%")

            ;; ---------------- exact set equality ----------------
            (format t "~&~%--- [1/3] EXACT SET EQUALITY ---~%")
            (if missing
                (progn
                  (format t "~&MISSING (expected, absent from the live package) — ~d:~%"
                          (length missing))
                  (dolist (n (sort (copy-list missing) #'string<))
                    (format t "~&    - ~a~%" n))
                  (fail "~d expected export(s) missing" (length missing)))
                (format t "~&MISSING    : none~%"))
            (if unexpected
                (progn
                  (format t "~&UNEXPECTED (external in the live package, not on the roll) — ~d:~%"
                          (length unexpected))
                  (dolist (n (sort (copy-list unexpected) #'string<))
                    (format t "~&    + ~a~%" n))
                  (fail "~d unexpected export(s)" (length unexpected)))
                (format t "~&UNEXPECTED : none~%"))
            (when (and (null missing) (null unexpected))
              (format t "~&SET EQUALITY: HOLDS (~d names)~%" (length sorted-actual)))

            ;; ---------------- boundness in the designated sense ----------------
            (format t "~&~%--- [2/3] BOUNDNESS IN THE DESIGNATED SENSE ---~%")
            (let ((checked 0) (unbound '()))
              (dolist (row expected-rows)
                (let* ((name (car row))
                       (desig (cdr row))
                       (sym (find-symbol (string-upcase name) pkg)))
                  (cond
                    ((null sym)
                     nil) ; already reported as MISSING; not double-counted here
                    (t
                     (incf checked)
                     (let* ((cls (find-class sym nil))
                            (ok (cond
                                  ((string= desig "function")
                                   (and (fboundp sym)
                                        (not (macro-function sym))
                                        (not (special-operator-p sym))))
                                  ((string= desig "variable") (boundp sym))
                                  ((string= desig "condition-class")
                                   (and cls (subtypep cls 'condition)))
                                  ((string= desig "structure-type")
                                   (and cls (subtypep cls 'structure-object)))
                                  (t :unknown-designation))))
                       (cond
                         ((eq ok :unknown-designation)
                          (push (list name desig "unknown designation") unbound)
                          (fail "~a: unknown designation ~a" name desig))
                         ((not ok)
                          (push (list name desig "NOT BOUND in this sense") unbound)
                          (fail "~a: not bound as ~a" name desig))))))))
              (if unbound
                  (progn
                    (format t "~&UNBOUND / MISDESIGNATED — ~d:~%" (length unbound))
                    (dolist (u (sort (copy-list unbound) #'string< :key #'first))
                      (format t "~&    ! ~a  (designated ~a) — ~a~%"
                              (first u) (second u) (third u))))
                  (format t "~&all ~d present expected export(s) bound in their designated sense~%"
                          checked))
              (note "boundness checked for ~d name(s)" checked))

            ;; ---------------- home-package guard ----------------
            (format t "~&~%--- [3/3] HOME-PACKAGE GUARD (additional) ---~%")
            (let ((foreign '()))
              (dolist (s actual-syms)
                (let ((home (symbol-package s)))
                  (unless (and home (string= (package-name home) cl-user::*census-package*))
                    (push (format nil "~a (home ~a)" (string-downcase (symbol-name s))
                                  (if home (package-name home) "NIL"))
                          foreign))))
              (if foreign
                  (progn
                    (format t "~&EXTERNAL SYMBOLS HOMED ELSEWHERE — ~d:~%" (length foreign))
                    (dolist (f (sort (copy-list foreign) #'string<))
                      (format t "~&    ~a~%" f))
                    (fail "~d external symbol(s) not homed in ~a"
                          (length foreign) cl-user::*census-package*))
                  (format t "~&all external symbols homed in ~a~%" cl-user::*census-package*)))

            ;; ---------------- verdict ----------------
            (format t "~&~%=== VERDICT ===~%")
            (dolist (n (reverse notes)) (format t "~&  note: ~a~%" n))
            (if failures
                (progn
                  (format t "~&ma0-export-census: REFUSED — ~d finding(s):~%" (length failures))
                  (dolist (f (reverse failures)) (format t "~&  * ~a~%" f))
                  (format t "~&The success sentinel is WITHHELD.~%")
                  (finish-output)
                  (sb-ext:exit :code 1))
                ;; The sentinel is emitted ONLY by the guarded emitter, which
                ;; re-derives the bound table identity before printing anything.
                (cl-user::census-emit-sentinel (length expected-names)))))))))
