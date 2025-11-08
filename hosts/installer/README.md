# Installer

NixOS installation ISO image for deploying new hosts.

## Configuration

**Type:** server

**Features:** installer

## Description

This configuration builds a custom NixOS installation ISO that can be used to bootstrap new hosts in the homelab. The installer includes necessary tools and configurations for initial system deployment.

## Special Configuration

- **zsh disabled**: Uses default shell for compatibility
- **Stable kernel**: Uses standard Linux kernel (not latest) to avoid potential ZFS compatibility issues during builds

## Building the ISO

Build the ISO image:

```bash
just build-installer
```

This creates an ISO file in `./result/iso/`

## Writing to USB Drive

Write the installer to a USB device (replace `sdX` with your device):

```bash
just write-installer sdX
```

**Warning:** This will overwrite all data on the target device.

## Usage

1. Build the installer ISO
2. Write to a USB drive
3. Boot target machine from USB
4. Use `nixos-anywhere` for automated deployment:

   ```bash
   just deploy <hostname> <target-ip>
   ```

## Deployment with nixos-anywhere

The installer works in conjunction with [nixos-anywhere](https://github.com/nix-community/nixos-anywhere) for automated NixOS installations. The `just deploy` command will:

- Partition disks according to the host's disko configuration
- Install NixOS with the specified host configuration
- Set up SSH keys and secrets
