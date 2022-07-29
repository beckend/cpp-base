<!-- https://crates.io/crates/mask -->
<!-- https://github.com/jacobdeichert/mask -->
# Tasks For My Project


<!-- A heading defines the command's name -->
## prepare

<!-- A blockquote defines the command's description -->
> prepare depdendencies

<!-- A code block defines the script to be executed -->
~~~bash
git submodule update --init --recursive

# make sure vcpkg is downloaded and binary can be used
# a link in ./bin/vcpkg will be available when this after script runs
if [[ ! -f "./internals/core/vcpkg/vcpkg" ]]; then
  ./internals/core/vcpkg/bootstrap-vcpkg.sh
fi
~~~


## build:production
> build project
~~~bash
cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_TOOLCHAIN_FILE:STRING=./internals/core/vcpkg/scripts/buildsystems/vcpkg.cmake \
  -G Ninja \
  -S./ \
  -B./build
cmake --build build -j$(nproc --all) --config Release
~~~

## build:dev
> build project
~~~bash
cmake \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_TOOLCHAIN_FILE:STRING=./internals/core/vcpkg/scripts/buildsystems/vcpkg.cmake \
  -G Ninja \
  -S./ \
  -B./build
cmake --build build -j$(nproc --all) --config Debug
~~~

## build:clean
> clean build
~~~bash
cmake --build build -j$(nproc --all) --target clean
~~~


## clean:project
> clean project
~~~bash
rm -rf ./build || true;
git submodule foreach --recursive git reset --hard
git submodule foreach --recursive git clean -xfd
git submodule update --init --recursive
$MASK prepare
~~~
