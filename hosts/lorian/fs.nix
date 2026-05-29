{
  config = {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/a4c807aa-5663-4061-99cc-41846a02e8de";
      fsType = "ext4";
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/1549be92-009b-4272-9a2d-b96643878e1d";}
    ];
  };
}
