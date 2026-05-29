{
  # monitor and control temparature
  services.thermald.enable = false;
  # Consider using auto-cpufreq instead
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "auto";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };
}
