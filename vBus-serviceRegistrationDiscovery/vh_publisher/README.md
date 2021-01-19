Publisher
===========================================

## Objective:

The objective of this project is to increment and set the mycounter value to Redis at a particular set interval

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
Building vh_publisher image for vhc05...
Command Started
Sending build context to Docker daemon  20.99kB
Step 1/19 : FROM arm32v7/alpine:3.9
 ---> 9df0ff5446fc
Step 2/19 : ENV ARCH="arm-"
 ---> Using cache
 ---> 1192203826d4
Step 3/19 : WORKDIR /app
 ---> Using cache
 ---> 0f227303a782
Step 4/19 : COPY src/ /app/
 ---> c3526ea2948e
Step 5/19 : RUN apk --update --no-cache add wget curl redis
 ---> Running in 620441b83728
fetch http://dl-cdn.alpinelinux.org/alpine/v3.9/main/armv7/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.9/community/armv7/APKINDEX.tar.gz
(1/8) Installing ca-certificates (20191127-r2)
(2/8) Installing nghttp2-libs (1.35.1-r2)
(3/8) Installing libssh2 (1.9.0-r1)
(4/8) Installing libcurl (7.64.0-r5)
(5/8) Installing curl (7.64.0-r5)
(6/8) Installing libgcc (8.3.0-r0)
(7/8) Installing redis (4.0.14-r0)
Executing redis-4.0.14-r0.pre-install
Executing redis-4.0.14-r0.post-install
(8/8) Installing wget (1.20.3-r0)
Executing busybox-1.29.3-r10.trigger
Executing ca-certificates-20191127-r2.trigger
OK: 6 MiB in 22 packages
Removing intermediate container 620441b83728
 ---> 7f2b2c24e0cb
Step 6/19 : RUN wget -q $(curl -s https://api.github.com/repos/veeainc/vbus-cmd/releases/latest | grep browser_download_url | grep "$ARCH" | cut -d '"' -f 4) && 	mv "elf-linux-"$ARCH"vbus-cmd" /usr/bin/vbus-cmd && 	chmod 777 /usr/bin/vbus-cmd && 	chmod -R 777 /app
 ---> Running in b2c2647f6800
Removing intermediate container b2c2647f6800
 ---> 7745ac505adb
Step 7/19 : ENV VBUS_PATH=/var/lib/veea/vbus
 ---> Running in 87eb0d420664
Removing intermediate container 87eb0d420664
 ---> d7aada9ab86c
Step 8/19 : LABEL com.veea.vhc.target="vhc05"
 ---> Running in 0e7eaa5f19c2
Removing intermediate container 0e7eaa5f19c2
 ---> 86192e95ccb3
Step 9/19 : LABEL com.veea.vhc.version="0.6.0"
 ---> Running in 024f24c6f78a
Removing intermediate container 024f24c6f78a
 ---> f10ccded4c72
Step 10/19 : LABEL com.veea.vhc.app.name="vh_publisher"
 ---> Running in 540f1fc6c8df
Removing intermediate container 540f1fc6c8df
 ---> dd157caf6eea
Step 11/19 : LABEL com.veea.vhc.app.version="1.0.0"
 ---> Running in f27675945920
Removing intermediate container f27675945920
 ---> a4abee2927a2
Step 12/19 : LABEL com.veea.vhc.config.proj.version="2"
 ---> Running in 1b572b1178d4
Removing intermediate container 1b572b1178d4
 ---> ba3ae18af49b
Step 13/19 : LABEL com.veea.vhc.config.user.version="2"
 ---> Running in 9672aa73cf0e
Removing intermediate container 9672aa73cf0e
 ---> eb151c5548ce
Step 14/19 : ARG PARTNER_ID
 ---> Running in c35e2cefa869
Removing intermediate container c35e2cefa869
 ---> cba947c81284
Step 15/19 : LABEL com.veea.image.persistent_uuid="$PARTNER_ID-196E-4492-BE64-C4BCDE3EFC3C"
 ---> Running in 106022e2127b
Removing intermediate container 106022e2127b
 ---> 5738908855b8
Step 16/19 : LABEL com.veea.authorisation.allowOnUnauthenticatedHost="true"
 ---> Running in 05e496baadb4
Removing intermediate container 05e496baadb4
 ---> 98508f7aad46
Step 17/19 : LABEL com.veea.authorisation.feature1="DEVELOPER"
 ---> Running in 304d11161259
Removing intermediate container 304d11161259
 ---> 0fe2b276cef9
Step 18/19 : LABEL com.veea.authorisation.volumes.persist1="vbus"
 ---> Running in 93b88540142b
Removing intermediate container 93b88540142b
 ---> 478d2166f50c
Step 19/19 : CMD ["/app/start.sh"]
 ---> Running in c950fd6d4b7a
Removing intermediate container c950fd6d4b7a
 ---> 9f2ceea2337c
Successfully built 9f2ceea2337c
Successfully tagged vh_publisher-armhf:1.0.0

```

## Create the Image

To create the vh_publisher image, run:

```bash
$ vhc hub image --create bin/vh_publisher-armhf\:1.0.0.tar
Creating image push for file [bin/vh_publisher-armhf:1.0.0.tar] on C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/images/push)...
 16.26 MB / 16.26 MB [===================================================================] 100.00%
{
    "image_id": "5272d358e880674e15079ce79f362190c268e0b04894e06e7ddedca6274bf8dd"
}
```

## Create the Container

To create the vh_publisher container, run:

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

To start the vh_publisher container, run:

```bash
$ vhc hub container --start 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b
Starting container 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b/start)...
Success
```

## Attach to the Container (No Console)

To attach to the vh_publisher container *without* a console run the following command. The output will display "sleeping..." because the container entrypoint is an infinite loop so that you can access `interpreter.py` in the next step

```bash
$ vhc hub container --attach 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b
Attaching to stdin/stdout/stderr on C05BCB00C0A000001127:9001...
Attaching to container 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b/attach)...
Success
sleeping...
sleeping...
```

To detach from the vh_publisher container, enter `exit` or hit `Ctrl+C` or `Ctrl+D`:

```bash
read tcp 10.211.55.4:44312->10.20.1.96:9001: use of closed network connection
read tcp 10.211.55.4:44310->10.20.1.96:9001: use of closed network connection
Detaching from container f2b2ed6c52ee0594b175a8ce4cc4333a5da45d769c62b90a7a14c0921a57c9b6 c05bcba0c0a000001445:9000 (https://10.20.1.96:9000/containers/f2b2ed6c52ee0594b175a8ce4cc4333a5da45d769c62b90a7a14c0921a57c9b6/detach)...
Success
```

Note: The `read tcp` messages may be safely ignored.

## Attach to the Container (Console)

To attach to the vh_publisher container *with* a console run the following command:

```bash
$ vhc hub container --attach 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b "/bin/sh -il"
Attaching to stdin/stdout/stderr on C05BCB00C0A000001127:9001...
Attaching to container 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b/attach)...
Success
```


To detach from the vh_publisher container, enter `exit` or hit `Ctrl+C` or `Ctrl+D`:

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

To stop the vh_publisher container, run:

```bash
$ vhc hub container --stop 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b
Stopping container 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b from C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b/stop)...
Success
```

## Delete the Container

To delete the vh_publisher container, run:

```bash
$ vhc hub container --delete 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b
Deleting container 8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b from C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/8fad7bebdcfcdbe142884ff93ed2696d8c2460803cae015a49af811d04e5476b)...
```

## Delete the Image

To delete the vh_publisher image, run:

```bash
$ vhc hub image --delete 5272d358e880674e15079ce79f362190c268e0b04894e06e7ddedca6274bf8dd
Deleting image 5272d358e880674e15079ce79f362190c268e0b04894e06e7ddedca6274bf8dd from C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/images/5272d358e880674e15079ce79f362190c268e0b04894e06e7ddedca6274bf8dd)...
```

