{config, ...}: {
  # We want to handle user configurations on a per-file basis. What that
  # means is a new user cannot be added via, e.g., useradd unless a new
  # file has been added here to create user configuration.
  # In short:users that are not in users/<username>.nix don't get to
  # be a real user
  imports = [
    ./user.nix
    ./root.nix
  ];

  config = {
    users = {
      # Default user shell package
      defaultUserShell = config.modules.system.defaultUserShell;

      # And other stuff...
      allowNoPasswordLogin = false;
      enforceIdUniqueness = true;
    };
  };
}
