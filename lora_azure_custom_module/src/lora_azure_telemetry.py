
################################################################################
# Copyright (C) Veea Systems Limited - All Rights Reserved.
# Unauthorised copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential. [2022-2023]
################################################################################

import os
import time
import sys
import threading
import signal
import random
from paho.mqtt import client as mqtt_client
import logging
from azure.iot.device import IoTHubModuleClient


_LOGGER = logging.getLogger(__name__)
FORMAT = '%(levelname)s: %(asctime)-15s: %(filename)s: %(funcName)s: %(module)s: %(message)s'
logging.basicConfig(level = logging.DEBUG, format = FORMAT)


VBUS_DOMAIN_NAME ="azureiothub"
VBUS_APP_NAME= "loracomponent"

port = 1883
topic = "application/+/device/+/event/up"

# generate client ID with pub prefix randomly
client_id = f'python-mqtt-{random.randint(0, 100)}'

# username = 'emqx'
# password = 'public'


def connect_mqtt(broker) -> mqtt_client:
    def on_connect(client, userdata, flags, rc):
        if rc == 0:
            _LOGGER.info("Connected to MQTT Broker!")
        else:
            _LOGGER.info("Failed to connect, return code %d\n", rc)

    client = mqtt_client.Client(client_id)
    
    #client.username_pw_set(username, password)

    client.on_connect = on_connect
    client.connect(broker, port)
    return client


def subscribe(azure_client, client: mqtt_client):
    def on_message(client, userdata, msg):

        #print(f"Received `{msg.payload.decode()}` from `{msg.topic}` topic")

        _LOGGER.info(f"Received `{msg.payload.decode()}` from `{msg.topic}` topic")

        message = msg.payload.decode()
        azure_client.send_message_to_output(message, "output1")
        _LOGGER.info("Data sent to Azure IoT Hub")

    client.subscribe(topic)
    client.on_message = on_message

def main():
    _LOGGER.info ( "\nPython {}\n".format(sys.version) )
    _LOGGER.info ( "IoT Hub Client for Python" )

    # Event indicating sample stop
    stop_event = threading.Event()

    # Define a signal handler that will indicate Edge termination of the Module
    def module_termination_handler(signal, frame):
        _LOGGER.info ("IoTHubClient sample stopped")
        stop_event.set()

    # Attach the signal handler
    signal.signal(signal.SIGTERM, module_termination_handler)

    # Create the client
    azure_client = IoTHubModuleClient.create_from_edge_environment()
    run(azure_client)


    try:
        # This will be triggered by Edge termination signal
        stop_event.wait()
    except Exception as e:
        _LOGGER.info("Unexpected error %s " % e)
        raise
    finally:
        # Graceful exit
        _LOGGER.info("Shutting down client")
        azure_client.shutdown()


def run(azure_client):

    while os.getenv("MQTT_URI") == None:
        time.sleep(5)
        _LOGGER.info(f"sleeping for 5 seconds to retry to get valid MQTT_URI")

    mqtt_uri = os.getenv("MQTT_URI")
    _LOGGER.info(f"mqtt_uri found is {mqtt_uri}")
    
    #broker = '10.101.0.1'
    #broker = '192.168.200.48'

    broker = mqtt_uri

    client = connect_mqtt(broker)
    subscribe(azure_client, client)
    client.loop_forever()


if __name__ == '__main__':
    main()
