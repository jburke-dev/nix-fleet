# Kraken

Minisforum MS-01 server for testing and future k3s cluster deployment.

## Configuration

**Type:** server

**Features:** None (minimal server configuration)

**IP Address:** 10.12.1.1 (servers VLAN)

**MAC Address:** 58:47:ca:7d:96:ae

## Hardware

Minisforum MS-01. See `hardware.nix` for hardware-specific configuration.

## Network Configuration

Connected to the servers VLAN (VLAN 12) with static IP assignment via MAC address reservation.

## Current Role

Currently configured as a minimal server for testing purposes. This host will eventually be part of a k3s cluster deployment.

## Deployment

Deploy from another machine:
```bash
just rebuild-remote kraken
```

Deploy along with all other servers:
```bash
just rebuild-servers
```

Initial deployment with nixos-anywhere:
```bash
just deploy kraken <IP_ADDRESS>
```

Build without deploying:
```bash
just build kraken
```
