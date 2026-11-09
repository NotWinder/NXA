# `forticlient` feature: Fortinet's proprietary FortiClient VPN client (full VPN installer),
# repackaged from the official .deb. Enable with `features = [ "forticlient" ]`.
#
# The bundled binaries hardcode /opt/forticlient and /etc/forticlient
# and write into them, and patchelf corrupts them, so the
# service copies the package to a writable /opt/forticlient and nix-ld runs
# the unpatched binaries.
{ ... }: {
  flake.modules.nixos.forticlient = { pkgs, ... }:
    let
      version = "6.4.0.0851";

      libs = with pkgs; [
        stdenv.cc.cc.lib
        glib
        gtk3
        pango
        cairo
        atk
        at-spi2-atk
        at-spi2-core
        cups
        expat
        nss
        nspr
        libsecret
        libnotify
        libuuid
        libayatana-appindicator
        systemd # libudev
        libdrm
        libxkbcommon
        mesa
        libgbm
        libGL
        libxshmfence
        fontconfig
        freetype
        vulkan-loader
        alsa-lib
        dbus
        libx11
        libxcb
        libxcomposite
        libxcursor
        libxdamage
        libxext
        libxfixes
        libxi
        libxrandr
        libxrender
        libxscrnsaver
        libxtst
      ];

      forticlient = pkgs.stdenv.mkDerivation {
        pname = "forticlient-vpn";
        inherit version;

        src = pkgs.fetchurl {
          url = "https://filestore.fortinet.com/forticlient/downloads/FortiClientFullVPNInstaller_${version}.deb";
          hash = "sha256-0imi8/EzeCRAWLW2eNJZdrqF5dTBskftLDwkL2YE7Ss=";
        };

        nativeBuildInputs = [ pkgs.dpkg ];
        dontAutoPatchelf = true;
        # dpkg-deb can't set the setuid bit on chrome-sandbox inside the build sandbox
        unpackPhase = "dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions";
        dontConfigure = true;
        dontBuild = true;
        dontStrip = true;

        installPhase = ''
          mkdir -p $out/share
          cp -r opt $out/opt
          cp -r usr/share/polkit-1 $out/share/
          cp -r etc $out/etc
          chmod -R u+w $out
        '';

        meta = {
          description = "Fortinet FortiClient VPN-only client (proprietary)";
          license = pkgs.lib.licenses.unfree;
          platforms = [ "x86_64-linux" ];
        };
      };

      sync = pkgs.writeShellScript "forticlient-sync" ''
        mkdir -p /opt/forticlient /etc/forticlient
        if [ "$(cat /opt/forticlient/.nix-src 2>/dev/null)" != "${forticlient}" ]; then
          cp -rT --no-preserve=ownership ${forticlient}/opt/forticlient /opt/forticlient
          chmod -R u+w /opt/forticlient
          echo ${forticlient} > /opt/forticlient/.nix-src
        fi
        [ -f /etc/forticlient/config.db ] || \
          install -m600 ${forticlient}/etc/forticlient/config.db /etc/forticlient/config.db
      '';
      gui = pkgs.writeShellScriptBin "forticlient-gui" ''
        # the GTK file picker (XML import) aborts without its GSettings schemas
        export XDG_DATA_DIRS="${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:$XDG_DATA_DIRS"
        exec /opt/forticlient/gui/FortiClient-linux-x64/FortiClient --no-sandbox "$@"
      '';
    in
    {
      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = libs;
      security.polkit.enable = true;
      environment.systemPackages = [ gui ];

      systemd.services.forticlient = {
        description = "FortiClient scheduler";
        wantedBy = [ "multi-user.target" ];
        after = [ "dbus.service" "network.target" ];
        path = with pkgs; [ iptables iproute2 procps coreutils ];
        serviceConfig = {
          ExecStartPre = "${sync}";
          ExecStart = "/opt/forticlient/fctsched";
          Restart = "always";
          RestartSec = 5;
          KillMode = "mixed";
        };
      };
    };
}
