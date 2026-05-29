{
  # despite being under logind, this has nothing to do with login
  # it's about power management
  services.logind = {
    settings.Login = {
      HandleLidSwitchExternalPower = "lock";
      HandleLidSwitch = "suspend-then-hibernate";
      HandlePowerKey = "suspend-then-hibernate";
      HibernateDelaySec = 3600;
    };
  };
}
