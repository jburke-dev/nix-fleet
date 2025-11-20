# Colossus

Colossus is a dedicated worker node in my k3s Kubernetes cluster. It's equipped with an NVIDIA GPU and is configured to handle GPU-accelerated workloads.

## Features

- **k3s Agent**: Configured as a worker node
- **NVIDIA GPU Support**: Enabled for containerized GPU workloads
- **IPMI**: Remote management capabilities
- **ZFS**: Filesystem with snapshot support and data integrity

## Configuration

The node is managed through my NixOS configuration with Denix framework. It inherits common settings from the `shared.nix` file while maintaining specific configurations for GPU support and IPMI access.

## Services

- k3s agent for container orchestration
- NVIDIA driver support
- IPMI daemon for remote management
- ZFS for storage management
