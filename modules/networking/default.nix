{
  delib,
  host,
  lib,
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
              vlanId = intOption 10;
              ipFragment = strOption "";
              deviceType = enumOption [ "server" "router" ] "server";
              mac = strOption "";
            };
          })
          {
            kaiju = {
              vlanId = 12;
              ipFragment = "1.1";
              mac = ""; # TODO: fill this in
            };
            colossus = {
              vlanId = 12;
              ipFragment = "1.2";
              mac = "";
            };
            kraken = {
              vlanId = 12;
              ipFragment = "1.3";
              mac = "";
            };
          }
      );
      vlans = readOnly (
        attrsOfOption
          (submodule {
            options = {
              id = intOption 0;
              cidr = enumOption [ 24 16 ] 24;
              dhcpMode = enumOption [ "dynamic" "static" ] "dynamic";
            };
          })
          {
            servers = {
              id = 12;
              cidr = 16;
              dhcpMode = "static";
            };
            trusted = {
              id = 20;
              cidr = 16;
              dhcpMode = "dynamic";
            };
            untrusted = {
              id = 25;
              cidr = 16;
              dhcpMode = "dynamic";
            };
          }
      );
    };

  nixos.ifEnabled =
    let
      netLib = import ../lib/networking.nix { inherit lib; };
    in
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
          assertion = !(cfg.enable && builtins.any (link: link.mac == "") (builtins.attrValues cfg.links));
          message = "links must specify a mac address!";
        }
        {
          assertion = !(cfg.enable && (builtins.length (builtins.attrNames cfg.links)) == 0);
          message = "must specify at least one link when using networking module!";
        }
        {
          assertion = (netLib.vlanIp { id = 12; } "0.1") == "10.12.0.1";
          message = "netLib vlanIp failed sanity check!";
        }
        {
          assertion = (netLib.vlanGateway { id = 12; }) == "10.12.0.1";
          message = "netLib vlanGateway failed sanity check!";
        }
      ];
      networking = {
        hostName = host.name;
        nftables.enable = true;
        inherit (cfg) domain nameservers hostId;

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
