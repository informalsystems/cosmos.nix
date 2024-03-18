{
  lib,
  nix-std,
  cfg,
}:
with lib; {
  options = {
    config = import ./config-options.nix {inherit lib;};
    toml = mkOption {type = types.unique {message = "only one toml output";} types.str;};
  };
  config = {
    toml = let
      # remove `null` from toml render
      sanitizedCfg = filterAttrsRecursive (_: v: v != null) cfg.config;
    in
      nix-std.lib.serde.toTOML sanitizedCfg;
  };
}
