# AGENTS.md

This file provides guidance to agentic coding models when working with code in this repository.

## Development Environment

This is a NixOS homelab infrastructure repository using Denix framework. The environment is configured with:

- Nix flakes for dependency management
- Home Manager for user environment configuration
- Denix framework for modular NixOS configuration
- SOPS-nix for secrets management
- Pre-commit hooks via git-hooks-nix

## Development Commands

Use Just for task automation:

- `just fmt` - Format all Nix files using nixfmt-tree
- `just rebuild-local` - Rebuild current host configuration locally
- `just rebuild-boot-local` - Rebuild current host configuration for next boot
- `just rebuild-remote HOST` - Deploy configuration to remote HOST
- `just rebuild-boot-remote HOST` - Deploy configuration to remote HOST for next boot
- `just rebuild-servers` - Deploy to all servers in parallel (kraken)
- `just build HOST [TARGET]` - Build specific host configuration (default: toplevel)
- `just build-installer` - Build NixOS installer ISO image
- `just write-installer DEV` - Write installer ISO to device
- `just deploy HOST IP` - Deploy to a new host using nixos-anywhere

For manual Nix operations:

- `nix flake update` - Update all flake inputs
- `nix build '.#nixosConfigurations.HOST.config.system.build.TARGET'` - Build specific target
- `sudo nixos-rebuild switch --flake .#HOST` - Manual rebuild for HOST

## Architecture Overview

### Flake Structure

This is a modular NixOS configuration using the Denix framework with flake-parts. The main inputs include:

- nixpkgs (nixos-unstable)
- home-manager
- denix (modular configuration framework)
- hyprland & hyprXPrimary (window manager and plugins)
- nixvim (Neovim configuration framework)
- stylix (system-wide theming)
- sops-nix (secrets management)
- git-hooks-nix (pre-commit hooks)
- ags-shell (custom desktop shell)
- zen-browser (privacy-focused browser)
- nixos-anywhere & disko (automated deployment and partitioning)

### Host Types and Features

Hosts are categorized by type with associated feature sets:

- **desktop**: gui, hyprland, gaming, dev
- **laptop**: gui, hyprland, dev
- **server**: Minimal base configuration (features added explicitly)

Available features: gui, hyprland, gaming, dev, installer, nvidia, router

Current active hosts:

- **desktop** - Main desktop workstation (type: desktop)
- **laptop** - Portable machine (type: laptop)
- **pandora** - Router/firewall (type: server, features: router)
- **kraken** - k3s HA cluster control plane node (type: server)
- **glados** - k3s HA cluster control plane node (type: server)
- **kaiju** - k3s HA cluster control plane node (type: server)
- **colossus** - k3s HA cluster worker node (type: server)
- **installer** - NixOS installation ISO (type: server, features: installer)

### Module Organization

**Config** (`modules/config/`):

- `constants.nix` - Shared constants (username, email)

**Top-level modules** (`modules/top-level/`):

- System configuration: boot, disko (disk partitioning), fonts, nix settings
- Graphics configuration (X11, Wayland)
- User interface: gtk, stylix (theming), xdg
- `home-manager.nix` - Home Manager integration
- `secrets.nix` - SOPS secrets management
- `user.nix` - User account configuration
- `localization.nix` - Locale and timezone settings

**Networking** (`modules/networking/`):

- `default.nix` - Core networking configuration with network definitions
- `client/` - Client-specific networking (for desktops/laptops)
- `server/` - Server networking configuration with systemd-networkd
- `router/` - Router-specific modules:
  - `firewall.nix` - nftables firewall rules
  - `dns.nix` - Blocky DNS with ad-blocking
  - `dhcp-server.nix` - Kea DHCP server
  - `kernel.nix` - Kernel parameters for routing
  - `networking.nix` - Router network interfaces

**Programs** (`modules/programs/`):

- AI tools: `ai-tools/` (claude-code, mcp-servers)
- Browsers: `browsers/` (firefox, vivaldi, zen)
- Development: `dev-utils.nix`, `git.nix`, `nixvim/`, `vim/`, `python.nix`, `kubectl.nix`, `typst.nix`
- Desktop apps: `discord.nix`, `teams.nix`, `steam.nix`, `note-taking/` (obsidian)
- Hyprland WM: `hyprland/` with extensive submodules:
  - `default.nix`, `binds.nix`, `rules.nix`, `plugins.nix`
  - `display-manager.nix`, `wallpaper.nix`, `hyprlock.nix`
  - `custom-shell.nix` (ags-shell integration)
  - `wleave/` (logout menu), `utils.nix`
- Terminal: `kitty.nix`, `zsh.nix`
- Utilities: `general-utils.nix`, `network-utils.nix`, `ssh.nix`

**Services** (`modules/services/`):

- `audio.nix` - PipeWire audio configuration
- `sshd.nix` - SSH daemon
- `default.nix` - Service defaults

**Overlays** (`modules/overlays/`):

- Package overlays and modifications

**Host Configurations** (`hosts/`):
Each host directory contains:

- `default.nix` - Host definition using `delib.host` with type, features, and host-specific config
- `hardware.nix` - Hardware-specific configuration (generated by nixos-generate-config)
- Optional: `networking.nix`, `services.nix` for complex configurations

### Denix Framework Usage

- Uses `delib.host` for host definitions
- Uses `delib.module` for reusable modules
- Supports feature flags and host type defaults
- Integrates with Home Manager through `homeconfig` argument

### Rice (Theme) System

Theming configurations in `rices/` directory:

- `dark.nix` - Dark theme configuration using Stylix
- `empty.nix` - Minimal/no theming
- Applied via `rice = "dark"` in host configs

## Common Patterns

**Adding a new host:**

1. Create directory in `hosts/` with the host name
2. Create `default.nix` using `delib.host` with:
   - `name` - hostname
   - `type` - desktop, laptop, or server
   - `features` - optional feature flags (overrides type defaults)
   - `myconfig` - host-specific configuration options
   - `rice` - optional theme selection
3. Generate and add `hardware.nix` with `nixos-generate-config`
4. For servers, configure networking in the module with MAC addresses and links

**Adding a program module:**

1. Create in `modules/programs/` (or appropriate subdirectory)
2. Use `delib.module` with:
   - Feature flags to control when the module is active
   - Options in `options.myconfig.programs.MODULE_NAME`
   - NixOS config in `nixos.ifEnabled`
   - Home Manager config in `home.ifEnabled`
3. Both NixOS and Home Manager configs are optional - use what you need

**Networking configuration:**

- Network topology defined in `modules/networking/default.nix`
- Networks: lan (router bridge, used for infrastructure), servers (vlan 12), trusted (vlan 20), untrusted (vlan 25)
- Static hosts configured with MAC addresses in the networking module
- Client networking (desktop/laptop) configured in `modules/networking/client/`
- Server networking uses systemd-networkd in `modules/networking/server/`
- Router uses nftables firewall, Blocky DNS, and Kea DHCP

**Secrets management:**

- SOPS-nix encrypts secrets per-host using each host's SSH keys
- Secrets are encrypted in the repository and decrypted at activation time
- Configure secrets in `modules/top-level/secrets.nix`

**Server deployment:**

- Use `just rebuild-remote HOST` for deploying to existing servers
- Use `just deploy HOST IP` for initial deployment with nixos-anywhere
- Use `just rebuild-servers` to deploy to all servers in parallel

**k3s Cluster:**

- Highly available four-node cluster: kraken, glados, kaiju, and colossus
- kraken, glados, and kaiju run as control plane nodes with workload scheduling enabled
- colossus runs as a worker node with workload scheduling enabled
- kube-vip provides control plane HA with virtual IP 10.12.1.100
- Cluster configurations stored in `k8s/` directory

## K3s Cluster Applications

The k3s cluster hosts several key applications and services:

- Secrets managed via SOPS in `k8s/secrets/`
- Manifests for cluster-wide resources in `k8s/infrastructure/manifests/`
- Cluster-wide resources have Helm values in `k8s/infrastructure/COMPONENT/values.yaml` as well as custom manifests in `k8s/infrastructure/manifests`
- Applications have Helm values in `k8s/apps/COMPONENT/values.yaml` as well as custom manifests in `k8s/apps/manifests/`

### Observability

- **kube-prometheus-stack**: Prometheus, Grafana, and Alertmanager for monitoring and alerting
- **Longhorn**: Distributed block storage solution with 3-way replication and snapshots

### Networking & Ingress

- **Traefik**: Ingress controller with automatic TLS termination
- **MetalLB**: Load balancer for bare-metal environments using IP pool 10.12.1.100-10.12.1.200
- **kube-vip**: HA control plane with virtual IP 10.12.1.100

### Security & Secrets

- **cert-manager**: Let's Encrypt certificates with Cloudflare DNS validation
- **SOPS**: Kubernetes secrets encrypted with age keys for secure secret management

### Databases

- **cloudnative-pg**: PostgreSQL operator for managed database clusters
- **Longhorn**: Storage infrastructure for database persistent volumes

### Applications

- **vaultwarden**: Password manager (Bitwarden-like) instance for secure credential storage
- **ollama**: Local AI model serving for running large language models
