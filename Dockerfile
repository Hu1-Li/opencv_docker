# Build Stage
FROM deltat/rust:static-libtorch AS builder1
RUN cp /root/libtorch/xx/libonnx.a /root/libtorch/lib/ && cp /root/libtorch/xx/libonnx_proto.a /root/libtorch/lib/ && rm -rf /root/libtorch/xx
FROM deltat/rust:opencv-static AS builder2


FROM ubuntu:22.04
COPY --from=builder1 /root/libtorch /root/libtorch
COPY --from=builder2 /root/opencv4 /root/opencv4

# LIBTORCH ENV
ENV LIBTORCH=/root/libtorch
ENV LIBTORCH_INCLUDE=/root/libtorch
ENV LD_LIBRARY_PATH=/root/libtorch/lib:$LD_LIBRARY_PATH

# OPENCV ENV
ENV OPENCV_INCLUDE_PATHS=/root/opencv4/include/opencv4
ENV OPENCV_LINK_PATHS=/root/opencv4/lib,/root/opencv4/lib/opencv4/3rdparty,/usr/lib/x86_64-linux-gnu
ENV OPENCV_LINK_LIBS=opencv_objdetect,opencv_calib3d,opencv_features2d,opencv_stitching,opencv_flann,opencv_videoio,opencv_video,opencv_imgcodecs,opencv_imgproc,opencv_core,liblibwebp,liblibtiff,liblibjpeg-turbo,liblibpng,liblibopenjp2,zlib,ippiw,ippicv,ittnotify,avcodec,avformat,swscale,avutil

WORKDIR /root/code
