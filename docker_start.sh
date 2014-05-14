#!/bin/bash

eval "$*" &

# fifo used to remote exec command
NICEDOCKER_DIR=/opt/nicedocker
[ -d $NICEDOCKER_DIR ] || mkdir -p /opt/nicedocker
[ -e $NICEDOCKER_DIR/docker_out ] && /bin/rm $NICEDOCKER_DIR/docker_out
mkfifo $NICEDOCKER_DIR/docker_out 
eval "while [ 1 ]; do sleep 1000000000 > $NICEDOCKER_DIR/docker_out; done" &
eval "while [ 1 ]; do /bin/bash < $NICEDOCKER_DIR/docker_out > $NICEDOCKER_DIR/docker_execlog 2>&1; /bin/rm $NICEDOCKER_DIR/docker_out; mkfifo $NICEDOCKER_DIR/docker_out; done" &
echo $! > $NICEDOCKER_DIR/loginbash.pid

# bash used for attach/login
while [ 1 ]; do
    /bin/bash
    echo please use ctrl+pq to exit docker
done

