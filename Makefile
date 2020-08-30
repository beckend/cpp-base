C := /opt/cuda/bin/gcc
CC := /opt/cuda/bin/gcc
CXX := /opt/cuda/bin/g++

include ./Makefile.custom.before.mk

DIR_BUILD := ./build

COUNT_CORES := 8
CFLAGS := -march=native -O2 -pipe -fno-plt -std=c++20

ifeq ($(CC), clang)
    CFLAGS := $(CFLAGS) -fcoroutines-ts
endif

ifeq ($(CXX), clang++)
    CFLAGS_DEBUG := -g
else
    CFLAGS_DEBUG := -g -fvar-tracking-assignments -std=c++20
endif

CXXFLAGS := $(CFLAGS)
MAKEFLAGS := -j$(COUNT_CORES)

ENV_BASE_COMPILE := CC="$(CC)" CXX="$(CXX)" CFLAGS="$(CFLAGS)" CXXFLAGS="$(CXXFLAGS)" MAKEFLAGS="$(MAKEFLAGS)"
ENV_BASE_COMPILE_VCPKG := VCPKG_FEATURE_FLAGS="binarycaching,manifests" VCPKG_CXX_FLAGS="$(CXXFLAGS)" VCPKG_MANIFEST_INSTALL="ON" $(ENV_BASE_COMPILE)

CMD_BASE_WATCHMAN_MAKE := watchman-make -p 'src/**/*.cpp' 'src/**/*.h'
CMD_BASE_CMAKE := CC="$(CC)" CXX="$(CXX)" cmake
OPTIONS_CMAKE_BUILD := --build $(DIR_BUILD) --target all -j $(COUNT_CORES) -v
OPTIONS_CMAKE_BUILD_POST =
TASKS_INIT := init-submodules init-cmake
TASKS_INIT_DEBUG := init-submodules init-cmake-debug

define CMAKE_OPTIONS_BASE
-GNinja \
-DUSE_CCACHE=YES \
-DCMAKE_TOOLCHAIN_FILE="./internals/core/vcpkg/scripts/buildsystems/vcpkg.cmake" \
-DCMAKE_C_FLAGS_RELEASE="$(CFLAGS)" \
-DCMAKE_CC_FLAGS_RELEASE="$(CFLAGS)" \
-DCMAKE_CXX_FLAGS_RELEASE="$(CFLAGS)" \
-DCMAKE_C_FLAGS_DDEBUG="$(CFLAGS_DEBUG)" \
-DCMAKE_CC_FLAGS_DDEBUG="$(CFLAGS_DEBUG)" \
-DCMAKE_CXX_FLAGS_DDEBUG="$(CFLAGS_DEBUG)" \
-S ./ \
-B $(DIR_BUILD)
endef

ifeq ($(shell test -f "./Makefile.custom.after.mk" && echo -n yes), yes)
    include ./Makefile.custom.after.mk
endif

default: init

debug-cmake:
	echo $(C) $(CC) $(CXX)

init-submodules:
ifeq ($(shell test ! -d "./internals/core/vcpkg/docs" && echo -n yes), yes)
	git submodule update --init --recursive
endif

define target_cmd_init_build =
	@mkdir -p $(DIR_BUILD) 
	@echo 'Created dir "$(DIR_BUILD)".'
endef
init-build:
ifeq ($(shell test ! -d $(DIR_BUILD) && echo -n yes), yes)
	$(call target_cmd_init_build)
endif

init-cmake: task-vcpkg-install-packages init-build
	@$(CMD_BASE_CMAKE) -D CMAKE_BUILD_TYPE=Release $(CMAKE_OPTIONS_BASE)

# this Ddebug is not a typo, the vcpkg.cmake has this weird regex check
init-cmake-debug: task-vcpkg-install-packages init-build
	@$(CMD_BASE_CMAKE) -D CMAKE_BUILD_TYPE=Ddebug $(CMAKE_OPTIONS_BASE)

init: $(TASKS_INIT)

init-debug: $(TASKS_INIT_DEBUG)

define target_cmd_task_vcpkg_install =
	@echo "Installing vcpkg..."
	bash ./internals/core/scripts/vcpkg-install.sh linkCustomPorts
	$(ENV_BASE_COMPILE_VCPKG) ./internals/core/vcpkg/bootstrap-vcpkg.sh -useSystemBinaries -allowAppleClang
endef
task-vcpkg-install:
ifeq ($(shell test ! -f "./internals/core/vcpkg/vcpkg" && echo -n yes), yes)
	$(call target_cmd_task_vcpkg_install)
endif

define target_cmd_task_vcpkg_install_packages =
	@echo "Installing vcpkg packages..."
	$(ENV_BASE_COMPILE_VCPKG) bash ./internals/core/scripts/vcpkg-install.sh
endef
task-vcpkg-install-packages: task-vcpkg-install
	$(call target_cmd_task_vcpkg_install_packages)

release: init
	$(CMD_BASE_CMAKE) $(OPTIONS_CMAKE_BUILD) --config Release $(OPTIONS_CMAKE_BUILD_POST)

release-watch:
	$(CMD_BASE_WATCHMAN_MAKE) --run "$(CMD_BASE_CMAKE) $(OPTIONS_CMAKE_BUILD) --config Release $(OPTIONS_CMAKE_BUILD_POST)"

update: init-submodules
	git submodule foreach git pull --no-rebase

debug: init-debug
	$(CMD_BASE_CMAKE) $(OPTIONS_CMAKE_BUILD) --config Debug $(OPTIONS_CMAKE_BUILD_POST)

debug-watch:
	$(CMD_BASE_WATCHMAN_MAKE) --run "$(CMD_BASE_CMAKE) $(OPTIONS_CMAKE_BUILD) --config Debug $(OPTIONS_CMAKE_BUILD_POST)"

synchronize-base:
	bash ./internals/core/scripts/update-base.sh

define target_cmd_clean =
	@$(RM) -fr $(DIR_BUILD)
	@echo 'Removed dir "$(DIR_BUILD)"'
	git submodule foreach --recursive git reset --hard
	git submodule foreach --recursive git clean -xfd
	git submodule update --init --recursive
endef
clean:
ifeq ($(shell test -d $(DIR_BUILD) && echo -n yes), yes)
	$(call target_cmd_clean)
endif

.PHONY: init $(TASKS_INIT) clean
