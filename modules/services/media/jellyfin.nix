{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "services.media.jellyfin";
  options =
    with delib;
    moduleOptions {
      enable = boolOption host.mediaServerFeatured;
      dataDir = strOption "/mnt/databases/jellyfin";
    };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      services.jellyfin = {
        enable = true;
        user = "media";
        group = "media";
        openFirewall = true;
        inherit (cfg) dataDir;
      };
      environment.systemPackages = with pkgs; [
        jellyfin
        jellyfin-web
        jellyfin-ffmpeg
      ];
    };
}
