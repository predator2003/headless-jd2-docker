FROM openjdk:8-jre

MAINTAINER Koopzington <koopzington@gmail.com>

LABEL org.freenas.interactive="false" \
      org.freenas.version="2" \
      org.freenas.upgradeable="true"  \
      org.freenas.expose-ports-at-host="false" \
      org.freenas.autostart="true" \
      org.freenas.volumes="[ \
        { \
          \"name\": \"/opt/JDownloader/cfg\", \
          \"descr\": \"Configuration files directory\" \
        }, \
        { \
          \"name\": \"/opt/JDownloader/Downloads\", \
          \"descr\": \"Downloads Folder\" \
        } \
      ]" \
      org.freenas.settings="[ \
        { \
          \"env\": \"JDOWNLOADER_GID\", \
          \"descr\": \"PGID assigned upon creation\", \
          \"optional\": true \
        }, \
        { \
          \"env\": \"JDOWNLOADER_UID\", \
          \"descr\": \"PUID assigned upon creation\", \
          \"optional\": true \
        } \
      ]"

# 1. Install compile and runtime dependencies
# 2. Compile PhantomJS from the source code
# 3. Remove compile depdencies
# We do all in a single commit to reduce the image size (a lot!)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        libsqlite3-dev \
        libfontconfig1-dev \
        libicu-dev \
        libfreetype6 \
        libssl-dev \
        libpng-dev \
        libjpeg-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        g++ \
        git \
        flex \
        bison \
        gperf \
        perl \
        python \
        ruby \
    && git clone --recurse-submodules https://github.com/ariya/phantomjs /tmp/phantomjs \
    && cd /tmp/phantomjs \
    && ./build.py --release --confirm --silent >/dev/null \
    && mv bin/phantomjs /usr/local/bin \
    && cd \
    && apt-get purge --auto-remove -y \
        build-essential \
        g++ \
        git \
        flex \
        bison \
        gperf \
        ruby \
        perl \
        python \
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/*

# Create user and group for JDownloader.
RUN groupadd -r -g 666 jdownloader && \
    useradd -r -u 666 -g 666 jdownloader

# Create directory, download and start JD2 for the initial update and creation of config files.
RUN mkdir -p /opt/JDownloader/ && \
    wget -O /opt/JDownloader/JDownloader.jar --user-agent="https://hub.docker.com/r/koopz/freenas-docker-jdownloader/" --progress=bar:force http://installer.jdownloader.org/JDownloader.jar && \
    java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar

COPY startJD2.sh /opt/JDownloader/
RUN chmod +x /opt/JDownloader/startJD2.sh

WORKDIR /opt/JDownloader

# Run this when the container is started
CMD startJD2.sh
