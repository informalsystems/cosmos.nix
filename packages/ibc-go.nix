{ inputs
, libwasmvm_1_5_0
, mkCosmosGoApp
, wasmdPreFixupPhase
,
}:
with inputs;
builtins.mapAttrs (_: mkCosmosGoApp)
{
  ibc-go-v2-simapp = {
    name = "simapp";
    src = ibc-go-v2-src;
    rev = ibc-go-v2-src.rev;
    version = "v2.4.1";
    vendorHash = "sha256-edKJYHKYOkpdXs1xHEdFjlNT1m4IhhhyyzIKjYvhE38=";
    tags = [ "netgo" ];
    engine = "tendermint/tendermint";
  };

  ibc-go-v3-simapp = {
    name = "simapp";
    version = "v3.3.0";
    src = ibc-go-v3-src;
    rev = ibc-go-v3-src.rev;
    vendorHash = "sha256-jI1Ky8SzwZ3PhAZrDJQknAWUnu0G9rktAyaE4J/o8Cw=";
    tags = [ "netgo" ];
    engine = "tendermint/tendermint";
  };

  ibc-go-v4-simapp = {
    name = "simapp";
    version = "v4.2.0";
    src = ibc-go-v4-src;
    rev = ibc-go-v4-src.rev;
    vendorHash = "sha256-M8N6IPBnhOQp4LsCgdKc0NOtdeLNkAcXtGsvHS00D+g=";
    tags = [ "netgo" ];
    engine = "tendermint/tendermint";
  };

  ibc-go-v5-simapp = {
    name = "simapp";
    version = "v5.1.0";
    src = ibc-go-v5-src;
    rev = ibc-go-v5-src.rev;
    vendorHash = "sha256-KajTi+hCMM8AoLsGmWV7qVGbYA8vZhn+0tmG20zJgPI=";
    tags = [ "netgo" ];
    engine = "tendermint/tendermint";
    excludedPackages = [ "./e2e" ];
  };

  ibc-go-v6-simapp = {
    name = "simapp";
    version = "v6.1.0";
    src = ibc-go-v6-src;
    rev = ibc-go-v6-src.rev;
    vendorHash = "sha256-hP/DTNkB1NI7yZZDn5tYy/9jYIb3BqESxIG2A4wgjJU";
    tags = [ "netgo" ];
    engine = "tendermint/tendermint";
    excludedPackages = [ "./e2e" ];
  };

  # If the modules/apps/callbacks is needed, it must be defined in a separate nix
  # package that loads only the given subdirectory as source
  ibc-go-v7-simapp = {
    name = "simd";
    version = "v7.3.0";
    src = ibc-go-v7-src;
    rev = ibc-go-v7-src.rev;
    vendorHash = "sha256-Wn7krfvF7E93g4KnGZ8iXaSjc+kmGgQ8Jb5egWNMQg8=";
    goVersion = "1.20";
    tags = [ "netgo" ];
    engine = "cometbft/cometbft";
    excludedPackages = [ "./e2e" "./modules/apps/callbacks" ];
  };

  # If the modules/apps/callbacks and/or modules/capability are needed,
  # they must each be defined in a separate nix package that loads only
  # the given subdirectory as source
  ibc-go-v8-simapp = {
    name = "simd";
    version = "v8.1.0";
    src = ibc-go-v8-src;
    rev = ibc-go-v8-src.rev;
    vendorHash = "sha256-KmuidyqJXwZOg+cnas/5O6awcKeEgzsByDg9rClADUQ=";
    goVersion = "1.21";
    tags = [ "netgo" ];
    engine = "cometbft/cometbft";
    excludedPackages = [ "./e2e" "./modules/apps/callbacks" "./modules/capability" ];
  };

  # If the modules/apps/callbacks and/or modules/capability are needed,
  # they must each be defined in a separate nix package that loads only
  # the given subdirectory as source
  ibc-go-v7-wasm-simapp = {
    name = "simd";
    version = "v7.3.0-wasm";
    src = "${ibc-go-v7-wasm-src}/modules/light-clients/08-wasm";
    rev = ibc-go-v7-wasm-src.rev;
    vendorHash = "sha256-oQ7KSQzl/BlknSYmQxf0PVidK9q36IA0wJk9DZN3xwk=";
    goVersion = "1.21";
    tags = [ "netgo" ];
    engine = "cometbft/cometbft";
    preFixup = ''
      ${wasmdPreFixupPhase libwasmvm_1_5_0 "simd"}
    '';
    buildInputs = [ libwasmvm_1_5_0 ];
  };

  ibc-go-v8-wasm-simapp = {
    name = "simd";
    version = "v8.0.0-wasm";
    src = "${ibc-go-v8-wasm-src}/modules/light-clients/08-wasm";
    rev = ibc-go-v8-wasm-src.rev;
    vendorHash = "sha256-Q8SJ6MsgPwRuuuDZCs1CY60lXcg8kSIEzVy8QxnbsuE=";
    goVersion = "1.21";
    tags = [ "netgo" ];
    engine = "cometbft/cometbft";
    preFixup = ''
      ${wasmdPreFixupPhase libwasmvm_1_5_0 "simd"}
    '';
    buildInputs = [ libwasmvm_1_5_0 ];
  };
}
