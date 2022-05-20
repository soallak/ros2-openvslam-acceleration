## Dependencies 
The following dependencies needs to be installed before compiling and using this repository:

- Dependencies of [OpenVSLAM](https://openvslam-community.readthedocs.io/en/latest/installation.html#dependencies)
- Vitis 2020.2

## Getting Started

1. Import repositories using *vcs*: 
```
cd src/
vcs import < src/.repos
```

2. This is optional, in case for example they are not available from the OS' package manager nor PyPi:

  a. colcon-acceleration: 
```
cd src/kria/colcon-acceleration
python setup.py build
python setup.py install --user
```

  b. and the same for colcon-mixin: 
```
cd src/kria/colcon-mixin
python setup.py build
python setup.py install --user
```
3. In the root of this repository, source ROS2 installation and build. 

```
source $ROS2_HONE/setup.zsh
colcon build --merge-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Release --parallel-workers 32
```

4. For KV260, from a new terminal do:

```
source $ROS2_HONE/setup.zsh
colcon acceleration select kv260-soallak

# Compile for kv260
colcon build --build-base=build-kv260-soallak --install-base=install-kv260-soallak --merge-install --mixin kv260-soallak --cmake-args -DROS_VITIS=ON -DCMAKE_BUILD_TYPE=Release

# Compile for kv260 with img_proc kernels disabled to speed up the build
colcon build --build-base=build-kv260-soallak --install-base=install-kv260-soallak --merge-install --mixin kv260-soallak --cmake-args -DROS_VITIS=ON -DCMAKE_BUILD_TYPE=Release -DNO_IMAGE_PROC_KERNEL=ON

# Compile for kv260 without any kernels
colcon build --build-base=build-kv260-soallak --install-base=install-kv260-soallak --merge-install --mixin kv260-soallak --cmake-args -DROS_VITIS=ON -DCMAKE_BUILD_TYPE=Release -DNOKERNELS=ON -DNO_IMAGE_PROC_KERNEL=ON

```

## SLAM Pipeline On Host 
The build command will also download default dataset.

```
ros2 launch slam_launch slam_full.launch.py dataset_path:=build/data_euroc/Machine_Hall_01/ dataset_period:=100 dataset_type:=euroc  system_type:=stereo start_pangolin_viewer:=true start_rviz2:=true
```

## SLAM Pipeline with Stereo-Matcher offloaded to KV260

1. Deploy kv260-sollak install dir to the board
```
 scp -r install-kv260-soallak kv260:
```
2. On the kv260, install `hwcv_kernels`

```
cp -r install-kv260-soallak/lib/hwcv_kernels/ /lib/firmware/xilinx/
xlnx-config -x unloadapp
xlnx-config -x loadapp hwcv_kernels
```

3. On the host, start date publisher and openvslam node
```
source install/setup.zsh
ros2 launch slam_launch slam_host.launch.py dataset_path:=build/data_euroc/Machine_Hall_01/ dataset_period:=100 dataset_type:=euroc start_rviz2:=true start_pangolin_viewer:=true

```

4. On kv260, start stereo-matcher
```
source /opt/ros/foxy/setup.bash
source install-kv260-soallak/local_setup.bash
# with hwcv acceleration
ros2 launch slam_launch slam_edge.launch.py stereo_algorithm:=2
# without hwcv acceleration
ros2 launch slam_launch slam_edge.launch.py stereo_algorithm:=0

```

## Traces Analysis

```
lttng create data_euroc_Machine_Hall_01
lttng enable-event --userspace slam_tracepoint_provider:'*' 
lttng start
```

After all images are published

```
lttng stop
ros2 run slam_tracepoint_analysis process  ~/lttng-traces/data_euroc_Machine_Hall_01-20220322-200832/ data_euroc_Machine_Hall_01_cpu.png

```
