FROM ubuntu:24.04

ARG RUNNER_VERSION=2.317.0
ENV DEBIAN_FRONTEND=noninteractive

LABEL Author="capafanwi"
LABEL Email="collins.afanwi@capgemini-gs.com"
LABEL GitHub="https://github.com/capafanwi/runners.git"
LABEL BaseImage="ubuntu:20.04"
LABEL RunnerVersion=${RUNNER_VERSION}

# Update the base packages and add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y && useradd -m docker

## install dependencies
RUN apt-get update && apt-get -y upgrade && apt-get install -y --no-install-recommends \
    apache2 \
    # awscli \
    build-essential \
    ca-certificates \
    checkinstall \
    cmake \
    cron \
    curl \
    dateutils \
    gdal-bin \
    gfortran \
    git-core \
    gnupg \
    gnupg2 \
    imagemagick \
    jq \
    libatlas-base-dev \
    libavcodec-dev \
    libavdevice-dev \
    libavfilter-dev \
    libavformat-dev \
    libavutil-dev \
    libboost-iostreams-dev \
    libboost-program-options-dev \
    libboost-serialization-dev \
    libboost-system-dev \
    libcgal-dev \
    libceres-dev \
    libeigen3-dev \
    libgflags-dev \
    libjpeg-dev \
    liblua5.3-dev \
    libopencv-dev \
    libopenblas0 \
    libpng-dev \
    libprotobuf-dev \
    libswresample-dev \
    libswscale-dev \
    libtiff-dev \
    locales \
    lsb-release \
    lua5.3 \
    mapnik-utils \
    mosquitto-clients \
    ninja-build \
    npm \
    openjdk-17-jre-headless \
    osm2pgsql \
    osmosis \
    osmium-tool \
    pkg-config \
    protobuf-compiler \
    python-is-python3 \
    python3-dev \
    python3-gdal \
    python3-lxml \
    python3-mapnik \
    python3-numpy \
    python3-pip \
    python3-psycopg2 \
    python3-pyproj \
    python3-scipy \
    python3-shapely \
    python3-yaml \
    renderd \
    sudo \
    tree \
    unzip \
    unrar \
    vim \
    wget \
    xz-utils \
    yasm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Download and setup GitHub Actions runner
RUN cd /home/docker && mkdir actions-runner && cd actions-runner && \
    curl -o actions-runner-linux-x64-2.317.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.317.0/actions-runner-linux-x64-2.317.0.tar.gz && \
    echo "9e883d210df8c6028aff475475a457d380353f9d01877d51cc01a17b2a91161d  actions-runner-linux-x64-2.317.0.tar.gz" | shasum -a 256 -c && \
    tar xzf ./actions-runner-linux-x64-2.317.0.tar.gz

# Install additional dependencies
RUN chown -R docker /home/docker && /home/docker/actions-runner/bin/installdependencies.sh

# Add and set up the start script
ADD runner-scripts/start.sh /home/docker/start.sh
RUN chmod +x /home/docker/start.sh

USER docker
ENTRYPOINT ["/home/docker/start.sh"]