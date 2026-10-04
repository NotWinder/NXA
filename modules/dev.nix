# Flake tooling outputs: `nix fmt`, `nix develop`, and one check per host so
# `nix flake check` (or `nix build .#checks.<system>.<host>`) builds every
# host's system closure instead of only evaluating it.
{ self, lib, ... }: {
  perSystem = { pkgs, system, ... }: {
    # nixpkgs-fmt needs paths; newer `nix fmt` passes none, so default to the
    # whole tree (`nix fmt`, `nix fmt -- --check .`, `nix fmt -- file.nix`).
    formatter = pkgs.writeShellScriptBin "nixpkgs-fmt-tree" ''
      exec ${lib.getExe pkgs.nixpkgs-fmt} "''${@:-.}"
    '';

    devShells.default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        jq
        just
        nixpkgs-fmt
        shellcheck
        shfmt
        sops
        yamllint
      ];
    };

    checks = lib.mapAttrs (_: host: host.config.system.build.toplevel) (
      lib.filterAttrs (_: host: host.config.nixpkgs.hostPlatform.system == system) self.nixosConfigurations
    );
  };
}
