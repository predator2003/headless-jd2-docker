FROM openjdk:8-jre

MAINTAINER Koopzington <koopzington@gmail.com>

# the user jd2 will run with and his group
ARG user=jd2
ARG group=jd2
ARG uid=1000
ARG gid=1000

# Install fontconfig and download phantomjs
RUN apt-get update && \
    apt-get install -y --no-install-recommends fontconfig && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    wget -O /tmp/phantomjs.tar.bz2 --progress=bar:force https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
    cd /tmp/ && \
    tar xvfj phantomjs.tar.bz2 && \
    mv phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs && \
    rm -rf /tmp/phantomjs*
    
RUN mkdir -p /opt/JDownloader/  
    
# Beta sevenzipbindings
COPY sevenzip* /opt/JDownloader/

COPY startJD2.sh /opt/JDownloader/
RUN chmod +x /opt/JDownloader/startJD2.sh

# add specified user and group and create and chown the install and downloads dir
RUN groupadd -g ${gid} ${group} \
	&& useradd -u ${uid} -g ${gid} -m -s /bin/bash ${user} \
	&& chown -R ${uid}:${group} /opt/JDownloader
      
USER ${user}

# Create directory, download and start JD2 for the initial update and creation of config files.
RUN \
    wget -O /opt/JDownloader/JDownloader.jar -U="https://hub.docker.com/r/koopz/freenas-docker-jdownloader/" --progress=bar:force http://installer.jdownloader.org/JDownloader.jar && \
    java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar




# Run this when the container is started


CMD /opt/JDownloader/startJD2.sh
