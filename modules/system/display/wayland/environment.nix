{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
in {
  config = mkIf sys.video.enable {
    environment.etc."greetd/environments".text = ''
      ${lib.optionalString config.custom.programs.hyprland.enable "Hyprland"}
      fish
      zsh
    '';

    environment = {
      variables = {
        #_JAVA_AWT_WM_NONEREPARENTING = "1";
        #NIXOS_OZONE_WL = "1";
        #GDK_BACKEND = "wayland,x11";
        #ANKI_WAYLAND = "1";
        #MOZ_ENABLE_WAYLAND = "1";
        #XDG_SESSION_TYPE = "wayland";
        #SDL_VIDEODRIVER = "wayland";
        SDL_VIDEODRIVER = "wayland,x11";
        #CLUTTER_BACKEND = "wayland";
        XWAYLAND_NO_GLAMOR = "1";
      };
    };
  };
}
