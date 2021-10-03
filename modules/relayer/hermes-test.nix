{ pkgs, hermes, system }:
let
  sharedModule = {
    # Since it's common for CI not to have $DISPLAY available, we have to explicitly tell the tests "please don't expect any screen available"
    virtualisation.graphics = false;
  };
in
pkgs.nixosTest {
  inherit system;
  nodes = {
    relayer = {
      import = [ sharedModule ];
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
  };
}
