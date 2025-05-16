{
  pkgs,
  hermes-src,
}:
pkgs.rustPlatform.buildRustPackage {
  pname = "hermes";
  version = "v1.7.4";
  src = hermes-src;
  cargoLock = {
    lockFile = "${hermes-src}/Cargo.lock";
  };
  nativeBuildInputs = with pkgs; [rust-bin.stable.latest.default];
  buildInputs = with pkgs;
    lib.lists.optionals stdenv.isDarwin
    [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];
  cargoSha256 = "sha256-oAsRn0THb5FU1HqgpB60jChGeQZdbrPoPfzTbyt3ozM=";
  doCheck = false;
  meta = {
    mainProgram = "hermes";
  };
}
