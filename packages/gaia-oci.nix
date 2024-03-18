{
  gaia,
  nix2container,
}:
nix2container.buildImage {
  name = "gaia";
  config = {
    entrypoint = ["${gaia}/bin/gaiad"];
  };
}
