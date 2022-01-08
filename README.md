# ROS2 Image Pipeline Acceleration

## Build

1. Import repositories using *vcs*: 
```
vcs import < src/.repos
```

2. We need to manually extend colcon:

```
cd src/kria/colcon-acceleration
python setup.py build
python setup.py install --user
```

3. In the root of this repository, source ROS2 installation and build

```
source $ROS2_HONE/setup.zsh
colcon build --packages-ignore colcon-acceleration
```

## Usage notes

I used [*direnv*](https://direnv.net/) to setup environment variables. For installation and usage
follow the instructions there.
Next step is to modify environment variables defined in `.envrc` to match your system configuration,
and run `direnv allow`

Alternatively once could setup the same environment by `source .envrc`. Again, refer to *direnv*
documentation for advantages of using *direnv*



