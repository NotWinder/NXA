{
  pkgs,
  inputs',
  lib,
  ...
}: let
  # 1. Define Python dependencies from pyproject.toml
  pythonDependencies = with pkgs.python3Packages; [
    # Add Python dependencies discovered in pyproject.toml here
    # For example:
    pillow
    materialyoucolor
  ];

  # 2. Define system dependencies from the manual installation
  systemDependencies = with pkgs; [
    libnotify
    swappy
    psmisc
    grim
    dart-sass
    app2unit
    wl-clipboard
    slurp
    wl-screenrec
    glib
    libpulseaudio
    cliphist
    fuzzel
  ];

  # Caelestia scripts derivation with Python shebang fixes
  caelestia = pkgs.python3Packages.buildPythonApplication rec {
    pname = "caelestia";
    version = "0.0.1";
    pyproject = true;

    src = pkgs.fetchFromGitHub {
      owner = "caelestia-dots";
      repo = "cli";
      rev = "main";
      sha256 = "sha256-60GdtCjNtwRCHnIlRak3Hl6hJQPtINoS7g5bb5e60P4=";
    };

    nativeBuildInputs = with pkgs.python3Packages; [
      build
      installer
      hatchling
      hatch-vcs
    ];

    propagatedBuildInputs = pythonDependencies ++ systemDependencies;

    # 6. Install fish completions
    postInstall = ''
      mkdir -p $out/share/fish/vendor_completions.d
      cp completions/caelestia.fish $out/share/fish/vendor_completions.d/
    '';

    meta = with lib; {
      description = "Caelestia dotfiles scripts";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };

  # Wrap quickshell with Qt dependencies and required tools in PATH
  quickshell-wrapped =
    pkgs.runCommand "quickshell-wrapped" {
      nativeBuildInputs = [pkgs.makeWrapper];
    } ''
      mkdir -p $out/bin
      makeWrapper ${inputs'.quickshell.packages.default}/bin/qs $out/bin/qs \
        --prefix QT_PLUGIN_PATH : "${pkgs.kdePackages.qtbase}/${pkgs.kdePackages.qtbase.qtPluginPrefix}" \
        --prefix QT_PLUGIN_PATH : "${pkgs.kdePackages.qt5compat}/${pkgs.kdePackages.qtbase.qtPluginPrefix}" \
        --prefix QML2_IMPORT_PATH : "${pkgs.kdePackages.qt5compat}/${pkgs.kdePackages.qtbase.qtQmlPrefix}" \
        --prefix QML2_IMPORT_PATH : "${pkgs.kdePackages.qtdeclarative}/${pkgs.kdePackages.qtbase.qtQmlPrefix}" \
        --prefix PATH : ${lib.makeBinPath [pkgs.fd pkgs.coreutils]}
    '';
in {
  options.programs.quickshell = {
    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = quickshell-wrapped;
      description = "The wrapped quickshell package with Qt dependencies";
    };

    caelestia-scripts = lib.mkOption {
      type = lib.types.package;
      default = caelestia;
      description = "The caelestia scripts package";
    };
  };
}
