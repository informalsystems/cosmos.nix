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
      package = mkOption {
        type = types.package;
        default = pkgs.osmosis;
        description = ''
        '';
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
          [ ! -d "/root/.osmosisd" ] && ${cfg.package}/bin/osmosisd init ${cfg.node-name}

          echo "Copying genesis file"
          echo "${cfg.genesis-file}"
          cat ${cfg.genesis-file} > /root/.osmosisd/config/genesis.json

          echo "Creating cosmovisor directories"
          mkdir -p /root/.osmosisd
          mkdir -p /root/.osmosisd/cosmovisor
          mkdir -p /root/.osmosisd/cosmovisor/genesis
          mkdir -p /root/.osmosisd/cosmovisor/genesis/bin
          mkdir -p /root/.osmosisd/cosmovisor/upgrades

          echo "Symlinking osmosisd to cosmovisor dir"
          [ ! -f "/root/.osmosisd/cosmovisor/genesis/bin" ] && ln -s /root/.osmosisd/cosmovisor/genesis/bin ${cfg.package}/bin/osmosisd
        '';
        path = [cfg.package];
        serviceConfig = {
          Type = "notify";
          ExecStart = "${cfg.cosmovisor}/bin/cosmovisor run";
          RestartSec = 3;
          Restart = "always";
          LimitNOFILE = "infinity";
          LimitNPROC = "infinity";
        };
      };
    };
  }
