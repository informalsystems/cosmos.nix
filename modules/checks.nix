{
  perSystem = {pkgs, self, ...} {
    checks = {
      fmt-check = pkgs.stdenv.mkDerivation {
        name = "fmt-check";
        src = ../;
        nativeBuildInputs = with pkgs; [alejandra shellcheck shfmt];
        checkPhase = ''
          alejandra -c .
        '';
      };
    } // self.packages;
  };
}
