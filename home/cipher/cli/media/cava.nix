{
  config.hm = {
    programs.cava = {
      enable = true;
      settings = {
        general.framerate = 60;
        input.method = "pulse";
        smoothing.noise_reduction = 88;
      };
    };
  };
}
