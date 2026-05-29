{pkgs, ...}: {
  config = {
    services = {
      udev.packages = [pkgs.gnome-settings-daemon];
      gnome = {
        # Whether to enable gnome-keyring. This is usually necessary for storing
        # secrets for programming applications such as VSCode or GitHub desktop.
        # It is also optional to use google/nextcloud calendar.
        gnome-settings-daemon.enable = true;
        gnome-keyring.enable = true;
      };
    };
  };
}
