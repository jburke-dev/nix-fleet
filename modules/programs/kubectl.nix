{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.kubectl";

  options = delib.singleEnableOption host.isDesktop;

  home.ifEnabled = {
    home.packages = with pkgs; [
      kubectl
    ];
  };
}
