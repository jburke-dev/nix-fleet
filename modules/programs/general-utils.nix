{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.general-utils";

  options = delib.singleEnableOption true;
  nixos.ifEnabled.environment.systemPackages = with pkgs; [
    htop
    pciutils
    unzip
    jq
    yq
  ];
}
