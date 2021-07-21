{ pkgs, ibc-rs-src, crate2nix }:
let
  name = "ibc-rs";
  generatedCargoNix = (import "${crate2nix}/tools.nix" { inherit pkgs; }).generatedCargoNix;

  # Create the cargo2nix project
  project = pkgs.callPackage
    (generatedCargoNix {
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
project.workspaceMembers.ibc-relayer-cli.build

