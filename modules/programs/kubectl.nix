{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.kubectl";

  options = delib.singleEnableOption host.isDesktop;

  home.ifEnabled =
    let
      k8s-helm =
        with pkgs;
        wrapHelm kubernetes-helm {
          plugins = with pkgs.kubernetes-helmPlugins; [
            helm-secrets
            helm-diff
            helm-s3
            helm-git
          ];
        };
      k8s-helmfile = pkgs.helmfile-wrapped.override {
        inherit (k8s-helm) pluginsDir;
      };
    in
    {
      home.packages = with pkgs; [
        kubectl
        kustomize
        talosctl
        k8s-helm
        k8s-helmfile
      ];
    };
}
