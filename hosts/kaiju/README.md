# Kaiju

Custom-built AMD EPYC server running as part of the k3s HA cluster.

## Configuration

**Type:** server

**Features:** None (minimal server configuration)

**IP Address:** 10.12.1.2 (servers VLAN)

**Cluster Role:** k3s control plane + workload node

## Hardware

Custom-built AMD EPYC. See `hardware.nix` for hardware-specific configuration.

## Network Configuration

Connected to the servers VLAN (VLAN 12) with static IP assignment via MAC address reservation.

## k3s Cluster Role

This host is one of three nodes in a highly available k3s cluster. All three nodes (kraken, kaiju, glados) run as control plane nodes with kube-vip providing HA using virtual IP 10.12.1.100. The nodes are not tainted, allowing them to run workloads alongside control plane components.

### Cluster Infrastructure

The cluster has the following infrastructure deployed:

- **kube-vip** - HA control plane with virtual IP failover (10.12.1.100)
- **Traefik** - Ingress controller with automatic TLS termination
- **cert-manager** - Let's Encrypt certificate management with Cloudflare DNS validation
- **Reflector** - Automatic secret and configmap replication across namespaces
- **Longhorn** - Distributed block storage with 3-way replication
- **MetalLB** - Load balancer providing IPs from pool 10.12.1.100-10.12.1.200
- **SOPS** - Encrypted secrets management for Kubernetes

### Managing the Cluster

Access the cluster using `kubectl` from any machine with the kubeconfig. The kubeconfig should point to the kube-vip virtual IP (10.12.1.100) for HA access. Cluster configuration and manifests are stored in the repository's `k8s/` directory.

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
