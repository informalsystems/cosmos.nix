{
  centauri,
  nix2container,
}:
nix2container.buildImage {
  name = "centauri";
  config = {
    entrypoint = ["${centauri}/bin/centaurid"];
  };
}
