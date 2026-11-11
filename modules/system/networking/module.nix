{ config
, pkgs
, ...
}: {
  ##  Networking

  imports = [
    ./ssh.nix
    ./netbird.nix
    ./tailscale.nix
  ];

  #networking.interfaces.enp5s0.wakeOnLan.enable = true;

  networking = {
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-l2tp
        networkmanager-openconnect
      ];
    };
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
    firewall.enable = false;
  };

  # FortiGate L2TP/IPsec needs IKEv1, which strongswan 6 builds without by default
  nixpkgs.overlays = [
    (final: prev: {
      strongswan = prev.strongswan.overrideAttrs (o: {
        configureFlags = o.configureFlags ++ [ "--enable-ikev1" ];
      });
    })
  ];

  # nm-l2tp starts strongswan's charon; Nix builds can't pass its checksum test
  environment.etc."strongswan.conf".text = ''
    libstrongswan {
      integrity_test = no
    }
  '';

  systemd.services.NetworkManager.environment = {
    STRONGSWAN_CONF = "/etc/strongswan.conf";
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    networkmanager-openvpn
    openvpn
    vpnc
  ];
}
