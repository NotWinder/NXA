{
  config,
  lib,
  ...
}: let
  inherit (config) custom;
  inherit (lib) mkIf;
  sys = custom.system;

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
        settings = {
          "github.com" = {
            hostname = "github.com";
            user = "git";
            identityFile = "${sys.homePath}/.ssh/id_ed25519";
            identitiesOnly = true;
          };
          comp-traefik1 = {
            hostname = "10.10.1.58";
            user = "traefik";
            proxyJump = "comp-proxmox";
          };
          comp-traefik2 = {
            hostname = "10.10.1.59";
            user = "traefik";
            proxyJump = "comp-proxmox";
          };
          comp-starhub-old = {
            hostname = "87.248.153.68";
            user = "root";
            port = 9011;
          };
          comp-proxmox-fallback = {
            hostname = "127.0.0.1";
            user = "root";
            port = 2222;
            proxyJump = "comp-starhub-old";
          };
          comp-piri = {
            hostname = "89.46.232.110";
            user = "root";
          };
          comp-ghahreman = {
            hostname = "78.157.40.195";
            user = "rasool";
            port = 2083;
          };
          comp-monitoring-elk1 = {
            hostname = "10.10.1.62";
            user = "elk";
            proxyJump = "comp-proxmox";
          };
          comp-proxy = {
            hostname = "10.10.1.69";
            user = "portal";
            proxyJump = "comp-proxmox";
          };
          comp-ci-shared-1 = {
            hostname = "10.10.1.220";
            user = "ci";
            proxyJump = "comp-proxmox";
          };
          comp-ci-shared-2 = {
            hostname = "10.10.1.221";
            user = "ci";
            proxyJump = "comp-proxmox";
          };
          comp-ci-build-1 = {
            hostname = "10.10.1.222";
            user = "ci";
            proxyJump = "comp-proxmox";
          };
          comp-ci-deploy-1 = {
            hostname = "10.10.1.223";
            user = "ci";
            proxyJump = "comp-proxmox";
          };
          comp-ai = {
            hostname = "10.10.1.35";
            user = "bert_service";
            proxyJump = "comp-proxmox";
          };
          comp-avid = {
            hostname = "10.10.1.116";
            user = "avid";
            proxyJump = "comp-proxmox";
          };
          comp-clickhouse = {
            hostname = "10.10.1.29";
            user = "clickhouse";
            proxyJump = "comp-proxmox";
          };
          comp-n8n = {
            hostname = "10.10.1.55";
            user = "n8n";
            proxyJump = "comp-proxmox";
          };
          comp-dns01 = {
            hostname = "10.10.1.60";
            user = "dns";
            proxyJump = "comp-proxmox";
          };
          comp-dns02 = {
            hostname = "10.10.1.54";
            user = "dns";
            proxyJump = "comp-proxmox";
          };
          comp-ganje = {
            hostname = "10.10.1.28";
            user = "ganje";
            proxyJump = "comp-proxmox";
          };
          comp-ganje-crawler = {
            hostname = "10.10.1.33";
            user = "root";
            proxyJump = "comp-proxmox";
          };
          comp-ganje-db = {
            hostname = "10.10.1.31";
            user = "root";
            proxyJump = "comp-proxmox";
          };
          comp-germany = {
            hostname = "65.109.179.188";
            user = "root";
          };
          comp-hiddify = {
            hostname = "65.109.211.222";
            user = "root";
          };
          comp-tools = {
            hostname = "10.10.1.43";
            user = "root";
            proxyJump = "comp-proxmox";
          };
          comp-mohammad = {
            hostname = "10.10.1.57";
            user = "mohammad";
            port = 2256;
            proxyJump = "comp-proxmox";
          };
          comp-monitor = {
            hostname = "10.10.1.27";
            user = "monitor";
            proxyJump = "comp-proxmox";
          };
          comp-nixos = {
            hostname = "10.10.1.44";
            user = "nixos";
            proxyJump = "comp-proxmox";
          };
          comp-park = {
            hostname = "178.131.105.131";
            user = "park";
            port = 2248;
          };
          comp-proxmox = {
            hostname = "85.133.224.202";
            user = "root";
          };
          comp-scrapyd-cluster-108 = {
            hostname = "10.10.1.34";
            user = "root";
            proxyJump = "comp-proxmox";
          };
          comp-scrapyd-cluster-109 = {
            hostname = "10.10.1.36";
            user = "root";
            proxyJump = "comp-proxmox";
          };
          comp-starbot = {
            hostname = "10.10.1.39";
            user = "starbot";
            proxyJump = "comp-proxmox";
          };
          comp-starhub = {
            hostname = "10.10.1.63";
            user = "starhub";
            proxyJump = "comp-proxmox";
          };
          comp-starhub-prod = {
            hostname = "45.156.185.29";
            user = "root";
            port = 9011;
          };
          comp-starbot-db = {
            hostname = "10.10.1.42";
            user = "root";
            proxyJump = "comp-proxmox";
          };
          comp-test = {
            hostname = "10.10.1.41";
            user = "test";
            proxyJump = "comp-proxmox";
          };
          comp-waf = {
            hostname = "10.10.1.4";
            user = "waf";
            proxyJump = "comp-proxmox";
          };
          comp-waf-manage = {
            hostname = "10.10.1.8";
            user = "root";
            port = 2256;
            proxyJump = "comp-proxmox";
          };
          comp-yektanet = {
            hostname = "10.10.1.40";
            user = "root";
            proxyJump = "comp-proxmox";
          };
          comp-zaris-manage = {
            hostname = "10.10.1.37";
            user = "zaris";
            proxyJump = "comp-proxmox";
          };
          comp-jarvis = {
            hostname = "10.10.1.52";
            user = "root";
            proxyJump = "comp-proxmox";
          };
          comp-tata = {
            hostname = "87.248.131.130";
            user = "root";
            port = 9011;
          };
          comp-rr-n8n-main-node = {
            hostname = "91.107.188.207";
            user = "root";
          };
          comp-rr-n8n-main-worker-1 = {
            hostname = "91.107.181.33";
            user = "root";
          };
          comp-rr-n8n-main-worker-2 = {
            hostname = "91.107.168.181";
            user = "root";
          };
          comp-digiarka = {
            hostname = "10.10.1.65";
            user = "digiarka";
            proxyJump = "comp-proxmox";
          };
          comp-tax = {
            hostname = "10.10.1.66";
            user = "tax";
            proxyJump = "comp-proxmox";
          };
          comp-monitoring-graphana = {
            hostname = "10.10.1.67";
            user = "graphana";
            proxyJump = "comp-proxmox";
          };
        };
      };
    };
  };
}
