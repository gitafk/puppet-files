#!/bin/bash

FS="/"
LOG_DIR="/opt/appdir/log"
CRITICAL="50"

function dateCheck() {
	date +%Y-%m-%dT%H:%M:%S
}

fsCheck () {
	fsDetails=$(df -h $FS | grep -v "Filesystem")
	used=$(echo $fsDetails | awk '{ print $5 }' | cut -d'%' -f1)

	# Cleaning required only when used space is above CRITICAL levels
	if [ $used -ge $CRITICAL ] ; then
		# Email can be sent here and/or automatic clean up
		# App will generate new log file each day, so old ones can be compressed 
		# Assumption that old logs files will be suffixed by dot and any set of characters
		echo "$(dateCheck) Compressing log files."
		find $LOG_DIR -type f -name 'app.log.*' -and -not -name 'app.log.*.gz' -exec gzip {} \;
		# Delete old compressed files
		echo "$(dateCheck) Deleting old commpressed log files."
		find $LOG_DIR -type f -name 'app.log.*.gz' -mtime +7 -exec rm {} \;
	else
		# All good, nothing to do
		echo "$(dateCheck) $0 execution complete, no cleaning required."
		exit 0
	fi
}

### Main function execution
echo "$(dateCheck) Filesystem check where app is deployed."
fsCheck
echo "$(dateCheck) $0 execution complete."