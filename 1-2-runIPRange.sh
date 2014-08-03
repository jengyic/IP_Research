#!/bin/bash

PATH=$PATH

TODAY=`date +"%Y%m%d"`

BASEPATH="/root/root_scripts/IP_Research"
RSPATH="Result-IPR"
PINGRFN="PING-$TODAY.log"
WEBRFN="Web-$TODAY.log"
SSHRFN="SSH-$TODAY.log"
DNSRFN="DNS-$TODAY.log"
SMTPRFN="SMTP-$TODAY.log"
CHKPARA=0
ND=0

# Default host counter
IPC=0
PING=0
WEB=0
SSH=0
DNS=0
SMTP=0

TIMEOUT="2"
TOCMD="/usr/bin/timeout $TIMEOUT"

if [ -n "$1" ]; then
	CC="$1"
	shift
else
	ND=1
	CHKPARA=1
fi

if [ -n "$1" ]; then
	HEAD="$1"
	shift
	if [ $HEAD -le 0 ]; then
		echo "[ERROR] Head($HEAD) can not be less than 1"
		CHKPARA=1
	fi
else
	ND=1
	CHKPARA=1
fi

if [ -n "$1" ]; then
	TAIL="$1"
	shift
	if [ $TAIL -le 0 ]; then
		echo "[ERROR] Tail($TAIL) can not be less than 1"
		CHKPARA=1
	fi
else
	ND=1
	CHKPARA=1
fi

if [ $ND -eq 0 ]&&[ $HEAD -gt $TAIL ]; then
	echo "[ERROR] Head($HEAD) is greater than Tail($TAIL)"
	CHKPARA=1
fi

if [ $CHKPARA -eq 1 ]; then
	echo "Usage: $0 country_code head_linenum tail_linenum"
	echo "country_code: tw, us, cn, jp, nl ..., see country_code.txt"
	echo "head_linenum tail_linenum: must larger than 0"
	exit 1
fi

DIFF=$(($TAIL-$HEAD+1))

#echo "$HEAD $TAIL $DIFF"

RSPATH="$RSPATH-$CC/$TODAY"
mkdir -p $BASEPATH/$RSPATH

cd $BASEPATH

IPLISTF=`ls | grep 'IP-' | sort -rn | head -n 1 | sed 's/\///'`
IPLIST="$IPLISTF/$IPLISTF-$CC.log"

echo "Search IP range: from line $HEAD to line $TAIL"
echo "cat $IPLIST | head -n $TAIL | tail -n $DIFF"
cat $IPLIST | head -n $TAIL | tail -n $DIFF
echo ""

for IPR in `cat $IPLIST | head -n $TAIL | tail -n $DIFF`
do
	echo "[[[[[[ $IPR ]]]]]]"
	IP=`echo $IPR|awk 'BEGIN{FS="/"};{print $1}'`
	MASK=`echo $IPR|awk 'BEGIN{FS="/"};{print $2}'`

	BINR=`./findMinMaxIPbin $IP $MASK|tail -n 1`
	#echo $BINR
	MINBIN=`echo $BINR|awk 'BEGIN{FS="-"};{print $1}' | sed 's/ //'`
	MAXBIN=`echo $BINR|awk 'BEGIN{FS="-"};{print $2}' | sed 's/ //'`
	echo "$MINBIN to $MAXBIN"
	echo `./Int2IP $MINBIN`" - "`./Int2IP $MAXBIN`

	for((i=$MINBIN; i<=$MAXBIN; i++))
	do
		#./Int2IP $i
		TMPIP=`./Int2IP $i`
		SRVLIST=""
		# PING
		CHKRES=`$TOCMD ./CheckService.sh ping $TMPIP`
		if [[ $CHKRES -eq 1 ]]; then
			touch $RSPATH/$PINGRFN
			echo "$TMPIP" >> $RSPATH/$PINGRFN
			SRVLIST="$SRVLIST PING"
			PING=$(($PING+1))
		fi

		# Web
		CHKRES=`$TOCMD ./CheckService.sh web $TMPIP`
		if [[ $CHKRES -eq 1 ]]; then
			touch $RSPATH/$WEBRFN
			echo "$TMPIP" >> $RSPATH/$WEBRFN
			SRVLIST="$SRVLIST WEB"
			WEB=$(($WEB+1))
		fi

		# SSH
		CHKRES=`$TOCMD ./CheckService.sh ssh $TMPIP`
		if [[ $CHKRES -eq 1 ]]; then
			touch $RSPATH/$SSHRFN
			echo "$TMPIP" >> $RSPATH/$SSHRFN
			SRVLIST="$SRVLIST SSH"
			SSH=$(($SSH+1))
		fi

		# DNS
		CHKRES=`$TOCMD ./CheckService.sh dns $TMPIP`
		if [[ $CHKRES -eq 1 ]]; then
			touch $RSPATH/$DNSRFN
			echo "$TMPIP" >> $RSPATH/$DNSRFN
			SRVLIST="$SRVLIST DNS"
			DNS=$(($DNS+1))
		fi

		# SMTP
		CHKRES=`$TOCMD ./CheckService.sh smtp $TMPIP`
		if [[ $CHKRES -eq 1 ]]; then
			touch $RSPATH/$SMTPRFN
			echo "$TMPIP" >> $RSPATH/$SMTPRFN
			SRVLIST="$SRVLIST SMTP"
			SMTP=$(($SMTP+1))
		fi

		if [ "$SRVLIST" != "" ]; then
			echo "$TMPIP$SRVLIST"
		fi
		IPC=$(($IPC+1))
	done

	echo ""
done

echo "Search IP: $IPC"
echo "     PING: $PING"
echo "      Web: $WEB"
echo "      SSH: $SSH"
echo "      DNS: $DNS"
echo "     SMTP: $SMTP"
