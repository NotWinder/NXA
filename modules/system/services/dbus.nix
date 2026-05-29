{pkgs, ...}: {
  services.dbus = {
    enable = true;
    packages = with pkgs; [dconf gcr udisks];

    # Use the faster dbus-broker instead of the classic dbus-daemon
    # this setting is experimental, but after testing I've come to realise it broke nothing
    implementation = "broker";
  };
}
