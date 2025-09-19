{ delib, host, ... }:
delib.module {
    name = "services.sshd";

    options = with delib; moduleOptions {
        enable = boolOption host.isServer;

        listenAddresses = listOfOption str [];
        authorizedKeys = listOfOption str [];
    };

    nixos.ifEnabled = { cfg, ... }: {
        user.openssh.authorizedKeys.keys = cfg.authorizedKeys;

        services.openssh = {
            enable = true;

            listenAddresses = map (addr: {inherit addr;}) cfg.listenAddresses;

            settings = {
                PermitRootLogin = "no";
                PasswordAuthentication = false;
                UsePAM = false;
                KbdInteractiveAuthentication = false;
            };
        };
    };
}
