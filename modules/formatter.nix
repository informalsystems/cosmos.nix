# Provides the default formatter for 'nix fmt'
# https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-fmt
{
  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
  };
}
