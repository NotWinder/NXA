# Universal `sops` nixos-only aspect (Phase 5 item 1 candidate): sops is
# global infrastructure on every host, so it is composed unconditionally in
# hosts/default.nix rather than behind a `features` entry. There is no
# home-manager side; per-host secret entries live in the host modules
# (hosts/<name>/modules/*) and consumers read paths via
# `config.sops.secrets.<name>.path`.
{ ... }:
{
  flake.modules.nixos.sops = {
    sops = {
      defaultSopsFile = ../secrets/secrets.yaml;
      validateSopsFiles = false;
      age = {
        sshKeyPaths = [ ];
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = false;
      };
    };
  };
}
