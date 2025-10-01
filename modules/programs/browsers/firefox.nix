{ delib, host, ... }:
delib.module {
  name = "programs.browsers.firefox";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled.programs.firefox.enable = true;
}
