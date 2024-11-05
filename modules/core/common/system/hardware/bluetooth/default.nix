{
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Name = "winder";
        ControllerMode = "dual";
        FastConnectable = "true";
        Experimental = "true";
        MultiProfile = "multiple";
      };
      Policy = {
        AutoEnable = "true";
      };
    };
  };
}
