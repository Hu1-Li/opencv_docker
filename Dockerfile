# Build Stage
FROM rust AS builder
WORKDIR /root/rust/src/
COPY . .
RUN curl -s https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-2.0.0%2Bcpu.zip -o libtorch.zip
RUN unzip -o -qq libtorch.zip
ENV LIBTORCH /root/rust/src/libtorch
ENV LIBTORCH_INCLUDE /root/rust/src/libtorch
ENV LD_LIBRARY_PATH /root/rust/src/libtorch/lib:$LD_LIBRARY_PATH
RUN cargo build --release

# Bundle Stage
FROM ubuntu
WORKDIR /code
COPY --from=builder /root/rust/src/target/release/test_tch .
COPY --from=builder /root/rust/src/libtorch /code/libtorch
ENV LIBTORCH /code/libtorch/
ENV LD_LIBRARY_PATH /code/libtorch/lib:$LD_LIBRARY_PATH
RUN apt-get update && apt-get install -y libgomp1 && rm -rf /var/lib/apt/lists/*
CMD ["./test_tch"]

