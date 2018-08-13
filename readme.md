
**bash solution to control call-for-heat relay on RPi using mqtt.**

Control relay on RPi GPIO pin using mqtt

mosquitto command line is used for mqtt (mosquitto_sub).

Tested on RPi2.

/usr/bin/mqttboiler.sh to be run from init.d/systemctl.
/usr/bin/mqttboilerrun.sh is the actual daemon that listens for mqtt commands and sets the GPIO


mqttboilerrun is executed with up to 4 arguments - host, port, intopic and gpio.
e.g. /usr/bin/mqttboilerrun.sh 127.0.0.1 1883 /heating/boiler 21

if these arguments are not specified the above defaults are used.

publish 'ON' to the intopic (default /heating/boiler)
any other publish message turns the relay off
Every 5 minutes if no publish message is received the relay is switched off

To use for heating control ensure 'ON' is published at least once every 5 minutes when call-for-heat is required
