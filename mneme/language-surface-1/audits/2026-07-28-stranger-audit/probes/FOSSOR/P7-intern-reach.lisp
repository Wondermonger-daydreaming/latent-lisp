(load "/tmp/claude-1000/-home-gauss-Desktop-Claude-Code-Lab/d214ea40-d602-4f0d-b684-e6f5fddf4447/scratchpad/surface1-audit/probes/FOSSOR/prelude.lisp")
(in-package #:fossor)
(banner "P7 — WHICH INSTRUMENTS STILL REACH THROUGH INTERN, AND DO THEY BITE?")
(dolist (f '("STUB-IMAGE-FIXTURE.lisp" "de-expansione-testata/APPLICATION.lisp"
             "errata-0.1/REPRODUCTION.lisp" "errata-0.2/REPRODUCTION-II.lisp"
             "surface1-selftest.lisp"))
  (let ((path (merge-pathnames f cl-user::*s1dir*)) (names '()) (nonext '()))
    (with-open-file (in path)
      (loop for l = (read-line in nil) while l do
        (let ((i 0))
          (loop for p = (search "(s1 " l :start2 i) while p do
            (let* ((start (+ p 4))
                   (end (position-if (lambda (c) (member c '(#\Space #\) #\Newline))) l :start start)))
              (when (and end (> end start)) (pushnew (string-upcase (subseq l start end)) names :test #'string=))
              (setf i (1+ p)))))))
    (dolist (n names)
      (multiple-value-bind (sym status) (find-symbol n '#:lisp-plus-surface1)
        (declare (ignore sym))
        (unless (eq status :external) (push (list n status) nonext))))
    (line "~A: ~D distinct (s1 …) names · NON-EXTERNAL: ~S" f (length names) nonext)))
