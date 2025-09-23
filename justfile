fmt:
    nix fmt

_format-targets +TARGETS:
    printf ".#%s " {{ TARGETS }} | sed 's/ $//'

write-installer DEV: (build-installer)
    #!/usr/bin/env bash
    isoFile=./result/iso/nixos*.iso
    sudo dd if=${isoFile} of=/dev/{{ DEV }} bs=4M status=progress conv=fdatasync

build-installer: (build "installer" "isoImage")

build HOST TARGET="toplevel":
    nix build '.#nixosConfigurations.{{ HOST }}.config.system.build.{{ TARGET }}'

rebuild-local:
    #!/usr/bin/env bash
    set -euo pipefail
    host=$(hostname)
    sudo nixos-rebuild --flake ".#${host}" switch 

rebuild-remote HOST:
    #!/usr/bin/env bash
    set -euo pipefail
    nixos-rebuild --target-host jburke@{{ HOST }}.infra.chesurah.net --use-remote-sudo --flake ".#{{ HOST }}" switch
