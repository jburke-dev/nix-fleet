{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.note-taking.anytype";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled.home.packages = [ pkgs.anytype ];
}
