{
  delib,
  ...
}:
delib.host {
  name = "colossus";

  shared.myconfig = {
    services = {
      sshd.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIq7GiQnAiAP6BbmL3TFNvfBFNYfHKgYD1HHe+o4AbNC jburke@desktop"
      ];
    };
  };
}
