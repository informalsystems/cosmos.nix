{
  pkgs,
  hermes-src,
}:
pkgs.rustPlatform.buildRustPackage {
  pname = "hermes";
  version = "v1.7.4";
  src = hermes-src;
  nativeBuildInputs = with pkgs; [rust-bin.stable.latest.default] ++ lib.lists.optionals stdenv.isDarwin [darwin.apple_sdk.frameworks.Security];
  cargoSha256 = "sha256-oAsRn0THb5FU1HqgpB60jChGeQZdbrPoPfzTbyt3ozM=";
  doCheck = false;
}
