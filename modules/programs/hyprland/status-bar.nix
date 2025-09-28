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
            "group/hardware"
            "clock"
          ];
          "group/hardware" = {
            orientation = "horizontal";
            drawer.transition-left-to-right = false;
            modules = [
              "custom/hardware-title"
              "cpu"
              "memory"
              "disk"
              "network"
            ];
          };
          clock = {
            interval = 1;
            format = "{:%H:%M:%S}";
          };
          "custom/hardware-title" = {
            format = "Hardware";
            tooltip = false;
          };
          cpu = {
            interval = 1;
          };
          disk = {
            format = "{used} / {total}";
            path = "/";
          };
          memory = {
            interval = 5;
            format = "{used} / {total}";
          };
          network = {
            interval = 1;
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
