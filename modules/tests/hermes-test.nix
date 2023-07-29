{
  pkgs,
  hermes,
  gaia,
}: let
  jsonRpcCurlRequest = addr: port: ''${pkgs.curl}/bin/curl -X POST -H 'Content-Type: application/json' -d '{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"health\",\"params\":[]}' http://${addr}:${builtins.toString port} 2>&1'';
  sharedModule = {
    # Since it's common for CI not to have $DISPLAY available, we have to explicitly tell the tests "please don't expect any screen available"
    virtualisation.graphics = false;
    networking.useDHCP = false;
  };
  defaultRestPort = 3000;
  defaultMetricsPort = 3001;
in
  pkgs.nixosTest {
    name = "hermes-module-test";
    nodes = {
      validator1 = {
        imports = [sharedModule ../chains/gaia.nix];
        networking = {
          interfaces = {
            eth1 = {
              ipv4.addresses = [
                {
                  address = "192.168.2.10";
                  prefixLength = 24;
                }
              ];
            };
          };
          firewall.allowedTCPPorts = [
            26657
            9090
          ];
        };
        services.gaia = {
          enable = true;
          package = gaia;
          state = {
            config-dir = ./validator1/config;
            data-dir = ./validator1/data;
          };
          rpc-addr = "tcp://0.0.0.0:26657";
        };
      };

      validator2 = {
        imports = [sharedModule ../chains/gaia.nix];
        networking = {
          interfaces = {
            eth1 = {
              ipv4.addresses = [
                {
                  address = "192.168.2.11";
                  prefixLength = 24;
                }
              ];
            };
          };
          firewall.allowedTCPPorts = [
            26657
            9090
          ];
        };
        services.gaia = {
          enable = true;
          package = gaia;
          state = {
            config-dir = ./validator2/config;
            data-dir = ./validator2/data;
          };
          rpc-addr = "tcp://0.0.0.0:26657";
        };
      };

      client = {
        imports = [sharedModule];
        networking = {
          interfaces.eth1 = {
            ipv4.addresses = [
              {
                address = "192.168.2.12";
                prefixLength = 24;
              }
            ];
          };
          extraHosts = ''
            192.168.2.10 validator1
            192.168.2.11 validator2
            192.168.2.13 relayer
          '';
        };
      };

      relayer = {
        imports = [sharedModule ../relayer/hermes.nix];

        networking = {
          interfaces.eth1 = {
            ipv4.addresses = [
              {
                address = "192.168.2.13";
                prefixLength = 24;
              }
            ];
          };
          firewall.allowedTCPPorts = [
            defaultRestPort
            defaultMetricsPort
          ];
          extraHosts = ''
            192.168.2.10 validator1
            192.168.2.11 validator2
          '';
        };

        services.hermes = {
          enable = true;
          package = hermes;
          rest = {
            port = defaultRestPort;
            host = "0.0.0.0";
          };
          telemetry = {
            port = defaultMetricsPort;
            host = "0.0.0.0";
          };
          chains = [
            {
              id = "nixos";
              rpc-address = "http://validator1:26657";
              grpc-address = "http://validator1:9090";
              websocket-address = "ws://validator1:26657/websocket";
              account-prefix = "cosmos";
              key-name = "testkey";
              gas-price = 0.001;
              gas-denomination = "stake";
            }
            {
              id = "nixos2";
              rpc-address = "http://validator2:26657";
              grpc-address = "http://validator2:9090";
              websocket-address = "ws://validator2:26657/websocket";
              account-prefix = "cosmos";
              key-name = "testkey";
              gas-price = 0.001;
              gas-denomination = "stake";
            }
          ];
        };
      };
    };

    testScript = ''
      import json

      validator1.start()
      validator2.start()
      client.start()

      validator1.wait_for_open_port(26657)
      validator2.wait_for_open_port(26657)
      validator1.wait_for_open_port(9090)
      validator2.wait_for_open_port(9090)

      client.succeed(
        "${pkgs.grpcurl}/bin/grpcurl -plaintext validator1:9090 list 2>&1"
      )
      client.succeed("${jsonRpcCurlRequest "validator1" 26657}")
      client.succeed("${jsonRpcCurlRequest "validator2" 26657}")

      relayer.start()
      relayer.wait_for_open_port(${toString defaultRestPort})


      version = json.loads(
          client.succeed(
            "${pkgs.curl}/bin/curl http://relayer:${toString defaultRestPort}/version"
          )
      )

      chains = json.loads(
          client.succeed(
            "${pkgs.curl}/bin/curl http://relayer:${toString defaultRestPort}/chains"
          )
      )

      chainsStatus = chains['status']
      chainsResult = chains['result']

      for versionDict in version:
        hermesVersion = versionDict['version']
        assert hermesVersion == "${hermes.version}", f'should be using correct hermes version expected ${hermes.version}, but got {hermesVersion}'
      assert chainsStatus == "success", f'chains endpoint should return status success but instead got {chainsStatus}'
      assert chainsResult == ["nixos", "nixos2"], f'chains endpoint should return both validator chains, but instead got {chainsResult}'
    '';
  }
