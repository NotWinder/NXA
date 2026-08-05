{ ... }: {
  flake.modules.nixos.server = {
    config = {
      system.nixos.tags = [ "server" ];
    };
  };
}
