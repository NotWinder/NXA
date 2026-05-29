AGENTS

This file gives concise, actionable rules and commands for automated agents (and humans) working in this repository.
Follow these exactly unless a change is justified and recorded in the git history.

## Architecture

- **flake-parts entrypoint:** `flake.nix` imports `./hosts` and `./lib` as flake-parts sub-flakes.
- **Hosts:** `hosts/default.nix` defines all NixOS configurations (8 hosts: amadeus, brau1589, cipher, heu, lorian, magi, salieri, wired). Each host dir has a `host.nix` + optional `modules/` + filesystem config files.
- **Custom library:** `lib/` extends `nixpkgs.lib` with custom functions exposed under `lib.extendedLib.*` (e.g. `lib.extendedLib.builders.mkNixosSystem`). Top-level aliases inherit a subset: `lib.mkNixosSystem`, `lib.mkModuleTree'`, `lib.importPathOrTree`, `lib.mkService`, etc.
- **Module trees (`modules/`):**
  - `modules/options/` — declares the `config.modules.*` option tree (usrEnv, system, style, device, profiles, meta).
  - `modules/system/` — system-level module implementations.
  - `modules/roles/` — role presets: `graphical`, `headless`, `server`, `workstation/`.
  - `modules/profiles/` — profile composables (gaming, workstation).
  - Module discovery uses `mkModuleTree'` (recursively collects `module.nix` files) and `importPathOrTree` (handles `.nix` files or directories, returning a list).
- **Home-manager:** `home/module.nix` integrates HM per-user; user configs go in `home/<username>/home.nix`.
- **Secrets:** SOPS-managed (`.sops.yaml` with age keys per user/host; `secrets.yaml` encrypted). The `sops-nix` flake input is used at the host level.

## Build / Lint / Test

```bash
nix build .#                                       # build all default outputs
nix flake show [--json | jq '.']                    # discover all outputs
nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel  # build single host
nix flake check                                     # run all checks
```

Formatting (run before committing):
```bash
find . -name '*.nix' -print0 | xargs -0 nixpkgs-fmt
shellcheck **/*.sh || true && shfmt -w **/*.sh || true
jq . <file>.json >/dev/null && yamllint -c .yamllint.yaml <file>.yaml || true
```

## Key conventions

- **Module options** are declared under `modules/options/` and accessed as `config.modules.usrEnv`, `config.modules.system`, etc.
- **Roles** stack tags and defaults: graphical adds `system.nixos.tags = ["graphical"]`.
- **stateVersion:** `system.stateVersion = "25.05"` for all hosts.
- **Host modules** are assembled via `mkModulesFor` in `hosts/default.nix`, which auto-imports module trees + roles + extraModules (sops-nix, stylix, home-manager).
- **ExtraModules pattern:** always pass `sops-nix`, `stylix`, `hm` as extraModules for graphical/workstation hosts.

## Secrets safety

- The repo contains `secrets.yaml` (SOPS-encrypted) and `.sops.yaml` (age key config).
- Agents must never print, transmit, or commit secrets.
- Use the repo's existing SOPS workflow (age keys + sops-nix) — do not add raw secrets to commits.

## Commits & PRs

- One-line imperative summary + body explaining why, not just what.
- Do not force-push main branches. Prefer a branch + PR for rebases.
- No pre-commit hooks or CI are currently configured in this repo.

## Tooling

- If formatting tools aren't installed locally: `nix run nixpkgs#nixpkgs-fmt -- <file>`
- The `.gitignore` only ignores `result`.

## Before committing

- Run `nixpkgs-fmt` on changed `.nix` files.
- Run `shfmt`/`shellcheck` on changed shell scripts.
- Ensure no secrets are staged.
- Run `nix build .#` or `nix flake check` if the change touches build logic.

If blocked or ambiguous: pick the least-surprising option (minimal change that keeps the build green) and note the choice in the commit message.
