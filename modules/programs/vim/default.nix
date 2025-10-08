{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.vim";

  options = delib.singleEnableOption true;

  nixos.ifEnabled.environment.systemPackages = with pkgs; [
    ((vim_configurable.override { }).customize {
      name = "vim";
      vimrcConfig.customRC = builtins.readFile ./vimrc;
    })
  ];
}
