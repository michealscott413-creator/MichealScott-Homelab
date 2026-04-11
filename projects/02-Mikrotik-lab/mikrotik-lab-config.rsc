# 2026-04-11 19:08:49 by RouterOS 7.18.2
# software id = Redacted
#
# model = RB760iGS
# serial number = Redacted
/interface bridge
add name=lab-bridge protocol-mode=none
/ip pool
add name=lab-pool ranges=192.168.10.x-192.168.10.x
/ip dhcp-server
add address-pool=lab-pool interface=lab-bridge name=lab-dhcp
/interface bridge port
add bridge=lab-bridge interface=ether2
add bridge=lab-bridge interface=ether3
add bridge=lab-bridge interface=ether4
add bridge=lab-bridge interface=ether5
/ip address
add address=192.168.10.x/24 interface=lab-bridge network=192.168.10.x
/ip dhcp-client
add interface=ether1
/ip dhcp-server lease
add address=192.168.10.x comment="Mac Mini Admin Console" mac-address=\
    xx:xx:xx:xx:xx:xx
/ip dhcp-server network
add address=192.168.10.0/24 dns-server=8.8.8.8,1.1.1.1 domain=lab.local \
    gateway=192.168.10.x
/ip firewall filter
add action=accept chain=input comment="1-Allow established/related input" \
    connection-state=established,related
add action=accept chain=forward comment="2-Allow established/related forward" \
    connection-state=established,related
add action=accept chain=input comment=\
    "Allow lab devices to access the router" disabled=yes in-interface=\
    lab-bridge
add action=accept chain=forward comment="3-Allow lab -> internet" \
    in-interface=lab-bridge out-interface=ether1
add action=accept chain=input comment="Allow WinBox only from Mac Mini" \
    dst-port=8291 protocol=tcp src-address=192.168.10.x
add action=accept chain=input comment="Allow WebFig only from Mac Mini" \
    dst-port=80,443 protocol=tcp src-address=192.168.10.x
add action=drop chain=input comment="drop invalid input" connection-state=\
    invalid
add action=drop chain=forward comment="Drop invalid forward" \
    connection-state=invalid
add action=drop chain=input comment="5-Drop all other input (protect router)"
/ip firewall nat
add action=masquerade chain=srcnat comment="Lab NAT to WAN" out-interface=\
    ether1
/ip route
add dst-address=192.168.10.0/24 gateway=lab-bridge
/system clock
set time-zone-name=Australia/Brisbane
/system note
set show-at-login=no