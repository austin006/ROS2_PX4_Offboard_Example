# Start gazebo with PX4
cd ~/PX4-Autopilot
make px4_sitl gz_x500

# Start Micro-uXRCE-DDS agent (client automatically started with PX4)
cd ~
MicroXRCEAgent udp4 -p 8888

# Launch QGroundControl
cd ~/QGroundControl
./QGroundControl.AppImage

# TrajectorySetpoint command (Fly to 2m high)
ros2 topic pub /fmu/in/trajectory_setpoint px4_msgs/msg/TrajectorySetpoint "{
  timestamp: $(date +%s%N),
  position: [0.0, 0.0, -2.0],
  yaw: 0.0
}" --rate 10

# Arm command
ros2 topic pub /fmu/in/vehicle_command px4_msgs/msg/VehicleCommand "{
  timestamp: $(date +%s%N),
  param1: 1.0,
  command: 400,
  target_system: 1,
  target_component: 1,
  source_system: 1,
  source_component: 1,
  from_external: true 
}"

# Switch to offboard mode
ros2 topic pub /fmu/in/vehicle_command px4_msgs/msg/VehicleCommand "{
  timestamp: $(date +%s%N),
  param1: 1.0,
  param2: 6.0,
  command: 176,
  target_system: 1,
  target_component: 1,
  source_system: 1,
  source_component: 1,
  from_external: true 
}"

# Land the drone (make sure to stop publishing offboard mode and trajectory_setpoint)
ros2 topic pub /fmu/in/vehicle_command px4_msgs/msg/VehicleCommand "{
  timestamp: $(date +%s%N),
  param1: 0.0,
  command: 21,
  target_system: 1,
  target_component: 1,
  source_system: 1,
  source_component: 1,
  from_external: true
}"