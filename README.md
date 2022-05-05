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

2. This is optional, in my case, I needed to manually extend colcon, instead of installing from
   PyPi:

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
3. In the root of this repository, source ROS2 installation and build

```
source $ROS2_HONE/setup.zsh
colcon build --merge-install
```

4. For hardware, from a new terminal do:

Refer to Xilinx build instructions [example](https://xilinx.github.io/KRS/sphinx/build/html/docs/examples/0_ros2_publisher.html#building-creating-the-raw-image-and-running-in-hardware) 
```
source $ROS2_HONE/setup.zsh
colcon acceleration select kv260

#Test that tool chain is working
colcon build --build-base=build-kv260 --install-base=install-kv260 --merge-install --mixin kv260 --packages-select ament_vitis ament_acceleration vadd_publisher

# Compile image_proc for kv260
colcon build --build-base=build-kv260 --install-base=install-kv260 --merge-install --mixin kv260 --packages-select ament_vitis ament_acceleration image_proc vitis_common tracetools_image_pipeline

#To create sd_card.img
colcon acceleration linux vanilla --install-dir install-kv260

```

## SLAM Pipeline
To compile run:
```
colcon build --merge-install --cmake-args -DUSE_PANGOLIN_VIEWER=ON -DUSE_SOCKET_PUBLISHER=OFF 
```
The above command will also download default datasets.


### Without Rviz2

```
ros2 launch slam_launch slam.launch.py dataset_path:=build/data_euroc/Machine_Hall_01/ dataset_period:=100 dataset_type:=euroc
```

### With Rviz2

```
ros2 launch slam_launch slam.launch.py dataset_path:=build/data_euroc/Machine_Hall_01/ dataset_period:=100 dataset_type:=euroc start_rviz2:=true
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
