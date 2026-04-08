# 2026-04-08 19:11:47 by RouterOS 7.18.2
# software id = BEXH-JNPZ
#
# model = RB760iGS
# serial number = HJX0AN9WRF3
/interface bridge
add name=lab-bridge protocol-mode=none
/ip pool
add name=lab-pool ranges=192.168.10.100-192.168.10.250
/ip dhcp-server
add address-pool=lab-pool interface=lab-bridge name=lab-dhcp
/interface bridge port
add bridge=lab-bridge interface=ether2
add bridge=lab-bridge interface=ether3
add bridge=lab-bridge interface=ether4
add bridge=lab-bridge interface=ether5
/ip address
add address=192.168.10.1/24 interface=lab-bridge network=192.168.10.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server network
add address=192.168.10.0/24 dns-server=8.8.8.8,1.1.1.1 domain=lab.local \
    gateway=192.168.10.1
/ip firewall filter
add action=accept chain=input comment="Allow established/related input" \
    connection-state=established,related
add action=accept chain=forward comment="Allow established/related forward" \
    connection-state=established,related
add action=accept chain=input comment="Allow established/related input" \
    connection-state=established,related
add action=accept chain=forward comment="Allow established/related forward" \
    connection-state=established,related
add action=accept chain=forward comment="Allow lab -> internet" in-interface=\
    lab-bridge out-interface=ether1
add action=accept chain=input comment=\
    "Allow lab devices to access the router" in-interface=lab-bridge
add action=drop chain=input comment="Drop all other input (protect router)"
add action=drop chain=input comment="Drop invalid connections" \
    connection-state=invalid
add action=drop chain=forward comment="Drop invalid forward" \
    connection-state=invalid
/ip firewall nat
add action=masquerade chain=srcnat comment="Lab NAT to WAN" out-interface=\
    ether1
/ip route
add dst-address=192.168.10.0/24 gateway=lab-bridge
/system clock
set time-zone-name=Australia/Brisbane
/system note
set show-at-login=no
