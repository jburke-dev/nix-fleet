{ delib, ... }:
delib.host {
  name = "colossus";

  shared.myconfig = {
    services = {
      sshd.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIq9DTK9j3TvTLc6gMUYWJJpU2I2DRM973BZBHajXAzE jburke@desktop"
      ];
    };
  };
}
