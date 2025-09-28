{ delib, pkgs, ... }:
delib.rice {
  name = "dark";
  home.stylix = {
    targets = {
      dunst.enable = true;
      rofi.enable = true;
      hyprland.enable = true;
      firefox = {
        enable = true;
        profileNames = [ "default" ];
      };
      waybar.enable = true;
    };
  };
  nixos.stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";
    cursor = {
      size = 12;
      name = "rose-pine-hyprcursor";
      package = pkgs.rose-pine-hyprcursor;
    };
    targets = {
      gtk.enable = true;
    };
    autoEnable = false;
  };
}
