(in-package :k4r)

(cpl:def-cram-function move-base (?ps)
  "moves the robots base using the ros navigation stack"
  (let ((?move-base-desig (desig:a motion
                                   (:type :going)
                                   (:pose ?ps))))

  (exe:perform ?move-base-desig)))
