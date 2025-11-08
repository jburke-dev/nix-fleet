# Desktop

Main desktop workstation running NixOS with Hyprland.

## Configuration

**Type:** desktop

**Features:** gui, hyprland, gaming, dev (default for desktop type)

**Theme:** dark (Stylix-based theming)

## Hardware

Custom built desktop workstation. See `hardware.nix` for hardware-specific configuration.

## Display Setup

Dual monitor configuration:
- **DP-1**: 3440x1440@100Hz ultrawide (left monitor)
- **DP-2**: Standard HD display (right monitor)

Each display has its own wallpaper directory configured.

## Software Highlights

### Window Manager
- [Hyprland](https://github.com/hyprwm/Hyprland) - Dynamic tiling Wayland compositor
- [ags-shell](https://github.com/jburke-dev/ags-shell) - Custom desktop shell built with AGS

### Development
- [Nixvim](https://github.com/nix-community/nixvim) - Neovim configured through Nix
- [Claude Code](https://claude.ai/code) - AI-powered code editor
- [Typst](https://github.com/typst/typst) for document preparation
- Git with custom configuration
- Python development with [uv](https://github.com/astral-sh/uv)

### Terminal
- [Ghostty](https://github.com/ghostty-org/ghostty) - GPU-accelerated terminal emulator
- [zsh](https://www.zsh.org/) - Shell with custom configuration

### Browsers
- [Firefox](https://www.mozilla.org/firefox/)
- [Vivaldi](https://vivaldi.com/)
- [Zen Browser](https://github.com/zen-browser/desktop) - Privacy-focused browser

### Gaming
- [Steam](https://store.steampowered.com/) with gaming optimizations

### Utilities
- Network utilities (enabled for network diagnostics)
- Discord for communication
- Microsoft Teams
- Obsidian for note-taking

## SSH Configuration

Configured SSH keys for:
- GitHub (personal repository access)
- pandora (router/firewall - 10.10.0.1)
- kraken (server - 10.12.1.1)

SSH configuration stored in `/mnt/apps/ssh`

## Deployment

Rebuild locally:
```bash
just rebuild-local
```

Build without activating:
```bash
just build desktop
```
