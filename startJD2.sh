
#!/bin/bash
# From https://github.com/ben-st/headless-jd2-docker/raw/master/startJD2.sh

function stopJD2 {
	PID=$(cat JDownloader.pid)
	kill $PID
	wait $PID
	exit
}

trap stopJD2 EXIT


echo "Starting JDownloader..."
# Sometimes this gets deleted. Just copy it every time.
cp /opt/JDownloader/sevenzip* /opt/JDownloader/libs/
java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar &
echo "[DONE]"

while true; do
	sleep inf
done
