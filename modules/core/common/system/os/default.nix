{
  imports = [
   #./activation # activation system for nixos-rebuild
    ./boot # boot and bootloader configurations
    ./display # display protocol (wayland/xorg)
   #./environment # system environment e.g. locale, timezone, packages
    ./fs # filesystem support options
    ./networking # network configuration & tcp optimizations
    ./programs # general programs
    ./services # gemeral services
   #./theme # theming for desktop toolkits e.g. gtk, qt
    ./users # per user configurations
  ];
}
