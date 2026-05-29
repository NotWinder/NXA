{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    #nodejs_21

    python3

    cargo
    rustup

    go
  ];
}
