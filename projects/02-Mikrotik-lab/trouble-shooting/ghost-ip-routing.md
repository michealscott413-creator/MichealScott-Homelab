## Persistent ICMP "Host Unreachable" Errors After Subnet Migration

After moving a Proxmox host from 192.168.1.0/24 to 192.168.10.0/24 and placing VMs behind a NAT on 10.10.10.0/24 (vmbr1), tcpdump began reporting continuous ICMP error logs. Specifically, the VM (10.10.10.x) was trying to reach the host's old IP (192.168.1.x), and the Proxmox bridge was rejecting the traffic as "Unreachable."

### Fix Attempt 1: Network Configuration Audit

**What:** Verified /etc/netplan/50-cloud-init.yaml on VM and /etc/network/interfaces on host contained no traces of old IP configurations and ran ip addr show.
**Why:** To ensure the VM and host was correctly assigned to the correct respective subnet and not holding a secondary "ghost" IP from the old range.
**Result:** Inconclusive. The configuration was correct, but the VM was still generating traffic directed at the old address.

### Fix Attempt 2: ARP Cache Clearing

**What:** Executed ip neigh flush all on both the Proxmox host and the VM.
**Why:** To rule out stale Address Resolution Protocol (ARP) tables mapping the old IP to a physical MAC address that no longer existed on that bridge.
**Result:** Failed. The ICMP error messages persisted in the logs immediately after the flush.

### Fix Attempt 3: Kernel Routing Trace

**What:** Ran ip route get 192.168.1.x inside the VM.
**Why:** To determine if the Linux kernel had a static route leftover or if it was treating the old IP as a local or external destination.
**Result:** Insight Gained. The output showed the VM was correctly sending the traffic to its gateway (10.10.10.1). This proved the network stack was healthy, but an internal application was still requesting the old IP.

### Fix Attempt 4: Configuration Grep (The Solution)

**What:** assess prometheus.yml file
**Why:** To find hardcoded IP references in service configurations for prometheus.
**Result:** Success. Found the legacy IPs for proxmox and VM (192.168.1.x) hardcoded in the prometheus.yml file as a scrape target for host metrics.

### Final Resolution
The issue was caused by Prometheus attempting to scrape the Proxmox host using its decommissioned IP. Updating the static_configs target in prometheus.yml to the new host IP and restarting the container successfully stopped the ICMP "Host Unreachable" errors.