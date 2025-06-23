{
  config.modules.usrEnv = {
    useHomeManager = true;

    programs = {
      cli.enable = true;
      git.signingKey = "0xB7747DE9EEAAE164";
    };
  };
}
