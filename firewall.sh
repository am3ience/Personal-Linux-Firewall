##!/bin/sh

clear
#flush IP tables
iptables -F
#delete user-chains
iptables -X

# Change the default chain policy to DROP
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

#User Defined chain
iptables -N ssh
iptables -N www
iptables -N otherdrop
iptables -N otheraccept


iptables -A ssh -j ACCEPT
iptables -A www -j ACCEPT
iptables -A otherdrop -j DROP
iptables -A otheraccept -j ACCEPT


#-----------------------------------------------------
#Permit inbound/outbound ssh packets
iptables -A INPUT -p tcp --dport 22 -j ssh
iptables -A OUTPUT -p tcp --sport 22 -j ssh

iptables -A OUTPUT -p tcp --dport 22 -j ssh
iptables -A INPUT -p tcp --sport 22 -j ssh

#-----------------------------------------------------
#Allow inbound/outbound www packets

#inbound HTTP
iptables -A INPUT -p tcp --dport 80 -j www
iptables -A OUTPUT -p tcp --sport 80 -j www
#outbound HTTP
iptables -A OUTPUT -p tcp --dport 80 -j www
iptables -A INPUT -p tcp --sport 80 -j www

#inbound HTTPS
iptables -A INPUT -p tcp --dport 443 -j www
iptables -A OUTPUT -p tcp --sport 443 -j www
#outbound HTTPS
iptables -A OUTPUT -p tcp --dport 443 -j www
iptables -A INPUT -p tcp --sport 443 -j www

#---------------------------------------------------
#Drop inbound traffic to port 80 from source ports less than 1024
iptables -A INPUT -p tcp --dport 80 --sport 0:1024 -j otherdrop

#---------------------------------------------------
#Drop all incoming packets from reserved port 0 as well
#as outbound traffic to port 0
iptables -A INPUT -p tcp --sport 0 -j otherdrop
iptables -A OUTPUT -p tcp --dport 0 -j otherdrop
iptables -A INPUT -p udp --sport 0 -j otherdrop
iptables -A OUTPUT -p udp --dport 0 -j otherdrop

#----------------------------------------------------
#Allow inbound/outbound DHCP
iptables -A OUTPUT -p udp --dport 68 -j otheraccept
iptables -A INPUT -p udp --sport 68 -j otheraccept
iptables -A OUTPUT -p tcp --dport 68 -j otheraccept
iptables -A INPUT -p tcp --sport 68 -j otheraccept

#----------------------------------------------------
#Allow inbound/outbound DNS
iptables -A OUTPUT -p udp --dport 53 -j otheraccept
iptables -A INPUT -p udp --sport 53 -j otheraccept
iptables -A OUTPUT -p tcp --dport 53 -j otheraccept
iptables -A INPUT -p tcp --sport 53 -j otheraccept

#---------------------------------------------------
#save then restart the iptables
systemctl iptables save
systemctl iptables restart

iptables -L -v -n -x
