(in-package :cram-donbot-k4r-demo)


;;;;;;;;;;;;;;;;;;;; MOVE BASE ;;;;;;;;;;;;;;;;;;;;;;;;

(cpm:def-process-module move-base-pm (motion-designator)
  (destructuring-bind (command pose)
      (desig:reference motion-designator)
    (ecase command
     (cram-common-designators:move-base ;; TODO put this back in ?
       (donbot-ll::call-move-base-action-pose
        :pose pose)))))
