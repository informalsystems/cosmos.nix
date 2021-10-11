{ pkgs, hermes, gaia, system }:
let
  sharedModule = {
    # Since it's common for CI not to have $DISPLAY available, we have to explicitly tell the tests "please don't expect any screen available"
    virtualisation.graphics = false;
    networking.useDHCP = false;
    networking.interfaces.eth0.useDHCP = false;
  };
  defaultRestPort = 3000;
  defaultMetricsPort = 3001;
  ibc1-genesis = pkgs.writeTextFile {
    name = "ibc1-genesis";
    text = (builtins.readFile ./ibc-1.genesis.json);
  };
  ibc2-genesis = pkgs.writeTextFile {
    name = "ibc2-genesis";
    text = (builtins.readFile ./ibc-2.genesis.json);
  };
in
pkgs.nixosTest {
  inherit system;
  name = "hermes-module-test";
  nodes = {
    relayer = {
      imports = [ sharedModule ../relayer/hermes.nix ];

      networking.firewall = {
        enable = true;
        trustedInterfaces = [ "eth0" ];
        interfaces = {
          eth0 = {
            allowedTCPPorts = [ defaultMetricsPort defaultRestPort ];
          };
        };
      };

      services.hermes = {
        enable = true;
        package = hermes;
        rest.port = defaultRestPort;
        telemetry.port = defaultMetricsPort;
        chains = [
          {
            id = "ibc-1";
            rpc-address = "http://validator1:26557";
            grpc-address = "http://validator1:9091";
            websocket-address = "http://validator1:26557/websocket";
            account-prefix = "cosmos";
            key-name = "testkey";
            gas-price = 0.001;
            gas-denomination = "stake";
          }
          {
            id = "ibc-2";
            rpc-address = "http://validator2:26557";
            grpc-address = "http://validator2:9091";
            websocket-address = "http://validator2:26557/websocket";
            account-prefix = "cosmos";
            key-name = "testkey";
            gas-price = 0.001;
            gas-denomination = "stake";
          }
        ];
      };
    };

    validator1 = {
      imports = [ sharedModule ../chains/gaia.nix ];
      networking.firewall = {
        enable = true;
        trustedInterfaces = [ "eth1" ];
        interfaces = {
          eth1 = {
            allowedTCPPorts = [ 26557 9091 ];
          };
        };
      };
      services.gaia = {
        enable = true;
        package = gaia;
        chain-id = "ibc-1";
        genesis-file = ibc1-genesis;
        rpc-addr = "tcp://127.0.0.1:26557";
        grpc-addr = "tcp://127.0.0.1:9091";
      };
    };

    validator2 = {
      imports = [ sharedModule ../chains/gaia.nix ];
      networking.firewall = {
        enable = true;
        trustedInterfaces = [ "eth1" ];
        interfaces = {
          eth1 = {
            allowedTCPPorts = [ 26557 9091 ];
          };
        };
      };
      services.gaia = {
        enable = true;
        package = gaia;
        chain-id = "ibc-2";
        genesis-file = ibc2-genesis;
        rpc-addr = "tcp://127.0.0.1:26557";
        grpc-addr = "tcp://127.0.0.1:9091";
      };
    };

    client = { imports = [ sharedModule ]; };
  };
  testScript = with builtins; ''
    import json
    start_all()

    validator1.wait_for_open_port(26557)
    validator2.wait_for_open_port(26557)
    validator1.systemctl("list-jobs --no-pager")
    validator2.systemctl("list-jobs --no-pager")

    relayer.wait_for_open_port(${toString defaultRestPort})

    actual = json.loads(
        client.succeed(
            "${pkgs.curl}/bin/curl http://relayer:${toString defaultRestPort}"
        )
    )

    assert actual == "", "rest port should be running"
  '';
}
