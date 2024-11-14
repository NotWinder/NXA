{
  # Text Editors
  pico = "edit";
  spico = "sedit";
  nano = "edit";
  snano = "sedit";
  svi = "sudo -E nvim";
  # File Operations
  cat = "bat";
  dir = "mkdir";
  cp = "cp -i";
  mv = "mv -i";
  rm = "trash -v";
  rmd = "/bin/rm --recursive --force --verbose ";
  # Directory Navigation
  home = "cd ~";
  "cd.." = "cd ..";
  ".." = "cd ..";
  "..." = "cd ../..";
  "...." = "cd ../../..";
  "....." = "cd ../../../..";
  web = "cd /var/www/html";
  # Process Management
  ps = "ps auxf";
  topcpu = "/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10";

  # Viewing and Handling Files
  less = "less -R";
  cls = "clear";
  cle = "clear";

  # Package Management
  apt-get = "sudo apt-get";
  apt = "sudo nala";
  freshclam = "sudo freshclam";

  # Python
  python = "python3";
  py = "python3";

  # Rust
  fempty = "cargo run --manifest-path /home/winder/rust/fempty/Cargo.toml";

  # List Contents
  la = "ls -Ah";
  ls = "ls -Fh --color=always";
  lx = "ls -lXBh";
  lk = "ls -lSrh";
  lc = "ls -lcrh";
  lu = "ls -lurh";
  lr = "ls -lRh";
  lt = "ls -ltrh";
  lm = "ls -alh | more";
  lw = "ls -xAh";
  ll = "ls -aFls";
  labc = "ls -lap";
  lf = "ls -l | egrep -v '^d'";
  ldir = "ls -l | egrep '^d'";

  # File Permissions
  mx = "chmod a+x";
  "000" = "chmod -R 000";
  "644" = "chmod -R 644";
  "666" = "chmod -R 666";
  "755" = "chmod -R 755";
  "777" = "chmod -R 777";

  # History and Search
  h = "history | grep ";
  p = "ps aux | grep ";
  f = "find . | grep ";

  # Check Command Type
  checkcommand = "type -t";

  # Network
  openports = "netstat -nape --inet";

  # Reboot
  reboot = "systemctl -i reboot";
  rebootsafe = "sudo shutdown -r now";
  rebootforce = "sudo shutdown -r -n now";

  # Disk and Space Usage
  diskspace = "du -S | sort -n -r | more";
  folders = "du -h --max-depth=1";
  folderssort = "find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn";

  # Directory Trees
  tree = "tree -CAhF --dirsfirst";
  treed = "tree -CAFd";

  # Mounted File Systems
  mountedinfo = "df -hT";


  # Archive Operations
  mktar = "tar -cvf";
  mkbz2 = "tar -cvjf";
  mkgz = "tar -cvzf";
  untar = "tar -xvf";
  unbz2 = "tar -xvjf";
  ungz = "tar -xvzf";

  # Log Files
  logs = "sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f";

  # SHA1 Hash
  sha1 = "openssl sha1";

  ## Nixos aliases 
  # Shells
  devng = "nix develop /home/winder/github/nix-winder/#angular";
  devdjango = "nix develop /home/winder/github/nix-winder/#django";
  devjava = "nix develop /home/winder/github/nix-winder/#java";
  devgo = "nix develop /home/winder/github/nix-winder/#go";
  devrust = "nix develop /home/winder/github/nix-winder/#rust";

  flake-build = "sudo nixos-rebuild switch --flake .#cipher";

  # Miscellaneous
  Hyprland = "exec env WLR_NO_HARDWARE_CURSORS=1 Hyprland";
  nixbuild = "sudo nixos-rebuild switch";
  poweroff = "systemctl -i poweroff";
  nvidia0 = "sudo -E nvidia-settings -a '[fan]/GPUTargetFanSpeed=0'";
  nvidia50 = "sudo -E nvidia-settings -a '[fan]/GPUTargetFanSpeed=50'";
  nvidia100 = "sudo -E nvidia-settings -a '[fan]/GPUTargetFanSpeed=100'";
  docreatefra6deb = "doctl compute droplet create --region fra1 --size s-1vcpu-1gb --image debian-12-x64 --ssh-keys 40930668,40798689,40998907 --wait";
  docreateams6deb = "doctl compute droplet create --region ams3 --size s-1vcpu-1gb --image debian-12-x64 --ssh-keys 40930668,40798689,40998907 --wait";
  docreatefra4deb = "doctl compute droplet create --region fra1 --size s-1vcpu-512mb-10gb --image debian-12-x64 --ssh-keys 40930668,40798689,40998907 --wait";
  docreateams4deb = "doctl compute droplet create --region ams3 --size s-1vcpu-512mb-10gb --image debian-12-x64 --ssh-keys 40930668,40798689,40998907 --wait";
  ssh = "TERM=xterm-256color ssh";
  wget = "wget --hsts-file='$XDG_CACHE_HOME/wget-hsts'";
  hug = "hugo server -F --bind=10.0.0.210 --baseURL=http://10.0.0.210";
  lookingglass = "~/looking-glass-B5.0.1/client/build/looking-glass-client -F";
}
