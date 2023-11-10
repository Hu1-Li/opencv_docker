# Build Stage
FROM rust AS builder
WORKDIR /root/rust/src/
COPY . .
RUN apt-get update && apt-get install -y libopencv-dev clang libclang-dev
RUN cargo build --release


# Bundle Stage
FROM ubuntu:22.04
WORKDIR /code
COPY --from=builder /root/rust/src/sample-mp4-file-small.mp4 /code/
COPY --from=builder /root/rust/src/target/release/test_opencv .
RUN apt-get update && apt-get install -y libgomp1 libopencv-dev clang libclang-dev && rm -rf /var/lib/apt/lists/*
CMD ["./test_opencv"]
