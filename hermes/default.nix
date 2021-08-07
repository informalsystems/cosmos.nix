{ pkgs, ibc-rs-src, generateCargoNix }:
let
  name = "ibc-rs";

  # Create the cargo2nix project
  cargoNix = pkgs.callPackage
    (generateCargoNix {
      inherit name;
      src = ibc-rs-src;
    })
    {
      # Individual crate overrides
      defaultCrateOverrides = pkgs.defaultCrateOverrides // {
        ${name} = _: {
          nativeBuildInputs = with pkgs; [ rustc cargo pkgconfig ];
          buildInputs = with pkgs; [ openssl ];
        };
        openssl-sys = _: {
          nativeBuildInputs = with pkgs; [ rustc cargo pkgconfig ];
          buildInputs = with pkgs; [ openssl ];
        };
      };
    };
in
cargoNix.workspaceMembers.ibc-relayer-cli.build
