{ config, ... }: {
  location.provider = "geoclue2";

  services.geoclue2 = {
    # enable geoclue2 only if location.provider is geoclue2
    enable = config.location.provider == "geoclue2";

    # If a host switches location.provider to "manual", geoclue2 turns off and
    # gammastep needs location.latitude/longitude set instead.
    appConfig.gammastep = {
      isAllowed = true;
      isSystem = false;
    };
  };
}
