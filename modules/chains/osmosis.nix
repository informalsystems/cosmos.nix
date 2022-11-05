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
        type = types.string;
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
          DAEMON_NAME = "osmosisd";
          DAEMON_HOME = "~/.osmosisd";
          DAEMON_RESTART_AFTER_UPGRADE = "true";
          DAEMON_ALLOW_DOWNLOAD_BINARIES = "false";
          DAEMON_LOG_BUFFER_SIZE = "512";
          UNSAFE_SKIP_BACKUP = "true";
        };
        preStart = ''
          ${cfg.package}/bin/osmosisd init
          cp ${cfg.genesis-file} ~/.osmosisd/config/genesis.json
          mkdir -p ~/.osmosisd
          mkdir -p ~/.osmosisd/cosmovisor
          mkdir -p ~/.osmosisd/cosmovisor/genesis
          mkdir -p ~/.osmosisd/cosmovisor/genesis/bin
          mkdir -p ~/.osmosisd/cosmovisor/upgrades
          ln -s ${cfg.package}/bin/osmosisd ~/.osmosisd/cosmovisor/genesis/bin
        '';
        path = [cfg.package];
        serviceConfig = {
          Type = "notify";
          ExecStart = "${cfg.package}/bin/osmosisd start";
          RestartSec = 3;
          Restart = "always";
          LimitNOFILE = "infinity";
          LimitNPROC = "infinity";
        };
      };
    };
  }
