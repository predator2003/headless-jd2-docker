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

# Create user and group for JDownloader.
RUN groupadd -r -g 666 jdownloader && \
    useradd -r -u 666 -g 666 jdownloader

# Create directory, download and start JD2 for the initial update and creation of config files.
RUN mkdir -p /opt/JDownloader/ && \
    wget -O /opt/JDownloader/JDownloader.jar --user-agent="https://hub.docker.com/r/koopz/freenas-docker-jdownloader/" --progress=bar:force http://installer.jdownloader.org/JDownloader.jar && \
    java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar

COPY startJD2.sh /opt/JDownloader/
RUN chmod +x /opt/JDownloader/startJD2.sh

VOLUME ["opt/JDownloader/cfg", "opt/JDownloader/Downloads"]

# Run this when the container is started
CMD /opt/JDownloader/startJD2.sh
