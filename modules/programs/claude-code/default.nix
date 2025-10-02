{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.claude-code";
  options = delib.singleEnableOption host.devFeatured;
  home.ifEnabled.home.packages = [ pkgs.claude-code ];
}
