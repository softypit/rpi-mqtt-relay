#!/bin/bash
##########################
# MQTT Shell Listen & Exec
host="127.0.0.1"
port=1883
intopic="/heating/boiler"
gpio=21

[ "$#" -gt 1 ] && host=$1
[ "$#" -gt 2 ] && port=$2
[ "$#" -gt 3 ] && intopic=$3
[ "$#" -gt 4 ] && gpio=$4
p="/tmp/mqttboilerbackpipe"
pidfile="/tmp/mqttboilersubpid"

listen(){
    ([ ! -p "$p" ]) && mkfifo $p
    echo "pipe error $?"
    echo ${gpio} > /sys/class/gpio/export
    (mosquitto_sub -h $host -p $port -t $intopic >$p) &
    echo "$!" > pidfile
    while true
    do
      read -t 300 line <$p
      if [ "$?" -gt 128 ]; then
	  # boiler off - timeout
	  echo "no boiler update - switch off"
          echo in > /sys/class/gpio/gpio${gpio}/direction
	  continue
      fi
      if [ "$line" == "ON" ]; then
	  # boiler on
          echo out > /sys/class/gpio/gpio${gpio}/direction
	  echo "Fire-up the boiler!"
      else
          # boiler off
          echo in > /sys/class/gpio/gpio${gpio}/direction
	  echo "Turn boiler off"
      fi
    done
    echo "Exit"
    rm $p
}

#echo "host is $host"
#echo "port is $port"
#echo "intopic $intopic"
#echo "gpio is $gpio"

rm -rf $p
#echo "creating fifo $p"

# Wait a while for broker to start
sleep 30s
listen

