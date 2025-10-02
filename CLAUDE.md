# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

This is a NixOS homelab infrastructure repository using Denix framework. Use Just for task automation:

- `just fmt` - Format all Nix files using nixfmt-tree
- `just rebuild-local` - Rebuild current host configuration locally
- `just rebuild-remote HOST` - Deploy configuration to remote HOST
- `just build HOST [TARGET]` - Build specific host configuration (default: toplevel)
- `just build-installer` - Build NixOS installer ISO image
- `just write-installer DEV` - Write installer ISO to device

For manual Nix operations:
- `nix flake update` - Update all flake inputs
- `nix build '.#nixosConfigurations.HOST.config.system.build.TARGET'` - Build specific target
- `sudo nixos-rebuild switch --flake .#HOST` - Manual rebuild for HOST

## Architecture Overview

### Flake Structure
This is a modular NixOS configuration using the Denix framework with flake-parts. The main inputs include:
- nixpkgs (25.05 stable)
- nixpkgs-unstable  
- home-manager
- denix (modular configuration framework)
- Various specialized inputs (nixvim, stylix, sops-nix, etc.)

### Host Types and Features
Hosts are categorized by type with associated feature sets:
- **desktop**: CLI, GUI, Hyprland, gaming, dev tools
- **laptop**: CLI, GUI, GNOME, dev tools  
- **server**: Minimal base configuration
- **installer**: Live boot environment

Available features: cli, gui, gnome, hyprland, gaming, dev, installer, reverseProxy

### Module Organization

**Top-level modules** (`modules/top-level/`):
- Core system configuration (boot, networking, graphics, fonts)
- Home Manager integration
- User management and secrets (SOPS)

**Programs** (`modules/programs/`):
- Desktop applications (browsers, Discord, Obsidian)
- Development tools (nixvim, git, dev-utils)
- Window managers (Hyprland with waybar, anyrun, hyprlock)
- Terminal and shell configuration

**Services** (`modules/services/`):
- Server services (Forgejo, Vaultwarden, Blocky DNS)
- Reverse proxy (Traefik) with service-specific configs
- System services (SSH, audio, ZFS)

**Host Configurations** (`hosts/`):
Each host directory contains:
- `default.nix` - Host definition with type, features, and specific config
- `hardware.nix` - Hardware-specific configuration
- Optional: `networking.nix`, `services.nix`, `shared.nix` for complex hosts

### Denix Framework Usage
- Uses `delib.host` for host definitions
- Uses `delib.module` for reusable modules
- Supports feature flags and host type defaults
- Integrates with Home Manager through `homeconfig` argument

### Rice (Theme) System
Theming configurations in `rices/` directory:
- `dark.nix` - Dark theme configuration
- Applied via `rice = "dark"` in host configs

## Common Patterns

**Adding a new host:**
1. Create directory in `hosts/`
2. Define in `default.nix` using `delib.host`
3. Set appropriate type and features
4. Add hardware configuration

**Adding a program module:**
1. Create in `modules/programs/`
2. Use `delib.module` with feature flags
3. Support both NixOS and Home Manager configs as needed

**Server deployment:**
- Use `just rebuild-remote HOST` for remote deployment
- Hosts share configurations where appropriate (locust 1-3)
- SOPS for secrets management