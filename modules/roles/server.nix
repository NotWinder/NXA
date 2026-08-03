{ ... }: {
  flake.modules.roles.server = {
    config = {
      system.nixos.tags = [ "server" ];
    };
  };
}
