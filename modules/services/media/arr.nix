{ delib, host, ... }:
delib.module {
  name = "services.media.arr";

  options =
    with delib;
    moduleOptions (
      {
        parent,
        ...
      }:
      {
        enable = boolOption parent.enable;
        subservices =
          attrsOfOption
            (submodule (
              { config, ... }:
              {
                options = {
                  dataDir = strOption "";
                  port = portOption null;
                };
              }
            ))
            {
              sonarr = {
                dataDir = "/mnt/databases/sonarr";
                port = 8989;
              };
              prowlarr = {
                dataDir = "/mnt/databases/prowlarr";
                port = 9696;
              };
              radarr = {
                dataDir = "/mnt/databases/radarr";
                port = 7878;
              };
            };
      }
    );

  nixos.ifEnabled =
    { cfg, ... }:
    {
      services = {
        sonarr = {
          enable = true;
          user = "media";
          group = "media";
          openFirewall = true;
          settings.server = {
            inherit (cfg.subservices.sonarr) port;
          };
          inherit (cfg.subservices.sonarr) dataDir;
        };
        prowlarr = {
          enable = true;
          openFirewall = true;
          settings.server = {
            inherit (cfg.subservices.prowlarr) port;
          };
          inherit (cfg.subservices.prowlarr) dataDir;
        };
        radarr = {
          enable = true;
          user = "media";
          group = "media";
          openFirewall = true;
          settings.server = {
            inherit (cfg.subservices.radarr) port;
          };
          inherit (cfg.subservices.radarr) dataDir;
        };
      };
    };
}
