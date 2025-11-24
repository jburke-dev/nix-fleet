{
  delib,
  pkgs,
  inputs,
  ...
}:
delib.module {
  name = "programs.ai-tools";

  home.ifEnabled = {
    home = {
      packages = [ inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default ];
      file.".config/opencode/opencode.json".text = builtins.readFile ./opencode.json;
      file.".config/opencode/prompts/brainstorm.txt".text = builtins.readFile ./prompts/brainstorm.txt;
    };
  };
}
