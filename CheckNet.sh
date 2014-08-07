#!/bin/bash

PATH=$PATH

RHOST="8.8.8.8"

while [ 1 ]
do
	RHOSTALIVE=`ping -q -c 1 -W 2 ${RHOST} > /dev/null && echo 1`
	if [ ! -n "${RHOSTALIVE}" ]||[ ${RHOSTALIVE} -ne 1 ]; then
		#echo "Network Error. Please check it."
		BAD=1
	else
		#echo "Ping to $RHOST is fine."
		exit 0
	fi 
done
