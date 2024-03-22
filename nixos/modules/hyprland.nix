{ pkgs, inputs, config, username, asztal, ... }:

{
  programs.hyprland.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  security = {
    polkit.enable = true;
    pam.services.ags = { };
  };

  services.greetd = {
    enable = true;
    settings.default_session.command = pkgs.writeShellScript "greeter" ''
      export XKB_DEFAULT_LAYOUT=${config.services.xserver.xkb.layout}
      export XCURSOR_THEME=Qogir
      ${asztal}/bin/greeter
    '';
  };

}
