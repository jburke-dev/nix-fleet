{
  delib,
  host,
  ...
}:
delib.module {
  name = "gtk";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled.gtk = {
    enable = true;

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
