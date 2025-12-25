{
  config,
  lib,
  ...
}: let
  inherit (config) modules;
  inherit (lib) mkIf;
  sys = modules.system;

  # Check if the SSH secrets exist
  enableSshSecrets = sys.enableSshSecrets;
in {
  config = mkIf enableSshSecrets {
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
      wantedBy = ["multi-user.target"];
      after = ["sops-nix.service"];
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
        matchBlocks = {
          waf = {
            hostname = "85.133.217.107";
            user = "waf";
          };

          db-ganje = {
            hostname = "10.10.1.31";
            user = "root";
            proxyJump = "waf";
          };
          starbot = {
            hostname = "10.10.1.39";
            user = "starbot";
            proxyJump = "waf";
          };
          park = {
            hostname = "178.131.134.191";
            user = "park";
            port = 2248;
          };
          ganje = {
            hostname = "10.10.1.28";
            user = "ganje";
            proxyJump = "waf";
          };
        };
      };
    };
  };
}
