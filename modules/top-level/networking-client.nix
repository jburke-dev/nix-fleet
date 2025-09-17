{
    delib,
    host,
    ...
}:
delib.module {
    name = "networking-client";

    options = delib.singleEnableOption host.isPC;

    nixos.ifEnabled = { cfg, ... }: {
        networking = {
            hostName = host.name;

            firewall.enable = true;
            networkmanager.enable = true;

            dhcpcd.extraConfig = "nohook resolv.conf";
            networkmanager.dns = "none";

            nameservers = [ "192.168.10.10" "192.168.10.22" ];
        };

        user.extraGroups = [ "networkmanager" ];
    };
}
