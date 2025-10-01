{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.browsers.vivaldi";

  options = delib.singleEnableOption host.guiFeatured;

  nixos.ifEnabled.environment.systemPackages = with pkgs; [
    vivaldi
  ];
  # TODO: policies and profiles
}
