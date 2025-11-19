{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "scripts";

  options = delib.singleEnableOption host.isPC;

  home.ifEnabled = {
    home.packages = with pkgs; [
      (writeScriptBin "reconcile-models" (builtins.readFile ./reconcile-models.sh))
    ];
  };
}
