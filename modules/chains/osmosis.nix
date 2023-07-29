{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.osmosis;
in
  with lib; {
    options.services.osmosis = {
      enable = mkEnableOption "osmosis";
      package = mkOption {
        type = types.package;
        default = pkgs.osmosis;
        description = ''
        '';
      };

      config-dir = mkOption {
        description = "";
        type = types.path;
      };

      home = mkOption {
        description = ''
        '';
        default = "/osmosis";
        type = types.path;
      };

      rpc-addr = mkOption {
        type = types.nullOr types.str;
        description = ''
        '';
      };
    };

    config = mkIf cfg.enable {
      systemd.services.osmosis = {
        description = "Osmosis Daemon";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];
        environment = {
          HOME = cfg.home;
        };
        preStart = ''
          [ ! -d ${cfg.home}/config ] && mkdir -p ${cfg.home}/config
          ln -s ${cfgconfig-dir}/* ${cfg.home}/config
        '';
        serviceConfig = let
          rpc-addr =
            if cfg.rpc-addr == null
            then ""
            else "--rpc.laddr ${cfg.rpc-addr} ";
        in {
          Type = "notify";
          ExecStart = "${cfg.package}/bin/osmosisd start ${rpc-addr} --home ${cfg.home}";
        };
      };
    };
  }
