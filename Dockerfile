# Google mirrors are very fast.
FROM google/debian:wheezy

MAINTAINER Ozzy Johnson <ozzy.johnson@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Update and install minimal.
RUN \
  apt-get update \
            --quiet && \
  apt-get install \ 
            --yes \
            --no-install-recommends \
            --no-install-suggests \
    autoconf \
    automake \
    curl \
    flex \
    git-core \
    libtool \
    libonig-dev \
    make \
    valgrind \
    wget && \

# Clean up packages.
  apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Prepare for cloning/building.
WORKDIR /tmp

# Build bison from source.
ENV BISON_VERSION 3.0.2
RUN \
  wget \
    http://ftpmirror.gnu.org/bison/bison-$BISON_VERSION.tar.gz && \
  tar xzf bison-$BISON_VERSION.tar.gz && \
  cd bison-$BISON_VERSION && \
  ./configure && \
  make -j`getconf _NPROCESSORS_ONLN` && \
  make install && \
  rm -rf /tmp/* 

# Get jq source.
RUN git clone git://github.com/stedolan/jq.git && \
    cd jq && \
    autoreconf -i && \
    ./configure && \
    make -j`getconf _NPROCESSORS_ONLN` && \
    make install && \
    rm -rf /tmp/*
 
# Default command.
CMD ["bash"]
