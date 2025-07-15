{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./scripts

    ./packages.nix # Caelestia scripts and quickshell wrapper derivations
    ./config.nix # Configuration files and environment setup
  ];

  # Main packages
  home.packages = with pkgs; [
    config.programs.quickshell.finalPackage # Our wrapped quickshell
    config.programs.quickshell.caelestia-scripts
    # Qt dependencies
    kdePackages.qt5compat
    kdePackages.qtdeclarative

    kdePackages.plasma-integration
    librsvg

    # Runtime dependencies
    inotify-tools
    hyprpaper
    imagemagick
    wl-clipboard
    fuzzel
    socat
    foot
    jq
    python3
    python3Packages.materialyoucolor
    grim
    wayfreeze
    wl-screenrec
    xdg-user-dirs

    # Additional dependencies
    lm_sensors
    curl
    material-symbols
    nerd-fonts.jetbrains-mono
    ibm-plex
    fd
    python3Packages.pyaudio
    python3Packages.numpy
    cava
    networkmanager
    bluez
    ddcutil
    brightnessctl
  ];
}
