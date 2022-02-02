ROS2 image pipeline acceleration workspace

## Getting Started

1. Import repositories using *vcs*: 
```
vcs import < src/.repos
```

2. This is optional, in my case,  I needed to manually extend colcon, instead of installing from
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
```
source $ROS2_HONE/setup.zsh
colcon acceleration select te0807

#Test that tool chain is working
colcon build --build-base=build-te0807 --install-base=install-te0807 --merge-install --mixin te0807 --packages-select ament_vitis ament_acceleration vadd_publisher

# Compile image_proc for te0807
colcon build --build-base=build-te0807 --install-base=install-te0807 --merge-install --mixin te0807 --packages-select ament_vitis ament_acceleration image_proc vitis_common tracetools_image_pipeline

#To create sd_card.img. Not supported for te0807
colcon acceleration linux vanilla --install-dir install-te0807

```

## Usage notes

I used [*direnv*](https://direnv.net/) to setup environment variables. For installation and usage
follow the instructions there.
Next step is to modify environment variables defined in `.envrc` to match your system configuration,
and run `direnv allow`

Alternatively once could setup the same environment by `source .envrc`. Again, refer to *direnv*
documentation for advantages of using *direnv*

To export compile commands, use `colcon build --merge-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=on`
and then create softlinks when needed

`source $XILINX_VITIS/settings64.csh` causes `cmake` related errors


For HW builds, the used platform can be changed. `colcon acceleration list` to list available ones

To create `sd_card.img` `colcon acceleration linux` parses the output `fdisk` and relies on the
language being english, therefore the `LANG` variable in my `.envrc`. `kpartx` is also needed so
make sure it is installed

One can add `source $ROS2_HONE/setup.zsh` to `.envrc` to auto-source ROS2 distribution
