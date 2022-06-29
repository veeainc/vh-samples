#!/bin/sh
################################################################################
# Copyright (C) Veea Systems Limited - All Rights Reserved.
# Unauthorised copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential. [2022-2023]
################################################################################

cd /app
source /app/myapp/venv3/bin/activate


. set_MQTT_URI.sh

python lora_azure_telemetry.py &

while true
do
  echo sleeping...
  sleep 30
done
