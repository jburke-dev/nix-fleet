{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.note-taking.joplin";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled.home.packages = [ pkgs.joplin-desktop ];
}
