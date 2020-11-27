;;;
;;; Copyright (c) 2018, Gayane Kazhoyan <kazhoyan@cs.uni-bremen.de>
;;; All rights reserved.
;;;
;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions are met:
;;;
;;;     * Redistributions of source code must retain the above copyright
;;;       notice, this list of conditions and the following disclaimer.
;;;     * Redistributions in binary form must reproduce the above copyright
;;;       notice, this list of conditions and the following disclaimer in the
;;;       documentation and/or other materials provided with the distribution.
;;;     * Neither the name of the Intelligent Autonomous Systems Group/
;;;       Technische Universitaet Muenchen nor the names of its contributors
;;;       may be used to endorse or promote products derived from this software
;;;       without specific prior written permission.
;;;
;;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
;;; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;;; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;;; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
;;; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;;; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;;; POSSIBILITY OF SUCH DAMAGE.

(in-package :cram-donbot-k4r-demo)

(defun init(&optional (?with-planner T))
  ;;(roslisp-utilities:startup-ros)
  (roslisp:start-ros-node "cram")
  (donbot-ll::init-move-base-action-client)
  (if ?with-planner
      (get-plan-interface))
  )

(defun mvp-demo (&optional (?init T) (?with-planner T))
  (if ?init
      (init))

  (with-unreal-robot
    (let* ((?target-pose ?test-pose-stamped))

      (if ?with-planner
          (cpl:whenever ((cpl:pulsed *flu*))
            
            (let* ((full-plan (cpl:value *flu*)))
              (mapcar (lambda (task)
                        (if (string= "goto_waypoint" (first task))
                            (progn (print "going to waypoint")
                                   ;;(setf ?target-pose (call-get-target-pose-service (third task)))
                                   (call-get-target-pose-service (third task))
                                   (move-base ?target-pose)
                                   ;;(setf ?target-pose (call-get-target-pose-service (fourth task)))
                                   ;;(move-base ?target-pose)
                                   ))

                        (if (string= "load_map" (first task))
                            (progn (print "calling get map service")
                                   (print "is currently commented out")
                                   ;;(call-get-map-service)
                                   ))

                        (if (string= "take_picture" (first task))
                            (progn (print "taking a picture")
                                   (call-send-image-service (third task))))

                        (if (string= "finish_inventory" (first task))
                            (progn (print "finishing inventory")))

                        (print "done with task. let's do next task"))

                      full-plan))))


              
      ;; trigger task
      ;; get 2d map
      ;;(call-get-map-service) 
      ;; get target pose
      (call-get-target-pose-service "test")
      ;; move to target pose
      (move-base ?target-pose)
      ;; capture image
      (call-send-image-service "shelf-picture")
      ;; send image to platform

  )))
