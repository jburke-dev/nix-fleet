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
      # anyrun seems borked after switching to unstable
      # "$mainMod, SUPER_L, exec, ${toggle "anyrun" ""}"
      "$mainMod, SUPER_L, exec, ags-shell picker"
      #"$mainMod SHIFT, SUPER_L, hyprexpo:expo, toggle"
    ];

    bind = [
      "$mainMod, q, killactive,"
      "$mainMod, T, exec, $terminal"
      "$mainMod, B, exec, $browser"

      "$mainMod, L, exec, wleave -b 2"
      "$mainMod, C, exec, hyprpicker -a"

      "$mainMod SHIFT, S, exec, $screenshot -m region"

      "$mainMod SHIFT, Right, movetoworkspace, +1"
      "$mainMod SHIFT, Left, movetoworkspace, -1"
      "$mainMod CTRL SHIFT, Right, movetoworkspacesilent, +1"
      "$mainMod CTRL SHIFT, Left, movetoworkspacesilent, -1"
      "$mainMod, Right, cyclenext"
      "$mainMod, Left, cyclenext, prev"
      "$mainMod, Up, fullscreen, 1"

      "$mainMod, S, layoutmsg, togglesplit"
      "$mainMod SHIFT, L, layoutmsg, swapsplit"

      "$mainMod, D, exec, ags-shell"
      "$mainMod SHIFT, D, exec, pkill gjs || ags-shell" # refresh ags-shell
      "$mainMod CTRL SHIFT, D, exec, pkill gjs"
    ]
    ++ builtins.concatLists (
      builtins.genList (
        i:
        let
          ws = toString (i + 1);
        in
        [
          "$mainMod, ${ws}, workspace, ${ws}"
          "$mainMod SHIFT, ${ws}, movetoworkspace, ${ws}"
          "$mainMod CTRL SHIFT, ${ws}, movetoworkspacesilent, ${ws}"
        ]
      ) 9
    );
  };
}
