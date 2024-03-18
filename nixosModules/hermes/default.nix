{
  nix-std,
  hermes,
}: {
  lib,
  config,
  pkgs,
  ...
}: let
  defaultPackage =
    if hermes != null
    then hermes
    else pkgs.hermes;
  prev = config.services.hermes;
  sanitizedCfg =
    # remove non toml parts
    (builtins.removeAttrs prev ["package"])
    // {
      chains =
        # remove `null` from toml render
        builtins.map (pkgs.lib.filterAttrsRecursive (_: v: v != null)) prev.chains;
    };
  hermes-toml = pkgs.writeTextFile {
    text = nix-std.lib.serde.toTOML sanitizedCfg;
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
          default = defaultPackage;
          description = ''
            The hermes (ibc-rs) software to run.
          '';
        };
      };

    config = mkIf sanitizedCfg.enable {
      systemd.services.hermes = {
        description = "Hermes Daemon";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];
        preStart = "echo \"hermes toml can be found here: ${hermes-toml}\"";
        serviceConfig = {
          Type = "notify";
          ExecStart = "${pkgs.lib.meta.getExe config.services.hermes.package} -c ${hermes-toml} start";
        };
      };
    };
  }
