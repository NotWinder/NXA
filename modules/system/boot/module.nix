{ config
, lib
, ...
}:
{
  imports = [
    ./loaders # per-bootloader configurations
    ./secure-boot.nix # secure boot module
    ./generic.nix # generic configuration, such as kernel and tmpfs setup
    ./plymouth.nix # plymouth boot splash
  ];

  boot.blacklistedKernelModules =
    [ "serial8250" ]
    # Only blacklist the TPM modules on machines without a TPM; hosts that
    # have one keep them for `hardware/tpm.nix`, which is gated on `hasTPM`.
    ++ lib.optionals (!config.custom.device.hasTPM) [ "tpm" "tpm_tis" "tpm_crb" ];
}
