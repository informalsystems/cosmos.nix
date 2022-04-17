{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.gaia;
in
  with lib; {
    options.services.crescentd = {
      enable = mkEnableOption "crescentd";
      package = mkOption {
        type = types.package;
        default = pkgs.crescent;
        description = ''
        '';
      };

      state = mkOption {
        default = null;
        description = "";
        type = types.nullOr (types.submodule {
          options = {
            data-dir = mkOption {
              description = "";
              type = types.path;
            };
            config-dir = mkOption {
              description = "";
              type = types.path;
            };
          };
        });
      };

      gaia-home = mkOption {
        description = ''
        '';
        default = "/gaia";
        type = types.path;
      };

      rpc-addr = mkOption {
        type = types.nullOr types.str;
        description = ''
        '';
      };
    };

    config = mkIf cfg.enable {
      systemd.services.gaia = {
        description = "Crescent Daemon";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];
        environment = {
          HOME = cfg.gaia-home;
          GAHOME = cfg.gaia-home;
        };
        preStart = with cfg.state; ''
          [ ! -d ${cfg.gaia-home}/config ] && mkdir -p ${cfg.gaia-home}/config
          [ ! -d ${cfg.gaia-home}/data ] && mkdir -p ${cfg.gaia-home}/data
          ln -s ${data-dir}/* ${cfg.gaia-home}/data
          ln -s ${config-dir}/* ${cfg.gaia-home}/config
        '';
        serviceConfig = let
          rpc-addr =
            if cfg.rpc-addr == null
            then ""
            else "--rpc.laddr ${cfg.rpc-addr} ";
        in {
          Type = "notify";
          ExecStart = "${cfg.package}/bin/crescentd start ${rpc-addr} --home ${cfg.gaia-home}";
        };
      };
    };
  }
