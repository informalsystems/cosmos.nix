{
  apalache-src,
  pkgs,
}: let
  version = "v0.23.1";

  # Patch the build.sbt file so that it does not call the `diff` command,
  # which is not available when sbt-derivation is using build.sbt to
  # compute the Scala dependencies.
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

    depsSha256 = "sha256-xKLKlkOHysNtSCDtj9JKwLYyCCuRrc36+QsBWFjLnFI=";

    src = apalache-src;

    patches = [
      (builtins.toFile "diff.patch" patch)
    ];

    buildPhase = ''
      sbt apalacheCurrentPackage
    '';

    installPhase = ''
      mkdir $out
      cp -r target/universal/current-pkg/* $out/
    '';
  }
