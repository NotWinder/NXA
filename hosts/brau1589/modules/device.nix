{
  config = {
    custom = {
      hardware = {
        nvidia = {
          enable = true;
          isHybrid = true;
          nvidiaOpen = true;
        };
      };
    };
    modules.device = {
      type = "desktop";
      cpu.type = "amd";
      gpu.type = "nvidia";
      monitors = ["HDMI-A-1"];
      hasBluetooth = true;
      hasSound = true;
      #hasTPM = true;
    };
  };
}
