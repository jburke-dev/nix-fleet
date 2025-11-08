# Laptop

Portable laptop running NixOS with Hyprland.

## Configuration

**Type:** laptop

**Features:** gui, hyprland, dev (default for laptop type)

**Theme:** dark (Stylix-based theming)

## Hardware

See `hardware.nix` for hardware-specific configuration.

## Software Highlights

### Window Manager

- [Hyprland](https://github.com/hyprwm/Hyprland) - Dynamic tiling Wayland compositor
- [ags-shell](https://github.com/jburke-dev/ags-shell) - Custom desktop shell built with AGS

### Development

- [Nixvim](https://github.com/nix-community/nixvim) - Neovim configured through Nix
- [Claude Code](https://claude.ai/code) - AI-powered code editor
- [Typst](https://github.com/typst/typst) for document preparation
- Python development with [uv](https://github.com/astral-sh/uv)
- Git with custom configuration

### Terminal

- [Ghostty](https://github.com/ghostty-org/ghostty) - GPU-accelerated terminal emulator
- [zsh](https://www.zsh.org/) - Shell with custom configuration

### Browsers

- [Firefox](https://www.mozilla.org/firefox/)
- [Vivaldi](https://vivaldi.com/)
- [Zen Browser](https://github.com/zen-browser/desktop) - Privacy-focused browser

### Utilities

- Network utilities (enabled for network diagnostics)
- Discord for communication
- Microsoft Teams
- Obsidian for note-taking

## SSH Configuration

Configured SSH keys for:

- GitHub (personal repository access)

## Deployment

Rebuild locally:

```bash
just rebuild-local
```

Build without activating:

```bash
just build laptop
```
