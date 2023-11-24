# Checks all the packages that this flake exports, and has a check that requires formatting of all sources
# For more info on 'nix flake check' see:
# https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake-check
{
  perSystem = {pkgs, self', ...}: {
    checks = {
      fmt-check = pkgs.stdenv.mkDerivation {
        name = "fmt-check";
        src = ../.;
        nativeBuildInputs = with pkgs; [alejandra shellcheck shfmt];
        checkPhase = ''
          alejandra -c .
        '';
        installPhase = ''
          mkdir "$out"
        '';
      };
    } 
    // self'.packages;
  };
}
