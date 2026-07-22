# NXA Architecture Improvement Plan

Last updated: 2026-07-22
Status: Active

---

## Phase 1 — Eliminate Host Boilerplate (high impact)

### 1.1 Push remaining defaults into option modules

**Problem:** Every host's `system.nix` still repeats near-identical values:
- `fs.enabledFilesystems = [ "btrfs" "vfat" "ntfs" "exfat" ]` — 7 of 8 hosts identical
- `boot.isUEFI = true; boot.loader = "grub";` — 7 of 8 hosts
- `virtualisation = { enable = true; qemu.enable = true; docker.enable = true; }` — 7 of 8
- `security = { tor.enable = true; fixWebcam = false; }` — 7 of 8

**Solution:** Set `mkDefault` for all of these in `modules/options/system/module.nix`. Each host file retains only what *differs* from the defaults.

**Files to change:**
- `modules/options/system/module.nix` — add default blocks
- All 8 `hosts/*/modules/system.nix` — strip redundant values

---

### 1.2 Gate global boot assumptions

**Problem:** `modules/system/boot/module.nix` unconditionally blacklists TPM modules and sets `zfs.zfs_arc_max`, even on non-TPM / non-ZFS systems.

**Solution:** Guard with conditionals:
- TPM blacklist only when `!config.custom.device.hasTPM`
- ZFS kernel param only when `config.custom.system.fs.zfs.enable`

**Files to change:**
- `modules/system/boot/module.nix`

---

## Phase 2 — Options & Namespace Corrections

### 2.1 Move WM option declarations into the options tree

**Problem:** `home/cipher/gui/wms/hyprland/default.nix` declares `options.custom.programs.hyprland` ad-hoc outside `modules/options/`. This means only hosts importing the cipher home-manager module can reference it. niri/sway options don't exist as options at all.

**Solution:** Create `modules/options/usrEnv/programs/wms.nix` declaring options for `hyprland`, `niri`, `sway`. The HM implementation modules in `home/` reference these declared options.

**Files to create:**
- `modules/options/usrEnv/programs/wms.nix`

**Files to change:**
- `home/cipher/gui/wms/hyprland/default.nix` — move option declaration out, keep implementation
- `home/cipher/gui/wms/niri/default.nix` — same
- `home/cipher/gui/wms/sway/default.nix` — same

---

### 2.2 Drop the `workstation` role (overlap with `workstation` profile)

**Problem:** `modules/roles/workstation/` only sets `system.nixos.tags = ["workstation"]`. The `workstation` profile (`modules/profiles/workstation.nix`) does all actual configuration. Two overlapping concepts for the same thing.

**Solution:** Remove the `workstation` role directory. Remove it from `hosts/default.nix` role lists. Keep only the `workstation` profile. Optionally: remove the role from the `graphical` role's tag list too, or promote the profile to a role if preferred.

**Files to change:**
- `modules/roles/workstation/` — delete directory
- `modules/roles/graphical.nix` — remove `workstation` from any implicit tag references
- `hosts/default.nix` — remove `workstation` from `mkModulesFor` role lists
- `docs/adding-a-host.md` — update example

---

### 2.3 Kill `mkService`

**Problem:** The author self-describes `mkService` as "a horrendous abstraction" in `lib/modules.nix:58`. It only provides `host` + `port` options, forcing every consumer to supplement via `extraOptions`. The `sing-box` service already does it right with explicit options.

**Solution:** Inline all `mkService` call-sites in `modules/options/system/services/default.nix` with explicit option definitions (like `sing-box` already has). Remove `mkService` from the library.

**Files to change:**
- `modules/options/system/services/default.nix` — replace `mkService` calls with explicit `mkOption`/`mkEnableOption`
- `lib/modules.nix` — remove `mkService` definition and export

---

## Phase 3 — Module & Import Cleanup

### 3.1 Explicit top-level imports vs auto-discovery

**Problem:** `mkModuleTree'` silently collects every `module.nix` in the tree. A rename, move, or accidental creation of a `module.nix` silently changes behaviour. There's no explicit dependency graph.

**Solution:** Keep `mkModuleTree'` only for large, deeply nested sub-trees where the discovery is genuinely useful (e.g. `home/cipher/gui/`, `modules/options/style/palettes/`). Replace it with explicit `imports = [ ... ]` lists for the top-level module trees in `hosts/default.nix`.

**Files to change:**
- `lib/modules.nix` — no change (keep the utility for where it's useful)
- `hosts/default.nix` — replace `(map importPathOrTree ...)` with explicit import lists for the known module trees
- Potentially: module tree entry points (`modules/system/module.nix`, `modules/options/module.nix`, etc.) already use explicit imports, so this change is mostly in `hosts/default.nix`

---

### 3.2 Clean up stale docs

**Problem:** `docs/adding-a-host.md` still documents the old boilerplate patterns (setting `mainUser`, `users`, `homePath`, `sound.enable`, `video.enable`, etc. in every host `system.nix`).

**Solution:** Rewrite to reflect current simplified patterns after Phase 1.1.

**Files to change:**
- `docs/adding-a-host.md`

---

### 3.3 Clean up commented-out / dead code

**Candidates:**
- `modules/system/boot/module.nix` — commented `./analasis.nix` import
- `modules/hardware/gpu/nvidia/default.nix` — many commented environment variables
- `modules/system/display/wayland/environment.nix` — commented session variables
- `modules/system/impermanence.nix` — commented SSH host key paths, `home.persistence`
- `modules/options/system/services/default.nix` — `docker` option here vs `virtualisation.docker` in `virtualisation.nix`
- `modules/roles/server.nix` — single line file, possibly unnecessary
- `modules/hardware/redistributable.nix` — check if still needed

---

## Phase 4 — Architecture (Optional / Discuss)

### 4.1 Decouple home-manager user configs from cipher

**Problem:** Every `home/<user>/home.nix` is a thin wrapper importing `../cipher/home.nix`. Per-user differences must be hacked into shared files with `mkIf`.

**Solution:** Split `home/cipher/home.nix` into shared modules (`home/shared/cli.nix`, `home/shared/gui.nix`, etc.) and have each user's `home.nix` explicitly compose what they want.

---

### 4.2 Data-driven host definitions

**Problem:** `hosts/default.nix` has 8 near-identical `mkNixosSystem` blocks.

**Solution:** Define a single `builtins.mapAttrs` over a data attrset:

```nix
hosts = {
  amadeus  = { roles = [graphical workstation]; system = "x86_64-linux"; };
  brau1589 = { roles = [graphical workstation]; system = "x86_64-linux"; };
  lorian   = { roles = [headless server];       system = "x86_64-linux"; };
  ...
};
```

Reduces `hosts/default.nix` from ~150 lines to ~40.
