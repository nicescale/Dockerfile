#!/bin/sh

eval "$*" &

# fifo used to remote exec command
NICEDOCKER_DIR=/opt/nicedocker
[ -d $NICEDOCKER_DIR ] || mkdir -p /opt/nicedocker
if [ ! -z "$NICESCALE" ]; then
  [ -e $NICEDOCKER_DIR/docker_out ] && /bin/rm $NICEDOCKER_DIR/docker_out
  mkfifo $NICEDOCKER_DIR/docker_out 
  eval "while [ 1 ]; do sleep 1000000000 > $NICEDOCKER_DIR/docker_out; done" &
  eval "while [ 1 ]; do /bin/sh < $NICEDOCKER_DIR/docker_out > $NICEDOCKER_DIR/docker_execlog 2>$NICEDOCKER_DIR/docker_execlog_err; /bin/rm $NICEDOCKER_DIR/docker_out; mkfifo $NICEDOCKER_DIR/docker_out; done" &
  echo $! > $NICEDOCKER_DIR/shexec.pid
fi

# bash used for attach/login
while [ 1 ]; do
    [ -f $NICEDOCKER_DIR/service.ini ] && . $NICEDOCKER_DIR/service.ini
    touch $NICEDOCKER_DIR/bashrc
    [ ! -z "$SERVICE_NAME" ] && echo "PS1=\"\u@$SERVICE_NAME:\w# \"" > $NICEDOCKER_DIR/bashrc
    /bin/bash --rcfile $NICEDOCKER_DIR/bashrc
    echo please press ctrl+pq to detach docker
done

