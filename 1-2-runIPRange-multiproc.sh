#!/bin/bash

PATH=$PATH

BASEPATH="/root/root_scripts/IP_Research"
LOGPATH="$BASEPATH/1-2-runIPRange"

JobLimit=12
JobsDone=0
CHKPR=30

TODAY=`date +"%Y%m%d"`

if [ ! -d $BASEPATH ]; then
	echo "$BASEPATH does not existed."
	exit 1
fi

if [ -n "$1" ]; then
	CC="$1"
	shift
else
	echo "Usage: $0 country_code"
	echo "Example: $0 tw"
	echo "Country code: tw, us, cn ... see country_code.txt"
	exit 1
fi

LOGPATH="$LOGPATH-$CC/$TODAY"
mkdir -p $LOGPATH

cd $BASEPATH

IPLISTF=`ls | grep 'IP-' | sort -rn | head -n 1 | sed 's/\///'`
IPLIST="$IPLISTF/$IPLISTF-$CC.log"

Jobs=`wc -l $IPLIST | awk '{print $1}'`

while [ 1 ];
do
	ProcCount=`ps awx|grep "1-2-runIPRange.sh $CC" | grep -v grep | wc -l | awk '{print $1}'`
	UnDoneJobs=$(($Jobs - $JobsDone))
	NeedProc=$(($JobLimit - $ProcCount))
	echo "$Jobs $JobLimit $ProcCount $NeedProc $UnDoneJobs"
	if [ $UnDoneJobs -lt $JobLimit ]; then
		if [ $NeedProc -gt $UnDoneJobs ]; then
			NeedProc="$UnDoneJobs"
		fi
	fi

	if [ $NeedProc -gt 0 ]; then
		date
		echo "Add $NeedProc jobs"
		for((i=0; i<$NeedProc; i++));
		do
			NewJob=$(($JobsDone+1))
			echo "Job: "`cat $IPLIST | head -n $NewJob | tail -n 1`
			./1-2-runIPRange.sh $CC $NewJob $NewJob > $LOGPATH/1-2-runIPRange-$CC-$TODAY-$NewJob-$NewJob.log 2>&1 &
			JobsDone=$(($JobsDone+1))
		done
	fi

	if [ $JobsDone -eq $Jobs ]; then
		echo "All jobs($Jobs) had excuted. Please wait for last jobs($NewJob)."
		ps awx|grep "1-2-runIPRange.sh $CC" | grep -v grep
		exit 0
	fi
	
	sleep $CHKPR
done
