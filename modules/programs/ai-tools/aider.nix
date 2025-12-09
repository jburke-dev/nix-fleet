{ delib, pkgs, ... }:
delib.module {
  name = "programs.ai-tools";

  home.ifEnabled = {
    programs.aider-chat = {
      enable = true;
      settings = {
        set-env = [
          "OLLAMA_API_BASE=https://ollama.apps.chesurah.net"
        ];
        vim = true;
      };
    };
  };
}
