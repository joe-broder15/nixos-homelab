{ pkgs, ... }:

{
  # Match the terminal font configured for Terminator (see zircon.nix's
  # home.file for the Terminator config).
  # terminal.integrated.fontFamily is parsed as CSS font-family, where an
  # unquoted identifier can't contain whitespace or digits; since the family
  # name here has both, it must be single-quoted or VS Code silently falls
  # back to its default terminal font instead of erroring.
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.userSettings = {
      "terminal.integrated.fontFamily" = "'GohuFont 11 Nerd Font Mono'";
      "terminal.integrated.fontSize" = 12;
    };
  };
}
