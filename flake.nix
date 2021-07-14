{
  description = "A flake for building Hello World";

  inputs = {
    nixpkgs-src = {
      url = github:NixOS/nixpkgs/nixos-20.03;
    };

    ibc-rs-src = {
      flake = false;
      url = github:informalsystems/ibc-rs;
    };

    tendermint-rs-src = {
      flake = false;
      url = github:informalsystems/tendermint-rs;
    };

    gaia-src = {
      flake = false;
      url = github:cosmos/gaia;
    };

    cosmos-sdk-src = {
      flake = false;
      url = github:cosmos/cosmos-sdk;
    };

    ibc-go-src = {
      flake = false;
      url = github:cosmos/ibc-go;
    };
  };

  outputs = inputs: {
    packages.x86_64-linux =
      let
        pkgs = import inputs.nixpkgs-src { system = "x86_64-linux"; };

        sources = pkgs.stdenv.mkDerivation {
          name = "sources";
          unpackPhase = "true";
          buildPhase = "true";
          installPhase = ''
            mkdir -p $out
            ls -la $out
            ln -s ${inputs.ibc-rs-src} $out/ibc-rs
            ln -s ${inputs.tendermint-rs-src} $out/tendermint-rs
            ln -s ${inputs.gaia-src} $out/gaia
            ln -s ${inputs.cosmos-sdk-src} $out/cosmos-sdk
            ln -s ${inputs.ibc-go-src} $out/ibc-go
          '';
        };
      in
      {
        inherit sources;
      };
  };
}
