;;; defines interfaces to different services.
;;; Some of these might need to be moved later on into donbot_description (Maybe)
(in-package :k4r)

(defun call-send-image-service (name)
  "pokes the send-image client to take and send an image"
  (if (not (roslisp:wait-for-service "send_image" 10))
      (roslisp:ros-warn (send-image-client) "timed out waiting for send-image service")
      (roslisp:call-service "send_image" 'k4r_common_srvs-srv:SendImage :name name)))
