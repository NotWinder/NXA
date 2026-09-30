{ config
, pkgs
, lib
, ...
}:
let
  inherit (lib) mkIf makeBinPath optionals optionalString;
  inherit (config) custom;

  env = custom.usrEnv;
  prg = env.programs;

  hyprland = config.custom.programs.hyprland.enable;
  ppd = config.services.power-profiles-daemon.enable;

  # gamemoded runs the custom scripts from the user service, whose PATH is not
  # guaranteed to contain these, so every script exports them itself.
  runtimePath = makeBinPath ([
    pkgs.coreutils
    pkgs.libnotify
    pkgs.ludusavi
  ]
  ++ optionals hyprland [ config.programs.hyprland.package ]
  ++ optionals ppd [ pkgs.power-profiles-daemon ]);

  # Remembers the power profile picked before the game (e.g. via profile-cycle)
  # so the end script restores it instead of forcing "balanced".
  profileState = "$XDG_RUNTIME_DIR/gamemode-power-profile";

  startscript = pkgs.writeShellScript "gamemode-start" ''
    export PATH=${runtimePath}:$PATH

    ${optionalString hyprland ''
      export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 $XDG_RUNTIME_DIR/hypr | tail -1)
      hyprctl --batch 'keyword decoration:blur 0 ; keyword animations:enabled 0 ; keyword misc:vfr 0'
    ''}

    ${optionalString ppd ''
      powerprofilesctl get > "${profileState}"
      powerprofilesctl set performance
    ''}

    notify-send -a 'Gamemode' 'Optimizations activated' -u 'low'
  '';

  endscript = pkgs.writeShellScript "gamemode-end" ''
    export PATH=${runtimePath}:$PATH

    ${optionalString hyprland ''
      export HYPRLAND_INSTANCE_SIGNATURE=$(ls -w1 $XDG_RUNTIME_DIR/hypr | tail -1)
      hyprctl --batch 'keyword decoration:blur 1 ; keyword animations:enabled 1 ; keyword misc:vfr 1'
    ''}

    ${optionalString ppd ''
      powerprofilesctl set "$(cat "${profileState}" 2>/dev/null || echo balanced)"
      rm -f "${profileState}"
    ''}

    ludusavi backup --force
    notify-send -a 'Gamemode' 'Optimizations deactivated' -u 'low'
  '';
in
{
  config = mkIf prg.gaming.gamemode.enable {
    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          softrealtime = "auto";
          renice = 10;
          # No defaultgov: gamemode then restores whatever governor was active
          # before the game (auto-cpufreq / power-profiles-daemon stay in charge).
          desiredgov = "performance";
          desiredprof = "performance";
        };

        custom = {
          start = startscript.outPath;
          end = endscript.outPath;
        };
      };
    };

    # <https://www.phoronix.com/news/Fedora-39-VM-Max-Map-Count>
    # <https://github.com/pop-os/default-settings/blob/master_jammy/etc/sysctl.d/10-pop-default-settings.conf>
    boot.kernel.sysctl = {
      # default on some gaming (SteamOS) and desktop (Fedora) distributions
      # might help with gaming performance
      "vm.max_map_count" = 2147483642;
    };
  };
}
