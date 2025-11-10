# Kaiju

Custom-built AMD EPYC server for testing and future k3s cluster deployment.

## Configuration

**Type:** server

**Features:** None (minimal server configuration)

**IP Address:** 10.12.1.2 (servers VLAN)

## Hardware

Custom-built. See `hardware.nix` for hardware-specific configuration.

## Network Configuration

Connected to the servers VLAN (VLAN 12) with static IP assignment via MAC address reservation.

## Current Role

Currently configured as a minimal server for testing purposes. This host will eventually be part of a k3s cluster deployment.

## Deployment

Deploy from another machine:

```bash
just rebuild-remote kaiju
```

Deploy along with all other servers:

```bash
just rebuild-servers
```

Initial deployment with nixos-anywhere:

```bash
just deploy kaiju <IP_ADDRESS>
```

Build without deploying:

```bash
just build kaiju
```
