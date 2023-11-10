# Build Stage
FROM ubuntu:22.04 AS builder
RUN set -xeu && apt-get update && apt-get install -y curl && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile=minimal
ENV PATH="${PATH}:/root/.cargo/bin"
WORKDIR /code/
COPY . .
RUN curl -s https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-2.0.0%2Bcpu.zip -o libtorch.zip
RUN unzip -o -qq libtorch.zip
ENV LIBTORCH /code/libtorch
ENV LIBTORCH_INCLUDE /code/libtorch
ENV LD_LIBRARY_PATH /code/libtorch/lib:$LD_LIBRARY_PATH
RUN cargo build --release

# Bundle Stage
FROM ubuntu:22.04
WORKDIR /code
COPY --from=builder /code/target/release/test_tch .
COPY --from=builder /code/libtorch /code/libtorch
ENV LIBTORCH /code/libtorch/
ENV LD_LIBRARY_PATH /code/libtorch/lib:$LD_LIBRARY_PATH
RUN apt-get update && apt-get install -y libgomp1 && rm -rf /var/lib/apt/lists/*
CMD ["./test_tch"]

