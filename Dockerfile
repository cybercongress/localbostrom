###########################################################################################
# Build cyber
###########################################################################################
FROM ubuntu:20.04

ENV GO_VERSION '1.22.2'
ENV GO_ARCH 'linux-amd64'
ENV GO_BIN_SHA '5901c52b7a78002aeff14a21f93e0f064f74ce1360fce51c6ee68cd471216a17'
ENV DEBIAN_FRONTEND=noninteractive 
ENV DAEMON_HOME /root/.cyber
ENV DAEMON_RESTART_AFTER_UPGRADE=true
ENV DAEMON_ALLOW_DOWNLOAD_BINARIES=false
ENV DAEMON_LOG_BUFFER_SIZE=1048
ENV UNSAFE_SKIP_BACKUP=true
ENV DAEMON_NAME cyber
ENV BUILD_DIR /build
ENV PATH /usr/local/go/bin:/root/.cargo/bin:/root/cargo/env:/root/.cyber/scripts:$PATH
ENV CUDA_VER '11.4.4-1'
ENV PATH="/usr/local/go/bin:/usr/local/cuda/bin:$PATH"


# Install go and required deps
###########################################################################################
RUN apt-get update && apt-get install -y --no-install-recommends wget ca-certificates \
&& wget -O go.tgz https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz \
&& echo "${GO_BIN_SHA} *go.tgz" | sha256sum -c - \
&& tar -C /usr/local -xzf go.tgz \
&& rm go.tgz \
&& go version 


COPY . /sources
WORKDIR /sources

# Install build tools and compile cyber without cpu
###########################################################################################
RUN apt-get -y install --no-install-recommends \
    make gcc g++ \
    curl \
    gnupg \
    git \
    software-properties-common \
# Compile cyber for localnet genesis. Set git checkout to desired version of go-cyber
###########################################################################################
&& mkdir -p /cyber/cosmovisor/genesis/bin \
&& cd /sources \
&& git clone https://github.com/cybercongress/go-cyber.git \
&& cd go-cyber \
&& git checkout v4.0.0-rc1 \
&& make build CUDA_ENABLED=false \
&& cp ./build/cyber /cyber/cosmovisor/genesis/bin/ \
&& cp ./build/cyber /usr/local/bin \ 
&& rm -rf ./build \
# Cleanup 
###########################################################################################
&& apt-get purge -y git \
    make \
    gcc g++ \
    curl \
    gnupg \
    python3.8 \
&& go clean --cache -i \
&& apt-get autoremove -y \
&& apt-get clean \
&& cd / \
&& rm -rf /sources/go-cyber/ 

# Install cosmovisor
###########################################################################################
RUN wget -O cosmovisor.tgz https://github.com/cosmos/cosmos-sdk/releases/download/cosmovisor%2Fv1.5.0/cosmovisor-v1.5.0-linux-amd64.tar.gz \
&& tar -xzf cosmovisor.tgz \
&& cp cosmovisor /usr/bin/cosmovisor \
&& chmod +x /usr/bin/cosmovisor \
&& rm cosmovisor.tgz && rm -fR $BUILD_DIR/* && rm -fR $BUILD_DIR/.*[a-z]

# Copy startup scripts and genesis
###########################################################################################
WORKDIR /
COPY start_script.sh start_script.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x start_script.sh \
&& chmod +x /entrypoint.sh \
&& cyber version


#  Start
###############################################################################
EXPOSE 26656 26657 1317 9090 26660
ENTRYPOINT ["/entrypoint.sh"]
CMD ["./start_script.sh"]
