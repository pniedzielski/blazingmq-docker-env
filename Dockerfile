###############################################################################
##                                BASE IMAGE                                 ##
##                                                                           ##
## System-wide development utilities and dependencies, like `gdb`, `cmake`   ##
## and `ninja`.                                                              ##
###############################################################################
FROM docker.io/ubuntu:24.04 AS base

# Set up CA certificates first before installing other dependencies
RUN apt-get update                                \
    && apt-get install -y ca-certificates         \
    && apt-get install -y --no-install-recommends \
        build-essential                           \
        clangd                                    \
        gdb                                       \
        cmake                                     \
        curl                                      \
        python3                                   \
        ninja-build                               \
        pkg-config                                \
        bison                                     \
        libfl-dev                                 \
        libbenchmark-dev                          \
        libgmock-dev                              \
    libz-dev                                      \
    && apt clean

# Compel BDE to live harmoniously with the rest of the world.
RUN ln -s /usr/local/lib /usr/local/lib64

###############################################################################
##                                 BDE IMAGE                                 ##
##                                                                           ##
## Downloads BDE to `/usr/local/src/bde/`, builds it in RelWithDebInfo mode, ##
## and installs its artifacts to `/usr/local`.                               ##
###############################################################################
FROM base AS bde

WORKDIR /usr/local/src

COPY build-bde.sh ./build-bde.sh
COPY gcc-default.cmake ./cmake-toolchains/gcc-default.cmake
COPY gcc-bde-presets.cmake ./cmake-toolchains/gcc-bde-presets.cmake

RUN ./build-bde.sh

###############################################################################
##                                 NTF IMAGE                                 ##
##                                                                           ##
## Downloads NTF to `/usr/local/src/ntf-core-TAG/`, builds it in             ##
## RelWithDebInfo mode, and installs its artifacts to `/usr/local`.          ##
###############################################################################
FROM bde AS ntf

WORKDIR /usr/local/src

COPY build-ntf.sh ./build-ntf.sh
RUN ./build-ntf.sh

###############################################################################
##                              BLAZINGMQ IMAGE                              ##
##                                                                           ##
## Copies local BlazingMQ source tree to `/root/blazingmq`.                      ##
###############################################################################
FROM ntf AS blazingmq

VOLUME /root/blazingmq

WORKDIR /root/

COPY build-blazingmq.sh ./build-blazingmq.sh

CMD /bin/bash
