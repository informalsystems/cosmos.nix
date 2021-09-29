{ pkgs, eval-pkgs, ts-relayer-src }:
let
  ibc-relayer =
    eval-pkgs.mkYarnPackage {
      name = "ts-relayer";
      src = ts-relayer-src;
      packageJSON = "${ts-relayer-src}/package.json";
      postConfigure = ''
        ${pkgs.yarn}/bin/yarn build
      '';
      yarnLock = "${ts-relayer-src}/yarn.lock";
    };
in
{
  ts-relayer = pkgs.writeShellScriptBin "ts-relayer" ''
    ${pkgs.nodejs}/bin/node ${ibc-relayer}/bin/ibc-relayer
  '';
  ts-relayer-setup = pkgs.writeShellScriptBin "ts-relayer-setup" ''
    ${pkgs.nodejs}/bin/node ${ibc-relayer}/bin/ibc-setup
  '';
}

