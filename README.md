# Nix Fleet

Modular NixOS configuration for my desktop, laptop, and homelab servers.

## Disclaimer

This repository contains my personal NixOS configurations. While I welcome others to take inspiration from my setup and I strive to follow best practices, please note:

- **No Guarantees**: I make no guarantee that these configurations will work on systems other than my own
- **Hardware Dependencies**: Some configurations have dependencies on my specific hardware
- **Use at Your Own Risk**: Always review and understand configurations before applying them to your own systems

Feel free to learn from, fork, or adapt any part of this configuration for your own use!

## Usage

A host can be rebuilt locally with `just rebuild-local`. Remote hosts can be rebuilt over ssh with `just rebuild-remote HOST`.

To update a system, run `nix flake update` followed by the normal rebuild command.

See the [justfile](justfile) for all available commands.

## Hosts

- **[Desktop](hosts/desktop/README.md)** - Main desktop workstation with Hyprland
- **[Laptop](hosts/laptop/README.md)** - Laptop with Hyprland
- **[Pandora](hosts/pandora/README.md)** - Router/firewall with nftables, Blocky DNS, and Kea DHCP
- **[Kraken](hosts/kraken/README.md)** - Server for testing and future k3s cluster
- **[Kaiju](hosts/kaiju/README.md)** - Server for testing and future k3s cluster
- **[Glados](hosts/glados/README.md)** - Server for testing and future k3s cluster
- **[Installer](hosts/installer/README.md)** - Custom NixOS installation ISO

## Flake

This flake is supported by various utilities to make NixOS development easier:

- [Home Manager](https://github.com/nix-community/home-manager) - Home directory and user profile management
- [Denix](https://github.com/yunfachi/denix) - Modular multi-host NixOS configuration framework
- [SOPS-nix](https://github.com/Mic92/sops-nix) - Secrets management
- [Flake-parts](https://github.com/hercules-ci/flake-parts) - Multi-system flake support
- [Git-hooks](https://github.com/cachix/git-hooks.nix) - Git hooks integration
- [nixos-anywhere](https://github.com/nix-community/nixos-anywhere) - Automated NixOS installation
- [Disko](https://github.com/nix-community/disko) - Declarative disk partitioning

## Future Plans

For planned features and improvements, please see the [GitHub Issues](https://github.com/jburke-dev/nix-fleet/issues) for this repository.
