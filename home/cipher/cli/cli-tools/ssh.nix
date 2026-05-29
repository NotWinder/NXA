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
          comp-proxmox = {
            hostname = "85.133.217.106";
            user = "root";
          };

          comp-waf = {
            hostname = "85.133.217.107";
            user = "waf";
          };

          comp-ganje = {
            hostname = "10.10.1.28";
            user = "ganje";
            proxyJump = "comp-waf";
          };

          comp-clickhouse = {
            hostname = "10.10.1.29";
            user = "clickhouse";
            proxyJump = "comp-waf";
          };

          comp-ganje-db = {
            hostname = "10.10.1.31";
            user = "root";
            proxyJump = "comp-waf";
          };

          comp-ganje-crawler = {
            hostname = "10.10.1.33";
            user = "root";
            proxyJump = "comp-waf";
          };

          comp-scrapyd-cluster-108 = {
            hostname = "10.10.1.34";
            user = "root";
            proxyJump = "comp-waf";
          };

          comp-scrapyd-cluster-109 = {
            hostname = "10.10.1.36";
            user = "root";
            proxyJump = "comp-waf";
          };

          comp-ai = {
            hostname = "10.10.1.35";
            user = "bert_service";
            proxyJump = "comp-waf";
          };

          comp-starbot = {
            hostname = "10.10.1.39";
            user = "starbot";
            proxyJump = "comp-waf";
          };

          comp-starbot2 = {
            hostname = "10.10.1.55";
            user = "starbot";
            proxyJump = "comp-waf";
          };

          comp-starbot-db = {
            hostname = "10.10.1.42";
            user = "root";
            proxyJump = "comp-waf";
          };

          comp-infra = {
            hostname = "10.10.1.43";
            user = "root";
            proxyJump = "comp-waf";
          };

          comp-yektanet = {
            hostname = "85.133.217.115";
            user = "root";
          };

          comp-mohammad = {
            hostname = "85.133.217.109";
            user = "mohammad";
            port = 2256;
          };

          comp-avid = {
            hostname = "85.133.217.114";
            user = "avid";
          };

          comp-waf-manage = {
            hostname = "85.133.217.110";
            user = "root";
            port = 2256;
          };

          comp-zaris-manage = {
            hostname = "10.10.1.37";
            user = "zaris";
            proxyJump = "comp-waf";
          };

          comp-monitor = {
            hostname = "10.10.1.27";
            user = "monitor";
            proxyJump = "comp-waf";
          };

          comp-nixos = {
            hostname = "10.10.1.44";
            user = "nixos";
            proxyJump = "comp-waf";
          };

          comp-nexus = {
            hostname = "10.10.1.55";
            user = "waf";
            proxyJump = "comp-waf";
          };

          comp-test = {
            hostname = "10.10.1.41";
            user = "test";
            proxyJump = "comp-waf";
          };

          comp-germany = {
            hostname = "65.109.179.188";
            user = "root";
          };

          comp-hiddify = {
            hostname = "65.109.211.222";
            user = "root";
          };

          comp-park = {
            hostname = "178.131.134.191";
            user = "park";
            port = 2248;
          };
        };
      };
    };
  };
}
