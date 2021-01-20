Consumer of Redis
===========================================

## Objective:

The objective of this project is to get the mycounter value from Redis which is set by the vh_publisher
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
Building vh_consumer image for vhc05...
Command Started
Sending build context to Docker daemon  30.72kB
Step 1/19 : FROM arm32v7/alpine:3.9
 ---> 9df0ff5446fc
Step 2/19 : ENV ARCH="arm-"
 ---> Using cache
 ---> 1192203826d4
Step 3/19 : WORKDIR /app
 ---> Using cache
 ---> 0f227303a782
Step 4/19 : COPY src/ /app/
 ---> aed10dbda0eb
Step 5/19 : RUN apk --update --no-cache add wget curl jq redis
 ---> Running in 31f8d7caf59f
fetch http://dl-cdn.alpinelinux.org/alpine/v3.9/main/armv7/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.9/community/armv7/APKINDEX.tar.gz
(1/10) Installing ca-certificates (20191127-r2)
(2/10) Installing nghttp2-libs (1.35.1-r2)
(3/10) Installing libssh2 (1.9.0-r1)
(4/10) Installing libcurl (7.64.0-r5)
(5/10) Installing curl (7.64.0-r5)
(6/10) Installing oniguruma (6.9.4-r1)
(7/10) Installing jq (1.6-r0)
(8/10) Installing libgcc (8.3.0-r0)
(9/10) Installing redis (4.0.14-r0)
Executing redis-4.0.14-r0.pre-install
Executing redis-4.0.14-r0.post-install
(10/10) Installing wget (1.20.3-r0)
Executing busybox-1.29.3-r10.trigger
Executing ca-certificates-20191127-r2.trigger
OK: 7 MiB in 24 packages
Removing intermediate container 31f8d7caf59f
 ---> d2098d9fa31c
Step 6/19 : RUN wget -q $(curl -s https://api.github.com/repos/veeainc/vbus-cmd/releases/latest | grep browser_download_url | grep "$ARCH" | cut -d '"' -f 4) && 	mv "elf-linux-"$ARCH"vbus-cmd" /usr/bin/vbus-cmd && 	chmod 777 /usr/bin/vbus-cmd && 	chmod -R 777 /app
 ---> Running in 8f184a3086b4
Removing intermediate container 8f184a3086b4
 ---> 5a20fd703ee5
Step 7/19 : ENV VBUS_PATH=/var/lib/veea/vbus
 ---> Running in 3092e9080714
Removing intermediate container 3092e9080714
 ---> 1f056f057788
Step 8/19 : LABEL com.veea.vhc.target="vhc05"
 ---> Running in d8709753e7ef
Removing intermediate container d8709753e7ef
 ---> 47e2e47caa3d
Step 9/19 : LABEL com.veea.vhc.version="0.6.0"
 ---> Running in d144f6f3b2b5
Removing intermediate container d144f6f3b2b5
 ---> b90207f1d29c
Step 10/19 : LABEL com.veea.vhc.app.name="vh_consumer"
 ---> Running in 0cd82d155854
Removing intermediate container 0cd82d155854
 ---> 2c847573494b
Step 11/19 : LABEL com.veea.vhc.app.version="1.0.0"
 ---> Running in c02da27866cb
Removing intermediate container c02da27866cb
 ---> a0bd967402fa
Step 12/19 : LABEL com.veea.vhc.config.proj.version="2"
 ---> Running in de792893af7d
Removing intermediate container de792893af7d
 ---> 79017166646d
Step 13/19 : LABEL com.veea.vhc.config.user.version="2"
 ---> Running in 8b6f978757aa
Removing intermediate container 8b6f978757aa
 ---> f3e97e32a179
Step 14/19 : ARG PARTNER_ID
 ---> Running in 235e6f16f1ee
Removing intermediate container 235e6f16f1ee
 ---> f19e4d86b6bf
Step 15/19 : LABEL com.veea.image.persistent_uuid="$PARTNER_ID-859C-42FC-867A-6186B44FCDFC"
 ---> Running in 18d4f8fbd647
Removing intermediate container 18d4f8fbd647
 ---> 7f14ec86ae90
Step 16/19 : LABEL com.veea.authorisation.allowOnUnauthenticatedHost="true"
 ---> Running in 4c743a693c27
Removing intermediate container 4c743a693c27
 ---> 13b951be0dd1
Step 17/19 : LABEL com.veea.authorisation.feature1="DEVELOPER"
 ---> Running in 469ca15a414b
Removing intermediate container 469ca15a414b
 ---> 0f32ae2e5e89
Step 18/19 : LABEL com.veea.authorisation.volumes.persist1="vbus"
 ---> Running in 4bcfcebc094d
Removing intermediate container 4bcfcebc094d
 ---> 76bb088109c4
Step 19/19 : CMD ["/app/start.sh"]
 ---> Running in 4994dc712338
Removing intermediate container 4994dc712338
 ---> 97fbed6ad401
Successfully built 97fbed6ad401
Successfully tagged vh_consumer-armhf:1.0.0
```

## Create the Image

To create the vh_consumer image, run:

```bash
$ vhc hub image --create bin/vh_consumer-armhf\:1.0.0.tar
Creating image push for file [bin/vh_consumer-armhf:1.0.0.tar] on C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/images/push)...
 17.14 MB / 17.14 MB [===================================================================] 100.00%
{
    "image_id": "5272d358e880674e15079ce79f362190c268e0b04894e06e7ddedca6274bf8dd"
}
```

## Create the Container

To create the vh_consumer container, run:

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

To start the vh_consumer container, run:

```bash
$ vhc hub container --start 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b
Starting container 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b/start)...
Success
```

## Attach to the Container (No Console)

To attach to the vh_consumer container *without* a console run the following command. The output will display "sleeping..." because the container entrypoint is an infinite loop so that you can access `interpreter.py` in the next step

```bash
$ vhc hub container --attach 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b
Attaching to stdin/stdout/stderr on C05BCB00C0A000001127:9001...
Attaching to container 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b/attach)...
Success
sleeping...
sleeping...
```

To detach from the vh_consumer container, enter `exit` or hit `Ctrl+C` or `Ctrl+D`:

```bash
read tcp 10.211.55.4:44312->10.20.1.96:9001: use of closed network connection
read tcp 10.211.55.4:44310->10.20.1.96:9001: use of closed network connection
Detaching from container f2b2ed6c52ee0594b175a8ce4cc4333a5da45d769c62b90a7a14c0921a57c9b6 c05bcba0c0a000001445:9000 (https://10.20.1.96:9000/containers/f2b2ed6c52ee0594b175a8ce4cc4333a5da45d769c62b90a7a14c0921a57c9b6/detach)...
Success
```

Note: The `read tcp` messages may be safely ignored.

## Attach to the Container (Console)

To attach to the vh_consumer container *with* a console run the following command:

```bash
$ vhc hub container --attach 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b "/bin/sh -il"
Attaching to stdin/stdout/stderr on C05BCB00C0A000001127:9001...
Attaching to container 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b/attach)...
Success
```


To detach from the vh_consumer container, enter `exit` or hit `Ctrl+C` or `Ctrl+D`:

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

To stop the vh_consumer container, run:

```bash
$ vhc hub container --stop 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b
Stopping container 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b from C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b/stop)...
Success
```

## Delete the Container

To delete the vh_consumer container, run:

```bash
$ vhc hub container --delete 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b
Deleting container 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b from C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b)...
```

## Delete the Image

To delete the vh_consumer image, run:

```bash
$ vhc hub image --delete 5272d358e880674e15079ce79f362190c268e0b04894e06e7ddedca6274bf8dd
Deleting image 5272d358e880674e15079ce79f362190c268e0b04894e06e7ddedca6274bf8dd from C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/images/5272d358e880674e15079ce79f362190c268e0b04894e06e7ddedca6274bf8dd)...
```

