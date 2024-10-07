#!/bin/bash
set -euxo pipefail

bde_tag=4.14.0.0
bde_tools_tag=4.8.0.0

# Download BDE
curl -SL \
     "https://github.com/bloomberg/bde/archive/refs/tags/${bde_tag}.tar.gz" \
    | tar xz
mv bde-${bde_tag} bde

# Download bde-tools for build system
curl -SL \
     "https://github.com/bloomberg/bde-tools/archive/refs/tags/${bde_tools_tag}.tar.gz" \
    | tar xz
mv bde-tools-${bde_tools_tag} bde-tools

# Configure build system with bde-tools, RelWithDebInfo (`opt_dbg`).
export PATH="$PATH:$(realpath bde-tools/bin)"
eval "$(bbs_build_env -b bde/build -u opt_dbg_cpp17 -i /usr/local)"

# Override toolchain file, which incorrectly hard-codes Linux as a x86/AMD64
# platform.
mv cmake-toolchains/gcc-default.cmake \
   bde-tools/BdeBuildSystem/toolchains/linux/gcc-default.cmake
mv cmake-toolchains/gcc-bde-presets.cmake \
   bde-tools/BdeBuildSystem/toolchains/linux/gcc-bde-presets.cmake

# Build and install to /usr/local
cd bde
bbs_build configure --prefix=/usr/local
bbs_build build -j 10
bbs_build install --install_dir="/" --prefix=/usr/local
