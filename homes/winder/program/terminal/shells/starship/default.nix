{ lib, ... }:
let
  inherit (builtins) map;
  inherit (lib.strings) concatStrings;
in
{
  programs.starship =
    let
      elemsConcatted = concatStrings (
        map (s: "\$${s}") [
          "hostname"
          "username"
          "directory"
          "shell"
          "nix_shell"
          "git_branch"
          "git_commit"
          "git_state"
          "git_status"
          "jobs"
          "cmd_duration"
        ]
      );
    in
    {
      enable = true;
      settings = {
        command_timeout = 5000;

        # configure specific elements
        character = {
          error_symbol = "[](bold red)";
          success_symbol = "[](bold green)";
          vicmd_symbol = "[](bold yellow)";
          format = "$symbol [|](bold bright-black) ";
        };

        format = "${elemsConcatted}\n$character";

        hostname = {
          ssh_only = true;
          disabled = false;
          format = "@[$hostname](bold blue) "; # the whitespace at the end is actually important
        };
        username = {
          format = "[$user]($style) in ";
        };

        directory = {
          truncation_length = 2;

          # removes the read_only symbol from the format, it doesn't play nicely with my folder icon
          format = "[ ](bold green) [$path]($style) ";

          # the following removes tildes from the path, and substitutes some folders with shorter names
          substitutions = {
            "~/Dev" = "Dev";
            "~/Documents" = "Docs";
          };
        };

        directory.substitutions = {
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };

        aws = {
          symbol = "  ";
        };
        buf = {
          symbol = " ";
        };
        c = {
          symbol = " ";
        };
        conda = {
          symbol = " ";
        };
        crystal = {
          symbol = " ";
        };
        dart = {
          symbol = " ";
        };
        directory = {
          read_only = " 󰌾";
        };
        docker_context = {
          symbol = " ";
        };
        elixir = {
          symbol = " ";
        };
        elm = {
          symbol = " ";
        };
        fennel = {
          symbol = " ";
        };
        fossil_branch = {
          symbol = " ";
        };
        git_branch = {
          symbol = " ";
        };
        git_status = {
          ahead = "⇡ ";
          behind = "⇣ ";
          conflicted = " ";
          deleted = "✘ ";
          diverged = "⇆ ";
          modified = "!";
          renamed = "»";
          staged = "+";
          stashed = "≡";
          style = "red";
          untracked = "?";
        };
        golang = {
          symbol = " ";
        };
        guix_shell = {
          symbol = " ";
        };
        haskell = {
          symbol = " ";
        };
        haxe = {
          symbol = " ";
        };
        hg_branch = {
          symbol = " ";
        };
        hostname = {
          ssh_symbol = " ";
        };
        java = {
          symbol = " ";
        };
        julia = {
          symbol = " ";
        };
        kotlin = {
          symbol = " ";
        };
        lua = {
          symbol = " ";
        };
        memory_usage = {
          symbol = "󰍛 ";
        };
        meson = {
          symbol = "󰔷 ";
        };
        nim = {
          symbol = "󰆥 ";
        };
        nix_shell = {
          symbol = " ";
        };
        nodejs = {
          symbol = " ";
        };
        ocaml = {
          symbol = " ";
        };
        os.symbols = {
          Alpaquita = " ";
          Alpine = " ";
          AlmaLinux = " ";
          Amazon = " ";
          Android = " ";
          Arch = " ";
          Artix = " ";
          CentOS = " ";
          Debian = " ";
          DragonFly = " ";
          Emscripten = " ";
          EndeavourOS = " ";
          Fedora = " ";
          FreeBSD = " ";
          Garuda = "󰛓 ";
          Gentoo = " ";
          HardenedBSD = "󰞌 ";
          Illumos = "󰈸 ";
          Kali = " ";
          Linux = " ";
          Mabox = " ";
          Macos = " ";
          Manjaro = " ";
          Mariner = " ";
          MidnightBSD = " ";
          Mint = " ";
          NetBSD = " ";
          NixOS = " ";
          OpenBSD = "󰈺 ";
          openSUSE = " ";
          OracleLinux = "󰌷 ";
          Pop = " ";
          Raspbian = " ";
          Redhat = " ";
          RedHatEnterprise = " ";
          RockyLinux = " ";
          Redox = "󰀘 ";
          Solus = "󰠳 ";
          SUSE = " ";
          Ubuntu = " ";
          Unknown = " ";
          Void = " ";
          Windows = "󰍲 ";
        };

        package = {
          symbol = "󰏗 ";
        };
        perl = {
          symbol = " ";
        };
        php = {
          symbol = " ";
        };
        pijul_channel = {
          symbol = " ";
        };
        python = {
          symbol = " ";
        };
        rlang = {
          symbol = "󰟔 ";
        };
        ruby = {
          symbol = " ";
        };
        rust = {
          symbol = "󱘗 ";
        };
        scala = {
          symbol = " ";
        };
        swift = {
          symbol = " ";
        };
        zig = {
          symbol = " ";
        };
        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:#33658A";
          format = "[ $time ]($style)";
        };
      };
    };
}
