# Kali Linux VM overview

## Proxmox config

- **ISO** = AMD86 "Installer" v2026.1
- **RAM** = 8GB
- **disk** = 64GB
- **CPU cores** = 2
- **QEMU agent** = Enabled
- All other settings left on default

## Kali Linux config and changes

- install xrdp
- install qemu-guest-agent xrdp
- update etc/xdrp/startwm.sh
    - add at top:
    - export DESKTOP_SESSION=kali
    - export GNOME_SHELL_SESSION_MODE=kali
    - export XDG_CURRENT_DESKTOP=kali:GNOME

**Commands to start XRDP service**
- sudo service xrdp start 
- sudo service xrdp-sesman start 
- sudo service xrdp status
