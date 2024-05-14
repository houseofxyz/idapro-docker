# idapro-docker

<p align="center"><img src="wrkdir/docker-ida.png"></p>

## About

IDA Pro (Windows) on Linux using Docker and Wine with X11 Forwarding over SSH. Why? Because I'm only paying for the Windows version but I also want to use it on Linux `¯\_(ツ)_/¯`

```bash
$ ./ida.sh
Usage: ./ida.sh <ida|ida64|build|purge|run|shell|start|stop>
```

## Before you start

1. Ensure you have a SSH public key in `~/.ssh/` (`ssh-keygen` if you don't)
2. Copy your IDA Pro Windows folder into an `IDA` folder in the `idapro-docker` root folder.

Then, build the docker image with `./ida.sh build`.

## Usage

You can start a new container from the pre-built image with `./ida.sh run`

I couldn't get docker to ignore the *errors* (that can be safely ignored) thrown by `wine`. So, if first time usage, run:

```bash
$ winetricks --force dotnet452 corefonts
$ WINEARCH=win64 winetricks -q win10
$ wine wine /root/python-3.10.0-amd64.exe /quiet InstallAllUsers=1 PrependPath=1
```

You can stop the container with `./ida.sh stop` and start a new container with `./ida.sh start` (without re-deploying from the docker image).

You can run IDA with `./ida.sh ida` or `./ida.sh ida64`.

If you need a shell on the container you can use `./ida.sh shell`. If you need to transfer, and preserve, files between your host and the container use the local `wrkdir` mapped to `/wrkdir` in the container.

## Remarks

- Tested with IDA Pro 8.4
- Ensure that the Python version you are running on Windows matches with the Python version that's downloaded via the `Dockerfile` and installed (manually) with `wine`. If you use `wine idapyswitch.exe`, IDA will crash every time you launch it (no idea why).

## References

- https://github.com/nicolaipre/idapro-docker
- https://github.com/intezer/docker-ida
- https://github.com/thawsystems/docker-ida
- https://gist.github.com/williballenthin/1c6ae0fbeabae075f1a4

