{
  delib,
  host,
  ...
}:
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
            };
          })
          {
            /*
              kaiju = {
                networkName = "servers";
                ipFragment = "1.1";
                mac = ""; # TODO: fill this in
              };
              colossus = {
                networkName = "servers";
                ipFragment = "1.2";
                mac = "";
              };
            */
            kraken = {
              networkName = "servers";
              ipFragment = "1.1";
              mac = "58:47:ca:7d:96:ae";
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
                      allowOutbound = listOfOption str [ ];
                    };
                  }
                  {
                    allowOutbound = [ ];
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
                allowOutbound = [
                  "wan"
                  "servers"
                  "trusted"
                  "untrusted"
                  "lan"
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
                  "servers"
                ];
              };
            };
            trusted = {
              id = 20;
              cidr = 16;
              dhcpMode = "dynamic";
              firewall = {
                allowOutbound = [
                  "wan"
                  "lan"
                  "servers"
                ];
              };
            };
            untrusted = {
              id = 25;
              cidr = 16;
              dhcpMode = "dynamic";
              firewall = {
                allowOutbound = [ "wan" ];
              };
            };
          }
      );
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
