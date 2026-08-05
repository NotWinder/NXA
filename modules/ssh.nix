# Multi-class `ssh` feature (Phase 5 item 1): selecting `features = [ "ssh" ]`
# on a host provides both the nixos side (sops secret provisioning + key
# copy service) and the homeManager side (ssh config / host aliases). The
# feature selection replaces the old `custom.system.enableSshSecrets` gate.
{ ... }:
{
  flake.modules.nixos.ssh = { config, ... }:
    let
      inherit (config) custom;
      sys = custom.system;
    in
    {
      config = {
        sops = {
          secrets = {
            "ssh_private_key" = {
              mode = "0600";
              owner = "${sys.mainUser}";
              neededForUsers = true;
            };
            "ssh_public_key" = {
              mode = "0644";
              owner = "${sys.mainUser}";
              neededForUsers = true;
            };
          };
        };

        # Copy the secret to the actual SSH location
        systemd.services.setup-ssh-key = {
          description = "Setup SSH private key from secrets";
          wantedBy = [ "multi-user.target" ];
          after = [ "sops-nix.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          script = ''
            mkdir -p ${sys.homePath}/.ssh

            # Copy private key
            cp ${config.sops.secrets.ssh_private_key.path} ${sys.homePath}/.ssh/id_ed25519
            chmod 600 ${sys.homePath}/.ssh/id_ed25519
            chown ${sys.mainUser}: ${sys.homePath}/.ssh/id_ed25519

            # Copy public key
            cp ${config.sops.secrets.ssh_public_key.path} ${sys.homePath}/.ssh/id_ed25519.pub
            chmod 644 ${sys.homePath}/.ssh/id_ed25519.pub
            chown ${sys.mainUser}: ${sys.homePath}/.ssh/id_ed25519.pub
          '';
        };
      };
    };

  flake.modules.homeManager.ssh = {
    imports = [ ./_lib/home/ssh.nix ];
  };
}
