# Nix 

Modular NixOS configuration for my desktop and servers.

# Usage

A host can be rebuilt locally with `just rebuild-local`.  Remote hosts can be rebuilt over ssh with `just rebuild-remote HOST`.

To update a system, run `nix flake update` followed by the normal rebuild command.

# Hosts

## Desktop
- [Hyprland](https://github.com/hyprwm/Hyprland) window manager
- [Nixvim](https://github.com/nix-community/nixvim) code editor
- [Ghostty](https://github.com/ghostty-org/ghostty) terminal emulator
- [zsh](https://github.com/zsh-users/zsh) shell
- [ags-shell](https://github.com/jburke-dev/ags-shell) custom desktop shell written with [AGS](https://github.com/Aylur/ags)

## Pandora
Custom router/firewall on an intel n355-based mini-PC.
- [nftables](https://netfilter.org/projects/nftables/) firewall
- [blocky](https://github.com/0xERR0R/blocky) ad-blocking DNS
- [kea](https://github.com/isc-projects/kea) dhcp server

## Common Server Configuration
:warning: :warning: Servers listed below are pending migration to new network configuration :warning: :warning:
- [Traefik](https://github.com/traefik/traefik) reverse proxy with LetsEncrypt ACME dns challenge for automated wildcard certs
- [Keepalived](https://github.com/acassen/keepalived) virtual shared IP for Traefik failover
- [Postgres](https://github.com/postgres/postgres) RDMS
- Networking with systemd-networkd

## Kaiju
Custom built AMD Epyc server
- [Vaultwarden](https://github.com/dani-garcia/vaultwarden) local password manager
- [Glance](https://github.com/glanceapp/glance) dashboard
- [Forgejo](https://forgejo.org) local git forge

## Colossus
Custom built AMD Epyc server
- [Jellyfin](https://github.com/jellyfin/jellyfin) local media server

## Kraken
Minisforum MS-01
- [Home Assistant](https://github.com/home-assistant) home automation
- Monitoring with [Prometheus](https://github.com/prometheus/prometheus) and [Grafana](https://github.com/grafana/grafana)

# Flake
This flake is supported by various utilities to make Nix development easier:
- [Home manager](https://github.com/nix-community/home-manager) home directory and user profile management
- [Denix](https://github.com/yunfachi/denix) modular multi-host nix config
- [Sops-nix](https://github.com/Mic92/sops-nix) secret management
- [Flake-parts](https://github.com/hercules-ci/flake-parts) multi-system flake support
- [Git-hooks](https://github.com/cachix/git-hooks.nix) git hooks nix integration

# Planned
- Local SSO with [authentik-nix](https://github.com/nix-community/authentik-nix)
- k3s cluster on servers
