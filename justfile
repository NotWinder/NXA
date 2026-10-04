check-all:
    nix flake check

# evaluate every host without building
check-eval:
    nix flake check --no-build

build-all:
    for h in $(nix eval --raw .#nixosConfigurations --apply 'c: toString (builtins.attrNames c)'); do nix build ".#nixosConfigurations.$h.config.system.build.toplevel" || exit 1; done

build-host hostname:
    nix build .#nixosConfigurations.{{hostname}}.config.system.build.toplevel

format:
    nix fmt

format-check:
    nix fmt -- --check .

format-sh:
    shfmt -w **/*.sh

shellcheck:
    shellcheck **/*.sh || true
