#!/bin/sh
################################################################################
# Copyright (C) Veea Systems Limited - All Rights Reserved.
# Unauthorised copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential. [2019-2020]
################################################################################

# Logging in the persistent volume vh_publisher
logfile="/var/lib/veea/vh_publisher/vh_publisher.log"

# Creating a partition in log file
echo "-----------------------------------------$(date)------------------------------------------" | tee "$logfile"

# Script to create a random UUID
stresstest_UUID="$(tr -dc A-Za-z0-9 </dev/urandom | head -c 8)"
status_var="up"

# Discover Redis url provided by Redis container
status="false"
while [ $status = "true" ]
redisURL=$(vbus-cmd --domain=veea --app=publisher -p "veea.redis.>" attribute get veea.redis.local.uris.redis | cut -d '"' -f2)
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

#Increment and set the counter at a particular interval (for eg: 30 secs)
count=0
status="false"
while [ $status = "true" ]
count=$((count+1)) 
do
  # -u flag is used to provide the appropriate Redis URI instead of using local Redis
	redis-cli -u "$redisURL" set mycounter "uuid: $stresstest_UUID - status: $status_var - count: $count"
	echo "Setting mycounter in redis-server - uuid: $stresstest_UUID - status: $status_var - count: $count"  | tee -a "$logfile"
	sleep 30
done

# Infinite loop for main thread not to terminate
# This helps in keeping the container running on Veea hub
while true
do
  echo sleeping...   | tee -a "$logfile"
  sleep 30
done

