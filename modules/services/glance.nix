{
  delib,
  ...
}:
delib.module {
  name = "services.glance";

  options =
    with delib;
    moduleOptions (
      { parent, ... }:
      {
        enable = boolOption false;
        listenAddress = strOption parent.hostVlans.services.address;
        httpPort = portOption 8080;
        interface = strOption parent.hostVlans.services.netdevName;
      }
    );

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
                            {
                              title = "Forgejo";
                              url = "https://forgejo.apps.chesurah.net";
                              icon = "si:forgejo";
                            }
                            {
                              title = "pfSense";
                              url = "https://pfsense.mgmt.chesurah.net";
                              icon = "si:pfsense";
                            }
                            {
                              title = "Mikrotik 1";
                              url = "https://mikrotik.mgmt.chesurah.net";
                              icon = "si:mikrotik";
                            }
                            {
                              title = "Mikrotik 2";
                              url = "https://mikrotik2.mgmt.chesurah.net";
                              icon = "si:mikrotik";
                            }
                          ];
                        }
                      ];
                    }
                  ];
                }
              ];
            }
            {
              name = "Tech";

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
                  size = "full";
                  widgets = [
                    {
                      type = "hacker-news";
                    }
                    {
                      type = "group";
                      widgets = [
                        {
                          type = "reddit";
                          subreddit = "selfhosted";
                        }
                        {
                          type = "reddit";
                          subreddit = "homelab";
                          show-thumbnails = true;
                        }
                        {
                          type = "reddit";
                          subreddit = "unixporn";
                          show-thumbnails = true;
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
