# VS Storage Example

- [VS Storage Example](#vs-storage-example)
  - [Basic Steps](#basic-steps)
  - [Prerequisites](#prerequisites)
  - [Setup Your Hub](#setup-your-hub)
    - [Pull Down the Application](#pull-down-the-application)
      - [Set the Container to Untrusted Mode](#set-the-container-to-untrusted-mode)
      - [Set the UUID](#set-the-uuid)
    - [Build the Image](#build-the-image)
    - [Create the Image](#create-the-image)
    - [Create the Container](#create-the-container)
    - [Manage the Container](#manage-the-container)
      - [Start the Container](#start-the-container)
      - [Browse the Container Webpage](#browse-the-container-webpage)
      - [Stop the Container](#stop-the-container)
      - [Delete the Container](#delete-the-container)
      - [Delete the Image](#delete-the-image)
      - [Attach to STDIO](#attach-to-stdio)
        - [Check directories](#check-directories)
  - [Example](#example)
    - [1. Build](#1-build)
    - [2. Create Image](#2-create-image)
    - [3. Create Container](#3-create-container)
    - [4. Start Container](#4-start-container)
    - [5. Attach to Container](#5-attach-to-container)
      - [Running the Example](#running-the-example)

## Basic Steps

1. build the image
2. upload image to your hub
3. create the container on the hub
4. run the container
5. attach to the running container
6. explore the external directories folder

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

To instantiate the Golang Web template application:

```bash
$ vhc new --template vh_storage_example
2019/07/03 12:00:00 Creating app from template vh_storage_example.
Using vh_storage_example
2019/07/01 12:00:00 Creating application directory: vh_storage_example
2019/07/01 12:00:00 vh_storage_example.zip downloaded
2019/07/01 12:00:00 Unzipping...
2019/07/01 12:00:00 Unzipped vh_storage_example.zip to vh_storage_example
```

Change to the Golang Web template directory:

```bash
cd vh_storage_example
```

#### Set the Container to Untrusted Mode

To set the container to run untrusted:

```bash
$ vhc secure --unauth-host
Project configuration modified. Please rebuild image(s).
```

#### Set the UUID

To generate a UUID automatically, run:

```bash
$ vhc secure --gen-uuid
Generated UUID: 4E42E803-431A-4208-95EF-48FA77C50850
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
$ vhc build --target vhc05 --unsigned
Making vh_storage_example image for vhc05 target...
Dockerfile.vhc05 does not exist.
Generating Dockerfile for Dockerfile.vhc05...
bin/vh_storage_example-armhf:1.0.0.tar does not exist.
Building vh_storage_example image for vhc05...
Command Started
Sending build context to Docker daemon   16.9kB
Step 1/22 : FROM golang:1.8-alpine as build
 ---> 4cb86d3661bf
Step 2/22 : RUN mkdir /app
 ---> Using cache
 ---> 21fc2dfe5cb5
Step 3/22 : COPY src/ /app/
 ---> 97cde54b87d9
Step 4/22 : WORKDIR /app
 ---> Running in 6452c7cc92ce
Removing intermediate container 6452c7cc92ce
 ---> 0aecd2609c11
Step 5/22 : RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm go build -a -o goapp
 ---> Running in 4eda7ef8512f
Removing intermediate container 4eda7ef8512f
 ---> 0c0ccce1f565
Step 6/22 : FROM arm32v7/busybox
 ---> 5186b901b1f7
Step 7/22 : EXPOSE 9500
 ---> Using cache
 ---> 5fe44103e877
Step 8/22 : ENV PORT 9500
 ---> Using cache
 ---> fbb41bf93c63
Step 9/22 : ENV WELCOME_MESSAGE Welcome to the VeeaHub platform!
 ---> Running in a1315a7a6c46
Removing intermediate container a1315a7a6c46
 ---> 63cd710c1627
Step 10/22 : WORKDIR /app/bin
 ---> Running in dcf3a6752d89
Removing intermediate container dcf3a6752d89
 ---> b03705d6f06b
Step 11/22 : COPY --from=build /app/goapp .
 ---> 48f13b9d1c5f
Step 12/22 : LABEL com.veea.vhc.target="vhc05"
 ---> Running in 54cdff7a4a8d
Removing intermediate container 54cdff7a4a8d
 ---> 881bec0f5526
Step 13/22 : LABEL com.veea.vhc.version="0.6.0"
 ---> Running in 5e060f24fa99
Removing intermediate container 5e060f24fa99
 ---> 7e41e6ad9d42
Step 14/22 : LABEL com.veea.vhc.app.name="vh golang web"
 ---> Running in ab8b6f06b835
Removing intermediate container ab8b6f06b835
 ---> e6833ebd7ac6
Step 15/22 : LABEL com.veea.vhc.app.version="1.0.0"
 ---> Running in 6651c1556ab2
Removing intermediate container 6651c1556ab2
 ---> 73dd838b0795
Step 16/22 : LABEL com.veea.vhc.config.proj.version="2"
 ---> Running in 069a9caf0c32
Removing intermediate container 069a9caf0c32
 ---> a19c3a57b0bf
Step 17/22 : LABEL com.veea.vhc.config.user.version="2"
 ---> Running in 295ef0e83e0c
Removing intermediate container 295ef0e83e0c
 ---> e9997bb9dc57
Step 18/22 : ARG PARTNER_ID
 ---> Running in 02cbbe5d9c6a
Removing intermediate container 02cbbe5d9c6a
 ---> 167fe971e496
Step 19/22 : LABEL com.veea.image.persistent_uuid="$PARTNER_ID-431A-4208-95EF-48FA77C50850"
 ---> Running in fefa63155817
Removing intermediate container fefa63155817
 ---> f833c22999f1
Step 20/22 : LABEL com.veea.authorisation.allowOnUnauthenticatedHost="true"
 ---> Running in 9334a2f2e4db
Removing intermediate container 9334a2f2e4db
 ---> 37b625db4a8f
Step 21/22 : LABEL com.veea.authorisation.feature1="DEVELOPER"
 ---> Running in 74088af69766
Removing intermediate container 74088af69766
 ---> b7ed835bd904
Step 22/22 : CMD ["/app/bin/goapp"]
 ---> Running in 6cf537665d39
Removing intermediate container 6cf537665d39
 ---> eaa0dacfcdf4
Successfully built eaa0dacfcdf4
Successfully tagged vh_storage_example-armhf:1.0.0


Saving vh_storage_example image for vhc05.
```

### Create the Image

To create the Golang Web image, run:

```bash
$ vhc hub image --create bin/vh_storage_example-armhf\:1.0.0.tar
Creating image push for file [bin/vh_storage_example-armhf:1.0.0.tar] on C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/images/push)...
 6.22 MB / 6.22 MB [=====================================================================] 100.00%
{
    "image_id": "c58e9d1261f548ed8e4a99e549cf5d6eca94a7dfeffb7191d4c7be2f732baa9f"
}
```

### Create the Container

To create the Golang Web container, run:

```bash
$ vhc hub image --create-container c58e9d1261f548ed8e4a99e549cf5d6eca94a7dfeffb7191d4c7be2f732baa9f
Creating container from image c58e9d1261f548ed8e4a99e549cf5d6eca94a7dfeffb7191d4c7be2f732baa9f on C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/images/c58e9d1261f548ed8e4a99e549cf5d6eca94a7dfeffb7191d4c7be2f732baa9f/create_container)...
 351 B / 351 B [=========================================================================] 100.00%
{
  "container_id": "9bf9e5ecf15330d6f1ece778e8c5e68f17381fe1bffcc2e348b0a3ec23e4f9a0",
  "detached": false
}
```

### Manage the Container

#### Start the Container

To start the Golang Web container, run:

```bash
 vhc hub container --start 9bf9e5ecf15330d6f1ece778e8c5e68f17381fe1bffcc2e348b0a3ec23e4f9a0
Starting container 9bf9e5ecf15330d6f1ece778e8c5e68f17381fe1bffcc2e348b0a3ec23e4f9a0 C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/9bf9e5ecf15330d6f1ece778e8c5e68f17381fe1bffcc2e348b0a3ec23e4f9a0/start)...
Success
```

#### Browse the Container Webpage

To browse the container's webpage, run:

```bash
$ curl C05BCB00C0A000001127:9500
<H1>Welcome to the VeeaHub platform!</H1> from path: /
```

Alternately, you can use a web browser.

#### Stop the Container

To stop the Golang Web container, run:

```bash
$ vhc hub container --stop 9bf9e5ecf15330d6f1ece778e8c5e68f17381fe1bffcc2e348b0a3ec23e4f9a0
Stopping container 9bf9e5ecf15330d6f1ece778e8c5e68f17381fe1bffcc2e348b0a3ec23e4f9a0 from C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/9bf9e5ecf15330d6f1ece778e8c5e68f17381fe1bffcc2e348b0a3ec23e4f9a0/stop)...
Success
```

#### Delete the Container

To delete the Golang Web container, run:

```bash
$ vhc hub container --delete 9bf9e5ecf15330d6f1ece778e8c5e68f17381fe1bffcc2e348b0a3ec23e4f9a0
Deleting container 9bf9e5ecf15330d6f1ece778e8c5e68f17381fe1bffcc2e348b0a3ec23e4f9a0 from C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/9bf9e5ecf15330d6f1ece778e8c5e68f17381fe1bffcc2e348b0a3ec23e4f9a0)...
```

#### Delete the Image

To delete the Golang Web image, run:

```bash
$ vhc hub image --delete c58e9d1261f548ed8e4a99e549cf5d6eca94a7dfeffb7191d4c7be2f732baa9f
Deleting image c58e9d1261f548ed8e4a99e549cf5d6eca94a7dfeffb7191d4c7be2f732baa9f from C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/images/c58e9d1261f548ed8e4a99e549cf5d6eca94a7dfeffb7191d4c7be2f732baa9f)...
```

#### Attach to STDIO

**NOTE:** It is recommended to use bash

To attach to stdio on the container, run:

```bash
$ vhc hub container --attach 74de3f949d4eb5251de623ed3e01fa35625b3d490564832b9aca627a2df94fc5 "/bin/sh -il"
Attaching to stdin/stdout/stderr on C05BCB00C0A000001127:9001...
Attaching to container 74de3f949d4eb5251de623ed3e01fa35625b3d490564832b9aca627a2df94fc5 C05BCB00C0A000001127:9000 (https://10.20.0.90:9000/containers/74de3f949d4eb5251de623ed3e01fa35625b3d490564832b9aca627a2df94fc5/attach)...
Success
```

Specifying `"/bin/ -il"` as the last argument to the command above drops VHC into a terminal-like state where the user can interact with the container, e.g.:

```bash
74de3f949d4e:/app$ /bin/sh: can't access tty; job control turned off
74de3f949d4e:/app$ ls
node_modules
package-lock.json
package.json
server.js
74de3f949d4e:/app$ pwd
/app
74de3f949d4e:/app$ exit
read tcp 10.211.55.3:53640->10.20.0.90:9001: use of closed network connection
read tcp 10.211.55.3:53638->10.20.0.90:9001: use of closed network connection
Detaching from container 74de3f949d4eb5251de623ed3e01fa35625b3d490564832b9aca627a2df94fc5 C05BCB00C0A000001127:9000 (https://10.20.0.90:9000/containers/74de3f949d4eb5251de623ed3e01fa35625b3d490564832b9aca627a2df94fc5/detach)...
Success
```

To exit the "terminal" enter either `exit` or hit `Ctrl+C` or `Ctrl+D`.

If you do not specify a command then the `attach` command will hook into the container's run-time stdio (i.e. any run-time output to stdout or stderr). Exit this mode of attach in the same manner as the previous example.

Notes:

- The process of attaching can take up to around 20 to 25 seconds to complete when running trusted.
- The `can't access tty` message above may be safely ignored.
- The `read tcp` messages above may be safely ignored.

##### Check directories

To check the contents of the directories you can use `bash` and `ls`

```bash
$ vhc hub container --attach 74de3f949d4eb5251de623ed3e01fa35625b3d490564832b9aca627a2df94fc5 "/bin/bash -il"
Attaching to stdin/stdout/stderr on C05BCB00C0A000001127:9001...
Attaching to container 74de3f949d4eb5251de623ed3e01fa35625b3d490564832b9aca627a2df94fc5 C05BCB00C0A000001127:9000 (https://10.20.0.90:9000/containers/74de3f949d4eb5251de623ed3e01fa35625b3d490564832b9aca627a2df94fc5/attach)...
Success
```

## Example

### 1. Build

```bash
$ vhc build
Making all targets...
Making vh_storage_example image for vhx09-10 target...
Dockerfile is newer than Dockerfile.vhx09-10.
Generating Dockerfile for Dockerfile.vhx09-10...
Dockerfile.vhx09-10 is newer than bin/vh_storage_example-arm64v8:1.0.0.tar.
Building vh_storage_example image for vhx09-10...
Command Started
Sending build context to Docker daemon  70.18MB
Step 1/19 : FROM balenalib/aarch64-alpine:latest
 ---> 439c44e5eecf
Step 2/19 : RUN mkdir /app
 ---> Using cache
 ---> 1e4e6e369eae
Step 3/19 : COPY src/ /app
 ---> 504baf26b507
Step 4/19 : RUN apk add --no-cache bash
 ---> Running in 93a0b2ef3282
fetch http://dl-cdn.alpinelinux.org/alpine/v3.12/main/aarch64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.12/community/aarch64/APKINDEX.tar.gz
OK: 32 MiB in 59 packages
Removing intermediate container 93a0b2ef3282
 ---> 5851cf952402
Step 5/19 : LABEL com.veea.authorisation.allowExternalStorage="true"
 ---> Running in f1bcf5ae8db0
Removing intermediate container f1bcf5ae8db0
 ---> af298be4c79a
Step 6/19 : ENV LOCALFILE="logo-veea-inc.png"
 ---> Running in 8170048a151e
Removing intermediate container 8170048a151e
 ---> 71a192a10243
Step 7/19 : RUN chmod 777 /app/${LOCALFILE}
 ---> Running in 830ec03b0120
Removing intermediate container 830ec03b0120
 ---> 405501e339d8
Step 8/19 : WORKDIR "/var/lib/veea/external_storage"
 ---> Running in 17c802a3581f
Removing intermediate container 17c802a3581f
 ---> 42feda32c950
Step 9/19 : LABEL com.veea.vhc.target="vhx09-10"
 ---> Running in 7211343b4c78
Removing intermediate container 7211343b4c78
 ---> 3fd3db83a4cc
Step 10/19 : LABEL com.veea.vhc.version="0.6.0"
 ---> Running in e375da88cca8
Removing intermediate container e375da88cca8
 ---> 2727fb3751d7
Step 11/19 : LABEL com.veea.vhc.app.name="vh storage example"
 ---> Running in ed14f8194433
Removing intermediate container ed14f8194433
 ---> 04d7d3a6ff05
Step 12/19 : LABEL com.veea.vhc.app.version="1.0.0"
 ---> Running in 1bc494887ead
Removing intermediate container 1bc494887ead
 ---> 2a2a93f0ce9c
Step 13/19 : LABEL com.veea.vhc.config.proj.version="2"
 ---> Running in 000d04e43d1e
Removing intermediate container 000d04e43d1e
 ---> d8973f98c838
Step 14/19 : LABEL com.veea.vhc.config.user.version="2"
 ---> Running in f3776670111c
Removing intermediate container f3776670111c
 ---> 38fdb7bc8051
Step 15/19 : ARG PARTNER_ID
 ---> Running in c95be636ae28
Removing intermediate container c95be636ae28
 ---> 5f780beca760
Step 16/19 : LABEL com.veea.image.persistent_uuid="$PARTNER_ID-0530-414E-A085-33EE1AB02E94"
 ---> Running in 139bb476068f
Removing intermediate container 139bb476068f
 ---> d536e7bc3224
Step 17/19 : LABEL com.veea.authorisation.allowOnUnauthenticatedHost="true"
 ---> Running in fac0f3ddfaf6
Removing intermediate container fac0f3ddfaf6
 ---> f816428af50b
Step 18/19 : LABEL com.veea.authorisation.feature1="DEVELOPER"
 ---> Running in 3fd1f9bff3c8
Removing intermediate container 3fd1f9bff3c8
 ---> a7d68f8db8fa
Step 19/19 : CMD ["/bin/bash", "/app/loop.sh"]
 ---> Running in 646b70290ab5
Removing intermediate container 646b70290ab5
 ---> a8547587eb36
Successfully built a8547587eb36
Successfully tagged vh_storage_example-arm64v8:1.0.0


Saving vh_storage_example image for vhx09-10.
Making vh_storage_example image for vhc05 target...
Dockerfile is newer than Dockerfile.vhc05.
Generating Dockerfile for Dockerfile.vhc05...
Dockerfile.vhc05 is newer than bin/vh_storage_example-armhf:1.0.0.tar.
Building vh_storage_example image for vhc05...
Command Started
Sending build context to Docker daemon   70.2MB
Step 1/19 : FROM balenalib/armv7hf-alpine:latest
 ---> a12ead335de1
Step 2/19 : RUN mkdir /app
 ---> Using cache
 ---> 7a5c9be45a1f
Step 3/19 : COPY src/ /app
 ---> 95ae356445bd
Step 4/19 : RUN apk add --no-cache bash
 ---> Running in 72db38e081a1
fetch http://dl-cdn.alpinelinux.org/alpine/v3.12/main/armv7/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.12/community/armv7/APKINDEX.tar.gz
OK: 22 MiB in 60 packages
Removing intermediate container 72db38e081a1
 ---> f8f32c5bc629
Step 5/19 : LABEL com.veea.authorisation.allowExternalStorage="true"
 ---> Running in cbe4d0a99faf
Removing intermediate container cbe4d0a99faf
 ---> 269336530a26
Step 6/19 : ENV LOCALFILE="logo-veea-inc.png"
 ---> Running in 58df2c7f657c
Removing intermediate container 58df2c7f657c
 ---> e7e4269800b1
Step 7/19 : RUN chmod 777 /app/${LOCALFILE}
 ---> Running in 3c7c9f235cf1
Removing intermediate container 3c7c9f235cf1
 ---> 2bb6bc14aaf2
Step 8/19 : WORKDIR "/var/lib/veea/external_storage"
 ---> Running in 5f54cb41df6f
Removing intermediate container 5f54cb41df6f
 ---> 808dca1f7b7a
Step 9/19 : LABEL com.veea.vhc.target="vhc05"
 ---> Running in 0cf6ef8ab6da
Removing intermediate container 0cf6ef8ab6da
 ---> 8a7151661dd0
Step 10/19 : LABEL com.veea.vhc.version="0.6.0"
 ---> Running in 0b5c97bda4f7
Removing intermediate container 0b5c97bda4f7
 ---> a619b74b1fc3
Step 11/19 : LABEL com.veea.vhc.app.name="vh storage example"
 ---> Running in b1d0e6cccb36
Removing intermediate container b1d0e6cccb36
 ---> 49609129481a
Step 12/19 : LABEL com.veea.vhc.app.version="1.0.0"
 ---> Running in df43fcc4475c
Removing intermediate container df43fcc4475c
 ---> 948e95367a27
Step 13/19 : LABEL com.veea.vhc.config.proj.version="2"
 ---> Running in 25d3404b3605
Removing intermediate container 25d3404b3605
 ---> 7c43ec7eb5cd
Step 14/19 : LABEL com.veea.vhc.config.user.version="2"
 ---> Running in ae878f7b984e
Removing intermediate container ae878f7b984e
 ---> 5180c32215f7
Step 15/19 : ARG PARTNER_ID
 ---> Running in 5b208c78a93f
Removing intermediate container 5b208c78a93f
 ---> c4e01d2126ca
Step 16/19 : LABEL com.veea.image.persistent_uuid="$PARTNER_ID-0530-414E-A085-33EE1AB02E94"
 ---> Running in e0c4241a9c13
Removing intermediate container e0c4241a9c13
 ---> f75b9a9f7b59
Step 17/19 : LABEL com.veea.authorisation.allowOnUnauthenticatedHost="true"
 ---> Running in 7dce674fd133
Removing intermediate container 7dce674fd133
 ---> c6c0e3d16f26
Step 18/19 : LABEL com.veea.authorisation.feature1="DEVELOPER"
 ---> Running in 3800d75af954
Removing intermediate container 3800d75af954
 ---> 468f71ee0cb3
Step 19/19 : CMD ["/bin/bash", "/app/loop.sh"]
 ---> Running in e96a2c7b152f
Removing intermediate container e96a2c7b152f
 ---> b36ad0908bb3
Successfully built b36ad0908bb3
Successfully tagged vh_storage_example-armhf:1.0.0


Saving vh_storage_example image for vhc05.
Making release for vh_storage_example...
ERROR: Image 'bin/vh_storage_example-arm64v8:1.0.0-metadata.json' metadata does not exist.

```

### 2. Create Image

```bash
$ vhc hub image --create bin/vh_storage_example-arm64v8\:1.0.0.tar
Creating image push for file [bin/vh_storage_example-arm64v8:1.0.0.tar] on E09CCW00C0B000001277:9000 (https://192.168.1.3:9000/images/push)...
 40.21 MB / 40.21 MB [===========================================================================================================================================================] 100.00%
{"image_id": "a8547587eb368cd92f0c35fda54f2bac5275de98244a1bb0f3f416899facfb23"}
```

### 3. Create Container

```bash
$ vhc hub image --create-container a8547587eb368cd92f0c35fda54f2bac5275de98244a1bb0f3f416899facfb23
Creating container from image a8547587eb368cd92f0c35fda54f2bac5275de98244a1bb0f3f416899facfb23 on E09CCW00C0B000001277:9000 (https://192.168.1.3:9000/images/a8547587eb368cd92f0c35fda54f2bac5275de98244a1bb0f3f416899facfb23/create_container)...
 322 B / 322 B [=================================================================================================================================================================] 100.00%
{
  "container_id": "64183d2e3b126c087f921fb4809b998ee539aff89c354bee6981201fc7dff8a2",
  "detached": false
}
```

### 4. Start Container

```bash
$ vhc hub container --start 64183d2e3b126c087f921fb4809b998ee539aff89c354bee6981201fc7dff8a2
Starting container 64183d2e3b126c087f921fb4809b998ee539aff89c354bee6981201fc7dff8a2 E09CCW00C0B000001277:9000 (https://192.168.1.3:9000/containers/64183d2e3b126c087f921fb4809b998ee539aff89c354bee6981201fc7dff8a2/start)...
Success
```

### 5. Attach to Container

#### Running the Example

Commands used in the example below.

> ls
>
> /bin/bash /app/storage-example.sh
>
> ls /var/lib/veea/external_storage/sda1/64183d2e3b12
>
> exit

```bash
$ vhc hub container --attach 64183d2e3b126c087f921fb4809b998ee539aff89c354bee6981201fc7dff8a2 /bin/bash
Attaching to stdin/stdout/stderr on E09CCW00C0B000001277:9001...
Attaching to container 64183d2e3b126c087f921fb4809b998ee539aff89c354bee6981201fc7dff8a2 E09CCW00C0B000001277:9000 (https://192.168.1.3:9000/containers/64183d2e3b126c087f921fb4809b998ee539aff89c354bee6981201fc7dff8a2/attach)...
Success
ls
sda1

/bin/bash /app/storage-example.sh
vh storage example
Running on 64183d2e3b12

Checking devices: /var/lib/veea/external_storage/mmcblk1p1 /var/lib/veea/external_storage/sda1 /var/lib/veea/external_storage/sdb1 /var/lib/veea/external_storage/sdc1
/var/lib/veea/external_storage/mmcblk1p1 not found!
/var/lib/veea/external_storage/sdb1 not found!
/var/lib/veea/external_storage/sdc1 not found!

Found Storage: /var/lib/veea/external_storage/sda1

Checking Directories...
making /var/lib/veea/external_storage/sda1/64183d2e3b12

Testing file creation...
Writing to /var/lib/veea/external_storage/sda1/64183d2e3b12/helloworld.txt
Result:
Hello, World!
EOF


Testing file copy...
Copying logo-veea-inc.png -> /var/lib/veea/external_storage/sda1/64183d2e3b12/logo-veea-inc.png
Contents of  /var/lib/veea/external_storage/sda1/64183d2e3b12:
helloworld.txt
logo-veea-inc.png

ls /var/lib/veea/external_storage/sda1/64183d2e3b12
helloworld.txt
logo-veea-inc.png

exit
read tcp 10.0.3.15:33946->192.168.1.3:9001: use of closed network connection
read tcp 10.0.3.15:33944->192.168.1.3:9001: use of closed network connection
Detaching from container 64183d2e3b126c087f921fb4809b998ee539aff89c354bee6981201fc7dff8a2 E09CCW00C0B000001277:9000 (https://192.168.1.3:9000/containers/64183d2e3b126c087f921fb4809b998ee539aff89c354bee6981201fc7dff8a2/detach)...
Success
```
