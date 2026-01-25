{ delib, host, ... }:
delib.module {
  name = "programs.terminal";

  options = delib.singleEnableOption host.guiFeatured;
}
