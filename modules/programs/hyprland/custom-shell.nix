{
  delib,
  inputs,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.hyprland.custom-shell";

  options = delib.singleCascadeEnableOption;

  # home.always.imports = [ inputs.ags-shell.homeManagerModules.ags-shell ];

  home.ifEnabled = {
    home.packages = [ inputs.desktop-shell.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    /*
      programs.ags-shell = {
        enable = true;
        settings = {
          statusBar = {
            battery.enable = host.isLaptop;
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
    */
  };
}
