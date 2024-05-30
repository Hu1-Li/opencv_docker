# Start from base image
FROM lhrbest/kylinos:v10_sp3

# Download Miniconda installation script
RUN curl -o /tmp/Miniconda3-latest-Linux-x86_64.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

# Install Miniconda
RUN /bin/bash /tmp/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3 && \
    rm /tmp/Miniconda3-latest-Linux-x86_64.sh

# Setup conda
ENV PATH="/opt/miniconda3/bin:$PATH"
RUN conda init bash

# Set pip mirror
RUN mkdir -p /root/.pip && \
    echo -e "[global]\nindex-url = https://pypi.tuna.tsinghua.edu.cn/simple" > /root/.pip/pip.conf

# Set working directory
WORKDIR /app
