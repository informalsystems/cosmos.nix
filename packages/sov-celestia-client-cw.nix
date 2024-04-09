{
  buildCosmwasmContract,
  wasm-sov-celestia-src,
}:
buildCosmwasmContract {
  src = wasm-sov-celestia-src;
  pname = "sov-celestia-client-cw";
  name = "sov-celestia-client-cw";

  cargoLock = {
    lockFile = "${wasm-sov-celestia-src}/Cargo.lock";
    outputHashes = {
      "basecoin-0.1.0" = "sha256-3tXSQYGG6K81fxqd8G/5mKT2utqLDS0n0WoZIUbn+og=";
      "celestia-proto-0.1.0" = "sha256-iUgrctxdJUyhfrEQ0zoVj5AKIqgj/jQVNli5/K2nxK0=";
      # TODO set correct hash for const-rollup-config
      "const-rollup-config-0.3.0" = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      "ibc-0.51.0" = "sha256-6HcMSTcKx4y1hfKcXnzgiNM9FWdqUuUNnemAgS36Z1A=";
      "jmt-0.9.0" = "sha256-pq1v6FXS//6Dh+fdysQIVp+RVLHdXrW5aDx3263O1rs=";
      "nmt-rs-0.1.0" = "sha256-jcHbqyIKk8ZDDjSz+ot5YDxROOnrpM4TRmNFVfNniwU=";
      "risc0-cycle-utils-0.3.0" = "sha256-5dA62v1eqfyZBny4s3YlC2Tty7Yfd/OAVGfTlLBgypk=";
      "rockbound-1.0.0" = "sha256-xTaeBndRb/bYe+tySChDKsh4f9pywAExsdgJExCQiy8=";
      "sov-celestia-client-0.1.0" = "sha256-9i+CX08AS5r0Z6ggUDDGSl6jiQO9xDTUjIyt2VnAkT0=";
      "tendermint-0.32.0" = "sha256-FtY7a+hBvQryATrs3mykCWFRe8ABTT6cuf5oh9IBElQ=";
    };
  };
}
