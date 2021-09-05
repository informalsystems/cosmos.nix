{ pkgs, syncGoModulesInputs }:
pkgs.writeShellScriptBin "syncGoModulesCheck"
  ''
    #!/usr/bin/env bash
    set -euo pipefail
    TOKENS="${syncGoModulesInputs}"
    AWK=${pkgs.gawk}/bin/awk
    JQ=${pkgs.jq}/bin/jq
    for GO_SRC in $TOKENS;
    do
      PACKAGE_NAME=$(echo "$GO_SRC" | $AWK -F: '{print $1}')
      REST=$(echo "$GO_SRC" | $AWK -F: '{print $2}')
      SRC_NAME=$(echo "$REST" | $AWK -F/ '{print $1}')

      NAR_HASH=$(cat flake.lock | $JQ -r ".nodes[\"$SRC_NAME\"].locked.narHash" )
      LAST_SYNCED="$PACKAGE_NAME/last-synced.narHash"

      if [ -f $LAST_SYNCED ]
      then continue
      else
        echo "$PACKAGE_NAME has not been synced, please run \"syncGoModules\" from within the nix shell"
        exit 1
      fi
      if [ $NAR_HASH != $(cat $LAST_SYNCED) ]
      then
        echo "$PACKAGE_NAME's go modules are out of sync, please run \"syncGoModules\" from within the nix shell"
        exit 1
      else
        continue
      fi
    done
  ''

