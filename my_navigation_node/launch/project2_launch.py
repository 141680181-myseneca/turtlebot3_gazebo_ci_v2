import os
from launch import LaunchDescription
from launch.actions import ExecuteProcess
from launch_ros.actions import Node

def generate_launch_description():
    # Use the custom world file (assumed to be at /project2_world.world in the container)
    world_file = '/project2_world.world'
    
    gazebo = ExecuteProcess(
        cmd=['gazebo', '--verbose', world_file, '--headless'],
        output='screen'
    )
    
    navigation_node = Node(
        package='my_navigation_node',
        executable='navigation_node.py',
        name='navigation_node',
        output='screen'
    )
    
    return LaunchDescription([
        gazebo,
        navigation_node
    ])
