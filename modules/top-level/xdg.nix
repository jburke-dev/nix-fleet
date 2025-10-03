{
  delib,
  host,
  homeconfig,
  ...
}:
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

        userDirs =
          let
            homeDir = name: "${homeconfig.home.homeDirectory}/${name}";
          in
          {
            enable = true;
            createDirectories = true;

            download = homeDir "Downloads";
            pictures = homeDir "Pictures";
            documents = homeDir "Documents";
          };
      };
    };
}
