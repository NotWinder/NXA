{
  perSystem = {pkgs, ...}: {
    devShells = {
      default = pkgs.mkShell {
        name = "nyx";
        meta.description = "The default development shell for my NixOS configuration";

        # tell direnv to shut up
        DIRENV_LOG_FORMAT = "";

        # packages available in the dev shell
        packages = with pkgs; [
          #inputs'.agenix.packages.default # provide agenix CLI within flake shell
          #inputs'.deploy-rs.packages.default # provide deploy-rs CLI within flake shell
          #config.treefmt.build.wrapper # treewide formatter
          nil # nix ls
          alejandra # nix formatter
          git # flakes require git, and so do I
          glow # markdown viewer
          statix # lints and suggestions
          deadnix # clean up unused nix code
          nodejs # for ags and eslint_d
          (pkgs.writeShellApplication {
            name = "update";
            text = ''
              nix flake update && git commit flake.lock -m "flake: bump inputs"
            '';
          })
        ];
      };

      django = pkgs.mkShell {
        name = "python";
        meta.description = "The Python development shell for django";
        packages = with pkgs; [
          python3Full
          python312Packages.pip
          python312Packages.pillow
          python312Packages.pygments
          python312Packages.certifi
          python312Packages.charset-normalizer
          python312Packages.colorama
          python312Packages.customtkinter
          python312Packages.customtkinter
          python312Packages.darkdetect
          python312Packages.idna
          python312Packages.markdown-it-py
          python312Packages.mdurl
          python312Packages.ordered-set
          python312Packages.python-dotenv
          python312Packages.requests
          python312Packages.rich
          python312Packages.thefuzz
          python312Packages.tqdm
          python312Packages.urllib3
          python312Packages.wheel
          python312Packages.zstandard
        ];

        shellHook = ''
          echo "welcome to the python shell"
        '';
      };
      angular = pkgs.mkShell {
        name = "angular";
        meta.description = "The angular development shell";
        packages = with pkgs; [
          nodePackages."@angular/cli"
          nodePackages.typescript-language-server
          nodejs_22
        ];

        shellHook = ''
          echo "welcome to the angular shell"
        '';
      };

      java = pkgs.mkShell {
        name = "java";
        meta.description = "The java development shell";
        packages = with pkgs; [
          jdk22
        ];

        shellHook = ''
          echo "welcome to the java shell"
        '';
      };
      go = pkgs.mkShell {
        name = "go";
        meta.description = "The go development shell";
        packages = with pkgs; [
          go
          gopls
        ];

        shellHook = ''
          echo "welcome to the go shell"
        '';
      };
    };
  };
}
