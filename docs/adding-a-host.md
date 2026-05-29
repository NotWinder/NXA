# Adding a New Host

This guide walks through adding a new NixOS host to this flake.

## Step 1: Create the host directory

```bash
mkdir -p hosts/<hostname>/modules
```

## Step 2: Create `hosts/<hostname>/host.nix`

```nix
{
  imports = [
    ./fs.nix
    ./modules
  ];

  config = {
    system.stateVersion = "25.05";
  };
}
```

## Step 3: Create filesystem config

If using **disko** (btrfs with automatic partitioning):

```nix
{
  imports = [../../modules/system/disko-btrfs.nix];
}
```

If using **manual filesystem config**, create `hosts/<hostname>/fs.nix` with your mount points.

## Step 4: Create module files under `hosts/<hostname>/modules/`

At minimum, create a `default.nix` that imports these four files:

```nix
# hosts/<hostname>/modules/default.nix
{
  imports = [
    ./device.nix
    ./profiles.nix
    ./system.nix
    ./usrEnv.nix
  ];
}
```

### 4a. `device.nix` — Hardware description

```nix
{
  config.custom.device = {
    cpu.type = "intel";       # or "amd", "vm-intel", "vm-amd"
    gpu.type = "intel";       # or "amd", "nvidia", "hybrid-nv", "hybrid-amd"
    type = "desktop";         # or "server", "vm"
    monitors = ["HDMI-A-1"];  # list of connected displays
    hasBluetooth = true;
    hasSound = true;
  };
}
```

### 4b. `profiles.nix` — Enable profiles

```nix
{
  config.custom.profiles = {
    workstation.enable = true;
    gaming.enable = false;  # optional
  };
}
```

### 4c. `system.nix` — System-level options

```nix
{pkgs, ...}: let
  mainUser = "winder";
in {
  config.custom.system = {
    inherit mainUser;
    users = [mainUser];
    homePath = "/home/${mainUser}";
    defaultUserShell = pkgs.fish;

    boot = {
      enableKernelTweaks = true;
      isUEFI = true;
      loadRecommendedModules = true;
      loader = "grub";
      secureBoot = false;
      tmpOnTmpfs = false;
    };

    services = {
      # enable services here, e.g.:
      # sing-box.enable = true;
    };

    fs.enabledFilesystems = ["btrfs" "vfat" "ntfs" "exfat"];
    bluetooth.enable = true;
    printing.enable = false;
    sound.enable = true;
    video.enable = true;
    virtualisation = { enable = true; qemu.enable = true; docker.enable = true; };
  };
}
```

### 4d. `usrEnv.nix` — User environment options

```nix
{
  config.custom.usrEnv = {
    useHomeManager = true;

    programs = {
      cli.enable = true;
      gui.enable = true;   # set false for headless/servers

      browsers = ["librewolf"];
      terminals = ["alacritty" "ghostty"];
      default = { terminal = "alacritty"; browser = "librewolf"; };
      launchers = ["rofi" "tofi"];
    };
  };
}
```

To enable a compositor, add:

```nix
config.custom.programs.hyprland.enable = true;  # or .niri, .sway
```

## Step 5: Register the host in `hosts/default.nix`

Add an entry following the existing pattern:

```nix
<hostname> = mkNixosSystem {
  inherit withSystem;
  hostname = "<hostname>";
  system = "x86_64-linux";
  modules = mkModulesFor "<hostname>" {
    roles = [graphical workstation];  # or [headless server] for servers
    extraModules = [sops-nix stylix hm];  # skip stylix for headless
  };
};
```

## Step 6: Set up secrets (optional)

If the host needs secrets:

1. Add an age key for the host in `.sops.yaml`
2. Regenerate `secrets.yaml` with the new key
3. Add `enableSshSecrets = true;` in the host's `system.nix` if SSH keys are needed

## Step 7: Build and deploy

```bash
# Build the system closure
nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel

# Deploy (on the target machine)
sudo nixos-rebuild switch --flake .#<hostname>
```

For disko-based installs (first-time setup):

```bash
sudo nix run github:nix-community/disko -- --mode disko ./hosts/<hostname>/fs.nix
sudo nixos-install --flake .#<hostname>
```
