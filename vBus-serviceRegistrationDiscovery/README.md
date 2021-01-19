Sample Project of Service Registration and Discovery on vBus
=========================================================

## Objective:

The objective of this sample project is to explain the concept of Service Registration and Discovery on vBus. In this project, we use vbus-cmd to register and discover services on vBus

There are three applications in this project:

1. Publisher

2. Redis Server

3. Consumer


![](.//media/image1.png)

**Redis-server**: It registers/exposes its Service URI whenever its container is started. 

**Publisher**: It will discover the Redis Server URI and start incrementing and setting the “myCounter” value in Redis-server at a set time interval(eg. 30 seconds)

**Consumer**: Like Publisher, Consumer also discover the Redis Server URI but instead of updating the “myCounter“ value, it reads it from Redis at a set time interval (eg. 30 seconds)

### vBus Command line Interface:
In order to register/discover a service on vBus, we make use of vBus-cmd which is a vBus command line tool.
>Learn more about vBus-cmd [here](https://github.com/veeainc/vbus-cmd)
1. You can download the latest release of vBus-cmd tool from the link below: 

    https://github.com/veeainc/vbus-cmd/releases

    >For VHC05 devices, download elf-linux-arm-vbus-cmd
    > 
    >For VHX09-10 devices, download elf-linux-arm64-vbus-cmd


2. Rename the downloaded file as vbus-cmd and save at /usr/bin/ so that it can be accessed globally.

### vBus-cmd Commands
Given below is the syntax for vBus commands and it has been further elucidated with the help of a couple of examples:


```vbus-cmd [global options] command [command options] [arguments...]```


COMMANDS:

| vBus Commands | Description                                               |
|---------------|-----------------------------------------------------------|
| discover, d   | Discover elements on `PATH`                               |
| node, n       | Send a command on a remote node                           |
| attribute, a  | Send a command on a remote attribute                      |
| method, m     | Send a command on a remote method                         |
| expose, e     | Expose a service URI                                      |
| version, v    | Display version number                                    |
| help, h       | Shows a list of commands or help for a particular command |

GLOBAL OPTIONS:

| Global Options               | Description                                   |
|------------------------------|-----------------------------------------------|
| --debug, -d                  | Show vBus library logs (default: false)       |
| --interactive, -i            | Start an interactive prompt (default: false)  |
| --permission value, -p value | Ask for permission before running the command |
| --domain value               | Change domain name (default: “system“)        |
| --app value                  | Change app name (default: “vbus-cmd“)         |
| --help, -h                   | Show help (default: false)                    |

#### Example usage

```
vbus-cmd discover system.zigbee

vbus-cmd discover -j system.zigbee (json output)

vbus-cmd attribute get -t 10 system.zigbee.[...].1026.attributes.0

vbus-cmd --domain=veea --app=redis expose --name=redis --protocol=tcp --port=6379 &
```
