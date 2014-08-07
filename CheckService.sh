#!/bin/bash

PATH=$PATH
CHKPARA=0
ND=0

if [ -n "$1" ]; then
	SRV="$1"
	shift
else
	ND=1
	CHKPARA=1
fi

if [ -n "$1" ]; then
	HOST="$1"
	shift
else
	ND=1
	CHKPARA=1
fi

if [ $ND -eq 0 ]&&[ "$SRV" != "web" ]&&[ "$SRV" != "ssh" ]&&[ "$SRV" != "dns" ]&&[ "$SRV" != "smtp" ]&&[ "$SRV" != "ping" ]; then
	echo "[ERROR] Check service is not web, ssh, dns, smtp or ping"
	CHKPARA=1
fi

case $SRV in
web)	PORT="80"
	;;
ssh)	PORT="22"
	;;
smtp)	PORT="25"
	;;
*)
	;;
esac

if [ $CHKPARA -eq 1 ]; then
	echo "Usage: $0 Service Hostname|IP_address"
	echo "Example: $0 web 8.8.8.8"
	exit 1
else
	# Ping to 8.8.8.8
	sh CheckNet.sh

	if [ "$SRV" == "ping" ]; then
		SRVSTATUS=`ping -q -c 1 -W 2 $HOST > /dev/null && echo 1`
		if [ "$SRVSTATUS" != "1" ]; then
			echo "0"
		else
			echo "1"
		fi
	elif [ "$SRV" == "dns" ]; then
		SRVSTATUS=`dig +short +time=1 @${HOST} www.google.com | grep -v ';' | wc -l`
		if [ $SRVSTATUS -eq 0 ]; then
			echo "0"
		else
			echo "1"
		fi
	else
		#echo "${HOST} ${PORT}"
		#echo "$PATH"
		SRVSTATUS=`echo -en "o ${HOST} ${PORT}\nsend escape\nquit\nclose\n" | /usr/bin/telnet 2>/dev/null | grep "]" | wc -l`
		#echo -en "open ${HOST} ${PORT}\nsend escape\nquit\nclose\n" | /usr/bin/telnet 2>/dev/null
		if [ $SRVSTATUS -ne 1 ]; then
			echo "0"
		else
			echo "1"
		fi
	fi
fi
