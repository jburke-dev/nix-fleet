# Nix 

Modular Denix flake using [Denix](https://github.com/yunfachi/denix)

# Usage

To modify the configuration on laptop or server, simply run `sudo nixos-rebuild switch --flake .#host`, where `host` is either `desktop` or `laptop`.  Server configuration over SSH coming soon.

# Roadmap

- [x] Migrate desktop configuration
- [ ] Migrate laptop configuration
- [ ] Setup common server config (allow SSH access, static IP configuration)
- [ ] Setup hypervisor server config
- [ ] Scalable deployment with [deploy-rs](https://github.com/serokell/deploy-rs)
