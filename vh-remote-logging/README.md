# Python Remote Syslog Demo Template Application

The Python Remote Syslog Demo template application demonstrates the following:

1. Create a basic container
2. Log messages to a remote syslog server from a hub

- [Python Remote Syslog Demo Template Application](#python-remote-syslog-demo-template-application)
  - [Setting up a Syslog Server](#setting-up-a-syslog-server)
  - [Prerequisites](#prerequisites)
  - [Setup Your Hub](#setup-your-hub)
    - [Pull Down the Application](#pull-down-the-application)
    - [Set the Container to Untrusted Mode](#set-the-container-to-untrusted-mode)
    - [Set the UUID](#set-the-uuid)
    - [Build the Image](#build-the-image)
    - [Create the Image](#create-the-image)
    - [Create the Container](#create-the-container)
    - [Put the syslog config on the container](#put-the-syslog-config-on-the-container)
    - [Enable Syslog (Syslog Forwarding) for Application Container](#enable-syslog-syslog-forwarding-for-application-container)
  - [How to read the Syslog](#how-to-read-the-syslog)
    - [Configure Remote Syslog Server to Listen for Incoming UDP syslog messages](#configure-remote-syslog-server-to-listen-for-incoming-udp-syslog-messages)
    - [Use tail to read the remote Syslog file](#use-tail-to-read-the-remote-syslog-file)
  - [Managing the Syslog Container on the Hub](#managing-the-syslog-container-on-the-hub)
    - [Start the Container](#start-the-container)
    - [Attach to the Container (Console)](#attach-to-the-container-console)
    - [Stop the Container](#stop-the-container)
    - [Delete the Container](#delete-the-container)
    - [Delete the Image](#delete-the-image)

---

## Setting up a Syslog Server

**Note: You want to make sure the remote syslog server is configured to listen on a UDP port for remote syslog messages. You need to know what this UDP port number is because later you will need to configure the remote-host and remote-port and this server and port will be what you will use.**

The following picture depicts three things.

- One - the Container/Application your are writing will make syslog calls to a remote syslog server that is listening on IP address 192.168.1.1 and UDP port 514 in this example.
- Two - Your container is running inside a VeeaHub for example with IP 192.168.1.2
- Third - The Remote Syslog Serveris listening on UDP port number 514 for remove syslog messages.

![image Info](remote-syslog-veeahub.png 'Image Description')

You can use a simple syslog docker container to test your configuration, but this should not be used as a production syslog server

`sudo docker run -it --rm -p 514:514/udp -p 601:601 --name syslog-ng balabit/syslog-ng:latest -rvdte`

---

For the following commands, please substitute your hub serial number, IP address, UUID, image ID, and container ID as appropriate.

## Prerequisites

If your configuration has been setup for secure/trusted development then you will need to specify the TLS PIN for all `hub` commands. There are three ways to do this:

1. `--tls-pin` option.
2. `VHC_TLS_PIN` environment variable.
3. User-prompt during execution of `hub` commands.

Option 2 was used in the creation of this document.

## Setup Your Hub

To add your hub to your VHC configuration, run:

```bash
vhc hub --add-hub 1:<serial-number>:<ipv4-addr>
```

where `1` is the hub ID. With a single hub configured there is no need to specify the hub ID via the `--hub-id` or `--active-hub` options. The commands below assume a single hub configuration.

Make sure you can talk to the hub:

```bash
$ vhc hub --ping
Located hub 10.20.0.89 via IP address.
Pinging C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/ping)...
Success
```

### Pull Down the Application

To instantiate the remote logging demo template application:

```bash
$ vhc new -t vh-remote-logging
2019/10/08 07:47:47 Creating app from template vh-remote-logging.
Using vh-remote-logging
2019/10/08 07:47:47 Creating application directory: vh-remote-logging
2019/10/08 07:47:47 vh-remote-logging.zip downloaded
2019/10/08 07:47:47 Unzipping...
2019/10/08 07:47:47 Unzipped vh-remote-logging.zip to vh-remote-logging
```

Change to the remote logging demo directory:

```bash
 cd vh-remote-logging
```

### Set the Container to Untrusted Mode

To set the container to run untrusted:

```bash
$ vhc secure --unauth-host
Project configuration modified. Please rebuild image(s).
```

### Set the UUID

To generate a UUID automatically, run:

```bash
$ vhc secure --gen-uuid
Generated UUID: 1BAB6834-70CB-4107-A6A3-D6F44ACE7C2E
Project configuration modified. Please rebuild image(s).
```

To set a specific UUID, run:

```bash
$ vhc secure --set-uuid <uuid>
Set UUID: <uuid>
Project configuration modified. Please rebuild image(s).
```

### Build the Image

To build the image for the VHC05 target, run:

```bash
$ vhc build --unsigned --no-cache --target vhx09-10
Making vh_remote_logging image for vhx09-10 target...
Dockerfile.vhx09-10 does not exist.
Generating Dockerfile for Dockerfile.vhx09-10...
bin/vh_remote_logging-arm64v8:1.0.0.tar does not exist.
Building vh_remote_logging image for vhx09-10...
Command Started
Sending build context to Docker daemon  45.57kB
Step 1/15 : FROM arm64v8/python:3.7-alpine
 ---> 170251bf6ff2
Step 2/15 : RUN mkdir /app
 ---> Running in fb2f47cac7d7
Removing intermediate container fb2f47cac7d7
 ---> 6250d272594d
Step 3/15 : COPY src/ /app/
 ---> 2b3c57eaf8ef
Step 4/15 : WORKDIR /app
 ---> Running in 8afe26729e42
Removing intermediate container 8afe26729e42
 ---> 059f87b5c213
Step 5/15 : LABEL com.veea.vhc.target="vhx09-10"
 ---> Running in 8f4c1170fe64
Removing intermediate container 8f4c1170fe64
 ---> c76851b4b01b
Step 6/15 : LABEL com.veea.vhc.version="0.6.0"
 ---> Running in 07f8481692a7
Removing intermediate container 07f8481692a7
 ---> b2fd675c1d9e
Step 7/15 : LABEL com.veea.vhc.app.name="vh remote logging"
 ---> Running in b9e27cdcde1b
Removing intermediate container b9e27cdcde1b
 ---> 894ae8736d75
Step 8/15 : LABEL com.veea.vhc.app.version="1.0.0"
 ---> Running in 32c6c261b907
Removing intermediate container 32c6c261b907
 ---> 7da9da99097b
Step 9/15 : LABEL com.veea.vhc.config.proj.version="2"
 ---> Running in 4a2f9fef4a2d
Removing intermediate container 4a2f9fef4a2d
 ---> 8d9bce78a798
Step 10/15 : LABEL com.veea.vhc.config.user.version="2"
 ---> Running in dfa4e08e9493
Removing intermediate container dfa4e08e9493
 ---> abef5560ea7f
Step 11/15 : ARG PARTNER_ID
 ---> Running in 2a06c97821d6
Removing intermediate container 2a06c97821d6
 ---> 0157b69979d7
Step 12/15 : LABEL com.veea.image.persistent_uuid="$PARTNER_ID-6605-41AE-9BDE-0E6B882AEDAA"
 ---> Running in 484d629f76d5
Removing intermediate container 484d629f76d5
 ---> e7a0d4cc072d
Step 13/15 : LABEL com.veea.authorisation.allowOnUnauthenticatedHost="true"
 ---> Running in eeb389ff6fc4
Removing intermediate container eeb389ff6fc4
 ---> 5aab51312002
Step 14/15 : LABEL com.veea.authorisation.feature1="DEVELOPER"
 ---> Running in 16deb1b60e3f
Removing intermediate container 16deb1b60e3f
 ---> 3a5d98c98893
Step 15/15 : CMD ["python", "loop.py"]
 ---> Running in fb1b8ded1c1e
Removing intermediate container fb1b8ded1c1e
 ---> 9ed40f244c25
Successfully built 9ed40f244c25
Successfully tagged vh_remote_logging-arm64v8:1.0.0


Saving vh_remote_logging image for vhx09-10.

```

### Create the Image

To create the Remote Logging Demo image, run:

```bash
$ vhc hub image --hub-id 0579 --create bin/vh_remote_logging-arm64v8:1.0.0.tar

Creating image push for file [bin/vh_remote_logging-arm64v8:1.0.0.tar] on E09BCW00C0B000000579:9000 (https://192.168.1.190:9000/images/push)...
 83.08 MB / 83.08 MB [=========================================================================================] 100.00%
{
  "image_id": "9ed40f244c25e71711796a327a8685e108e1003f86ab2a760098f19febe27fd6"
}

```

### Create the Container

To create the Remote Logging Demo container, run:

```bash
$ vhc hub image --hub-id 0579 --create-container 9ed40f244c25e71711796a327a8685e108e1003f86ab2a760098f19febe27fd6
Creating container from image 9ed40f244c25e71711796a327a8685e108e1003f86ab2a760098f19febe27fd6 on E09BCW00C0B000000579:9000 (https://192.168.1.190:9000/images/9ed40f244c25e71711796a327a8685e108e1003f86ab2a760098f19febe27fd6/create_container)...
 322 B / 322 B [===============================================================================================] 100.00%
{
  "container_id": "08e3c3890013744826dd04a5c30db639232fb2a6ba21a3d2f3c4bca9834d1774",
  "detached": false
}
```

### Put the syslog config on the container

Add the ip and port config for your syslog server

```bash
$ vhc hub container --put-syslog 08e3c3890013744826dd04a5c30db639232fb2a6ba21a3d2f3c4bca9834d1774 --hub-id 0579 log-config.json
Put syslog for container 08e3c3890013744826dd04a5c30db639232fb2a6ba21a3d2f3c4bca9834d1774 from E09BCW00C0B000000579:9000 (https://192.168.1.190:9000/containers/08e3c3890013744826dd04a5c30db639232fb2a6ba21a3d2f3c4bca9834d1774/syslog)...
Success
```

### Enable Syslog (Syslog Forwarding) for Application Container

This step will configure a syslog forwarder on the VeeaHub specific to this container which will listen to all syslog messages on socket /dev/log and forward them to your configured remote host (syslog) and remote UDP port. Note that you have to start the container for the messages to start forwarding to remote server. If you enable syslog while the container is running, you need to restart the container for the messages to start forwarding.

```bash
Example
{
    "remote-host":"192.168.1.1",
    "remote-port":"514"
}
```

## How to read the Syslog

### Configure Remote Syslog Server to Listen for Incoming UDP syslog messages

This step to make sure your remote syslog server is configured to listen for remote syslog UDP messages and to double check what the UDP port is. The default USP port is 514 but double check.

This syslog server setting is dependent on the syslog server you are using. As an example, using rsyslogd on Ubuntu 18.04 the following is the change to /etc/rsyslog.conf to enable listening to UDP messages on port 514 which is to uncomment 2 lines in the /etc/rsyslog.conf file.

```bash
builder:/etc$ diff rsyslog.conf.orig rsyslog.conf
17,18c17,18
< #module(load="imudp")
< #input(type="imudp" port="514")
---
> module(load="imudp")
> input(type="imudp" port="514")
builder:/etc$
```

Restart the Ubuntu 18.04 rsyslog server

```bash
sudo /etc/init.d/rsyslog restart
```

Test logging to the remote syslog server works from another machine.

```bash
ubuntu20:~/WebstormProjects/dig/src/playground$ logger -n 192.168.1.1 -P 514 "Test message from ubuntu 20"
```

Verify you see the test log message to verify your syslog server is setup correctly.

### Use tail to read the remote Syslog file

Login to your syslog server to tail the log so you can see when the log messages start flowing.

The log messages seen below will not start flowing until you

- a) enable syslog (syslog forwarding) for the application container and
- b) start the container.

```bash
builder:~$ sudo tail -f /var/log/syslog
Jul 23 10:23:54 builder systemd[20602]: Stopped Pending report trigger for Ubuntu Report.
Jul 23 10:23:54 builder systemd[1]: Removed slice User Slice of root.
Jul 23 10:23:55 logging from inside VH container - sleeping for 5 secs :2
Jul 23 10:24:00 logging from inside VH container - sleeping for 5 secs :3
Jul 23 10:24:05 logging from inside VH container - sleeping for 5 secs :4
Jul 23 10:24:10 logging from inside VH container - sleeping for 5 secs :5
Jul 23 10:24:15 logging from inside VH container - sleeping for 5 secs :6
Jul 23 10:24:20 logging from inside VH container - sleeping for 5 secs :7
Jul 23 10:24:25 logging from inside VH container - sleeping for 5 secs :8
Jul 23 10:24:31 logging from inside VH container - sleeping for 5 secs :9
Jul 23 10:24:35 logging from inside VH container - sleeping for 5 secs :10
```

## Managing the Syslog Container on the Hub

### Start the Container

To start the Remote Logging Demo container, run:

```bash
$ vhc hub container --start ecfd7e83b757945ba9da76d86356738b386e6ddb9cfb17d490c2a884be5081ea
Starting container ecfd7e83b757945ba9da76d86356738b386e6ddb9cfb17d490c2a884be5081ea C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/ecfd7e83b757945ba9da76d86356738b386e6ddb9cfb17d490c2a884be5081ea/start)...
Success
```

### Attach to the Container (Console)

To attach to the Remote Logging Demo container _with_ a console run the following command:

```bash
nothing to see
```

### Stop the Container

To stop the remote logging demo container, run:

```bash
$ vhc hub container --stop ecfd7e83b757945ba9da76d86356738b386e6ddb9cfb17d490c2a884be5081ea
Stopping container ecfd7e83b757945ba9da76d86356738b386e6ddb9cfb17d490c2a884be5081ea from C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/ecfd7e83b757945ba9da76d86356738b386e6ddb9cfb17d490c2a884be5081ea/stop)...
Success
```

### Delete the Container

To delete the remote logging demo container, run:

```bash
$ vhc hub container --delete ecfd7e83b757945ba9da76d86356738b386e6ddb9cfb17d490c2a884be5081ea
Deleting container ecfd7e83b757945ba9da76d86356738b386e6ddb9cfb17d490c2a884be5081ea from C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/ecfd7e83b757945ba9da76d86356738b386e6ddb9cfb17d490c2a884be5081ea)...
```

### Delete the Image

To delete the remote logging demo image, run:

```bash
$ vhc hub image --delete 39df6eb333c16f30e3efdb8de10e152eea30517b300bae7534bcfa6293f48157
Deleting image 39df6eb333c16f30e3efdb8de10e152eea30517b300bae7534bcfa6293f48157 from C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/images/39df6eb333c16f30e3efdb8de10e152eea30517b300bae7534bcfa6293f48157)...
```
