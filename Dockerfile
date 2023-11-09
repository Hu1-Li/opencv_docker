# Build Stage
FROM deltat/tch:latest AS builder
RUN curl -s https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-2.0.0%2Bcpu.zip -o libtorch.zip
RUN unzip -o -qq libtorch.zip
ENV LIBTORCH /root/rust/src/libtorch
ENV LD_LIBRARY_PATH /root/rust/src/libtorch/lib:$LD_LIBRARY_PATH
ADD --chown=rust:rust . ./
RUN cargo build --release

# Bundle Stage
FROM scratch
WORKDIR /code
COPY --from=builder /root/rust/src/target/release/test_tch .
COPY --from=builder /root/rust/src/libtorch .
ENV LIBTORCH /code/libtorch
ENV LD_LIBRARY_PATH /code/libtorch/lib:$LD_LIBRARY_PATH
CMD ["./test_tch"]

