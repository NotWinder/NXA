{
  config.modules.usrEnv = {
    desktop = "none";
    desktops."i3".enable = false;
    useHomeManager = true;

    programs = {
      cli.enable = true;
      git.signingKey = "0xB7747DE9EEAAE164";
    };
  };
}
