FROM osrf/ros:humble-desktop

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        curl \
        git \
        libeigen3-dev \
        libopencv-dev \
        libpcl-dev \
        libpython3-dev \
        mesa-utils \
        net-tools \
        python3-colcon-common-extensions \
        python3-dev \
        python3-pip \
        ros-humble-geometry-msgs \
        ros-humble-nav-msgs \
        ros-humble-pcl-conversions \
        ros-humble-rclcpp \
        ros-humble-rviz2 \
        ros-humble-sensor-msgs \
        ros-humble-std-msgs \
        ros-humble-tf2 \
        ros-humble-tf2-geometry-msgs \
        ros-humble-tf2-ros \
        ros-humble-visualization-msgs \
        software-properties-common \
        vim \
        wget \
    && rm -rf /var/lib/apt/lists/*

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
    && chown -R pointlio:pointlio /home/pointlio \
    && echo 'source /opt/ros/humble/setup.bash' >> /home/pointlio/.bashrc

USER pointlio:pointlio
WORKDIR /home/pointlio
ENTRYPOINT ["fixuid"]
CMD ["/bin/bash"]
