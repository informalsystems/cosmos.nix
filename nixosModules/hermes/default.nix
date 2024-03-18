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
  cfg = config.services.hermes;
  base = import ./base.nix {inherit lib nix-std cfg;};
  tomlFile = pkgs.writeTextFile {
    name = "config.toml";
    text = base.config.toml;
  };
in
  with lib; {
    options.services.hermes =
      base.options
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

    config = mkIf cfg.enable {
      services.hermes.toml = base.config.toml;
      systemd.services.hermes = {
        description = "Hermes Daemon";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];
        preStart = "echo \"hermes toml can be found here: ${tomlFile}\"";
        serviceConfig = {
          Type = "notify";
          ExecStart = "${pkgs.lib.meta.getExe cfg.package} -c ${tomlFile} start";
        };
      };
    };
  }
