#!/bin/bash

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 {ida|ida64|build|purge|run|shell|start|stop}"
    exit 1
fi

# Define the function for each script
function ida {
    ssh -p 2222 -o StrictHostKeyChecking=no -o "UserKnownHostsFile /dev/null" -o ForwardX11=yes -o ForwardX11Trusted=yes -X root@localhost wine "IDA/ida.exe"
}

function ida64 {
    ssh -p 2222 -o StrictHostKeyChecking=no -o "UserKnownHostsFile /dev/null" -o ForwardX11=yes -o ForwardX11Trusted=yes -X root@localhost wine "IDA/ida64.exe"
}

function purge {
    docker rm idapro
    docker rmi idapro
}

function run {
    echo "Creating Docker Container (from local image)."
    docker run -it -d --name idapro -e DISPLAY=$DISPLAY -v $(pwd)/wrkdir:/wrkdir -p 2222:22 idapro
    docker ps
}

function shell {
    ssh -p 2222 -o StrictHostKeyChecking=no -o "UserKnownHostsFile /dev/null" -o ForwardX11=yes -o ForwardX11Trusted=yes -X root@localhost
}

function start {
    echo "Starting Docker Container."
    docker start idapro
    docker ps
}

function stop {
    echo "Stopping Docker Container."
    docker stop idapro
    docker ps -a
}

function build {
    cp ~/.ssh/id_rsa.pub .
    docker build --no-cache . -t idapro
}

# Switch based on the input argument
case "$1" in
    ida)
        ida
        ;;
    ida64)
        ida64
        ;;
    purge)
        purge
        ;;
    build)
       build
        ;;
    run)
        run
        ;;
    shell)
        shell
        ;;
    start)
        start
        ;;
    stop)
        stop
        ;;
    *)
        echo "Invalid option: $1"
        echo "Valid options are: ida, ida64, purge, build, run, shell, start, stop"
        exit 1
        ;;
esac

