# 🐢🚀 TurtleBot3 Gazebo CI/CD

## 🚀 Project Structure

~~~bash
turtlebot3_gazebo_ci_v2/
├── .github/
│   └── workflows/
│       └── tb3_simulation.yml      # GitHub Actions CI/CD pipeline
├── docker/
│   ├── Dockerfile                  # Defines the Docker image
│   ├── entrypoint.sh               # Starts ROS & Gazebo simulation
│   ├── my_navigation_node/         # ROS 2 package for robot navigation (Project 2)
│   └── project2_world.world        # Custom world file for Project 2
├── scripts/
│   └── start_simulation.sh         # Manual script to run the simulation
├── tests/
│   └── test_robot_spawn.sh         # Test if TurtleBot3 spawns in Gazebo
├── README.md                       # Project documentation
└── .gitignore                      # Ignore unnecessary files
~~~

## 🚀 📂 Container Filesystem Structure
Once the Docker container is running, its internal filesystem will look like this:
~~~bash
/
├── opt/
│   ├── ros/
│   │   ├── humble/                  # ROS 2 Humble installation
│   │   │   ├── setup.bash           # ROS setup script
│   │   │   ├── share/
│   │   │   │   ├── turtlebot3_description/  # TurtleBot3 URDF models
│   │   │   │   │   └── urdf/
│   │   │   │   │       └── turtlebot3_burger.urdf   # Robot model file
│   │   │   │   └── turtlebot3_gazebo/  # Gazebo simulation assets
│   │   │   │       └── worlds/
│   │   │   │           └── empty.world  # Default empty world
├── usr/
│   ├── share/
│   │   ├── gazebo-11/                # Gazebo simulator files
│   │   │   └── worlds/
│   │   │       └── empty.world       # Default Gazebo world used by simulation
├── my_navigation_node/             # Custom ROS 2 navigation package (from docker/my_navigation_node)
├── project2_world.world            # Custom world file for Project 2 (from docker/project2_world.world)
├── entrypoint.sh                   # Entrypoint script (from docker/entrypoint.sh)
~~~
# Custom Room Environment in Gazebo

## 1. How did you create the custom room environment in Gazebo?
I used Gazebo’s Building Editor to set up a room layout. I basically placed four walls to enclose a space and adjusted the dimensions to get the right look. Then I saved the configuration as `project2_world.world` so it could be loaded into the simulation later.

## 2. Describe the process of setting up the ROS 2 workspace and creating the package.
I started by creating a new ROS 2 workspace and used the ROS 2 command-line tool with a command like:

```bash
ros2 pkg create --build-type ament_cmake my_navigation_node
```

This generated the basic package structure. Then, I added my source code, updated the `package.xml` and `CMakeLists.txt` files, and used `colcon build` to compile everything. It was pretty smooth since ROS 2 makes setting up a workspace really straightforward.

## 3. How did you implement the navigation strategy in your node?
My navigation node is pretty simple—it publishes velocity commands on the `/cmd_vel` topic. I set up a timer callback that sends out linear and angular velocity values to move the robot forward and slightly turn, so it effectively moves diagonally. It’s a basic approach, but it gets the robot moving in the desired direction.

## 4. What challenges did you face with making the robot move diagonally, and how did you overcome them?
The tricky part was dialing in the right mix of linear and angular speeds. At first, the robot would either veer too much to one side or not turn enough. I had to do a bit of trial and error, tweaking the velocity parameters until I got a smooth, steady diagonal motion. It was mostly about fine-tuning the values until everything behaved as expected.

## 5. How do you verify that your ROS 2 node is functioning correctly?
I used a couple of methods:
1. Ran `ros2 topic list` and `ros2 topic echo /cmd_vel` to make sure the node was actually publishing the velocity commands.
2. Observed the robot in the Gazebo simulation to confirm that it was moving as intended across the room.
3. Automated tests in the CI pipeline also helped me catch any issues early on.
