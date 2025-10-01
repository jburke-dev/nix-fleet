{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.hyprland.anyrun";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled.programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        "${pkgs.anyrun}/lib/libapplications.so"
        "${pkgs.anyrun}/lib/libshell.so"
        "${pkgs.anyrun}/lib/libsymbols.so"
        "${pkgs.anyrun}/lib/librink.so"
        "${pkgs.anyrun}/lib/librandr.so"
        "${pkgs.anyrun}/lib/libwebsearch.so"
        "${pkgs.anyrun}/lib/libdictionary.so"
      ];
      y.fraction = 0.3;
      width.fraction = 0.25;
      closeOnClick = true;
    };

    extraCss = builtins.readFile (./style.css);
    extraConfigFiles = {
      "shell.ron".text = ''
        Config(
            prefix: ">",
        )
      '';
      "websearch.ron".text = ''
        Config(
            prefix: "?",
            engines: [DuckDuckGo]
        )
      '';
    };
  };
}
