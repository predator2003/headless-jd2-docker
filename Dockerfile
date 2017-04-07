FROM openjdk:8-jre-alpine

MAINTAINER Koopzington <koopzington@gmail.com>

LABEL org.freenas.interactive="false"				\
      org.freenas.version="2"					\
      org.freenas.upgradeable="true"				\
      org.freenas.expose-ports-at-host="false"			\
      org.freenas.autostart="true"				\
      org.freenas.volumes="[					\
          {							\
              \"name\": \"/opt/JDownloader/cfg\",			\
              \"descr\": \"Configuration files directory\"	\
          },							\
          {							\
              \"name\": \"/opt/JDownloader/Downloads\",		\
              \"descr\": \"Downloads Folder\"			\
          }							\	
       ]"							\
       org.freenas.settings="[					\
          {							\
              \"env\": \"JDOWNLOADER_GID\",			\
              \"descr\": \"PGID assigned upon creation\",	\
              \"optional\": true				\
          },							\
          {							\
              \"env\": \"JDOWNLOADER_UID\",			\
              \"descr\": \"PUID assigned upon creation\",	\
              \"optional\": true				\
          }							\
      ]"

# Create user and group for JDownloader.
RUN addgroup -S -g 666 jdownloader \
    && adduser -u 666 -D -S -G jdownloader jdownloader

# Create directory, download and start JD2 for the initial update and creation of config files.
RUN mkdir -p /opt/JDownloader/ \
    && wget -O /opt/JDownloader/JDownloader.jar -U "https://hub.docker.com/r/koopz/freenas-docker-jdownloader/" http://installer.jdownloader.org/JDownloader.jar \
    && java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar

COPY startJD2.sh /opt/JDownloader/
RUN chmod +x /opt/JDownloader/startJD2.sh

# Run this when the container is started
CMD /opt/JDownloader/startJD2.sh
