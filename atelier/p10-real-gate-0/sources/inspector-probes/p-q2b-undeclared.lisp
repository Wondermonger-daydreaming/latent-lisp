(require :sb-introspect)
(load "mneme/memory-layer-0/ml0-suite-ground.lisp")
(let* ((pkg (find-package '#:lisp-plus-memory-layer0))
       (loader (find-package '#:lisp-plus-memory-layer0-loader))
       (all (append (symbol-value (find-symbol "+ML0-EXTERNAL-FUNCTIONS+" loader))
                    (symbol-value (find-symbol "+ML0-EXTERNAL-VARIABLES+" loader))
                    (symbol-value (find-symbol "+ML0-EXTERNAL-TYPES+" loader))))
       (ext '()))
  (do-external-symbols (s pkg) (pushnew s ext))
  (let ((undeclared (sort (loop for s in ext
                                unless (member (symbol-name s) all :test #'string=)
                                  collect (symbol-name s))
                          #'string<)))
    (format t "~&TOTAL externals ~d ; declared names ~d ; UNDECLARED ~d~%"
            (length ext) (length all) (length undeclared))
    (dolist (n undeclared)
      (let ((s (find-symbol n pkg)))
        (format t "  ~a  fboundp=~a class=~a arglist=~s~%"
                n (and (fboundp s) t) (and (find-class s nil) t)
                (handler-case (sb-introspect:function-lambda-list s) (error () :n/a)))))))
;; lambda lists of some candidates
(format t "~%--- selected arglists ---~%")
(dolist (n '("ML0-NOTE" "ML0-CHECK" "ML0-PRINT-STORE-UNIVERSE" "ML0-PRINT-CONJUNCTS"
             "ML0-SUBJECT-FROM-FIXTURE-ROW" "ML0-SUBJECT-CANONICAL-REQUEST"
             "ML0-SUBJECT-EXTERNAL-REQUEST-KEY" "ML0-SUBJECT-FIXTURE-ROW"
             "ML0-ACQUISITION-ROUTE-IDENTIFIER" "ML0-EVIDENCE-PROJECTION-DIGEST"
             "ML0-WARRANTS-COMMENSURABLE-P" "ML0-FAILING-LEG" "ML0-RENDER-ACCOUNT"
             "ML0-SPECIES-MAY-WARRANT-OCCURRENCE-P" "ML0-STORE-SCOPE-UNCHANGED-P"
             "ML0-LIST-ACCOUNT-IDS" "ML0-ENV-PREFLIGHT"))
  (let ((s (find-symbol n (find-package '#:lisp-plus-memory-layer0))))
    (format t "  ~a => ~s~%" n
            (handler-case (sb-introspect:function-lambda-list s) (error () :n/a)))))
(finish-output)
