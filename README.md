# Personal-Linux-Firewall

A firewall for Linux that implements the following rules:
- Set the default policies to DROP.
- Create a set of rules that will:
- Permit inbound/outbound ssh packets.
- Permit inbound/outbound www packets.
- Drop inbound traffic to port 80 (http) from source ports less than 1024.
- Drop all incoming packets from reserved port 0 as well as outbound traffic to port 0.
- Create a set of user-defined chains that will implement accounting rules to keep track of www, ssh traffic, versus the rest of the traffic on your system.

Constraints:
- Use Netfilter for your firewall implementation.
- You must ensure the the firewall drops all inbound SYN packets, unless there is a rule that permits inbound traffic.
- You will be required to demonstrate your firewall in action on the day the assignment is due.
- Remember to allow DNS and DHCP traffic through so that your machine can function properly.
