{
  config = {
    custom = {
      hardware = {
        nvidia = {
          enable = true;
        };
      };
    };
    custom.device = {
      type = "desktop";
      cpu.type = "intel";
      gpu.type = "nvidia";
      monitors = [ "HDMI-A-1" ];
      hasBluetooth = true;
      hasSound = true;
      #hasTPM = true;
    };
  };
}
