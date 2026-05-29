{
  imports = [
    ./asus
    ./cpu # cpu specific options
    ./gpu # gpu specific options
    ./sound # enable sound
    ./video # enable video

    ./bluetooth.nix # bluetooth and device management
    ./redistributable.nix # Non-free redstributable software
    ./tpm.nix # trusted platform module
  ];
}
