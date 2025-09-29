{
  delib,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "services.glance";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;
      listenAddress = strOption "127.0.0.1";
      httpPort = portOption 8080;
      interface = strOption "";
    };

  nixos.ifEnabled =
    {
      cfg,
      ...
    }:
    {
      services.glance = {
        enable = true;
        settings = {
          server = {
            host = cfg.listenAddress;
            port = cfg.httpPort;
            proxied = true;
          };
          pages = [
            {
              name = "Home";
              head-widgets = [
                {
                  type = "search";
                  search-engine = "duckduckgo";
                  autofocus = true;
                  new-tab = true;
                }
              ];
              columns = [
                {
                  size = "small";
                  widgets = [
                    {
                      type = "calendar";
                      first-day-of-week = "monday";
                    }
                    {
                      type = "weather";
                      location = "Philadelphia, United States";
                      units = "imperial";
                      hour-format = "24h";
                    }
                    {
                      type = "clock";
                      hour-format = "24h";
                    }
                  ];
                }
                {
                  size = "full";
                  widgets = [
                    {
                      type = "bookmarks";
                      title = "Services";
                      groups = [
                        {
                          links = [
                            {
                              title = "Vaultwarden";
                              url = "https://vaultwarden.apps.chesurah.net";
                              icon = "si:vaultwarden";
                            }
                          ];
                        }
                      ];
                    }
                  ];
                }
              ];
            }
          ];
        };
      };

      systemd.tmpfiles.settings = {
        "10-glance"."/run/glance".d = {
          user = "glance";
          group = "glance";
          mode = "0770";
        };
      };

      networking.firewall.interfaces."${cfg.interface}".allowedTCPPorts = [ cfg.httpPort ];
    };
}
