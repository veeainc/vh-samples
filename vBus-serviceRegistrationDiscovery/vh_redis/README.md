Redis Server
===========================================

## Objective:

The objective of this project is to start the Redis-Server and handle all the Redis requests

Note: For the following commands, please substitute your hub serial number, IP address, UUID, image ID, and container ID as appropriate.


## Build the Image

Now, use the following command to build the image.

```bash
vhc build --target vhc05 --unsigned      #for VHC05 hub
vhc build --target vhx09-10 --unsigned   #for VHE09/VHE10 hub
```
You can use ```--no-cache``` for removing the existing cache before build.

To build the image for the VHC05 target, run:

```bash
$ vhc build --target vhc05 --unsigned
Building vh_redis image for vhc05...
Command Started
Sending build context to Docker daemon  23.04kB
Step 1/22 : FROM arm32v7/alpine:3.11.2
 ---> 04eaa5c00efc
Step 2/22 : ENV ARCH="arm-"
 ---> Using cache
 ---> 4bed83188434
Step 3/22 : RUN apk --no-cache update
 ---> Using cache
 ---> 897488aba9ad
Step 4/22 : RUN apk add redis wget curl jq
 ---> Using cache
 ---> 0f5945d98666
Step 5/22 : RUN sed -i 's/protected-mode yes/protected-mode no/g' /etc/redis.conf && 	sed -i 's/save 900 1/save 60 1/g' /etc/redis.conf && 	sed -i 's/bind 127.0.0.1/#bind 127.0.0.1/g' /etc/redis.conf && 	sed -i 's/unixsocket /#unixsocket /g' /etc/redis.conf && 	sed -i 's/unixsocketperm /#unixsocketperm /g' /etc/redis.conf && 	sed -i 's#logfile /var/log/redis/redis.log#logfile /var/lib/veea/redisdata/redis-server.log #g' /etc/redis.conf && 	sed -i 's#dir /var/lib/redis#dir /var/lib/veea/redisdata #g' /etc/redis.conf
 ---> Using cache
 ---> 2ddc41829caa
Step 6/22 : WORKDIR /app
 ---> Using cache
 ---> ff40a81447f9
Step 7/22 : COPY src/ /app
 ---> f46aff94ad27
Step 8/22 : RUN wget -q $(curl -s https://api.github.com/repos/veeainc/vbus-cmd/releases/tags/v1.4.4 | grep browser_download_url | grep "$ARCH" | cut -d '"' -f 4) && mv "elf-linux-"$ARCH"vbus-cmd" /usr/bin/vbus-cmd && 	chmod 777 /usr/bin/vbus-cmd && 	chmod -R 777 /app
 ---> Running in 9132a9cb049c
Removing intermediate container 9132a9cb049c
 ---> defc99acd0de
Step 9/22 : ENV VBUS_PATH=/var/lib/veea/vbus
 ---> Running in 60206b7feabd
Removing intermediate container 60206b7feabd
 ---> 8c6a3ec2a074
Step 10/22 : EXPOSE 6379
 ---> Running in a7ffaa76e068
Removing intermediate container a7ffaa76e068
 ---> 9c3108b0686e
Step 11/22 : LABEL com.veea.vhc.target="vhc05"
 ---> Running in 76e899125e4f
Removing intermediate container 76e899125e4f
 ---> 4de83d4aecd7
Step 12/22 : LABEL com.veea.vhc.version="0.6.0"
 ---> Running in fb88ff460319
Removing intermediate container fb88ff460319
 ---> 3cd4e4a17ecd
Step 13/22 : LABEL com.veea.vhc.app.name="vh_redis"
 ---> Running in d2a6d1b6bec4
Removing intermediate container d2a6d1b6bec4
 ---> 7e43b7b3ed5f
Step 14/22 : LABEL com.veea.vhc.app.version="1.0.0"
 ---> Running in 4e63be28c329
Removing intermediate container 4e63be28c329
 ---> 792c2bfece69
Step 15/22 : LABEL com.veea.vhc.config.proj.version="2"
 ---> Running in 8baf37325a72
Removing intermediate container 8baf37325a72
 ---> f44384545b5b
Step 16/22 : LABEL com.veea.vhc.config.user.version="2"
 ---> Running in a5c78684d7d2
Removing intermediate container a5c78684d7d2
 ---> ec0c5c1a6cbc
Step 17/22 : ARG PARTNER_ID
 ---> Running in 0d2df1989a8b
Removing intermediate container 0d2df1989a8b
 ---> c0509990e461
Step 18/22 : LABEL com.veea.image.persistent_uuid="$PARTNER_ID-BA5E-5EED-C0DE-000000000203"
 ---> Running in 445a6e63950a
Removing intermediate container 445a6e63950a
 ---> f6ea69284a20
Step 19/22 : LABEL com.veea.authorisation.allowOnUnauthenticatedHost="true"
 ---> Running in 2db3d6e8a6a1
Removing intermediate container 2db3d6e8a6a1
 ---> 76d2e5435774
Step 20/22 : LABEL com.veea.authorisation.volumes.persist1="redisdata"
 ---> Running in 129060f48f1e
Removing intermediate container 129060f48f1e
 ---> a8a1777392c9
Step 21/22 : LABEL com.veea.authorisation.volumes.persist2="vbus"
 ---> Running in 23dad81a8ddf
Removing intermediate container 23dad81a8ddf
 ---> ab3d4fbcc4df
Step 22/22 : CMD ["/app/start.sh"]
 ---> Running in 30e719f302db
Removing intermediate container 30e719f302db
 ---> 913fc07c8017
Successfully built 913fc07c8017
Successfully tagged vh_redis-armhf:1.0.0

```

## Create the Image

To create the vh_redis image, run:

```bash
$ vhc hub image --create bin/vh_redis-armhf\:1.0.0.tar
Creating image push for file [bin/vh_redis-armhf:1.0.0.tar] on C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/images/push)...
 18.83 MB / 18.83 MB [===================================================================] 100.00%
{
    "image_id": "5272d358e880674e15079ce79f362190c268e0b04894e06e7ddedca6274bf8dd"
}
```

## Create the Container

To create the vh_redis container, run:

```bash
$ vhc hub image --create-container 5272d358e880674e15079ce79f362190c268e0b04894e06e7ddedca6274bf8dd
Creating container from image 5272d358e880674e15079ce79f362190c268e0b04894e06e7ddedca6274bf8dd on C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/images/5272d358e880674e15079ce79f362190c268e0b04894e06e7ddedca6274bf8dd/create_container)...
 322 B / 322 B [=========================================================================] 100.00%
{
  "container_id": "8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b",
  "detached": false
}
```

## Start the Container

To start the vh_redis container, run:

```bash
$ vhc hub container --start 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b
Starting container 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b/start)...
Success
```

## Attach to the Container (No Console)

To attach to the vh_redis container *without* a console run the following command. The output will display "sleeping..." because the container entrypoint is an infinite loop so that you can access `interpreter.py` in the next step

```bash
$ vhc hub container --attach 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b
Attaching to stdin/stdout/stderr on C05BCB00C0A000001127:9001...
Attaching to container 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b/attach)...
Success
sleeping...
sleeping...
```

To detach from the vh_redis container, enter `exit` or hit `Ctrl+C` or `Ctrl+D`:

```bash
read tcp 10.211.55.4:44312->10.20.1.96:9001: use of closed network connection
read tcp 10.211.55.4:44310->10.20.1.96:9001: use of closed network connection
Detaching from container f2b2ed6c52ee0594b175a8ce4cc4333a5da45d769c62b90a7a14c0921a57c9b6 c05bcba0c0a000001445:9000 (https://10.20.1.96:9000/containers/f2b2ed6c52ee0594b175a8ce4cc4333a5da45d769c62b90a7a14c0921a57c9b6/detach)...
Success
```

Note: The `read tcp` messages may be safely ignored.

## Attach to the Container (Console)

To attach to the vh_redis container *with* a console run the following command:

```bash
$ vhc hub container --attach 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b "/bin/sh -il"
Attaching to stdin/stdout/stderr on C05BCB00C0A000001127:9001...
Attaching to container 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b/attach)...
Success
```


To detach from the vh_redis container, enter `exit` or hit `Ctrl+C` or `Ctrl+D`:

```bash
read tcp 10.211.55.9:54894->10.20.0.89:9001: use of closed network connection
read tcp 10.211.55.9:54892->10.20.0.89:9001: use of closed network connection
Detaching from container 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b/detach)...
Success
```

Notes:
- The prompt prefix is the first 12 characters of the container ID.
- The `can't access tty` message above may be safely ignored.
- As above, the `read tcp` messages may be safely ignored.

## Stop the Container

To stop the vh_redis container, run:

```bash
$ vhc hub container --stop 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b
Stopping container 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b from C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b/stop)...
Success
```

## Delete the Container

To delete the vh_redis container, run:

```bash
$ vhc hub container --delete 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b
Deleting container 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b from C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b)...
```

## Delete the Image

To delete the vh_redis image, run:

```bash
$ vhc hub image --delete 5272d358e880674e15079ce79f362190c268e0b04894e06e7ddedca6274bf8dd
Deleting image 5272d358e880674e15079ce79f362190c268e0b04894e06e7ddedca6274bf8dd from C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/images/5272d358e880674e15079ce79f362190c268e0b04894e06e7ddedca6274bf8dd)...
```

