FROM ubuntu:16.04

# 32-bit support for AMD drivers
RUN dpkg --add-architecture i386

RUN set -ex && \
    apt-get update && \
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
    wget

ENV AMDAPPSDKROOT=/opt/amdgpu-pro/

# AMD drivers
RUN wget --referer=http://support.amd.com https://www2.ati.com/drivers/linux/ubuntu/amdgpu-pro-17.40-492261.tar.xz \
    && tar -xJvf amdgpu-pro-*.tar.xz && cd amdgpu-pro-17.40-492261/ && ./amdgpu-pro-install -y 

RUN ln -s /usr/lib/x86_64-linux-gnu/libOpenCL.so.1 /usr/lib/libOpenCL.so

RUN apt install rocm-amdgpu-pro \
                clinfo -y

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

RUN git clone https://github.com/mimblewimble/grin.git && \
              cd grin && \
              ~/.cargo/bin/cargo build --release && \
              cd ..


RUN git clone https://github.com/mimblewimble/grin-miner.git && \
              cd grin-miner && \
              git submodule update --init && \
              ~/.cargo/bin/cargo build --features opencl


RUN cd /grin/target/release && \
    ./grin --floonet server config && \
    sed -i -e 's/enable_stratum_server = false/enable_stratum_server = true/' grin-server.toml && \
    sed -i -e 's/run_tui = true/run_tui = false/' grin-server.toml && \
    echo "password\npassword" | ./grin --floonet wallet init

RUN cd /grin-miner && \
    cp grin-miner.toml target/debug/grin-miner.toml && \
    sed -i -e 's/run_tui = true/run_tui = false/' target/debug/grin-miner.toml && \
    sed -i -e 's/stratum_server_addr = "127.0.0.1:13416"/stratum_server_addr = "us-east-stratum.grinmint.com:4416"/' target/debug/grin-miner.toml && \
    sed -i -e 's/#stratum_server_password = "x"/stratum_server_password = "some-password"/' target/debug/grin-miner.toml && \
    sed -i -e 's/stratum_server_tls_enabled = false/stratum_server_tls_enabled = true/' target/debug/grin-miner.toml && \
    sed -i -e 's/#stratum_server_login = "http:\/\/192.168.1.100:13415"/stratum_server_login = "mischkeaa+someuser@gmail.com\/vanities"/' target/debug/grin-miner.toml


RUN cd /grin-miner/ocl_cuckaroo/ && ~/.cargo/bin/cargo build --release && \
    cp /grin-miner/target/release/libocl_cuckaroo.so /grin-miner/target/debug/plugins/libocl_cuckaroo.cuckooplugin
