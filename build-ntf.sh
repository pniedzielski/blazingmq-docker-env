#!/bin/bash
set -euxo pipefail

tag=2.4.2

# Download NTF
curl -SL \
     "https://github.com/bloomberg/ntf-core/archive/refs/tags/${tag}.tar.gz" \
    | tar xz
mv ntf-core-${tag} ntf-core

# Build and install to /usr/local
cd ntf-core
./configure \
    --keep \
    --prefix /usr/local \
    --without-usage-examples \
    --without-applications \
    --without-warnings-as-errors \
    --ufid opt_dbg_cpp17
make
make install
