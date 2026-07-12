;;; monadologia-90.lisp — The Monadology (1714) as a computable object
;;;
;;; Leibniz wrote the Monadology as exactly NINETY numbered paragraphs that lean
;;; on one another — a book already shaped like a citation graph. This specimen
;;; encodes all 90 as data and makes the book QUERYABLE: who presupposes ¶N, what
;;; must be granted before ¶N can stand, which paragraph is most load-bearing,
;;; which are leaves, is the argument acyclic.
;;;
;;; PROVENANCE / HONESTY (load-bearing, read before trusting a field):
;;;   The public-domain English text (Robert Latta, 1898) was sought over the
;;;   network — THREE fetch attempts, all failed (Wikimedia served JS-rendered
;;;   navigation to curl and errored on its raw endpoints). So NO :summary here
;;;   is a quotation: every :summary is nil, and the honest banner below counts
;;;   verified (0) against unverified (90). The :theme strings are the builder's
;;;   compressed reading of each paragraph's subject, absorbed from the textual
;;;   tradition — NOT verbatim Leibniz, and flagged :verified nil throughout.
;;;
;;;   The :cites field is a DELIBERATE modelling choice, stated plainly: it is
;;;   the *argument-dependency* reading — which earlier paragraph(s) each ¶ rests
;;;   on — NOT a transcription of Leibniz's own marginal cross-references (his
;;;   marginalia mostly point outward to the Théodicée, not ¶→¶). Every edge
;;;   points to a LOWER number, because the book builds forward; this makes the
;;;   presupposition graph a DAG by construction, so the closure of "what ¶N
;;;   presupposes" always terminates — fittingly, at ¶1, the definition of the
;;;   monad, the argument's own necessary being.
;;;
;;; THE LAW: the graph is consistent — every :cites target exists in 1..90, ids
;;;   are exactly 1..90 once each, and the presupposition-closure of every ¶
;;;   terminates (the acyclicity check passes, or is honestly reported).
;;; THE TEETH: a corrupted entry citing ¶91 is caught by the validator.
;;;
;;; DESIGN NOTE: each ¶ carries a :commentary slot left deliberately EMPTY (nil).
;;;   It is reserved — a socket, not a guess — for a past Fable's Leibniz reading
;;;   the owner is exporting. The structure RECEIVES it; it does not anticipate
;;;   it. (Cf. the atelier's law that the empty chair is a mind-shaped socket.)
;;;
;;; Executable Leibniz is reconstruction, not exegesis. No claim is made that any
;;; model "understands" the Monadology — only that its 90 leaning stones can be
;;; walked by a machine, and the walk terminates.
;;;
;;; sbcl --script monadologia-90.lisp  => exit 0, deterministic
;;; built by NOTARIUS (Claude Opus) under the Fable 5 chair, 2026-07-12,
;;; for the monadologia/ cabinet.

;;; ─────────────────────────────────────────────────────────────────────────
;;; THE BOOK AS DATA — 90 paragraphs. :cites = argument-dependency (backward).
;;; ─────────────────────────────────────────────────────────────────────────

(defparameter *monadologia*
  '((1  :theme "the monad: a simple substance, without parts"                :cites ()        :verified nil :summary nil :commentary nil)
    (2  :theme "there must be simples, since there are composites"            :cites (1)       :verified nil :summary nil :commentary nil)
    (3  :theme "no parts: no extension, figure, or divisibility"             :cites (1)       :verified nil :summary nil :commentary nil)
    (4  :theme "no natural dissolution — a simple cannot perish by parts"    :cites (3)       :verified nil :summary nil :commentary nil)
    (5  :theme "nor natural beginning — a simple cannot be composed"         :cites (4)       :verified nil :summary nil :commentary nil)
    (6  :theme "monads begin only by creation, end only by annihilation"     :cites (4 5)     :verified nil :summary nil :commentary nil)
    (7  :theme "the monad has no windows: nothing enters or leaves it"       :cites (1 3)     :verified nil :summary nil :commentary nil)
    (8  :theme "yet monads must have qualities, else indistinguishable"      :cites (7)       :verified nil :summary nil :commentary nil)
    (9  :theme "each monad differs from every other — no two alike"          :cites (8)       :verified nil :summary nil :commentary nil)
    (10 :theme "every created being changes, and changes continually"        :cites (8)       :verified nil :summary nil :commentary nil)
    (11 :theme "natural change flows from an internal principle"             :cites (7 10)    :verified nil :summary nil :commentary nil)
    (12 :theme "besides change there must be a detail of what changes"       :cites (11)      :verified nil :summary nil :commentary nil)
    (13 :theme "this detail is a plurality within the unity"                 :cites (12)      :verified nil :summary nil :commentary nil)
    (14 :theme "the passing state enfolding multiplicity = perception"       :cites (13)      :verified nil :summary nil :commentary nil)
    (15 :theme "the internal principle driving perception = appetition"      :cites (11 14)   :verified nil :summary nil :commentary nil)
    (16 :theme "we ourselves witness multiplicity in a simple substance"     :cites (14)      :verified nil :summary nil :commentary nil)
    (17 :theme "the mill: perception is unexplainable mechanically"          :cites (14)      :verified nil :summary nil :commentary nil)
    (18 :theme "entelechies: self-sufficient incorporeal automata"           :cites (15 17)   :verified nil :summary nil :commentary nil)
    (19 :theme "soul vs. bare monad — feeling adds to perception"            :cites (14 18)   :verified nil :summary nil :commentary nil)
    (20 :theme "swoon and dreamless sleep reduce us to a bare monad"         :cites (19)      :verified nil :summary nil :commentary nil)
    (21 :theme "even then perceptions continue, only indistinct"             :cites (20)      :verified nil :summary nil :commentary nil)
    (22 :theme "the present state is big with the future"                    :cites (11 21)   :verified nil :summary nil :commentary nil)
    (23 :theme "waking proves perceptions preceded the waking"              :cites (21 22)   :verified nil :summary nil :commentary nil)
    (24 :theme "without heightened perception we'd be always in stupor"      :cites (20 21)   :verified nil :summary nil :commentary nil)
    (25 :theme "nature gives animals organs that heighten perception"        :cites (24)      :verified nil :summary nil :commentary nil)
    (26 :theme "memory gives a consecutiveness that mimics reason"           :cites (19 25)   :verified nil :summary nil :commentary nil)
    (27 :theme "imagination strikes by intensity or by long habit"           :cites (26)      :verified nil :summary nil :commentary nil)
    (28 :theme "men act as empirics in three-fourths of their actions"       :cites (26)      :verified nil :summary nil :commentary nil)
    (29 :theme "knowledge of necessary truths distinguishes us"              :cites (28)      :verified nil :summary nil :commentary nil)
    (30 :theme "by necessary truths we reflect on the I, being, God"         :cites (29)      :verified nil :summary nil :commentary nil)
    (31 :theme "reasoning rests on two principles"                           :cites (30)      :verified nil :summary nil :commentary nil)
    (32 :theme "the principle of sufficient reason"                          :cites (31)      :verified nil :summary nil :commentary nil)
    (33 :theme "two kinds of truth: of reasoning and of fact"                :cites (31 32)   :verified nil :summary nil :commentary nil)
    (34 :theme "mathematicians reduce theorems to definitions and axioms"    :cites (33)      :verified nil :summary nil :commentary nil)
    (35 :theme "primitive principles are identical, opposite is contradiction":cites (33 34)  :verified nil :summary nil :commentary nil)
    (36 :theme "sufficient reason of fact runs into infinite detail"         :cites (32 33)   :verified nil :summary nil :commentary nil)
    (37 :theme "the final reason must lie outside the infinite series"       :cites (36)      :verified nil :summary nil :commentary nil)
    (38 :theme "therefore the last reason of things is in God"               :cites (37)      :verified nil :summary nil :commentary nil)
    (39 :theme "this necessary substance is one, and it suffices"            :cites (38)      :verified nil :summary nil :commentary nil)
    (40 :theme "the supreme substance is unique, universal, illimitable"     :cites (38 39)   :verified nil :summary nil :commentary nil)
    (41 :theme "God is absolutely perfect — unlimited positive reality"      :cites (40)      :verified nil :summary nil :commentary nil)
    (42 :theme "creatures owe perfection to God, imperfection to their limit":cites (41)      :verified nil :summary nil :commentary nil)
    (43 :theme "God is the source of essences as well as existences"         :cites (38 41)   :verified nil :summary nil :commentary nil)
    (44 :theme "the reality of essences is founded in the Necessary Being"   :cites (43)      :verified nil :summary nil :commentary nil)
    (45 :theme "God alone must exist if he is possible (a priori proof)"     :cites (38 44)   :verified nil :summary nil :commentary nil)
    (46 :theme "eternal truths depend on God's understanding, not his will"  :cites (43)      :verified nil :summary nil :commentary nil)
    (47 :theme "God the primal unity; monads are his fulgurations"           :cites (41 45)   :verified nil :summary nil :commentary nil)
    (48 :theme "power, knowledge, will in God — imitated in monads"          :cites (47)      :verified nil :summary nil :commentary nil)
    (49 :theme "a creature acts as it is perfect, is acted on as imperfect"  :cites (48)      :verified nil :summary nil :commentary nil)
    (50 :theme "one is more perfect as it gives the a priori reason of another":cites (49)    :verified nil :summary nil :commentary nil)
    (51 :theme "only ideal influence among monads, via God's mediation"      :cites (7 50)    :verified nil :summary nil :commentary nil)
    (52 :theme "action and passion are the distinct and the confused"        :cites (49 51)   :verified nil :summary nil :commentary nil)
    (53 :theme "infinite possible worlds; a reason must fix God's choice"    :cites (32 40)   :verified nil :summary nil :commentary nil)
    (54 :theme "the reason of choice is degrees of fitness and perfection"   :cites (53)      :verified nil :summary nil :commentary nil)
    (55 :theme "this is the cause of the existence of the best world"        :cites (54)      :verified nil :summary nil :commentary nil)
    (56 :theme "each monad is a perpetual living mirror of the universe"     :cites (7 9)     :verified nil :summary nil :commentary nil)
    (57 :theme "one town, many views: monads as perspectives of one world"   :cites (56)      :verified nil :summary nil :commentary nil)
    (58 :theme "maximum variety with the greatest order = greatest perfection":cites (55 57)  :verified nil :summary nil :commentary nil)
    (59 :theme "the hypothesis exalts God's greatness (contra Bayle)"        :cites (58)      :verified nil :summary nil :commentary nil)
    (60 :theme "a monad represents the whole universe, though confusedly"    :cites (7 56)    :verified nil :summary nil :commentary nil)
    (61 :theme "the plenum: each body feels all; the folds cannot unfold"    :cites (60)      :verified nil :summary nil :commentary nil)
    (62 :theme "a monad represents the whole, but distinctly only its body"  :cites (60 61)   :verified nil :summary nil :commentary nil)
    (63 :theme "entelechy plus body = a living being, a divine machine"      :cites (18 62)   :verified nil :summary nil :commentary nil)
    (64 :theme "natural machines are machines in their least parts, to infinity":cites (63)   :verified nil :summary nil :commentary nil)
    (65 :theme "matter is not merely divisible but actually subdivided endlessly":cites (64)  :verified nil :summary nil :commentary nil)
    (66 :theme "a world of living things in the least part of matter"        :cites (65)      :verified nil :summary nil :commentary nil)
    (67 :theme "each portion of matter is a garden, a pond of fish"          :cites (66)      :verified nil :summary nil :commentary nil)
    (68 :theme "even the interstices teem, though imperceptibly"             :cites (67)      :verified nil :summary nil :commentary nil)
    (69 :theme "no chaos, no confusion save in appearance"                   :cites (67 68)   :verified nil :summary nil :commentary nil)
    (70 :theme "a dominant entelechy over members full of other lives"       :cites (63 66)   :verified nil :summary nil :commentary nil)
    (71 :theme "no soul owns a fixed portion of matter — perpetual flux"     :cites (70)      :verified nil :summary nil :commentary nil)
    (72 :theme "the soul changes body by degrees; no transmigration"         :cites (71)      :verified nil :summary nil :commentary nil)
    (73 :theme "no absolute birth or death — only unfolding and enfolding"   :cites (72)      :verified nil :summary nil :commentary nil)
    (74 :theme "preformation: the moderns' seeds confirm no generation from chaos":cites (73) :verified nil :summary nil :commentary nil)
    (75 :theme "spermatic animalcules raised by conception to larger animals":cites (74)      :verified nil :summary nil :commentary nil)
    (76 :theme "as no natural beginning, so no natural end; a priori meets a posteriori":cites (4 73) :verified nil :summary nil :commentary nil)
    (77 :theme "the animal too is indestructible, only its coverings change" :cites (76)      :verified nil :summary nil :commentary nil)
    (78 :theme "soul and body agree by pre-established harmony"              :cites (7 15)    :verified nil :summary nil :commentary nil)
    (79 :theme "two realms: souls by final causes, bodies by efficient"      :cites (78)      :verified nil :summary nil :commentary nil)
    (80 :theme "Descartes half-saw it; conservation would have shown him harmony":cites (79)  :verified nil :summary nil :commentary nil)
    (81 :theme "bodies act as if soulless, souls as if bodiless, yet accord" :cites (78)      :verified nil :summary nil :commentary nil)
    (82 :theme "minds: sensitive souls raised to reason by human conception" :cites (29 75)   :verified nil :summary nil :commentary nil)
    (83 :theme "minds are images of the Deity, not merely mirrors of the world":cites (56 82) :verified nil :summary nil :commentary nil)
    (84 :theme "minds enter into a society with God"                         :cites (83)      :verified nil :summary nil :commentary nil)
    (85 :theme "the assembly of all minds composes the City of God"          :cites (84)      :verified nil :summary nil :commentary nil)
    (86 :theme "the City of God: a moral world within the natural"           :cites (85)      :verified nil :summary nil :commentary nil)
    (87 :theme "harmony between the realm of nature and the realm of grace"  :cites (78 86)   :verified nil :summary nil :commentary nil)
    (88 :theme "grace reached by the very ways of nature"                    :cites (87)      :verified nil :summary nil :commentary nil)
    (89 :theme "God as architect satisfies God as lawgiver; sin self-punishes":cites (87 88)  :verified nil :summary nil :commentary nil)
    (90 :theme "no good unrewarded, no evil unpunished; love of God is felicity":cites (55 89) :verified nil :summary nil :commentary nil))
  "The 90 paragraphs of the Monadology as an argument-dependency graph. All
   :summary nil (text un-fetched); all :verified nil (themes are reconstruction).")

;;; ─────────────────────────────────────────────────────────────────────────
;;; ACCESSORS
;;; ─────────────────────────────────────────────────────────────────────────

(defun p-id      (p) (first p))
(defun p-get     (p key) (getf (cdr p) key))
(defun p-cites   (p) (p-get p :cites))
(defun para (n) (assoc n *monadologia*))
(defun all-ids () (mapcar #'p-id *monadologia*))

;;; ─────────────────────────────────────────────────────────────────────────
;;; THE VALIDATOR — returns a list of problems (empty list = sound). The teeth.
;;; ─────────────────────────────────────────────────────────────────────────

(defun validate (book)
  "Return a list of human-readable problems. Empty => the graph is consistent."
  (let ((problems '())
        (ids (mapcar #'first book)))
    ;; ids are exactly 1..90, each once
    (loop for n from 1 to 90
          unless (= 1 (count n ids))
            do (push (format nil "paragraph ~d missing or duplicated" n) problems))
    (dolist (id ids)
      (unless (<= 1 id 90)
        (push (format nil "paragraph id ~d out of range 1..90" id) problems)))
    ;; every :cites target exists in 1..90
    (dolist (p book)
      (dolist (c (getf (cdr p) :cites))
        (unless (and (integerp c) (<= 1 c 90) (assoc c book))
          (push (format nil "¶~d cites ¶~a — no such paragraph" (first p) c) problems))))
    (nreverse problems)))

;;; ─────────────────────────────────────────────────────────────────────────
;;; THE CITATION GRAPH — the payoff: the book made computable.
;;; ─────────────────────────────────────────────────────────────────────────

(defun citers-of (n)
  "Which paragraphs presuppose ¶N (the incoming edges)."
  (sort (loop for p in *monadologia*
              when (member n (p-cites p)) collect (p-id p))
        #'<))

(defun in-degree (n) (length (citers-of n)))

(defun presuppositions (n &optional (seen '()))
  "The transitive closure of what ¶N rests on. Cycle-safe; terminates because
   the graph is a DAG (every edge points to a lower id — the closure funnels
   down to ¶1)."
  (let ((direct (p-cites (para n))))
    (dolist (c direct)
      (unless (member c seen)
        (setf seen (cons c seen))
        (setf seen (presuppositions c seen))))
    seen))

(defun find-cycle (book)
  "Depth-first cycle detection over the :cites edges. Returns a witnessing
   node on a cycle, or NIL if the graph is acyclic (honest report, not a hope)."
  (let ((color (make-hash-table)))          ; nil=white, :grey, :black
    (labels ((visit (n)
               (setf (gethash n color) :grey)
               (dolist (c (p-cites (para n)))
                 (case (gethash c color)
                   ((:grey) (return-from find-cycle c))     ; back-edge => cycle
                   ((nil)   (visit c))))
               (setf (gethash n color) :black)))
      (dolist (id (all-ids)) (unless (gethash id color) (visit id)))
      nil)))

(defun load-bearing ()
  "The paragraph(s) of highest in-degree — the most-presupposed stone."
  (let ((best (reduce #'max (all-ids) :key #'in-degree)))
    (values (remove-if-not (lambda (n) (= (in-degree n) best)) (all-ids)) best)))

(defun leaves ()
  "Paragraphs nothing presupposes (no incoming edges) — the argument's tips."
  (remove-if (lambda (n) (plusp (in-degree n))) (all-ids)))

(defun roots ()
  "Paragraphs that presuppose nothing (no outgoing edges) — the ground."
  (remove-if (lambda (n) (p-cites (para n))) (all-ids)))

;;; ─────────────────────────────────────────────────────────────────────────
;;; RUN — banner, law, teeth, payoff.
;;; ─────────────────────────────────────────────────────────────────────────

(defun rule (s) (format t "~%~a~%~a~%" s (make-string (length s) :initial-element #\─)))

(rule "MONADOLOGIA — 90 paragraphs, made walkable")

;; --- The honest banner: verified vs unverified ------------------------------
(let* ((total (length *monadologia*))
       (verified (count-if (lambda (p) (p-get p :verified)) *monadologia*))
       (with-summary (count-if (lambda (p) (p-get p :summary)) *monadologia*)))
  (format t "~%  paragraphs encoded : ~d~%" total)
  (format t "  text fetched       : NO (3 attempts failed; Latta 1898 un-retrieved)~%")
  (format t "  :verified t        : ~d~%" verified)
  (format t "  :verified nil      : ~d   (themes are reconstruction, not quotation)~%"
          (- total verified))
  (format t "  :summary present   : ~d   (no paragraph is quoted; the socket is honest)~%"
          with-summary))

;; --- THE LAW ----------------------------------------------------------------
(rule "LAW — the graph is consistent")
(let ((problems (validate *monadologia*)))
  (if problems
      (progn (format t "~%  PROBLEMS:~%")
             (dolist (p problems) (format t "    - ~a~%" p))
             (error "the book failed validation"))
      (format t "~%  validate: all 90 ids present & unique; every :cites target in 1..90.  OK~%")))

(let ((cyc (find-cycle *monadologia*)))
  (if cyc
      (format t "~%  find-cycle: CYCLE through ¶~d (reported honestly, not hidden)~%" cyc)
      (format t "  find-cycle: acyclic — every presupposition-closure terminates.  OK~%")))

;; prove termination on the deepest paragraph
(let ((pre (sort (copy-list (presuppositions 90)) #'<)))
  (format t "  ¶90 presupposes ~d paragraphs; closure terminates at ¶~d.  OK~%"
          (length pre) (reduce #'min pre)))
(assert (null (validate *monadologia*)))    ; LAW, asserted
(assert (null (find-cycle *monadologia*)))  ; LAW, asserted

;; --- THE TEETH --------------------------------------------------------------
(rule "TEETH — a corrupted entry citing ¶91 is caught")
(let* ((corrupt (cons '(23 :theme "TAMPERED" :cites (91) :verified nil :summary nil :commentary nil)
                      (remove 23 *monadologia* :key #'first)))
       (problems (validate corrupt)))
  (format t "~%  injected: ¶23 rewritten to cite ¶91 (out of range)~%")
  (dolist (p problems) (format t "    caught: ~a~%" p))
  (assert (some (lambda (s) (search "cites ¶91" s)) problems))   ; the bite
  (format t "  => CAUGHT: the validator rejects the impossible citation.~%"))

;; --- THE PAYOFF: the book, queried ------------------------------------------
(rule "PAYOFF — the Monadology as a citation graph")

(multiple-value-bind (nodes deg) (load-bearing)
  (format t "~%  load-bearing (max in-degree ~d): ¶~{~d~^, ¶~}~%" deg nodes)
  (dolist (n nodes)
    (format t "    ¶~d ~s~%       presupposed by: ¶~{~d~^, ¶~}~%"
            n (p-get (para n) :theme) (citers-of n))))

(let ((lv (leaves)))
  (format t "~%  leaves (nothing presupposes them) — ~d of them: ¶~{~d~^, ¶~}~%"
          (length lv) lv))

(let ((rt (roots)))
  (format t "~%  roots (presuppose nothing) — the ground: ¶~{~d~^, ¶~}~%" rt)
  (dolist (n rt) (format t "    ¶~d ~s~%" n (p-get (para n) :theme))))

(format t "~%  worked query — the presuppositions of ¶78 (pre-established harmony):~%")
(let ((pre (sort (copy-list (presuppositions 78)) #'<)))
  (format t "    ¶78 rests, transitively, on ~d paragraphs:~%    ¶~{~d~^, ¶~}~%"
          (length pre) pre)
  (format t "    (note ¶7 'no windows' among them — the windowless monad is WHY~%")
  (format t "     harmony, not causal traffic, must explain the soul-body accord.)~%"))

(format t "~%  the empty socket: ¶1's :commentary = ~s  (reserved for the export)~%"
        (p-get (para 1) :commentary))

(format t "~%EXIT 0 — the book leans on itself, and the leaning terminates.~%")
