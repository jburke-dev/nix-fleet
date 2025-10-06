{
  delib,
  ...
}:
delib.module {
  name = "programs.ai-tools.mcp-servers";
  options = delib.singleCascadeEnableOption;

  home.ifEnabled =
    let
      mcpServers = {
        # TODO: setup node js on system and "bubble up" the npx?
        filesystem = {
          command = "@modelcontextprotocol/server-filesystem";
          args = [ "/home/jburke/Code" ];
          kind = "node";
        };
        sequential-thinking = {
          command = "@modelcontextprotocol/server-sequential-thinking";
          kind = "node";
        };
        nixos = {
          command = "mcp-nixos";
          kind = "uv";
        };
        memory = {
          command = "@modelcontextprotocol/server-memory";
          kind = "node";
          env = {
            MEMORY_FILE_PATH = "/mnt/apps/claude/memory.json";
          };
        };
        git = {
          command = "mcp-server-git";
          kind = "uv";
        };
      };

      toMcpConfig =
        name: cfg:
        {
          type = "stdio";
          command = if cfg.kind == "node" then "nix" else "uvx";
          args =
            (
              if cfg.kind == "node" then
                [
                  "shell"
                  "nixpkgs#nodejs_22"
                  "--command"
                  "npx"
                  "-y"
                ]
              else
                [ ]
            )
            ++ [ cfg.command ]
            ++ (cfg.args or [ ]);
        }
        // (if cfg ? env && cfg.env != { } then { inherit (cfg) env; } else { });
    in
    {
      xdg.configFile."claude/mcp-servers.json".text = builtins.toJSON {
        mcpServers = builtins.mapAttrs toMcpConfig mcpServers;
      };
    };
}
