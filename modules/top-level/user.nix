{ delib, lib, ... }:
delib.module {
  name = "user";

  nixos.always =
    { myconfig, ... }:
    let
      inherit (myconfig.constants) username;
    in
    {
      # this allows other modules to set user.Setting instead of users.users.${username}.setting
      imports = [ (lib.mkAliasOptionModule [ "user" ] [ "users" "users" username ]) ];
      users = {
        groups.${username} = { };

        users.${username} = {
          isNormalUser = true;
          initialPassword = username;
          extraGroups = [ "wheel" ];
          useDefaultShell = true;
        };
      };

      security.sudo.wheelNeedsPassword = false;
      environment.localBinInPath = true;
    };
}
