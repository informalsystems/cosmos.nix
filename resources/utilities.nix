{
  pkgs,
  nix-std,
}: {
  mkCosmosGoApp = {
    name,
    version,
    src,
    vendorSha256,
    additionalLdFlags ? "",
    appName ? null,
    preCheck ? null,
    ...
  } @ args: let
    buildGoModuleArgs =
      pkgs.lib.filterAttrs
      (n: _:
        builtins.all (a: a != n)
        ["src" "name" "version" "vendorSha256" "appName"])
      args;
    # gomod-json = (import ./gomod-json.nix) {inherit pkgs nix-std;};
    # tendermint-version = gomod-json.find-tendermint-version (gomod-json.make-gomod-json { inherit name version src; } );
    tendermint-version = with nix-std.lib; let
      all-tm-matches =
        regex.allMatches
        "tendermint/tendermint[[:space:]](=>[[:space:]]?[[:graph:]]*[[:space:]])?v?[[:graph:]]*"
        (builtins.readFile "${src}/go.mod");
      tm-string =
        if list.any (string.hasInfix "=>") all-tm-matches
        then list.head (list.filter (string.hasInfix "=>") all-tm-matches)
        else list.head all-tm-matches;
      tm-version = optional.functor.map string.strip (optional.monad.bind tm-string (regex.lastMatch "[[:space:]](v?[[:graph:]]*)"));
    in
      optional.match tm-version {
        nothing =
          pkgs.lib.trivial.warn
          "Could not find a tendermint version with regex, check if the formatting of go.mod escapes the regex in cosmos.nix/resources/utilities"
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
          -X github.com/tendermint/tendermint/version.TMCoreSemVer=${tendermint-version}
          ${additionalLdFlags}
        '';
      }
      // buildGoModuleArgs);

  wasmdPreFixupPhase = binName: ''
    old_rpath=$(${pkgs.patchelf}/bin/patchelf --print-rpath $out/bin/${binName})
    new_rpath=$(echo "$old_rpath" | cut -d ":" -f 1 --complement)
    ${pkgs.patchelf}/bin/patchelf --set-rpath "$new_rpath" $out/bin/${binName}
  '';
}
