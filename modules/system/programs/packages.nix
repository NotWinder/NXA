{ pkgs, inputs', ... }: {
  # khal's sphinx man builder produces no output on current nixpkgs, which
  # fails the build ("failed to produce output path for output 'man'").
  nixpkgs.overlays = [
    (_: prev: {
      khal = prev.khal.overrideAttrs (o: {
        postFixup = (o.postFixup or "") + "mkdir -p $man";
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    ansible
    cachix
    colmena
    opencode
    opencode-desktop
    claude-code
    inputs'.claude-desktop-nix.packages.default
    graphify
    codex
    tmux

    # opencode MCP servers
    mcp-server-filesystem
    context7-mcp
    mcp-nixos
  ];
}
