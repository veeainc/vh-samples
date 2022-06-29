#!/bin/sh
################################################################################
# Copyright (C) Veea Systems Limited - All Rights Reserved.
# Unauthorised copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential. [2022-2023]
################################################################################

# Discover MQTT url

# while true
# do
#     mqttURL=$(vbus-cmd --domain=azureiothub --app=loracomponent -w -p "veea.mqtt" discover veea.mqtt | grep tcp | cut -d '/' -f3 | cut -d ':' -f1)

#     export MQTT_URI=$mqttURL
# done

# Discover MQTT url
status="false"
while [ $status = "true" ]
#mqttURL=$(vbus-cmd --domain=greengrass --app=loracomponent -w -p "veea.mqtt.>" attribute get veea.mqtt.local.uris.mqtt | cut -d '"' -f2)

mqttURL=$(vbus-cmd --domain=azureiothub --app=loracomponent -w -p "veea.mqtt" discover veea.mqtt | cut -d '"' -f4 | grep tcp)

echo "MQTT uri: $mqttURL" 
do
	if expr "$mqttURL" : '[a-z]*\://*[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\:[0-9]*/$' >/dev/null; then
      echo "MQTT URI found : $mqttURL"
      mqttURL_formatted=$(echo $mqttURL | cut -d '/' -f3 | cut -d ':' -f1)
      echo "Formatted MQTT URI found : $mqttURL_formatted"
      export MQTT_URI=$mqttURL_formatted
	  status="true"
	  echo "breaking the loop"
	  break
	else
	  echo  "Valid MQTT URI not found. Retrying in 5 seconds.."
	  sleep 5
	fi
done

echo  "Broken the loop and out of loop"


