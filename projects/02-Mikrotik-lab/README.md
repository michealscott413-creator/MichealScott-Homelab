# MikroTik hEX S Lab Router Setup # 

## April 2026 ##

**Goal**: Create an isolated lab network (192.168.10.0/24) behind the home TP-Link Archer VR1600v (192.168.1.0/24) while keeping the home wifi network untouched. Built from a clean (no default config) 
state.

### Physical Connections ###

- ether1 → TP-Link Archer LAN port (WAN side, gets DHCP IP 192.168.1.113)
- ether2 → Mac Mini (permanent admin console)
- ether3/4/5 → Future lab devices (Proxmox, switches, etc.)
- Bridge: lab-bridge (combines ether2–5 into one logical LAN switch)

### IP Addressing

Lab gateway: 192.168.10.1/24 on lab-bridge
WAN: Dynamic DHCP client on ether1 (currently 192.168.1.113/24)
DHCP pool for lab devices: 192.168.10.100–192.168.10.250
DNS: 8.8.8.8, 1.1.1.1

### Key Services

- DHCP server on lab-bridge
- Masquerade NAT (srcnat) on ether1 for internet access from lab
- Basic firewall (input + forward chains)

### Current Firewall Rules (as of 2026-04-08)

- Accept established/related (input & forward)
- Accept all traffic from lab-bridge → internet (forward)
- Accept lab devices accessing the router (input)
- Drop invalid connections
- Drop everything else to the router (protects against external access)


### Key Learnings

- Building from clean config teaches bridges, HW-offload behavior, routing, NAT, and firewall ordering.
- HW-offload requires initial traffic flow before pings to bridge IP work reliably.
- Double-NAT setup (Archer → hEX S) provides good isolation for homelab.

### Next Steps 

1. Move Proxmox to lab network (static 192.168.10.50)
2. Restrict WinBox/management to Mac Mini on ether2
3. Introduce VLAN for better admin/lab separation later
