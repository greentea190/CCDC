#!/bin/bash
IPT="/sbin/iptables"

# Your DNS servers you use: cat /etc/resolv.conf
DNS_SERVER="8.8.4.4 8.8.8.8"

# Allow connections to this package servers
PACKAGE_SERVER="ftp.us.debian.org security.debian.org"

#User Input: Asking for which service to configure
while [ "$PROMPT" != 0 ]; do
	cat <<- _EOF_
	Select a service to configure firewall rules for:
	
	1) Web
	2) DNS 
	3) Mail 
	4) Splunk
	5) SSH
	0) Quit

	_EOF_

read -p "Select a service [0-4] to configure firewall rules for: " SERVICE


#Deleting existing iptables rules"
$IPT -F
$IPT -X
#$IPT -t nat -F
#$IPT -t nat -X
#$IPT -t mangle -F
#$IPT -t mangle -X

#Set default policy to DROP
$IPT -P INPUT   DROP
$IPT -P FORWARD DROP
$IPT -P OUTPUT  DROP

## This should be one of the first rules.
## so dns lookups are already allowed for your other rules
for ip in $DNS_SERVER
do
	echo "Allowing DNS lookups (tcp, udp port 53) to server '$ip'"
	$IPT -A OUTPUT -p udp -d $ip --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
	$IPT -A INPUT  -p udp -s $ip --sport 53 -m state --state ESTABLISHED     -j ACCEPT
	$IPT -A OUTPUT -p tcp -d $ip --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
	$IPT -A INPUT  -p tcp -s $ip --sport 53 -m state --state ESTABLISHED     -j ACCEPT
done

for ip in $PACKAGE_SERVER
do
	echo "Allow connection to '$ip' on port 21"
	$IPT -A OUTPUT -p tcp -d "$ip" --dport 21  -m state --state NEW,ESTABLISHED -j ACCEPT
	$IPT -A INPUT  -p tcp -s "$ip" --sport 21  -m state --state ESTABLISHED     -j ACCEPT

	echo "Allow connection to '$ip' on port 80"
	$IPT -A OUTPUT -p tcp -d "$ip" --dport 80  -m state --state NEW,ESTABLISHED -j ACCEPT
	$IPT -A INPUT  -p tcp -s "$ip" --sport 80  -m state --state ESTABLISHED     -j ACCEPT

	echo "Allow connection to '$ip' on port 443"
	$IPT -A OUTPUT -p tcp -d "$ip" --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
	$IPT -A INPUT  -p tcp -s "$ip" --sport 443 -m state --state ESTABLISHED     -j ACCEPT
done


#######################################################################################################
## Required Rules

#Allow loopback connections
$IPT -I INPUT -i lo -j ACCEPT
$IPT -A OUTPUT -o lo -j ACCEPT

#Allowing NEW and ESTABLISHED connections using ports 80,443
$IPT -A OUTPUT -p tcp -m multiport --sports 80,443 -m state --state ESTABLISHED -j ACCEPT
$IPT -A INPUT -p tcp -m multiport --dports 80,443 -m state --state NEW,ESTABLISHED -j ACCEPT

#Allowing ICMP outbound for ping
$IPT -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
$IPT -A INPUT  -p icmp -m state --state ESTABLISHED,RELATED -j ACCEPT

#Allow outgoing connections to port 123 (ntp)"
$IPT -A OUTPUT -p udp --dport 123 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPT -A INPUT  -p udp --sport 123 -m state --state ESTABLISHED -j ACCEPT


#######################################################################################################
#Specific Firewall Rules

#Web: Allowing all inbound connections to ports 80,443
if [ $SERVICE == 1 ] then
$IPT -I INPUT -p tcp --dport 80 -j ACCEPT
$IPT -I INPUT -p tcp --dport 443 -j ACCEPT
fi

#DNS: Allowing all outbound connections to port 53
if [ $SERVICE == 2 ] then
$IPT -I  
fi

#Mail: Allowing all outbound connections to port 25
if [ $SERVICE == 3 ] then
fi

#Splunk: Allowing all Splunk service connections on ports 8000,9997,8089
if [ $SERVICE == 3 ] then

#SSH: Allow all outgoing connections to port 22
if [ $SERVICE == 5 ] then
$IPT -A OUTPUT -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
$IPT -A INPUT  -p tcp --sport 22 -m state --state ESTABLISHED     -j ACCEPT
fi


#Allow incomming webserver connnections to port 80,443 HTTP/HTTPS
iptables -A INPUT -p tcp --sport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A 
exit 0
