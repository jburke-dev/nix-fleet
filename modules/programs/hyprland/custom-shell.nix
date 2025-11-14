{
  delib,
  inputs,
  pkgs,
  ...
}:
delib.module {
  name = "programs.hyprland.custom-shell";

  options = delib.singleCascadeEnableOption;

  home.always.imports = [ inputs.ags-shell-local.homeManagerModules.ags-shell ];

  home.ifEnabled = {
    # home.packages = [ inputs.ags-shell.packages.${pkgs.system}.default ];
    programs.ags-shell = {
      enable = true;
      settings = {
        workspaces = {
        };
      };
    };
  };
}
