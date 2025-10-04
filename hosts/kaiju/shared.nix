{
  delib,
  ...
}:
delib.host {
  name = "kaiju";

  shared.myconfig = {
    services = {
      sshd.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOIZJY67nTojEsAoLkNPkcXNUXywkVM3KtvPE81Qka6h jburke@desktop"
      ];
    };
  };
}
