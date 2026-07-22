{
  config = {
    custom = {
      programs = {
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
  };
}
