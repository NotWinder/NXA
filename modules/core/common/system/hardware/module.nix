{
  imports = [
    ./cpu # cpu specific options
    ./gpu # gpu specific options
    ./multimedia # enable multimedia: e.g. sound and video

    ./bluetooth.nix # bluetooth and device management
    ./redistributable.nix # Non-free redstributable software
    ./tpm.nix # trusted platform module
  ];
}
