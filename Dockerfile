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
        libgomp1

RUN set -xeu && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile=minimal

ENV PATH="${PATH}:/root/.cargo/bin"

RUN pip install pyyaml

WORKDIR /root/

RUN git clone -b v2.1.0 --recurse-submodule https://github.com/pytorch/pytorch.git pytorch-static --depth 1 && cd pytorch-static && USE_ROCM=OFF USE_OPENMP=ON BUILD_TYPE=Release USE_CUDNN=OFF BUILD_PYTHON=OFF BUILD_TEST=OFF USE_CUDA=OFF BUILD_SHARED_LIBS=OFF python3 setup.py build
