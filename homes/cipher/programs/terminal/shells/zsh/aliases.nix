{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.meta) getExe; #getExe';
  inherit (pkgs) eza bat ripgrep dust procs yt-dlp python3;
  inherit (lib) mkIf;

  cfg = osConfig.modules.system;
  #dig = getExe' pkgs.dnsutils "dig";
in {
  config = mkIf (cfg.defaultUserShell == pkgs.zsh) {
    programs.zsh.shellAliases = {
      # make sudo use aliases
      sudo = "sudo ";

      # nix specific aliases
      cleanup = "sudo nix-collect-garbage --delete-older-than 3d && nix-collect-garbage -d"; # Uses nix-collect-garbage to Cleanup the old generaions
      bloat = "nix path-info -Sh /run/current-system"; # Shows the current systems size
      curgen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system"; # lists the generaions of the system
      gc-check = "nix-store --gc --print-roots | egrep -v \"^(/nix/var|/run/\w+-system|\{memory|/proc)\""; # TODO: check what is does
      repair = "nix-store --verify --check-contents --repair";
      run = "nix run"; # runs the flake
      search = "nix search"; # Searchs in the flake
      shell = "nix shell"; # runs a shell with the flake packages
      build = "nix build $@ --builders \"\""; ## TODO: check what is does
      devng = "nix develop ~/github/nix-winder/#angular"; # runs a devshell for angular
      devdjango = "nix develop ~/github/nix-winder/#django"; # runs a devshell for django
      devjava = "nix develop ~/github/nix-winder/#java"; # runs a devshell for java
      devgo = "nix develop ~/github/nix-winder/#go"; # runs a devshell for go
      devrust = "nix develop ~/github/nix-winder/#rust"; # runs a devshell for rust
      flake-build = "sudo nixos-rebuild switch --flake .#cipher"; # rebuilds the system with the cipher system

      # quality of life aliases
      cat = "${getExe bat} --style=plain";
      grep = "${getExe ripgrep}";
      du = "${getExe dust}";
      ps = "${getExe procs}";
      mp = "mkdir -p";
      fcd = "cd $(find -type d | fzf)";
      ls = "${getExe eza} -h --git --icons --color=auto --group-directories-first -s extension";
      ll = "ls -lF --time-style=long-iso --icons";
      ytmp3 = ''
        ${getExe yt-dlp} -x --continue --add-metadata --embed-thumbnail --audio-format mp3 --audio-quality 0 --metadata-from-title="%(artist)s - %(title)s" --prefer-ffmpeg -o "%(title)s.%(ext)s"
      ''; # TODO: how this aliase works

      # system aliases
      sc = "sudo systemctl";
      jc = "sudo journalctl";
      scu = "systemctl --user ";
      jcu = "journalctl --user";
      errors = "journalctl -p err..alert";
      la = "${getExe eza} -lah --tree";
      tree = "${getExe eza} --tree --icons=always";
      http = "${getExe python3} -m http.server";
      burn = "pkill -9";
      diff = "diff --color=auto";
      cpu = ''watch -n.1 "grep \"^[c]pu MHz\" /proc/cpuinfo"'';
      killall = "pkill";

      # insteaed of querying some weird and random"what is my ip" service
      # we get our public ip by querying opendns directly.
      # <https://unix.stackexchange.com/a/81699>
      #canihazip = "${dig} @resolver4.opendns.com myip.opendns.com +short";
      #canihazip4 = "${dig} @resolver4.opendns.com myip.opendns.com +short -4";
      #canihazip6 = "${dig} @resolver1.ipv6-sandbox.opendns.com AAAA myip.opendns.com +short -6";
      # FIXME: doesn't work for some reasone

      # faster navigation
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";
      "......" = "cd ../../../../../";

      # Text Editors
      pico = "edit";
      spico = "sedit";
      nano = "edit";
      snano = "sedit";
      svi = "sudo -E nvim";
      # File Operations
      cp = "cp -i";
      mv = "mv -i";
      rm = "trash -v";
      rmd = "/bin/rm --recursive --force --verbose ";
      # Directory Navigation
      "cd.." = "cd ..";

      # Viewing and Handling Files
      less = "less -R";
      cls = "clear";
      cle = "clear";

      # File Permissions
      mx = "chmod a+x";
      "000" = "chmod -R 000";
      "644" = "chmod -R 644";
      "666" = "chmod -R 666";
      "755" = "chmod -R 755";
      "777" = "chmod -R 777";

      # Network
      openports = "netstat -nape --inet";

      # Reboot
      reboot = "systemctl -i reboot";
      rebootsafe = "sudo shutdown -r now";

      # Archive Operations
      mktar = "tar -cvf";
      mkbz2 = "tar -cvjf";
      mkgz = "tar -cvzf";
      untar = "tar -xvf";
      unbz2 = "tar -xvjf";
      ungz = "tar -xvzf";

      # Miscellaneous
      poweroff = "systemctl -i poweroff";
      nvidia0 = "sudo -E nvidia-settings -a '[fan]/GPUTargetFanSpeed=0'";
      nvidia50 = "sudo -E nvidia-settings -a '[fan]/GPUTargetFanSpeed=50'";
      nvidia100 = "sudo -E nvidia-settings -a '[fan]/GPUTargetFanSpeed=100'";
      ssh = "TERM=xterm-256color ssh";
      wget = "wget --hsts-file='$XDG_CACHE_HOME/wget-hsts'";
    };
  };
}
