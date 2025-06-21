# Created with reference to https://docs.celestia.org/nodes/systemd
{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.celestia-node;
in
  with lib; {
    options.services.celestia-node = {
      enable = mkEnableOption "celestia-node";

      package = mkOption {
        type = types.package;
        default = pkgs.celestia-node;
      };

      node-type = mkOption {
        type = types.enum ["light" "full" "bridge"];
        default = "light";
        description = ''
          Specify whether to run a "light", "full", or "bridge" node.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "celestia-node";
        description = "User under which the Celestia node service runs.";
      };

      group = mkOption {
        type = types.str;
        default = "celestia-node";
        description = "Group under which the Celestia node service runs.";
      };

      coreGrpcPort = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Custom gRPC port for the core node connection.";
      };

      coreIp = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "IP address or DNS of the core node to connect to.";
      };

      coreRpcPort = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Custom RPC port for the core node connection.";
      };

      gateway = mkOption {
        type = types.submodule {
          options = {
            enabled = mkOption {
              type = types.bool;
              default = false;
              description = "Enable the REST gateway.";
            };

            addr = mkOption {
              type = types.str;
              default = "localhost";
              description = "Custom gateway listen address.";
            };

            port = mkOption {
              type = types.port;
              default = 26659;
              description = "Custom gateway port.";
            };
          };
        };
        default = {};
        description = "Gateway configuration options.";
      };

      metrics = mkOption {
        type = types.submodule {
          options = {
            enabled = mkOption {
              type = types.bool;
              default = false;
              description = "Enables OTLP metrics with HTTP exporter.";
            };

            endpoint = mkOption {
              type = types.str;
              default = "localhost:4318";
              description = "HTTP endpoint for OTLP metrics to be exported to.";
            };

            tls = mkOption {
              type = types.bool;
              default = true;
              description = "Enable TLS connection to OTLP metric backend.";
            };
          };
        };
        default = {};
        description = "Metrics configuration options.";
      };

      logLevel = mkOption {
        type = types.enum ["DEBUG" "INFO" "WARN" "ERROR" "DPANIC" "PANIC" "FATAL"];
        default = "INFO";
        description = "Log level (e.g. DEBUG, INFO, WARN, ERROR, DPANIC, PANIC, FATAL).";
      };
    };

    config = mkIf cfg.enable {
      users.users.celestia-node = {
        isSystemUser = true;
        group = cfg.group;
      };

      users.groups.celestia-node = {};

      systemd.services.celestia-node = {
        description = "Celestia ${cfg.node-type} node daemon";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];
        serviceConfig = {
          ExecStart = let
            coreGrpcPortArg = optionalString (cfg.coreGrpcPort != null) "--core.grpc.port ${cfg.coreGrpcPort}";
            coreIpArg = optionalString (cfg.coreIp != null) "--core.ip ${cfg.coreIp}";
            coreRpcPortArg = optionalString (cfg.coreRpcPort != null) "--core.rpc.port ${cfg.coreRpcPort}";
            gatewayArgs = optionalString cfg.gateway.enabled "--gateway --gateway.addr ${cfg.gateway.addr} --gateway.port ${cfg.gateway.port}";
            metricsArgs = optionalString cfg.metrics.enabled "--metrics --metrics.endpoint ${cfg.metrics.endpoint} ${optionalString cfg.metrics.tls "--metrics.tls"}";
            logLevelArg = "--log.level ${cfg.logLevel}";
          in "${cfg.package}/bin/celestia ${cfg.node-type} start ${coreGrpcPortArg} ${coreIpArg} ${coreRpcPortArg} ${gatewayArgs} ${metricsArgs} ${logLevelArg}";

          Restart = "on-failure";
          RestartSec = 3;
          LimitNOFILE = 1400000;
          User = cfg.user;
          Group = cfg.group;
        };
      };
    };
  }
