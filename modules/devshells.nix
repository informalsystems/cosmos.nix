# Default shell provides the dependencies for working on this project. This is the shell you are put into by direnv.
# 
# 'cosmos-shell' allows individuals to get access to _all_ the packages in this flake by running:
# nix develop github:informalsystems/cosmos.nix
{
  perSystem = {
    pkgs,
    inputs',
    self',
    ...
  }: {
    devShells = {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          rnix-lsp
          alejandra
        ];
      };

      cosmos-shell = pkgs.mkShell {
        buildInputs = with pkgs;
          [
            go
            rust-bin.stable.latest.default
            openssl
            shellcheck
          ]
          ++ builtins.attrValues self'.packages;
      };
    };
  };
}
