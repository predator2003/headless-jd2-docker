[![Docker Automated build](https://img.shields.io/docker/automated/koopz/freenas-docker-jdownloader.svg?style=flat-square)]()
[![Docker Build Status](https://img.shields.io/docker/build/koopz/freenas-docker-jdownloader.svg?style=flat-square)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/koopz/freenas-docker-jdownloader.svg?style=flat-square)]()
[![Docker Stars](https://img.shields.io/docker/stars/koopz/freenas-docker-jdownloader.svg?style=flat-square)]()

# headless-jd2-docker
Headless JDownloader 2 Docker Container for FreeNAS

## Running the container
0. `sudo su`
1. Create a folder on your host for the configuration files (eg. sudo mkdir /config/jd2)
2. run `docker run -d --name jd2 -v /config/jd2:/opt/JDownloader/cfg -v /home/user/Downloads:/root/Downloads plusminus/jdownloader2-headless`
3. stop the container `docker stop jd2`
4. On your host, enter your credentials (in quotes) to the file `org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json` as in `{ "password" : "mypasswort", "email" : "email@home.org" }`
5. Start the container
