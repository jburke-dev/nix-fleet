{
  delib,
  host,
  pkgs,
  #nix-ai-tools,
  ...
}:
/*
  let
    pkgs-nix-ai-tools = import nix-ai-tools {
      system = pkgs.system;
      config = pkgs.config;
    };
  in
*/
delib.module {
  name = "programs.claude-code";

  options = delib.singleEnableOption false;
  #nixos.ifEnabled.environment.systemPackages = with pkgs-nix-ai-tools; [ claude-code ];
}
