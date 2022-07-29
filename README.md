# C++ boilerplate
- Has CMakeList-base.txt for non repetition.
- Uses ccache.
- Has vcpkg installed


### vcpkg
- use manifest mode: https://github.com/microsoft/vcpkg/blob/master/docs/users/manifests.md
- binary is in `./bin/vcpkg` after running `mask prepare`


### Usage
- mask read maskfile.md
- `mask prepare` - prepares depdendencies
- `mask build:production` - builds project
