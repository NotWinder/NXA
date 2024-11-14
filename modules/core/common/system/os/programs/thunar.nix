{pkgs, ...}: {
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      kdePackages.ark
      ffmpegthumbnailer
      libgsf
      xfce.tumbler
    ];
  };

  services.tumbler.enable = true;
}
