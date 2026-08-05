# Closure-captured home-manager aspect for the foot terminal (Phase 3c step 4).
#
# Loaded into the flake-parts module space; closes over `inputs'` so the
# nyxexprs `foot-transparent` package stays available without any
# `extraSpecialArgs` plumbing. Only the color presets remain in the `_lib`
# tree (referenced by path below); the module body lives here.
{ inputs', ... }: {
  flake.modules.homeManager.foot = { pkgs, lib, osConfig, ... }:
    let
      inherit (builtins) elem;
      inherit (lib) mkIf;
      inherit (osConfig.custom.style.colorScheme) slug colors;
      prg = osConfig.custom.usrEnv.programs;
    in
    {
      config = mkIf (elem "foot" prg.terminals) {
        home.packages = with pkgs; [
          libsixel # for displaying images
        ];
        programs.foot = {
          enable = true;
          package = inputs'.nyxexprs.packages.foot-transparent;
          server.enable = false;
          settings = {
            main = {
              # window settings
              app-id = "foot";
              title = "foot";
              locked-title = "no";
              term = "xterm-256color";
              pad = "16x16 center";
              shell = "zsh";

              # notifications
              notify = "notify-send -a \${app-id} -i \${app-id} \${title} \${body}";
              selection-target = "clipboard";

              # font and font rendering
              dpi-aware = false; # this looks more readable on a laptop, but it's unreasonably large
              font = "Iosevka Nerd Font:size=14";
              font-bold = "Iosevka Nerd Font:size=14";
              vertical-letter-offset = "-0.90";
            };

            scrollback = {
              lines = 10000;
              multiplier = 3;
            };

            tweak = {
              font-monospace-warn = "no"; # reduces startup time
              sixel = "yes";
            };

            cursor = {
              style = "beam";
              beam-thickness = 2;
            };

            mouse = {
              hide-when-typing = "yes";
            };

            url = {
              launch = "xdg-open \${url}";
              label-letters = "sadfjklewcmpgh";
              osc8-underline = "url-mode";
              protocols = "http, https, ftp, ftps, file";
              uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+=\"'()[]";
            };

            colors = import ../_lib/home/cipher/gui/terminals/foot/presets/${slug}/colors.nix { inherit colors; } // { alpha = "0.85"; };
          };
        };
      };
    };
}
