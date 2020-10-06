;;; motion designator definition for the k4r demo

(in-package :cram-donbot-k4r-demo)


(def-fact-group donbot-move-base-designators (desig:motion-grounding)

  (<- (desig:motion-grounding ?designator (:going ?pose))
    (desig:desig-prop ?designator (:type :going))
    (desig:desig-prop ?designator (:target ?pose))))
