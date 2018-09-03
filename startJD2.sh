#!/bin/bash

function stopJD2 {
	PID=$(cat JDownloader.pid)
	kill $PID
	wait $PID
	exit
}

if [ "${gid}" ]
then
	groupadd -g ${gid} ${group}
else
	group=root
fi

if [ "${uid}" ] 
then
	useradd -r -s /bin/false -u ${uid} -g ${group} ${user}
	chown -R ${user}:${group} /opt/JDownloader
else
	user=root
fi

# Sometimes this gets deleted. Just copy it every time.
cp /opt/JDownloader/sevenzip* /opt/JDownloader/libs/

trap stopJD2 EXIT

echo "Starting JDownloader..."
su -c "java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar" -s /bin/bash ${user}
echo "[DONE]"

while sleep 3600; do :; done
