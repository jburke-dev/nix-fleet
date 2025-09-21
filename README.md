# Nix 

Modular Denix flake using [Denix](https://github.com/yunfachi/denix)

# Usage

To modify the configuration on laptop or desktop, simply run `sudo nixos-rebuild switch --flake .#host`, where `host` is either `desktop` or `laptop`.

To build installer image, run `nix build .#nixosConfigurations.installer.config.system.build.isoImage`.  This image can be written to a USB or CD and used to boot a minimal live install of Nix that is running SSH.

To modify the configuration of a server, simply run `sudo nixos-rebuild switch --flake .#host --target-host host --use-remote-sudo`, where `host` is one of the servers.  Some servers (namely locust 1 through 3) will share configurations and deploy-rs will be used to deploy multiple profiles at once in the future.

To update a system, run `nix flake update` followed by the normal rebuild command.

# Roadmap

- [x] Migrate desktop configuration
- [ ] Migrate laptop configuration
- [x] Setup common server config (allow SSH access, static IP configuration)
- [x] Setup installer iso image
- ~~[ ] Setup nixos-anywhere with disko~~
- [ ] Scalable deployment with [deploy-rs](https://github.com/serokell/deploy-rs)

# Server configuration

- [ ] kaiju - compute server and testing environment
    - [x] initial configuration
    - [ ] complete networking setup
    - [ ] ZFS pools
- [ ] locust 1-3 - mini-PC for HA and monitoring
    - [ ] local DNS server
    - [ ] load-balanced reverse proxy
    - [ ] prometheus + grafana
    - [ ] mission critical services
        - [ ] authentik
        - [ ] vaultwarden
- [ ] colossus - compute and storage server

## Common configurations

- [ ] System level prometheus exporters?
