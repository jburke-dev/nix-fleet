{ delib, host, ... }:
delib.module {
  name = "programs.browsers";

  options =
    with delib;
    moduleOptions {
      enable = boolOption host.guiFeatured;
      defaultBrowser = enumOption [ "vivaldi-stable" ] "vivaldi-stable";
    };

  home.ifEnabled =
    { cfg, ... }:
    {
      xdg.mimeApps = {
        defaultApplications =
          let
            defaultBrowser = "${cfg.defaultBrowser}.desktop";
          in
          {
            "text/html" = defaultBrowser;
            "application/pdg" = defaultBrowser;
            "x-scheme-handler/http" = defaultBrowser;
            "x-scheme-handler/https" = defaultBrowser;
            "x-scheme-handler/about" = defaultBrowser;
            "x-scheme-handler/unknown" = defaultBrowser;
          };
      };
    };
}
