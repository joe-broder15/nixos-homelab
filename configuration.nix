# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

    # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    cifs-utils
    qbittorrent
    wireguard-tools
    plex
    htop
    neofetch
    git
    tree
    resilio-sync
  ];


  networking = {
    # System hostname broadcast on the network.
    hostName = "nixos";

    # Manage interfaces dynamically via NetworkManager.
    networkmanager.enable = true;

    # WireGuard interface definition sourced from disk.
    wg-quick.interfaces.wg0.configFile = "/etc/nixos/wireguard/wg0.conf";

    # Provide NAT for the WireGuard clients.
    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = "ens18";
      internalInterfaces = [ "wg0" ];
    };
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services = {
    # Keyboard layout for any X11 sessions.
    xserver = {
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # Secure remote management via SSH.
    openssh.enable = true;

    # Headless BitTorrent client with web UI.
    qbittorrent = {
      enable = true;
      openFirewall = true;
      user = "user";
    };

    # Plex media server for streaming with firewall openings.
    plex = {
      enable = true;
      user = "user";
      openFirewall = true;
    };

    resilio = {
			enable=true;
			enableWebUI=true;
			httpListenAddr = "192.168.1.101";  
    	httpListenPort = 9000;
    };

		dnsmasq = {
      enable = true;
      extraConfig = ''
        interface=wg0
      '';
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    description = "user";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  # map network shares
  fileSystems."/mnt/Library1" = {
    device = "//192.168.1.99/Library1";
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in
      [ "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100" ];
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
