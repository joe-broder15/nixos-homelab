{ config, pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./gtk.nix
  ];

  home.username = "zircon";
  home.homeDirectory = "/home/zircon";

  # Do not change; tracks the Home Manager release this config was written for.
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    spotify
    tmux
    vscode
    brave
    terminator
    nerd-fonts.gohufont
    discord
    signal-desktop
    protonmail-desktop
    proton-vpn
    keepassxc
    claude-code
    gh
    zsh
    gnomeExtensions.dash-to-panel
  ];

  home.file = {
    # GohuFont is a bitmap font; point size must be 11 or 14.
    ".config/terminator/config".text = ''
      [global_config]
      [keybindings]
      [profiles]
        [[default]]
          use_system_font = False
          font = GohuFont 11 Nerd Font Mono 11
      [layouts]
        [[default]]
          [[[window0]]]
            type = Window
            parent = ""
          [[[child1]]]
            type = Terminal
            parent = window0
      [plugins]
    '';
  };

  home.sessionVariables = { };

  # GNOME extensions installed via home.packages must be explicitly enabled by UUID.
  dconf.settings."org/gnome/shell".enabled-extensions = [
    pkgs.gnomeExtensions.dash-to-panel.extensionUuid
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "joe-broder15";
      email = "joe.broder@proton.me";
    };
  };

  programs.home-manager.enable = true;
}
