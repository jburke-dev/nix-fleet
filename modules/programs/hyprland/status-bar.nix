{
  delib,
  ...
}:
delib.module {
  name = "programs.hyprland.status-bar";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          modules-left = [
            "hyprland/workspaces"
            "hyprland/submap"
          ];
          modules-center = [ "hyprland/window" ];
          modules-right = [
            "network"
            "clock"
          ];
          network = {
            interface = "enp16s0";
            format = "{icon} {ifname} - {bandwidthDownBytes} | {bandwidthUpBytes}";
          };
          "hyprland/workspaces" = {
            format = "{icon} {windows}";
            format-window-separator = " | ";
            persistent-workspaces = {
              HDMI-A-1 = [
                1
                2
                3
                4
              ];
              DP-2 = [ 5 ];
            };
            workspace-taskbar = {
              enable = true;
              update-active-window = true;
              format = "{icon} {title:.22}";
              icon-size = 24;
            };
          };
          "hyprland/window" = {
            icon = true;
          };
        };
      };
    };
  };
}
