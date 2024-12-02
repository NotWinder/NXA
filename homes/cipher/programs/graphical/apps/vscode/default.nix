{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  sys = modules.system;
  prg = sys.programs;
in {
  config = mkIf prg.vscode.enable {
    programs.vscode = {
      enable = true;
      enableExtensionUpdateCheck = true;
      enableUpdateCheck = true;
      extensions = with pkgs.vscode-extensions;
        [
          WakaTime.vscode-wakatime # Visual Studio Code plugin for automatic time tracking and metrics generated from your programming activity
          arrterian.nix-env-selector
          astro-build.astro-vscode # Astro language support for VS Code
          bbenoist.nix
          catppuccin.catppuccin-vsc # Soothing pastel theme for VSCode
          christian-kohler.path-intellisense # Visual Studio Code plugin that autocompletes filenames
          dbaeumer.vscode-eslint # Integrates ESLint JavaScript into VS Code
          eamodio.gitlens # Visual Studio Code extension that improves its built-in Git capabilities
          esbenp.prettier-vscode # Code formatter using prettier
          formulahendry.code-runner
          github.codespaces # VSCode extensions that provides cloud-hosted development environments for any activity
          github.vscode-pull-request-github
          golang.go # Go extension for Visual Studio Code
          ibm.output-colorizer
          irongeek.vscode-env # Adds formatting and syntax highlighting support for env files (.env) to Visual Studio Code
          james-yu.latex-workshop # LaTeX Workshop Extension
          kamadorueda.alejandra # Uncompromising Nix Code Formatter
          ms-azuretools.vscode-docker # Docker Extension for Visual Studio Code
          ms-python.python # Visual Studio Code extension with rich support for the Python language
          ms-python.vscode-pylance # Performant, feature-rich language server for Python in VS Code
          ms-vscode-remote.remote-ssh # Use any remote machine with a SSH server as your development environment
          ms-vscode.cpptools # C/C++ extension adds language support for C/C++ to Visual Studio Code, including features such as IntelliSense and debugging
          ms-vsliveshare.vsliveshare # Real-time collaborative development for VS Code
          naumovs.color-highlight # Highlight web colors in your editor
          oderwat.indent-rainbow # Makes indentation easier to read
          pkief.material-icon-theme
          redhat.vscode-yaml
          rust-lang.rust-analyzer # Alternative rust language server to the RLS
          shardulm94.trailing-spaces
          sumneko.lua # Lua language server provides various language features for Lua to make development easier and faster
          svelte.svelte-vscode # Svelte language support for VS Code
          timonwong.shellcheck # Integrates ShellCheck into VS Code, a linter for Shell scripts
          usernamehw.errorlens # Visual Studio Code extension that improves highlighting of errors, warnings and other language diagnostics
          xaver.clang-format
          yzhang.markdown-all-in-one # All you need to write Markdown (keyboard shortcuts, table of contents, auto preview and more)
        ]
        ++ [
          pkgs.vscode-extensions."2gua".rainbow-brackets
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "copilot-nightly";
            publisher = "github";
            version = "1.67.7949";
            sha256 = "sha256-ZtUqQeWjXmTz49DUeYkuqSTdVHRC8OfgWv8fuhlHDVc=";
          }
          {
            name = "volar";
            publisher = "vue";
            version = "1.0.12";
            sha256 = "sha256-D9E3KRUOlNVXH4oMv1W0+/mbqO8Se7+6E2F5P/KvCro=";
          }
          {
            name = "vscode-typescript-vue-plugin";
            publisher = "vue";
            version = "1.0.12";
            sha256 = "sha256-WiL+gc9+U861ubLlY/acR+ZcrFT7TdIDR0K1XNNidX8=";
          }
          {
            name = "decay";
            publisher = "decaycs";
            version = "1.0.6";
            sha256 = "sha256-Jtxj6LmHgF7UNaXtXxHkq881BbuPtIJGxR7kdhKr0Uo=";
          }
          {
            name = "vscode-typescript-next";
            publisher = "ms-vscode";
            version = "5.0.202301100";
            sha256 = "sha256-8d/L9F06ZaS9dTOXV6Q40ivI499nfZLQURcLdHXoTSM=";
          }
          {
            name = "vscode-chromium-vector-icons";
            publisher = "adolfdaniel";
            version = "1.0.2";
            sha256 = "sha256-Meo53e/3jUP6YDEXOA/40xghI77jj4iAQus3/S8RPZI=";
          }
        ];
      userSettings = {
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.colorTheme" = "Catppuccin Macchiato";
        "catppuccin.accentColor" = "mauve";
        "editor.fontFamily" = "JetBrainsMono Nerd Font, Material Design Icons, 'monospace', monospace";
        "editor.fontSize" = 16;
        "editor.fontLigatures" = true;
        "workbench.fontAliasing" = "antialiased";
        "files.trimTrailingWhitespace" = true;
        "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font Mono";
        "window.titleBarStyle" = "custom";
        "terminal.integrated.automationShell.linux" = "nix-shell";
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "terminal.integrated.cursorBlinking" = true;
        "terminal.integrated.enableBell" = false;
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnType" = false;
        "editor.minimap.enabled" = false;
        "editor.minimap.renderCharacters" = false;
        "editor.overviewRulerBorder" = false;
        "editor.renderLineHighlight" = "all";
        "editor.inlineSuggest.enabled" = true;
        "editor.smoothScrolling" = true;
        "editor.suggestSelection" = "first";
        "editor.guides.indentation" = true;
        "editor.guides.bracketPairs" = true;
        "editor.bracketPairColorization.enabled" = true;
        "window.nativeTabs" = true;
        "window.restoreWindows" = "all";
        "window.menuBarVisibility" = "toggle";
        "workbench.panel.defaultLocation" = "right";
        "workbench.editor.tabCloseButton" = "left";
        "workbench.startupEditor" = "none";
        "workbench.list.smoothScrolling" = true;
        "security.workspace.trust.enabled" = false;
        "explorer.confirmDelete" = false;
        "breadcrumbs.enabled" = true;
      };
    };
  };
}
