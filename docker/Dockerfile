# Use the official ROS 2 Humble Desktop image with Gazebo
FROM osrf/ros:humble-desktop

# Install required dependencies for TurtleBot3, Gazebo, headless support, and colcon
RUN apt-get update && apt-get install -y \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-turtlebot3-gazebo \
    ros-humble-turtlebot3-msgs \
    ros-humble-turtlebot3-simulations \
    ros-humble-turtlebot3-description \
    xvfb \
    lsof \
    python3-colcon-common-extensions && \
    rm -rf /var/lib/apt/lists/*

# Install additional system dependencies (including Xvfb utilities)
RUN apt-get update && apt-get install -y \
    xvfb \
    x11-utils \
    x11-xserver-utils && \
    rm -rf /var/lib/apt/lists/*

# Set default environment variables for headless mode
ENV TURTLEBOT3_MODEL=burger
ENV DISPLAY=:99
ENV QT_QPA_PLATFORM=offscreen
ENV GAZEBO_RENDERING=0
ENV GAZEBO_HEADLESS_RENDERING=1
ENV SVGA_VGPU10=0

# Copy the entrypoint script into the container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy the custom navigation package and custom world into the container
COPY my_navigation_node /my_navigation_node
COPY project2_world.world /project2_world.world

# Build the custom navigation package using colcon
RUN . /opt/ros/humble/setup.bash && colcon build --base-path /my_navigation_node

# Use bash as default shell for subsequent RUN commands
SHELL ["/bin/bash", "-c"]

# Set the default entrypoint (runs automatically on 'docker run')
ENTRYPOINT ["/entrypoint.sh"]
