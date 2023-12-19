# must use for generating python model from CosmWasm JSONShemas, lacks nix support (I guess to be moved to nixpkgs)
{
  mkPoetryApplication,
  datamodel-code-generator-src,
}: {
  mkPoetryApplication,
  datamodel-code-generator-src,
}:
mkPoetryApplication {
  projectDir = datamodel-code-generator-src;
  checkGroups = [];
}
