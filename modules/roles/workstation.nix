{ ... }: {
  flake.modules.roles.workstation = {
    imports = [ ../_lib/roles/workstation/system/module.nix ];
  };
}
