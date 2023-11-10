# Build Stage
FROM ubuntu:22.04 AS builder
RUN set -xeu && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && \
    apt-get autoremove -y --purge && \
    apt-get -y autoclean

RUN set -xeu && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl clang libclang-dev libopencv-dev

RUN set -xeu && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile=minimal

ENV PATH="${PATH}:/root/.cargo/bin"
WORKDIR /root/rust/src/
COPY . .
RUN cargo build --release


# Bundle Stage
FROM ubuntu:22.04
WORKDIR /code
COPY --from=builder /root/rust/src/sample-mp4-file-small.mp4 /code/
COPY --from=builder /root/rust/src/target/release/test_opencv .
# RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y libgomp1 libopencv-dev clang libclang-dev && rm -rf /var/lib/apt/lists/*
# CMD ["./test_opencv"]
