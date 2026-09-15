(define-condition my-bad (error) () (:report (lambda (c s) (declare (ignore c)) (format s "lane incomplete"))))
(format t "~&before load~%") (finish-output)
(handler-case (error 'my-bad) (my-bad (e) (format t "~&caught: ~a~%" e)))
(error 'my-bad)
