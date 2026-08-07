# NXA (Nix Automata)

NixOS flake configuration managing 8 hosts, inspired by [NotAShelf's nyx](https://github.com/NotAShelf/nyx).

## Hosts

| Host | Type | CPU | GPU | Role | Notes |
|------|------|-----|-----|------|-------|
| amadeus | desktop | Intel | Nvidia | graphical + workstation | |
| brau1589 | desktop | AMD | Nvidia | graphical + workstation | ZFS, gaming, [specs](#brau1589-specs) |
| cipher | desktop | Intel | — | graphical + workstation | gaming, arr-stack |
| heu | desktop | AMD | Intel | graphical + workstation | |
| magi | desktop | Intel | AMD | graphical + workstation | |
| salieri | desktop | AMD | AMD | graphical + workstation | |
| wired | desktop | Intel | Intel | graphical + workstation | btrfs |

### brau1589 specs

ASUS ROG Strix G513IE (G513IE_G513IE):

| Component | Spec |
|-----------|------|
| CPU | AMD Ryzen 7 4800H (Zen 2, 8 cores / 16 threads) + Vega (Renoir) iGPU |
| GPU | NVIDIA GeForce RTX 3050 Ti Mobile 4 GB (hybrid with the iGPU) |
| RAM | 32 GB DDR4 (30.7 GiB visible, ~1–2 GB reserved by the iGPU) |
| Storage | 2× Intel SSDPEKNU512GZ 512 GB NVMe |
| Display | 15.6" 1920×1080 @ 144 Hz (BOE LM156LF-2F01) + HDMI-A-1 |

## Quick reference

```bash
# Build all
nix build .#

# Build single host
nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel

# Check evaluation
nix flake check

# Format
nix run nixpkgs#nixpkgs-fmt -- <file.nix>
```

## Architecture

The flake is built on the [dendritic pattern](https://dendrix.denful.dev/Dendritic.html):
every file under `modules/` is a flake-parts module that registers a named
aspect in the `flake.modules.<class>.<name>` registry (`nixos` tree wrappers,
`roles`, `hosts`, `homeManager` aspects). `hosts/default.nix` is a data table
(roles, home aspects, system per host) whose entries are assembled from the
registry by `lib.mkNixosSystem`.

For the full migration history, rationale, and remaining work see
[docs/dendritic-migration.md](docs/dendritic-migration.md). Custom options live
under `config.custom.*`, declared in `modules/options/`.

## Using NXA as a flake input

Everything the flake exposes for consumption by other flakes lives under the
`modules` output — the aspect registry (`flake.modules.<class>.<name>`,
surfaced as `nxa.modules.<class>.<name>`), plus `lib` and
`nixosConfigurations`. Add the flake as an input and import the aspects you
want by name:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nxa.url = "github:notwinder/nxa";
  };

  outputs = { nixpkgs, nxa, ... }: {
    nixosConfigurations.foo = nixpkgs.lib.nixosSystem {
      modules = [
        nxa.modules.nixos.base        # config.custom.* option tree
        nxa.modules.nixos.graphical   # role: video/sound/bluetooth + tag
        nxa.modules.nixos.ssh         # multi-class feature (nixos side)
        nxa.modules.homeManager.git   # home-manager aspect
        # ...
      ];
    };
  };
}
```

The registry is strictly two levels (`<class>.<name>`). Every aspect is tagged
with its class (`_class`/`_file` by the registry's `apply`), so importing a
`nixos` aspect into a home-manager eval (or vice versa) fails loudly. Most
aspects gate on `config.custom.*` (NixOS) or `osConfig.custom.*`
(home-manager), so they compose cleanly with each other.

### `modules.nixos.*` — NixOS aspects

| Aspect | Description |
|--------|-------------|
| `base` | `config.custom.*` option tree (`modules/options/`) |
| `system` | System-level modules (`modules/system/`), incl. the home-manager wiring |
| `hardware` | Hardware modules (`modules/hardware/`): CPU, GPU, sound, video, bluetooth |
| `nix` | Nix configuration (`modules/nix/`) |
| `virt` | Virtualization (`modules/virt/`): docker, qemu, waydroid, distrobox |
| `profiles` | Composables (`modules/profiles/`): firejail, tor, workstation |
| `sops` | Universal SOPS/age wiring (global `defaultSopsFile`, key path); no home side |
| `graphical` | Role: `graphical` tag; video/sound/bluetooth enabled (mkDefault) |
| `headless` | Role: `headless` tag; video/sound/bluetooth disabled (mkDefault) |
| `server` | Role: `server` tag |
| `ssh` | Feature (nixos side): sops secret provisioning + SSH key setup service |
| `gaming` | Feature (nixos side): enables the `custom.usrEnv.programs.gaming` umbrella |
| `amadeus` … `wired` | Per-host aspects — registered but **not consumed**; hosts compose `hosts/<name>/host.nix` by path from the data table |

### `modules.homeManager.*` — home-manager aspects

| Aspect | Description |
|--------|-------------|
| `base` | Username/home/stateVersion, sd-switch, shared HM defaults |
| `cli` | CLI tooling; composes the `git` aspect |
| `git` | Universal git config |
| `gui` | Desktop composition: WM aspects + closure-captured aspects below |
| `themes` | Theming (GTK, Qt, colorscheme) |
| `misc` | Misc config; composes `xdg` |
| `hyprland` / `niri` / `sway` | Per-WM aspects, gated on `osConfig.custom.programs.<wm>.enable` |
| `dankMaterial` | DankMaterialShell (dms) shell, quickshell layer rules; composes `gui` |
| `zen` | Zen browser beta home module; composes `gui` |
| `foot` | Foot terminal (nyxexprs `foot-transparent`); composes `gui` |
| `randomize` | `wallpaper-random` script (hyprpaper/swww via winpaper); composes `gui` |
| `hyprlock` | Hyprlock config (winpaper wallpaper); composes `gui` |
| `hyprpaper` | Hyprpaper service config; composes `gui` |
| `xdg` | XDG dirs/mime/user-dirs config; composes `misc` |
| `ssh` | Feature (home side): ssh config / host aliases |
| `gaming` | Feature (home side): gaming programs, gated on the umbrella option |
| `amadeus` … `wired` | Per-user aspects (`modules/home/users/`) composing the shared ones by name |

The closure-captured aspects close over flake-parts args (`inputs`,
`inputs'`, `self`) instead of relying on `extraSpecialArgs`; the `ssh`/`gaming`
aspects are multi-class features registered from single files
(`modules/ssh.nix`, `modules/gaming.nix`) — their `nixos` and `homeManager`
names overlap deliberately, so a host selects both sides with one
`features = [ "ssh" ]` entry.

### `lib` — extended library

`lib` is nixpkgs' library extended with:

- `mkNixosSystem`, `mkSystem` — host system builders
- `mkGraphicalService`, `mkHyprlandService`, `hardenService` — systemd helpers
- `primaryMonitor`, `isx86Linux` — hardware helpers
- `serializeTheme`, `compileSCSS`, `xdgTemplate` — theme/build helpers

### `nixosConfigurations.*`

All 8 hosts (see the [Hosts](#hosts) table). Build one with
`nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel`.

## Adding a new host

See [docs/adding-a-host.md](docs/adding-a-host.md).

## Secrets

SOPS-managed via age keys. See `.sops.yaml` for key configuration.

## Configuration namespace

All custom options live under `config.custom.*`:

- `custom.device.*` — hardware description (CPU, GPU, monitors)
- `custom.system.*` — system-level options (boot, services, users)
- `custom.usrEnv.*` — user environment (programs, GUI, desktop)
- `custom.style.*` — theming (GTK, Qt, colorscheme)
- `custom.profiles.*` — composable feature sets (workstation, gaming)
- `custom.programs.*` — per-program enable flags (hyprland, niri, etc.)
- `custom.hardware.*` — hardware driver options (nvidia)
- `custom.services.*` — service options (greetd)
