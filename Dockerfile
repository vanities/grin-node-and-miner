FROM ubuntu:16.04

# 32-bit support for AMD drivers
RUN dpkg --add-architecture i386

RUN set -ex && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get --no-install-recommends --yes install \
    clang \
    libclang-dev \
    llvm-dev \
    libncurses5 \
    libncursesw5 \
    cmake \
    git \
    ca-certificates \
    openssl \
    curl \
    libssl-dev \
    pkg-config \
    locales \
    libncurses5-dev \
    libncursesw5-dev \
    ocl-icd-opencl-dev \
    wget \
    build-essential \
    libhwloc-dev

ENV LLVM_BIN=/opt/amdgpu-pro/bin
ENV AMDAPPSDKROOT=/opt/amdgpu-pro/

# AMD drivers
RUN wget --referer=http://support.amd.com https://www2.ati.com/drivers/linux/ubuntu/amdgpu-pro-17.40-492261.tar.xz \
    && tar -xJvf amdgpu-pro-*.tar.xz && cd amdgpu-pro-17.40-492261/ && ./amdgpu-pro-install --compute --px -y 

RUN ln -s /usr/lib/x86_64-linux-gnu/libOpenCL.so.1 /usr/lib/libOpenCL.so

RUN apt install rocm-amdgpu-pro \
                clinfo -y

RUN wget https://github.com/mimblewimble/grin-miner/releases/download/v1.0.0/grin-miner-v1.0.0-479967147-linux-amd64.tgz && tar xvf grin-miner-v1.0.0-479967147-linux-amd64.tgz && mv grin-miner-v1.0.0 grin-miner
