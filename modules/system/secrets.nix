{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    validateSopsFiles = false;
    age = {
      sshKeyPaths = [ ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = false;
    };
  };
}
