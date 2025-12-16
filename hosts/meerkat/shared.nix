{ delib, ... }:
delib.host {
  name = "meerkat";

  shared.myconfig = {
    services = {
      sshd.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlW9zFraRPyRsvquVWhKbfIj1ORpm0HtjWpyH60+I17 jburke@desktop"
      ];
    };
  };
}
