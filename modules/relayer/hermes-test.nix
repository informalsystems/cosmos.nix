{ pkgs, hermes, system }:
let
  sharedModule = {
    # Since it's common for CI not to have $DISPLAY available, we have to explicitly tell the tests "please don't expect any screen available"
    virtualisation.graphics = false;
  };
  defaultRestPort = 3000;
  # defaultMetricsPort = 3001;
in
pkgs.nixosTest {
  inherit system;
  nodes = {
    relayer = {
      imports = [ sharedModule ./hermes.nix ];
      services.hermes = {
        enable = true;
        package = hermes;
        chains = [
          {
            id = "ibc-1";
            rpc-address = "http://127.0.0.1:26557";
            grpc-address = "http://127.0.0.1:9091";
            websocket-address = "ws://127.0.0.1:26557/websocket";
            account-prefix = "cosmos";
            key-name = "testkey";
            gas-price = 0.001;
            gas-denomination = "stake";
          }
        ];
      };
    };
    client = { imports = [ sharedModule ]; };
  };
  testScript = with builtins; ''
    import json
    start_all()
    relayer.wait_for_open_port(${toString defaultRestPort})

    actual = json.loads(
        client.succeed(
            "${pkgs.curl}/bin/curl http://relayer:${toString defaultRestPort}"
        )
    )

    assert actual == "", "rest port should be running"
  '';
}
