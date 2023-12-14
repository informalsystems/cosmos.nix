{
  inputs,
  mkCosmosGoApp,
}:
with inputs;
  builtins.mapAttrs (_: mkCosmosGoApp)
  {
    stride = {
      name = "stride";
      version = "v8.0.0";
      src = stride-src;
      vendorHash = "sha256-z4vT4CeoJF76GwljHm2L2UF1JxyEJtvqAkP9TmIgs10=";
      engine = "tendermint/tendermint";

      doCheck = false;
    };

    stride-consumer = {
      name = "stride-consumer";
      version = "v12.1.0";
      src = stride-consumer-src;
      vendorHash = "sha256-tH56oB9Lw0/+ypWRj9n8o/QHPcLQuuNkzD4zFy6bW04=";
      engine = "cometbft/cometbft";

      doCheck = false;
    };

    stride-consumer-no-admin = {
      name = "stride-consumer-no-admin";
      version = "v12.1.0";
      src = stride-consumer-src;
      vendorHash = "sha256-tH56oB9Lw0/+ypWRj9n8o/QHPcLQuuNkzD4zFy6bW04=";
      engine = "cometbft/cometbft";

      patches = [../patches/stride-no-admin-check.patch];
      doCheck = false;
    };

    stride-no-admin = {
      name = "stride-no-admin";
      version = "v8.0.0";
      src = stride-src;
      vendorHash = "sha256-z4vT4CeoJF76GwljHm2L2UF1JxyEJtvqAkP9TmIgs10=";
      engine = "tendermint/tendermint";

      patches = [../patches/stride-no-admin-check.patch];
      doCheck = false;
    };
  }
