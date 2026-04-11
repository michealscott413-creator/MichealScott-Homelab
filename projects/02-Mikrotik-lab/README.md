 # MikroTik hEX S: Isolated Homelab Architecture #

## 📋 Overview

This project demonstrates the deployment of a hardened, isolated Layer 3 environment using a MikroTik hEX S (RouterOS v7). The lab is architected to run behind a standard residential gateway (Double-NAT) to provide a "blast radius" protection, ensuring lab experiments do not impact the primary home network.

## 🏗️ Network Topology

mermaid

graph TD
    subgraph "Home Network (192.168.1.0/24)"
        ISP((Internet)) --- Gateway[TP-Link Archer VR1600v]
    end

    subgraph "Isolated Lab (192.168.10.0/24)"
        Gateway ---|ether1| MikroTik[MikroTik hEX S]
        MikroTik ---|Bridge| L-Switch[Lab Bridge: ether2-5]
        L-Switch --- Admin[Admin Console: Mac Mini]
        L-Switch --- Proxmox[Proxmox VE Host]
        L-Switch --- Future[IoT / Lab Expansion]
    end


## 🛠️ Technical Specifications

- Feature	Implementation
- Hardware	MikroTik RB760iGS (hEX S)
- OS	RouterOS v7.18.2
- Upstream (WAN)	DHCP Client on ether1
- Downstream (LAN)	192.168.10.1/24 on lab-bridge
- DHCP Pool	192.168.10.100 - .250
- DNS	Google (8.8.8.8) & Cloudflare (1.1.1.1)

## 🛡️ Security Implementation

The configuration follows the Principle of Least Privilege. Key security measures include:
- Management Plane Isolation: WinBox and WebFig access are strictly limited via firewall source-address filtering to the Admin Console only.
- Stateful Firewalling:
    - Input Chain: Protects the router. Uses an "Implicit Deny" strategy—only established/related traffic and specific management IPs are permitted.
    - Forward Chain: Controls transit traffic. Allows Lab-to-Internet but blocks unsolicited inbound traffic from the home network.
    - NAT Scoping: Masquerade is strictly bound to out-interface=ether1 to prevent accidental leakage between subnets.

## 🚀 Key Learnings & Engineering Decisions

- Infrastructure from Scratch: Bypassed "Default Configuration" to gain a granular understanding of bridge hair-pinning and HW-offload behavior.
- Hardware Offloading: Identified that initial ARP/Traffic flow is required before bridge pings stabilize, confirming hardware-level switching logic.
- Double-NAT Strategy: Successfully utilized a nested router setup to create a sandbox environment that is physically connected but logically separated from the home ISP gateway.

## 📅 Roadmap

- Phase 2: Migrate Proxmox VE nodes to static assignments in the .10.x range.
- Phase 3: Implement VLAN Trunking (802.1Q) to separate Management, Production, and IoT traffic within the lab.
P- hase 4: Configure a WireGuard VPN peer on the MikroTik for secure remote lab access.

## 📝 Configuration Reference

- The full RouterOS configuration is available in /configs/router-config.txt. All sensitive identifiers (Serial Numbers/MACs) and internal credentials have been redacted for security.

