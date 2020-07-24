# VS Storage Example

## Basic Steps:

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
$ vhc hub --add-hub 1:<serial-number>:<ipv4-addr>
```

where `1` is the hub ID. With a single hub configured there is no need to specify the hub ID via the `--hub-id` or `--active-hub` options. The commands below assume a single hub configuration.

Make sure you can talk to the hub:

```bash
$ vhc hub --ping
Located hub 10.20.0.89 via IP address.
Pinging C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/ping)...
Success
```

## Pull Down the Application

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
$ cd vh_storage_example
```

## Set the Container to Untrusted Mode

To set the container to run untrusted:

```bash
$ vhc secure --unauth-host
Project configuration modified. Please rebuild image(s).
```

## Set the UUID

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

## Build the Image

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

## Create the Image

To create the Golang Web image, run:

```bash
$ vhc hub image --create bin/vh_storage_example-armhf\:1.0.0.tar
Creating image push for file [bin/vh_storage_example-armhf:1.0.0.tar] on C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/images/push)...
 6.22 MB / 6.22 MB [=====================================================================] 100.00%
{
    "image_id": "c58e9d1261f548ed8e4a99e549cf5d6eca94a7dfeffb7191d4c7be2f732baa9f"
}
```

## Create the Container

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

## Start the Container

To start the Golang Web container, run:

```bash
 vhc hub container --start 9bf9e5ecf15330d6f1ece778e8c5e68f17381fe1bffcc2e348b0a3ec23e4f9a0
Starting container 9bf9e5ecf15330d6f1ece778e8c5e68f17381fe1bffcc2e348b0a3ec23e4f9a0 C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/9bf9e5ecf15330d6f1ece778e8c5e68f17381fe1bffcc2e348b0a3ec23e4f9a0/start)...
Success
```

## Browse the Container Webpage

To browse the container's webpage, run:

```bash
$ curl C05BCB00C0A000001127:9500
<H1>Welcome to the VeeaHub platform!</H1> from path: /
```

Alternately, you can use a web browser.

## Stop the Container

To stop the Golang Web container, run:

```bash
$ vhc hub container --stop 9bf9e5ecf15330d6f1ece778e8c5e68f17381fe1bffcc2e348b0a3ec23e4f9a0
Stopping container 9bf9e5ecf15330d6f1ece778e8c5e68f17381fe1bffcc2e348b0a3ec23e4f9a0 from C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/9bf9e5ecf15330d6f1ece778e8c5e68f17381fe1bffcc2e348b0a3ec23e4f9a0/stop)...
Success
```

## Delete the Container

To delete the Golang Web container, run:

```bash
$ vhc hub container --delete 9bf9e5ecf15330d6f1ece778e8c5e68f17381fe1bffcc2e348b0a3ec23e4f9a0
Deleting container 9bf9e5ecf15330d6f1ece778e8c5e68f17381fe1bffcc2e348b0a3ec23e4f9a0 from C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/containers/9bf9e5ecf15330d6f1ece778e8c5e68f17381fe1bffcc2e348b0a3ec23e4f9a0)...
```

## Delete the Image

To delete the Golang Web image, run:

```bash
$ vhc hub image --delete c58e9d1261f548ed8e4a99e549cf5d6eca94a7dfeffb7191d4c7be2f732baa9f
Deleting image c58e9d1261f548ed8e4a99e549cf5d6eca94a7dfeffb7191d4c7be2f732baa9f from C05BCB00C0A000001127:9000 (https://10.20.0.89:9000/images/c58e9d1261f548ed8e4a99e549cf5d6eca94a7dfeffb7191d4c7be2f732baa9f)...
```


## Attach to STDIO

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

## Check directories

To check the contents of the directories you can use `bash` and `ls`

```bash
$ vhc hub container --attach 74de3f949d4eb5251de623ed3e01fa35625b3d490564832b9aca627a2df94fc5 "/bin/bash -il"
Attaching to stdin/stdout/stderr on C05BCB00C0A000001127:9001...
Attaching to container 74de3f949d4eb5251de623ed3e01fa35625b3d490564832b9aca627a2df94fc5 C05BCB00C0A000001127:9000 (https://10.20.0.90:9000/containers/74de3f949d4eb5251de623ed3e01fa35625b3d490564832b9aca627a2df94fc5/attach)...
Success
```
