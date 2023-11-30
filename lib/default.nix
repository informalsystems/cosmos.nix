nix-std: pkgs: packages: let
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
          packages.cosmwasm-check
        ]);
      cleanedArgs = builtins.removeAttrs args ["rustPlatform" "profile" "nativeBuildInputs"];
      cosmwasmify = input: output: ''
        # from https://github.com/CosmWasm/rust-optimizer/blob/main/Dockerfile
        # --signext-lowering is needed to support blockchains runnning CosmWasm < 1.3. It can be removed eventually
        wasm-opt ${input} -o ${output} -Os --signext-lowering
        cosmwasm-check ${output}
      '';
    in
      rustPlatform.buildRustPackage (
        {
          buildPhase = "cargo build --lib --target ${target} --profile ${profile} --package ${pname}";
          RUSTFLAGS = "-C link-arg=-s";
          nativeBuildInputs = wasmNativeBuildInputs;
          installPhase = ''
            mkdir --parents $out/lib
            ${cosmwasmify "target/${target}/release/${binaryName}" "$out/lib/${binaryName}"}
          '';
        }
        // cleanedArgs
      );

  buildApp = args @ {
    name,
    version,
    src,
    engine,
    vendorSha256,
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
        ["src" "name" "version" "vendorSha256" "appName"])
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
          "Could not find a ${engine} version with regex, check if the formatting of go.mod escapes the regex in cosmos.nix/resources/utilities"
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
}
