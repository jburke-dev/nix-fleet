{
  delib,
  inputs,
  ...
}:
delib.module {
  name = "programs.hyprland.custom-shell";

  options = delib.singleCascadeEnableOption;

  home.always.imports = [ inputs.ags-shell.homeManagerModules.ags-shell ];

  home.ifEnabled = {
    programs.ags-shell = {
      enable = true;
      settings = {
        statusBar = {
          workspaces.rules = [
            {
              match = "class";
              content = "kitty";
              icon = "";
            }
            {
              match = "class";
              content = "discord";
              icon = "";
            }
            {
              match = "class";
              content = "zen-twilight";
              icon = "";
            }
          ];
        };
        picker = {
        };
      };
    };
  };
}
