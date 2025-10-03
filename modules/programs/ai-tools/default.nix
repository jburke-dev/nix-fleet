{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.ai-tools";
  options = delib.singleEnableOption host.devFeatured;
  home.ifEnabled.home.packages = [
    pkgs.claude-code
  ];
}
