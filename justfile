fmt:
    nix fmt

_format-targets +TARGETS:
    printf ".#%s " {{ TARGETS }} | sed 's/ $//'

write-installer DEV: (build-installer)
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
