{
  delib,
  host,
  lib,
  ...
}:
delib.module {
  name = "services.sshd";

  options =
    with delib;
    moduleOptions {
      enable = boolOption (host.isServer || host.installerFeatured);

      listenAddresses = listOfOption str [ ];
      authorizedKeys = listOfOption str [ ];
      UsePAM = boolOption host.installerFeatured;
      PasswordAuthentication = boolOption host.installerFeatured;
      KbdInteractiveAuthentication = boolOption host.installerFeatured;
      PermitRootLogin = enumOption [ "yes" "prohibit-password" "no" ] (
        if host.installerFeatured then "yes" else "no"
      );
    };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      user.openssh.authorizedKeys.keys = cfg.authorizedKeys;

      services.openssh = {
        enable = true;

        listenAddresses = lib.mkIf (!host.installerFeatured) (
          map (addr: { inherit addr; }) cfg.listenAddresses
        );

        settings = {
          inherit (cfg)
            UsePAM
            PasswordAuthentication
            KbdInteractiveAuthentication
            PermitRootLogin
            ;
        };
      };
    };
}
