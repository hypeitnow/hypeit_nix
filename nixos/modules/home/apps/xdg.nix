{config, ...}: let
  browser = ["brave.desktop"];

  # XDG MIME types
  associations = {
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/x-extension-xht" = browser;
    "application/x-extension-xhtml" = browser;
    "application/xhtml+xml" = browser;
    "text/html" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/chrome" = ["chromium-browser.desktop"];
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/unknown" = browser;

    "audio/*" = ["mpv.desktop"];
    "video/*" = ["mpv.dekstop"];
    "image/*" = ["imv.desktop"];
    "application/json" = browser;
    "application/pdf" = ["org.pwmt.zathura.desktop.desktop"];
    "x-scheme-handler/discord" = ["discordcanary.desktop"];
    "x-scheme-handler/spotify" = ["spotify.desktop"];
    "x-scheme-handler/tg" = ["telegramdesktop.desktop"];
  };
in {
  xdg = {
    enable = true;
    cacheHome = config.home.homeDirectory + "/.local/cache";

    mimeApps = {
      enable = true;
      defaultApplications = associations;
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
      };
    };
    configFile."black".text = ''
      [tool.black]
      line-length = 80
    '';

    configFile."environment.d/ssh_askpass.conf".text = ''
      SSH_ASKPASS="${pkgs.ksshaskpass}/bin/ksshaskpass"
    '';

    configFile."autostart/ssh-add.desktop".text = ''
      [Desktop Entry]
      Exec=ssh-add -q
      Name=ssh-add
      Type=Application
    '';

    configFile."plasma-workspace/env/ssh-agent-startup.sh" = {
      text = ''
        #!/bin/sh
        [ -n "$SSH_AGENT_PID" ] || eval "$(ssh-agent -s)"
      '';
      executable = true;
    };

    configFile."plasma-workspace/shutdown/ssh-agent-shutdown.sh" = {
      text = ''
        #!/bin/sh
        [ -z "$SSH_AGENT_PID" ] || eval "$(ssh-agent -k)"
      '';
      executable = true;
    };

    configFile."mpv/input.conf" = {
      text = ''
        PGDWN osd-msg-bar seek 5 exact
        PGUP osd-msg-bar seek -5
        Shift+PGDWN osd-msg-bar seek 30 exact
        Shift+PGUP osd-msg-bar seek -30 exact
        RIGHT osd-msg-bar seek 1 exact
        LEFT osd-msg-bar seek -1 exact
        Shift+RIGHT osd-msg-bar seek 1 exact
        Shift+LEFT osd-msg-bar seek -1 exact
        UP add volume 2
        DOWN add volume -2
        n playlist-next
        p playlist-prev
      '';
    };

    configFile."mpv/mpv.conf" = {
      text = ''
        osd-level=2
        volume=20
        volume-max=150
        autofit=100%x98%
        geometry=+50%-25
        #window-maximized
        # see https://github.com/mpv-player/mpv/issues/10229
      '';
    };
    configFile."autostart/keybase_autostart.desktop".force = true;

    # default keybase_autostart.desktop doesn't run on NVIDIA in sync mode
    # without --disable-gpu-sandbox.
    configFile."autostart/keybase_autostart.desktop".text = ''
      [Desktop Entry]
      Comment[en_US]=Keybase Filesystem Service and GUI
      Comment=Keybase Filesystem Service and GUI
      Exec=env KEYBASE_AUTOSTART=1 keybase-gui --disable-gpu-sandbox
      GenericName[en_US]=
      GenericName=
      MimeType=
      Name[en_US]=Keybase
      Name=Keybase
      Path=
      StartupNotify=true
      Terminal=false
      TerminalOptions=
      Type=Application
      X-DBUS-ServiceName=
      X-DBUS-StartupType=
      X-KDE-SubstituteUID=false
      X-KDE-Username=
    '';
  };

  services.keybase.enable = true;
  services.kbfs.enable = true;
  # thanks to tejing on IRC for clueing me in to .force here: it will
  # overwrite any existing file.

}