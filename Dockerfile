# builder stage
FROM rust:1.31 as builder

RUN set -ex && \
    apt-get update && \
    apt-get --no-install-recommends --yes install \
    clang \
    libclang-dev \
    llvm-dev \
    libncurses5 \
    libncursesw5 \
    cmake \
    git


RUN git clone https://github.com/mimblewimble/grin.git && \
              cd grin && \
              cargo build --release && \
              cd ..


RUN git clone https://github.com/mimblewimble/grin-miner.git && \
              cd grin-miner && \
              git submodule update --init && \
              cargo build

WORKDIR /grin/target/release

RUN ./grin --floonet server config && \
    sed -i -e 's/enable_stratum_server = false/enable_stratum_server = true/' grin-server.toml && \
    sed -i -e 's/run_tui = true/run_tui = false/' grin-server.toml && \
    echo "password\npassword" | ./grin --floonet wallet init
