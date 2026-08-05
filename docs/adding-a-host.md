# Adding a New Host

This guide walks through adding a new NixOS host to this flake. The flake uses
the dendritic pattern: hosts are data-table entries in `hosts/default.nix`,
composed from named aspects in the `flake.modules.<class>.<name>` registry.

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

At minimum, create a `default.nix` that imports your host-specific option files
(`device.nix`, `profiles.nix`, `system.nix`, `usrEnv.nix`). These set the
`config.custom.*` options; see the existing hosts and `modules/options/` for the
full option tree.

## Step 5: Register the host in `hosts/default.nix`

Add one row to the `hosts` data table:

```nix
<hostname> = {
  roles = [ "graphical" ];                   # or [ "headless" "server" ] for servers
  home = [ "<hostname>" ];                   # per-user home-manager aspect (see step 6)
  system = "x86_64-linux";
};
```

The host is assembled by `mkModulesFor` from the registry: nixos tree aspects
(base/system/hardware/nix/virt/profiles) + role aspects + sops-nix + home-manager
+ your per-host home aspects — so no `mkNixosSystem` block is needed here.
Enable the `workstation` profile (browsers, terminals, media, firejail locking,
etc.) via `custom.profiles.workstation.enable = true` in
`hosts/<hostname>/modules/profiles.nix` if the host is a desktop.

## Step 6: Add a per-user home-manager aspect

Create `modules/home/users/<hostname>.nix`, composing the shared aspects by
name (select on `Config` args — see existing users for the wiring):

```nix
{ self, ... }: {
  flake.modules.homeManager.<hostname> = {
    imports = [
      self.modules.homeManager.base
      self.modules.homeManager.cli
      # add gui/themes/misc for graphical hosts
    ];
  };
}
```

then select it via the `home = [ "<hostname>" ]` field in the host's data-table
row. Shared aspects are defined in `modules/home.nix` under
`flake.modules.homeManager` (`base`, `cli`, `gui`, `themes`, `misc`); per-user
aspects live in `modules/home/users/`. Headless/servers typically only compose
`base` and `cli`.

## Step 7: Set up secrets (optional)

If the host needs secrets:

1. Add an age key for the host in `.sops.yaml`
2. Regenerate `secrets.yaml` with the new key
3. Add the host's secret settings in its `system.nix` if SSH keys etc. are needed

## Step 8: Build and deploy

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