#!/bin/bash

set -e
set -u
set -o pipefail

apt-get update && apt-get install -y --no-install-recommends \
    build-essential git cmake \
    wget python pkg-config software-properties-common \
    autoconf automake libtool ocaml \
    protobuf-compiler libprotobuf-dev \
    libssl-dev libcurl4-openssl-dev curl

git clone --branch=sgx_2.2 --depth=1 https://github.com/intel/linux-sgx.git
cd linux-sgx
curl -s -S -L 'https://gist.githubusercontent.com/nhynes/c770b0e91610f8c020a8d1a803a1e7cb/raw/8f5372d9cb88929b3cc49a384943bb363bc06827/intel-sgx.patch' | git apply
./download_prebuilt.sh
make -j4 sdk && make -j4 sdk_install_pkg
./linux/installer/bin/sgx_linux_x64_sdk*.bin --prefix /opt
cd -

tag=6098af # v1.0.5
git clone --branch=$tag --depth=1 https://github.com/baidu/rust-sgx-sdk.git /opt/rust-sgx-sdk
cd /opt/rust-sgx-sdk
curl -s -S -L 'https://gist.githubusercontent.com/nhynes/37164039c5d3f33aa4f123e4ba720036/raw/b0de575fe937231799930764e76c664b92975163/rust-sgx-sdk.diff' | git apply
cd -
