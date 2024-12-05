{
  config.modules.device = {
    type = "desktop";
    cpu.type = "intel";
    gpu.type = "hybrid-nv";
    monitors = ["eDP1"];
    hasBluetooth = true;
    hasSound = true;
    #hasTPM = true;
  };
}
