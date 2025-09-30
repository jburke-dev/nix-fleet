{
  delib,
  ...
}:
let
  toggle = program: args: "pkill ${program} || ${program} ${args}";
in
delib.module {
  name = "programs.hyprland.binds";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled.wayland.windowManager.hyprland.settings = {
    "$screenshot" = "hyprshot -o $HOME/Pictures/Screenshots/";
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    bindr = [
      "$mainMod, SUPER_L, exec, ${toggle "anyrun" ""}"
      "$mainMod SHIFT, SUPER_L, hyprexpo:expo, toggle"
    ];

    bind = [
      "$mainMod, q, killactive,"
      "$mainMod, T, exec, $terminal"
      "$mainMod, B, exec, $browser"
      "$mainMod, M, fullscreen, 1"

      "$mainMod, L, exec, wleave -b 2"

      "$mainMod SHIFT, S, exec, $screenshot -m region"

      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"

      "$mainMod SHIFT, Right, movetoworkspace, +1"
      "$mainMod SHIFT, Left, movetoworkspace, -1"

      "$mainMod SHIFT, 1, workspace, 1"
      "$mainMod SHIFT, 2, workspace, 2"
      "$mainMod SHIFT, 3, workspace, 3"
      "$mainMod SHIFT, 4, workspace, 4"
      "$mainMod SHIFT, 5, workspace, 5"
      "$mainMod SHIFT, 6, workspace, 6"
      "$mainMod SHIFT, 7, workspace, 7"
      "$mainMod SHIFT, 8, workspace, 8"
      "$mainMod SHIFT, 9, workspace, 9"
    ];
  };
}
