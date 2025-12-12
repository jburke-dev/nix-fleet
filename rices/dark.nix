{ delib, pkgs, ... }:
delib.rice {
  name = "dark";
  home.stylix = {
    targets = {
      dunst.enable = true;
      #hyprland.enable = true;
      firefox = {
        enable = true;
        profileNames = [ "default" ];
      };

      #hyprlock.enable = true;
      zen-browser = {
        enable = true;
        profileNames = [ "default" ];
      };
    };
  };
  nixos.stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.sauce-code-pro;
        name = "SauceCodePro Nerd Font Propo";
      };
    };
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
