# ROS2 Image Pipeline Acceleration

## Build

1. Import repositories using *vcs*: 
```
vcs import < src/.repos
```

2. I needed to manually extend colcon:

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
colcon acceleration select kv260
colcon build --build-base=build-kv260 --install-base=install-kv260 --merge-install --mixin kv260 --packages-select ament_vitis vadd_publisher ament_acceleration
colcon acceleration linux vanilla --install-dir install-kv260


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


