{
    delib,
    ...
}:
delib.host {
    name = "installer";

    shared.myconfig.services = {
        sshd.authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICPcVVM9Vml3clMP95j9pprx6A2eky/jvXchxsk9SmdI jburke@desktop" ];
    };
}
