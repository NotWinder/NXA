{
  services.slskd = {
    enable = true;
    openFirewall = true;
    domain = "127.0.0.1";
    environmentFile = /home/winder/env;
    settings = {
      shares.directories = ["/home/winder/Media/Music/primary/Music/library"];
      directories = {
        downloads = "/home/winder/Media/Music/primary/Music/not-picarded";
        incomplete = "/var/lib/slskd/incomplete";
      };
    };
  };
}
