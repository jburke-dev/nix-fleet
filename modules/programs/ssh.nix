{
  delib,
  host,
  lib,
  ...
}:
delib.module {
  name = "programs.ssh";

  options = delib.singleEnableOption true;

  home.ifEnabled.programs.ssh = {
    enable = true;
    # TODO: setup persist?
    includes = lib.mkIf (host.isPC) [ "~/Code/nix-dotfiles/config/ssh/*" ];
  };
}
