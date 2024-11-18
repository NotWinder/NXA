{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  prg = env.programs;
in {
  config = mkIf prg.gaming.minecraft.enable {
    home.packages = let
      # java packages that are needed by various versions or modpacks
      # different distributions of java may yield different results in performance
      # and thus I recommend testing them one by one to remove those that you do not
      # need in your configuration
      jdks = with pkgs; [
        # Java 8
        temurin-jre-bin-8
        zulu8

        # Java 11
        temurin-jre-bin-11

        # Java 17
        temurin-jre-bin-17

        # Latest
        temurin-jre-bin
        zulu
        graalvm-ce
      ];

      additionalPrograms = with pkgs; [
        gamemode
        mangohud
        jprofiler
      ];

      glfw =
        if osConfig.meta.isWayland
        then pkgs.glfw-wayland-minecraft
        else pkgs.glfw;
    in [
      # the successor to polyMC, which is now mostly abandoned
      (pkgs.prismlauncher.override {
        # get java versions required by various minecraft versions
        # "write once run everywhere" my ass
        inherit jdks;

        # wrap Prismlauncher with programs in may need for workarounds
        # or client features
        inherit additionalPrograms;

        # wrap Prismlauncher with the nixpkgs glfw, or optionally the wayland patched
        # version of glfw while we're on Wayland.
        inherit glfw;
      })
    ];
  };
}
