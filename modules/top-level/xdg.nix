{ delib, host, ... }:
delib.module {
  name = "xdg";

  options =
    with delib;
    moduleOptions {
      enable = boolOption host.guiFeatured;
    };

  home.ifEnabled =
    { cfg, ... }:
    {
      xdg = {
        enable = true;
        mime.enable = true;
        mimeApps.enable = true;
      };
    };
}
