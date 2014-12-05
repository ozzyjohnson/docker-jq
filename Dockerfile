FROM debian:wheezy

MAINTAINER Ozzy Johnson <docker@ozzy.io>

ENV DEBIAN_FRONTEND noninteractive

ENV BISON_VERSION 3.0.2
ENV BISON_PACKAGE http://ftpmirror.gnu.org/bison/bison-$BISON_VERSION.tar.gz

# Update and install minimal.
RUN \
    apt-get update \
        --quiet \
    && apt-get install \ 
        --yes \
        --no-install-recommends \
        --no-install-suggests \
    autoconf \
    automake \
    flex \
    git-core \
    libtool \
    libonig-dev \
    make \
    valgrind \
    wget \

# Clean up packages.
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Prepare for cloning/building.
WORKDIR /tmp

# Build bison from source.
RUN \
    wget \
        --no-verbose \
    $BISON_PACKAGE \
    && tar xzf bison-$BISON_VERSION.tar.gz \
    && cd bison-$BISON_VERSION \
    && ./configure \
    && make -j`getconf _NPROCESSORS_ONLN` \
    && make install \
    && rm -rf /tmp/* 

# Build jq from source.
RUN \
    git clone git://github.com/stedolan/jq.git \
    && cd jq \
    && autoreconf -i \
    && ./configure \
    && make -j`getconf _NPROCESSORS_ONLN` \
    && make install \
    && rm -rf /tmp/*
 
# Default command.
CMD ["bash"]
