
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

echo "Starting JDownloader..."
java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar &
echo "[DONE]"

while true; do
	sleep inf
done
