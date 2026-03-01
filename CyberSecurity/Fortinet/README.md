# Fortinet - FortiGate

## Manual Installation


### Network Diagram

<img src="diagram.png"/>

## Initial Setup

config system interface
    edit "port1"
    set mode static
    set ip <NEW_IP_ADDRESS> <SUBNET_MASK>
    set allowaccess ping https ssh
    set description "Your Description"
    next
end

config system interface
    edit "port2"
    set mode static
    set ip <NEW_IP_ADDRESS> <SUBNET_MASK>
    set allowaccess ping https ssh
    set description "Your Description"
    next
end

<img src="fortigate_cli.png"/>

<img src="fortigate_gui.png"/>

## Simple ACLs configurations

<img src="acl.png"/>
<img src="acl2.png"/>
<img src="acl3.png"/>
<img src="acl4.png"/>

### Testing conectivities

<img src="conectivies_OK.png"/>

### Extra - Cisco WLC initial setup

<img src="wlc_configs.png"/>
