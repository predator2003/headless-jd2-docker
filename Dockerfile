FROM openjdk:8-jre-alpine

MAINTAINER Koopzington <koopzington@gmail.com>

# Create user and group for JDownloader.
RUN groupadd -r -g 666 jdownloader \
    && useradd -r -u 666 -g 666 -d /jdownloader -m jdownloader

# Create directory, download and start JD2 for the initial update and creation of config files.
RUN mkdir -p /opt/JDownloader/ \
    && wget -O /opt/JDownloader/JDownloader.jar --user-agent="https://hub.docker.com/r/koopzington/freenas-docker-jdownloader/" --progress=bar:force http://installer.jdownloader.org/JDownloader.jar \
    && java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar

COPY startJD2.sh /opt/JDownloader/
RUN chmod +x /opt/JDownloader/startJD2.sh

# Run this when the container is started
CMD /opt/JDownloader/startJD2.sh
