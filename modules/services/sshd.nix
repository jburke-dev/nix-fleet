{ delib, host, lib, ... }:
delib.module {
    name = "services.sshd";

    options = with delib; moduleOptions {
        enable = boolOption (host.isServer || host.installerFeatured);

        listenAddresses = listOfOption str [];
        authorizedKeys = listOfOption str [];
        permitRootLogin = enumOption [ "yes" "no" ] (if host.installerFeatured then "yes" else "no");
    };

    nixos.ifEnabled = { cfg, ... }: {
        user.openssh.authorizedKeys.keys = cfg.authorizedKeys;
        users.users.root.openssh.authorizedKeys.keys = lib.mkIf (cfg.permitRootLogin == "yes") cfg.authorizedKeys;

        systemd.services.sshd = lib.mkIf (host.installerFeatured) {
            wantedBy = lib.mkForce [ "multi-user.target" ];
        };

        services.openssh = {
            enable = true;

            listenAddresses = lib.mkIf (!host.installerFeatured) (map (addr: {inherit addr;}) cfg.listenAddresses);

            settings = {
                PermitRootLogin = cfg.permitRootLogin;
                PasswordAuthentication = false;
                UsePAM = false;
                KbdInteractiveAuthentication = false;
            };
        };
    };
}
