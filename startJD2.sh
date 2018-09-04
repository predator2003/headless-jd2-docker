#!/bin/bash

function stopJD2 {
	PID=$(cat JDownloader.pid)
	kill $PID
	wait $PID
	exit
}

trap stopJD2 EXIT

# Sometimes this gets deleted. Just copy it every time.
cp /opt/JDownloader/sevenzip* /opt/JDownloader/libs/

java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar &

while true; do
	sleep inf
done
