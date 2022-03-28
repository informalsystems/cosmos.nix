{pkgs}: {
  mkCosmosGoApp = {
    name,
    version,
    src,
    vendorSha256,
    appName ? null,
    preCheck ? null,
    ...
  } @ args: let
    parser = import ./goModParser.nix;
    go-mod = parser (builtins.readFile "${src}/go.mod");
    tendermint-version = go-mod.require."github.com/tendermint/tendermint".version;
    buildGoModuleArgs = pkgs.lib.filterAttrs (n: _: builtins.all (a: a != n) ["src" "name" "version" "vendorSha256" "appName"]) args;
    ldFlagAppName =
      if appName == null
      then "${name}d"
      else appName;
  in
    pkgs.buildGoModule ({
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
      '';
    }
    // buildGoModuleArgs);

  wasmdPreFixupPhase = binName: ''
    old_rpath=$(${pkgs.patchelf}/bin/patchelf --print-rpath $out/bin/${binName})
    new_rpath=$(echo "$old_rpath" | cut -d ":" -f 1 --complement)
    ${pkgs.patchelf}/bin/patchelf --set-rpath "$new_rpath" $out/bin/${binName}
  '';
}
