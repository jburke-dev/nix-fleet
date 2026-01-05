{
  delib,
  host,
  ...
}:
delib.module {
  name = "services.gnome-keyring";

  options = delib.singleEnableOption host.guiFeatured;

  nixos.ifEnabled = {
    # Enable gnome-keyring with SSH support
    services.gnome.gnome-keyring.enable = true;

    # Configure PAM to unlock gnome-keyring on login
    security.pam.services.sddm.enableGnomeKeyring = true;
  };

  home.ifEnabled = {
    # Enable gnome-keyring in home-manager
    services.gnome-keyring = {
      enable = true;
      components = [
        "secrets"
        "ssh"
      ];
    };
  };
}
