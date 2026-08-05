check-all:
    nix flake check

hosts := "amadeus brau1589 cipher heu lorian magi salieri wired"

build-all:
    for h in {{hosts}}; do nix build ".#nixosConfigurations.$h.config.system.build.toplevel" || exit 1; done

build-host hostname:
    nix build .#nixosConfigurations.{{hostname}}.config.system.build.toplevel

format:
    nix run nixpkgs#nixpkgs-fmt -- .

format-check:
    nix run nixpkgs#nixpkgs-fmt -- --check .

format-sh:
    shfmt -w **/*.sh

shellcheck:
    shellcheck **/*.sh || true
