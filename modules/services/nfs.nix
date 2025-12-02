{
  delib,
  host,
  ...
}:
delib.module {
  name = "services.nfs";
  options = delib.singleEnableOption host.nfsServerFeatured;
  nixos.ifEnabled =
    let
      nfs_opts = "(rw,sync,no_subtree_check,no_root_squash)";
    in
    {
      services.nfs.server = {
        enable = true;
        exports = ''
          /tank/media *${nfs_opts}
        '';
      };

      systemd.services.nfs-server = {
        requires = [
          "tank-downloads.mount"
          "tank-media.mount"
        ];
        after = [
          "tank-downloads.mount"
          "tank-media.mount"
        ];
      };
    };
}
