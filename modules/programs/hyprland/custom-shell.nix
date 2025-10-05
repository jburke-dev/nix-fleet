{
  delib,
  inputs,
  pkgs,
  ...
}:
delib.module {
  name = "programs.hyprland.custom-shell";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    home.packages = [ inputs.ags-shell.packages.${pkgs.system}.default ];
  };
}
