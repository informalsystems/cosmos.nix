{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.osmosisd;
in
  with lib; {
    options.services.osmosisd = {
      enable = mkEnableOption "osmosisd";
      packages = mkOption {
        description = "";
        type = types.submodule {
          options = {
            genesis = mkOption {
              description = "";
              type = types.package;
            };
            v2 = mkOption {
              description = "";
              type = types.package;
            };
            v3 = mkOption {
              description = "";
              type = types.package;
            };
            v4 = mkOption {
              description = "";
              type = types.package;
            };
            v5 = mkOption {
              description = "";
              type = types.package;
            };
            v6 = mkOption {
              description = "";
              type = types.package;
            };
            v7 = mkOption {
              description = "";
              type = types.package;
            };
            v8 = mkOption {
              description = "";
              type = types.package;
            };
            v9 = mkOption {
              description = "";
              type = types.package;
            };
            v10 = mkOption {
              description = "";
              type = types.package;
            };
            v11 = mkOption {
              description = "";
              type = types.package;
            };
            v12 = mkOption {
              description = "";
              type = types.package;
            };
          };
        };
      };

      cosmovisor = mkOption {
        type = types.package;
        default = pkgs.cosmovisor;
        description = ''
        '';
      };

      node-name = mkOption {
        type = types.str;
        default = "osmosis-daemon";
        description = ''
        '';
      };

      genesis-file = mkOption {
        type = types.path;
      };
    };

    config = mkIf cfg.enable {
      systemd.services.osmosisd = {
        description = "Osmosis Daemon";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];
        environment = {
          HOME = "/root";
          DAEMON_NAME = "osmosisd";
          DAEMON_HOME = "/root/.osmosisd";
          DAEMON_RESTART_AFTER_UPGRADE = "true";
          DAEMON_ALLOW_DOWNLOAD_BINARIES = "false";
          DAEMON_LOG_BUFFER_SIZE = "512";
          UNSAFE_SKIP_BACKUP = "true";
        };
        preStart = ''
          echo "Initializing osmosisd"
          [ ! -d "/root/.osmosisd" ] && ${cfg.packages.v12}/bin/osmosisd init ${cfg.node-name}

          echo "Copying genesis file"
          echo "${cfg.genesis-file}"
          cat ${cfg.genesis-file} > /root/.osmosisd/config/genesis.json

          echo "Creating cosmovisor directories"
          mkdir -p /root/.osmosisd/cosmovisor/genesis/bin
          mkdir -p /root/.osmosisd/cosmovisor/v2/bin
          mkdir -p /root/.osmosisd/cosmovisor/v3/bin
          mkdir -p /root/.osmosisd/cosmovisor/v4/bin
          mkdir -p /root/.osmosisd/cosmovisor/v5/bin
          mkdir -p /root/.osmosisd/cosmovisor/v6/bin
          mkdir -p /root/.osmosisd/cosmovisor/v7/bin
          mkdir -p /root/.osmosisd/cosmovisor/v8/bin
          mkdir -p /root/.osmosisd/cosmovisor/v9/bin
          mkdir -p /root/.osmosisd/cosmovisor/v10/bin
          mkdir -p /root/.osmosisd/cosmovisor/v11/bin
          mkdir -p /root/.osmosisd/cosmovisor/v12/bin
          mkdir -p /root/.osmosisd/cosmovisor/upgrades

          if [ ! -f "/root/.osmosisd/cosmovisor/genesis/bin" ]
          then
            echo "Symlinking osmosis genesis binary"
            ln -s ${cfg.packages.genesis}/bin/osmosisd /root/.osmosisd/cosmovisor/genesis/bin
          fi

          if [ ! -f "/root/.osmosisd/cosmovisor/v2/bin" ]
          then
            echo "Symlinking osmosis v2 binary"
            ln -s ${cfg.packages.v2}/bin/osmosisd /root/.osmosisd/cosmovisor/v2/bin
          fi

          if [ ! -f "/root/.osmosisd/cosmovisor/v3/bin" ]
          then
            echo "Symlinking osmosis v3 binary"
            ln -s ${cfg.packages.v3}/bin/osmosisd /root/.osmosisd/cosmovisor/v3/bin
          fi

          if [ ! -f "/root/.osmosisd/cosmovisor/v4/bin" ]
          then
            echo "Symlinking osmosis v4 binary"
            ln -s ${cfg.packages.v4}/bin/osmosisd /root/.osmosisd/cosmovisor/v4/bin
          fi

          if [ ! -f "/root/.osmosisd/cosmovisor/v5/bin" ]
          then
            echo "Symlinking osmosis v5 binary"
            ln -s ${cfg.packages.v5}/bin/osmosisd /root/.osmosisd/cosmovisor/v5/bin
          fi

          if [ ! -f "/root/.osmosisd/cosmovisor/v6/bin" ]
          then
            echo "Symlinking osmosis v6 binary"
            ln -s ${cfg.packages.v6}/bin/osmosisd /root/.osmosisd/cosmovisor/v6/bin
          fi

          if [ ! -f "/root/.osmosisd/cosmovisor/v7/bin" ]
          then
            echo "Symlinking osmosis v7 binary"
            ln -s ${cfg.packages.v7}/bin/osmosisd /root/.osmosisd/cosmovisor/v7/bin
          fi

          if [ ! -f "/root/.osmosisd/cosmovisor/v8/bin" ]
          then
            echo "Symlinking osmosis v8 binary"
            ln -s ${cfg.packages.v8}/bin/osmosisd /root/.osmosisd/cosmovisor/v8/bin
          fi

          if [ ! -f "/root/.osmosisd/cosmovisor/v9/bin" ]
          then
            echo "Symlinking osmosis v9 binary"
            ln -s ${cfg.packages.v9}/bin/osmosisd /root/.osmosisd/cosmovisor/v9/bin
          fi

          if [ ! -f "/root/.osmosisd/cosmovisor/v10/bin" ]
          then
            echo "Symlinking osmosis v10 binary"
            ln -s ${cfg.packages.v10}/bin/osmosisd /root/.osmosisd/cosmovisor/v10/bin
          fi

          if [ ! -f "/root/.osmosisd/cosmovisor/v11/bin" ]
          then
            echo "Symlinking osmosis v11 binary"
            ln -s ${cfg.packages.v11}/bin/osmosisd /root/.osmosisd/cosmovisor/v11/bin
          fi

          if [ ! -f "/root/.osmosisd/cosmovisor/v12/bin" ]
          then
            echo "Symlinking osmosis v12 binary"
            ln -s ${cfg.packages.v12}/bin/osmosisd /root/.osmosisd/cosmovisor/v12/bin
          fi
        '';
        serviceConfig = {
          Type = "notify";
          ExecStart = "${cfg.cosmovisor}/bin/cosmovisor run start --log_level \"trace\"";
          RestartSec = 3;
          Restart = "always";
          LimitNOFILE = "infinity";
          LimitNPROC = "infinity";
          TimeoutStartSec = "infinity";
        };
      };
    };
  }
