{
  apalache-src,
  pkgs,
}: let
  version = "v0.23.1";

  # Patch the build.sbt file so that it does not call the `git describe` command.
  # This is called by sbt-derivation to resolve the Scala dependencies, however
  # inside the Nix build environment for sbt-derivation, the git command is
  # not available, hence the dependency resolution would fail. As a workaround,
  # we use the version string provided in Nix as the build version.
  #
  # Note that the diff has a single space indentation, so auto re-indentation
  # inside the editor may break the diff.
  patch = ''
    diff --git a/build.sbt b/build.sbt
    index c052ebc8..fa4568d7 100644
    --- a/build.sbt
    +++ b/build.sbt
    @@ -184,7 +184,7 @@
           // See https://github.com/sbt/sbt-buildinfo
           buildInfoPackage := "apalache",
           buildInfoKeys := {
    -        val build = scala.sys.process.Process("git describe --tags --always").!!.trim
    +        val build = "${version}"
             Seq[BuildInfoKey](
                 BuildInfoKey.map(version) { case (k, v) =>
                   if (isSnapshot.value) (k -> build) else (k -> v)
  '';
in
  pkgs.sbt.mkDerivation {
    pname = "apalache";
    inherit version;

    depsSha256 = "sha256-9wGlIFmvKW4N8NQqhOlxjhl48JptHCSI8F8EFF9mYrw=";

    src = apalache-src;

    patches = [
      (builtins.toFile "diff.patch" patch)
    ];

    buildPhase = ''
      make dist
    '';

    installPhase = ''
      mkdir -p $out/lib
      mkdir -p $out/bin
      mkdir -p target/out

      tar xf target/universal/apalache.tgz -C target/out

      cp -r target/out/apalache/lib/apalache.jar $out/lib/apalache.jar

      cat > $out/bin/apalache-mc <<- EOM
      #!${pkgs.bash}/bin/bash
      exec ${pkgs.jre}/bin/java -Xmx4096m -jar "$out/lib/apalache.jar" "\$@"
      EOM

      chmod +x $out/bin/apalache-mc
    '';
  }
