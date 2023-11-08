# Use an official Rust runtime as a parent image
FROM rust:bullseye as builder

WORKDIR /code

COPY . .

RUN apt-get update && apt-get install -y unzip wget && rm -rf /var/lib/apt/lists/*
RUN wget -q https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-2.0.0%2Bcpu.zip -O libtorch.zip
RUN unzip -o -qq libtorch.zip
ENV LIBTORCH /code/libtorch
ENV LD_LIBRARY_PATH /code/libtorch/lib:$LD_LIBRARY_PATH

RUN cargo build --release && cp /code/target/release/test_tch . && rm -rf /code/target
