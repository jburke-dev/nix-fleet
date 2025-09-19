{
    delib,
    host,
    ...
}:
delib.module {
    name = "networking-client";

    options = delib.singleEnableOption host.isServer;

    nixos.ifEnabled.networking = {
        domain = "infra.chesurah.net";
        dhcpcd.enable = false;
        nameservers = [ "1.1.1.1" "1.0.0.1" ];
    };
}
