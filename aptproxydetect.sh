#!/bin/bash

# da mettere in /usr/local/bin con i diritti di esecuzione
#
# serve per settare il Proxy-Auto-Detect di apt attravero 
# il file /etc/apt/apt.conf.d/00ProxyDetect
# 
# per funzionare ha bisogno dello script che setta http_proxy e che
# dovrebbe trovarsi in /etc/profile.d/ (wpadpac2.sh)
#
PROXYSETSCRIPT="/etc/profile.d/wpadpac2.sh"
#
. $PROXYSETSCRIPT

if [ -n "$http_proxy" ]; then
   echo $http_proxy
else
   echo "DIRECT"
fi
