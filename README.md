IP_Research is copyleft by Jengyic@DaemonLand, using the BSD license.

 0. (optional) Change bash path in all shell script if in FreeBSD.

FreeBSD:
/usr/local/bin/bash

 1. Before using this tool, you should compile C program via gcc(Linux) or cc(FreeBSD).

Linux:
gcc -O2 findMinMaxIPbin.c -o findMinMaxIPbin
gcc -O2 Int2IP.c -o Int2IP

FreeBSD:
cc -O2 findMinMaxIPbin.c -o findMinMaxIPbin
cc -O2 Int2IP.c -o Int2IP

 2. Edit 1-2-runIPRange.sh and 1-2-runIPRange-multiproc.sh, change BASEPATH.

FreeBSD: using gtimeout in 1-2-runIPRange.sh.
TOCMD="/usr/local/bin/gtimeout $TIMEOUT"

 3. (optional) Edit CheckService.sh if in FreeBSD.

FreeBSD: 
SRVSTATUS=`echo -en "open ${HOST} ${PORT}\nsend escape\nquit\nclose\n" | /usr/bin/telnet 2>/dev/null | grep "]" | wc -l`

If any advice, please contact me via jengyic@gmail.com.
