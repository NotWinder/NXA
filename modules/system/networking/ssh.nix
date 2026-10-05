{
  services.openssh = {
    enable = true;
    openFirewall = true; # the ssh port(s) should be automatically passed to the firewall's allowedTCPports
    ports = [ 22 ]; # the port(s) openssh daemon should listen on
  };
}
