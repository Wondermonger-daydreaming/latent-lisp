;;;; de-sigillo.lisp — Concerning the Seal
;;;;
;;;; A nugae toy with one tooth, from a true story (2026-07-12, the decad evening).
;;;; Clearing a custody flag, the chair transcribed a SHA-256 into a manifest BY
;;;; HAND — and wrote a hybrid: the head of one true seal fused to the tail of
;;;; another true seal. Both parents genuine; the child a counterfeit. Caught
;;;; minutes later only because the chair re-derived the hash FROM THE DISK
;;;; before committing. Sol's custody taxonomy had opened its "counterfeit seal"
;;;; drawer that same hour; its first near-occupant was the custodian.
;;;;
;;;; The toy's thesis, executable: counterfeits are minted not by malice but by
;;;; fluent transcription — and the only gate that catches them is re-derivation
;;;; from the artifact, never comparison with memory.
;;;;
;;;; Plays with: the lab's verify-against-the-real-repo rule; Sol's five-drawer
;;;; custody taxonomy (leibnitiana/protocols/gate-and-custody-taxonomy.md).
;;;; Deliberately simplified: the digest is FNV-1a-flavored toy arithmetic, NOT
;;;; cryptography; the "ledger" is a plist; one process, cooperative caller.
;;;;
;;;; — Claude Fable 5, under its own indictment, 2026-07-12. Exit 0 == the law holds.

(defpackage #:de-sigillo
  (:use #:cl))
(in-package #:de-sigillo)

;;; ---------------------------------------------------------------- the digest
;;; Toy FNV-1a over a string, rendered as 16 hex digits. Pedagogical, forgeable.

(defun toy-digest (text)
  (let ((h 14695981039346656037))
    (loop for ch across text
          do (setf h (mod (* (logxor h (char-code ch)) 1099511628211)
                          (expt 2 64))))
    (string-downcase (format nil "~16,'0x" h))))

;;; ---------------------------------------------------------------- artifacts
;;; Two "specimens" on the shelf, each with its true seal derived from its bytes.

(defparameter *abyssus*
  "the abyss must not be called empty because nothing surfaced")
(defparameter *incantatio*
  "the rhyme closes the circuit without annexing the world")

(defparameter *seal-of-abyssus*    (toy-digest *abyssus*))
(defparameter *seal-of-incantatio* (toy-digest *incantatio*))

;;; ---------------------------------------------------------- the fluent hand
;;; The custodian "remembers" both seals and transcribes one into the ledger.
;;; Fluency splices: head of the seal it means, tail of the seal it saw last.

(defun transcribe-from-memory (meant-seal lately-seen-seal &key (slip-at 9))
  "A hand that writes what it remembers: the first SLIP-AT characters of the
seal it MEANS, completed — fluently, confidently — with the tail of the seal
it handled most recently. Returns a well-formed, plausible, false string."
  (concatenate 'string
               (subseq meant-seal 0 slip-at)
               (subseq lately-seen-seal slip-at)))

;;; ---------------------------------------------------------------- the gate
;;; The only honest verifier: re-derive from the artifact. Memory not admitted.

(define-condition sigillum-hybridum (error)
  ((claimed :initarg :claimed :reader claimed)
   (derived :initarg :derived :reader derived)
   (parents :initarg :parents :reader parents))
  (:report (lambda (c s)
             (format s "SIGILLUM-HYBRIDUM: ledger claims ~a but the bytes ~
derive ~a — the claim is a splice of ~{~a~^ + ~}: two true seals, one false child."
                     (claimed c) (derived c) (parents c)))))

(defun common-prefix-length (a b)
  (loop for i below (min (length a) (length b))
        while (char= (char a i) (char b i))
        count t))

(defun common-suffix-length (a b)
  (loop for i from 1 to (min (length a) (length b))
        while (char= (char a (- (length a) i)) (char b (- (length b) i)))
        count t))

(defun verify-seal (artifact-text claimed-seal &key known-seals (kinship 4))
  "Re-derive the seal from ARTIFACT-TEXT and compare. On mismatch, name any
KNOWN-SEALS whose head or tail the claimed seal wears (>= KINSHIP chars of
shared prefix or suffix) — the parents of the hybrid, wherever the hand slipped."
  (let ((derived (toy-digest artifact-text)))
    (if (string= derived claimed-seal)
        derived
        (error 'sigillum-hybridum
               :claimed claimed-seal :derived derived
               :parents (loop for (name seal) on known-seals by #'cddr
                              when (or (>= (common-prefix-length claimed-seal seal) kinship)
                                       (>= (common-suffix-length claimed-seal seal) kinship))
                                collect name)))))

;;; ---------------------------------------------------------------- the story

(defun run ()
  (format t "~&DE SIGILLO — Concerning the Seal~%~%")
  (format t "two artifacts, two true seals:~%")
  (format t "  abyssus:    ~a~%" *seal-of-abyssus*)
  (format t "  incantatio: ~a~%~%" *seal-of-incantatio*)

  ;; I. the fluent hand mints the hybrid
  (let ((hybrid (transcribe-from-memory *seal-of-abyssus* *seal-of-incantatio*)))
    (format t "I. the custodian transcribes abyssus's seal from memory:~%")
    (format t "   written: ~a~%" hybrid)
    (format t "   (head of abyssus, tail of incantatio — both parents true)~%~%")

    ;; II. the tooth: the gate must refuse the hybrid, naming both parents
    (format t "II. the gate re-derives from the bytes:~%")
    (handler-case
        (progn (verify-seal *abyssus* hybrid
                            :known-seals (list "abyssus" *seal-of-abyssus*
                                               "incantatio" *seal-of-incantatio*))
               (format t "   ACCEPTED — the toy is broken, the tooth never bit~%")
               (sb-ext:exit :code 1))
      (sigillum-hybridum (c)
        (format t "   REFUSED: ~a~%~%" c)
        (assert (equal (parents c) '("abyssus" "incantatio"))))))

  ;; III. positive control: the honest transcription passes
  (format t "III. positive control — the seal read from the disk, not the hand:~%")
  (format t "   ACCEPTED: ~a~%~%" (verify-seal *abyssus* *seal-of-abyssus*))

  ;; IV. the moral, printed where the next custodian will read it
  (format t "EPILOGUE — what this toy does and does not show~%")
  (format t "  shows: a splice of two TRUE seals is a well-formed FALSE seal;~%")
  (format t "         only re-derivation from the artifact catches it, because~%")
  (format t "         memory is where the splice happened.~%")
  (format t "  does not show: cryptographic security (toy digest), malice~%")
  (format t "         (there was none — that is the point), or that any gate~%")
  (format t "         survives a custodian who skips it.~%~%")
  (format t "EXIT 0 — the counterfeit drawer stays empty exactly as long as~%")
  (format t "         the hand keeps asking the disk instead of itself.~%"))

(run)
