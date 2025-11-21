{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.ai-tools";

  home.ifEnabled = {
    home = {
      packages = with pkgs; [ opencode ];
      file.".config/opencode/opencode.json".text = builtins.readFile ./opencode.json;
      file.".config/opencode/prompts/brainstorm.txt".text = builtins.readFile ./prompts/brainstorm.txt;
    };
  };
}
