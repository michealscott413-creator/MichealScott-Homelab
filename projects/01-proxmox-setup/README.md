## MikroTik hEX S + Proxmox Network Isolation Setup (April 2026)

**Status**: Completed ✅

### Objective
Create a fully isolated lab network behind the home Archer VR1600v while keeping the home network untouched. Built the entire router configuration **from a clean (no-default) state** for maximum learning.

### Physical & Logical Layout
- ISP → Archer VR1600v (home WiFi + LAN1)
- Archer LAN1 → MikroTik hEX S ether1 (WAN)
- MikroTik ether2 → Admin PC (Mac Mini – permanent management console)
- MikroTik ether3 → Proxmox C27-1655
- Proxmox:
  - `vmbr0` – Management bridge (connected to MikroTik lab network)
  - `vmbr1` – Isolated lab bridge (no physical uplink)
    - ubuntu vm
    - windows-10 vm

**Networks**:
- Home Network: 192.168.1.0/24
- Management Network: 192.168.10.0/24 (behind MikroTik)
- Isolated Lab Network: 10.10.10.0/24 (NAT behind Proxmox)

## Network Design

![Current Lab Network Diagram](../../docs/diagrams/current-lab-overview.png)

**Key Services Running**:
- MikroTik: DHCP server, masquerade NAT, basic firewall
- Proxmox: iptables NAT from vmbr1 → vmbr0
- VMs: Ubuntu Server 24.04 and Windows 10 on vmbr1

*(See `diagrams/network-diagram-2026-04.png` for visual)*

### Major Learnings & Skills Gained

**MikroTik (RouterOS 7.18.2)**
- Built router from clean slate (no default config)
- Created and understood `bridge` concept (`lab-bridge` on ether2–5) – behaves like a built-in managed switch
- Hardware offload (HW) behaviour and why it sometimes needs initial traffic to work
- WAN DHCP client + default route
- Masquerade NAT (srcnat) for internet sharing
- Firewall **chains** (`input` vs `forward`), rule ordering, `established/related`, and drop policies
- Restricted management (WinBox + WebFig) to only the admin PC using `src-address` rules
- DHCP server, static leases, and pools

**Proxmox Networking**
- Dual-bridge setup (`vmbr0` management + `vmbr1` isolated)
- Linux bridge with no physical ports (pure virtual switch)
- iptables masquerade NAT (`POSTROUTING`) and IP forwarding
- Persistent NAT rules via `/etc/network/interfaces` (post-up/post-down)
- Traffic flow between subnets (management ↔ isolated lab)

**Security & Best Practices**
- Double-NAT isolation (home router → MikroTik → Proxmox)
- Principle of least privilege on firewall (only Mac can manage router)
- Dropping invalid connections and everything else to the router
- Never exposing management ports to the entire lab network
- Using private subnets (non-overlapping with home network)
- Documenting everything before moving production-like services

**Troubleshooting Skills**
- Lost management access during bridge/IP changes → recovered via MAC address in WinBox
- Bridge not responding to pings until HW-offload was temporarily disabled
- Firewall rule ordering (broad allow rules vs specific drop rules)

### Next Milestones
- Add VLANs with upcoming Cisco switch (practice CCNA commands)
- Move additional services (Pi-hole, Prometheus/Grafana) to isolated lab network
- Add selective inter-network firewall rules (e.g. Mac → specific lab services)

**Last updated**: April 11, 2026  
**Config backups**: `mikrotik-lab-config.rsc` + Proxmox `/etc/network/interfaces` snippet saved in repo.