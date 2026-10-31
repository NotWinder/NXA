{
  # DankMaterialShell compositor integration. The shell itself (packages and
  # the dms user service) comes from the NixOS side in
  # modules/system/display/wayland/dms.nix; this aspect only adds binds and
  # layer rules, and is inert unless custom.programs.dms.enable is set.
  flake.modules.homeManager.dankMaterial = { config, lib, osConfig, pkgs, ... }:
    let
      inherit (lib) mkIf mkForce;

      dms = osConfig.custom.programs.dms.enable;
    in
    {
      programs.niri = mkIf (osConfig.custom.programs.niri.enable && dms) {
        settings = {
          layer-rules = [
            {
              matches = [{ namespace = "^quickshell$"; }];
              place-within-backdrop = true;
            }
          ];

          binds = with config.lib.niri.actions; let
            sh = spawn "sh" "-c";
          in
          {
            "Mod+D".action = sh "dms ipc call spotlight toggle";
            # Replaces the swaylock bind from the niri aspect; Ctrl+L is left
            # to terminals and browsers.
            "Super+Alt+L".action = mkForce (sh "dms ipc call lock lock");
            "Mod+Escape" = {
              allow-when-locked = true;
              action = sh "dms ipc call powermenu toggle";
            };
          };
        };
      };

      # niri-flake can't emit `include`, so (like DMS's own HM module) move its
      # generated file to hm.kdl and write config.kdl as a list of includes, with
      # the DMS-generated files last so they override. optional=true keeps niri
      # starting before DMS has written them.
      xdg.configFile = lib.mkMerge [
        (mkIf (osConfig.custom.programs.niri.enable && dms) {
          niri-config.target = mkForce "niri/hm.kdl";
          niri-config-dms = {
            target = "niri/config.kdl";
            text = lib.concatMapStringsSep "\n" (f: ''include optional=true "${f}.kdl"'')
              ([ "hm" ] ++ map (f: "dms/${f}") [
                "alttab"
                "binds"
                "colors"
                "cursor"
                "layout"
                "outputs"
                "windowrules"
                "wpblur"
              ]);
          };
        })
        (mkIf dms {
          # KDE apps (Dolphin) read colours from kdeglobals, not the qt6ct
          # palette. DMS's generated scheme is a complete kdeglobals-format
          # file, so link to it.
          kdeglobals.source = mkForce (config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/.local/share/color-schemes/DankMatugen.colors");
        })
      ];

      # Let DMS (matugen) theme GTK and Qt. DMS owns gtk-{3,4}.0/gtk.css (its
      # "Apply GTK colors" refuses user-managed symlinks) and the qt6ct palette,
      # so we only provide adw-gtk3 and point Qt at qtengine (what this DMS targets;
      # qt6ct ignores its KDE colour scheme and left Dolphin light). GTK_THEME is dropped
      # in themes/gtk.nix because it would pin the theme and break DMS's
      # light/dark switching.
      gtk = mkIf dms {
        theme = mkForce {
          name = "adw-gtk3";
          package = pkgs.adw-gtk3;
        };
        gtk4.theme = mkForce null;
      };
      qt.platformTheme.name = mkIf dms (mkForce "qtengine");
      home.packages = mkIf dms [ pkgs.qtengine ];
      # DMS writes the terminal colours itself (alacritty/dank-theme.toml,
      # ghostty/themes/dankcolors) and live-reloads them; we only reference them.
      programs.alacritty.settings.general.import = mkIf dms [ "${config.xdg.configHome}/alacritty/dank-theme.toml" ];
      programs.ghostty.settings.theme = mkIf dms "dankcolors";

      # Zen: DMS writes ~/.config/dms/zen.css; load it from userChrome.css.
      # Profile dir is Zen's own (not declared via the HM profiles module, which
      # would take over profiles.ini). ponytail: hardcoded profile dir, switch to
      # programs.zen-browser.profiles if more than one profile needs theming.
      # Zen reads userChrome once at startup, so restart it after a theme change.
      home.file = mkIf (dms && builtins.elem "zen-beta" osConfig.custom.usrEnv.programs.browsers) (
        let profile = "${config.home.homeDirectory}/.zen/t7ot97ix.Default Profile"; in {
          "${profile}/chrome/userChrome.css".text = ''
            @import url("file://${config.xdg.configHome}/dms/zen.css");
          '';
          "${profile}/user.js".text = ''
            user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          '';
        }
      );

      wayland.windowManager.hyprland = mkIf (osConfig.custom.programs.hyprland.enable && dms) {
        settings = {
          # Hyprland's systemd integration is off here, so graphical-session.target
          # may never activate; start the dms unit explicitly.
          exec-once = [ "systemctl --user start dms.service" ];
          bind = [
            "$MOD, D, exec, dms ipc call spotlight toggle"
            "$MOD ALT, L, exec, dms ipc call lock lock"
            "$MOD, Escape, exec, dms ipc call powermenu toggle"
          ];
        };
      };
    };
}
