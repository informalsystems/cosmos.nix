{ pkgs, go-source-inputs }:
pkgs.writeTextFile
{
  name = "syncGoModulesCheck";
  text = ''
    #!/usr/bin/env bash
    set -euo pipefail
    TOKENS="${go-source-inputs}"
    for GO_SRC in $TOKENS;
    do
      PACKAGE_NAME=$(echo "$GO_SRC" | ${pkgs.gawk}/bin/awk -F: '{print $1}')
      REST=$(echo "$GO_SRC" | ${pkgs.gawk}/bin/awk -F: '{print $2}')
      SRC_NAME=$(echo "$REST" | ${pkgs.gawk}/bin/awk -F/ '{print $1}')

      NAR_HASH=$(${pkgs.jq}/bin/jq -r ".nodes[\"$SRC_NAME\"].locked.narHash" < flake.lock )
      LAST_SYNCED="resources/$PACKAGE_NAME/last-synced.narHash"

      if [ -f "$LAST_SYNCED" ]
      then continue
      else
        echo "$PACKAGE_NAME has not been synced, please run \"syncGoModules\" from within the nix shell"
        exit 1
      fi
      if [ "$NAR_HASH" != "$(cat "$LAST_SYNCED")" ]
      then
        echo "$PACKAGE_NAME's go modules are out of sync, please run \"syncGoModules\" from within the nix shell"
        exit 1
      else
        continue
      fi
    done
  '';
  executable = true;
  checkPhase = ''
    ${pkgs.shellcheck}/bin/shellcheck $out
  '';
}
