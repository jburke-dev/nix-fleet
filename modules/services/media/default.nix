{ delib, host, ... }:
delib.module {
  name = "services.media";

  options = delib.singleEnableOption host.mediaServerFeatured;

  nixos.ifEnabled = {
    users = {
      users.media = {
        group = "media";
        isSystemUser = true;
      };
      groups.media = { };
    };
  };
}
