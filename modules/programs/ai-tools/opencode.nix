{
  delib,
  inputs,
  pkgs,
  ...
}:
delib.module {
  name = "programs.ai-tools";

  home.ifEnabled = {
    home = {
      packages = [ inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default ];
      #file.".config/opencode/opencode.json".text = builtins.readFile
    };
  };
}
