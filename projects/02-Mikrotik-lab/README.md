 # MikroTik hEX S: Isolated Homelab Architecture #

## 📋 Overview

This project demonstrates the deployment of a hardened, isolated Layer 3 environment using a MikroTik hEX S (RouterOS v7). The lab is architected to run behind a standard residential gateway (Double-NAT) to provide a "blast radius" protection, ensuring lab experiments do not impact the primary home network.

## 🏗️ Network Topology

   ```mermaid
flowchart TD
     %% Define Styles 
    classDef home fill:#e1f5fe,stroke:#01579b,color:#000,stroke-width:2px
    classDef lab fill:#fff3e0,stroke:#e65100,color:#000,stroke-width:2px
    classDef iso fill:#ffebee,stroke:#b71c1c,color:#000,stroke-width:2px

    %% Home Network
    subgraph Home_Net [Home Network: 192.168.1.0/24]
        ISP((Internet)) --- TP[TP-Link Archer]
        TP ---|WiFi| IoT((IoT Devices))
        TP ---|WiFi| WPC[Wife's PC]
    end

    %% Lab Network
    subgraph Lab_Net [Lab Network: 192.168.10.0/24]
        TP ---|ether1| HEX[MikroTik hEX S]
        HEX ---|Bridge| Mini[Mac Mini Admin]
        HEX ---|Bridge| PX[Proxmox Host]
    end

    %% Isolated Subnet
    subgraph Isolated_Net [Isolated VM Network: 10.10.10.0/24]
        PX ---|VMBR1| VM1[Ubuntu VM]
        PX ---|VMBR1| VM2[Win10 VM]
    end

    %% Apply Styles
    class TP,IoT,WPC home
    class HEX,Mini,PX lab
    class VM1,VM2 iso
```
## 🛠️ Technical Specifications

- Feature	Implementation
- Hardware	MikroTik RB760iGS (hEX S)
- OS	RouterOS v7.18.2
- Upstream (WAN)	DHCP Client on ether1
- Downstream (LAN)	192.168.10.1/24 on lab-bridge
- DHCP Pool	192.168.10.100 - .250
- DNS	Google (8.8.8.8) & Cloudflare (1.1.1.1)

## 🛡️ Security & Design Decisions

To ensure the lab remains a safe environment for testing without compromising the primary home network, the following design choices were made:
- Layer 3 Isolation (Double-NAT): The hEX S acts as a stateful firewall between the 192.168.1.x and 192.168.10.x networks. This prevents "lab spillover"—traffic from experimental VMs cannot reach the home IoT or PC devices unless explicitly permitted.
- Virtual Switch Segregation (VMBR1): Within Proxmox, a dedicated Linux Bridge (VMBR1) was created with no physical port attachment. NAT with firewall implemented between the 192.168.10.x and 10.10.10.x networks.
- Management Hardening: Access to the MikroTik's management interfaces (WinBox/WebFig) is restricted to the Mac Mini's static IP. All other attempts from the 192.168.10.0/24 range are dropped at the input chain.
- Minimalist WAN Footprint: The MikroTik uses a dynamic DHCP client on its WAN port, allowing it to be "portable" and easily moved to any other upstream gateway without configuration changes.


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

