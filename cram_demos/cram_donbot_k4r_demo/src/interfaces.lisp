;;; defines interfaces to different services.
;;; Some of these might need to be moved later on into donbot_description (Maybe)
(in-package :k4r)

(defun call-send-image-service (name label-name label-id)
  "pokes the send-image service to take and send an image"
  (if (not (roslisp:wait-for-service "send_image" 10))
      (roslisp:ros-warn (send-image-client) "timed out waiting for send-image service")
      (roslisp:call-service "send_image" 'k4r_common_srvs-srv:SendImage :image_name name :label_name label-name :label_id (parse-integer label-id))))

(defun call-get-target-pose-service (object-ID)
  "pokes the get-target-pose service to get a pose to go to"
  (if (not (roslisp:wait-for-service "get_target_pose" 10))
      (roslisp:ros-warn (get-target-pose-client) "timed out waiting for get_target_pose service")
      (roslisp:with-fields (pose_stamped)
          (roslisp:call-service "get_target_pose" 'k4r_common_srvs-srv:GetTargetPose :object object-ID)
       (cl-tf:from-msg pose_stamped))))

(defun get-target-pose-callback(msg)
  (roslisp:with-fields (pose)
      msg
    (print pose)
    pose))

(defun call-get-map-service ()
  "pokes the get-map service to get the map from the platform"
  (if (not (roslisp:wait-for-service "get_map" 10))
      (roslisp:ros-warn (get-map) "timed out waiting for get_map service")
      (roslisp:call-service "get_map" 'k4r_common_srvs-srv:GetMap)))



(defvar *current-plan* nil)
;;; make fluent to wait for msgs

(defvar *flu* (cpl:make-fluent :name :flu :value nil))

(defun get-plan-interface ()
  ;;(cram-language:make-fluent :name *fluent* :value nil)
  (roslisp::subscribe "rosplan_planner_interface/planner_output" "std_msgs/String"
                         #'plan-callback))


(defun plan-callback(msgs)
  (roslisp:with-fields (data) msgs
       (parse-plan data)))

(defun parse-plan(plan-msg)
  (print "plan received. Now parsing")
  (let* ((plan-list nil)
         (rest-plan plan-msg)
         (start nil)
         (end nil))

    (loop while (not (eql (position #\( rest-plan) nil))
      do (setf start (position #\( rest-plan :test #'equal))
         (setf end (position #\) rest-plan :test #'equal))
         (setf plan-list (append plan-list (list (subseq rest-plan (+ start 1) end))))
         (setf rest-plan (subseq rest-plan (+ end 1) (length rest-plan))))

    (setf (cpl:value *flu*) (mapcar #'split-string plan-list))
    (setf *current-plan* (mapcar #'split-string plan-list))
    (print "done parsing plan.")))


(defun split-string(string)
  (loop for i = 0 then (1+ j)
        as j = (position #\Space string :start i)
        collect (subseq string i j)
        while j))
        
