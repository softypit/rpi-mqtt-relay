#!/bin/sh

start() {
    /usr/bin/mqttboilerrun.sh &
}

stop() {
    pkill mqttboilerrun
}

case $1 in 
  start|stop) "$1" ;;
esac

