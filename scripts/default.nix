{pkgs}: let
  sa = pkgs.writeShellApplication;
  format = sa {
    name = "format";
    text = "alejandra .";
    runtimeInputs = with pkgs; [alejandra];
  };
in [
  format
]
