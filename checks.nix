{
  packages,
  inputs,
  system,
}:
{
  pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
    src = ./.;
    hooks = {
      alejandra.enable = true;
    };
  };
}
// packages
# adding packages here ensures that every attr gets built on check

