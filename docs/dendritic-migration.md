# Dendritic Migration Path

A phase-by-phase plan for migrating the NXA flake from its current architecture
(flake-parts + auto-imported NixOS module trees + nested home-manager eval) to
the **dendritic pattern** (every file is a flake-parts module; named aspect
registry `flake.modules.<class>.<name>`; hosts compose aspects by name).

Reference: https://github.com/mightyiam/dendritic · https://dendrix.denful.dev/Dendritic.html

Last updated: 2026-08-04
Status: Active — Phase 2 complete

## Migration progress

- [x] **Phase 0 — Baseline & branch** (2026-08-03)
- [x] **Phase 1 — Registry skeleton** (coarse aspects, zero behavior change) (2026-08-03)
- [x] **Phase 2 — Hosts & roles become aspects** (2026-08-04)
- [ ] **Phase 3 — Home-manager unwrap** (3a wiring ✓ with deviations · 3b register by name ✓ · 3c steps 1–7 ✓ · 3d per-user composition ✓)
- [ ] **Phase 4 — Delete legacy & docs** (incl. reverting the four migration pins)
- [ ] **Phase 5 — Optional polish**

---

## 1. Verified technical foundations

These facts were confirmed against the pinned toolchain and matter for every
phase below:

1. **The dendritic registry option is NOT built into the locked flake-parts.**
   flake-parts added `options.flake.modules`
   (`types.lazyAttrsOf (types.lazyAttrsOf types.deferredModule)`) only in a
   later rev, as the optional extra module `extras/modules.nix`. The locked
   flake-parts (`17c9d6c`) has `options.flake` as a freeform
   `lazyAttrsOf (unique raw)`, which rejects multiple aspect definitions of
   `flake.modules`. Phase 1 therefore declares the option locally in
   `modules/_lib/registry.nix` (same type as upstream). Classes are the outer
   attr (`nixos`, `homeManager`, `darwin`, `generic`), names the inner.
   Modules registered this way are exposed to the rest of the flake as
   `self.modules.<class>.<name>`. The upstream `extras/modules.nix` apply also
   sets `_class`, which Phase 3c (class conversion) may want to add.

2. **home-manager injects `osConfig` into HM module args** when used through
   `home-manager.nixosModules.home-manager` (HM `nixos/common.nix:30`:
   `osConfig = config;`). This lets homeManager-class aspects read
   `osConfig.custom.*` with **no `specialArgs`** — the current
   `extraSpecialArgs = { inherit inputs self inputs' self' defaults; }`
   (`home/module.nix:17`) becomes unnecessary.

3. **`import-tree`** (`github:denful/import-tree`, maintained fork of
   `vic/import-tree`; fallback: `vic/import-tree`) loads every `.nix` file under
   a directory as a flake-parts module in one expression. Paths containing
   `/_` are ignored — that's where helper code lives.

4. **Store-path equivalence** is the strongest correctness gate available: if
   the pre-migration and post-migration `config.system.build.toplevel` have the
   same out path, behavior is provably identical.

5. **Store-path evals require a CLEAN worktree.** The toplevel closure embeds
   the self-flake git revision (`nixos-version` → `system-path` → `etc` →
   everything). Any uncommitted change to tracked files marks the revision
   `-dirty` and silently changes **every** host's store path — a false
   negative for the equivalence gate. Rules (verified empirically during
   Phase 0):
   - Always compare store paths with a committed (or `git stash`ed) tree.
   - **Untracked files are silently EXCLUDED from the git flake source.** They
     do not dirty the flake (`nix flake metadata` shows `dirty=null`) — but they
     are also not part of the source copy, so a new `.nix` file has **no effect
     until it is `git add`ed** (verified empirically: `modules/_lib/registry.nix`
     was missing from the store source copy until staged; aspect files likewise).
     Sanity-check new files with the store source copy or `nix eval .#modules`
     before trusting a gate.
   - Sanity-check with `nix flake metadata --json | jq .dirtyRevision` before
     trusting a gate.

6. **Even a clean tree changes every host's toplevel on every commit** unless
   the self-revision is pinned. Three migrations-only pins were added in
   Phase 0 to make toplevel store paths **commit-stable**, and a **fourth**
   (the `nh` flake-path leak, found in Phase 1) was added in `00d1a04`.
   **All four must be reverted in Phase 4:**

   | Pin | Location | Why |
   |---|---|---|
   | `system.nixos.revision = "dendritic-migration"` | `lib/builders.nix` (base module) | per-commit `self.rev` |
   | `system.configurationRevision = "dendritic-migration"` | `modules/nix/system.nix` | feeds `nixos-version` → `system-path` → toplevel |
   | `environment.etc."nyx".source = <toFile ...>` (was `= self`) | `modules/nix/system.nix` | `self` is the per-commit flake source path, embedded in `/etc/nyx` |
   | `programs.nh.flake = <toFile ...>` (was `= inputs.self.outPath`) | `modules/nix/nh.nix` | `inputs.self.outPath` → `NH_FLAKE` → `set-environment` → whole toplevel |

   Each is marked with a `MIGRATION ONLY` comment. Restoring the original
   values in Phase 4 is part of deleting the legacy machinery.

   Note: the Phase 0 claim of "validated 8/8 across no-op commits" could not
   have held at the time — the `nh.nix` leak (§1 fact 6, row 4) was already
   present, so a no-op commit *would* have changed every toplevel. True
   commit-stability was only achieved and verified after the `nh` pin landed
   (`00d1a04`): amadeus `88ydlh…` is identical across `00d1a04` and `9065727`.

## 2. Current state (baseline inventory)

| Thing | Where | Size |
|---|---|---|
| Hosts | `hosts/default.nix` — 8 near-identical `mkNixosSystem` blocks | 149 lines |
| Host modules | `hosts/<name>/host.nix` + `hosts/<name>/modules/*` | 8 × ~5 files |
| NixOS module trees | `modules/{options,system,hardware,nix,virt,profiles,roles}` | ~150 files |
| Custom options | `modules/options/` → `config.custom.{device,system,usrEnv,style,profiles,meta}` | ~60 files |
| Home-manager | `home/module.nix` (alias `hm` + `specialArgs` + `sharedModules`) + `home/<user>/home.nix` | 118 files |
| Shared user config | 7 of 8 `home/<user>/home.nix` just `imports = [ ../cipher/home.nix ]` | — |
| Builder | `lib/builders.nix` — `mkNixosSystem` via `lib.nixosSystem` | 69 lines |
| Loader lib | `lib/modules.nix` — `mkModuleTree`, `mkModuleTree'`, `importPathOrTree`, `mkService` | 86 lines |

Home-manager churn, precisely sized:

- 118 `.nix` files under `home/`
- 76 set `config.hm` (the alias wrapper) — need unwrapping
- 33 read `config.custom` — need `osConfig.custom`
- 3 use `inputs.<name>`: `home/cipher/gui/bars/dankMaterial.nix` (`inputs.dms`),
  `home/cipher/gui/browsers/zen.nix` (`inputs.zen-browser`),
  `home/cipher/gui/wms/niri/default.nix` (`inputs.niri`) — need closure capture
- 2 use `self`
- 1 uses the `defaults` specialArg: `home/cipher/gui/wms/sway/config.nix`

## 3. Target state

```
flake.nix          # mkFlake { inherit inputs; } { imports = [ (import-tree ./modules) ./hosts ./lib ]; }
                   #   modules/_lib/registry.nix is loaded explicitly (import-tree skips /_);
                   #   the import-tree call is path-filtered so the legacy trees stay out
                   #   until they migrate (see Phase 1 deviations 2)
modules/
  _lib/            # helpers — not auto-imported (import-tree /_ convention);
                   # registry.nix here declares options.flake.modules
  base.nix         # NixOS core aspect: custom.* tree + secrets + common defaults
  system.nix       # coarse aspect: imports ./system/module.nix
  hardware.nix     # coarse aspect: imports ./hardware/module.nix
  nix.nix          # coarse aspect: imports ./nix/module.nix
  virt.nix         # coarse aspect: imports ./virt/module.nix
  profiles.nix     # coarse aspect: imports ./profiles/module.nix
  roles/
    graphical.nix  # flake.modules.nixos.roles.graphical
    headless.nix
    server.nix
    workstation.nix
  hosts/
    amadeus.nix    # flake.modules.nixos.amadeus (host.nix + modules/* + fs.nix)
    brau1589.nix
    cipher.nix
    heu.nix
    lorian.nix
    magi.nix
    salieri.nix
    wired.nix
  home/
    base.nix       # homeManager core aspect (today's sharedModules + shell basics)
    cli.nix        # shared user aspects (split out of home/cipher/)
    gui.nix
    themes.nix
    gaming.nix
    media.nix
    misc.nix
    cipher.nix     # per-user aspects composing the shared ones
    amadeus.nix
    ...
hosts/default.nix  # thin data table: host → roles + home aspects, ~40 lines
lib/               # unchanged (mkNixosSystem stays)
home/              # retired — content moved to modules/home/
```

Rules of the end state:

- Every `.nix` file under `modules/` is a flake-parts module (auto-imported).
- NixOS-class modules live under `flake.modules.nixos.<name>`; home-manager
  modules under `flake.modules.homeManager.<name>`.
- Hosts select aspects **by name**, never by file path.
- `flake.nix` and `hosts/default.nix` contain no host-specific configuration.
- No `specialArgs` / `extraSpecialArgs` anywhere (one documented exception in
  Phase 3a wiring: `self` remains an arg to the NixOS eval — already the case in
  `lib/builders.nix`).

---

## 4. Phases

Each phase ends with a green gate. Phases 1–3b must preserve store paths
byte-for-byte.

### Phase 0 — Baseline & branch

**Status: DONE** — commits `2d3f66a`, `26271f9`, `421bf26`, `104dce1`,
`cc543e4` on branch `dendritic`. Landed: lorian eval fix, `import-tree`
input, three self-revision pins (a fourth — the `nh` flake-path pin — was
added in Phase 1, `00d1a04`), baseline recorded at `/tmp/opencode/baseline.txt`
(8/8 hosts; **regenerated in Phase 1** — the original was recorded on a dirty
tree and is unreproducible, see §1 fact 5), gate validated across no-op
commits *after* the `nh` pin landed. Next: Phase 2.

**Objective:** a safe, measured starting point.

Steps:

1. Create branch off clean main:
   ```bash
   git switch -c dendritic-migration
   ```
2. Record baseline store paths for all 8 hosts. Use `nix eval --raw` on
   `config.system.build.toplevel.outPath` — pure evaluation, no build, and
   identical paths to a real build:
   ```bash
   : > /tmp/opencode/baseline.txt
   for h in amadeus brau1589 cipher heu lorian magi salieri wired; do
     printf '%s ' "$h"
     nix eval --raw .#nixosConfigurations.$h.config.system.build.toplevel.outPath \
       >> /tmp/opencode/baseline.txt
   done
   ```
   Keep this file out of git (it is not the repo's place).
3. Add the `import-tree` input to `flake.nix`:
   ```nix
   import-tree.url = "github:denful/import-tree";
   ```
4. `nix flake lock` and confirm `nix flake check` passes.
5. **Pre-existing fix landed first:** lorian failed to evaluate on main
   (`secure-mount-options.nix` set `fileSystems."/boot".options` on a BIOS/ext4
   host with no `/boot` mount). Fixed by guarding on
   `config.custom.system.boot.isUEFI` in commit `2d3f66a` **before** recording
   the baseline so it covers all 8 hosts.
6. **Pin the self-revision (see §1 fact 6):** the three migration-only pins
   must be in place before recording the baseline, otherwise every later
   commit invalidates the file. Add them, commit, then record the baseline.
   Store paths are then commit-stable (this 8/8 no-op validation was in fact
   defeated by the `nh` leak and only held after the fourth pin landed in
   `00d1a04` — see §1 fact 6 note).

**Gate:** `nix flake check` green; baseline recorded; a no-op commit leaves
all 8 toplevel paths unchanged.

**Time:** 0.5–1 h.

---

### Phase 1 — Registry skeleton, zero behavior change

**Objective:** populate the aspect registry without changing what any host
evaluates to. The registry is filled but not yet consumed.

**Status: DONE** — commits `0469c15` (aspects + import-tree wiring),
`00d1a04` (nh flake-path pin), `9065727` (registry option declaration),
`e9799a0` (this doc: Phase 1 status + deviations). Gate: `nix flake check`
green; all 8 toplevel store paths recorded as the
new Phase 1 baseline at `/tmp/opencode/baseline.txt`.

**Deviations from this plan** (all required by the pinned toolchain;
committed on the `dendritic` branch):

1. `mkFlake` at `17c9d6c` rejects a module **list** (it wraps the argument in
   `{ imports = [ arg ] }` and the module system throws "Module imports can't
   be nested lists"). `outputs` therefore passes a single module whose
   `imports` carries the tree, `./hosts`, and `./lib`. (Same class of change
   as the freeform `flake` fix in foundation §1.)
2. A bare `(inputs.import-tree ./modules)` auto-imports the raw NixOS trees
   (`options/`, `system/`, …) into the flake-parts module space and fails eval
   (infinite recursion / undefined options). A path filter excludes
   `/(options|system|hardware|nix|virt|profiles|roles)/` so only the six
   coarse aspect files load.
3. `options.flake.modules` is declared locally in `modules/_lib/registry.nix`
   (import-tree skips `/_`; flake.nix imports it explicitly) because the
   locked flake-parts lacks it (see foundation §1).
4. **New leak found & pinned:** `modules/nix/nh.nix` embedded
   `inputs.self.outPath` into `NH_FLAKE` → `set-environment` → the whole
   toplevel closure, defeating the gate exactly like the Phase 0 pins. Phase 0
   missed it; pinned to a constant in `00d1a04`, reverted in Phase 4.
5. The original `/tmp/opencode/baseline.txt` was recorded on a **dirty** tree
   and is unreproducible (see foundation §5). It was regenerated on the clean
   committed Phase 1 head (`9065727`); the Phase 0 gate conclusion still
   holds — store paths are commit-stable (verified: `88ydlh…` for amadeus is
   identical across the `00d1a04` and `9065727` commits).

Steps:

1. Rewrite `flake.nix` outputs:
   ```nix
   outputs = inputs @ { flake-parts, ... }:
     flake-parts.lib.mkFlake { inherit inputs; } [
       (inputs.import-tree ./modules)
       ./hosts
       ./lib
     ];
   ```
   `./lib` and `./hosts` remain explicit flake-parts modules (they are the
   entry points; `lib/default.nix` also sets `perSystem._module.args.lib` and
   `flake.lib`, which must not move).

2. Create `modules/_lib/` for helpers that must not be auto-imported. There is
   no migration-critical content there yet; the directory exists from now on
   to establish the convention.

3. Create the coarse NixOS aspects. Each wraps an existing tree by its root
   `module.nix` (verified: every tree root imports all of its children
   explicitly, so this preserves the exact current module set):
   ```nix
   # modules/system.nix
   { ... }: {
     flake.modules.nixos.system = {
       imports = [ ./system/module.nix ];
     };
   }
   ```
   Same shape for `hardware.nix`, `nix.nix`, `virt.nix`, `profiles.nix`.

4. Create the base aspect (`modules/base.nix`):
   ```nix
   # modules/base.nix
   { ... }: {
     flake.modules.nixos.base = {
       imports = [
         ./options/module.nix        # the custom.* tree
       ];
     };
   }
   ```
   Decision (this phase, and stick to it): secrets ownership stays in the
   system tree — `modules/system/module.nix` already imports `./secrets.nix`,
   so the base aspect imports only `./options/module.nix` and must not import
   `./secrets.nix` (keeps tree ownership clean; imports are idempotent but the
   system tree stays the single owner).

5. Audit reachability: every `module.nix` that `mkModuleTree'` currently
   collects from `modules/{options,system,hardware,nix,virt,profiles}` must be
   reachable from the corresponding root `module.nix`. The roots above are
   confirmed complete today; re-verify after any future refactor with:
   ```bash
   # collected today (git show HEAD~0 list via mkModuleTree' semantics)
   find modules/options modules/system modules/hardware modules/nix \
     modules/virt modules/profiles -name 'module.nix'
   ```

6. Do **not** touch `hosts/default.nix` yet — hosts keep using
   `mkModulesFor`. The registry exists but nothing consumes it, so the module
   set per host is unchanged.

**Gate:**

```bash
nix flake check
for h in amadeus brau1589 cipher heu lorian magi salieri wired; do
  nix build .#nixosConfigurations.$h.config.system.build.toplevel --print-out-paths
done
# diff against /tmp/opencode/baseline.txt — must be identical
```

**Time:** 2–4 h.

---

### Phase 2 — Hosts & roles become aspects

**Objective:** hosts and roles join the registry; `hosts/default.nix` becomes a
data table; nothing a host evaluates changes.

**Status: DONE** — commits `f540c48` (doc reconcile), `0dc1211` (8 inert host
aspects, Gate 1 green 8/8), `46cbe9a` (roles → aspects, workstation moved,
filter dropped `roles`, data table rewrite), `db831bf` (restored exact module
order for store-path preservation). Gate: `nix flake check` green; all 8
toplevel store paths match the Phase 1 baseline.

**Deviations from this plan** (all required by the pinned toolchain or discovered
during execution):

1. **Registry type is strictly 2-level** (`lazyAttrsOf (lazyAttrsOf deferredModule)`),
   so `flake.modules.nixos.roles.*` (3-level) is impossible. Roles register
   under a dedicated class: `flake.modules.roles.{graphical,headless,server,workstation}`,
   looked up as `registry.roles.${r}`; hosts as `registry.nixos.${n}` with
   `registry = config.flake.modules`.

2. **Coarse aspects (`base`, `system`, `hardware`, `nix`, `virt`, `profiles`) must
   NOT wrap the legacy trees as flake-parts aspects yet** — doing so changes the
   module list shape (aspect wrapper with nested `imports` vs direct
   `importPathOrTree`), which alters the BFS expansion order in NixOS
   `evalModules` and breaks drvPath equality. The trees continue to use
   `importPathOrTree` directly (preserving the exact module list shape with
   duplicated child imports). Only hosts and roles consume the registry.

3. **Workstation legacy content moved to `modules/_lib/roles/workstation/system/`**
   (self-contained, relative imports only) to keep the workstation role aspect
   simple and the import-tree filter clean (`/_` is auto-skipped).

4. **`import-tree` filter in `flake.nix` updated to exclude only
   `options|system|hardware|nix|virt|profiles`** (roles removed; the six coarse
   aspects are the only remaining auto-imported tree wrappers).

5. **Host aspects (`modules/hosts/*.nix`) fold in `sops-nix` and `home-manager`**
   as imported modules, keeping the data table pure.

6. **Gate 2 initially FAILED** (all 8 store paths differed) due to the module
   order change (the aspect-based trees reordered the BFS expansion). Root cause
   identified: NixOS `listOf`-typed options (like `environment.systemPackages`)
   concatenate in module-definition order; the new aspect wrapping changed the
   effective order of package definitions, producing a different `system.path`
   drv and cascading to `etc`, `system-units`, etc. Fixed by replicating the
   EXACT pre-Phase-2 module list construction in `hosts/default.nix` (host.nix
   first, then trees via `importPathOrTree`, then registry role values, then
   home-user, then sops/hm last).

---

### Phase 3 — Home-manager unwrap (the bulk)

**Objective:** move home-manager from a nested eval behind the `config.hm`
alias to a first-class `homeManager` class in the registry, with real HM
modules and per-user aspect composition.

#### 3a. Wiring core (1 h)

Replace the alias + specialArgs mechanism in `home/module.nix`:

```nix
# home/module.nix (rewritten)
{ config, inputs, ... }:
let
  sys = config.custom.system;
  registry = inputs.self.modules.homeManager;
  homeAspects = config.custom.home.aspects; # list of names, see below
in {
  home-manager = {
    verbose = true;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm.old";

    users.${sys.mainUser} = {
      imports = map (name: registry.${name}) homeAspects;
    };
  };
}
```

Notes:

- `inputs.self` is already a NixOS eval arg via `lib/builders.nix:45`
  (`inherit inputs self inputs' self'`), so `self.modules.homeManager.*` is
  readable from NixOS modules. No new specialArgs.
- The `hm` alias option module (`mkAliasOptionModule [ "hm" ] ...`,
  `home/module.nix:21`) is deleted at the end of 3c, together with
  `extraSpecialArgs`.
- The per-host aspect selection list is a new option. Minimal version:
  declare `custom.home.aspects` (a `listOf str`, defaulting to
  `[ "base" "cli" "gui" "themes" "gaming" "media" "misc" ]`) in
  `modules/options/` so host aspects can override it per machine
  (e.g. lorian = `[ "base" "cli" ]`).
- `sharedModules` (nix.package mkForce, programs.home-manager.enable, manual
  off) moves into the homeManager `base` aspect.

#### 3b. Register home aspects by name, still wrapped (2–3 h)

Halfway checkpoint: the home config is name-addressed but still NixOS-class
(i.e. files keep `config.hm = { ... }`).

1. Move `home/cipher/{cli,gui,themes,misc}` under `modules/home/` (keeping the
   directory structure exactly, so paths and imports inside files keep
   working).
2. Split into shared aspects + per-user aspects:
   ```nix
   # modules/home/cli.nix
   { ... }: {
     flake.modules.nixos.home.cli = {
       imports = [ ./cipher/cli ];
     };
   }
   ```
   with `gui`, `themes`, `misc`, plus a `home.base` aspect for what was
   `home/cipher/home.nix` (home.username/homeDirectory/stateVersion +
   systemd.user.startServices). Create empty per-user aspects that compose:
   ```nix
   # modules/home/cipher.nix
   { ... }: {
     flake.modules.nixos.home.users.cipher = {
       imports = [
         ./cipher/home.nix
         ./cipher/gui/wms
       ];
     };
   }
   ```
   Do not perfect the split here — Phase 3d does that.
3. Wire `home/module.nix` to import the registry entries instead of
   `home/<user>/home.nix`:
   ```nix
   users.${sys.mainUser}.imports =
     map (name: registry.${name}) homeAspects
     ++ [ registry.users.${hostname-or-default} ];
   ```
4. Delete `hosts/default.nix`'s `homesPath` plumbing (`homesPath` import in
   `mkModulesFor`). The module set per host must remain identical — the same
   files end up imported, just through the registry.

**Gate:** all 8 store paths == baseline (this proves 3b is a pure
reorganization).

**Time:** 2–3 h.

#### 3c. Convert the class to `homeManager` (5–7 h)

**Status: DONE** — steps 1–7 complete (2026-08-05). Steps analysed before this
branch independently (options hygiene, `hm` unwrap, `config.custom` →
`osConfig.custom`, `defaults` specialArg inlining, `_class` flip). The final two
steps — #4 **closure capture** and #7 **alias/specialArgs deletion** — were the
delta this branch finished:

- Closure-captured aspects now live under `modules/home/` (one file per aspect,
  `{ inputs | inputs' | self, ... }` closing over flake-parts specialArgs):
  `dank-material.nix` (`inputs.dms`), `zen.nix` (`inputs.zen-browser`),
  `foot.nix` (`inputs'.nyxexprs`), `randomize.nix` (`inputs'.winpaper`),
  `hyprlock.nix` / `hyprpaper.nix` (`inputs'.hyprlock` / `inputs'.hyprpaper`),
  `xdg.nix` (`self.lib.xdgTemplate`). The old `_lib/...` leaves they replaced
  were deleted (`gui/bars/dankMaterial.nix`, `gui/browsers/zen.nix`,
  `gui/terminals/foot/default.nix` [presets kept under `_lib`],
  `gui/wallpaper/scripts/randomize.nix`, `gui/wms/hyprland/tools/{hyprlock,
  hyprpaper}.nix`, `misc/xdg.nix` + `misc/`). The `gui`/`misc` aspects in
  `modules/home.nix` now compose these closure aspects via `self` plus the
  remaining tree.
- `home/module.nix` no longer passes `inputs`/`inputs'`/`self'`/`specialArgs`/
  `extraSpecialArgs`; `self` is retained solely for the
  `self.modules.homeManager` registry look-up (still supplied by the NixOS-side
  specialArgs in `lib/builders.nix`, which is out of scope for 3c). The
  `mkAliasOptionModule [ "hm" ]` alias was already removed in an earlier phase;
  lines 440–443 documenting its deletion are satisfied.
- The orphaned `hyprlock`/`hyprpaper` modules (never imported by any tree,
  gated by `options.custom.programs.hyprlock/hyprpaper.enable`) were converted
  to closure aspects and composed into `gui` — behavior-neutral while the
  options are disabled, keeps the code reachable.
- Verified: all 8 hosts evaluate; `nix flake check` passes; cipher and lorian
  toplevel drvPaths are byte-identical to the pre-migration anchors
  (`qjz7dpyiyh7yg9j8dzc3gmrvixyk4pdn…` and `3sl319f9c8pwfir7kiz8kf25mwkzlhvk…`).

This is the real unwrap. Mechanical, script-assisted, done in this order:

1. **Options hygiene first (PLAN.md 2.1):** move ad-hoc option declarations
   out of home files into `modules/options/`:
   - `home/cipher/gui/bars/dankMaterial.nix` declares
     `options.custom.programs.dms` — move to
     `modules/options/usrEnv/programs/wms.nix`
   - `home/cipher/gui/wms/hyprland/default.nix` declares
     `options.custom.programs.hyprland` — same target
   - niri/sway: declare options for `niri`/`sway` in the same file
   HM aspects must not declare NixOS options; everything read via
   `osConfig.custom.*` must be declared in the NixOS options tree.
2. **Unwrap the `hm` wrapper (76 files):** transform
   ```nix
   { config, ... }: {
     config.hm = {
       home.packages = [ ... ];
       programs.git = { ... };
     };
   }
   ```
   into a real HM module:
   ```nix
   { ... }: {
     home.packages = [ ... ];
     programs.git = { ... };
   }
   ```
   (strip one level of nesting, dedent one level). Scriptable with a simple
   tree-sitter/awk pass; hand-review the non-trivial cases (conditionals in
   `dankMaterial.nix`, `sway/config.nix`, hyprland config files).
3. **`config.custom` → `osConfig.custom` (33 files):** mechanical rename.
   `osConfig` is provided by home-manager's NixOS module (verified, see §1.2).
   Watch for files that only *set* `custom.*` options (e.g. `wms` files) —
   those set nothing in the HM eval and become pure `osConfig` readers; any
   host-facing toggles keep being set in the NixOS host aspects.
4. **`inputs` / `self` closure capture (7 files):** wrap the aspect
   definition so the deferredModule closes over flake-parts args:
   ```nix
   # modules/home/dank-material.nix  (new aspect definition file)
   { inputs, ... }: {
     flake.modules.homeManager.dankMaterial = { config, lib, ... }: {
       imports = [ inputs.dms.homeModules.default ];
       programs.dank-material-shell = lib.mkIf (config.custom.dms.enable) {
         enable = true;
         settings.iconTheme = "Papirus-Dark";
       };
     };
   }
   ```
   ⚠️ **Staging gotcha:** flake store-source copies of a dirty worktree omit
   untracked files, so the new aspect files under `modules/home/` silently
   failed to register (options showed as missing) until `git add`'d. Stage the
   new files before evaluating. See the risk table's hidden `inputs`/`self`
   row for the repeat sweep gate.
   The actual sweep of the cipher home tree found **seven** leaves, a wider
   set than the plan's estimate (`dankMaterial`, `zen`, `foot`, `randomize`,
   `hyprlock`, `hyprpaper`, `xdg`; `niri/default.nix` was already captured in
   an earlier phase). Done under `modules/home/<name>.nix`, composed into
   `gui`/`misc` via `self.modules.homeManager.<name>`, and the original
   `_lib/` leaves deleted. Re-run the sweep to catch stragglers:
   ```bash
   rg -l 'inputs(\.|\x27\x27|\x27\.)|\bself\b' modules/_lib/home/cipher
   ```
5. **`defaults` specialArg (1 file):** `home/cipher/gui/wms/sway/config.nix`
   — inline the value of `config.custom.usrEnv.programs.default` via
   `osConfig.custom.usrEnv.programs.default`.
6. **Register the converted aspects** by flipping the class:
   ```nix
   flake.modules.homeManager.cli = { imports = [ ./cli ]; };
   ```
   (note: `flake.modules.nixos.home.cli` → `flake.modules.homeManager.cli`).
   The `_class` wrapper makes class mistakes fail loudly at eval time — a
   feature, not a bug.
7. **Delete the alias:** remove `mkAliasOptionModule [ "hm" ] ...`,
   `extraSpecialArgs`, and the `specialArgs` block in `home/module.nix`.
   Keep `useGlobalPkgs`/`useUserPackages` as-is.

**Gate:**

```bash
nix flake check
nix build .#nixosConfigurations.cipher.config.system.build.toplevel
nixos-rebuild dry-activate --flake .#cipher   # no HM drift noise
```

Accept small, documented diffs in the HM generation (option ordering, alias
removal); investigate anything behavioral.

**Time:** 5–7 h.

#### 3d. Per-user composition (1–2 h)

**Status: DONE** (2026-08-05). Users stop inheriting cipher wholesale:

- Per-user aspects live under `modules/home/users/<name>.nix` (one per host).
  Each composes the shared `flake.modules.homeManager` aspects **by name**
  (`base`, `cli`, `gui`, `themes`, `misc`) via `self` — the same name-based
  mechanism hosts use. The seven `gui`-class hosts (amadeus, brau1589, cipher,
  heu, magi, salieri, wired) compose the full set (they inherit cipher's config
  today); `lorian` composes only `[ "base" "cli" ]` per the plan example.
  Per-user deltas belong in these files, not behind `mkIf` in shared files.
- `hosts/default.nix` (data table) gained a `home = [ <aspect-name> ]` field
  per host; the host construction injects
  `{ config.custom.usrEnv.home.aspects = cfg.home; }` as an extra module, so
  hosts select aspects by name (never by file path).
- The old registry entries in `modules/home.nix` that pointed every per-user
  aspect at `./_lib/home/cipher/home.nix` were deleted, and that composer file
  removed with them.
- Note: the plan's example showed `amadeus = [ "base" "cli" "gui" "themes" ]`
  (no `misc`); `misc` here only carries the `xdg` closure aspect (needed for
  browser/file-manager mime associations), so the `gui`-class hosts keep it
  until per-user deltas say otherwise.

Address PLAN.md 4.1 — users stop inheriting cipher wholesale:

```nix
# hosts/default.nix (extended table)
hosts = {
  amadeus = { roles = [ "graphical" "workstation" ]; home = [ "base" "cli" "gui" "themes" ]; };
  ...
  lorian   = { roles = [ "headless" "server" ];       home = [ "base" "cli" ]; };
  ...
};
```

Each user aspect (`modules/home/users/<name>.nix`) composes shared aspects and
adds its own deltas. Any file that only exists because cipher's config was
inherited should now be gated per-user by the aspect composition, not by
`mkIf` inside shared files.

**Gate:** all 8 hosts evaluate; cipher and lorian build cleanly.

**Time:** 1–2 h.

---

### Phase 4 — Delete legacy & docs

Steps:

1. **Revert the four migration-only pins (see §1 fact 6):**
   - `lib/builders.nix` — remove `system.nixos.revision = "dendritic-migration"`.
   - `modules/nix/system.nix` — restore
     `configurationRevision = self.shortRev or self.dirtyShortRev` and
     `environment.etc."nyx".source = self`.
   - `modules/nix/nh.nix` — restore `programs.nh.flake = inputs.self.outPath`.
2. `lib/modules.nix`: remove `mkModuleTree` (and `mkModuleTree'` /
   `importPathOrTree`) if nothing references them after Phase 2
   (`rg -n 'mkModuleTree|importPathOrTree|mkService' modules hosts lib home`).
   Remove `mkService` (PLAN.md 2.3) while in here if not already done.
3. Delete `home/` directory and the `homesPath` remnants in
   `hosts/default.nix`.
4. Slim `hosts/default.nix` to the data table (PLAN.md 4.2).
5. Update docs:
   - `AGENTS.md` — architecture section (module discovery is now
     import-tree; `flake.modules.<class>.<name>`; hosts import by name;
     home-manager class; `custom.*` still the option namespace)
   - `README.md` — Configuration namespace section stays; add a short
     "Architecture" pointer to this file
   - `docs/adding-a-host.md` — rewrite for the data-table flow
   - `PLAN.md` — mark completed phases, keep open items
6. Format: `nix run nixpkgs#nixpkgs-fmt -- .` and `just format-check`.

**Gate:**

```bash
nix flake check
nix build .#nixosConfigurations.cipher.config.system.build.toplevel
nix build .#nixosConfigurations.lorian.config.system.build.toplevel
nix build .#nixosConfigurations.brau1589.config.system.build.toplevel   # sops/ZFS/gaming path
just build-all
```

**Time:** 2–3 h.

---

### Phase 5 — Optional polish (2–4 h, can skip)

1. **Multi-class aspects** — one file configures a feature across classes:
   ```nix
   { inputs, ... }: {
     flake.modules.nixos.ssh = { services.openssh.enable = true; };
     flake.modules.homeManager.ssh = { programs.ssh = { enable = true; }; };
   }
   ```
   Natural candidates: `ssh`, `git`, `sops`, `gaming`.
2. **sops convention** — current design already fits: `base.nix` sets the
   global `defaultSopsFile = ../../secrets/secrets.yaml`; brau1589's override
   lives in its host aspect. No change needed; document it.
3. **Roles cleanup (PLAN.md 2.2)** — drop the `workstation` role in favor of
   the workstation profile, or promote the profile to an aspect.
4. **dendrix-style aspect split** — break `modules/home/gui.nix` into
   per-WM aspects (`hyprland`, `niri`, `sway`) once the class migration is
   proven stable.

**Time:** 2–4 h.

---

## 5. Verification & rollout

| Phase | Gate |
|---|---|
| 0 | `nix flake check` green; baseline recorded |
| 1 | 8 store paths == baseline; check green |
| 2 | 8 store paths == baseline; check green |
| 3b | 8 store paths == baseline; check green |
| 3c | cipher toplevel + HM generation clean; `dry-activate` shows no drift |
| 3d | 8 hosts eval; cipher + lorian build |
| 4 | `nix flake check`; cipher/lorian/brau1589 builds; `just build-all` |
| 5 | check green |

Store-path equivalence script (Phases 1–3b). **Run on a committed tree only**
(see §1 fact 5 — a dirty worktree silently invalidates every comparison):

```bash
#!/usr/bin/env bash
set -euo pipefail
nix flake metadata --json | jq -e '.dirtyRevision == null' >/dev/null \
  || { echo "worktree is dirty — commit or stash first"; exit 1; }
# untracked files are excluded from the git flake source (§1 fact 5) — a gate
# run against them would silently compare the OLD source
[ -z "$(git ls-files --others --exclude-standard)" ] \
  || { echo "untracked files are not in the flake source — git add/commit first"; exit 1; }
for h in amadeus brau1589 cipher heu lorian magi salieri wired; do
  p=$(nix eval --raw .#nixosConfigurations.$h.config.system.build.toplevel.outPath)
  grep -F "$p" /tmp/opencode/baseline.txt >/dev/null \
    && echo "OK  $h" || echo "DIFF $h $p"
done
```

Commit strategy: one commit per phase, branch `dendritic-migration`, PR per
phase (repo convention: branch + PR; no force-pushing main; no pre-commit
hooks configured; `.github/workflows/check.yml` runs `nix flake check`).
Main stays deployable after every merged phase.

## 6. Risks & mitigations

| Risk | Mitigation |
|---|---|
| `_class` mismatch — a NixOS-class registry module imported into the HM eval errors | Registry is class-keyed; Phase 3c flips classes wholesale; eval gate catches |
| `osConfig` availability depends on the pinned HM version | Verified on current master (`nixos/common.nix:30`); re-verify against flake.lock at 3c start |
| import-tree fork drift / load order assumptions | Pin `den/import-tree`; aspect wrappers use explicit `imports`, so load order is irrelevant |
| 8 hosts × full rebuild wall-time | Eval gates + 3 full builds only; store-path equality needs only the path, not the full build, if a remote/substituter has it |
| Hidden `inputs`/`self` uses in home beyond the 5 found | `rg` sweep at the start of 3c; wrap before building |
| Hidden `self.outPath` leaks outside home (found: `nh.nix`, Phase 1) | `rg 'outPath|self\b' modules hosts lib` sweep before each gate; commit-stability test (no-op commit) re-verifies per phase |
| New/untracked `.nix` files silently missing from the flake source (§1 fact 5) | Untracked-file check in the gate script; sanity-check via `nix eval .#modules` |
| Store-path gate noise from a dirty worktree (`-dirty` revision propagates through the whole closure) | Committed/stashed tree before every gate; `jq .dirtyRevision` sanity check in the gate script |
| Impermanence / persistence paths break on directory moves | Keep the `modules/home/` layout mirroring `home/cipher/` exactly through 3b |
| `flake.modules` registry + `_class` wrapping changes error messages | Accept; add a note in AGENTS.md |
| HM generation equivalence noise at 3c | Gate on behavior (`dry-activate`), not byte-identical store paths |

## 7. Timeline

| Phase | Time |
|---|---|
| 0 — Baseline & branch | 0.5–1 h |
| 1 — Registry skeleton | 2–4 h |
| 2 — Hosts & roles as aspects | 3–5 h (actual: 4 h incl. debug) |
| 3a — Wiring core | 1 h |
| 3b — Home aspects by name (wrapped) | 2–3 h |
| 3c — Class conversion / unwrap | 5–7 h |
| 3d — Per-user composition | 1–2 h |
| 4 — Delete legacy & docs | 2–3 h |
| 5 — Optional polish | 2–4 h |

**Total: ~18–29 h + build wall-time (3–5 focused days).** Phases 0–2 land the
system half with provable store-path equivalence; Phase 3 is the risky bulk;
Phases 4–5 are cleanup.
