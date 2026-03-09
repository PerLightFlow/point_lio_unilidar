from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument
from launch.conditions import IfCondition
from launch.substitutions import LaunchConfiguration
from launch_ros.actions import Node
from ament_index_python.packages import get_package_share_directory
import os


def generate_launch_description():
    package_share = get_package_share_directory('point_lio_unilidar')
    rviz = LaunchConfiguration('rviz')
    params = os.path.join(package_share, 'config', 'unilidar_l1.ros2.yaml')
    rviz_cfg = os.path.join(package_share, 'rviz_cfg', 'loam_livox.rviz')

    return LaunchDescription([
        DeclareLaunchArgument('rviz', default_value='true'),
        Node(
            package='point_lio_unilidar',
            executable='pointlio_mapping',
            name='laserMapping',
            output='screen',
            parameters=[params],
        ),
        Node(
            package='rviz2',
            executable='rviz2',
            name='rviz2',
            arguments=['-d', rviz_cfg],
            condition=IfCondition(rviz),
            output='screen',
        ),
    ])
