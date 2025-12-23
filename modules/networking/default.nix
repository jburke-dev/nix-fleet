{
  delib,
  host,
  lib,
  ...
}:
let
  netLib = import ../lib/networking.nix { inherit lib; };
in
delib.module {
  name = "networking";

  options =
    with delib;
    moduleOptions {
      enable = boolOption true;
      hostId = strOption "";
      domain = readOnly (strOption "home.chesurah.net");
      links = attrsOfOption (submodule {
        options = {
          mac = strOption "";
          priority = intOption 10;
        };
      }) { };
      staticHosts = readOnly (
        attrsOfOption
          (submodule {
            options = {
              networkName = strOption "servers";
              ipFragment = strOption "";
              deviceType = enumOption [ "server" "router" ] "server";
              mac = strOption "";
              addToStaticHostsFile = boolOption true;
            };
          })
          {
            pve-meerkat = {
              networkName = "mgmt";
              ipFragment = "1.1";
              mac = "48:21:0b:56:5d:fb";
            };
            /*
              meerkat = {
                networkName = "servers";
                ipFragment = "1.5";
                mac = "02:ed:aa:06:23:87";
              };
            */
            home-assistant = {
              networkName = "untrusted"; # some iot devices like philips hue don't play nice in initial configuration across subnets
              ipFragment = "1.1";
              mac = "2c:cf:67:ae:5f:94";
            };
            mikrotik-hap = {
              networkName = "untrusted";
              ipFragment = "1.2";
              mac = "04:f4:1c:59:aa:2c";
            };
            mikrotik = {
              networkName = "lan";
              ipFragment = "1.1";
              mac = "D4:01:C3:12:16:F4"; # combo3 port
            };
          }
      );
      networks = readOnly (
        attrsOfOption
          (submodule {
            options = {
              id = intOption 0;
              type = enumOption [ "bridge" "vlan" ] "vlan";
              interface = allowNull (strOption null);
              cidr = enumOption [ 24 16 ] 24;
              dhcpMode = enumOption [ "dynamic" "static" ] "dynamic";
              firewall =
                submoduleOption
                  {
                    options = {
                      isTrusted = boolOption false;
                      allowOutbound = listOfOption str [ ];
                      allowOutboundToIp = listOfOption (submodule {
                        options = {
                          ip = strOption "";
                          ports = listOfOption int [ ];
                          protocol = enumOption [ "tcp" "udp" "both" ] "tcp";
                        };
                      }) [ ];
                      allowOutboundToIpPortRange = listOfOption (submodule {
                        options = {
                          ip = strOption "";
                          startPort = intOption 7000;
                          endPort = intOption 7001;
                          protocol = enumOption [ "tcp" "udp" "both" ] "tcp";
                        };
                      }) [ ];
                    };
                  }
                  {
                  };
            };
          })
          {
            lan = {
              id = 10;
              type = "bridge";
              interface = "br-lan";
              cidr = 16;
              dhcpMode = "static";
              firewall = {
                isTrusted = true;
                allowOutbound = [
                  "wan"
                  "servers"
                  "trusted"
                  "untrusted"
                  "lan"
                ];
              };
            };
            mgmt = {
              id = 11;
              cidr = 16;
              dhcpMode = "static";
              firewall = {
                allowOutbound = [
                  "wan"
                  "mgmt"
                ];
              };
            };
            servers = {
              id = 12;
              cidr = 16;
              dhcpMode = "static";
              firewall = {
                allowOutbound = [
                  "wan"
                  "trusted"
                  "untrusted"
                  "servers"
                  "lan"
                ];
              };
            };
            trusted = {
              id = 20;
              cidr = 16;
              dhcpMode = "dynamic";
              firewall = {
                isTrusted = true;
                allowOutbound = [
                  "wan"
                  "lan"
                  "servers"
                  "untrusted"
                  "mgmt"
                  "talos"
                ];
              };
            };
            untrusted = {
              id = 25;
              cidr = 16;
              dhcpMode = "static";
              firewall = {
                allowOutbound = [
                  "wan"
                  "untrusted"
                ];
              };
            };
            talos = {
              id = 15;
              cidr = 16;
              dhcpMode = "static";
              firewall = {
                allowOutbound = [
                  "wan"
                  "talos"
                ];
                allowOutboundToIpPortRange = [
                  {
                    ip = "10.11.0.0/16";
                    startPort = 6789;
                    endPort = 7568;
                    protocol = "tcp";
                  }
                ];
              };
            };
          }
      );
    };

  myconfig.always =
    { cfg, ... }:
    {
      args.shared = {
        staticHosts = builtins.mapAttrs (
          _: host: netLib.getHostIpFromNetwork cfg.networks host
        ) cfg.staticHosts;
        networkCidrs = builtins.mapAttrs (_: network: netLib.vlanSubnet network) cfg.networks;
        inherit (cfg) domain;
      };
    };

  nixos.ifEnabled =
    {
      cfg,
      ...
    }:
    {
      assertions = [
        {
          assertion = !(cfg.enable && cfg.hostId == "");
          message = "hostId must not be empty when networking is enabled!";
        }
        {
          assertion =
            !(
              cfg.enable
              && !(host.isPC || host.installerFeatured)
              && builtins.any (link: link.mac == "") (builtins.attrValues cfg.links)
            );
          message = "links must specify a mac address for non-clients!";
        }
        {
          assertion =
            !(
              cfg.enable
              && !(host.isPC || host.installerFeatured)
              && (builtins.length (builtins.attrNames cfg.links)) == 0
            );
          message = "must specify at least one link when using networking module on non-clients!";
        }
      ];
      networking = {
        hostName = host.name;
        nftables.enable = true;
        inherit (cfg) domain hostId;

        # these are covered by nftables
        nat.enable = false;
        firewall.enable = false;

        useDHCP = false;
        dhcpcd.enable = false;

        # this is just the compatibility layer between networking.interfaces and networkd, not needed when
        # we're configuring networkd explicitly
        useNetworkd = false;
      };
    };
}
