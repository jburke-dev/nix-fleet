{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "services.gnome";

  options = delib.singleEnableOption host.gnomeFeatured;

  nixos.ifEnabled = {
    services.xserver = {
      enable = true;

      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  home.ifEnabled = {
    home.ifEnabled = with pkgs; [ xclip ];
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/shell" = {
        enabled-extensions = [
          pkgs.gnomeExtensions.tiling-shell.extensionUuid
        ];
      };
    };
  };
}
