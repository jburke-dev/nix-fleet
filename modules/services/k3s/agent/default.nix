{ delib, ... }:
delib.module {
  name = "services.k3s.agent";

  options =
    with delib;
    moduleOptions (
      { parent, ... }:
      {
        enable = boolOption (parent.role == "agent");
      }
    );

  nixos.ifEnabled =
    { parent, ... }:
    {
      services.k3s.serverAddr = "https://${parent.kubeVip}:6443";
    };
}
