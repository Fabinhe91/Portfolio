## Network Engineering Project: Multi-Site Enterprise Network with Routing, NAT, and Security
### Project Overview
This project involved designing and implementing a secure, scalable enterprise network connecting two sites (HQ and Branch) using Cisco routers and switches. The objective was to provide inter-VLAN routing, internet access via NAT/PAT, and enforce port-level security while ensuring encrypted remote management.

### Network Topology
HQ Site:

Router: Cisco 3725 (HQ-EdgeRT)

VLANs:

VLAN 10 (Management): 10.1.10.0/24

VLAN 20 (Sales): 10.1.20.0/24

Loopback1: 10.10.10.1/24 (simulated internal network)

Branch Site:

Router: Cisco IOL L2 image acting as Layer 3 switch (Branch-RT)

VLANs:

VLAN 110 (Management): 10.2.10.0/24

VLAN 120 (Sales): 10.2.20.0/24

Loopback1: 20.20.20.1/24 (simulated internal network)

Transit Network: 192.168.253.0/24 connecting both routers to an upstream ISP gateway (192.168.253.2).

### Network Diagram
<img src="diagram.png"/>

### Configuration Highlights
# 1. VLAN and Inter-VLAN Routing
Created VLANs on both routers using subinterfaces (router-on-a-stick).

Assigned IP addresses to subinterfaces:

HQ: Ethernet0/1.10 (10.1.10.254/24), Ethernet0/1.20 (10.1.20.254/24)

Branch: Ethernet0/1.110 (10.2.10.254/24), Ethernet0/1.120 (10.2.20.254/24)

# 2. Dynamic Routing with OSPF
Configured OSPF process 1 on both routers with router IDs (1.1.1.1 for HQ, 2.2.2.2 for Branch).

Advertised all directly connected networks (VLANs, loopbacks, and the transit link 192.168.253.0/24) into OSPF area 0.

Verified OSPF neighbor adjacency and routing tables to ensure full reachability between all subnets.

# 3. Internet Access via NAT/PAT
Designated Ethernet0/0 as the outside interface and subinterfaces as inside.

Created ACLs to control which traffic is translated:

Initial misconfiguration (deny-first) caused internal traffic to be dropped.

Corrected ACL order: deny RFC 1918 addresses first, then permit all other traffic (internet-bound).

Applied ip nat inside source list <ACL> interface Ethernet0/0 overload to enable PAT.

Verified NAT translations and statistics, ensuring internal traffic remained untranslated while internet traffic was successfully NATed.

# 4. Securing Remote Management (SSHv2)
Disabled Telnet by restricting VTY lines to SSH only (transport input ssh).

Generated 2048-bit RSA keys and enforced SSH version 2.

Created local user accounts with privilege 15 and encrypted passwords (username admin secret cisco123).

Configured SSH timeouts and authentication retries.

# 5. Port Security with Sticky MAC Addresses (on Access Switches)
Enabled port security on access ports to restrict unauthorized devices.

Used switchport port-security mac-address sticky to dynamically learn and retain MAC addresses.

Set maximum MAC addresses per port (e.g., 2 for PC + IP phone).

Configured violation mode shutdown to disable ports upon security breaches.

Implemented aging to remove stale entries and auto-recovery options for convenience.

Challenges and Solutions
OSPF Adjacency Not Forming: Initially, routers were on different subnets (10.1.x.x vs 10.2.x.x). Added the transit network 192.168.253.0/24 to OSPF to establish neighbor relationship.

NAT Breaking Internal Connectivity: The ACL mistakenly permitted all traffic before denying private addresses, causing NAT to translate internal pings. Reordered ACL to deny RFC1918 first, preserving internal routing.

Port Security Violations: Tested recovery procedures using errdisable recovery and manual intervention.

## Results
End-to-end IP connectivity between all VLANs and loopbacks across sites.

Internet access for all internal hosts via NAT/PAT, with correct translation only for external destinations.

Secure remote management using SSHv2, eliminating clear-text Telnet.

Access ports protected against MAC flooding and unauthorized devices via sticky MAC learning.

## Lessons Learned
ACL order is critical when used with NAT – always deny internal ranges first.

OSPF requires a common transit network to form adjacencies.

Port security with sticky MACs simplifies administration while enhancing security.

Regular verification commands (show ip ospf neighbor, show ip nat statistics, show port-security) are essential for troubleshooting.

# This project demonstrates proficiency in routing, switching, network address translation, and security best practices in a multi-site Cisco environment.