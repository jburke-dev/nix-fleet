{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.admin-utils";

  options = delib.singleEnableOption host.isDesktop;

  nixos.ifEnabled =
    { myconfig, ... }:
    {
      sops.secrets = {
        "attic/configure_cache_token" = {
          owner = myconfig.constants.username;
          sopsFile = ../../hosts/desktop/secrets.yaml;
        };
      };
    };

  home.ifEnabled = {
    home.packages = with pkgs; [
      attic-client
      (pkgs.writeShellScriptBin "attic-login" ''
        attic login homelab https://cache.apps.chesurah.net $(cat /run/secrets/attic/configure_cache_token)
      '')
    ];
  };
}
