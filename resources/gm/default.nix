{ shellcheck, makeWrapper, mkDerivation, lib, ibc-rs-src, stoml, sconfig }:
mkDerivation {
  pname = "gm";
  version = "0.7.0";
  buildInputs = [ makeWrapper ];
  src = ibc-rs-src;
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
      --prefix PATH : ${lib.makeBinPath [ sconfig stoml ]} \
      --set LIB_GM_PATH $out/bin
  '';
  patches = [ ./gm_lib.patch ];
}
