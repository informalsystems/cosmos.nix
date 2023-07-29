{
  pkgs,
  gaia,
}: let
  sharedModule = {
    # Since it's common for CI not to have $DISPLAY available, we have to explicitly tell the tests "please don't expect any screen available"
    virtualisation.graphics = false;
    networking.useDHCP = false;
  };
in
  pkgs.nixosTest {
    name = "gaia-module-test";
    nodes = {
      gaia = {
        imports = [sharedModule ../chains/gaia.nix];

        networking = {
          interfaces.eth1 = {
            ipv4.addresses = [
              {
                address = "192.168.2.11";
                prefixLength = 24;
              }
            ];
          };
          firewall.allowedTCPPorts = [26557];
        };

        services.gaia = {
          enable = true;
          package = gaia;
          state = {
            config-dir = ./validator1/config;
            data-dir = ./validator1/data;
          };
          rpc-addr = "tcp://0.0.0.0:26557";
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
            192.168.2.11 gaia
          '';
        };
      };
    };

    testScript = ''
      start_all()

      gaia.wait_for_open_port(26557)
      gaia.systemctl("list-jobs --no-pager")

      addr = gaia.succeed("${gaia}/bin/gaiad tendermint show-address --home \"/gaia\"")
      print(addr)

      q = gaia.succeed(
        "${gaia}/bin/gaiad query tendermint-validator-set --node http://gaia:26557 --chain-id nixos --home \"/gaia\""
      )
      print(q)

      actual = client.succeed(
        "${pkgs.curl}/bin/curl http://gaia:26557/health | ${pkgs.jq}/bin/jq -r -c -M .\"error\""
      )
      print(actual)

      assert actual == "null\n", "rest port should be running"
    '';
  }
