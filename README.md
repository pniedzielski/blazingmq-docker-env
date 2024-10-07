# Local development environment for BlazingMQ

Although [BlazingMQ](https://github.com/bloomberg/blazingmq) itself is not too
hard to build, getting its dependencies BDE and NTF to play nicely is very,
very difficult.  The BlazingMQ repo provides a few example Dockerfiles, but
these are meant more to run the broker than to develop it; similarly, the repo
provides several build scripts, but making sure they work across all the
different platforms out there is a pain.

This repo provides a Docker Compose workflow for bringing up a Linux
development environment in which you can build and test the BlazingMQ broker,
BlazingMQ tools, and its three official SDKs.  These images support building on
amd64 and aarch64, something the official build scripts do not.

## Usage

``` shell
# Clone the code repositories (or your forks of them)
git clone https://github.com/bloomberg/blazingmq.git blazingmq
git clone https://github.com/bloomberg/blazingmq-sdk-java.git blazingmq-sdk-java
git clone https://github.com/bloomberg/blazingmq-sdk-python.git blazingmq-sdk-python
# Start a development environment.
docker-compose up
# Run a 3 node cluster.
#docker-compose --profile multi-node up  # Not yet implemented
```
