# da mettere in /etc/profile.d con i diritti di esecuzione ed estensione .sh
#
# chiamato da bash insieme agli altri in /etc/profile.d/, NON riceve parametri
#
# funziona solo con i miei proxy.pac
# bisognerebbe fare un parser Javascript con Lex&Yacc per generalizzarlo
#
# sarebbe interessante anche andare a pescare le opzioni date dal server
# DHCP per renderlo completamente conforme allo standard WPAD/PAC
#

NETTIMEOUT=2 # timeout in secondi, non troppo alto ma neanche bassissimo
RETRIES=1 # tentativi
TMPDIR="/tmp"
PACURL="http://wpad/proxy.pac"
#PACURL="http://www.smaldino.it/"
## OUTFILE="${TMPDIR}/proxy.pac"

# Rimosso l'uso del file temporaneo per contenere il proxy.pac
# perchè in presenza di multi utenze, combina caos indescrivibile
# (non riesce a sovrascrivere, ........).
# Anche la soluzione di cancellarlo dopo l'uso non va bene perchè apt/dpkg
# fa partire in parallelo i downloads e quindi ... caos!
# Adesso scarica e analizza in pipe

# echo $FROMPROFILE

## wget -t $RETRIES -T $NETTIMEOUT -O $OUTFILE $PACURL 2> /dev/null
## retcode=$?

# echo $retcode

## if [ $retcode -eq 0 ]; then
#   echo "ok"
   ## PROXYURL=`awk 'BEGIN{IGNORECASE = 1}/return.+PROXY/' $OUTFILE | awk '{print substr($3, 1, length($3)-2)}'`
   PROXYURL=`wget -t $RETRIES -T $NETTIMEOUT -q -O - $PACURL | awk 'BEGIN{IGNORECASE = 1}/return.+PROXY/' | awk '{print substr($3, 1, length($3)-2)}'`
   ## rm $OUTFILE
#   echo $PROXYURL
   if [ -n "$PROXYURL" ]; then 
      # è riuscito a trovare host/porta
      tmpproxy="http://${PROXYURL}/"
      export http_proxy=$tmpproxy
      export https_proxy=$http_proxy
      export ftp_proxy=$http_proxy
      export HTTP_PROXY=$http_proxy
      export HTTPS_PROXY=$http_proxy
      export FTP_PROXY=$http_proxy
      export no_proxy="localhost,127.0.0.0/8,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12,.lan,.local"
      export NO_PROXY=$no_proxy
   fi
## fi

