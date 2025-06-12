FROM osrf/ros:humble-desktop-full

# SETUP ENVS
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
# ENV PATH="/opt/ros/humble/bin:${PATH}"

# SETUP parallel workers
ARG parallel_workers=1

# INSTALL SOME ESSENTIAL PROGRAMS
RUN apt update     && \
    apt install -y    \
        git wget bash-completion unzip python3-pip neovim software-properties-common \
        libdraco-dev ros-humble-point-cloud-interfaces

RUN pip3 install rosbags scikit-learn==1.6.1 pandas==2.2.3 numpy==1.24.4

RUN sudo apt install libpcl-dev

# INSTALL MOLA ODOMETRY
RUN apt install -y \
        ros-$ROS_DISTRO-mola \
        ros-$ROS_DISTRO-mola-state-estimation \
        ros-$ROS_DISTRO-mola-lidar-odometry \
        ros-$ROS_DISTRO-mola-test-datasets # popular datasets config files

# INSTALL RCPCC dependencies
RUN apt install -y libopencv-dev libfftw3-dev libzstd-dev libpcl-dev libboost-all-dev\
                ros-humble-pcl-conversions ros-humble-pcl-msgs

# INSTALL cloudini dependencies
RUN apt install -y ros-humble-point-cloud-interfaces \
                   ros-humble-point-cloud-transport \
                   ros-${ROS_DISTRO}-ament-cmake-clang-format

# DOWNLOAD ROS2 PACKAGES into src
WORKDIR /workspace/src
RUN git clone --recurse-submodules https://github.com/witek2310/rcpcc_ros2
# RUN git clone https://github.com/witek2310/point_cloud_metrics
RUN git clone https://github.com/witek2310/draco_ros2

WORKDIR /workspace
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && colcon build --parallel-workers 4 --symlink-install"

# FILL BASHRC
WORKDIR /workspace
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
RUN echo "source /workspace/install/setup.bash" >> ~/.bashrc

