# Build Stage
FROM rust AS builder

# Set the working directory in the container
WORKDIR /code

# Copy the current directory contents into the container
COPY . .

# Install OpenCV dependencies
RUN apt-get update && apt-get install -y libopencv-dev clang libclang-dev

# Build the Rust application
RUN cargo build --release

# Run the application
CMD ["cargo", "run"]
