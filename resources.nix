{ system
, inputs
, pkgs
, eval-pkgs
}:
let
  cleanSourceWithRegexes = src: regexes: with pkgs.lib; with builtins; cleanSourceWith {
    filter = (path: _:
      any (r: match r path == null) regexes
    );
    inherit src;
  };

  gaia-packages = import ./resources/gaia {
    inherit pkgs inputs;
  };

  ibc-packages = import ./resources/ibc-go {
    inherit pkgs inputs;
  };

  # Cosmos packages
  packages = rec {

    # Go packages
    stoml = pkgs.buildGoModule {
      name = "stoml";
      src = inputs.stoml-src;
      vendorSha256 = "sha256-37PcS7qVQ+IVZddcm+KbUjRjql7KIzynVGKpIHAk5GY=";
    };
    sconfig = pkgs.buildGoModule {
      name = "sconfig";
      src = inputs.sconfig-src;
      vendorSha256 = "sha256-ytpye6zEZC4oLrif8xe6Vr99lblule9HiAyZsSisIPg=";
    };
    cosmovisor = pkgs.buildGoModule {
      name = "cosmovisor";
      src = "${inputs.cosmos-sdk-src}/cosmovisor";
      vendorSha256 = "sha256-OAXWrwpartjgSP7oeNvDJ7cTR9lyYVNhEM8HUnv3acE=";
      doCheck = false;
    };
    simd = pkgs.buildGoModule {
      name = "simd";
      src = cleanSourceWithRegexes inputs.cosmos-sdk-src [ ".*cosmovisor.*" ];
      vendorSha256 = "sha256-kYoGoNT9W7x8iVjXyMCe72TCeq1RNILw53SmNpv/VXg=";
      doCheck = false;
    };
    osmosis = pkgs.buildGoModule {
      name = "osmosis";
      src = inputs.osmosis-src;
      vendorSha256 = "sha256-1z9XUOwglbi13w9XK87kQxLl4Hh+OcLZlXfw8QyVGZg=";
      preCheck = ''
        export HOME="$(mktemp -d)"
      '';
    };
    iris = pkgs.buildGoModule {
      name = "iris";
      src = inputs.iris-src;
      vendorSha256 = "sha256-PBbOuSe4GywD2WTgoZZ/1QDXH5BX2UHseXU2vPrJKX8=";
    };
    regen = pkgs.buildGoModule {
      name = "regen";
      subPackages = [ "app/regen" ];
      src = inputs.regen-src;
      vendorSha256 = "sha256-NH7flr8ExsfNm5JWpTGMmTRmcbhRjk9YYmqOnBRVmQM=";
      preCheck = ''
        export HOME="$(mktemp -d)"
      '';
    };
    evmos = pkgs.buildGoModule {
      name = "evmos";
      src = inputs.evmos-src;
      vendorSha256 = "sha256-c2MJL52achqlTbu87ZUKehnn92Wm6fTU/DIjadCUgH4=";
      preCheck = ''
        export HOME="$(mktemp -d)"
      '';
    };
    relayer = pkgs.buildGoModule {
      name = "relayer";
      src = inputs.relayer-src;
      vendorSha256 = "sha256-AelUjtgI9Oua++5TL/MEAAOgxZVxhOW2vEEhNdH3aBk=";
      doCheck = false;
    };

    ica = pkgs.buildGoModule {
      name = "ica";
      src = inputs.ica-src;
      vendorSha256 = "sha256-ykGo5TQ+MiFoeQoglflQL3x3VN2CQuyZCIiweP/c9lM=";
    };

    # Rust resources
    hermes = pkgs.rustPlatform.buildRustPackage {
      pname = "ibc-rs";
      version = "v0.13.0-rc.0";
      src = inputs.ibc-rs-src;
      nativeBuildInputs = with pkgs; [ rust-bin.stable.latest.default ];
      cargoSha256 = "sha256-lIMnZQw46prUFHlAzCWPkKzSNi4F9D+1+aG1vt/5Bvo=";
      doCheck = false;
    };

    # Misc
    gm = with pkgs; (import ./resources/gm) {
      inherit shellcheck lib makeWrapper gnused;
      inherit (inputs) ibc-rs-src;
      stoml = packages.stoml;
      sconfig = packages.sconfig;
      mkDerivation = stdenv.mkDerivation;
    };
    ts-relayer = ((import ./resources/ts-relayer) {
      inherit pkgs eval-pkgs;
      inherit (inputs) ts-relayer-src;
    }).ts-relayer;
    ts-relayer-setup = ((import ./resources/ts-relayer) {
      inherit pkgs eval-pkgs;
      inherit (inputs) ts-relayer-src;
    }).ts-relayer-setup;
  } // gaia-packages
  // ibc-packages;

  # Dev shells
  devShells = {
    nix-shell =
      pkgs.mkShell {
        shellHook = inputs.self.checks.${system}.pre-commit-check.shellHook;
        buildInputs = with pkgs; [
          rnix-lsp
          pass
          gnupg
        ];
      };
    cosmos-shell =
      pkgs.mkShell {
        buildInputs = with pkgs; [
          go
          rust-bin.stable.latest.default
          openssl
          shellcheck
        ] ++ builtins.attrValues packages;
      };
  };
in
{ inherit packages devShells; }
