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


RUN pip install pyyaml

WORKDIR /root/

RUN git clone -b v2.1.0 --recurse-submodule https://github.com/pytorch/pytorch.git pytorch-static && mkdir /root/libtorch_build && cd /root/libtorch_build && cmake -DBUILD_SHARED_LIBS:BOOL=OFF -DFBGEMM_STATIC:BOOL=ON -DBUILD_CAFFE2_OPS=OFF -DUSE_SYSTEM_SLEEF=OFF -DBUILD_CAFFE2=OFF -DUSE_OPENMP:BOOL=ON -DUSE_CUDNN:BOOL=OFF -DBUILD_PYTHON:BOOL=OFF -DBUILD_TEST=OFF -DCMAKE_BUILD_TYPE:STRING=Release -DUSE_CUDA=OFF -DCMAKE_INSTALL_PREFIX:PATH=/root/libtorch -DNDEBUG -DUSE_GLOG=OFF -DUSE_DISTRIBUTED:BOOL=OFF -DCMAKE_CXX_FLAGS:STRING=-fPIC ../pytorch-static && cmake --build . --target install && mkdir -p /root/libtorch/xx && cp ./lib/*.a /root/libtorch/xx/


FROM ubuntu:22.04
COPY --from=builder /root/libtorch /root/libtorch

# LIBTORCH ENV
ENV LIBTORCH=/root/libtorch
ENV LIBTORCH_INCLUDE=/root/libtorch
ENV LD_LIBRARY_PATH=/root/libtorch/lib:$LD_LIBRARY_PATH

WORKDIR /root/code
COPY . .
