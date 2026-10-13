# Colmena deployment for every host in nixosConfigurations:
#   colmena apply --on <host>      # from any machine with SSH access
#   colmena apply-local --sudo     # on the host itself
# Each node reuses its host's own module list and specialArgs, so a deploy
# builds the same system as `nixos-rebuild switch --flake .#<host>`. Hosts
# are reached by name (deployment.targetHost), e.g. over the tailnet.
{ self, inputs, lib, ... }:
let
  hosts = self.nixosConfigurations;
in
{
  flake.colmenaHive = inputs.colmena.lib.makeHive (
    {
      meta = {
        nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
        nodeNixpkgs = lib.mapAttrs (_: host: import inputs.nixpkgs { inherit (host.pkgs.stdenv.hostPlatform) system; }) hosts;
        nodeSpecialArgs = lib.mapAttrs (_: host: host._module.specialArgs) hosts;
      };
    }
    // lib.mapAttrs
      (name: host: {
        imports = host._module.args.modules;
        deployment = {
          targetHost = name;
          allowLocalDeployment = true;
        };
      })
      hosts
  );
}
