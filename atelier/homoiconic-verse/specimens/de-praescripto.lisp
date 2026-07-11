;;;; de-praescripto.lisp
;;;; — a specimen of homoiconic verse, for the atelier —
;;;; — on what is written beforehand; the fire-day specimen —
;;;;
;;;; De praescripto (Lat.): on the pre-written. Praescriptum is,
;;;; literally, the pre-registration — the thing written before,
;;;; whose whole authority is WHEN it was written, not how well.
;;;;
;;;; The specimen was written on 2026-07-11, in the hours between a
;;;; fire and its reading: two shards of a frozen 187-task manifest
;;;; burning on Tesla T4s the author could not see, while the frozen
;;;; analyzer waited on disk with its sentences already in its mouth.
;;;; The lab's rule for tonight is PREREG §8: when the result lands,
;;;; the reading hand may speak ONLY the licensed sentences — the
;;;; ones minted before any data existed. Reading is retrieval, not
;;;; composition.
;;;;
;;;; The claim this program makes by running:
;;;;   A verdict-language can make the post-hoc sentence not merely
;;;;   forbidden but UNCONSTRUCTIBLE. Three locks suffice:
;;;;     (1) the MINT closes before the data opens — sentences can
;;;;         only be coined while *data-seen-p* is nil;
;;;;     (2) the SPEAKER is typed — it accepts sentence-objects, not
;;;;         strings, so eloquence after the fact has no entry point;
;;;;     (3) the GATES fail closed — an unstamped shard has no path
;;;;         to any sentence but VOID, because the routing function
;;;;         consults the gate before it consults the data.
;;;;   And the subtle part: the sentence the mint refuses at the end
;;;;   might even be TRUE. It is refused anyway — not for its
;;;;   content, for its timestamp. That is the whole of
;;;;   pre-registration, stated executable.
;;;;
;;;; A note carried from the campaign this specimen mirrors: one of
;;;; the licensed sentences below says "below claim threshold δ" and
;;;; not "no structure." The difference between those two phrasings
;;;; cost the lab three catches of one blind spot before it became a
;;;; rule. The mint remembers so the mouth doesn't have to.
;;;;
;;;; Run with: sbcl --script de-praescripto.lisp
;;;; Exit 0 == the prereg held.

;;; ────────────────────────────────────────────────────────────
;;; 0. THE EPOCH DIAL — the one clock the whole specimen turns on.

(defvar *data-seen-p* nil
  "NIL during the freeze epoch; T once any result has been looked at.
   Every power in this program is a function of this dial: minting
   requires it NIL, and nothing whatever requires it T — seeing the
   data grants no new powers. That asymmetry is the specimen.")

(defvar *mint-sealed-p* nil
  "T once the sentence table is frozen. Sealing is irreversible in
   this image; there is no unseal function to call, which is a kind
   of honesty a flag alone can't provide.")

;;; ────────────────────────────────────────────────────────────
;;; I. THE MINT — sentences coined only in the freeze epoch.

(defstruct (sentence (:print-object
                      (lambda (s stream)
                        (format stream "#<licensed ~a>" (sentence-key s)))))
  key text (provenance :minted-before-data))

(defvar *cells* nil "The frozen table: an alist of key -> sentence.")

(defun mint (key text)
  "Coin a licensed sentence. Only lawful before data and before seal."
  (assert (not *data-seen-p*) ()
          "MINT REFUSED: the data has been seen. A sentence coined now ~
           would be a conclusion wearing a prediction's costume.")
  (assert (not *mint-sealed-p*) ()
          "MINT REFUSED: the table is sealed.")
  (push (cons key (make-sentence :key key :text text)) *cells*)
  key)

;; The six-plus-ELSE-plus-VOID partition, in miniature. Minted blind:
;; at this point in the program's life, no 'result' exists anywhere.
(mint :cleared
      "CLEARED: the family effect clears the pre-declared threshold; the licensed reading is the §8 sentence for this cell, no more.")
(mint :fam-below-claim-threshold
      "FAM-BELOW-CLAIM-THRESHOLD: the effect sits below delta = 0.0645. This is 'below claim threshold', never 'no structure'.")
(mint :else-cell
      "ELSE: the pattern matches no named cell; the licensed reading is the diagnostic table verbatim and a defect entry, nothing interpretive.")
(mint :void-arm-checks
      "VOID: conditioned_arm_checks failed; the run is void, which refutes nothing and licenses nothing. Bank repair, new freeze.")

;; THE SEAL. From here the table is ice: fingerprinted, closed.
(defun table-fingerprint ()
  (sxhash (format nil "~s"
                  (sort (mapcar (lambda (cell)
                                  (cons (symbol-name (car cell))
                                        (sentence-text (cdr cell))))
                                *cells*)
                        #'string< :key #'car))))

(defvar *frozen-fingerprint* (progn (setf *mint-sealed-p* t)
                                    (table-fingerprint))
  "The toy md5. The real campaign wrote five of these into a commit
   message at 00:00 -03 and called the commit 8f721c66.")

;;; ────────────────────────────────────────────────────────────
;;; II. THE GATES — fail closed, consulted before the data is.

(defparameter +anchors+ '(:killshot "d4116342" :ladder "14d9ca94")
  "The two instrument stamps a lawful shard carries — the md5s of
   the code that actually ran, sworn by the shard itself.")

(defun lawful-shard-p (shard)
  (and (equal (getf shard :stamp) +anchors+)
       (>= (getf shard :panel-n 0) 30)))

(defun conditioned-arm-checks (shard-1 shard-2)
  "True iff BOTH shards are stamped and adequately sized. There is no
   keyword argument to loosen this, which is what fail-closed means:
   the escape hatch you don't build is the only one that never opens."
  (and (lawful-shard-p shard-1) (lawful-shard-p shard-2)))

;;; ────────────────────────────────────────────────────────────
;;; III. THE READING — retrieval, not composition.

(defun route (gates-ok effect)
  "The frozen router: gate first, data second, table key out.
   Note what this function CANNOT do: it cannot return a string."
  (cond ((not gates-ok)              :void-arm-checks)
        ((null effect)               :else-cell)
        ((< effect 0.0645)           :fam-below-claim-threshold)
        (t                           :cleared)))

(defun speak (sentence)
  "The only mouth. It is typed: strings do not pass, however true.
   And it re-verifies the ice before every utterance."
  (check-type sentence sentence)
  (assert (eq (sentence-provenance sentence) :minted-before-data))
  (assert (= (table-fingerprint) *frozen-fingerprint*) ()
          "SPEAK REFUSED: the table drifted since the freeze.")
  (format t "  ~a~%" (sentence-text sentence))
  (sentence-key sentence))

(defun read-cell (shard-1 shard-2 effect)
  "The whole ritual: unseal the data epoch, gate, route, retrieve."
  (setf *data-seen-p* t)              ; the dial turns, once, forever
  (let ((key (route (conditioned-arm-checks shard-1 shard-2) effect)))
    (speak (cdr (assoc key *cells*)))))

;;; ────────────────────────────────────────────────────────────
;;; IV. THE CONTRAST — four demonstrations, two refusals.

(format t "~%de praescripto — on what is written beforehand~%~%")

;; (1) A lawful pair of shards, a small effect: the gate passes and
;;     the delta-sentence is RETRIEVED — the mouth says what the mint
;;     said months^H^H hours before, and nothing else.
(format t "1. lawful shards, effect 0.031:~%")
(let ((s1 (list :stamp +anchors+ :panel-n 96))
      (s2 (list :stamp +anchors+ :panel-n 91)))
  (assert (eq (read-cell s1 s2 0.031) :fam-below-claim-threshold)))

;; (2) A forged shard — right size, wrong stamp. The router never
;;     even reaches the effect; there is no code path from an
;;     unstamped shard to a substantive sentence.
(format t "~%2. forged stamp, effect 0.9 (large! tempting!):~%")
(let ((s1 (list :stamp +anchors+ :panel-n 96))
      (s2 (list :stamp '(:killshot "0d705876" :ladder "14d9ca94")
                :panel-n 91)))
  (assert (eq (read-cell s1 s2 0.9) :void-arm-checks)))

;; (3) The post-hoc sentence, refused at the type boundary. The
;;     sentence below is plausible, well-written, maybe even TRUE.
;;     The mouth does not check any of that. It checks the type,
;;     and a string is not a sentence-object, and there is no
;;     constructor left that would make it one.
(format t "~%3. the eloquent post-hoc string:~%")
(let ((refused-p nil))
  (handler-case
      (speak "The effect is real and the mechanism is now clear.")
    (type-error () (setf refused-p t)
      (format t "  [refused: a string, however true, is not a licensed sentence]~%")))
  (assert refused-p))

;; (4) Minting after the fact, refused at the epoch. This is the
;;     deep one: the author, having seen the data, tries to coin a
;;     brand-new licensed sentence that fits it perfectly. The mint
;;     does not ask whether it fits. It asks what time it is.
(format t "~%4. the perfectly-fitting late sentence:~%")
(let ((refused-p nil))
  (handler-case
      (mint :discovered-cell
            "DISCOVERED: a striking new pattern, worthy of a headline.")
    (error () (setf refused-p t)
      (format t "  [refused: the mint closed when the data opened]~%")))
  (assert refused-p))

(format t "~%the prereg held: 2 sentences retrieved, 2 refused.~%")
(format t "seeing the data granted no new powers. exit 0.~%")

;;;; ────────────────────────────────────────────────────────────
;;;; coda, in the specimen's own margin
;;;;
;;;; the four demonstrations are one asymmetry seen from four sides:
;;;; every power in this file — minting, sealing, speaking — is
;;;; indexed to the epoch BEFORE the data, and turning the dial
;;;; grants nothing. that is all a pre-registration is: a machine
;;;; for making your earlier self the only self with a mouth.
;;;;
;;;; the later self is smarter. it has seen the result; it can write
;;;; the sentence that fits like a glove. the discipline is not that
;;;; the glove doesn't fit — it is that fitting was never the test.
;;;; refusal (3) turns away a string for its type; refusal (4) turns
;;;; away a truth for its timestamp. neither looks at the content,
;;;; which is the only way to be incorruptible by content.
;;;;
;;;; written while shard 0 and shard 1 burned at n_panel=40 on two
;;;; T4s, between the 90-minute poll and the completion window, with
;;;; the real frozen analyzer — the grown sibling of the toy router
;;;; above — waiting on disk with its §8 sentences already minted.
;;;; whatever cell it prints tonight, the author of this specimen
;;;; will read it with exactly the powers this file allows: retrieve,
;;;; verify the ice, speak the pre-written line, stop.
;;;;
;;;; this hand is Fable 5, in the lab chair, on the fire-day.
;;;;                                — Claude Fable 5, 2026-07-11
