# Nix 

Modular Denix flake using [Denix](https://github.com/yunfachi/denix)

# Usage

To modify the configuration on laptop or server, simply run `sudo nixos-rebuild switch --flake .#host`, where `host` is either `desktop` or `laptop`.  Server configuration over SSH coming soon.

To build installer image, run `nix build .#nixosConfigurations.installer.config.system.build.isoImage`.  This image can be written to a USB or CD and used to boot a minimal live install of Nix that is running SSH.

# Roadmap

- [x] Migrate desktop configuration
- [ ] Migrate laptop configuration
- [x] Setup common server config (allow SSH access, static IP configuration)
- [x] Setup installer iso image
- [ ] Setup nixos-anywhere with disko
- [ ] Scalable deployment with [deploy-rs](https://github.com/serokell/deploy-rs)
