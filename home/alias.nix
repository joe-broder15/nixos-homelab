{ ... }:

{
  programs.zsh.shellAliases = {
    ll = "ls -lhrt";
    gs = "git status";
    # Reload the zircon Home Manager config from this repo's flake.
    hmr = "home-manager switch --flake ~/nixos-configs#zircon";
    # Pull latest changes first, then reload.
    hmp = "git -C ~/nixos-configs pull && home-manager switch --flake ~/nixos-configs#zircon";
    # Jump to the home directory.
    home = "cd ~";
    # Jump to the Synology CIFS share.
    syno = "cd /mnt/Library1";
  };
}
