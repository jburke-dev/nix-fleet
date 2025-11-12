{
  delib,
  lib,
  networkInterface,
  ...
}:
delib.module {
  name = "services.k3s.server";

  nixos.ifEnabled =
    { parent, cfg, ... }:
    {
      services.k3s.manifests = lib.optionalAttrs cfg.clusterInit {
        kube-vip.content = [
          # ServiceAccount
          {
            apiVersion = "v1";
            kind = "ServiceAccount";
            metadata = {
              name = "kube-vip";
              namespace = "kube-system";
            };
          }

          # ClusterRole
          {
            apiVersion = "rbac.authorization.k8s.io/v1";
            kind = "ClusterRole";
            metadata = {
              annotations = {
                "rbac.authorization.kubernetes.io/autoupdate" = "true";
              };
              name = "system:kube-vip-role";
            };
            rules = [
              {
                apiGroups = [ "" ];
                resources = [ "services/status" ];
                verbs = [ "update" ];
              }
              {
                apiGroups = [ "" ];
                resources = [
                  "services"
                  "endpoints"
                ];
                verbs = [
                  "list"
                  "get"
                  "watch"
                  "update"
                ];
              }
              {
                apiGroups = [ "" ];
                resources = [ "nodes" ];
                verbs = [
                  "list"
                  "get"
                  "watch"
                  "update"
                  "patch"
                ];
              }
              {
                apiGroups = [ "coordination.k8s.io" ];
                resources = [ "leases" ];
                verbs = [
                  "list"
                  "get"
                  "watch"
                  "update"
                  "create"
                ];
              }
              {
                apiGroups = [ "discovery.k8s.io" ];
                resources = [ "endpointslices" ];
                verbs = [
                  "list"
                  "get"
                  "watch"
                  "update"
                ];
              }
              {
                apiGroups = [ "" ];
                resources = [ "pods" ];
                verbs = [ "list" ];
              }
            ];
          }

          # ClusterRoleBinding
          {
            kind = "ClusterRoleBinding";
            apiVersion = "rbac.authorization.k8s.io/v1";
            metadata = {
              name = "system:kube-vip-binding";
            };
            roleRef = {
              apiGroup = "rbac.authorization.k8s.io";
              kind = "ClusterRole";
              name = "system:kube-vip-role";
            };
            subjects = [
              {
                kind = "ServiceAccount";
                name = "kube-vip";
                namespace = "kube-system";
              }
            ];
          }

          # DaemonSet (ARP mode)
          {
            apiVersion = "apps/v1";
            kind = "DaemonSet";
            metadata = {
              name = "kube-vip-ds";
              namespace = "kube-system";
            };
            spec = {
              selector = {
                matchLabels = {
                  name = "kube-vip-ds";
                };
              };
              template = {
                metadata = {
                  labels = {
                    name = "kube-vip-ds";
                  };
                };
                spec = {
                  affinity = {
                    nodeAffinity = {
                      requiredDuringSchedulingIgnoredDuringExecution = {
                        nodeSelectorTerms = [
                          {
                            matchExpressions = [
                              {
                                key = "node-role.kubernetes.io/master";
                                operator = "Exists";
                              }
                            ];
                          }
                          {
                            matchExpressions = [
                              {
                                key = "node-role.kubernetes.io/control-plane";
                                operator = "Exists";
                              }
                            ];
                          }
                        ];
                      };
                    };
                  };
                  containers = [
                    {
                      name = "kube-vip";
                      image = "ghcr.io/kube-vip/kube-vip:v1.0.1";
                      imagePullPolicy = "Always";
                      args = [ "manager" ];
                      env = [
                        {
                          name = "vip_arp";
                          value = "true";
                        }
                        {
                          name = "port";
                          value = "6443";
                        }
                        {
                          name = "vip_interface";
                          value = networkInterface;
                        }
                        {
                          name = "vip_subnet";
                          value = "32";
                        }
                        {
                          name = "cp_enable";
                          value = "true";
                        }
                        {
                          name = "cp_namespace";
                          value = "kube-system";
                        }
                        {
                          name = "vip_ddns";
                          value = "false";
                        }
                        {
                          name = "svc_enable";
                          value = "false";
                        }
                        {
                          name = "vip_leaderelection";
                          value = "true";
                        }
                        {
                          name = "vip_leaseduration";
                          value = "5";
                        }
                        {
                          name = "vip_renewdeadline";
                          value = "3";
                        }
                        {
                          name = "vip_retryperiod";
                          value = "1";
                        }
                        {
                          name = "address";
                          value = cfg.kubeVip;
                        }
                      ];
                      securityContext = {
                        capabilities = {
                          add = [
                            "NET_ADMIN"
                            "NET_RAW"
                            "SYS_TIME"
                          ];
                        };
                      };
                    }
                  ];
                  hostNetwork = true;
                  serviceAccountName = "kube-vip";
                  tolerations = [
                    {
                      effect = "NoSchedule";
                      operator = "Exists";
                    }
                    {
                      effect = "NoExecute";
                      operator = "Exists";
                    }
                  ];
                };
              };
            };
          }
        ];
      };
    };
}
