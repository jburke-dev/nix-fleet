{
  delib,
  host,
  ...
}:
delib.module {
  name = "programs.admin-utils";

  options = delib.singleEnableOption host.isDesktop;

  nixos.ifEnabled =
    { myconfig, ... }:
    {
      sops.secrets =
        let
          sopsCfg = {
            owner = myconfig.constants.username;
            sopsFile = ../../hosts/desktop/secrets.yaml;
          };
        in
        {
          "terraform/token/id" = sopsCfg;
          "terraform/token/secret" = sopsCfg;
        };
    };
}
