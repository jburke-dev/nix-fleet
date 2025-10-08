{
  delib,
  ...
}:
delib.host {
  name = "kraken";

  shared.myconfig = {
    services = {
      sshd.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL8ISRXVOfQWKoPHbeUu1zYhZ5omsaPtxtZTy74A4QYJ jburke@desktop"
      ];
    };
  };
}
