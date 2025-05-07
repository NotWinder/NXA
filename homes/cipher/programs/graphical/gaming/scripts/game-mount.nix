{pkgs, ...}: let
  game-mount = pkgs.writeShellScriptBin "game-mount" ''
    # Notification title and message
    TITLE="GameMod"
    MESSAGE="On!"

    dwarfs /home/winder/Games/ISO/Assassins-Creed-IV-Black-Flag.dwarfs /home/winder/Games/Heroic/Prefixes/default/Assassins-Creed-IV-Black-Flag/pfx/drive_c/Games/Assassins-Creed-IV-Black-Flag/
    dwarfs /home/winder/Games/ISO/Dark-Souls-III.dwarfs /home/winder/Games/Heroic/Prefixes/default/Dark-Souls-III/pfx/drive_c/Games/DS3-mnt/
    dwarfs /home/winder/Games/ISO/Elden-Ring.dwarfs /home/winder/Games/Heroic/Prefixes/default/Elden-Ring/pfx/drive_c/Games/ER-mnt/
    dwarfs /home/winder/Games/ISO/NieR-Automata-Game-of-the-YoRHa-Edition.dwarfs /home/winder/Games/Heroic/Prefixes/default/NieR-Automata/pfx/drive_c/Games/NieR-Automata-Game-of-the-YoRHa-Edition/
    dwarfs /home/winder/Games/ISO/NieR-Replicant-ver.1.22474487139.dwarfs /home/winder/Games/Heroic/Prefixes/default/NieR-Replicant-ver.1.22474487139/pfx/drive_c/Games/NieR-Replicant-ver.1.22474487139/
    dwarfs /home/winder/Games/ISO/Portal2.dwarfs /home/winder/Games/Heroic/Prefixes/default/Portal2/pfx/drive_c/Games/Portal2/
    dwarfs /home/winder/Games/ISO/Red-Dead-Redemption-2.dwarfs /home/winder/Games/Heroic/Prefixes/default/Red-Dead-Redemption-2/pfx/drive_c/Games/Red-Dead-Redemption-2/
    dwarfs /home/winder/Games/ISO/Tekken-8.dwarfs /home/winder/Games/Heroic/Prefixes/default/Tekken-8/pfx/drive_c/Games/TEKKEN-8/
    dwarfs /home/winder/Games/ISO/The-Stanley-Parable-Ultra-Deluxe.dwarfs /home/winder/Games/Heroic/Prefixes/default/The-Stanley-Parable-Ultra-Deluxe/pfx/drive_c/Games/The-Stanley-Parable-Ultra-Deluxe/

    unionfs /home/winder/Games/Heroic/Prefixes/default/Elden-Ring/pfx/drive_c/Games/Mods=RW:/home/winder/Games/Heroic/Prefixes/default/Elden-Ring/pfx/drive_c/Games/ER-mnt=RO /home/winder/Games/Heroic/Prefixes/default/Elden-Ring/pfx/drive_c/Games/Elden-Ring/
    unionfs /home/winder/Games/Heroic/Prefixes/default/Dark-Souls-III/pfx/drive_c/Games/Mods=RW:/home/winder/Games/Heroic/Prefixes/default/Dark-Souls-III/pfx/drive_c/Games/DS3-mnt=RO /home/winder/Games/Heroic/Prefixes/default/Dark-Souls-III/pfx/drive_c/Games/Dark-Souls-III/

    # Send notification using notify-send
    notify-send "$TITLE" "$MESSAGE"

  '';
in {
  home.packages = [game-mount];
}
