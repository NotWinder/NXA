{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ansible
    cachix
    colmena
    opencode
    opencode-desktop
    claude-code
    graphify
    codex
    tmux

    # opencode MCP servers
    mcp-server-filesystem
    context7-mcp
    mcp-nixos
  ];
}
