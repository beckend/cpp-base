cmake_minimum_required(VERSION 3.19.1)

set(PROJECT_NAME "App")
set(PROJECT_VERSION "0.1.0")
set(CMAKE_PREFIX_PATH "./")

if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
  set(
    CMAKE_TOOLCHAIN_FILE "./internals/core/vcpkg/scripts/buildsystems/vcpkg.cmake"
    CACHE STRING ""
  )
endif()

project(${PROJECT_NAME} VERSION ${PROJECT_VERSION})

file(GLOB_RECURSE fCApp ${PROJECT_SOURCE_DIR}/src/*.cpp)

add_executable(${PROJECT_NAME} ${fCApp})

include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeList-base-before.txt)
include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeList-base.txt)
include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeList-base-after.txt)
include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeList-vcpkg.txt)
