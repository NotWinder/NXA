check-all:
    nix flake check

# evaluate every host, the dev shell, the formatter and the colmena hive
# without building
# (`nix flake check --no-build` uses a read-only store, which breaks inputs
# that read their own source on a fresh store)
check-eval:
    nix eval --json --option allow-import-from-derivation false .#checks.x86_64-linux --apply 'builtins.mapAttrs (_: c: c.drvPath)'
    nix eval --raw --option allow-import-from-derivation false .#devShells.x86_64-linux.default.drvPath
    nix eval --raw --option allow-import-from-derivation false .#formatter.x86_64-linux.drvPath
    nix eval --json --option allow-import-from-derivation false .#colmenaHive.deploymentConfig --apply 'builtins.mapAttrs (_: d: d.targetHost)'

# deploy one host with colmena (from a machine that can SSH to it)
deploy hostname:
    colmena apply --on {{hostname}}

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
