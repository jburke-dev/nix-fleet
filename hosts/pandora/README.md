# Pandora

Custom router/firewall running on an Intel N355-based mini-PC.

## Configuration

**Type:** server

**Features:** router

**IP Address:** 10.10.0.1 (LAN bridge)

## Hardware

Intel N355-based mini-PC. See `hardware.nix` for hardware-specific configuration.

## Network Configuration

Pandora serves as the primary router and firewall for the homelab, managing multiple VLANs and providing core network services.

### Network Topology

- **lan** (VLAN 10, bridge): Infrastructure network (10.10.0.0/16)
- **servers** (VLAN 12): Server network with static DHCP (10.12.0.0/16)
- **trusted** (VLAN 20): Trusted devices with dynamic DHCP (10.20.0.0/16)
- **untrusted** (VLAN 25): IoT and untrusted devices with static DHCP (10.25.0.0/16)

### Firewall Rules

Using [nftables](https://netfilter.org/projects/nftables/) for firewall management with network-specific outbound policies:

- **lan**: Full access to all networks
- **servers**: Access to WAN, trusted, and servers networks
- **trusted**: Access to WAN, lan, servers, and untrusted networks
- **untrusted**: Isolated - only WAN and untrusted network access

Configuration in `modules/networking/router/firewall.nix`

### DNS

[Blocky](https://github.com/0xERR0R/blocky) - Ad-blocking DNS server with:

- Ad and tracker blocking
- Custom upstream resolvers
- Query logging
- Per-network DNS policies

Configuration in `modules/networking/router/dns.nix`

### DHCP

[Kea](https://github.com/isc-projects/kea) - DHCP server providing:

- Static DHCP reservations for servers and infrastructure
- Dynamic DHCP pools for trusted devices
- VLAN-aware DHCP serving

Configuration in `modules/networking/router/dhcp-server.nix`

### Kernel Configuration

Custom kernel parameters for IP forwarding and routing optimized for gateway operations.

Configuration in `modules/networking/router/kernel.nix`

## Deployment

Deploy from another machine:

```bash
just rebuild-remote pandora
```

Initial deployment with nixos-anywhere:

```bash
just deploy pandora <IP_ADDRESS>
```

Build without deploying:

```bash
just build pandora
```
