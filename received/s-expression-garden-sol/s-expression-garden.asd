;;;; s-expression-garden.asd

(asdf:defsystem #:s-expression-garden
  :description "Botanical jurisprudence for grafting executable S-expressions."
  :author "OpenAI, designed with Wondermonger-daydreaming"
  :license "MIT"
  :version "0.1.0"
  :serial t
  :components ((:file "package")
               (:file "garden")
               (:file "specimens")
               (:file "demo")
               (:static-file "RULEBOOK.sexp"))
  :in-order-to ((asdf:test-op (asdf:test-op #:s-expression-garden/tests))))

(asdf:defsystem #:s-expression-garden/tests
  :description "Test assize for The S-Expression Garden."
  :depends-on (#:s-expression-garden)
  :serial t
  :components ((:file "tests"))
  :perform (asdf:test-op (operation component)
             (declare (ignore operation component))
             (uiop:symbol-call '#:s-expression-garden '#:run-tests
                               :trials 200
                               :signal-on-failure t)))
