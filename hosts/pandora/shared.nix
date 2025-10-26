{ delib, ... }:
delib.host {
  name = "pandora";

  shared.myconfig = {
    services = {
      sshd.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQ5xkj9Eqo8PDqNVmF75i5P1mcoJgATWLDZj4QQi7eD jburke@desktop"
      ];
    };
  };
}
