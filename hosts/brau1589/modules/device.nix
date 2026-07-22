{
  config.custom = {
    device = {
      type = "desktop";
      cpu.type = "amd";
      gpu = {
        type = "hybrid-nv";
        nvidia.isHybrid = true;
        nvidia.nvidiaOpen = true;
      };
      monitors = [ "HDMI-A-1" ];
      hasBluetooth = true;
      hasSound = true;
      #hasTPM = true;
    };
  };
}
