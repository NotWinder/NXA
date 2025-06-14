{
  config,
  pkgs,
  ...
}: {
  ##  Networking

  imports = [
    ./ssh.nix
  ];

  networking = {
    networkmanager.enable = true;
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
    firewall.enable = false;
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];
}
