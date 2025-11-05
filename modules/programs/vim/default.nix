{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.vim";

  options = delib.singleEnableOption true;

  nixos.ifEnabled.environment.systemPackages = with pkgs; [
    ((vim-full.override { }).customize {
      name = "vim";
      vimrcConfig.customRC = builtins.readFile ./vimrc;
    })
  ];
}
