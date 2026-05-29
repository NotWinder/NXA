{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf concatStringsSep;
  inherit (builtins) elem;
  inherit (config) modules;

  prg = modules.usrEnv.programs;
in {
  config.hm = mkIf (elem "chromium" prg.browsers) {
    programs.chromium = {
      enable = true;
      extensions = [
        {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # sponsor block
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock
        {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
        {id = "iaiomicjabeggjcfkbimgmglanimpnae";} # tab manager
      ];

      package = pkgs.chromium.override {
        commandLineArgs = [
          # Ungoogled features
          "--disable-search-engine-collection"
          "--extension-mime-request-handling=always-prompt-for-install"
          "--fingerprinting-canvas-image-data-noise"
          "--fingerprinting-canvas-measuretext-noise"
          "--fingerprinting-client-rects-noise"
          "--popups-to-tabs"
          "--show-avatar-button=incognito-and-guest"

          # Experimental features
          "--enable-features=${
            concatStringsSep "," [
              "BackForwardCache:enable_same_site/true"
              "CopyLinkToText"
              "OverlayScrollbar"
              "TabHoverCardImages"
              "VaapiVideoDecoder"
              "AcceleratedVideoDecodeLinuxGL"
            ]
          }"

          # Aesthetics
          "--force-dark-mode"

          # Performance
          "--enable-gpu-rasterization"
          "--enable-oop-rasterization"
          "--enable-zero-copy"
          "--ignore-gpu-blocklist"

          # Etc
          # "--gtk-version=4"
          "--disk-cache=$XDG_RUNTIME_DIR/chromium-cache"
          "--no-default-browser-check"
          "--no-service-autorun"
          "--disable-features=PreloadMediaEngagementData,MediaEngagementBypassAutoplayPolicies"
          "--disable-reading-from-canvas"
          "--no-pings"
          "--no-first-run"
          "--no-experiments"
          "--no-crash-upload"
          "--disable-wake-on-wifi"
          "--disable-breakpad"
          "--disable-sync"
          "--disable-speech-api"
          "--disable-speech-synthesis-api"

          # Wayland
          "--ozone-platform-hint=auto"
        ];
      };
    };
  };
}
