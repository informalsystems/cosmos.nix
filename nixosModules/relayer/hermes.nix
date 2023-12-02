{
  lib,
  config,
  pkgs,
  nix-std ? import (fetchTarball "https://github.com/chessai/nix-std/archive/master.tar.gz"),
  ...
}: let
  prev = config.services.hermes;
  cfg = prev // {chains = builtins.map (pkgs.lib.filterAttrsRecursive (_: v: v != null)) prev.chains;};
  hermes-toml = pkgs.writeTextFile {
    text = nix-std.lib.serde.toTOML cfg;
    name = "config.toml";
  };
in
  with lib; {
    options.services.hermes =
      import ./options.nix {inherit lib;}
      // {
        enable = mkEnableOption "hermes";
        package = mkOption {
          type = types.package;
          default = pkgs.hermes;
          description = ''
            The hermes (ibc-rs) software to run.
          '';
        };
      };

    config = mkIf cfg.enable {
      systemd.services.hermes = {
        description = "Hermes Daemon";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];
        preStart = "echo \"hermes toml can be found here: ${hermes-toml}\"";
        serviceConfig = {
          Type = "notify";
          ExecStart = "${cfg.package}/bin/hermes -c ${hermes-toml} start";
        };
      };
    };
  }
