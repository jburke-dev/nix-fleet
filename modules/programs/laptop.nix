{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.laptop";

  options = delib.singleEnableOption host.isLaptop;

  home.ifEnabled = {
    home.packages = with pkgs; [
      brightnessctl
    ];
  };
}
