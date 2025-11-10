# Glados

Framework desktop mini-PC for testing and future k3s cluster deployment.

## Configuration

**Type:** server

**Features:** None (minimal server configuration)

**IP Address:** 10.12.1.3 (servers VLAN)

## Hardware

Framework desktop. See `hardware.nix` for hardware-specific configuration.

## Network Configuration

Connected to the servers VLAN (VLAN 12) with static IP assignment via MAC address reservation.

## Current Role

Currently configured as a minimal server for testing purposes. This host will eventually be part of a k3s cluster deployment.

## Deployment

Deploy from another machine:

```bash
just rebuild-remote glados
```

Deploy along with all other servers:

```bash
just rebuild-servers
```

Initial deployment with nixos-anywhere:

```bash
just deploy glados <IP_ADDRESS>
```

Build without deploying:

```bash
just build glados
```
