# 01 - Proxmox VE Setup on Acer C27-1655

**Status**: Completed (April 2026)

## What Was Done
- Upgraded RAM to 32GB (2x16GB Kingston ValueRAM)
- Clean installation of Proxmox VE 9.x
- Configured static IP 192.168.1.50 on vmbr0
- Created isolated bridge `vmbr1` for future lab VMs
- Disabled built-in screen blanking after 5 minutes
- Removed subscription nag + cleaned repositories
- Created first test VM: Ubuntu Server 24.04 LTS (VM ID 101, static IP 192.168.1.101)

## Key Learnings
- Proper bridge configuration in Proxmox (vmbr0 vs vmbr1)
- Netplan configuration on Ubuntu 24.04
- Importance of keeping lab network isolated from main home network
- Using static IPs that match VM IDs for easy tracking

## Screenshots Included
- Proxmox web GUI
- Network tab showing vmbr0 and vmbr1
- Ubuntu VM console

## Files
- `proxmox-lab-context.md` (for continuing conversations)

## Network Design

![Current Lab Network Diagram](../../docs/diagrams/current-lab-overview.png)

**Key Components:**
- `vmbr0`: Management bridge (192.168.1.50) – used by Proxmox GUI and management VMs
- `vmbr1`: Isolated lab bridge – future VMs will connect here
- Ubuntu Server 24.04 (VM 101) currently on vmbr0 with static IP 192.168.1.101

Last updated: April 4, 2026
