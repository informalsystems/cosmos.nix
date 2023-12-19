nix-std: {
  pkgs,
  cosmwasm-check,
}: let
  buildCosmwasmContract = let
    target = "wasm32-unknown-unknown";
    # from https://github.com/CosmWasm/rust-optimizer/blob/main/Dockerfile
    rust = pkgs.rust-bin.stable."1.70.0".default.override {
      extensions = [];
      targets = [
        target
      ];
    };

    defaultRustPlatform = pkgs.makeRustPlatform {
      cargo = rust;
      rustc = rust;
    };
  in
    args @ {
      pname,
      # must contain wasm32-unknown-unknown
      rustPlatform ? defaultRustPlatform,
      src,
      # people use different profiles a lot
      profile ? "release",
      nativeBuildInputs ? [],
      ...
    }: let
      binaryName = "${builtins.replaceStrings ["-"] ["_"] pname}.wasm";
      wasmNativeBuildInputs = pkgs.lib.lists.unique (nativeBuildInputs
        ++ [
          pkgs.binaryen
          cosmwasm-check
        ]);
      cleanedArgs = builtins.removeAttrs args ["rustPlatform" "profile" "nativeBuildInputs"];
    in
      rustPlatform.buildRustPackage (
        {
          RUSTFLAGS = "-C link-arg=-s";
          nativeBuildInputs = wasmNativeBuildInputs;
          installPhase = ''
            mkdir --parents $out/lib
          '';
          buildPhase = ''
            cargo build --lib --target ${target} --profile ${profile} --package ${pname}
            mkdir -p ./output/lib
            wasm-opt "target/${target}/release/${binaryName}" -o  "./output/lib/${binaryName}" -Os --signext-lowering
            cp -r ./output $out
          '';
          checkPhase = ''
            cargo test
            cosmwasm-check "$out/lib/${binaryName}"
          '';
        }
        // cleanedArgs
      );

  buildApp = args @ {
    name,
    version,
    src,
    engine,
    vendorHash,
    additionalLdFlags ? "",
    appName ? null,
    preCheck ? null,
    goVersion ? "1.19",
    ...
  }: let
    buildGoModuleArgs =
      pkgs.lib.filterAttrs
      (n: _:
        builtins.all (a: a != n)
        ["src" "name" "version" "vendorHash" "appName"])
      args;

    dependency-version = with nix-std.lib; let
      all-dep-matches =
        regex.allMatches
        "${engine}[[:space:]](=>[[:space:]]?[[:graph:]]*[[:space:]])?v?[[:graph:]]*"
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
          ''
          Could not find a ${engine} version with regex check that: 
            - The correct bft engine is ${engine} 
            - the formatting of go.mod may not conform to the regex in cosmos.nix/lib/default.nix.
          ''  
          null;
        just = function.id;
      };

    ldFlagAppName =
      if appName == null
      then "${name}d"
      else appName;

    buildGoModuleVersion = {
      "1.19" = pkgs.buildGo119Module;
      "1.20" = pkgs.buildGo120Module;
      "1.21" = pkgs.buildGo121Module;
    };

    buildGoModule = buildGoModuleVersion.${goVersion};
  in
    buildGoModule ({
        inherit version src vendorHash;
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
          -X github.com/${engine}/version.TMCoreSemVer=${dependency-version}
          ${additionalLdFlags}
        '';
      }
      // buildGoModuleArgs);
in {
  inherit buildCosmwasmContract;
  mkCosmosGoApp = buildApp;

  wasmdPreFixupPhase = libwasmvm: binName:
    if pkgs.stdenv.hostPlatform.isLinux
    then ''
      old_rpath=$(${pkgs.patchelf}/bin/patchelf --print-rpath $out/bin/${binName})
      new_rpath=$(echo "$old_rpath" | cut -d ":" -f 1 --complement)
      ${pkgs.patchelf}/bin/patchelf --set-rpath "$new_rpath" $out/bin/${binName}
    ''
    else if pkgs.stdenv.hostPlatform.isDarwin
    then ''
      install_name_tool -add_rpath "${libwasmvm}/lib" $out/bin/${binName}
    ''
    else null;

  mkGenerator = name: srcDir: pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = with pkgs; [ gomod2nix ];
    text = ''
      CURDIR=$(pwd)
      BUILDDIR=$(mktemp -d)
      cd "$BUILDDIR"
      cp -r ${srcDir}/* ./
      gomod2nix --outdir "$CURDIR"
    '';
  };

}
