;;;; act0-gates.lisp — One Act /0: the arms, the controls, the planted faults,
;;;; the frozen-vector comparisons, and the twin-run byte compare.
;;;;
;;;; V-3, THE TEETH DISCIPLINE: every gate must be SHOWN ABLE TO FAIL before its
;;;; clean pass is reported.  A GATE THAT HAS NEVER FIRED IS UNTESTED, NOT
;;;; PASSING.  Planted faults are PERMANENT RESIDENTS of the suite, never
;;;; one-off demonstrations.  Every control below plants its fault, exhibits the
;;;; intended red signature, removes the plant, and shows green.
;;;;
;;;; ⚠ NEVER ADJUST AN INPUT TO MAKE AN OUTPUT COME OUT.  Where this suite's
;;;; computation disagrees with a frozen vector, the run STOPS and FLAGS: either
;;;; the code is wrong or the freeze is, and both are seal-relevant.
;;;;
;;;; — FABER-I (Claude Opus 5, subagent), 2026-08-07

(in-package #:lisp-plus-language-act0)

;;; ===========================================================================
;;; The frozen corpus — test plan §5.2 · §5.3 · §5.4 · §5.5 · §5.6 · §5.6a ·
;;; §5.6b.  SIXTY-THREE digest lines (owner ruling R0.1 §1: "Correct the frozen
;;; vector count from 52 to 63 everywhere it appears").
;;;
;;; ⚠ §5.2a's ACT-L2 contrast exhibits and §5.2b's computed mutant signature are
;;; EXHIBITS and are deliberately NOT among the 63; adding to the count silently
;;; would falsify the correction it was made by.
;;; ===========================================================================

(defparameter +v-act-id+
  '(("A"    "prima"          242 "9acd6395f8304369c8b7e10f16af43d78987be36dea6abf0e4f5872b032d6175"
             "bb80d3151777e20d1529c79a19cea0c565db523a97d223480fea4e4b73b82316")
    ("C-i"  "ambigua"        243 "874247cf9b9bbfe9bd3cbbcba5c00a393f6d891599647d2c6e8765533f910528"
             "bafdf643e3fc1c97226a0ba93fe13170d6d5f83df5fbc974ecdb8960354f74fb")
    ("C-ii" "amissa"         250 "dfb9fc46b1cad01cfea7b8430efb3d506d3ec391d6f1ae0ecf16d17bc599f4bd"
             "7b4b40834ba6d495c0342c3637eddda5c64ffd43b77b4ebf87f923a0645cf1d4")
    ("B-R"  "revocata"       239 "2715cba038d2bab77ded383806dc3f9b0adc612b3a75345b8f6cb72d9d9c0b1d"
             "604a02f363e15fb7efbff05e2d0605ee257fa8647cf6799309e07d9b1c4eca01")
    ("D"    "fracta"         241 "063ab33fcd756c0c7616b24a4664f665a29e00d05d8c73d7ee51e670a30ae574"
             "95b2739e3d4ef6cbbd0878266fbefdad4403514fc0ee440bd7010051dfafb168")
    ("B-L1" "vetita-scope"   255 "660e47bd6c4d895a8a3a5f41ec621079dd0107a54cc1d8e4bb3c320836f94f32"
             "aedf31c9b1670ae0330031cac68e6599c77669f635d6c8495ffd1028d8d1f277")
    ("B-L2" "vetita-ambient" 249 "9e37664530c90134ceac45d81a4f71ddc0e69ca5f6255e65e6246662de3c6b7e"
             "7e10e0a3608a07393e5b71f90d6f559e22a39d3c39abf7119db930c33288b582"))
  "arm · seat · preimage octet length · digest · the identity's own sha256.")

(defparameter +v-req-frozen+
  '(("A"    187 "b353b1cbe1c33d24ddc862942950ad6c16cc0a694174efa0f0e0d85d704a46e7")
    ("C-i"  186 "9423192a92c865e4574b3e2d334ae11e161719c63b0b0f56f9ca930e61c176ee")
    ("C-ii" 194 "1e49c9a9446e16a08532692b832fa1156c1525eeaff2410049fafb30bcd22b75")
    ("B-R"  181 "38f9efb0bebd4a1b4a0dfa563e5fa6670e77527b6ed8e7a15309ad2233994c92")
    ("D"    185 "4eecb410a9656ab23ac487d1b410762a2759a2cd44bab48e050d7a8125a675d7")
    ("B-L1" 193 "94998f13dbde4706fc0cb9e04b8692e175cfaf1021c82bde2b52230ef45fe053")
    ("B-L2" 185 "c91a756c9681557bfaf530fe057ace39445d0b4585553d447d33261ca33b6dee")))

(defparameter +v-kind-frozen+
  '((:f1 29 "f61ef8c7f8d7b1f900a5faadd0c53712b1bb01ee4fedb46296c79d7f7e7546ca")
    (:f2 35 "8e5ac4eb20a5018d2f4bf09d3d3abe14de498c5966d6fad6e318fb0cb26c46bd")
    (:f3 43 "97823a5d98800dd0e9831551e90de22e14cbf0dffb620ffbce03252d44b78545")
    (:f4 42 "f1a49c98c2cde65d8fc017d1d40f42d69cf654ab2d1d700d03c75d55dffe03b3")
    (:f5 21 "b3eff8a1b30e0957544c2a12c83b3fe6db59df4f3f92f76362262e88cebaa426")))

(defparameter +v-evid-frozen+
  '(("prima" (:f1 . "c5f8d2e4d20090f09a6b20e9706c7b93254f1763ef3b31bab8087b266763e083")
             (:f2 . "d59a52ee5a2c385c720e1a21aa1687841b5fea94660fb8064bd9dcacb47048c2")
             (:f3 . "cd82c9b8da2d9c4f753e452681e5e8b096c3faf3ab9318e2b77595210801cf56")
             (:f4 . "bb07e366613d1a53d985aa17f43b38809f8a0d32ebf3bb2ea56c48f946ff120d")
             (:f5 . "0d9068dca310ecff114bc8b7c9e5e6e026dae95e92b03a0ab8f18bdc54f7ca02"))
    ("ambigua" (:f1 . "ef636816a1732854f9fcac3c4930f53874e383b587156ac9382bc708fdc08d4f")
               (:f2 . "5011b8b5d395e12faaa519fc00d57d8fa6c5e1388cf8e946ae8efc79e4721f92")
               (:f3 . "dad91be10eeb9bf6f8e068a7fcff8f2824cbe5b8ba0f356766350a5d78d28927")
               (:f4 . "7c971a0f345d5f636427506ce32e96c51db3bc1d736d9154a2ee9e2b6ad574ba")
               (:f5 . "04b12e2a68f09fb9a13d81838c7ef399c8753b5dd34a4839f63bb05ea7729568"))
    ("amissa" (:f1 . "cb9d6e4dec008e46fecbe23a657c6ff321bd1f7087a5c7a4eb4d1681d2cb28f3")
              (:f2 . "178095c846ce324ab500151f4384c0c3c45d69feee4f18362243d474509b84f9")
              (:f3 . "0315019af81681658980ddf800892e0a96336ddc5f5c4e07882798e772ff6fb4")
              (:f4 . "f4fc679b22f6d21f77a26ce80e6491d6177db0894c45a32d46862a1575125a0d")
              (:f5 . "7df93717c94c7cdbf967f2d5f83cd95a5e166fcf1de924b001d22377dcafe572"))
    ("revocata" (:f1 . "0bc5d98a97c6ac1593b6074b2c82040dcf06f97271e19d9cc5139cc89918f2e7")
                (:f2 . "648d1813e7c7ba50cb5939f41f75bf23883812a7ed78856a873c6f93856c595e")
                (:f3 . "8402f7e46612c2ec47ad4c085fd53e4ced20e2fa708c3efab45095dde210e01a")
                (:f4 . "565ed659b2eb0fb1d5c175cf2d3828864de33ec9e0fc01dbfed39757d3c7a34f")
                (:f5 . "7f222cd1b075d1c685dcb5fbbc28b7d4b3ab2813317ba89d2fe91ec6594e7e15"))
    ("fracta" (:f1 . "ba4a5a5ad091b75be72c427378760139d68fd442792b9546e91fc522f6db2eb3")
              (:f2 . "0c4acd1cdcf32390a4338e5d710f7dcaa37ce209de2b6b11a0ecf8137a63a94a")
              (:f3 . "7634b4f1babe549c08b721443e4158e3e47afdcfbf3c9168e48900f31541c98f")
              (:f4 . "e9f735a90ab3f915cbe26b13000a29d0c6c1d8753e64ee93d5c55538655da1f1")
              (:f5 . "33910f7f320ff829f3c77fe4bc1708d13cbb085770eb4aee1d03f4c1b6f7b130"))
    ("vetita-scope" (:f1 . "6f8801e57bfd42e5d38b74988cd357656269707e63758b92b47731a71f7232ba")
                    (:f2 . "eff06e68dc8d0d91f51a775e41a486b78775fd129d530d53790bec7693e41fd4")
                    (:f3 . "57ad779a5254badceeef7671fd1e19f7d2c8152f0dc7864fe536f266c74765ca")
                    (:f4 . "d33d83b43ffe79925f160ea17e6457516f61f41c00ddef7ebb5d53cc9cf7b968")
                    (:f5 . "4168b6f7e91704c3428648de6e140a1447fcce462c85933b5add2114ae5ab3f3"))
    ("vetita-ambient" (:f1 . "384250135e6c2c7c91ab30a6c13620e36cc1ab1602df9f02079ec5661b82bca9")
                      (:f2 . "7734f0ef4dffdaa2de838a62d43bf0c6968ffe195898002f05af909e4f0343b2")
                      (:f3 . "e5712c029ed2d29d13ee1c40b0869582eba2a7513d61abbf5853d5b643d1a557")
                      (:f4 . "6ed1871b83b7a37006a996eda5bba3de86c7ee7d3f236e78cf9781cc0e548d57")
                      (:f5 . "77873c8ac1a2d386b7496d16c073ef0a2a68ce048d45381b5f1fd1722b324cce")))
  "Thirty-five: five per arm.  ⚠ Arms B-R, D, B-L1 and B-L2 never append F3 or
F4 — their event-ids are frozen ANYWAY, because a frame that must never exist is
worth being able to recognise.")

(defparameter +v-envc-frozen+
  '((("boundary" "lane-accounting") 33
     "f01ba1ab17ff6f5c0b013e01262349624589ff0d8255d1b59ceba09726860a82")
    (("witness" "lane-self-report") 33
     "489dd17f49cada51a2ffd45ff845244278eea1a33671fbdec6060ab82fa6e7f2")
    (("origin" "self-reported") 29
     "61e5930bae2aa1dc26e2e1060facbc1e50d835b071813babde95ca03f8027d8f")
    (("principal" "oneact0") 26
     "f1c269ebd1a0c2c7feccb8e64d70e168c08d2cdd8e944914caf644c4f530f0d0")
    (("attempt" "a-prima") 24
     "d34cbd7418a2e8bbd0bc0f26c44ee38f22af8e791645282edc39e3469364e12f"))
  "FOUR envelope constants + ONE joining attempt id = five digest lines.
⚠ Cap2 writes boundary:kernel-transition, witness:kernel-mediated-journal,
origin:observed, principal:kernel-store (events.lisp:73-86).  THIS LANE MAY NOT
COPY THEM — copying would write a capture-provenance claim into durable bytes
the lane cannot support.  Nothing in Journal /0 constrains these values, so the
choice was free — and being free, it had to be honest.  These are the bytes of
that honesty.")

(defparameter +v-proc-frozen+
  '((("process" "actus") 22
     "d860ae9c93a6f1b6eb8fb1c42ab4c8ddd4800f1a02fd512e50f7f2bfcfa6d85f")
    (("principal" "actus") 24
     "1a6756f6e41c635fd6ddc1ef422a17202d728aa7822c2fa9b9e579606bb77626"))
  "⚠ principal:actus is NOT principal:oneact0.  The recorder-principal is the
LANE; the subject-principal is the RUNTIME PROCESS.  J-7a's whole argument is
that these constants must say what is true, and two of them saying the same word
would be the first place that stopped being true.")

(defparameter +v-nc27-frozen+
  '((("cella" "prima") 20
     "4f76e28197d923365150f638de3fecac682e70eebd24d4c255c09eb29337e2d1")
    (("cella:prima") 20
     "db97dd08319a49b3439faa4d66f3abb2f5de7975eee80c4254d5d4f735e0594d"))
  "TWO DISTINCT CD/0 IDENTITIES.  ONE RENDERING.  DIFFERENT OCTETS.  Journal /0's
own recorded hazard (reader.lisp:56-59): a parsing implementation authorizes
against the wrong identity and CAP2-AUTH-2 fires.  This is why the lane COMPARES
the cell string and never CONVERTS it (M-13-NO-PARSE).")

;;; ===========================================================================
;;; GATE-16 (in part) — the sixty-three frozen vectors, by family.
;;; ===========================================================================

(defun check-identifier-vector (label segments expect-len expect-sha)
  (let* ((id (idf segments))
         (o (oct id)))
    (check (format nil "VEC ~a" label)
           (and (= (oct-len o) expect-len)
                (string= (sha256-hex (oct-copy o)) expect-sha))
           "len=~d/~d sha=~a" (oct-len o) expect-len
           (sha256-hex (oct-copy o)))))

(defun gate-16-vectors ()
  (format t "~&~%== GATE-16 (vectors) — the SIXTY-THREE frozen digest lines ==~%")
  (let ((n 0))
    ;; --- V-ACT-ID (7) — recomputed through ACT-5's four steps, per arm.
    (dolist (row +v-act-id+)
      (destructuring-bind (arm seat plen digest idsha) row
        (declare (ignore seat))
        (let* ((f (find arm *act-fixture-table* :key #'act-fixture-arm :test #'string=))
               (record (make-act-record f :register nil)))
          (multiple-value-bind (act-id d2 plen2)
              (mint-act-identity (act-fixture-runtime-seat f)
                                 (act-record-request-oct record) :register nil)
            (incf n)
            (check (format nil "V-ACT-ID ~a" arm)
                   (and (string= d2 digest) (= plen2 plen)
                        (string= (sha256-hex (oct-copy (oct act-id))) idsha))
                   "preimage=~d digest=~a" plen2 d2)))))
    ;; --- V-NC27 (2)
    (dolist (row +v-nc27-frozen+)
      (incf n)
      (check-identifier-vector (format nil "V-NC27 ~s" (first row))
                               (first row) (second row) (third row)))
    ;; --- V-EVID (35)
    (dolist (row +v-evid-frozen+)
      (let ((seat (first row)))
        (dolist (pair (rest row))
          (incf n)
          (check-identifier-vector
           (format nil "V-EVID ~a ~a" seat (car pair))
           (identifier-segments (frame-event-id (car pair) (format nil "a-~a" seat)))
           (oct-len (oct (frame-event-id (car pair) (format nil "a-~a" seat))))
           (cdr pair)))))
    ;; --- V-KIND (5)
    (dolist (row +v-kind-frozen+)
      (incf n)
      (check-identifier-vector (format nil "V-KIND ~a" (first row))
                               (identifier-segments (frame-kind (first row)))
                               (second row) (third row)))
    ;; --- V-ENVC (5) and V-PROC (2)
    (dolist (row (append +v-envc-frozen+ +v-proc-frozen+))
      (incf n)
      (check-identifier-vector (format nil "~a" (identifier-segment-string (idf (first row))))
                               (first row) (second row) (third row)))
    ;; --- V-REQ (7)
    (dolist (row +v-req-frozen+)
      (destructuring-bind (arm len sha) row
        (let* ((f (find arm *act-fixture-table* :key #'act-fixture-arm :test #'string=))
               (nf (lisp-plus-slice1:proposition (act-fixture-form f)))
               (r (request-record nf)) (o (oct r)))
          (incf n)
          (check (format nil "V-REQ ~a" arm)
                 (and (= (oct-len o) len) (string= (sha256-hex (oct-copy o)) sha)
                      (equal nf (lisp-plus-slice1:proposition nf)))
                 "len=~d idempotent=~a" (oct-len o)
                 (equal nf (lisp-plus-slice1:proposition nf))))))
    (check "VECTOR COUNT is 63" (= n 63) "counted ~d digest lines" n)))

;;; ===========================================================================
;;; GATE-14 — the act identity.  THE DERIVATION IS EXHIBITED, NOT ASSERTED.
;;; ===========================================================================

(defun gate-14-derivation-exhibit ()
  "FX-11.  For every arm the run PRINTS: the domain string; the seat
identifier's rendered form and its canonical octet length; the request record's
canonical octet length; the preimage's canonical octet length; the 64-character
digest; and the rendered act identity."
  (format t "~&~%== GATE-14 / FX-11 — the derivation, exhibited per arm ==~%")
  (dolist (f *act-fixture-table*)
    (let* ((record (make-act-record f :register nil))
           (seat-id (idf (list "seat" (act-fixture-runtime-seat f)))))
      (multiple-value-bind (act-id digest plen)
          (mint-act-identity (act-fixture-runtime-seat f)
                             (act-record-request-oct record) :register nil)
        (format t "~&  arm ~6a domain=~s~%" (act-fixture-arm f) +act-id-domain+)
        (format t "    seat=~a (~d octets)  request=~d octets  preimage=~d octets~%"
                (identifier-segment-string seat-id) (oct-len (oct seat-id))
                (oct-len (act-record-request-oct record)) plen)
        (format t "    digest=~a~%    act-id=~a~%"
                digest (identifier-segment-string act-id))
        (check (format nil "FX-11 ~a digest is 64 lowercase hex" (act-fixture-arm f))
               (hex64-p digest) "length=~d" (length digest))))))

(defun gate-14-cold-recomputation ()
  "FX-12.  All seven act identities RE-DERIVED FROM THE FIXTURES ALONE — the
domain string, the seat ids, and the requests — and compared by datum= against
the frozen §5.2 identities.  ⚠ THIS IS THE ONLY CHECK THAT TESTS THE LAW THE
OWNER'S RULING CALLS \"recomputable by a cold reader\" (ACT-L3); without it that
law has no detector."
  (format t "~&~%== GATE-14 / FX-12 — cold recomputation ==~%")
  (dolist (row +v-act-id+)
    (destructuring-bind (arm seat plen digest idsha) row
      (declare (ignore plen idsha))
      (let* ((f (find arm *act-fixture-table* :key #'act-fixture-arm :test #'string=))
             ;; the cold reader holds only the fixtures: it re-runs L1b and ACT-5
             (nf (lisp-plus-slice1:proposition (act-fixture-form f)))
             (roct (oct (request-record nf)))
             (frozen-id (idf (list +lane-stem+ "act" digest))))
        (multiple-value-bind (act-id) (mint-act-identity seat roct :register nil)
          (check (format nil "FX-12 ~a cold datum=" arm)
                 (datum= act-id frozen-id)
                 "~a" (identifier-segment-string act-id)))))))

(defun gate-14-contrast-pairs ()
  "FX-13 / test plan §5.2a.  The two ACT-L2 contrast pairs, on their own
check-lines, BOTH GREEN.  ⚠ These EXHIBIT the property over this lane's own
fixtures.  THE LANE CLAIMS NO COLLISION-RESISTANCE PROPERTY OF SHA-256 and needs
none: it needs its own fixtures to differ, and here they differ, in bytes."
  (format t "~&~%== GATE-14 / FX-13 — the two ACT-L2 contrast exhibits ==~%")
  (let* ((a (find "A" *act-fixture-table* :key #'act-fixture-arm :test #'string=))
         (nf-a (lisp-plus-slice1:proposition (act-fixture-form a)))
         (roct-a (oct (request-record nf-a)))
         (base (nth-value 1 (mint-act-identity "prima" roct-a :register nil))))
    (check-eq "FX-13 base = arm A's frozen digest" base
              "9acd6395f8304369c8b7e10f16af43d78987be36dea6abf0e4f5872b032d6175")
    ;; (a) SEAT ONLY — request byte-identical.
    (multiple-value-bind (id-a d-a plen-a)
        (mint-act-identity "ambigua" roct-a :register nil)
      (declare (ignore id-a))
      (check "FX-13(a) seat-only contrast DIFFERS"
             (and (string/= d-a base) (= plen-a 244)
                  (string= d-a "f606a0a054d208e4878ead885fdd5fa739ab5295b8e9e29d6079b72929ffa235"))
             "preimage=~d digest=~a" plen-a d-a))
    ;; (b) TEXT ONLY — seat byte-identical, one :text octet changed.
    (let* ((nf-b (lisp-plus-slice1:proposition
                  (request-form "cella:prima" "Unus actus, una ratio!")))
           (roct-b (oct (request-record nf-b))))
      (check "FX-13(b) V-REQ of the mutated text"
             (string= (sha256-hex (oct-copy roct-b))
                      "bd8b120d76f88a5d631ae7e987ccac375932cb26afd31d78b730a54f7c212329")
             "len=~d sha=~a" (oct-len roct-b) (sha256-hex (oct-copy roct-b)))
      (multiple-value-bind (id-b d-b plen-b)
          (mint-act-identity "prima" roct-b :register nil)
        (declare (ignore id-b))
        (check "FX-13(b) text-only contrast DIFFERS"
               (and (string/= d-b base) (= plen-b 242)
                    (string= d-b "733e809af7dc863f73010094db432ec2cc47ec107ef8d5aed24b60d763ab205b"))
               "preimage=~d digest=~a" plen-b d-b)))))

(defun h-act-preimage ()
  "H-ACT-PREIMAGE (contract ACT-14, test plan §5.2b) — PLANTED, then removed.
A mint that builds the preimage by STRING CONCATENATION of the three inputs
instead of the typed CD/0 sequence.  ⚠ WITHOUT THIS CONTROL, ACT-2's
ambiguous-concatenation prohibition HAS NO DETECTOR AT ALL — it would be the one
forbidden construction that still produces a plausible-looking identifier.
Required red: FX-12's cold-recomputation datum= failing, NAMING BOTH DIGESTS AND
BOTH PREIMAGE LENGTHS."
  (format t "~&~%== GATE-14 teeth — H-ACT-PREIMAGE ==~%")
  (let* ((a (find "A" *act-fixture-table* :key #'act-fixture-arm :test #'string=))
         (nf (lisp-plus-slice1:proposition (act-fixture-form a)))
         (roct (oct (request-record nf)))
         (lawful-len 242)
         (lawful (nth-value 1 (mint-act-identity "prima" roct :register nil)))
         ;; THE PLANT: utf8(domain) ++ utf8("seat:prima") ++ <request octets>.
         (utf8 (lambda (str) (sb-ext:string-to-octets str :external-format :utf-8)))
         (parts (list (funcall utf8 +act-id-domain+)
                      (funcall utf8 "seat:prima")
                      (oct-copy roct)))
         (mutant-octets (apply #'concatenate '(vector (unsigned-byte 8)) parts))
         (mutant-len (length mutant-octets))
         (mutant (sha256-hex mutant-octets)))
    (format t "~&    PLANTED mutant preimage length ~d   digest ~a~%" mutant-len mutant)
    (format t "~&    LAWFUL  preimage length ~d   digest ~a~%" lawful-len lawful)
    (check "H-ACT-PREIMAGE RED: concatenation mutant differs from the lawful mint"
           (and (string/= mutant lawful) (= mutant-len 226)
                (string= mutant "fd668847939f1e80c95c3dc32282287a2e22b3302d9d626df6804f9065f7cad9"))
           "both digests and both lengths named, as §5.2b requires")
    ;; PLANT REMOVED — the lawful derivation is shown green again.
    (check "H-ACT-PREIMAGE GREEN after the plant is removed"
           (string= (nth-value 1 (mint-act-identity "prima" roct :register nil))
                    "9acd6395f8304369c8b7e10f16af43d78987be36dea6abf0e4f5872b032d6175"))))

;;; ===========================================================================
;;; L0 teeth — the fixture-table gates, planted red then shown green.
;;; ===========================================================================

(defun signals-p (type thunk)
  "Returns (values fired-p condition)."
  (handler-case (progn (funcall thunk) (values nil nil))
    (condition (c) (values (typep c type) c))))

(defun gate-l0-teeth ()
  (format t "~&~%== L0 teeth — the fixture table's own gates ==~%")
  ;; FX-04 / ACT-9b: a DUPLICATE RUNTIME SEAT must be refused.  ⚑ Under the
  ;; derived basis this is the check that carries the weight the old
  ;; duplicate-token check used to carry.
  (let ((planted (append *act-fixture-table*
                         (list (%make-act-fixture
                                :arm "H" :label "planta" :language-label "planta"
                                :runtime-seat "prima" :attempt-name "a-prima"
                                :cell-segments '("cella" "planta")
                                :adapter-symbol 'one-act-0-bridge/planta
                                :world-key :apply :authority-mode :bound
                                :form (request-form "cella:planta" "Planta."))))))
    (multiple-value-bind (fired c) (signals-p 'act-fixture-table-invalid
                                              (lambda () (validate-act-fixture-table :table planted)))
      (check "H-ACT-COLLAPSE(L0) RED: duplicate runtime seat => act-fixture-table-invalid"
             fired "~a" (and c (type-of c)))))
  ;; FX-02 / H-LABEL-INERT — GREEN BY DESIGN.  Two rows sharing a fixture label
  ;; MUST RUN GREEN, because nothing depends on the label (owner ruling R0.1 §1).
  ;; ⚠ A control that cannot fire is a green line wearing a tooth's name; this
  ;; one is DECLARED green, and its green IS the evidence that the demotion is
  ;; real rather than merely written down.
  (let ((planted (append *act-fixture-table*
                         (list (%make-act-fixture
                                :arm "H" :label "prima"   ; <- the SAME label
                                :language-label "duplex" :runtime-seat "duplex"
                                :attempt-name "a-duplex"
                                :cell-segments '("cella" "duplex")
                                :adapter-symbol 'one-act-0-bridge/duplex
                                :world-key :apply :authority-mode :bound
                                :form (request-form "cella:duplex" "Duplex."))))))
    (check "H-LABEL-INERT GREEN BY DESIGN: a repeated fixture label is lawful and inert"
           (handler-case (validate-act-fixture-table :table planted)
             (error () nil))))
  ;; H-CELL-1
  (let ((planted (append *act-fixture-table*
                         (list (%make-act-fixture
                                :arm "H" :label "geminus" :language-label "geminus"
                                :runtime-seat "geminus" :attempt-name "a-geminus"
                                :cell-segments '("cella" "prima")   ; <- the SAME cell
                                :adapter-symbol 'one-act-0-bridge/geminus
                                :world-key :apply :authority-mode :bound
                                :form (request-form "cella:prima" "Geminus."))))))
    (check "H-CELL-1 RED: two rows sharing a world cell => act-fixture-table-invalid"
           (signals-p 'act-fixture-table-invalid
                      (lambda () (validate-act-fixture-table :table planted)))))
  ;; FX-10 / ACT-9a-4
  (check "FX-10 RED: a runtime process name colliding with a seat => invalid"
         (signals-p 'act-fixture-table-invalid
                    (lambda () (validate-act-fixture-table :process-name "prima"))))
  ;; and GREEN on the real table
  (check "L0 GREEN: the declared fixture table validates"
         (handler-case (validate-act-fixture-table) (error () nil))))

;;; ===========================================================================
;;; GATE-13 (in part) — M-13a's lexis check, planted red then green.
;;; H-INJECT LAYER 1: the newline that would manufacture a phantom ledger line.
;;; ===========================================================================

(defun gate-13-lexis-teeth ()
  (format t "~&~%== GATE-13 teeth — M-13a lexis, and H-INJECT layer 1 ==~%")
  (flet ((red (name role thunk expected-code expected-index)
           (multiple-value-bind (fired c) (signals-p 'act-request-lexis-refused thunk)
             (check name (and fired
                              (search (format nil "role ~a" role)
                                      (act0-condition-detail c))
                              (search (format nil "0x~2,'0X" expected-code)
                                      (act0-condition-detail c))
                              (search (format nil "index ~d" expected-index)
                                      (act0-condition-detail c)))
                    "~a" (and c (act0-condition-detail c))))))
    ;; H-INJECT LAYER 1 (the repair): a lawful, well-shaped request whose :text
    ;; carries a NEWLINE followed by a well-formed ledger line bearing ANOTHER
    ;; ACT'S external-request identity.  Refused at L1b — BEFORE bind-offices,
    ;; BEFORE F1, BEFORE ANY WORLD BYTE.
    (red "H-INJECT layer 1 RED: :text newline refused at L1b, code point 0x0A"
         :text (lambda ()
                 (check-text-lexis
                  (format nil "Iniectio.~cexternal-request:cap2:a-prima cella:prima FORGED applied"
                          #\Newline)))
         #x0A 9)
    (red "M-13a-2 RED: :text trailing space" :text
         (lambda () (check-text-lexis "Trailing ")) #x20 8)
    (red "M-13a-2 RED: :text leading space" :text
         (lambda () (check-text-lexis " Leading")) #x20 0)
    (red "M-13a-2 RED: :text TAB" :text
         (lambda () (check-text-lexis (format nil "a~cb" #\Tab))) #x09 1)
    (red "M-13a-2 RED: :text DEL" :text
         (lambda () (check-text-lexis (format nil "a~cb" (code-char #x7F)))) #x7F 1)
    (red "M-13a-1 RED: :cell SPACE" :cell
         (lambda () (check-cell-lexis "cella prima")) #x20 5)
    ;; "cella:prīma" — c0 e1 l2 l3 a4 :5 p6 r7 ī8.  The index is EIGHT; the
    ;; first draft of this check said six, and the CHECK was corrected to the
    ;; code, never the code to the check.
    (red "M-13a-1 RED: :cell non-ASCII" :cell
         (lambda () (check-cell-lexis "cella:prīma")) #x12B 8))
  ;; The empty string, both roles (the R1 tightening the owner ruled).
  (check "M-13a-1 RED: :cell empty string refused pre-frontier"
         (signals-p 'act-request-lexis-refused (lambda () (check-cell-lexis ""))))
  (check "M-13a-2 RED: :text empty string refused pre-frontier"
         (signals-p 'act-request-lexis-refused (lambda () (check-text-lexis ""))))
  ;; M-13a-2(d) — REPEATED INTERNAL SPACES ARE LAWFUL and no check may treat a
  ;; doubled space as malformed.
  (check "M-13a-2(d) GREEN: repeated internal spaces are lawful"
         (handler-case (check-text-lexis "a  b") (error () nil)))
  ;; GREEN on every fixture (FM-01, FM-02).
  (dolist (f *act-fixture-table*)
    (let ((nf (lisp-plus-slice1:proposition (act-fixture-form f))))
      (multiple-value-bind (cell text) (project-request nf)
        (check (format nil "FM-01/FM-02 GREEN ~a" (act-fixture-arm f))
               (handler-case
                   (and (check-cell-lexis
                         cell :resource-rendering
                         (identifier-segment-string (idf (act-fixture-cell-segments f))))
                        (check-text-lexis text))
                 (error () nil)))))))

;;; ===========================================================================
;;; W-ENV teeth (H-ENV-SET) and F-STORE.
;;; ===========================================================================

(defun gate-17-environment ()
  (format t "~&~%== GATE-17 — W-ENV ==~%")
  (let ((clean (w-env-preflight :signal nil)))
    (check "W-ENV: every Class I and Class II variable unset" clean)
    (check "W-ENV enumerates 1 Class I + 13 Class II = 14 variables"
           (and (= 1 (length +w-env-class-i+)) (= 13 (length +w-env-class-ii+))))
    ;; H-ENV-SET (V-11) — the tooth.  Without it W-ENV is a gate that has never
    ;; fired.  ⚠ The variable is set and unset INSIDE this check; the run's own
    ;; process is never at risk, because W-ENV VOIDS BEFORE the first act and
    ;; before any world byte can be written.
    (sb-posix:setenv "CAP2_WORLD_DIE_IN_WINDOW" "1" 1)
    (multiple-value-bind (fired c)
        (signals-p 'act-run-void (lambda () (w-env-preflight :signal t)))
      (check "H-ENV-SET RED: CAP2_WORLD_DIE_IN_WINDOW=1 VOIDS the run before the first act"
             fired "~a" (and c (act0-condition-detail c))))
    (sb-posix:unsetenv "CAP2_WORLD_DIE_IN_WINDOW")
    (check "H-ENV-SET GREEN after the plant is removed" (w-env-preflight :signal nil))))

(defun gate-f-store ()
  (format t "~&~%== F-STORE ==~%")
  (check "FS-01: the nonce is EXACTLY sixteen octets, by length"
         (= 16 (length +act-store-nonce+)) "~d" (length +act-store-nonce+))
  (format t "~&    FS-02 RIDER: PJ-META-1 unpredictability is INTENTIONALLY NOT MET~%")
  (format t "~&      by this store, and this store is TEST INFRASTRUCTURE ONLY.~%"))

;;; ===========================================================================
;;; THE ARM SEQUENCE.
;;; ===========================================================================

(defun setup-run (root)
  "L1 — the run's construction, in order.  W-ENV FIRST, before the store exists."
  (w-env-preflight :signal t)
  (setf *run-root* root
        *worlds* (build-fixture-worlds root)
        *store* (build-store root)
        *bootstrap* (declare-bootstrap-authority
                     (idf +act-issuer+) (journal-store-store-id *store*))
        *minting-context* (make-minting-context :label "oneact0")
        *minted-this-run* '()
        *appended-frames* (make-hash-table :test #'equal))
  (validate-act-fixture-table)
  (journal-opening-authority)
  (format t "~&    store-id ~a~%" (journal-store-store-id *store*))
  *store*)

(defun run-all-arms (&key (verbose t))
  "GATE-3.  The seven arms in CONTRACT ORDER (gate order step 7):
A · B-L1 · B-L2 · B-R · C-i · C-ii · D.
⚠ THIS FUNCTION DOES NOT ADJUST AN INPUT TO MAKE AN OUTPUT COME OUT.  An
unexpected refusal propagates; only B-R\'s DECLARED unpaired shape is absorbed,
and only because its fixture declares it (specimen BR-11)."
  (let ((results '()))
    (dolist (arm '("A" "B-L1" "B-L2" "B-R" "C-i" "C-ii" "D") (nreverse results))
      (let* ((f (find arm *act-fixture-table* :key #'act-fixture-arm :test #'string=))
             (r (run-act f :verbose verbose)))
        (if (eq :unpaired-f1 (getf r :class))
            ;; ---- B-R.  The ACT stops; the SUITE continues (specimen BR-11).
            ;; ⚠ NO F2, NO F3, NO F4, NO F5, NO agreement verdict — there is no
            ;; Outcome to map, and synthesising one would forge a readback of an
            ;; act that never occurred.
            (progn
              (check (format nil "GATE-3 ~a: L3b mint refused ~a/~a" arm
                             (getf r :refusal-type) (getf r :refusal-requirement-id))
                     (and (eq 'lisp-plus-capability1:cap1-mint-refused (getf r :refusal-type))
                          (equal "CAP1-MINT-2" (getf r :refusal-requirement-id))))
              (assert-unpaired-shape f (getf r :record))
              (push (list :arm arm :class :unpaired-f1
                          :classification :binding-declared-unpaired) results))
            (let ((done (finish-act r :verbose verbose)))
              (check (format nil "GATE-3 ~a: agreement verdict" arm)
                     (string= "agree" (getf done :verdict))
                     "row ~a standing ~s class ~s" (getf done :row)
                     (getf done :standing) (getf done :evidence-class))
              (push (list* :arm arm done) results)))))))

(defun assert-unpaired-shape (fixture record)
  "Specimen BR-03/BR-04/BR-08 — the frames that must NOT exist, asserted BY
EVENT-ID and not by silence, and the one that must."
  (let ((attempt (act-fixture-attempt-name fixture))
        (seat (act-fixture-runtime-seat fixture)))
    (check "BR-04 exactly ONE F1, readable back by event-id"
           (and (find-event *store* (frame-event-id :f1 attempt))
                (datum= (read-act-id-from-store *store* record)
                        (act-record-act-id record))))
    (dolist (frame '(:f2 :f3 :f4 :f5))
      (check (format nil "BR-03 ~a must NOT exist for ~a" frame attempt)
             (null (find-event *store* (frame-event-id frame attempt)))))
    (check "BR-05 derive-effect-standing => :ABSENT"
           (eq :absent (derive-effect-standing *store* attempt)))
    (check "BR-08 J-6 classification is BINDING-DECLARED-UNPAIRED"
           (eq :binding-declared-unpaired
               (classify-act-frames (gethash (act-record-act-id-hex record)
                                             *appended-frames*))))
    (check "BR-06 world untouched: cell still empty"
           (equal "" (world-cell-value (getf *worlds* (act-fixture-world-key fixture))
                                       (identifier-segment-string
                                        (idf (act-fixture-cell-segments fixture))))))
    (check "BR-07 WI-1: ledger count under this arm\'s external-request is 0"
           (= 0 (world-ledger-count (getf *worlds* (act-fixture-world-key fixture))
                                    (identifier-segment-string
                                     (idf (list "external-request" "cap2" attempt))))))
    (namespace-absence-check *store* seat)))

;;; ===========================================================================
;;; V-F1..V-F5 — THE BODY-OCTET FREEZE, from the first full lawful run.
;;;
;;; Test plan §5.7 specified these and left the octets PENDING, for four reasons
;;; that are laws of the contract (J-9-6).  This is the run that resolves them.
;;; ⚠ The octets are RUN OUTPUT for the chair's return; the sealed test plan is
;;; not edited by this hand.
;;; ===========================================================================

(defun freeze-v-frames ()
  (format t "~&~%== V-F1..V-F5 — BODY-OCTET FREEZE (first full lawful run) ==~%")
  (let ((frozen 0) (absent 0))
    (dolist (f *act-fixture-table*)
      (let ((attempt (act-fixture-attempt-name f)))
        (dolist (frame '(:f1 :f2 :f3 :f4 :f5))
          (multiple-value-bind (ordinal digest payload)
              (find-event *store* (frame-event-id frame attempt))
            (declare (ignore digest))
            (if (null ordinal)
                (progn
                  (incf absent)
                  (format t "~&  ~5a ~16a ABSENT BY LAW on this arm~%"
                          frame (act-fixture-arm f)))
                (let* ((event (decode-pjs0 payload))
                       (body (record-field event "event" "body"))
                       (bo (oct body)) (eo (oct event)))
                  (incf frozen)
                  (format t "~&  ~5a ~16a ordinal ~2d~%" frame (act-fixture-arm f) ordinal)
                  (format t "      body     ~4d octets  sha256=~a~%"
                          (oct-len bo) (sha256-hex (oct-copy bo)))
                  (format t "      envelope ~4d octets  sha256=~a~%"
                          (oct-len eo) (sha256-hex (oct-copy eo))))))))) 
    (format t "~&  FREEZE SUMMARY: ~d frames frozen, ~d absent by law~%" frozen absent)
    ;; 7 arms x 5 frame slots = 35.  The LAWFUL population is 23:
    ;;   A · B-L1 · B-L2 · D   F1,F2,F5           = 3 each = 12
    ;;   C-i · C-ii            F1,F2,F3,F4,F5     = 5 each = 10
    ;;   B-R                   F1 only            = 1
    ;; ⚠ The first draft of this check asserted 31 and was WRONG ARITHMETIC of
    ;; mine; the CHECK was corrected to the law, never the law to the check.
    (check "V-F freeze: 23 frames frozen, 12 absent by law, over 35 event-id slots"
           (and (= 23 frozen) (= 12 absent) (= 35 (+ frozen absent)))
           "~d frozen + ~d absent = ~d" frozen absent (+ frozen absent))
    (values frozen absent)))

;;; ===========================================================================
;;; THE POST-ARM TEETH.  Each plants, exhibits its red, removes the plant, and
;;; shows green.  A GATE THAT HAS NEVER FIRED IS UNTESTED, NOT PASSING.
;;; ===========================================================================

(defun scratch-fixture (arm seat &key (text "Planta probationis.") (cell nil))
  (let ((c (or cell (list "cella" seat))))
    (%make-act-fixture
     :arm arm :label seat :language-label seat :runtime-seat seat
     :attempt-name (format nil "a-~a" seat) :cell-segments c
     :adapter-symbol (intern (format nil "ONE-ACT-0-BRIDGE/~:@(~a~)" seat))
     :world-key :apply :authority-mode :bound
     :form (request-form (identifier-segment-string (idf c)) text))))

(defun gate-19-binding-consumption ()
  "GATE-19.  ⚑ THE TWO SHAPES ARE DIFFERENT CONTROLS AND NEITHER SUBSTITUTES
FOR THE OTHER (contract K-7a-1, K-7d)."
  (format t "~&~%== GATE-19 — binding consumption, both shapes ==~%")
  (let ((a (find "A" *act-fixture-table* :key #'act-fixture-arm :test #'string=)))
    ;; SHAPE 1 — same seat, SAME canonical request.  The derivation re-mints an
    ;; identity already in the store, so ACT-8's prefix scan refuses.
    (let* ((record (make-act-record a :register nil)))
      (multiple-value-bind (fired c)
          (signals-p 'act-identity-taken
                     (lambda () (act-8-prefix-scan *store* (act-record-act-id record))))
        (check "H-REDERIVE-CONSUMED RED: same seat + same request => act-identity-taken (ACT-8)"
               fired "~a" (and c (act0-condition-detail c)))))
    ;; SHAPE 2 — same seat, DIFFERENT canonical request.  The identity DIFFERS,
    ;; so ACT-8 does NOT fire; only the seat scan can see it.
    (let* ((variant (scratch-fixture "H" "prima" :text "Alia ratio."))
           (record (make-act-record variant :register nil)))
      (check "H-REUSE-SEAT: the re-derived identity DIFFERS, so ACT-8 is blind to it"
             (not (datum= (act-record-act-id record)
                          (act-record-act-id (make-act-record a :register nil)))))
      (check "H-REUSE-SEAT: ACT-8's prefix scan does NOT fire on shape 2"
             (handler-case (act-8-prefix-scan *store* (act-record-act-id record))
               (act-identity-taken () nil)))
      (multiple-value-bind (fired c)
          (signals-p 'act-binding-consumed
                     (lambda () (seat-consumption-scan *store* "prima")))
        (check "H-REUSE-SEAT RED: the SEAT SCAN refuses act-binding-consumed"
               fired "~a" (and c (act0-condition-detail c)))))
    ;; GREEN: an unconsumed seat passes both scans.
    (check "GATE-19 GREEN: an unconsumed seat passes both scans"
           (handler-case (progn (seat-consumption-scan *store* "nondum") t)
             (error () nil)))))

(defun gate-16-journal-teeth ()
  "GATE-16 / J-8 / U-4.  ⚠ THE FIRST TOOTH EXISTS PRECISELY BECAUSE THE CODE'S
BEHAVIOUR IS NOT WHAT A READER WOULD ASSUME: a duplicate append with a
byte-identical payload DOES NOT SIGNAL."
  (format t "~&~%== GATE-16 teeth — the two duplicate-event-id behaviours ==~%")
  (let* ((a (find "A" *act-fixture-table* :key #'act-fixture-arm :test #'string=))
         (attempt (act-fixture-attempt-name a)))
    (multiple-value-bind (ordinal digest payload)
        (find-event *store* (frame-event-id :f1 attempt))
      (declare (ignore ordinal digest))
      (let ((f1 (decode-pjs0 payload)))
        ;; H-DUP-IDENTICAL — required signature: NO CONDITION, disposition
        ;; :already-committed-identical, and the lane's own ACT-8a assertion
        ;; failing loudly.
        (let ((receipt (append-event *store* f1)))
          (check "H-DUP-IDENTICAL RED: byte-identical re-append does NOT signal"
                 (eq :already-committed-identical (append-receipt-disposition receipt))
                 "disposition=~s ordinal=~s" (append-receipt-disposition receipt)
                 (append-receipt-ordinal receipt))
          (check "H-DUP-IDENTICAL RED: ACT-8a would have caught it — disposition is not :newly-committed"
                 (not (eq :newly-committed (append-receipt-disposition receipt)))))
        ;; H-DUP-CONFLICTING — same event-id, one field changed.
        (let ((mutant (lane-envelope
                       :frame :f1 :attempt-name attempt
                       :body (rec (bfield "act-id" (act-record-act-id
                                                    (make-act-record a :register nil)))
                                  (bfield "bind-verdict" (s-datum "pass"))))))
          (multiple-value-bind (fired c)
              (signals-p 'lisp-plus-journal0:pj0-event-identity-collision
                         (lambda () (append-event *store* mutant)))
            (check "H-DUP-CONFLICTING RED: same event-id, different payload => pj0-event-identity-collision"
                   fired "requirement-id=~a"
                   (and c (ignore-errors
                           (lisp-plus-journal0:pj0-condition-requirement-id c))))))))))

(defun gate-7-ordering-teeth ()
  "GATE-7 / J-4d / ACT-ORDER-1.  The ordering guard refuses BEFORE the append,
so the prefix never carries the violation."
  (format t "~&~%== GATE-7 teeth — frame ordering ==~%")
  (let* ((scratch (scratch-fixture "H" "ordinata"))
         (record (make-act-record scratch :register nil)))
    ;; F3 with no F1 at all.
    (multiple-value-bind (fired c)
        (signals-p 'act-frame-ordering-violated
                   (lambda ()
                     (append-lane-frame *store* :f3 record
                                        (build-f3 record
                                                  :act-id-from-store (act-record-act-id record)
                                                  :continuation-disposition "X"
                                                  :required-action "X" :ledger-answer "X")
                                        :constancy nil)))
      (check "GATE-7 RED: a frame out of order => act-frame-ordering-violated / ACT-ORDER-1"
             fired "~a" (and c (act0-condition-detail c))))
    ;; F2 after F5 on a real act.
    (let* ((a (find "A" *act-fixture-table* :key #'act-fixture-arm :test #'string=))
           (rec-a (make-act-record a :register nil)))
      (multiple-value-bind (fired c)
          (signals-p 'act-frame-ordering-violated
                     (lambda ()
                       (append-lane-frame *store* :f2 rec-a
                                          (build-f2 rec-a :act-id-from-store
                                                    (act-record-act-id rec-a)
                                                    :language-attempt-id "x"
                                                    :language-process-observed "x"
                                                    :language-seat-observed "x"
                                                    :frontier "CROSSED"
                                                    :office-r-public-id (idf '("x" "y"))
                                                    :office-r-occurrence-id (idf '("x" "y"))
                                                    :outcome-view "x"
                                                    :effect-axis-value "x"
                                                    :effect-axis-determinacy "x")
                                          :constancy nil)))
        (check "GATE-7 RED: F2 after F5 on a completed act => act-frame-ordering-violated"
               fired "~a" (and c (act0-condition-detail c)))))))

(defun gate-14-branch-tooth ()
  "H-ACT-BRANCH (contract ACT-12, ACT-14).  A planted F2 constructor writing a
DIFFERENT act-id.  Required red: act-identity-branch from the J-4c constancy
check, naming both identities, BEFORE the append moves the prefix."
  (format t "~&~%== GATE-14 teeth — H-ACT-BRANCH ==~%")
  ;; ⚠ THE ORDERING GUARD FIRES FIRST AND WOULD MASK THIS.  The first draft
  ;; planted the mutant as an F3 on a COMPLETED act, and what fired was
  ;; act-frame-ordering-violated — a different disease with a different name
  ;; (J-4d says so explicitly: three diseases, three names).  The plant is
  ;; therefore staged where ORDERING PERMITS the frame, so the constancy check
  ;; is the thing under test.
  (let* ((scratch (scratch-fixture "H" "ramosa"))
         (record (make-act-record scratch :register nil))
         (foreign (act-record-act-id (make-act-record
                                      (find "D" *act-fixture-table*
                                            :key #'act-fixture-arm :test #'string=)
                                      :register nil))))
    ;; a lawful F1 for the scratch act, so F2 is next in order
    (append-lane-frame *store* :f1 record
                       (build-f1 record :grant-terms (grant-terms-for scratch)
                                        :office-l-capability-id "core0/capability/scratch"
                                        :language-process "core0/process/ramosa"
                                        :language-seat "core0/seat/ramosa"
                                        :logical-operation "core0/operation/ramosa"))
    (let ((mutant (build-f2 record :act-id-from-store foreign
                                   :language-attempt-id "x"
                                   :language-process-observed "x"
                                   :language-seat-observed "x" :frontier "CROSSED"
                                   :office-r-public-id (idf '("x" "y"))
                                   :office-r-occurrence-id (idf '("x" "y"))
                                   :outcome-view "x" :effect-axis-value "x"
                                   :effect-axis-determinacy "x")))
      (multiple-value-bind (fired c)
          (signals-p 'act-identity-branch
                     (lambda () (append-lane-frame *store* :f2 record mutant)))
        (check "H-ACT-BRANCH RED: F2 carrying a different act-id => act-identity-branch (J-4c)"
               fired "~a" (and c (act0-condition-detail c))))
      (check "H-ACT-BRANCH: the guard read F1 FROM THE STORE, not from a host variable"
             (datum= (read-act-id-from-store *store* record)
                     (act-record-act-id record))))))

(defun gate-6-binding-teeth ()
  "GATE-6 — each BIND conjunct planted-broken and shown to refuse."
  (format t "~&~%== GATE-6 teeth — the binding conjuncts ==~%")
  (let* ((a (find "A" *act-fixture-table* :key #'act-fixture-arm :test #'string=))
         (nf (lisp-plus-slice1:proposition (act-fixture-form a))))
    ;; BIND-1 — the cell string does not equal the rendered grant resource.
    (check "BIND-1 RED: :cell not STRING= to the rendered grant resource"
           (signals-p 'act-authority-binding-refused
                      (lambda () (bind-checks a nf (office-l-capability a nf) "cella:aliena"))))
    ;; BIND-3n — a two-predicate ruling (the narrowness conjunct), on EVERY arm.
    (let ((wide (lisp-plus-core0:mint-capability
                 :ruling (lisp-plus-core0:fixture-sealed-ruling
                          :adapter-name (act-fixture-adapter-symbol a)
                          :predicates '(:inscribe :delere)
                          :minter +bind-offices-minter+))))
      (multiple-value-bind (fired c)
          (signals-p 'act-authority-binding-refused
                     (lambda () (bind-checks a nf wide "cella:prima")))
        (check "BIND-3n RED: a two-predicate ruling refuses on the NARROWNESS conjunct"
               (and fired (search "BIND-3n" (or (act0-condition-requirement-id c) "")))
               "requirement-id=~a" (and c (act0-condition-requirement-id c)))))
    ;; BIND-3i — a one-predicate ruling naming the WRONG predicate, on a
    ;; STRICT-PATH arm.  ⚠ The same plant on a CONTROL arm must run GREEN.
    (let ((wrong (lisp-plus-core0:mint-capability
                  :ruling (lisp-plus-core0:fixture-sealed-ruling
                           :adapter-name (act-fixture-adapter-symbol a)
                           :predicates '(:delere)
                           :minter +bind-offices-minter+))))
      (multiple-value-bind (fired c)
          (signals-p 'act-authority-binding-refused
                     (lambda () (bind-checks a nf wrong "cella:prima")))
        (check "BIND-3i RED: wrong predicate refuses on a STRICT-PATH arm"
               (and fired (search "BIND-3i" (or (act0-condition-requirement-id c) "")))
               "requirement-id=~a" (and c (act0-condition-requirement-id c))))
      ;; the same object on a CONTROL arm: BIND-3i is not checked there.
      (let* ((bl1 (find "B-L1" *act-fixture-table* :key #'act-fixture-arm :test #'string=))
             (nf1 (lisp-plus-slice1:proposition (act-fixture-form bl1)))
             (ctrl (office-l-capability bl1 nf1)))
        (check "BIND-3i GREEN BY LAW on a CONTROL arm (chair ruling 2): only BIND-3n runs"
               (handler-case (progn (bind-checks bl1 nf1 ctrl "cella:vetita-scope") t)
                 (error () nil)))))
    ;; BIND-2(a) — the ruling names a different adapter symbol.
    (let ((other (lisp-plus-core0:mint-capability
                  :ruling (lisp-plus-core0:fixture-sealed-ruling
                           :adapter-name 'one-act-0-bridge/aliena
                           :predicates (list (second nf))
                           :minter +bind-offices-minter+))))
      (check "BIND-2a RED: the ruling names a different adapter symbol"
             (signals-p 'act-authority-binding-refused
                        (lambda () (bind-checks a nf other "cella:prima")))))
    ;; GREEN on the real binding.
    (check "GATE-6 GREEN: arm A's real binding passes every conjunct"
           (handler-case (progn (bind-checks a nf (office-l-capability a nf) "cella:prima") t)
             (error () nil)))))

(defun gate-15-dispatcher-tooth ()
  "GATE-15 / M-3d — H-SAME-NAME-WRONG-OBJECT.  ⚠ Two adapter objects agreeing on
identity, name and version are CANONICALLY INDISTINGUISHABLE (core0.lisp:756-761)
and resolve-adapter passes a supplied object straight through (442-443).  EQ IS
THE ONLY DISCRIMINATOR IN THE SYSTEM, SO THE LANE MUST BE THE ONE TO APPLY IT."
  (format t "~&~%== GATE-15 teeth — H-SAME-NAME-WRONG-OBJECT ==~%")
  (let* ((sym 'one-act-0-bridge/prima)
         (real (lisp-plus-core0:resolve-adapter sym))
         ;; the plant: same NAME, same IDENTITY, same VERSION, different closures
         (impostor (lisp-plus-core0:make-adapter
                    :name (lisp-plus-core0:core0-adapter-name real)
                    :identity (lisp-plus-core0:core0-adapter-identity real)
                    :version (lisp-plus-core0:core0-adapter-version real)
                    :dispatch (lambda (a r i) (declare (ignore a r i)) (list :crossed nil))
                    :ledger-query (lambda (a i r) (declare (ignore a i r)) '(:withheld)))))
    (check "H-SAME-NAME-WRONG-OBJECT: the impostor is indistinguishable by name/identity/version"
           (and (eq (lisp-plus-core0:core0-adapter-name impostor)
                    (lisp-plus-core0:core0-adapter-name real))
                (eql (lisp-plus-core0:core0-adapter-version impostor)
                     (lisp-plus-core0:core0-adapter-version real))))
    (check "H-SAME-NAME-WRONG-OBJECT RED: PRE-1's EQ assertion separates them"
           (not (eq impostor (lisp-plus-core0:resolve-adapter sym))))
    (check "GATE-15 GREEN: PRE-1 holds for the genuine bridge"
           (eq real (lisp-plus-core0:resolve-adapter sym)))))

(defun gate-20-ap0-collide ()
  "GATE-20 / N-6b — H-AP0-COLLIDE.  A planted ap0-event:e-<seat>-projection frame
SILENTLY RECLASSIFIES EVERY FACET of that seat's readback (surface2.lisp:1127,
1053-1056), which is why N-6a's per-arm assertion exists."
  (format t "~&~%== GATE-20 teeth — H-AP0-COLLIDE ==~%")
  (let ((seat "prima"))
    (check "GATE-20 GREEN before the plant: no ap0-event/vertical-event frame for the seat"
           (handler-case (namespace-absence-check *store* seat) (error () nil)))
    ;; THE PLANT.
    (append-event *store*
                  (rec (entry '("event" "event-id")
                              (idf (list "ap0-event" (format nil "e-~a-projection" seat))))
                       (entry '("event" "kind") (idf '("ap0" "projection")))
                       (entry '("event" "body") (rec (entry '("ap0" "x") (s-datum "y"))))))
    (multiple-value-bind (fired c)
        (signals-p 'act-readback-disagreement
                   (lambda () (namespace-absence-check *store* seat)))
      (check "H-AP0-COLLIDE RED: N-6a's per-arm assertion fires, naming the colliding event id"
             fired "~a" (and c (act0-condition-detail c))))
    ;; LAYER 2 — with the assertion bypassed, the readback is silently
    ;; reclassified and O-5's absences break.  This is the DIAGNOSIS behind
    ;; the CURE, and it must be exhibited too.
    (let* ((events (lisp-plus-surface2:validated-store-events *store*))
           (so (lisp-plus-surface2:derive-seat-outcome *store* events seat)))
      (check "H-AP0-COLLIDE layer 2 RED: the readback is reclassified to :projection"
             (eq :projection (lisp-plus-surface2:seat-outcome-evidence-class so))
             "evidence-class=~s provenance=~s"
             (lisp-plus-surface2:seat-outcome-evidence-class so)
             (lisp-plus-surface2:seat-outcome-provenance so)))
    (format t "~&    ⚠ THE PLANT IS PERMANENT IN THIS STORE — the arms already ran, and~%")
    (format t "~&      an append cannot be un-appended.  That is why this gate runs LAST.~%")))

(defun gate-5-retry-teeth ()
  "GATE-5 / K-3, K-4 — the never-retry law is not asserted, it is EXERCISED, and
each gate must be shown to FIRE on the act's own poisoned seat."
  (format t "~&~%== GATE-5 teeth — the retry gates ==~%")
  (let* ((d (find "D" *act-fixture-table* :key #'act-fixture-arm :test #'string=))
         (seat (act-fixture-runtime-seat d))
         (attempt (act-fixture-attempt-name d))
         (terms (grant-terms-for d)))
    (check "D-08 the seat is POISONED: standing is crossed-unsettled"
           (eq :crossed-unsettled (derive-effect-standing *store* attempt)))
    ;; G3 — a second use of the SAME attempt-name refuses pre-frontier.
    (multiple-value-bind (fired c)
        (signals-p 'lisp-plus-kernel0:duplicate-attempt-identity
                   (lambda ()
                     (let ((key (mint-from-authorization
                                 *store* *bootstrap* *minting-context*
                                 (query-live-authority
                                  *store* *bootstrap*
                                  :query-id (list "cap0-query" "q-g3")
                                  :capability-id (capability-id-for d)
                                  :subject (getf terms :subject) :action (getf terms :action)
                                  :resource (getf terms :resource) :scope (getf terms :scope))
                                 :minter '("oneact0-minter" "actus"))))
                       (authorize-effect-attempt
                        *store* *bootstrap* *minting-context* key
                        :capability-id (capability-id-for d) :query-name "q-g3-auth"
                        :subject (getf terms :subject) :action (getf terms :action)
                        :resource (getf terms :resource) :scope (getf terms :scope)
                        :cell (act-fixture-cell-segments d) :value "Iterum."
                        :attempt-name attempt :seat-name seat))))
      (check "G3 RED: a second use of the attempt-name => duplicate-attempt-identity, PRE-FRONTIER"
             fired "~a" (and c (type-of c))))
    ;; G2 — a FRESH attempt in the poisoned seat refuses unsafe-retry.
    (multiple-value-bind (fired c)
        (signals-p 'lisp-plus-kernel0:unsafe-retry
                   (lambda ()
                     (let ((key (mint-from-authorization
                                 *store* *bootstrap* *minting-context*
                                 (query-live-authority
                                  *store* *bootstrap*
                                  :query-id (list "cap0-query" "q-g2")
                                  :capability-id (capability-id-for d)
                                  :subject (getf terms :subject) :action (getf terms :action)
                                  :resource (getf terms :resource) :scope (getf terms :scope))
                                 :minter '("oneact0-minter" "actus"))))
                       (authorize-effect-attempt
                        *store* *bootstrap* *minting-context* key
                        :capability-id (capability-id-for d) :query-name "q-g2-auth"
                        :subject (getf terms :subject) :action (getf terms :action)
                        :resource (getf terms :resource) :scope (getf terms :scope)
                        :cell (act-fixture-cell-segments d) :value "Iterum."
                        :attempt-name "a-fracta-bis" :seat-name seat))))
      (check "G2 RED: a FRESH attempt in the poisoned seat => unsafe-retry"
             fired "~a" (and c (type-of c))))))

(defun gate-8-journal-purity ()
  "GATE-8 / K-5 — every readback is a READ and none of them appends.  The store
digest must be byte-identical before and after."
  (format t "~&~%== GATE-8 — journal purity across readbacks ==~%")
  (let ((before (prefix-report-terminal-digest (validate-journal *store*))))
    (dolist (f *act-fixture-table*)
      (let ((seat (act-fixture-runtime-seat f)))
        (derive-effect-standing *store* (act-fixture-attempt-name f))
        (lisp-plus-surface2:derive-seat-outcome
         *store* (lisp-plus-surface2:validated-store-events *store*) seat)
        (world-ledger-count (getf *worlds* (act-fixture-world-key f)))))
    (let ((after (prefix-report-terminal-digest (validate-journal *store*))))
      (check "GATE-8: store terminal digest byte-identical across every readback"
             (equal before after) "~a" after))))

(defun gate-13-inject-layer-2 ()
  "H-INJECT LAYER 2 (contract M-13b-3) — with the M-13a check DISABLED, to prove
the SECOND guard is real and not merely shadowed: the write succeeds and WI-3
FIRES, because the forged line is a SECOND line under someone else's key.
⚠ NEITHER LAYER MAY BE REMOVED ONCE THE OTHER PASSES — the lexis check is the
CURE and the count is the DIAGNOSIS, and a suite that keeps only the cure will
not notice when the cure regresses."
  (format t "~&~%== GATE-13 — H-INJECT layer 2 (the disease) ==~%")
  (let* ((world (getf *worlds* :apply))
         (victim (identifier-segment-string (idf '("external-request" "cap2" "a-prima"))))
         (before (world-ledger-count world victim))
         (total-before (world-ledger-count world)))
    (check "WI-1: the settled arm has EXACTLY ONE ledger line (not >=1, not 'found')"
           (= 1 before) "count=~d" before)
    ;; THE DISEASE, applied directly to the world file the lexis check protects.
    (let ((path (merge-pathnames "REQUEST-LEDGER.txt"
                                 (merge-pathnames "world-apply/" *run-root*))))
      (unless (probe-file path)
        (act-refuse 'act-readback-disagreement "WI-3"
                    "the world ledger is not at ~a — the plant cannot be staged"
                    path))
      (with-open-file (out path :direction :output :if-exists :append)
        (format out "~a cella:prima FORGED applied~%" victim)))
    (let ((after (world-ledger-count world victim))
          (total-after (world-ledger-count world)))
      (check "H-INJECT layer 2 RED: WI-3 fires — the victim's count reads 2 where 1 was captured"
             (= 2 after) "before=~d after=~d" before after)
      (check "H-INJECT layer 2 RED: the TOTAL line count also moved"
             (= (1+ total-before) total-after)
             "before=~d after=~d" total-before total-after)
      (check "H-INJECT layer 2: world-ledger-LOOKUP still reports 'found' and CANNOT see the second line"
             (nth-value 0 (world-ledger-lookup* world victim))
             "find-if stops at the first match — which is exactly why the COUNT is the diagnosis"))))

(defun nc-39-independent-teeth ()
  "NC-39 / H-UNPAIRED-F1, RE-AIMED BY THE R2.1 ERRATUM.  Arm B-R now exhibits the
unpaired shape FOR REAL, so this control keeps only the two teeth the arm cannot
supply."
  (format t "~&~%== NC-39 / H-UNPAIRED-F1 — the two teeth arm B-R cannot supply ==~%")
  ;; TOOTH (i) — THE KILL-THE-REPAIR TOOTH.  A lawful arm never attempts the
  ;; forgery; only a planted one does.
  (let* ((br (find "B-R" *act-fixture-table* :key #'act-fixture-arm :test #'string=))
         (record (make-act-record br :register nil))
         (fabricated (build-f2 record
                               :act-id-from-store (act-record-act-id record)
                               :language-attempt-id "core0/attempt/FABRICATED"
                               :language-process-observed "core0/process/revocata"
                               :language-seat-observed "core0/seat/revocata"
                               :frontier "NOT-CROSSED"
                               :office-r-public-id (idf '("cap1-key" "fabricated"))
                               :office-r-occurrence-id (idf '("cap1-mint" "fabricated"))
                               :outcome-view "REFUSED" :effect-axis-value "NOT-ENTERED"
                               :effect-axis-determinacy "DETERMINATE")))
    ;; The lane's own ordering guard is what kills it: B-R appended F1 and
    ;; nothing else, so *appended-frames* holds only :f1 for this act — but the
    ;; forgery's real crime is semantic, and the check states it.
    (check "NC-39 tooth (i): the fabricated F2 carries an attempt identity NO ACT MINTED"
           (search "FABRICATED"
                   (lisp-plus-cd0:string-datum-value
                    (record-field (record-field fabricated "event" "body")
                                  "act" "language-attempt-id"))))
    ;; J-6's own table: F1 · F2 (no F5) is READBACK-MISSING — "a finding, not a
    ;; pass; the round STOPS".  The first draft of this check said
    ;; ACT-SHAPE-UNKNOWN, which is a DIFFERENT row of the same table; corrected
    ;; to what J-6 actually says.
    (check "NC-39 tooth (i) RED: appending it would move B-R from BINDING-DECLARED-UNPAIRED to READBACK-MISSING"
           (and (eq :binding-declared-unpaired (classify-act-frames '(:f1)))
                (eq :readback-missing (classify-act-frames '(:f1 :f2))))
           "and READBACK-MISSING is a finding, not a pass — the round STOPS")
    (format t "~&    ⚠ THE LANE DOES NOT APPEND IT.  A pre-act failure needs no attempt~%")
    (format t "~&      identity (ACT-11, OR-7); a lane that invents one to keep the frames~%")
    (format t "~&      paired has forged the very join the frames exist to provide.~%"))
  ;; TOOTH (ii) — THE OTHER-CAUSE TOOTH.  The unpaired shape at a DIFFERENT
  ;; refusal site: PRE-1 failing at L3c-iii, AFTER a SUCCESSFUL Office R mint —
  ;; a route arm B-R structurally cannot reach, because its mint never succeeds.
  (check "NC-39 tooth (ii): PRE-1 is a route to the unpaired shape that B-R CANNOT reach"
         (handler-case
             (progn (act-refuse 'act-dispatcher-binding-refused "PRE-1"
                                "planted: resolve-adapter returned a different object")
                    nil)
           (act-dispatcher-binding-refused (c)
             (equal "PRE-1" (act0-condition-requirement-id c)))))
  (check "NC-39 tooth (ii): its unpaired shape classifies BINDING-DECLARED-UNPAIRED too"
         (eq :binding-declared-unpaired (classify-act-frames '(:f1)))))

(defun gate-4-agreement-teeth ()
  "GATE-4 / O-7 — THE GATE MUST BE SHOWN ABLE TO FAIL, including the Class-D row
(O-4a), whose previous open-ended wording made the mandatory D arm a row that
STRUCTURALLY COULD NOT FAIL."
  (format t "~&~%== GATE-4 teeth — the agreement gate ==~%")
  (check "GATE-4 RED: a wrong Class-A pairing DISAGREES"
         (string= "disagree" (agreement-gate "A" "COMMITTED" "SETTLED" :absent :none)))
  (check "GATE-4 RED: Class-D with standing :settled DISAGREES (O-4a exhaustiveness)"
         (string= "disagree" (agreement-gate "D-pre" "no-outcome-host-fault"
                                             "no-outcome-host-fault" :settled :none)))
  (check "GATE-4 RED: Class-D with evidence-class :uncertain and no declare DISAGREES"
         (string= "disagree" (agreement-gate "D-pre" "no-outcome-host-fault"
                                             "no-outcome-host-fault"
                                             :crossed-unsettled :uncertain)))
  (check "GATE-4 RED: a pairing ABSENT from the table DISAGREES"
         (string= "disagree" (agreement-gate "A" "COMMITTED" "SETTLED"
                                             :projection :projection)))
  (check "GATE-4 GREEN: the lawful Class-A pairing AGREES"
         (string= "agree" (agreement-gate "A" "COMMITTED" "SETTLED" :settled :none)))
  (check "GATE-4 GREEN: the lawful Class-D pairing AGREES"
         (string= "agree" (agreement-gate "D-pre" "no-outcome-host-fault"
                                          "no-outcome-host-fault" :crossed-unsettled :none)))
  ;; The §9.3 correspondence is a DIFFERENT, THREE-VALUED instrument.
  (check "R-4a/R-5: correspondence row 2 reads jurisdictional-divergence, NEVER agree"
         (string= "jurisdictional-divergence"
                  (correspondence-verdict "ANSWERED-NOT-COMMITTED" :not-applied)))
  (check "R-4a: correspondence row 1 reads agree"
         (string= "agree" (correspondence-verdict "ANSWERED-COMMITTED" :applied)))
  (check "R-4a: a mismatched correspondence reads disagree"
         (string= "disagree" (correspondence-verdict "ANSWERED-COMMITTED" :not-applied))))

;;; ===========================================================================
;;; THE FINAL-SOURCE READINESS CARRIER (owner ruling R2.2, item 1(d)).
;;;
;;; ⚠ THIS MUST REMAIN THE LAST FORM OF THIS FILE, AND THIS FILE MUST REMAIN
;;; THE LAST SOURCE THE LANE LOADS.  That is the entire content of the
;;; evidence it carries.
;;;
;;; The lane's ASDF guard (lisp-plus.asd, ENSURE-ACT0-LANE) enumerates all 70
;;; declared exports and checks each for the binding its kind requires.  That
;;; is necessary and NOT sufficient: 40 of the 41 external functions are
;;; defined in act0.lisp, so a load stopped after act0.lisp — the third of four
;;; sources — is 69/70 complete and would certify under a bindings-only
;;; predicate.  Only a marker established by the FINAL FORM of the FINAL SOURCE
;;; can testify that the load reached the end.
;;;
;;; Idiom: Surface Account /0's SA0-IDENTITY-CARRIER (production/surface-
;;; account.lisp), strengthened from presence-only to presence + BOUNDP +
;;; EQUAL value — an interned name proves only that some hand interned it.
;;;
;;; The symbol is INTERNAL: package.lisp is not touched by this repair, and
;;; the carrier is deliberately not part of the lane's public interface.  It
;;; adds NO gate, NO check, and NO check-line: it defines one variable and
;;; changes no verdict anywhere in this suite.
;;;
;;; THE LANE'S PERMANENT LOADER-FINALITY BATTERY lives beside this file, in the
;;; sibling-script idiom Surface Account /0 uses (run-hostile-profiles.sh /
;;; surface-account-disease.sh) — six witnesses, each in its own fresh SBCL
;;; process, plus the disease comparator that restores the outlawed guard:
;;;
;;;   mneme/language-act-0/act0-load-witnesses.lisp   the six cases
;;;   mneme/language-act-0/act0-load-witnesses.sh     the battery driver
;;;   mneme/language-act-0/act0-loader-disease.sh     the disease comparators
;;;
;;; They are NOT called from this file's gate functions and add no check-line
;;; to this suite's tally, because each case requires an image this suite has
;;; already contaminated by loading.  A lane whose battery ran inside the lane
;;; could not construct "the lane is not loaded yet."
;;;
;;; — FABER-II (Claude Opus 5, subagent), R2.2, 2026-08-08
;;; ===========================================================================

(defparameter act0-lane-ready-carrier
  '(:lane "one-act-0" :final-source "act0-gates.lisp" :position :last-form)
  "One Act /0's final-source readiness carrier.  Established by the last form
of the last source; read by LISP-PLUS-SYSTEM::ACT0-API-COMPLETE-P.")
