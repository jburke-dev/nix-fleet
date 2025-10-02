{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.python";

  options = delib.singleEnableOption host.devFeatured;

  home.ifEnabled = {
    programs.uv = {
      enable = true;
      settings = {
        python-downloads = "never";
      };
    };
  };
}
