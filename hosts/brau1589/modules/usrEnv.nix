{
  config = {
    custom = {
      programs = {
        hyprland.enable = true;
        niri.enable = true;
        dms.enable = true;
      };
      services.greetd = {
        enable = true;
        autoLogin = {
          enable = true;
          command = "niri-session";
        };
      };
    };
    custom.usrEnv.programs = {
      browsers = [ "librewolf" "zen-beta" ];
      default.browser = "zen-beta";
    };
  };
}
