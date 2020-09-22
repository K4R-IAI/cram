(in-package :k4r)
;; Contains some little functions for testing and debugging


(defparameter ?test-pose-stamped
  (cl-tf:make-pose-stamped 
       "map"
       0.0
       (cl-tf:make-3d-vector 1.0 1.0 0.0)
       (cl-tf:make-identity-rotation)))
