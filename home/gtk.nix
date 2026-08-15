{ pkgs, ... }:

let
  # Dracula's GTK theme was removed from nixpkgs (depended on the
  # unmaintained gtk-engine-murrine), so it's fetched directly here.
  dracula-gtk-theme = pkgs.stdenvNoCC.mkDerivation {
    pname = "dracula-gtk-theme";
    version = "unstable-2024-05-14";

    src = pkgs.fetchFromGitHub {
      owner = "dracula";
      repo = "gtk";
      rev = "81d0287950e8093dd8f8c753347763bce8588465";
      sha256 = "0pvcp5j6ay8vmc3ydbshy9gcz5xk7m3hwkcn84m9mrw6h4w2vfl1";
    };

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/share/themes/Dracula
      cp -r . $out/share/themes/Dracula
    '';
  };
in
{
  gtk = {
    enable = true;

    theme = {
      name = "Dracula";
      package = dracula-gtk-theme;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
      size = 24;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Dracula";
      icon-theme = "Papirus-Dark";
      cursor-theme = "capitaine-cursors";
      color-scheme = "prefer-dark";
    };
  };
}
