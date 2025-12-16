{ delib, ... }:
delib.host {
  name = "meerkat";

  type = "server";

  features = [
    "k3s"
  ];

  myconfig.services.k3s = {
    role = "agent";
    extraFlags = [
      "--node-taint dev=true:NoSchedule"
      "--node-label workload=development"
      "--node-label env=dev"
    ];
  };
}
