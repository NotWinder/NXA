# NXA (Nix Automata)

NixOS flake configuration managing 8 hosts, inspired by [NotAShelf's nyx](https://github.com/NotAShelf/nyx).

## Hosts

| Host | Type | CPU | GPU | Role | Notes |
|------|------|-----|-----|------|-------|
| amadeus | desktop | Intel | Nvidia | graphical + workstation | |
| brau1589 | desktop | AMD | Nvidia | graphical + workstation | ZFS, gaming |
| cipher | desktop | Intel | — | graphical + workstation | gaming, arr-stack |
| heu | desktop | AMD | Intel | graphical + workstation | |
| lorian | server | Intel | — | headless + server | ext4, no GUI |
| magi | desktop | Intel | AMD | graphical + workstation | |
| salieri | desktop | AMD | AMD | graphical + workstation | |
| wired | desktop | Intel | Intel | graphical + workstation | btrfs |

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

## Adding a new host

See [docs/adding-a-host.md](docs/adding-a-host.md).

## Secrets

SOPS-managed via age keys. See `secrets/.sops.yaml` for key configuration.

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
