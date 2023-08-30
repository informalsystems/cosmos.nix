{
  apalache-src,
  pkgs,
}: let
  version = "v0.42.0";

  postPatch = ''
    # Patch the build.sbt file so that it does not call the `git describe` command.
    # This is called by sbt-derivation to resolve the Scala dependencies, however
    # inside the Nix build environment for sbt-derivation, the git command is
    # not available, hence the dependency resolution would fail. As a workaround,
    # we use the version string provided in Nix as the build version.
    substituteInPlace ./build.sbt \
      --replace 'Process("git describe --tags --always").!!.trim' '"${version}"'

    # Patch the wrapper script to use a JRE from the Nix store,
    # and to load the JAR from the Nix store by default.
    substituteInPlace ./src/universal/bin/apalache-mc \
      --replace 'exec java' 'exec ${pkgs.jre}/bin/java' \
      --replace '$DIR/../lib/apalache.jar' "$out/lib/apalache.jar"
  '';
in
  pkgs.sbt.mkDerivation {
    inherit version postPatch;
    pname = "apalache";
    src = apalache-src;
    buildPhase = "make dist";
    installPhase = ''
      mkdir $out
      tar \
        --file=target/universal/apalache.tgz \
        --extract \
        --gzip \
        --strip-components=1 \
        --directory=$out
    '';

    depsSha256 = "sha256-PPE8BRgl9aLL7WhA8E1sib261lw9XRUwFp5aJ7qyxXw=";
    overrideDepsAttrs = _: _: {
      inherit postPatch;
    };
  }
