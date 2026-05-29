{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    cachix
    opencode
    opencode-desktop
  ];
}
