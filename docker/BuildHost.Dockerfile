FROM ros:rolling-perception

LABEL  maintainer="soallak <sw.allak@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

ARG USER_ID=1000
ARG USER=krs

WORKDIR /workdir

RUN apt-get update && apt-get install -y \ 
    mesa-opencl-icd \
    opencl-headers \
    ocl-icd-opencl-dev \
    ocl-icd-dev \
    libeigen3-dev \
    libsuitesparse-dev \
    libyaml-cpp-dev \
    lttng-tools \
    liblttng-ust-common1 \
    liblttng-ust-ctl5 \
    liblttng-ust-dev \
    liblttng-ust-python-agent1 \
    liblttng-ust1 \
    liblttng-ctl-dev \
    liblttng-ctl0 \
    python3-lttng \
    python3-lttnganalyses \
    python3-lttngust \
    ros-rolling-image-common \
    ros-rolling-vision-opencv \
    ros-rolling-rviz2 && rm -rf /var/lib/apt/lists/*

# Build & install g2o
RUN git clone https://github.com/RainerKuemmerle/g2o.git; cd g2o; mkdir build; cd build; \
    cmake -DCMAKE_INSTALL_PREFIX=/usr .. && make && make install

# Build & install FBoW
RUN git clone https://github.com/stella-cv/FBoW.git; cd FBoW; mkdir build; cd build; \
    cmake -DCMAKE_INSTALL_PREFIX=/usr .. && make && make install

# Build & install Pangolin
RUN git clone --recursive https://github.com/stevenlovegrove/Pangolin.git; cd Pangolin; \
    ./scripts/install_prerequisites.sh recommended; \
    mkdir build; cd build; \
    cmake -DCMAKE_INSTALL_PREFIX=/usr .. && make && make install


# Add HLS headers, only the headers are need for compilation 
# there to include whole vitis just for that
ADD resources/Vitis_HLS_include.tar.gz .

##Cleanup Workdir
##RUN rm -rf /workdir/*

# get and compile the workspace
RUN git clone https://github.com/soallak/ros2_openvslam_acceleration.git && \
    cd ros2_openvslam_acceleration/src && vcs import < .repos && cd ..;

ENV XILINX_HLS=/workdir/Vitis_HLS/2021.2/
ENV XILINX_VIVADO=""
ENV XILINX_VITIS=""

RUN bash -c 'source /opt/ros/rolling/setup.bash; \
    cd ros2_openvslam_acceleration;  colcon build --merge-install --cmake-args -DCMAKE_BUILD_TYPE=Release -DTRACETOOLS_LTTNG_ENABLED=OFF --parallel-workers 32'

# install default dataset
RUN mkdir -p /data/euroc/; cp -r ros2_openvslam_acceleration/install /openvslam_acceleration && cp -r ros2_openvslam_acceleration/build/data_euroc/Machine_Hall_01 /data/euroc/

# The entry point
COPY resources/openvslam_entrypoint.sh /
RUN chmod +x /openvslam_entrypoint.sh

RUN adduser --disabled-password --gecos '' --uid ${USER_ID} ${USER} && \
    usermod -aG sudo ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER krs
WORKDIR /home/krs

ENTRYPOINT [ "/openvslam_entrypoint.sh" ]
