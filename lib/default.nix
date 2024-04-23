nix-std: {
  pkgs,
  cosmwasm-check,
}: let
  buildCosmwasmContract = let
    target = "wasm32-unknown-unknown";
    # from https://github.com/CosmWasm/rust-optimizer/blob/main/Dockerfile
    rust = pkgs.rust-bin.stable."1.75.0".default.override {
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
      # as per https://github.com/CosmWasm/wasmd/blob/main/README.md
      maxWasmSizeBytes ? 819200,
      cargoExtraArgs ? "--locked",
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
            cargo build --lib --target ${target} --profile ${profile} --package ${pname} ${cargoExtraArgs}
            mkdir -p ./output/lib
            wasm-opt "target/${target}/${profile}/${binaryName}" -o  "./output/lib/${binaryName}" -Os --signext-lowering
            cp -r ./output $out
          '';
          checkPhase = ''
            cargo test
            cosmwasm-check "$out/lib/${binaryName}"
            SIZE=$(stat --format=%s "$out/lib/${binaryName}")
            if [[ "$SIZE" -gt ${builtins.toString maxWasmSizeBytes} ]]; then
              echo "Wasm file size is $SIZE, which is larger than the maximum allowed size of ${builtins.toString maxWasmSizeBytes} bytes."
              echo "Either reduce size or increase maxWasmSizeBytes if you know what you are doing."
              exit 1
            fi
          '';
        }
        // cleanedArgs
      );

  buildApp = args @ {
    name,
    version,
    rev,
    src,
    engine,
    vendorHash,
    additionalLdFlags ? [],
    appName ? null,
    preCheck ? null,
    goVersion ? "1.20",
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
      "1.20" = pkgs.buildGo120Module;
      "1.21" = pkgs.buildGo121Module;
    };

    buildGoModule = buildGoModuleVersion.${goVersion};
  in
    buildGoModule ({
        inherit version vendorHash src;
        pname = name;
        preCheck =
          if preCheck == null
          then ''export HOME="$(mktemp -d)"''
          else preCheck;
        ldflags =
          [
            "-X github.com/cosmos/cosmos-sdk/version.Name=${name}"
            "-X github.com/cosmos/cosmos-sdk/version.AppName=${ldFlagAppName}"
            "-X github.com/cosmos/cosmos-sdk/version.Version=${version}"
            "-X github.com/cosmos/cosmos-sdk/version.Commit=${rev}"
            "-X github.com/${engine}/version.TMCoreSemVer=${dependency-version}"
          ]
          ++ additionalLdFlags;
      }
      // buildGoModuleArgs);
in {
  # A helper for building rust cosmwasm smart contracts. Does some best practices like using binaryren wasm-opt
  # to optimize the bytecode, and runs cosmwasm-check to validate.
  inherit buildCosmwasmContract;

  # A wrapper around [buildGoModule](https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/go/module.nix)
  # that is specialized to packaging cosmos-sdk based go projects
  #
  # for more information see: https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/go.section.md
  mkCosmosGoApp = buildApp;

  # A helper function for patching cosmos-sdk binaries that use wasmd, so that the binary artifact references
  # a nix store path, and not a local relative path
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

  # A helper that produces an executable for generating a gomod2nix.toml file (which
  # captures a go module's dependencies and their hash in a toml file)
  mkGenerator = name: srcDir:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = with pkgs; [gomod2nix];
      text = ''
        CURDIR=$(pwd)
        BUILDDIR=$(mktemp -d)
        cd "$BUILDDIR"
        cp -r ${srcDir}/* ./
        gomod2nix --outdir "$CURDIR"
      '';
    };

  # `hermesModuleConfigToml { modules }).config.hermes.toml`
  # will be a string to put into [config.toml](https://hermes.informal.systems/documentation/configuration/configure-hermes.html)
  hermesModuleConfigToml = {modules}:
    pkgs.lib.evalModules {
      modules =
        [
          (
            {
              lib,
              config,
              ...
            }: let
              # please note that this is not `nixos service`(systemd/launchd),
              # but just the "abstract" module that can be used to build other configurations:
              # static config files, containers, vm, process manager, futher generator.
              cfg = config.hermes;
              base = import ../nixosModules/hermes/base.nix {inherit lib nix-std cfg;};
            in {
              options.hermes = base.options;
              config.hermes.toml = base.config.toml;
            }
          )
        ]
        ++ modules;
    };
}
