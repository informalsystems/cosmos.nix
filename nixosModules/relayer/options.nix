{lib}:
with lib; {
  global = mkOption {
    type = types.submodule {
      options = {
        log_level = mkOption {
          type = types.enum ["error" "warn" "info" "debug" "trace"];
          default = "info";
          description = ''
            Specify the verbosity for the relayer logging output.
          '';
        };
      };
    };
  };
  mode = mkOption {
    description = "Specify the mode to be used by the relayer";
    default = {
      clients = {
        enabled = true;
        refresh = true;
        misbehaviour = true;
      };
      packets = {
        enabled = true;
        clear_interval = 100;
        clear_on_start = false;
        tx_confirmation = true;
      };
      connections.enabled = false;
      channels.enabled = false;
    };
    type = types.submodule {
      options = {
        clients = mkOption {
          description = "Specify the clients mode";
          default = {
            enabled = true;
            refresh = true;
            misbehaviour = true;
          };
          type = types.submodule {
            options = {
              enabled = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Whether or not to enable the client workers.
                '';
              };
              refresh = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Whether or not to enable periodic refresh of clients. [Default: true]
                  Note: Even if this is disabled, clients will be refreshed automatically if
                       there is activity on a connection or channel they are involved with.
                '';
              };
              misbehaviour = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Whether or not to enable misbehaviour detection for clients.
                '';
              };
            };
          };
        };

        packets = mkOption {
          description = "Specify the packets mode";
          default = {
            enabled = true;
            clear_interval = 100;
            clear_on_start = false;
            tx_confirmation = true;
          };
          type = types.submodule {
            options = {
              enabled = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Whether or not to enable the packet workers.
                '';
              };
              clear_interval = mkOption {
                type = types.ints.u32;
                default = 100;
                description = ''
                  Parametrize the periodic packet clearing feature.
                  Interval (in number of blocks) at which pending packets
                  should be eagerly cleared. A value of '0' will disable it.
                '';
              };
              clear_on_start = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Whether or not to clear packets on start.
                '';
              };
              tx_confirmation = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Toggle the transaction confirmation mechanism.
                  The tx confirmation mechanism periodically queries the `/tx_search` RPC
                  endpoint to check that previously-submitted transactions
                  (to any chain in this config file) have delivered successfully.
                  Experimental feature. Affects telemetry if set to false.
                '';
              };
            };
          };
        };

        connections = mkOption {
          description = "Specify the connections mode";
          default = {
            enabled = false;
          };
          type = types.submodule {
            options = {
              enabled = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Whether or not to enable the connection workers for handshake completion.
                '';
              };
            };
          };
        };

        channels = mkOption {
          description = "Specify the channels mode";
          default = {
            enabled = false;
          };
          type = types.submodule {
            options = {
              enabled = mkOption {
                type = types.bool;
                default = true;
                description = ''
                  Whether or not to enable the channel workers for handshake completion.
                '';
              };
            };
          };
        };
      };
    };
  };

  # REST API submodule options
  rest = mkOption {
    description = ''
      The REST section defines parameters for Hermes' built-in RESTful API.
      <link xlink:href="https://hermes.informal.systems/rest.html">Rest option docs</link>.
    '';
    default = {
      enabled = true;
      host = "127.0.0.1";
      port = 3000;
    };
    type = types.submodule {
      options = {
        enabled = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Where or not to enable the REST service.
          '';
        };
        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = ''
            Specify the IPv4/6 host over which the built-in HTTP server will serve the RESTful.
          '';
        };
        port = mkOption {
          type = types.port;
          default = 3000;
          description = ''
            Specify the port over which the built-in HTTP server will serve the restful API.
          '';
        };
      };
    };
  };

  # Telemetry API submodule options
  telemetry = mkOption {
    description = ''
      The telemetry section defines parameters for Hermes' built-in telemetry capabilities.
      <link xlink:href="https://hermes.informal.systems/telemetry.html">Telemetry option docs</link>.
    '';
    default = {
      enabled = true;
      host = "127.0.0.1";
      port = 3001;
    };
    type = types.submodule {
      options = {
        enabled = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether or not to enable the telemetry service.
          '';
        };
        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = ''
            Specify the IPv4/6 host over which the built-in HTTP server will serve metrics.
          '';
        };
        port = mkOption {
          type = types.port;
          default = 3001;
          description = ''
            Specify the port over which the built-in HTTP server will serve the metrics gathered.
          '';
        };
      };
    };
  };

  # Chain submodule options
  chains = mkOption {
    description = ''
      A chains section includes parameters related to a chain and the full node to which
      the relayer can send transactions and queries.
    '';
    type = types.listOf (
      types.submodule {
        options = import ./chain-options.nix {inherit lib;};
      }
    );
  };
}
