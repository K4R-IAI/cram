(in-package :cram-donbot-k4r-demo)

;;;;;;;;;;;;;;;;;;;;; fact groups ;;;;;;;;;;;;;;;;;;;;;

(def-fact-group donbot-k4r-pms (cpm:matching-process-module
                                cpm:available-process-module)

  ;; make pm available
  (<- (cpm:available-process-module move-base-pm))
  
  ;; definition of rules
  (<- (cpm:matching-process-module ?motion-designator move-base-pm)
    (desig:desig-prop ?motion-designator (:type :going))))




;;;;;;;;;;;;;;;;;;;;;; macros ;;;;;;;;;;;;;;;;;;;;;;;;

;;; macro for unreal robot
(defmacro with-unreal-robot (&body body)
  `(cram-process-modules:with-process-modules-running
       (donbot-pm:grippers-pm
        move-base-pm
        ;;cram-giskard::giskard-pm
        )
     (cpl-impl::named-top-level (:name :top-level)
       ,@body)))
