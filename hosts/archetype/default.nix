/**
# Host config: archetype

## Description
Server configuration running NixOS.  Only includes base programs needed for any server, used as a cloud-init template in Proxmox.
*/
{
    delib,
    ...
}:
delib.host {
    name = "archetype";

    type = "server";

    nixos = {
        nixpkgs.config.allowUnfree = true;
        system.stateVersion = "25.05";

        myconfig = {};
    };
}
