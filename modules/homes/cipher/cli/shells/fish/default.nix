{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.modules.system;
in {
  imports = [
    ./aliases.nix
  ];
  config.hm = mkIf (cfg.defaultUserShell == pkgs.fish) {
    programs.fish = {
      enable = true;
      functions = {
        # use vi key bindings with hybrid emacs keybindings
        fish_user_key_bindings =
          # fish
          ''
            fish_default_key_bindings -M insert
            fish_vi_key_bindings --no-erase insert
          '';
        ssh = ''
          env TERM=xterm-256color ssh $argv
        '';
      };
      shellInit =
        # fish
        ''
          # shut up welcome message
          set fish_greeting

          # set options for plugins
          set sponge_regex_patterns 'password|passwd|^kill'

          # bind --mode default \t complete-and-search
          bind -M insert ctrl-space accept-autosuggestion
        '';
      # setup vi mode
      interactiveShellInit =
        # fish
        ''
          fish_vi_key_bindings
        '';

      # fish plugins, must be an attrset
      #plugins = [];
    };
  };
}
