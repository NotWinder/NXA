{
  services.bind = {
    enable = true;
    directory = "/var/cache/bind";
    cacheNetworks = [ "192.168.0.0/24" ];
    blockedNetworks = [ ];
    forwarders = [ "8.8.8.8" "8.8.4.4" ];
    extraOptions = ''
      dnssec-validation auto;
      recursion yes;
    '';
    extraConfig = ''
      logging {
          category default { default_syslog; default_debug; };

          channel an_example_channel {
              file "example.log" versions 3 size 20m suffix increment;
              print-time yes;
              print-category yes;
          };
      };
    '';
    zones = {
      "example.com" = {
        master = true;
        file = "/etc/bind/db.example.com";
      };
      "1.168.192.in-addr.arpa" = {
        master = true;
        file = "/etc/bind/db.192";
      };
    };
  };
}
