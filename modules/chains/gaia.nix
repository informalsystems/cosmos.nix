{ lib, config, pkgs, ... }:
let
  cfg = config.services.gaia;
in
with lib; {
  options.services.gaia = {
    enable = mkEnableOption "gaia";
    package = mkOption {
      type = types.package;
      default = pkgs.gaia;
      description = ''
      '';
    };
    chain-id = mkOption {
      type = types.str;
      description = ''
      '';
    };
    genesis-file = mkOption {
      description = ''
      '';
      type = types.path;
    };
    gaia-dir = mkOption {
      description = ''
      '';
      default = "/gaia";
      type = types.path;
    };
    grpc-addr = mkOption {
      type = types.nullOr types.str;
      description = ''
      '';
    };
    rpc-addr = mkOption {
      type = types.nullOr types.str;
      description = ''
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.gaia = {
      description = "Gaia Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig =
        let
          grpc-addr = if cfg.grpc-addr == null then "" else "--rpc.grpc_laddr ${cfg.grpc-addr} ";
          rpc-addr = if cfg.rpc-addr == null then "" else "--rpc.laddr ${cfg.rpc-addr} ";
        in
        {
          Type = "notify";
          ExecStart =
            ''
              [ ! -d ${cfg.gaia-dir} ] && mkdir -p ${cfg.gaia-dir}
              ln -s ${cfg.genesis-file} ${cfg.gaia-dir}/config/genesis.json
              ${cfg.package}/bin/gaiad init main --chain-id ${cfg.chain-id} --home ${cfg.gaia-dir}
              ${cfg.package}/bin/gaiad start ${grpc-addr}${rpc-addr}
            '';
        };
    };
  };
}
