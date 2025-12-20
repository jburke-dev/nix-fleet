{ delib, host, ... }:
delib.module {
  name = "programs.docker";

  options = delib.singleEnableOption host.dockerFeatured;

  nixos.ifEnabled = {
    virtualisation.docker.enable = true;
  };
}
