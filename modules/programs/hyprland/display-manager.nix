{ delib, ... }:
delib.module {
  name = "programs.hyprland.display-manager";

  options = delib.singleCascadeEnableOption;

  nixos.ifEnabled = {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "elarun";
    };
  };
}
