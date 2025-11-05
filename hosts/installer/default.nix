{ delib, ... }:
delib.host {
  name = "installer";

  type = "server";

  features = [
    "installer"
  ];

  myconfig = {
    programs.zsh.enable = false;
  };
}
