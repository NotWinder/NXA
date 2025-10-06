{config, ...}: let
  inherit (config) modules;
  sys = modules.system;
in {
  config = {
    sops = {
      secrets = {
        "ssh_private_key" = {
          mode = "0600";
          owner = "${sys.mainUser}";
        };
        "ssh_public_key" = {
          mode = "0644";
          owner = "${sys.mainUser}";
        };
      };
    };

    # Copy the secret to the actual SSH location
    systemd.services.setup-ssh-key = {
      description = "Setup SSH private key from secrets";
      wantedBy = ["multi-user.target"];
      after = ["sops-nix.service"];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        mkdir -p ${sys.homePath}/.ssh
        cp ${config.sops.secrets.ssh_private_key.path} ${sys.homePath}/.ssh/id_ed25519
        chmod 600 ${sys.homePath}/.ssh/id_ed25519
        chown ${sys.mainUser}: ${sys.homePath}/.ssh/id_ed25519

        # Also copy public key if you have it
         cp ${config.sops.secrets.ssh_public_key.path} ${sys.homePath}/.ssh/id_ed25519.pub
         chmod 644 ${sys.homePath}/.ssh/id_ed25519.pub
         chown ${sys.mainUser}: ${sys.homePath}/.ssh/id_ed25519.pub
      '';
    };

    hm = {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          "github.com" = {
            hostname = "github.com";
            user = "git";
            identityFile = "${sys.homePath}/.ssh/id_ed25519";
            identitiesOnly = true;
          };
        };
      };
    };
  };
}
