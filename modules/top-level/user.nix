{ delib, lib, ... }:
delib.module {
  name = "user";

  nixos.always =
    { myconfig, ... }:
    let
      inherit (myconfig.constants) username userFullName;
    in
    {
      # this allows other modules to set user.Setting instead of users.users.${username}.setting
      imports = [ (lib.mkAliasOptionModule [ "user" ] [ "users" "users" username ]) ];
      users = {
        groups.${username} = { };

        users.${username} = {
          isNormalUser = true;
          description = userFullName;
          initialHashedPassword = "$y$j9T$dEAJAyDaLnLNHJmq9sXfT1$b9xxCmTW3EAB82uDQFL6retuUvxBHb6WTTIU6Cdf2k.";
          extraGroups = [ "wheel" ];
          useDefaultShell = true;
        };
      };

      security.sudo.wheelNeedsPassword = false;
      environment.localBinInPath = true;
      programs.nix-ld.enable = true;
    };
}
