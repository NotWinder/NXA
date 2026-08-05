AGENTS

This file gives concise, actionable rules and commands for automated agents (and humans) working in this repository.
Follow these exactly unless a change is justified and recorded in the git history.

## Architecture

- **flake-parts entrypoint:** `flake.nix` auto-loads the aspect files at the top of `modules/` via `import-tree` (skipping `modules/_lib/` and the legacy NixOS trees `options|system|hardware|nix|virt|profiles`), and imports `./hosts`, `./lib`, and `./modules/_lib/registry.nix` as flake-parts sub-flakes.
- **Aspect registry:** every module registers a named aspect under `flake.modules.<class>.<name>` (declared in `modules/_lib/registry.nix`). Classes in use:
  - `nixos` — coarse wrappers over the legacy trees: `base` (→ `options/`), `system`, `hardware`, `nix`, `virt`, `profiles`. Each wraps its tree's top-level `module.nix`, which transitively imports the whole tree.
  - `roles` — role presets: `graphical`, `headless`, `server` (`modules/roles/*.nix`; the former `workstation` role was folded into the workstation profile in phase 5).
  - `hosts` — per-host aspects under `modules/hosts/` (compose the host dir + sops-nix + home-manager).
  - `homeManager` — home-manager aspects: `base`, `cli`, `gui`, `misc`, `themes` + one per user under `modules/home/users/`.
- **Hosts:** `hosts/default.nix` is a data table (`roles`, `home`, `system` per host); each host is assembled from the registry by `mkModulesFor` (nixos tree aspects + roles + sops-nix/home-manager + per-host home aspect selection), then wrapped by `lib.mkNixosSystem`. Host-specific files stay in `hosts/<name>/` (`host.nix` + `modules/` + filesystem config).
- **Custom library:** `lib/` extends `nixpkgs.lib` with custom functions exposed under `lib.extendedLib.*`. Top-level aliases: `lib.mkNixosSystem`, `lib.mkSystem`, `lib.mkService`, etc.
- **Option namespace:** All custom options live under `config.custom.*` (declared in `modules/options/`). See README for the full tree.
- **Module trees (`modules/`):**
  - `modules/options/` — declares the `config.custom.*` option tree (usrEnv, system, style, device, profiles, meta).
  - `modules/system/` — system-level module implementations.
  - `modules/system/btrfs-snapshots.nix` — shared btrfs snapshot logic (auto-imported, conditional).
  - `modules/system/secure-mount-options.nix` — shared `/boot` security defaults (auto-imported).
  - `modules/system/disko-btrfs.nix` — shared disko btrfs partition layout.
  - `modules/system/home-manager/module.nix` — the home-manager wiring: sets `home-manager.users.<mainUser>.imports` from the `homeManager` registry aspects selected in `custom.usrEnv.home.aspects`.
  - `modules/hardware/` — hardware-specific modules (CPU, GPU, sound, video, bluetooth).
  - `modules/roles/` — role presets: `graphical`, `headless`, `server`, `workstation`.
  - `modules/profiles/` — profile composables (gaming, workstation).
  - `modules/virt/` — virtualization modules (docker, qemu, waydroid, distrobox).
  - Module discovery: aspect files at the top of `modules/` auto-load via `import-tree`; the legacy trees are excluded there and loaded through the `nixos` registry aspects (each wraps its tree's `module.nix`).
- **Home-manager:** aspects live under `flake.modules.homeManager` (shared in `modules/home.nix` / `modules/_lib/home/`, per-user under `modules/home/users/`); the wiring in `modules/system/home-manager/module.nix` composes the host's selected aspects. No `extraSpecialArgs`/`specialArgs` are passed to home-manager.
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

- **All custom options** are under `config.custom.*` (declared in `modules/options/`, accessed as `config.custom.usrEnv`, `config.custom.system`, etc.).
- **Roles** stack tags and defaults: graphical adds `system.nixos.tags = ["graphical"]`.
- **stateVersion:** `system.stateVersion = "25.05"` for all hosts.
- **Host modules** are assembled by `mkModulesFor` in `hosts/default.nix`: nixos tree aspects (base/system/hardware/nix/virt/profiles) + roles + extra modules (sops-nix, home-manager).
- **ExtraModules pattern:** always pass `sops-nix` and `hm` as extra modules for graphical/workstation hosts (done centrally in `mkModulesFor`).
- **Adding a host:** see `docs/adding-a-host.md`.

## Secrets safety

- The repo contains `secrets/secrets.yaml` (SOPS-encrypted) and `secrets/.sops.yaml` (age key config).
- Agents must never print, transmit, or commit secrets.
- Use the repo's existing SOPS workflow (age keys + sops-nix) — do not add raw secrets to commits.
- **Sops conventions (phase 5):** the global `defaultSopsFile = ../../secrets/secrets.yaml` lives in `modules/system/secrets.nix` (system tree, so every host gets it); per-host secret entries (e.g. brau1589's `sops.secrets.vaultwarden_server_key`) live in the host's own `hosts/<name>/modules/system.nix`; consumers read paths via `config.sops.secrets.<name>.path` (see `modules/system/services/networking/wireguard.nix`, `modules/system/programs/ssh.nix`).

## Commits & PRs

- One-line imperative summary + body explaining why, not just what.
- Do not force-push main branches. Prefer a branch + PR for rebases.
- No pre-commit hooks or CI are currently configured in this repo.

## Tooling

- If formatting tools aren't installed locally: `nix run nixpkgs#nixpkgs-fmt -- <file>`
- The `.gitignore` only ignores `result`, `result-*`, `.direnv/`, and `*.hm.old`.

## Before committing

- Run `nixpkgs-fmt` on changed `.nix` files.
- Run `shfmt`/`shellcheck` on changed shell scripts.
- Ensure no secrets are staged.
- Run `nix build .#` or `nix flake check` if the change touches build logic.

If blocked or ambiguous: pick the least-surprising option (minimal change that keeps the build green) and note the choice in the commit message.
