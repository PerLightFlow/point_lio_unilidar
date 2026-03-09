#pragma once

#include <cassert>
#include <chrono>

#include <rclcpp/rclcpp.hpp>
#include <builtin_interfaces/msg/time.hpp>

inline rclcpp::Logger pointlio_logger()
{
    return rclcpp::get_logger("point_lio_unilidar");
}

#define ROS_INFO(...) RCLCPP_INFO(pointlio_logger(), __VA_ARGS__)
#define ROS_WARN(...) RCLCPP_WARN(pointlio_logger(), __VA_ARGS__)
#define ROS_ERROR(...) RCLCPP_ERROR(pointlio_logger(), __VA_ARGS__)
#define ROS_ASSERT(cond) assert(cond)

inline double pointlio_time_to_sec(const builtin_interfaces::msg::Time &stamp)
{
    return rclcpp::Time(stamp).seconds();
}

inline builtin_interfaces::msg::Time pointlio_time_from_sec(double seconds)
{
    builtin_interfaces::msg::Time stamp;
    const auto nanoseconds = static_cast<int64_t>(seconds * 1e9);
    stamp.sec = static_cast<int32_t>(nanoseconds / 1000000000LL);
    stamp.nanosec = static_cast<uint32_t>(nanoseconds % 1000000000LL);
    return stamp;
}
