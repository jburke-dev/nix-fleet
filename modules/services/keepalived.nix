{
  delib,
  host,
  ...
}:
delib.module {
  name = "services.keepalived";

  options =
    with delib;
    moduleOptions {
      enable = boolOption host.reverseProxyFeatured;
      virtualIp = strOption "";
      interface = strOption "vlan-services";
      state = enumOption [ "MASTER" "BACKUP" ] "MASTER";
    };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      services.keepalived = {
        enable = true;
        openFirewall = true;

        vrrpInstances.VIP_10 = {
          inherit (cfg) state interface;
          virtualRouterId = 10;
          priority = if cfg.state == "MASTER" then 255 else 254;
          virtualIps = [ { addr = "${cfg.virtualIp}/24"; } ];
        };
      };
    };
}
