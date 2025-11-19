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
    };
  };
}
