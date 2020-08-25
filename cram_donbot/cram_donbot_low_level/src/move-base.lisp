;; Navigation interface between DonBot and ROS Navigation stack

(in-package :donbot-ll)

(defvar *move-base-client* nil)

(defun init-action-client ()
  (setf *move-base-client* (actionlib:make-action-client
                            "move_base"
                            "move_base_msgs/MoveBaseAction"))
  (roslisp:ros-info (navigate-map)
                    "Waiting for move_base action server...")
  ;; workaround for race condition in actionlib wait-for server
  (loop until (actionlib:wait-for-server *move-base-client*))
  (roslisp:ros-info (navigate-map) 
                    "move_base action client created."))

(defun get-action-client ()
  (when (null *move-base-client*)
    (init-action-client))
  *move-base-client*)

(defun make-move-base-goal (pose-stamped-goal)
  (actionlib:make-action-goal (get-action-client)
    target_pose pose-stamped-goal))

(defun call-move-base-action (frame-id translation rotation)
  (unless (eq roslisp::*node-status* :running)
    (roslisp:start-ros-node "move-base-lisp-client"))

  (multiple-value-bind (result status)
      (let ((actionlib:*action-server-timeout* 10.0)
            (the-goal (cl-tf:make-pose-stamped-msg 
                       (cl-tf:make-pose
                        translation rotation)
                       frame-id
                       (roslisp::ros-time))))
        (actionlib:call-goal
         (get-action-client)
         (make-move-base-goal the-goal)))
    (roslisp:ros-info (navigate-map) "Move_base action finished.")
    (values result status)))
