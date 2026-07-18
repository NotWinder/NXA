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
    custom.device = {
      type = "desktop";
      cpu.type = "amd";
      gpu.type = "hybrid-nv";
      monitors = [ "HDMI-A-1" ];
      hasBluetooth = true;
      hasSound = true;
      #hasTPM = true;
    };
  };
}
