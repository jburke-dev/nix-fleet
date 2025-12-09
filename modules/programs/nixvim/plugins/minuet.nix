{ delib, ... }:
delib.module {
  name = "programs.nixvim.plugins";

  home.ifEnabled.programs.nixvim = {
    plugins.minuet = {
      enable = true;

      settings = {
        provider = "openai_fim_compatible";
        n_completions = 1;
        context_window = 1024;
        provider_options = {
          openai_fim_compatible = {
            api_key = "TERM";
            name = "Ollama Local";
            end_point = "https://ollama.apps.chesurah.net/v1/completions";
            model = "qwen2.5-coder:7b";
            optional = {
              max_tokens = 56;
              top_p = 0.9;
            };
          };
        };
      };
    };
  };
}
