{ pkgs, cfg }:
with cfg;
let
  rest = with cfg.rest;
    ''
      [rest]
      enabled = ${enabled}
      host = '${host}'
      port = ${port}
    '';

  telemetry = with cfg.telemetry;
    ''
      [telemetry]
      enabled = ${enabled}
      host = '${host}'
      port = ${port}
    '';

  chain-fold-op = accumulator: chain:
    with chain;
    accumulator ++
    ''
      [[chains]]
      id = '${id}'
      rpc_addr = '${rpc-address}'
      grpc_addr = '${grpc-address}'
      websocket_addr = '${websocket-address}'
      rpc_timeout = '${rpc-timeout}'
      account_prefix = '${account-prefix}'
      key_name = '${key-name}'
      store_prefix = '${store-prefix}'
      max_gas = ${max-gas}
      gas_price = { price = ${gas-price}, denom = '${gas-denomination}' }
      gas_adjustment = ${gas-adjustment}
      max_msg_num = ${max-message-number}
      max_tx_size = ${max-transaction-size}
      clock_drift = '${clock-drift}'
      trusting_period = '${trusting-period}'
      trust_threshold = {
        numerator = '${trusting-threshold-numerator}',
        denominator = '${trusting-threshold-numerator}'
      }
    '';
  chains = builtins.foldl' chain-fold-op "" cfg.chains;
in
pkgs.writeTextFile {
  name = "config.toml";
  text = ''
    [global]
    strategy = '${strategy}'
    filter = '${filter}
    log_level = '${log-level}'
    clear_packets_interval = ${clear-packets-interval}
    tx_confirmation = ${tx-confirmation}
  ''
  ++ rest
  ++ telemetry
  ++ chains;
}

