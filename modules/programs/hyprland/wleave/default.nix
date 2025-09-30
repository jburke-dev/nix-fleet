{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.hyprland.wleave";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    home.packages = with pkgs; [
      wleave
    ];
    xdg.configFile."wleave/layout.json".text = builtins.toJSON {
      "buttons-per-row" = "2/2";
      "buttons" = [
        {
          "label" = "lock";
          "action" = "hyprlock";
          "text" = "Lock";
          "keybind" = "l";
          "icon" = "${pkgs.wleave}/share/wleave/icons/lock.svg";
        }
        {
          "label" = "logout";
          "action" = "loginctl terminate-user $USER";
          "text" = "Logout";
          "keybind" = "e";
          "icon" = "${pkgs.wleave}/share/wleave/icons/logout.svg";
        }
        {
          "label" = "reboot";
          "action" = "systemctl reboot";
          "text" = "Reboot";
          "keybind" = "r";
          "icon" = "${pkgs.wleave}/share/wleave/icons/reboot.svg";
        }
        {
          "label" = "shutdown";
          "action" = "systemctl poweroff";
          "text" = "Shutdown";
          "keybind" = "s";
          "icon" = "${pkgs.wleave}/share/wleave/icons/shutdown.svg";
        }
      ];
      "close-on-lost-focus" = true;
      "show-keybinds" = true;
    };
  };

}
