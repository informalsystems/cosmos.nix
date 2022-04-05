{pkgs}: let
  sa = pkgs.writeShellApplication;
  format = sa {
    name = "format";
    text = builtins.readFile ./format.sh;
    runtimeInputs = with pkgs; [alejandra nix-linter];
  };
in [
  format
]
