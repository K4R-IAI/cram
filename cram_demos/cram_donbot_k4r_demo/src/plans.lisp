(in-package :k4r)

(defun move-base (?ps)
  "moves the robots base using the ros navigation stack"
  (exe:perform
   (desig:a motion
            (:type :going)
            (:pose ?ps))))
