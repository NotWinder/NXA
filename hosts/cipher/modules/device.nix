{
  config = {
    custom = {
      hardware = {
        nvidia = {
          enable = true;
        };
      };
    };
    modules.device = {
      type = "desktop";
      cpu.type = "intel";
      monitors = ["HDMI-A-1"];
      hasBluetooth = true;
      hasSound = true;
      #hasTPM = true;
    };
  };
}
