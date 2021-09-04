{ pkgs, ibc-rs-src }:
pkgs.stdenv.mkDerivation {
  name = "sources";
  unpackPhase = "true";
  buildPhase = "true";
  checkPhase = ''
    ${pkgs.shellcheck} ${ibc-rs-src}/scripts/gm/bin/gm
    ${pkgs.shellcheck} ${ibc-rs-src}/scripts/gm/bin/lib-gm
    ${pkgs.shellcheck} ${ibc-rs-src}/scripts/gm/bin/shell-support
  '';
  installPhase = ''
    mkdir -p $out/bin

    ls -la $out
    ln -s ${ibc-rs-src}/scripts/gm/bin/gm $out/bin/gm
    ln -s ${ibc-rs-src}/scripts/gm/bin/lib-gm $out/bin/lib-gm
    ln -s ${ibc-rs-src}/scripts/gm/bin/shell-support $out/bin/shell-support
  '';
}
