{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "fonts";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      font-awesome
    ];
  };
}
