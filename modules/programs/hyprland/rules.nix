{
  delib,
  lib,
  ...
}:
delib.module {
  name = "programs.hyprland.rules";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled =
    { parent, ... }:
    {
      wayland.windowManager.hyprland = {
        settings = {
          windowrule = [
            # TODO: adapt this for single-monitor hosts?
            "match:class vivaldia-stable, workspace ${toString (parent.workspacesPerDisplay + 1)}"
            "match:class zen-twilight, workspace ${toString (parent.workspacesPerDisplay + 1)}"
            "match:class discord, workspace 2"
            "match:workspace w[tv1]s[false], border_size 0, float 0"
            "match:workspace w[tv1]s[false], rounding 0, float 0"
            "match:workspace f[1]s[false], border_size 0, float 0"
            "match:workspace f[1]s[false], rounding 0, float 0"
            "match:class kitty, opacity 0.9 0.5"
          ];
          monitor =
            (builtins.map (
              display:
              "${display.name}, ${display.resolution}, ${if display.leftMost then "0x0" else "auto-right"}, 1"
            ) parent.displays)
            ++ [
              ", preferred, auto, 1" # place newly plugged in monitors to the right of existing ones with preferred resolution
            ];
          workspace = [
            "w[tv1]s[false], gapsout:0, gapsin:0" # set gaps for non-special workspaces with only 1 visible tiled window
            "f[1]s[false], gapsout:0, gapsin:0" # same as above but maximized
          ]
          ++ (lib.lists.imap0 (
            i: display:
            "${toString (i * parent.workspacesPerDisplay + 1)}, monitor:${display.name}, default:true"
          ) parent.displays);
        };
      };
    };
}
