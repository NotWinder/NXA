{ inputs, pkgs, ... }: {
  imports = [
    ./fs.nix
    ./modules
    inputs.deepseek-harness.nixosModules.default
  ];

  config = {
    system.stateVersion = "25.05";
    boot.binfmt.emulatedSystems = [ "i686-linux" ];

    programs.dsh = {
      enable = true;
      desktop.enable = true;
      profiles.tui.bundles = [ pkgs.dsh.bundles.tui ];
      defaultProfile = "nix-tui";
    };
  };
}
