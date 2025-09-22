{
  delib,
  ...
}:
delib.host {
  name = "kaiju";

  shared.myconfig = {
    services = {
      sshd.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBfpDlSNeREjX7kP7mo+cM6eyUVbLxJV01BE7P8WL/+I jburke@kaiju"
      ];
    };
  };
}
