{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf optionals;
  inherit (osConfig) modules meta;

  env = modules.usrEnv;
  rofiPackage = with pkgs;
    if meta.isWayland
    then rofi-wayland
    else rofi;
in {
  config = mkIf env.programs.launchers.rofi.enable {
    programs.rofi = {
      enable = true;
      package = rofiPackage.override {
        plugins =
          [
            pkgs.rofi-rbw
          ]
          ++ optionals meta.isWayland (with pkgs; [
            rofi-rbw-wayland
            rofi-emoji-wayland
          ]);
      };
      extraConfig = {
        modi = "drun,filebrowser,emoji";
        drun-display-format = " {name} ";
        sidebar-mode = true;
        matching = "prefix";
        scroll-method = 0;
        disable-history = false;
        show-icons = true;

        display-drun = " Run";
        display-run = " Run";
        display-filebrowser = " Files";
        display-emoji = "💀 Emoji";
      };

      theme = let
        inherit (osConfig.modules.style.colorScheme) colors;
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          background-alt = mkLiteral "#${colors.base02}";
          selected = mkLiteral "#${colors.base00}";
          active = mkLiteral "#${colors.base0D}";
          urgent = mkLiteral "#${colors.base00}";
        };
        "window" = {
          transparency = "real";
          location = mkLiteral "center";
          anchor = mkLiteral "center";
          fullscreen = mkLiteral "false";
          width = mkLiteral "600px";
          x-offset = mkLiteral "0px";
          y-offset = mkLiteral "0px";
          enabled = mkLiteral "true";
          border-radius = mkLiteral "20px";
          border = mkLiteral "4px";
          border-color = mkLiteral "#${colors.base02}";
          cursor = "default";
        };
        "mainbox" = {
          enabled = true;
          spacing = mkLiteral "0px";
          orientation = mkLiteral "vertical";
          children = mkLiteral "[inputbar,listbox]";
        };
        "listbox" = {
          spacing = mkLiteral "10px";
          padding = mkLiteral "10px 10px 10px 15px";
          orientation = mkLiteral "vertical";
          children = mkLiteral "[message,listview]";
        };
        "inputbar" = {
          enabled = true;
          spacing = mkLiteral "10px";
          padding = mkLiteral "30px 20px 30px 20px";
          orientation = mkLiteral "horizontal";
          children = mkLiteral "[prompt,entry]";
        };
        "entry" = {
          enabled = true;
          expand = true;
          width = mkLiteral "300px";
          padding = mkLiteral "12px 15px";
          border-radius = mkLiteral "15px";
          cursor = mkLiteral "text";
          placeholder = "Search";
          placeholder-color = mkLiteral "inherit";
        };
        "prompt" = {
          width = mkLiteral "64px";
          font = "Iosevka Nerd Font 13";
          padding = mkLiteral "10px 20px 10px 20px";
          border-radius = mkLiteral "15px";
          cursor = mkLiteral "pointer";
        };
        "mode-switcher" = {
          enabled = true;
          spacing = mkLiteral "10px";
        };
        "button" = {
          width = mkLiteral "48px";
          font = "Iosevka Nerd Font 14";
          padding = mkLiteral "8px 5px 8px 8px";
          border-radius = mkLiteral "15px";
          cursor = mkLiteral "pointer";
        };
        "listview" = {
          enabled = true;
          columns = 2;
          lines = 7;
          cycle = true;
          dynamic = true;
          scrollbar = false;
          layout = mkLiteral "vertical";
          reverse = false;
          fixed-height = true;
          fixed-columns = false;
          spacing = mkLiteral "5px";
          cursor = mkLiteral "default";
        };
        "element" = {
          enabled = true;
          spacing = mkLiteral "15px";
          padding = mkLiteral "7px";
          border-radius = mkLiteral "100%";
          cursor = mkLiteral "pointer";
        };
        "element-icon" = {
          size = mkLiteral "32px";
          cursor = mkLiteral "inherit";
        };
        "element-text" = {
          cursor = mkLiteral "inherit";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.0";
        };
        "textbox" = {
          padding = mkLiteral "12px";
          border-radius = mkLiteral "100%";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.0";
        };
        "error-message" = {
          padding = mkLiteral "12px";
          border-radius = mkLiteral "20px";
        };
      };
    };
  };
}
