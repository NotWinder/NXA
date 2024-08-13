{
    XDG_DATA_HOME="$HOME/.local/share";
    XDG_STATE_HOME="$HOME/.local/state";
    XDG_CONFIG_HOME="$HOME/.config";
    XDG_CACHE_HOME="$HOME/.cache";
    XDG_DATA_DIRS="/usr/local/share";
    XDG_RUNTIME_DIR="/run/user/$UID";
    XDG_CONFIG_DIRS="/etc/xdg";

    ##X11
    XINITRC="$XDG_CONFIG_HOME/X11/xinitrc";
    ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors";
    XCOMPOSECACHE="$XDG_CACHE_HOME/X11/xcompose";

    ##NPM
    NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc";

    ##Gtk
    GTK_RC_FILES="$XDG_CONFIG_HOME/gtk-1.0/gtkrc";
    GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc";

    ##Rust
    CARGO_HOME="$XDG_DATA_HOME/cargo";
    RUSTUP_HOME="$XDG_DATA_HOME/rustup";

    ##Colors
    CLICOLOR=1;
    LS_COLORS="no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:";
    LESS_TERMCAP_mb="$'\E[01;31m'";
    LESS_TERMCAP_md="$'\E[01;31m'";
    LESS_TERMCAP_me="$'\E[0m'";
    LESS_TERMCAP_se="$'\E[0m'";
    LESS_TERMCAP_so="$'\E[01;44;33m'";
    LESS_TERMCAP_ue="$'\E[0m'";
    LESS_TERMCAP_us="$'\E[01;32m'";

    ##Others
    GNUPGHOME="'$XDG_DATA_HOME'/gnupg";
    WGETRC="'$XDG_CONFIG_HOME/wgetrc'";
    WINEPREFIX="'$XDG_DATA_HOME'/wineprefixes/64-bit";
    PATH="$PATH:/usr/local/go/bin";
}
