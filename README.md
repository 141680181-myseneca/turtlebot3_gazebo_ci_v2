# 🐢🚀 TurtleBot3 Gazebo CI/CD

## 🚀 Project Structure

~~~bash
turtlebot3_gazebo_ci/
├── .github/                        
│   └── workflows/
│       └── tb3_simulation.yml      # GitHub Actions CI/CD pipeline
├── docker/
│   ├── Dockerfile                  # Defines the Docker image
│   └── entrypoint.sh               # Starts ROS & Gazebo simulation
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
│   │   │   ├── setup.bash            # ROS setup script
│   │   │   ├── share/
│   │   │   │   ├── turtlebot3_description/  # TurtleBot3 URDF models
│   │   │   │   │   ├── urdf/
│   │   │   │   │   │   ├── turtlebot3_burger.urdf   # Robot model file
│   │   │   │   ├── turtlebot3_gazebo/  # Gazebo simulation assets
│   │   │   │   │   ├── worlds/
│   │   │   │   │   │   ├── empty.world # Empty world file
├── usr/
│   ├── share/
│   │   ├── gazebo-11/                # Gazebo simulator files
│   │   │   ├── worlds/
│   │   │   │   ├── empty.world       # Default world used by simulation
├── entrypoint.sh                      # Custom script to start the robot
~~~

![TurtleBot3 Gazebo](https://user-images.githubusercontent.com/your-image-url.png)  
*A fully automated CI/CD pipeline for running TurtleBot3 simulations using Docker and GitHub Actions.*

---

## 📌 Project Overview

This project sets up a **Docker-based CI/CD pipeline** for running **TurtleBot3 simulations in Gazebo** without using `.launch` files. It automates:
- **Building the ROS 2 & Gazebo environment** inside Docker.
- **Spawning the TurtleBot3 robot** in an empty Gazebo world.
- **Running tests** to ensure proper simulation setup.
- **Continuous Integration (CI)** using GitHub Actions.

---

## 🛠️ Setup & Usage

### 🔹 Prerequisites

Before running this project, ensure you have:
- **Docker** installed: [Get Docker](https://docs.docker.com/get-docker/)
- (Optional) **GitHub Actions Runner** if testing locally.

### 🔹 Clone the Repository

~~~bash
git clone https://github.com/141680181-myseneca/turtlebot3_gazebo_ci.git
cd turtlebot3_gazebo_ci
~~~

### 🔹 Build & Run the Docker Container

To build and run the simulation inside a Docker container, execute:

~~~bash
docker build -t tb3_sim ./docker
docker run --rm -it tb3_sim
~~~

This will:
- Start Gazebo with an empty world.
- Spawn TurtleBot3 inside Gazebo.

---

## ⚡ CI/CD Pipeline (GitHub Actions)

When you push code to the main branch, GitHub Actions will:
- Build the Docker image using `docker/Dockerfile`.
- Run the TurtleBot3 simulation inside a container.
- Test if the robot spawns correctly.
- Pass the workflow if everything works.

### 🔹 Manual CI/CD Trigger

To manually trigger the pipeline:

~~~bash
git push origin turtlebot3_gazebo_ci

~~~

*Alternatively, trigger via GitHub Actions > Workflows.*

---

## 🧪 Testing

### 🔹 Run Tests Locally

To test if the robot spawns correctly inside Gazebo:

~~~bash
docker run --rm tb3_sim bash -c "ros2 run gazebo_ros spawn_entity.py -entity tb3 -file /opt/ros/humble/share/turtlebot3_description/urdf/turtlebot3_burger.urdf"
~~~


---

## ❓ FAQ

**1. What command did you use to create a ROS 2 package?**

I used:
```bash
ros2 pkg create --build-type ament_cmake my_package

custom world (`project2_world.world`) and launch your navigation node. Use the appropriate ROS 2 launch structure in `.launch.py` format. ### Running Project 2 - **Build your custom package:** ```bash colcon build --packages-select my_navigation_node ``` - **Launch the custom world and navigation node:** - Either update your Docker container’s entrypoint or create a new launch file to run your custom world and node simultaneously. Ensure this orchestrates the Gazebo world and robot’s movement toward the destination. - **Verify the robot moves:** Check that the robot navigates from one corner of the room to the opposite corner successfully in Gazebo. ### Questions: 1. **How did you modify the existing world?** - Simply use Gazebo’s Building Editor or edit `empty.world` where we typically start our simulation. Add walls, items, or obstacles as needed for your custom room. 2. **What ROS 2 node did you create for navigation?** - As outlined in the instructions, create a node that utilizes movement commands (for instance `/cmd_vel`) to control the robot’s movement. You can either implement your velocity control logic or use pre-existing robot controllers if available. --- That's all! You can now proceed with your custom world and robot movement simulation in Gazebo. ``` for 30 seconds
Below is an updated set of files for Project 2 – Custom World and Robot Movement. These changes build on your current setup with as few modifications as possible. Replace (or add) the following files in your repository: