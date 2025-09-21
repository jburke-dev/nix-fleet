{ delib, lib, ... }:
delib.host {
    name = "kaiju";

    nixos.networking = {
        hostId = "deadc0ff";
        vlans = {
          vlan21 = {
            id = 21;
            interface = "enp129s0f0";
          };
        };
        interfaces.vlan21.ipv4.addresses = [{
            address = "192.168.21.5";
            prefixLength = 24;
        }];
        defaultGateway = "192.168.21.1";
    };
}
