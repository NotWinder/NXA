{
  perSystem =
    { inputs'
    , config
    , pkgs
    , ...
    }: {
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
          packages = with pkgs.python312Packages;
            [
              django
              openpyxl
              pandas
              jdatetime
              pillow
              openai
            ];

          shellHook = ''
            echo "welcome to the python shell"
          '';
        };
        angular = pkgs.mkShell {
          meta.description = "The angular development shell";
          packages = with pkgs;
            [
              nodePackages."@angular/cli"
              nodePackages.typescript-language-server
              nodejs_22
            ];

          shellHook = ''
            echo "welcome to the angular shell"
          '';
        };
        go = pkgs.mkShell {
          meta.description = "The go development shell";
          packages = with pkgs;
            [
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
