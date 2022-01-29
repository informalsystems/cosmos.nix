{ inputs }:
# In this case inputs is mostly used in order to reference go sources (suffixed by src in this file).
# For reference check the inputs attrset in flake.nix!
with inputs;
let go-project-srcs =
  {
    gaia6 = { inputName = "gaia6-src"; storePath = "${gaia6-src}"; };
    gaia5 = { inputName = "gaia5-src"; storePath = "${gaia5-src}"; };
    gaia4 = { inputName = "gaia4-src"; storePath = "${gaia4-src}"; };
    stoml = {
      inputName = "stoml-src";
      storePath = "${stoml-src}";
    };
    sconfig = {
      inputName = "sconfig-src";
      storePath = "${sconfig-src}";
    };
    cosmovisor = {
      inputName = "cosmos-sdk-src";
      storePath = "${cosmos-sdk-src}/cosmovisor";
    };
    cosmos-sdk = { inputName = "cosmos-sdk-src"; storePath = "${cosmos-sdk-src}"; };
    osmosis = {
      inputName = "osmosis-src";
      storePath = "${osmosis-src}";
    };
    iris = {
      inputName = "iris-src";
      storePath = "${iris-src}";
    };
    regen = {
      inputName = "regen-src";
      storePath = "${regen-src}";
    };
    evmos = {
      inputName = "evmos-src";
      storePath = "${evmos-src}";
    };
    relayer = { inputName = "relayer-src"; storePath = "${relayer-src}"; };
    # thor = { inputName = "thor-src"; storePath = "${thor-src}"; };
    # juno = { inputName = "juno-src"; storePath = "${juno-src}"; };
  };
in
with builtins;
concatStringsSep " "
  (attrValues (builtins.mapAttrs (name: value: "${name}:${value.inputName}${value.storePath}") go-project-srcs))
