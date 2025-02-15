#!/bin/bash
set -e

echo "🚀 EntryPoint: Starting TurtleBot3 Gazebo Simulation..."

# Source the ROS 2 Humble environment
source /opt/ros/humble/setup.bash

# Set the TurtleBot3 model (default: burger)
export TURTLEBOT3_MODEL=${TURTLEBOT3_MODEL:-burger}

# Disable audio processing to prevent ALSA/OpenAL errors
export GAZEBO_AUDIO=0
export SDL_AUDIODRIVER=dummy
export PULSE_SERVER=""
export ALSA_CONFIG_PATH=/dev/null

# Force full headless mode in Gazebo
export DISPLAY=:99
export QT_QPA_PLATFORM=offscreen
export GAZEBO_RENDERING=0
export GAZEBO_HEADLESS_RENDERING=1
export GAZEBO_GUI=0
export SVGA_VGPU10=0

echo "🛠️ Using TurtleBot3 Model: $TURTLEBOT3_MODEL"

# Remove stale Xvfb lock file if it exists
if [ -f "/tmp/.X99-lock" ]; then
  echo "🛑 Removing stale Xvfb lock file..."
  rm -f /tmp/.X99-lock
fi

# Kill any existing Xvfb on display :99 (forcefully)
if pgrep -f "Xvfb :99" > /dev/null; then
  echo "⚠️ Killing existing Xvfb on display :99..."
  pkill -9 -f "Xvfb :99"
  sleep 1
fi

echo "📡 Starting Xvfb on display :99..."
Xvfb :99 -screen 0 1024x768x24 &
sleep 2

# Kill any existing Gazebo processes
echo "🛑 Killing any existing Gazebo processes..."
pkill -9 -f gzserver || true
pkill -9 -f gzclient || true
sleep 2

# Set GAZEBO_MASTER_URI based on port availability
if command -v lsof > /dev/null; then
  if lsof -i :11345 > /dev/null; then
    echo "⚠️ Port 11345 in use. Binding Gazebo to port 11346..."
    export GAZEBO_MASTER_URI=http://127.0.0.1:11346
  else
    export GAZEBO_MASTER_URI=http://127.0.0.1:11345
  fi
else
  export GAZEBO_MASTER_URI=http://127.0.0.1:11345
fi

# Launch Gazebo via ROS 2 launch in headless mode using the default world
# (For Project 2, you can manually launch your custom world and navigation node using the provided launch file.)
echo "🔄 Launching ROS 2 Gazebo Bridge in headless mode..."
ros2 launch gazebo_ros gazebo.launch.py gui:=false &
sleep 10

# Wait for /spawn_entity service and spawn TurtleBot3 (Project 1 functionality)
echo "🔎 Waiting for /spawn_entity service..."
timeout 30 bash -c 'until ros2 service list | grep -q /spawn_entity; do sleep 1; done' || {
  echo "❌ ERROR: /spawn_entity service not available."
  exit 1
}

echo "🧹 Removing any existing TurtleBot3 instance..."
for i in {1..3}; do
  ros2 service call /delete_entity gazebo_msgs/srv/DeleteEntity "{name: 'tb3'}" && break || sleep 2
done
sleep 5

echo "🤖 Spawning TurtleBot3..."
ros2 run gazebo_ros spawn_entity.py -entity tb3 -file "/opt/ros/humble/share/turtlebot3_description/urdf/turtlebot3_${TURTLEBOT3_MODEL}.urdf"
sleep 5

echo "✅ Simulation Ready! TurtleBot3 is in Gazebo."

# Kill any stray gzclient process
pkill -9 -f gzclient || true

# End entrypoint for Project 1 functionality.
exit 0
