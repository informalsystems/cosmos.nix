{ pkgs, gaia, system }:
let
  sharedModule = {
    # Since it's common for CI not to have $DISPLAY available, we have to explicitly tell the tests "please don't expect any screen available"
    virtualisation.graphics = false;
    networking.useDHCP = false;
    networking.interfaces.eth0.useDHCP = false;
  };
in
pkgs.nixosTest {
  inherit system;
  name = "gaia-module-test";
  nodes = {
    gaia = {
      imports = [ sharedModule ../chains/gaia.nix ];

      networking.firewall = {
        enable = true;
        trustedInterfaces = [ "eth0" ];
        interfaces = {
          eth0 = {
            allowedTCPPorts = [ 26557 9091 ];
          };
        };
      };

      services.gaia = {
        enable = true;
        package = gaia;
        state = {
          config-dir = ./validator1/config;
          data-dir = ./validator1/data;
        };
        rpc-addr = "tcp://127.0.0.1:26557";
        grpc-addr = "tcp://127.0.0.1:9091";
      };
    };
  };

  testScript = with builtins; ''
    start_all()

    gaia.wait_for_open_port(26557)
    gaia.systemctl("list-jobs --no-pager")

    addr = gaia.succeed("${gaia}/bin/gaiad tendermint show-address --home \"/gaia\"")
    print(addr)

    q = gaia.succeed(
      "${gaia}/bin/gaiad query tendermint-validator-set --node http://localhost:26557 --chain-id nixos --home \"/gaia\""
    )
    print(q)
  '';
}

