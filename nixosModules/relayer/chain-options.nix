{lib}:
with lib; {
  # Required
  id = mkOption {
    type = types.str;
    description = ''
      Specify the chain ID.
    '';
  };
  rpc_addr = mkOption {
    type = types.str;
    description = ''
      Specify the RPC address and port where the chain RPC server listens on.
    '';
  };
  grpc_addr = mkOption {
    type = types.str;
    description = ''
      Specify the GRPC address and port where the chain GRPC server listens on.
    '';
  };

  event_source = mkOption {
    type = types.submodule {
      options = {
        mode = mkOption {
          type = types.enum ["push" "pull"];
          default = "push";
          description = ''
            Specify the mode of the event source.
          '';
        };
        url = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Specify the WebSocket address and port where the chain WebSocket server listens on.
          '';
        };
        batch_delay = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Specify the delay between batches of events.
          '';
        };
        interval = mkOption {
          type = types.nullOr types.str;
          default = null;

          description = ''
            Specify the interval between requests for new events.
          '';
        };
      };
    };
  };

  account_prefix = mkOption {
    type = types.str;
    description = ''
      Specify the prefix used by the chain.
    '';
  };
  key_name = mkOption {
    type = types.str;
    description = ''
      Specify the name of the private key to use for signing transactions. Required
      <link xlink:href="httpsg://hermes.informal.systems/commands/keys/index.html#adding-keys">
        See the Adding Keys chapter
      </link>.
    '';
  };
  key_store_type = mkOption {
    type = types.enum ["Test" "Memory"];
    default = "Test";
  };
  default_gas = mkOption {
    type = types.ints.positive;
    default = 100000000;
  };
  gas_price = mkOption {
    type = types.submodule {
      options = {
        price = mkOption {
          type = types.float;
          description = ''
            Specify the price per gas used of the fee to submit a transaction.
          '';
        };
        denom = mkOption {
          type = types.str;
          description = ''
            Specify the denomination of the fee to submit a transaction.
          '';
        };
      };
    };
  };

  address_type = mkOption {
    type = types.submodule {
      options = {
        derivation = mkOption {
          type = types.enum ["cosmos"];
          default = "cosmos";
          description = ''
            Specify the derivation type of the address.
          '';
        };
      };
    };
  };

  # Optional
  rpc_timeout = mkOption {
    type = types.str;
    default = "10s";
    description = ''
      Specify the maximum amount of time (duration) that the RPC requests should
      take before timing out.
    '';
  };
  store_prefix = mkOption {
    type = types.str;
    default = "ibc";
    description = ''
      Specify the store prefix used by the on-chain IBC modules.
    '';
  };
  max_gas = mkOption {
    type = types.ints.positive;
    default = 3000000;
    description = ''
      Specify the maximum amount of gas to be used as the gas limit for a transaction.
    '';
  };
  gas_multiplier = mkOption {
    type = types.float;
    default = 0.1;
    description = ''
      Specify by ratio to increase the gas estimate used to compute the fee,
      to account for potential estimation error.
    '';
  };
  max_msg_num = mkOption {
    type = types.ints.positive;
    default = 30;
    description = ''
      Specify how many IBC messages at most to include in a single transaction.
    '';
  };
  max_tx_size = mkOption {
    type = types.ints.positive;
    default = 2097152;
    description = ''
      Specify the maximum size, in bytes, of each transaction that Hermes will submit.
    '';
  };
  max_block_time = mkOption {
    type = types.str;
    default = "30s";
    description = ''
      Specify the maximum amount of time to wait for a new block to be committed.
    '';
  };
  clock_drift = mkOption {
    type = types.str;
    default = "5s";
    description = ''
      Specify the maximum amount of time to tolerate a clock drift.
      The clock drift parameter defines how much new (untrusted) header's time
      can drift into the future.
    '';
  };
  trusting_period = mkOption {
    type = types.str;
    default = "14days";
    description = ''
      Specify the amount of time to be used as the light client trusting period.
      It should be significantly less than the unbonding period
      (e.g. unbonding period = 3 weeks, trusting period = 2 weeks).
    '';
  };
  trusted_node = mkOption {
    type = types.bool;
    default = false;
  };
  ccv_consumer_chain = mkOption {
    type = types.bool;
    default = false;
  };

  type = mkOption {
    type = types.enum ["CosmosSdk"];
    default = "CosmosSdk";
    description = ''
      Specify the type of the chain.
    '';
  };

  trust_threshold = mkOption {
    default = {
      numerator = "1";
      denominator = "3";
    };
    type = types.submodule {
      options = {
        numerator = mkOption {
          type = types.str;
          default = "1";
          description = ''
            Specify the trust threshold for the light client, ie. the maximum fraction of validators
            which have changed between two blocks.
            Warning: This is an advanced feature! Modify with caution.
          '';
        };
        denominator = mkOption {
          type = types.str;
          default = "3";
          description = ''
            Specify the trust threshold for the light client, ie. the maximum fraction of validators
            which have changed between two blocks.
            Warning: This is an advanced feature! Modify with caution.
          '';
        };
      };
    };
  };
}
