{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.hyprland.workspace-rules";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    wayland.windowManager.hyprland = {
      settings = {
        workspace = [
          "1, monitor:HDMI-A-1, default:true"
          "r[2-4], monitor:HDMI-A-1"
          "5, monitor:DP-2, default:true"
        ];
      };
    };
  };
}
