# This module might be slightly confusing, since nixos modules are isntantiated via a "fixed point"
# which is effectively a loop that accumulates attributes.
#
# because of this "fixed point" and lazyness we are able to set the "options"
# attribute, which declares the schema for the module and is required at the
# beginning of the loop, and the "config" attribute which is a serialization of
# the accumulated configuration into a toml file and intuitively happens at the
# end of the loop
#
# TL;DR:
# - 'options' represents the schema for the hermes configuration module
# - 'config.toml' represents the a final serialization of the actual configuration into a toml file
# - for more information on nixos modules see https://nix.dev/tutorials/module-system/module-system.html
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
    toml = nix-std.lib.serde.toTOML cfg.config;
  };
}
