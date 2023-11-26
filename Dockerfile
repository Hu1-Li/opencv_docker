# Build Stage
FROM ubuntu:22.04 AS builder
RUN set -xeu && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && \
    apt-get autoremove -y --purge && \
    apt-get -y autoclean

RUN set -xeu && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl \
        clang \
        libclang-dev \
        wget \
        unzip \
        build-essential \
        cmake \
        git \
        yasm \
        pkg-config \
        python3 \
        python3-pip \
        libgomp1 \
        libmkl-dev

RUN set -xeu && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile=minimal

ENV PATH="${PATH}:/root/.cargo/bin"

RUN pip install pyyaml mkl-devel

WORKDIR /root/

RUN git clone -b v2.1.0 --recurse-submodule https://github.com/pytorch/pytorch.git pytorch-static --depth 1 && mkdir /root/libtorch_build && cd /root/libtorch_build && cmake -DBUILD_SHARED_LIBS:BOOL=OFF -DBUILD_CAFFE2_OPS:BOOL=OFF -DBUILD_CAFFE2:BOOL=OFF -DUSE_OPENMP:BOOL=ON -DUSE_CUDNN:BOOL=OFF -DBUILD_PYTHON:BOOL=OFF -DBUILD_TEST:BOOL=OFF -DCMAKE_BUILD_TYPE:STRING=Release -DUSE_CUDA:BOOL=OFF -DCMAKE_INSTALL_PREFIX:PATH=/root/libtorch -DUSE_DISTRIBUTED:BOOL=OFF /root/pytorch-static -DCMAKE_CXX_FLAGS:STRING=-fPIC -D_GLIBCXX_USE_CXX11_ABI=1 -DFBGEMM_STATIC=1 && cmake --build . --target install --parallel

WORKDIR /root/code
COPY . .
