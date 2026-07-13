#!/usr/bin/env -S sbcl --script

;;;; Grow the initial Receipt-Bearing Seed from one program form.

(defparameter *seed-program*
  '(lambda (self generation organism grafts)
     (labels ((tree-size (tree)
                (if (atom tree)
                    1
                    (+ 1 (tree-size (second tree))
                         (tree-size (third tree)))))
              (replace-node (tree index donor)
                (cond ((zerop index) (copy-tree donor))
                      ((atom tree)
                       (error "Graft index ~D falls outside ~S" index tree))
                      (t
                       (let ((left-size (tree-size (second tree))))
                         (if (<= index left-size)
                             (list (first tree)
                                   (replace-node (second tree)
                                                 (1- index)
                                                 donor)
                                   (copy-tree (third tree)))
                             (list (first tree)
                                   (copy-tree (second tree))
                                   (replace-node (third tree)
                                                 (- index left-size 1)
                                                 donor))))))))
       (let* ((graft (car grafts))
              (cut (and graft (first graft)))
              (donor (and graft (second graft)))
              (child-organism
                (if graft
                    (replace-node organism cut donor)
                    (copy-tree organism)))
              (remaining-grafts (if graft (rest grafts) nil))
              (child-source
                (list self
                      (list 'quote self)
                      (1+ generation)
                      (list 'quote child-organism)
                      (list 'quote remaining-grafts)))
              (receipt
                (list :receipt-version 1
                      :specimen :receipt-bearing-seed
                      :parent-generation generation
                      :child-generation (1+ generation)
                      :parent-organism organism
                      :graft (if graft
                                 (list :preorder-cut cut :donor donor)
                                 :none)
                      :child-organism child-organism
                      :remaining-grafts (length remaining-grafts)
                      :replay-valid
                        (if graft
                            (equal child-organism
                                   (replace-node organism cut donor))
                            (equal child-organism organism))
                      :identity
                        (list :same-program-form t
                              :same-organism (equal organism child-organism)
                              :authority
                                (if graft :new-name-required :lineage-only))
                      :verdict
                        (if graft
                            :graft-demonstrated
                            :fallow-continuation))))
         ;; stdout is viable offspring; stderr is testimony about the birth.
         (write child-source :pretty nil)
         (let ((*standard-output* *error-output*))
           (write receipt :pretty nil)
           (terpri))))))

(defparameter *initial-organism*
  '(claim continuity (because probes finite)))

(defparameter *graft-queue*
  '((1 conformance)
    (4 (domain boolean-lists length-8))
    (3 (count 511 cases))))

(with-open-file
    (stream (merge-pathnames "receipt-seed.lisp" *load-truename*)
            :direction :output
            :if-exists :supersede
            :if-does-not-exist :create)
  (write (list *seed-program*
               (list 'quote *seed-program*)
               0
               (list 'quote *initial-organism*)
               (list 'quote *graft-queue*))
         :stream stream
         :pretty nil))

(format t "Grew receipt-seed.lisp at generation 0.~%")
