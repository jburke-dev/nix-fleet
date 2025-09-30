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
      nerd-fonts.sauce-code-pro
      nerd-fonts."_0xproto"
      nerd-fonts.roboto-mono
      nerd-fonts.space-mono
    ];
  };
}
