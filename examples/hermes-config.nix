{inputs, ...}: let
in {
  perSystem = {
    pkgs,
    cosmosLib,
    ...
  }: {
    packages.example-hermes-config = pkgs.writeTextFile {
      name = "config.toml";
      text =
        (cosmosLib.evalHermesModule {
          modules = [
            {
              config.hermes.global.log_level = "trace";
              config.hermes.chains = [
                {
                  id = "a";
                  rpc_addr = http://127.0.0.1:26657;
                  grpc_addr = http://127.0.0.1:9090;
                  account_prefix = "cosmos";
                  address_type = {derivation = "cosmos";};
                  event_source = {
                    mode = "pull";
                    interval = "1s";
                  };
                  gas_price = {
                    price = 1.0;
                    denom = "stake";
                  };
                  key_name = "cosmos";
                  trust_threshold = {
                    numerator = "1";
                    denominator = "3";
                  };
                }
              ];
            }
          ];
        })
        .config
        .hermes
        .toml;
    };
  };
}
