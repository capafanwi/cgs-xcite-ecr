FROM ubuntu:22.04 AS compiler-common

# Based on
# https://switch2osm.org/serving-tiles/manually-building-a-tile-server-18-04-lts/
ENV DEBIAN_FRONTEND=noninteractive
ENV AUTOVACUUM=on
ENV UPDATES=disabled
ENV PG_VERSION 15
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Get packages
RUN apt-get update \
&& apt-get -y upgrade \
&& apt-get install -y --no-install-recommends \
 ca-certificates gnupg lsb-release locales \
 wget curl \
 git-core unzip unrar \
 apache2 \
 cron \
 dateutils \
 gnupg2 \
 gdal-bin \
 liblua5.3-dev \
 lua5.3 \
 mapnik-utils \
 npm \
 osm2pgsql \
 osmium-tool \
 osmosis \
 python-is-python3 \
 python3-mapnik \
 python3-lxml \
 python3-psycopg2 \
 python3-shapely \
 python3-pip \
 renderd \
 sudo \
 vim \
 awscli \
&& locale-gen $LANG && update-locale LANG=$LANG \
&& apt-get clean autoclean \
&& apt-get autoremove --yes \
&& rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install python libraries
RUN pip3 install \
 requests \
 osmium \
 pyyaml

RUN wget https://github.com/openstreetmap/osmosis/releases/download/0.49.2/osmosis-0.49.2.tar \
  && tar -xvf osmosis-0.49.2.tar \
  && cd osmosis-0.49.2/ \
  && sudo apt install openjdk-17-jre-headless \
  && chmod a+x bin/osmosis \
  ;
