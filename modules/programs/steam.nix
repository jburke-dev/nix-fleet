{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.steam";

  options = delib.singleEnableOption host.gamingFeatured;

  home.ifEnabled.home.packages = [ pkgs.steam ];
}
