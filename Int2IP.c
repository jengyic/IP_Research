#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define HASHSIZE 4294967295

unsigned int ip2bin(unsigned int,unsigned int,unsigned int,unsigned int);
unsigned int mask2bin(unsigned int);
void bin2ip(unsigned int,char *);

int main(int argc, char *argv[])
{
	unsigned int ipbin;		/* Binary IP address */
	char tmpip[16];

	sscanf(argv[1], "%u", &ipbin);
	bin2ip(ipbin,tmpip);
	printf("%s\n",tmpip);

	return 0;
}

unsigned int ip2bin(unsigned int n1, unsigned int n2, unsigned int n3, unsigned int n4)
{
	unsigned int tmp;
	tmp = (unsigned int)n1;
	tmp = tmp << 8;
	tmp = tmp | n2;
	tmp = tmp << 8;
	tmp = tmp | n3;
	tmp = tmp << 8;
	tmp = tmp | n4;

	return tmp;
}

unsigned int mask2bin(unsigned int m)
{
	unsigned int out = 0;
	int i;

	if(m < 1 || m > 32)
		return out;

	for(i = 32; i > 0; i--){
		if(m > 0){
			out = out | 1;
			m--;
		} else {
			out = out | 0;
		}
		if(i > 1)
			out = out << 1;
	}

	return out;
}

void bin2ip(unsigned int ipbin, char *ip)
{
	unsigned int n1, n2, n3, n4;    /* For IP address 4 digits */

	n4 = ipbin & 255;
	ipbin = ipbin >> 8;
	n3 = ipbin & 255;
	ipbin = ipbin >> 8;
	n2 = ipbin & 255;
	ipbin = ipbin >> 8;
	n1 = ipbin & 255;

	sprintf(ip,"%d.%d.%d.%d",n1,n2,n3,n4);
}
