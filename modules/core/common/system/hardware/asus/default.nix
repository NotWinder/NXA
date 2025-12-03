{pkgs, ...}: {
  config = {
    #systemd.services.supergfxd.path = [pkgs.pciutils];

    #services = {
    #  supergfxd = {
    #    enable = true;
    #    settings = {
    #      mode = "Hybrid";
    #      always_reboot = false;
    #      vfio_enable = false;
    #      compute_enable = false;
    #      hotplug_type = "None";
    #    };
    #  };

    #  asusd = {
    #    enable = true;
    #    enableUserService = true;
    #  };
    #};

    #environment.systemPackages = with pkgs; [
    #  (writeShellScriptBin "gpu-hybrid" ''
    #    ${pkgs.supergfxctl}/bin/supergfxctl -m Hybrid
    #    echo "Switched to Hybrid mode (battery saving)"
    #  '')

    #  (writeShellScriptBin "gpu-dedicated" ''
    #    ${pkgs.supergfxctl}/bin/supergfxctl -m Dedicated
    #    echo "Switched to Dedicated NVIDIA mode (max performance)"
    #  '')

    #  (writeShellScriptBin "gpu-integrated" ''
    #    ${pkgs.supergfxctl}/bin/supergfxctl -m Integrated
    #    echo "Switched to Integrated AMD mode (max battery)"
    #  '')

    #  (writeShellScriptBin "gpu-gaming" ''
    #    echo "Setting up GPU for gaming..."
    #    ${pkgs.supergfxctl}/bin/supergfxctl -m Dedicated
    #    sleep 2
    #    sudo ${pkgs.linuxPackages.nvidia_x11}/bin/nvidia-smi -pm 1
    #    sudo ${pkgs.linuxPackages.nvidia_x11}/bin/nvidia-smi -pl 80
    #    sudo ${pkgs.linuxPackages.nvidia_x11}/bin/nvidia-smi -lgc 1500
    #    echo "GPU configured for maximum performance!"
    #    ${pkgs.linuxPackages.nvidia_x11}/bin/nvidia-smi
    #  '')

    #  (writeShellScriptBin "gpu-status" ''
    #    echo "Current GPU mode:"
    #    ${pkgs.supergfxctl}/bin/supergfxctl -g
    #    echo ""
    #    echo "GPU processes:"
    #    ${pkgs.linuxPackages.nvidia_x11}/bin/nvidia-smi
    #  '')
    #];

    ## Allow nvidia-smi to be run with sudo without password for power management
    #security.sudo.extraRules = [
    #  {
    #    users = ["winder"];
    #    commands = [
    #      {
    #        command = "${pkgs.linuxPackages.nvidia_x11}/bin/nvidia-smi";
    #        options = ["NOPASSWD"];
    #      }
    #    ];
    #  }
    #];
  };
}
