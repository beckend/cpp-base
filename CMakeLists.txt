cmake_minimum_required(VERSION 3.23.3)

if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
  message(STATUS "This project is a top-level one")
else()
  message(STATUS "This project has a top-level one called [${CMAKE_PROJECT_NAME}]")
  set(PROJECT_NAME "app")
  set(PROJECT_VERSION "0.1.0")
  set(CMAKE_PREFIX_PATH "./")
endif()

if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
  set(
    CMAKE_TOOLCHAIN_FILE "./internals/core/vcpkg/scripts/buildsystems/vcpkg.cmake"
    CACHE STRING "vcpkg toolchain file"
  )
endif()

project(${PROJECT_NAME} VERSION ${PROJECT_VERSION})

file(GLOB_RECURSE fCApp ${PROJECT_SOURCE_DIR}/src/*.cpp)

option(BUILD_SHARED_LIBS "Build shared library" ON)
option(BUILD_STATIC_LIBS "Build static library" ON)

if(BUILD_SHARED_LIBS)
endif()

if(BUILD_STATIC_LIBS)
endif()

# if lib
add_library(${PROJECT_NAME} OBJECT ${fCApp})

# add_library(${PROJECT_NAME} STATIC $<TARGET_OBJECTS:app>)

# if binary
# add_executable(${PROJECT_NAME} ${fCApp})
include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeList-base-before.txt)
include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeList-base.txt)
include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeList-base-after.txt)
include(${CMAKE_CURRENT_SOURCE_DIR}/CMakeList-vcpkg.txt)
