check-all:
    nix flake check

build-all:
    nix build .#

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
