# point_lio_unilidar

`point_lio_unilidar` 当前已整理为 **ROS2 Humble only** 版本，用于与 `/home/s5376/ros_ws/src/unilidar_sdk2` 等 ROS2 节点生态配合使用。

## 当前保留内容

- ROS2 `ament_cmake` 构建系统
- ROS2 节点实现：`pointlio_mapping`
- ROS2 参数文件：
  - `config/unilidar_l1.ros2.yaml`
  - `config/unilidar_l2.ros2.yaml`
- ROS2 启动文件：
  - `launch/mapping_unilidar_l1.launch.py`
  - `launch/mapping_unilidar_l2.launch.py`
- RViz2 配置：`rviz_cfg/loam_livox.rviz`

## 已移除的旧内容

- 旧版构建链路与遗留入口
- ROS1 XML launch 文件
- ROS1 参数 YAML
- RViz1 配置
- ROS1/Noetic 对应的仓库级使用入口

## 主要 ROS2 适配点

- 节点、发布与订阅接口统一到 `rclcpp`
- TF 广播接口统一到 `tf2_ros::TransformBroadcaster`
- 参数系统已迁移到 ROS2 `declare_parameter` / `get_parameter`
- 输入接口统一为：
  - LiDAR：`sensor_msgs/msg/PointCloud2`
  - IMU：`sensor_msgs/msg/Imu`
- 地图相关输出：
  - `/pointlio/cloud_registered`
  - `/pointlio/cloud_effected`
  - `/pointlio/laser_map`
  - `/pointlio/odom`
  - `/pointlio/path`

## 默认与 `unilidar_sdk2` 的接口约定

默认参数面向以下话题：

- 点云：`/unilidar/cloud`
- IMU：`/unilidar/imu`

如需适配其他 bag 或驱动，请修改：

- `common.lid_topic`
- `common.imu_topic`
- `preprocess.lidar_type`
- `preprocess.scan_line`
- `preprocess.timestamp_unit`

## 编译

在工作空间内编译：

```bash
source /opt/ros/humble/setup.bash
cd /home/s5376/ros_ws
colcon build --packages-select point_lio_unilidar
source install/local_setup.bash
```

单独在包目录验证构建：

```bash
source /opt/ros/humble/setup.bash
cd /home/s5376/ros_ws/src/point_lio_unilidar
colcon build \
  --packages-select point_lio_unilidar \
  --base-paths .
```

## 运行

### 1) 对接 `unilidar_sdk2`

终端 1：启动雷达驱动。

终端 2：启动建图。

```bash
source /opt/ros/humble/setup.bash
source /home/s5376/ros_ws/install/local_setup.bash
ros2 launch point_lio_unilidar mapping_unilidar_l2.launch.py
```

### 2) 播放 ROS2 bag 验证

```bash
source /opt/ros/humble/setup.bash
source /home/s5376/ros_ws/install/local_setup.bash
ros2 launch point_lio_unilidar mapping_unilidar_l2.launch.py
```

另开终端播放 bag：

```bash
source /opt/ros/humble/setup.bash
ros2 bag play /home/s5376/下载/Simple-LIO-SAM/ros2/park_dataset
```

如果 bag 话题不是默认的 `/unilidar/cloud` 和 `/unilidar/imu`，请复制一份参数文件后修改对应 topic。

## RViz2 说明

默认 RViz2 配置显示累积地图话题 `/pointlio/laser_map`，用于替代仅显示当前帧点云的效果。

如果看到的是纯白地图点云，这通常只是 RViz2 的着色方式，不代表算法退化；当前配置已切到按 `Z` 轴着色，便于观察空间结构。

## 当前已知问题

- 重复播放同一 bag 时，时间戳回退会触发 buffer 清理告警
- 退出节点时，偶发仍可能存在析构阶段不够平滑的问题
- 与更大规模 ROS2 系统联调前，仍建议继续检查 TF、odom 语义与 Nav2 接口一致性

## 备注

- 仓库当前目标是仅维护 ROS2 Humble 使用链路
- `/home/s5376/ros_ws/src/unilidar_sdk2` 本轮未做修改
- bag 调试时使用过的临时参数文件已删除，不保留在仓库中
