FROM ubuntu:16.04

MAINTAINER You Zhou <oezhouyou@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

# Create a development user
RUN useradd -ms /bin/bash dev && \
    echo "dev:dev" | chpasswd

# Setup home environment
RUN chown -R dev.dev /home/dev
RUN echo "dev ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
      make cmake build-essential git \
      libeigen3-dev \
      libflann-dev \
      libusb-1.0-0-dev \
      libvtk6-qt-dev \
      libpcap-dev \
      libboost-all-dev \
      libproj-dev \
      && rm -rf /var/lib/apt/lists/*

RUN \
    git config --global http.sslVerify false && \
    git clone --branch pcl-1.8.1 --depth 1 https://github.com/PointCloudLibrary/pcl.git pcl-trunk && \
    cd pcl-trunk && \
    mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j 1 && make install && \
    make clean

RUN ldconfig

# Define default command.
CMD ["/bin/bash"]

USER dev
