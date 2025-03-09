{pkgs, ...}: let
  game-umount = pkgs.writeShellScriptBin "game-umount" ''
    # Notification title and message
    TITLE="GameMod"
    MESSAGE="Off!"

    fusermount -u /home/winder/Games/Heroic/Prefixes/default/Elden-Ring/pfx/drive_c/Games/Elden-Ring/

    umount /home/winder/Games/Heroic/Prefixes/default/Assassins-Creed-IV-Black-Flag/pfx/drive_c/Games/Assassins-Creed-IV-Black-Flag/
    umount /home/winder/Games/Heroic/Prefixes/default/Dark-Souls-III/pfx/drive_c/Games/Dark-Souls-III/
    umount /home/winder/Games/Heroic/Prefixes/default/Elden-Ring/pfx/drive_c/Games/ER-mnt/
    umount /home/winder/Games/Heroic/Prefixes/default/NieR-Automata/pfx/drive_c/Games/NieR-Automata-Game-of-the-YoRHa-Edition/
    umount /home/winder/Games/Heroic/Prefixes/default/NieR-Replicant-ver.1.22474487139/pfx/drive_c/Games/NieR-Replicant-ver.1.22474487139/
    umount /home/winder/Games/Heroic/Prefixes/default/Portal2/pfx/drive_c/Games/Portal2/
    umount /home/winder/Games/Heroic/Prefixes/default/Red-Dead-Redemption-2/pfx/drive_c/Games/Red-Dead-Redemption-2/
    umount /home/winder/Games/Heroic/Prefixes/default/Sekiro-Shadows-Die-Twice/pfx/drive_c/Games/Sekiro-Shadows-Die-Twice/
    umount /home/winder/Games/Heroic/Prefixes/default/Tekken-8/pfx/drive_c/Games/TEKKEN-8/
    umount /home/winder/Games/Heroic/Prefixes/default/The-Stanley-Parable-Ultra-Deluxe/pfx/drive_c/Games/The-Stanley-Parable-Ultra-Deluxe/

    # Send notification using notify-send
    notify-send "$TITLE" "$MESSAGE"
  '';
in {
  home.packages = [game-umount];
}
