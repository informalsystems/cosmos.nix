{pkgs}: let
  config = pkgs.writeTextFile {
    name = "config.nu";
    text = builtins.readFile ./config.nu;
  };
in {
  push-store = pkgs.writeShellApplication {
    name = "push-store";
    runtimeInputs = with pkgs; [jq nushell];
    text = let
      nuscript = pkgs.writeTextFile {
        name = "push-store.nu";
        text = builtins.readFile ./push.nu;
      };
    in "nu --config ${config} ${nuscript} \"$1\" \"$2\"";
  };
}
