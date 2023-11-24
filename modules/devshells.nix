{
  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    devShells = {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          rnix-lsp
          alejandra
          go
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
          ++ builtins.attrValues packages;
      };
    };
  };
}
