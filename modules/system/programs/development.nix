{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    #nodejs_21
    nodejs_24

    python3

    cargo
    rustup

    go
  ];
}
