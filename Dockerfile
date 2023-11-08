# Build Stage
FROM ekidd/rust-musl-builder:stable AS builder
WORKDIR /code
COPY . .
RUN apt-get update && apt-get install -y unzip wget
RUN wget -q https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-2.0.0%2Bcpu.zip -O libtorch.zip
RUN unzip -o -qq libtorch.zip
ENV LIBTORCH /code/libtorch
ENV LD_LIBRARY_PATH /code/libtorch/lib:$LD_LIBRARY_PATH
ADD --chown=rust:rust . ./
RUN cargo build --release

# Bundle Stage
FROM scratch
WORKDIR /code
COPY --from=builder /code/target/release/test_tch .
COPY --from=builder /code/libtorch .
ENV LIBTORCH /code/libtorch
ENV LD_LIBRARY_PATH /code/libtorch/lib:$LD_LIBRARY_PATH
CMD ["./test_tch"]

