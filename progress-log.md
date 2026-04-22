# Homelab Progress Log

This log tracks my hands-on learning journey. I update it as I complete tasks.

## April 2026

- Successfully installed and configured Proxmox VE 9.x on Acer C27-1655
- Created secondary isolated lab bridge in proxmox 'vmbr1'
- setup second router behind isp router with seperate subnet and bridged lan ports.
- Created first test VM: Ubuntu Server 24.04 LTS (VM ID 101)
- Created Windows 10 VM v25H2 for windows command practice 
- created Kali-linux VM with rdp enabled
- Configured static IP's for vms and dhcp for second router
- configured subnets behind Mikrotik router and proxmox bridge, both with NAT into the subnets.
- Passed comptia A+ exams and move on to network + study.

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

## March 2026

**March 23-29, 2026**
- Upgraded Acer C27-1655 from stock RAM to **32GB (2x16GB Kingston ValueRAM DDR4-3200)**
- Created full system backup of original Windows installation
- Created GitHub repo `MichealScott-Homelab` for documentation
- Prepared Proxmox installation (ISO ready, but paused waiting for MikroTik + longer Ethernet cable)


## Overall Certification & Lab Roadmap (18 months)

| Cert                  | Target Completion | Status      | Notes                     |
|-----------------------|-------------------|-------------|---------------------------|
| CompTIA A+            | April 2026        | Completed   | Core hardware & OS        |
| Network+              | June 2026         | in progress | -                         |
| Security+             | August 2026       | Not started | -                         |
| CCNA                  | October 2026      | Not started | -                         |
| AZ-104                | December 2026     | Not started | Hybrid cloud focus        |

