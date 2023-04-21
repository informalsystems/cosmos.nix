{
  pkgs,
  nix-std,
}: let
  buildApp = engineRepo: args @ {
    name,
    version,
    src,
    vendorSha256,
    additionalLdFlags ? "",
    appName ? null,
    preCheck ? null,
    ...
  }: let
    buildGoModuleArgs =
      pkgs.lib.filterAttrs
      (n: _:
        builtins.all (a: a != n)
        ["src" "name" "version" "vendorSha256" "appName"])
      args;

    dependency-version = with nix-std.lib; let
      all-dep-matches =
        regex.allMatches
        "${engineRepo}[[:space:]](=>[[:space:]]?[[:graph:]]*[[:space:]])?v?[[:graph:]]*"
        (builtins.readFile "${src}/go.mod");
      dep-string =
        if list.any (string.hasInfix "=>") all-dep-matches
        then list.head (list.filter (string.hasInfix "=>") all-dep-matches)
        else list.head all-dep-matches;
      dep-version = optional.functor.map string.strip (optional.monad.bind dep-string (regex.lastMatch "[[:space:]](v?[[:graph:]]*)"));
    in
      optional.match dep-version {
        nothing =
          pkgs.lib.trivial.warn
          "Could not find a ${engineRepo} version with regex, check if the formatting of go.mod escapes the regex in cosmos.nix/resources/utilities"
          null;
        just = function.id;
      };

    ldFlagAppName =
      if appName == null
      then "${name}d"
      else appName;
  in
    pkgs.buildGo119Module ({
        inherit version src vendorSha256;
        pname = name;
        preCheck =
          if preCheck == null
          then ''export HOME="$(mktemp -d)"''
          else preCheck;
        ldflags = ''
          -X github.com/cosmos/cosmos-sdk/version.Name=${name}
          -X github.com/cosmos/cosmos-sdk/version.AppName=${ldFlagAppName}
          -X github.com/cosmos/cosmos-sdk/version.Version=${version}
          -X github.com/cosmos/cosmos-sdk/version.Commit=${src.rev}
          -X github.com/${engineRepo}/version.TMCoreSemVer=${dependency-version}
          ${additionalLdFlags}
        '';
      }
      // buildGoModuleArgs);
in {
  mkCosmosGoApp = buildApp "tendermint/tendermint";
  mkCosmosGoTendermint = buildApp "tendermint/tendermint";
  mkCosmosGoAppComet = buildApp "cometbft/cometbft";

  wasmdPreFixupPhase = binName: ''
    old_rpath=$(${pkgs.patchelf}/bin/patchelf --print-rpath $out/bin/${binName})
    new_rpath=$(echo "$old_rpath" | cut -d ":" -f 1 --complement)
    ${pkgs.patchelf}/bin/patchelf --set-rpath "$new_rpath" $out/bin/${binName}
  '';
}
