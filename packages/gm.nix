{
  pkgs,
  inputs,
}:
with pkgs;
let 
  # We could potentially expose stoml and sconfig in packages
  # but they are only used here, and are note technically cosmos
  # packages, so it is kind of confusing to provide them.
  stoml = pkgs.buildGoModule {
    name = "stoml";
    src = inputs.stoml-src;
    vendorSha256 = "sha256-i5m2I0IApTwD9XIjsDwU4dpNtwGI0EGeSkY6VbXDOAM=";
  };

  sconfig = pkgs.buildGoModule {
    name = "sconfig";
    src = inputs.sconfig-src;
    vendorSha256 = "sha256-J3L8gPtCShn//3mliMzvRTxRgb86f1pJ+yjZkF5ixEk=";
  };
in stdenv.mkDerivation {
    pname = "gm";
    version = "0.0.8";
    buildInputs = [makeWrapper];
    src = inputs.ibc-rs-src;
    configurePhase = "true";
    buildPhase = ''
      echo "installing gm from sources"
      mkdir -p $out/bin

      cp ./scripts/gm/bin/gm $out/bin/gm
      cp ./scripts/gm/bin/lib-gm $out/bin/lib-gm
      cp ./scripts/gm/bin/shell-support $out/bin/shell-support
    '';
    checkPhase = ''
      echo "checking bash scripts"
      ${shellcheck}/bin/shellcheck ./bin/gm
      ${shellcheck}/bin/shellcheck ./bin/lib-gm
      ${shellcheck}/bin/shellcheck ./bin/shell-support
    '';
    installPhase = ''
      echo "wrapping absolute paths to sconfig and stoml"
      wrapProgram $out/bin/gm \
        --prefix PATH : ${lib.makeBinPath [sconfig stoml gnused]} \
        --set LIB_GM $out/bin/lib-gm
    '';
  }
