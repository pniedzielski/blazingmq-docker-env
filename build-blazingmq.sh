#!/bin/bash
set -euxo pipefail

cmake -S . -B build -G Ninja              \
    -DCMAKE_TOOLCHAIN_FILE=/usr/local/src/bde-tools/BdeBuildSystem/toolchains/linux/gcc-default.cmake \
    -DCMAKE_MODULE_PATH="." \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo     \
    -DBDE_BUILD_TARGET_SAFE=ON            \
    -DBDE_BUILD_TARGET_64=ON              \
    -DBDE_BUILD_TARGET_CPP17=ON           \
    -DCMAKE_PREFIX_PATH=/usr/local/src/bde-tools/BdeBuildSystem \
    -DCMAKE_INSTALL_PREFIX=/usr/local     \
    -DCMAKE_INSTALL_LIBDIR=lib            \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cd build
ninja all.t

