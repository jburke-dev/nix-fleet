{ delib, ... }:
delib.host {
  name = "glados";

  shared.myconfig = {
    services = {
      sshd.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILLPJU+YIOnGA9n4pkyvwwYwEeljQvzWN3t8DaK48YNS jburke@desktop"
      ];
    };
  };
}
