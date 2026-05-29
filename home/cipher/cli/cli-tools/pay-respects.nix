{pkgs, ...}: {
  config.hm = {
    # type "fuck" to fix the last command that made you go "fuck"
    programs.pay-respects = {
      enable = false;
      package = pkgs.pay-respects.overridePythonAttrs {doCheck = false;};
    };
  };
}
