fmt:
    nix fmt

_format-targets +TARGETS:
    printf ".#%s " {{ TARGETS }} | sed 's/ $//'

write-installer DEV: build-installer
    #!/usr/bin/env bash
    isoFile=$(ls ./result/iso/nixos*.iso)
    sudo dd if=${isoFile} of=/dev/{{ DEV }} bs=4M status=progress conv=fdatasync

build-installer: (build "installer" "isoImage")

build HOST TARGET="toplevel":
    nix build '.#nixosConfigurations.{{ HOST }}.config.system.build.{{ TARGET }}'

[parallel]
rebuild-servers: (rebuild-remote "kaiju") (rebuild-remote "colossus") (rebuild-remote "kraken")

rebuild-local:
    #!/usr/bin/env bash
    set -euo pipefail
    host=$(hostname)
    sudo nixos-rebuild --flake ".#${host}" switch 

rebuild-boot-local:
    #!/usr/bin/env bash
    host=$(hostname)
    sudo nixos-rebuild --flake ".#${host}" boot 

rebuild-boot-remote HOST:
    #!/usr/bin/env bash
    set -euo pipefail
    nixos-rebuild --build-host {{ HOST }} --target-host {{ HOST }} --sudo --flake ".#{{ HOST }}" boot

rebuild-remote HOST:
    #!/usr/bin/env bash
    set -euo pipefail
    nixos-rebuild --build-host {{ HOST }} --target-host {{ HOST }} --sudo --flake ".#{{ HOST }}" switch

deploy HOST IP:
    #!/usr/bin/env bash
    set -euo pipefail
    nixos-anywhere --flake ".#{{ HOST }}" --target-host {{ IP }} --build-on remote --phases kexec,disko,install

sync-k8s: sync-k8s-infra sync-k8s-apps

sync-k8s-infra:
    #!/usr/bin/env bash
    set -euo pipefail
    helmfile -f ./k8s/infrastructure/helmfile.yaml apply
    kubectl apply -f ./k8s/infrastructure/manifests/ -R

sync-k8s-apps:
    #!/usr/bin/env bash
    set -euo pipefail
    kubectl apply -f ./k8s/apps/manifests/ -R
