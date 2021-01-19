#!/bin/sh
################################################################################
# Copyright (C) Veea Systems Limited - All Rights Reserved.
# Unauthorised copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential. [2019-2020]
################################################################################

#Logging in the persistent volume vh_redis
logfile="/var/lib/veea/vh_redis/vh_redis.log"

#creating a partition in log file
echo "-----------------------------------------$(date)------------------------------------------" | tee "$logfile"

# start the Redis-server with configuration file
redis-server /etc/redis.conf 2>&1 | tee -a "$logfile" &

#Validating the redis server has started by checking background process
status="false"
while [ $status = "true" ]
sleep 5
do
  pgrepresult=$(pgrep redis-server)
  echo "redis pgrepresult is $pgrepresult"  | tee -a "$logfile"
  if [ -z "$pgrepresult" ];then
    echo "redis-server not started. Waiting for it to start"  | tee -a "$logfile"
    sleep 3
  else
    status="true"
    echo "redis-server started with pid $pgrepresult" | tee -a "$logfile"
    echo "breaking the waiting loop" | tee -a "$logfile"
    break
  fi
done

# Expose Redis URI on vBus
# this is the format it exposes <protocol>://<IP_Address>:<port>/
vbus-cmd --domain=veea --app=redis -w expose --name=redis --protocol=redis --port=6379 &

sleep 3

# Validating Exposed Redis URI
status="false"
while [ $status = "true" ]
exposed_URI=$(vbus-cmd --domain=veea --app=redis -p "veea.redis.>" attribute get veea.redis.local.uris.redis | cut -d '"' -f2)
sleep 5
do
	echo "exposed_URI get result is : $exposed_URI" | tee -a "$logfile"
  # Validating the Exposed Redis URI in the following format with the REGEX: redis://10.100.1.1:6379/
  if expr "$exposed_URI" : '[a-z]*\://*[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\:[0-9]*/$' >/dev/null; then
    echo "redis service is exposed with vbus-cmd: $exposed_URI"  | tee -a "$logfile"
    status="true"
    echo "breaking the loop" | tee -a "$logfile"
    break
  else
    echo  "URI is not set or not exposed in correct format. Retrying in 5 seconds.."  | tee -a "$logfile"
    sleep 3
  fi
done

# Infinite loop for main thread not to terminate
# This helps in keeping the container running on Veea hub
while true
do
  echo sleeping... | tee -a "$logfile"
  sleep 30
done
