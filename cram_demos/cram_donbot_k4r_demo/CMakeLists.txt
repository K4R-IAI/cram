cmake_minimum_required(VERSION 2.8.3)
project(cram_donbot_k4r_demo)
find_package(catkin REQUIRED
  roslisp
  actionlib_msgs
  message_generation)

generate_messages( DEPENDENCIES actionlib_msgs)

catkin_package(
  CATKIN_DEPENDS roslisp actionlib_msgs message_runtime
  k4r_common_srvs)

include_directories(
  ${catkin_INCLUDE_DIRS}
  )

#add_lisp_executable(demo cram-donbot-k4r-demo cram-donbot-k4r-demo:init)
add_lisp_executable(demo cram-donbot-k4r-demo cram-donbot-k4r-demo:mvp-demo)
