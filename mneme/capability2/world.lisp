;;;; world.lisp — the world: a controlled effect adapter under a labeled
;;;; AP0 subset.
;;;;
;;;; THE PHILOSOPHICAL LOAD-BEARER.  The "outside" this lane's one effect
;;;; touches must SURVIVE process death while the process's memory does not
;;;; — that asymmetry IS the uncertainty this lane exists to handle.  The
;;;; world here is a tiny deterministic durable fixture: two files of
;;;; deterministic bytes under a declared directory —
;;;;
;;;;   CELLS.txt          — the bounded resource: one line per cell,
;;;;                        "NAME VALUE", sorted by name; rewritten whole on
;;;;                        each applied request.
;;;;   REQUEST-LEDGER.txt — the adapter's own request ledger: one appended
;;;;                        line per APPLIED request,
;;;;                        "REQUEST-ID CELL VALUE applied".
;;;;
;;;; JURISDICTION, kept visibly separate: these files are the fake OUTSIDE.
;;;; They are NOT part of the PJ0 journal and are never validated by it; the
;;;; journal is the PROCESS's evidence, the world is what the process's
;;;; effect touched.  Reconciliation is exactly the act of carrying a
;;;; journaled identity (the external-request-id) across that jurisdiction
;;;; line and asking the survivor what it holds.
;;;;
;;;; AP0 standing (AP-CON-1: a fake adapter is not a separate weaker
;;;; species): this adapter is a controlled effect adapter under a LABELED
;;;; AP0 SUBSET — deterministic, scripted, synchronous, single-provider.
;;;; NOT implemented from AP0's descriptor shape: adapter descriptors'
;;;; witnessable-set declarations, stream/chunk custody, provider envelope
;;;; custody, terminal-fixture coverage (AP-FAKE-3), and the full closed
;;;; acknowledgment ladder.  AP0's acknowledgment VOCABULARY is used where
;;;; honest — this adapter emits exactly two classes it can genuinely
;;;; witness (:provider-terminal — it durably applied the write itself and
;;;; holds the bytes; :acknowledgment-ambiguous — a scripted mode returning
;;;; an acknowledgment carrying no admissible evidence) — WITHOUT claiming
;;;; the full closed set's semantics.  No AP0 conformance is claimed.
;;;;
;;;; NO IDEMPOTENCY: the adapter declares NO provider-enforced idempotency
;;;; (§14.5 — a caller key without provider guarantee is not proof).  A
;;;; second apply under the SAME request identity appends a SECOND ledger
;;;; line: blind retry genuinely double-applies here, which is what makes
;;;; the retry law load-bearing rather than decorative.
;;;;
;;;; DURABILITY: writes are flushed (FINISH-OUTPUT) before return; declared,
;;;; not proven — the same standing as journal0's declared durability.
;;;;
;;;; PLANTED INTERRUPTION POINT (board point 2; AP0 crash-window W1 analog):
;;;; when the environment variable CAP2_WORLD_DIE_IN_WINDOW is "1", the
;;;; adapter exits the process AFTER the write is durably applied and
;;;; ledgered, BEFORE returning any acknowledgment — the dispatch landed;
;;;; the acknowledgment never came home.  Deterministic and scripted (the
;;;; capability1 planted-death precedent): no SIGKILL and no
;;;; mid-instruction byte truncation is claimed — de-teste-occiso owns real
;;;; crash-window truncation.
;;;;
;;;; — CLAVIGER-III (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-capability2)

(defvar +world-adapter-segments+ '("cap2-adapter" "cella" "v0"))

(defstruct (world
            (:constructor %make-world)
            (:copier nil)
            (:conc-name %world-))
  directory   ; pathname — the declared world directory
  script)     ; :apply (honest terminal ack) | :ambiguous (evidence-free ack)

(defun world-adapter-id ()
  "The adapter's declared identity (identifier datum)."
  (identifier-from-segments +world-adapter-segments+))

(defun world-script (world)
  (%check-world world)
  (%world-script world))

(defun %check-world (world)
  (unless (world-p world)
    (error 'cap2-world-missing
           :requirement-id "CAP2-WORLD-1"
           :detail "no explicit world was supplied; the controlled effect ~
                    adapter's durable fixture is declared configuration, ~
                    never ambient state"))
  world)

(defun %world-cells-path (world)
  (merge-pathnames "CELLS.txt" (%world-directory world)))

(defun %world-ledger-path (world)
  (merge-pathnames "REQUEST-LEDGER.txt" (%world-directory world)))

(defun %write-text-file (pathname text)
  (ensure-directories-exist pathname)
  (with-open-file (stream pathname :direction :output
                                   :if-exists :supersede
                                   :if-does-not-exist :create)
    (write-string text stream)
    (finish-output stream))
  pathname)

(defun %append-text-line (pathname line)
  (ensure-directories-exist pathname)
  (with-open-file (stream pathname :direction :output
                                   :if-exists :append
                                   :if-does-not-exist :create)
    (write-string line stream)
    (terpri stream)
    (finish-output stream))
  pathname)

(defun %read-text-file (pathname)
  (with-open-file (stream pathname :direction :input
                                   :if-does-not-exist nil)
    (when stream
      (let ((text (make-string (file-length stream))))
        (subseq text 0 (read-sequence text stream))))))

(defun %read-text-lines (pathname)
  (let ((text (%read-text-file pathname)))
    (when text
      (with-input-from-string (stream text)
        (loop for line = (read-line stream nil nil)
              while line
              unless (zerop (length line)) collect line)))))

(defun %render-cells (cells)
  "CELLS is an alist (NAME-STRING . VALUE-STRING), rendered sorted by name —
one canonical byte form per cell state."
  (with-output-to-string (stream)
    (dolist (cell (sort (copy-list cells) #'string< :key #'car))
      (format stream "~a ~a~%" (car cell) (cdr cell)))))

(defun %parse-cells (world)
  (loop for line in (%read-text-lines (%world-cells-path world))
        for space = (position #\Space line)
        collect (cons (subseq line 0 space) (subseq line (1+ space)))))

(defun make-world (directory cells &key (script :apply))
  "Create the world fixture at DIRECTORY with the declared CELLS (an alist
of NAME-STRING . INITIAL-VALUE-STRING) and an empty request ledger.
SCRIPT is the adapter's deterministic scripted mode."
  (unless (member script '(:apply :ambiguous))
    (error 'cap2-world-missing
           :requirement-id "CAP2-WORLD-2"
           :detail "the world script must be :apply or :ambiguous"))
  (let ((world (%make-world :directory (pathname directory) :script script)))
    (%write-text-file (%world-cells-path world) (%render-cells cells))
    (%write-text-file (%world-ledger-path world) "")
    world))

(defun open-world (directory &key (script :apply))
  "Open an existing world fixture (the restart's path: durable bytes on
disk, no memory of the process that wrote them)."
  (let ((world (%make-world :directory (pathname directory) :script script)))
    (unless (probe-file (%world-cells-path world))
      (error 'cap2-world-missing
             :requirement-id "CAP2-WORLD-3"
             :detail "the declared world directory holds no CELLS.txt"))
    world))

(defun world-cell-value (world name)
  "The current durable value of cell NAME (string), or NIL."
  (%check-world world)
  (cdr (assoc name (%parse-cells world) :test #'string=)))

(defun world-cells-sha256 (world)
  "sha256 of the cell store's current bytes."
  (%check-world world)
  (sha256-hex (map '(simple-array (unsigned-byte 8) (*)) #'char-code
                   (or (%read-text-file (%world-cells-path world)) ""))))

(defun world-ledger-sha256 (world)
  "sha256 of the request ledger's current bytes."
  (%check-world world)
  (sha256-hex (map '(simple-array (unsigned-byte 8) (*)) #'char-code
                   (or (%read-text-file (%world-ledger-path world)) ""))))

(defun world-ledger-count (world &optional request-id-string)
  "How many APPLIED entries the ledger holds — all of them, or those under
REQUEST-ID-STRING (the double-apply exhibit)."
  (%check-world world)
  (let ((lines (%read-text-lines (%world-ledger-path world))))
    (if request-id-string
        (count-if (lambda (line)
                    (let ((space (position #\Space line)))
                      (and space (string= request-id-string
                                          (subseq line 0 space)))))
                  lines)
        (length lines))))

(defun world-ledger-lookup (world request-id-string)
  "The reconciliation query: ask the SURVIVING world what it holds under
REQUEST-ID-STRING.  Returns (values found-p line-string line-sha256).
Signals kernel /0's RECONCILIATION-INSUFFICIENT when the ledger itself is
gone — an unanswerable world resolves nothing (PJ-FOLD-1's spirit: absence
of the witness is not evidence of absence of the effect)."
  (%check-world world)
  (unless (probe-file (%world-ledger-path world))
    (signal-kernel0
     'reconciliation-insufficient
     :requirement-id "CAP2-REC-3"
     :failed-invariant
     "§14.2 [F: UNC-2]: the declared reconciliation procedure requires the ~
      world's request ledger; without it no branch can be evidenced and ~
      nothing may resolve by default"))
  (let ((line (find-if (lambda (line)
                         (let ((space (position #\Space line)))
                           (and space (string= request-id-string
                                               (subseq line 0 space)))))
                       (%read-text-lines (%world-ledger-path world)))))
    (if line
        (values t line
                (sha256-hex (map '(simple-array (unsigned-byte 8) (*))
                                 #'char-code line)))
        (values nil nil nil))))

(defun %world-apply-request (world request-id-string cell-name value)
  "THE DISPATCH — the adapter durably applies one exact cell write and
ledgers it, then acknowledges.  Internal: only ATTEMPT-PROTECTED-EFFECT
calls this, and only after the full §10.4 preflight.  NO idempotency: a
second apply under the same request identity appends a second ledger line.
Returns the acknowledgment as (values class ledger-entry-sha cells-sha):
class :provider-terminal with evidence under script :apply; class
:acknowledgment-ambiguous with NO evidence under script :ambiguous."
  (%check-world world)
  (let* ((cells (%parse-cells world))
         (entry (assoc cell-name cells :test #'string=)))
    (unless entry
      (error 'cap2-world-missing
             :requirement-id "CAP2-WORLD-4"
             :detail (format nil "the bounded resource holds no cell ~a"
                             cell-name)))
    (setf (cdr entry) value)
    (%write-text-file (%world-cells-path world) (%render-cells cells))
    (let ((line (format nil "~a ~a ~a applied" request-id-string cell-name
                        value)))
      (%append-text-line (%world-ledger-path world) line)
      ;; The planted interruption point (board point 2): the write is
      ;; durably applied and ledgered; the acknowledgment never returns.
      (when (equal (sb-ext:posix-getenv "CAP2_WORLD_DIE_IN_WINDOW") "1")
        (format t "NOTE world adapter: dying in the acknowledgment window ~
                   (planted deterministic interruption; dispatch applied ~
                   and ledgered, acknowledgment not returned)~%")
        (finish-output)
        (sb-ext:exit :code 7 :abort t))
      (ecase (%world-script world)
        (:apply
         (values :provider-terminal
                 (sha256-hex (map '(simple-array (unsigned-byte 8) (*))
                                  #'char-code line))
                 (world-cells-sha256 world)))
        (:ambiguous
         (values :acknowledgment-ambiguous nil nil))))))
