{
  delib,
  ...
}:
delib.module {
  name = "programs.hyprland.waybar";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [ "clock" ];
          "hyprland/workspaces" = {
            on-scroll-up = "hyprctl dispatch workspace e-1";
            on-scroll-down = "hyprctl dispatch workspace e+1";
          };
          "hyprland/window" = {
            separate-outputs = true;
          };
        };
      };
      style = builtins.readFile ./style.css;
    };
  };
}
