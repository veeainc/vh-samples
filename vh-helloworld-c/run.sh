#!/bin/sh

# Mark the start of this platform container
logger "Starting [vh-helloworld] sample [$$]"

helloworld

# Hang around, as docker service will restart this if we complete
while true;
do
    sleep 60;
done