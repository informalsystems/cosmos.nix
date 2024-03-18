{
  osmosis,
  nix2container,
}:
nix2container.buildImage {
  name = "osmosis";
  config = {
    entrypoint = ["${osmosis}/bin/osmosisd"];
  };
}
