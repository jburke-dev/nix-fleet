{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.network-utils";

  options = delib.singleEnableOption true;

  home.ifEnabled.home.packages = with pkgs; [
    dig
    nmap
    traceroute
  ];
}
