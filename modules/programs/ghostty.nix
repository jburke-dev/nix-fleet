{
  delib,
  host,
  nixpkgs-unstable,
  pkgs,
  ...
}:
let
  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.system;
    config = pkgs.config;
  };
in
delib.module {
  name = "programs.ghostty";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    home.packages = with pkgs-unstable; [ ghostty ];
    xdg.configFile."ghostty/config" = {
      source = ../../.config/ghostty/config;
    };
  };
}
