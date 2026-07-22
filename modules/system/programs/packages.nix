{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    cachix
    opencode
    opencode-desktop
    tmux

    # opencode MCP servers
    mcp-server-filesystem
    context7-mcp
    mcp-nixos
  ];
}
