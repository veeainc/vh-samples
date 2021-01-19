#!/bin/sh
################################################################################
# Copyright (C) Veea Systems Limited - All Rights Reserved.
# Unauthorised copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential. [2019-2020]
################################################################################

#Logging in the persistent volume vh_consumer
logfile="/var/lib/veea/vh_consumer/vh_consumer.log"

#creating a partition in log file
echo "-----------------------------------------$(date)------------------------------------------" | tee "$logfile"

# Discover Redis url provided by Redis container
status="false"
while [ $status = "true" ]
redisURL=$(vbus-cmd --domain=veea --app=consumer -p "veea.redis.>" attribute get veea.redis.local.uris.redis | cut -d '"' -f2)
sleep 1
echo "Redis URI: $redisURL" | tee -a "$logfile"
do
  # Validating the discovered Redis URI in the following format with the REGEX: redis://10.100.1.1:6379/
	if expr "$redisURL" : '[a-z]*\://*[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\:[0-9]*/$' >/dev/null; then
	  echo "Valid redisURL found : $redisURL"  | tee -a "$logfile"
	  status="true"
	  echo "Breaking the loop" | tee -a "$logfile"
	  break
	else
	  echo  "Valid redisURL not found. Retrying in 5 seconds.."  | tee -a "$logfile"
	  sleep 5
	fi
done

#Get the "mycounter" value at particular intervals (for eg: 30 secs) from Redis using redis-cli tool
status="false"
while [ $status = "true" ]
# -u flag is used to provide the appropriate Redis URI instead of using local Redis
mycounter=$(redis-cli -u "$redisURL" get mycounter)
do
	if [ -z "$mycounter" ]; then
	  	echo "mycounter found empty. Retrying after 3 seconds" | tee -a "$logfile"
	  	sleep 3
	else
		echo "mycounter retrieved from Redis - $mycounter" | tee -a "$logfile"
		sleep 30
	fi
done

# Infinite loop for main thread not to terminate
# This helps in keeping the container running on Veea hub
while true
do
  echo sleeping...   | tee -a "$logfile"
  sleep 30
done



