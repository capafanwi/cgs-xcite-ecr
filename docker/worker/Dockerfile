# When running from linux,git bash or equivelent nix command line
# Set up an ssh config that has this included (~/.ssh/config, use your own username):
#
# Host github.com-bgu
#     Hostname github.com
#     IdentityFile=/home/username/.ssh/id_deploy_bgu
# Host github.com-baw
#     Hostname github.com
#     IdentityFile=/home/username/.ssh/id_deploy_baw
#
# Make sure you have all the above id_deploy* private keys also in ~/.ssh
# Run the build like this (note the change in context):
# docker build -f Dockerfile -t worker ~/.ssh
#
#Run the docker image and mount like a folder like this:
# docker run --mount type=bind,source="/data/folder/Waxhaw_testing",target=/Waxhaw_testing -it worker /bin/bash
FROM ubuntu:22.04 as intermediate

ARG BDA_GPX_UTILS_TAG=2.2.0
ARG BDA_ARGO_WORKFLOWS_TAG=develop
ARG DEBIAN_FRONTEND=noninteractive #needed to avoid interactive displays when apt installing certain packages

# install git
RUN apt-get update && apt-get -y install \
    git \
    wget \
    xz-utils \
    libavdevice-dev \
    libavfilter-dev \
    libavformat-dev \
    libavcodec-dev \
    libswresample-dev \
    libswscale-dev \
    libavutil-dev \
    cmake \
    pkgconf \
    git \
    gcc \
    g++ \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# add credentials on build
RUN mkdir /root/.ssh
COPY /id_deploy* /root/.ssh
COPY /config /root/.ssh
RUN sed -i 's^/home/[a-z]*/^/root/^g' /root/.ssh/config
RUN chmod 600 /root/.ssh/*

# make sure your domain is accepted
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN git clone https://github.com/juanmcasillas/gopro2gpx.git
RUN cd gopro2gpx && git checkout dff353a

RUN wget https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-5.1.1-amd64-static.tar.xz
RUN tar xvf ffmpeg-5.1.1-amd64-static.tar.xz

#Use the command below to checkout a given branch
#  increment the echo when you want to pull an update to the branch otherwise you will get the docker cache
RUN echo '0' >/dev/null && git clone --branch ${BDA_ARGO_WORKFLOWS_TAG} git@github.com-baw:/capbancroft/bda-argo-workflows.git

# Install GoPro Parser
WORKDIR /
RUN git clone https://github.com/gopro/gpmf-parser && \
    cd gpmf-parser && git checkout 2678feb && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make install

WORKDIR /
# Build and install our extraction
RUN echo '0' >/dev/null && git clone --branch ${BDA_GPX_UTILS_TAG} git@github.com-bgu:/capbancroft/bda-gpx-utils.git
WORKDIR /bda-gpx-utils/gpmf-extraction/app
RUN mkdir build && \
    cd build && \
    cmake .. && \
    make
    
FROM ubuntu:22.04

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get -y install \
    awscli \
    curl \
    python3.9 \
    python3-setuptools \
    tzdata \
    unzip \
    jq \
    pip \
    mosquitto-clients \
    tree \
    libavcodec58 \
    libavformat58 \
    libavutil56 \
    libswscale5 \
    gdal-bin \
    python3-gdal \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# setup ffmpeg v5 ffprobe for gopro2gpx to work
COPY --from=intermediate /ffmpeg-5.1.1-amd64-static/ffprobe /usr/local/bin/ffprobe
COPY --from=intermediate /ffmpeg-5.1.1-amd64-static/ffmpeg /usr/local/bin/ffmpeg

COPY --from=intermediate /gopro2gpx /src/gopro2gpx
WORKDIR /src/gopro2gpx
RUN python3 setup.py install

# GPX simplification
RUN pip install numpy pyproj gpx-cmd-tools 

COPY --from=intermediate /bda-argo-workflows/tools /src/bda-argo-workflows/tools
RUN chmod +x /src/bda-argo-workflows/tools/*.sh

COPY --from=intermediate /bda-gpx-utils /src/bda-gpx-utils
COPY --from=intermediate /bda-gpx-utils/gpmf-extraction/app/build/bda-gopro /usr/local/bin/

WORKDIR /src/bda-gpx-utils
RUN pip3 install -r requirements.txt

WORKDIR /tmp
