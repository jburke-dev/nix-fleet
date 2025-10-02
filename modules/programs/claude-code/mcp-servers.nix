{
  delib,
  ...
}:
delib.module {
  name = "programs.claude-code.mcp-servers";
  options = delib.singleCascadeEnableOption;

  home.ifEnabled =
    let
      mcpServers = {
        # TODO: setup node js on system and "bubble up" the npx?
        filesystem = {
          command = "@modelcontextprotocol/server-filesystem";
          args = [ "/home/jburke/Code" ];
        };
        sequential-thinking = {
          command = "@modelcontextprotocol/server-sequential-thinking";
          args = [ ];
        };
      };
      toMcpConfig = name: cfg: {
        type = "stdio";
        command = "nix";
        args = [
          "shell"
          "nixpkgs#nodejs_22"
          "--command"
          "npx"
          "-y"
          cfg.command
        ]
        ++ cfg.args;
        env = { };
      };
    in
    {
      xdg.configFile."claude/mcp-servers.json".text = builtins.toJSON {
        mcpServers = builtins.mapAttrs toMcpConfig mcpServers;
      };
    };
}
