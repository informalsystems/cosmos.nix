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
in
pkgs.nixosTest {
  inherit system;
  name = "hermes-module-test";
  nodes = {

    validator1 = {
      imports = [ sharedModule ../chains/gaia.nix ];
      networking = {
        interfaces = {
          eth1 = {
            ipv4.addresses = [
              { address = "192.168.2.10"; prefixLength = 24; }
            ];
          };
        };
        firewall.allowedTCPPorts = [
          26557
          9092
        ];
      };
      services.gaia = {
        enable = true;
        package = gaia;
        state = {
          config-dir = ./validator1/config;
          data-dir = ./validator1/data;
        };
        rpc-addr = "tcp://0.0.0.0:26557";
        grpc-addr = "tcp://0.0.0.0:9091";
      };
    };

    validator2 = {
      imports = [ sharedModule ../chains/gaia.nix ];
      networking = {
        interfaces = {
          eth1 = {
            ipv4.addresses = [
              { address = "192.168.2.11"; prefixLength = 24; }
            ];
          };
        };
        firewall.allowedTCPPorts = [
          26557
          9092
        ];
      };
      services.gaia = {
        enable = true;
        package = gaia;
        state = {
          config-dir = ./validator2/config;
          data-dir = ./validator2/data;
        };
        rpc-addr = "tcp://0.0.0.0:26557";
        grpc-addr = "tcp://0.0.0.0:9091";
      };
    };

    client = {
      imports = [ sharedModule ];
      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.2.12"; prefixLength = 24; }
          ];
        };
        extraHosts = ''
          192.168.2.10 validator1
          192.168.2.11 validator2
        '';
      };
    };

    relayer = {
      imports = [ sharedModule ../relayer/hermes.nix ];

      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.2.13"; prefixLength = 24; }
          ];
        };
        extraHosts = ''
          192.168.2.10 validator1
          192.168.2.11 validator2
        '';
      };

      services.hermes = {
        enable = true;
        package = hermes;
        rest.port = defaultRestPort;
        telemetry.port = defaultMetricsPort;
        chains = [
          {
            id = "nixos";
            rpc-address = "http://validator1:26557";
            grpc-address = "http://validator1:9091";
            websocket-address = "ws://validator1:26557/websocket";
            account-prefix = "cosmos";
            key-name = "testkey";
            gas-price = 0.001;
            gas-denomination = "stake";
          }
          {
            id = "nixos2";
            rpc-address = "http://validator2:26557";
            grpc-address = "http://validator2:9091";
            websocket-address = "ws://validator2:26557/websocket";
            account-prefix = "cosmos";
            key-name = "testkey";
            gas-price = 0.001;
            gas-denomination = "stake";
          }
        ];
      };
    };
  };

  testScript = with builtins; ''
    import json

    validator1.start()
    validator2.start()
    client.start()

    validator1.wait_for_open_port(26557)
    validator2.wait_for_open_port(26557)

    relayer.start()

    relayer.wait_for_open_port(${toString defaultRestPort})

    actual = json.loads(
        client.succeed(
            "${pkgs.curl}/bin/curl http://relayer:${toString defaultRestPort}"
        )
    )

    print(actual)

    assert actual == "", "rest port should be running"
  '';
}
