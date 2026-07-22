# NXA Architecture Improvement Plan

Last updated: 2026-07-22
Status: **Phase 1 complete**

---

## Phase 1 — Foundations (low risk, high impact)

### 1.1 Eliminate boilerplate in host `system.nix` files

**Problem:** Every host repeats:
```nix
mainUser = "winder";
users = [ mainUser ];
homePath = "/home/${mainUser}";
```
Plus identical boot defaults (`enableKernelTweaks`, `initrd.enableTweaks`, etc.) across 7 of 8 hosts.

**Solution:** Move defaults into `modules/options/system/module.nix` via `mkDefault`. Each host only keeps what differs.

**Changes:**
- `enableKernelTweaks`, `initrd.enableTweaks`, `loadRecommendedModules` now default to `true`
- `defaultUserShell` now defaults to `pkgs.fish`
- `printing.enable` defaults to `false`
- All 8 host `system.nix` files stripped of now-redundant values (saved ~15 lines each)
- `lorian` retains `pkgs.zsh` and `isUEFI = false` as host-specific overrides

**Status:** ✅ Complete

---

### 1.2 Simplify `callLibs` in `lib/default.nix`

**Problem:** The `callLibs` function uses a `__functor` pattern the author self-describes as "the most cursed." It adds complexity for zero benefit — every lib file already takes `{ inputs, lib, ... }`.

**Solution:** Replace `callLibs ./foo.nix` with `import ./foo.nix { inherit inputs; lib = self; }`.

**Files touched:** `lib/default.nix` only (callers remain unchanged since the `extendedLib` attr shape stays the same).

**Changes:** Removed `callLibs` function entirely. Replaced 5 `callLibs` calls with direct `import`. Removed dead commented-out code. `lib/default.nix` went from 164→49 lines.

**Status:** ✅ Complete

---

## Phase 2 — Roles & Profiles (architectural corrections)

### 2.1 Make roles actually configure systems

**Problem:** `graphical.nix`, `headless.nix`, and `server.nix` only set a tag. They don't configure anything.

**Solution:** Each role gains `mkIf`-guarded config:
- `graphical`: enable wayland, pipewire, graphical target
- `headless`: enable sshd, disable sound/video/bluetooth
- `server`: enable server-oriented services

**Status:** ❌ Not started

---

### 2.2 Derive home-manager config path from hostname

**Problem:** `home/module.nix` hardcodes `./cipher/home.nix`. lorian (headless server) gets cipher's full GUI home config.

**Solution:** Derive path from hostname: `./${config.custom.system.mainUser}/home.nix` or `./${config.networking.hostName}/home.nix`.

**Status:** ❌ Not started

---

### 2.3 Expand `custom.profiles.workstation`

**Problem:** Workstation profile only enables libreoffice + zathura. Most graphical hosts repeat terminal/browser/launcher selections.

**Solution:** Move common desktop defaults (terminals, browsers, launchers) into the profile.

**Status:** ❌ Not started

---

## Phase 3 — Namespace & Options Cleanup

### 3.1 Unify `custom.hardware` into `custom.device`

**Problem:** GPU config lives under `custom.hardware.nvidia` while GPU *type* declarations are under `custom.device.gpu`. No cross-linking.

**Solution:** Add assertions + optionally migrate GPU enable options under `custom.device.gpu.*`.

**Status:** ❌ Not started

---

### 3.2 Add missing `custom.system.networking` option module

**Problem:** The README references networking options (tailscale, nftables, optimizeTcp) but `modules/options/system/networking.nix` doesn't exist. Host configs set these ad-hoc.

**Solution:** Create the missing options module with tailscale, nftables, and optimizeTcp options.

**Status:** ❌ Not started

---

### 3.3 Add `custom.system.impermanence.persistPath`

**Problem:** No centralized abstraction for the persist path. Hosts must reach into raw `environment.persistence."/persist"`.

**Solution:** Add `persistPath` option (default `"/persist"`) to the impermanence options module.

**Status:** ❌ Not started

---

## Phase 4 — Stale Code Removal

### 4.1 Clean up commented-out imports

**Files to clean:**
- `hosts/default.nix` — commented nixos-hardware, caelestia-shell
- `modules/roles/headless.nix` — all commented imports
- `modules/roles/server.nix` — all commented imports
- `modules/system/boot/module.nix` — commented `./analasis.nix`
- `modules/system/services/module.nix` — commented fwupd, navidrome
- `modules/virt/module.nix` — commented podman
- All hosts `system.nix` — commented-out services
- `lib/default.nix` — all commented-out extendedLib entries (aliases, ci, dag, etc.)

**Status:** ⏳ Partially done (lib/default.nix cleaned in Phase 1.2)

---

### 4.2 Remove dead core

**Problem:** `modules/system/boot/loaders/none/` exists but `custom.system.boot.loader` has no `"none"` in its enum.

**Solution:** Drop dead paths.

**Status:** ❌ Not started

---

## Phase 5 — CI & Automation

### 5.1 Add GitHub Actions CI

**Problem:** No automated checks. 8 hosts are never verified after changes.

**Solution:** Add `.github/workflows/check.yml` with `nix flake check`.

**Status:** ❌ Not started

---

### 5.2 Add justfile

**Problem:** Common commands spread across docs and AGENTS.md; no single entry point.

**Solution:** Add `justfile` with `check-all`, `format`, `build-host <name>`.

**Status:** ❌ Not started

---

## Phase 6 — Optional Enhancements

### 6.1 Stylix integration

**Problem:** AGENTS.md mentions stylix as extraModule, but it's never imported.

**Solution:** Either import stylix or remove the reference.

**Status:** ❌ Not started

### 6.2 Host-specific disko/router abstraction

**Problem:** 6 hosts define filesystems raw in `fs.nix`. Only brau1589 uses `disko.nix`.

**Solution:** Migrate to shared disko abstraction for btrfs hosts.

**Status:** ❌ Not started
