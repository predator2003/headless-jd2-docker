#!/bin/bash

USER="jdownloader"

echo "JDownloader settings"
echo "===================="
echo
echo "User:       ${USER}"
echo "UID:        ${JDOWNLOADER_UID:=666}"
echo "GID:        ${JDOWNLOADER_GID:=666}"
echo

function stopJD2 {
printf "Stopping JDownloader"
    PID=$(cat JDownloader.pid)
    kill $PID
    wait $PID
    echo "[DONE]"
    exit
}

trap stopJD2 EXIT

printf "Updating UID / GID... "
[[ $(id -u ${USER}) == ${JDOWNLOADER_UID} ]] || usermod  -o -u ${JDOWNLOADER_UID} ${USER}
[[ $(id -g ${USER}) == ${JDOWNLOADER_GID} ]] || groupmod -o -g ${JDOWNLOADER_GID} ${USER}
echo "[DONE]"

printf "Setting permissions... "
chown -R ${USER}: /opt/JDownloader
echo "[DONE]"

echo "Starting JDownloader..."
su -pc "java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar 2>&1 >/dev/null" ${USER}
echo "[DONE]"

while true; do 
    i=1
done
