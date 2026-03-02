# Ubuntu 20.04 with ROS Noetic
# This Dockerfile is configured for point_lio_unilidar project
FROM osrf/ros:noetic-desktop-full

# Install ROS noetic packages and dependencies
RUN apt-get update \
    && apt install -y ros-noetic-pcl-ros \
    && apt install -y ros-noetic-perception-pcl \
    && apt install -y ros-noetic-vision-opencv \
    && apt install -y ros-noetic-tf \
    && apt install -y ros-noetic-geometry-msgs \
    && apt install -y ros-noetic-nav-msgs \
    && apt install -y ros-noetic-sensor-msgs \
    && apt install -y ros-noetic-std-msgs \
    && apt install -y ros-noetic-roscpp \
    && apt install -y ros-noetic-rospy \
    && apt install -y libpcl-dev \
    && apt install -y libeigen3-dev \
    && apt install -y libopencv-dev \
    && apt install -y git \
    && apt install -y wget curl \
    && apt install -y vim \
    && apt install -y build-essential \
    && apt install -y cmake \
    && apt install -y python3-dev \
    && apt install -y libpython3-dev \
    && apt install -y software-properties-common \
    && apt install -y mesa-utils \
    && apt install -y net-tools \
    && rm -rf /var/lib/apt/lists/*

# Create user with sudo privileges
RUN useradd --create-home --no-log-init --shell /bin/bash pointlio \
    && adduser pointlio sudo \
    && usermod -a -G sudo pointlio \
    && echo 'pointlio:pointlio' | chpasswd \
    && mkdir -p /etc/sudoers.d \
    && echo "pointlio ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/pointlio \
    && chmod 0440 /etc/sudoers.d/pointlio \
    && USER=pointlio \
    && GROUP=pointlio \
    && curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.4.1/fixuid-0.4.1-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - \
    && chown root:root /usr/local/bin/fixuid \
    && chmod 4755 /usr/local/bin/fixuid \
    && mkdir -p /etc/fixuid \
    && printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml \
    && mkdir -p /home/pointlio/ros_ws \
    && sudo chown pointlio:pointlio /home/pointlio/ros_ws \
    && echo 'source /opt/ros/noetic/setup.bash' >> /home/pointlio/.bashrc

USER pointlio:pointlio
WORKDIR /home/pointlio
ENTRYPOINT ["fixuid"]

CMD ["/bin/bash"]