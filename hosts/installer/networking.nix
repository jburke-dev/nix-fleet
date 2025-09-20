{
    delib,
    ...
}:
delib.host {
    name = "installer";

    nixos.networking = {
        defaultGateway = "192.168.5.1";
        # TODO: how to handle this for systems where I can get DHCP working?
        interfaces.eno1.ipv4.addresses = [{
            address = "192.168.5.2";
            prefixLength = 24;
        }];
    };
}
