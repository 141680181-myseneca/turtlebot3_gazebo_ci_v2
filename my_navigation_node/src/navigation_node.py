#!/usr/bin/env python3

import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist

class NavigationNode(Node):
    def __init__(self):
        super().__init__('navigation_node')
        self.publisher_ = self.create_publisher(Twist, '/cmd_vel', 10)
        self.timer = self.create_timer(0.1, self.timer_callback)
        self.duration = 10.0  # Run for 10 seconds
        self.start_time = self.get_clock().now().seconds_nanoseconds()[0]

    def timer_callback(self):
        current_time = self.get_clock().now().seconds_nanoseconds()[0]
        if current_time - self.start_time > self.duration:
            twist = Twist()
            twist.linear.x = 0.0
            twist.angular.z = 0.0
            self.publisher_.publish(twist)
            self.get_logger().info('Navigation complete. Stopping the robot.')
            rclpy.shutdown()
        else:
            twist = Twist()
            twist.linear.x = 0.5  # Move forward at 0.5 m/s
            twist.angular.z = 0.0
            self.publisher_.publish(twist)
            self.get_logger().info('Moving forward...')

def main(args=None):
    rclpy.init(args=args)
    node = NavigationNode()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
