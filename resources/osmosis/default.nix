{
  pkgs,
  inputs,
  libwasmvm_1,
}: let
  utilities = import ../utilities.nix {
    inherit pkgs;
    inherit (inputs) nix-std;
  };
in
  with inputs;
    builtins.mapAttrs
    (_: utilities.mkCosmosGoApp)
    {
      osmosis1 = {
        name = "osmosis";
        version = "v1.0.3";
        src = inputs.osmosis1-src;
        vendorSha256 = "sha256-WrQWRYz/t0dHIbIvQOwuciO8y2dD/Q7aTgcrT77B/nM=";
        tags = ["netgo"];
      };

      osmosis2 = {
        name = "osmosis";
        version = "v2.0.0";
        src = inputs.osmosis2-src;
        vendorSha256 = "sha256-BBm/oKsYmlzVbCC3O6gX3uAXrISaXDMsl/3dfPvRQGY=";
        tags = ["netgo"];
      };

      osmosis3 = {
        name = "osmosis";
        version = "v3.1.0";
        src = inputs.osmosis3-src;
        vendorSha256 = "sha256-8hmIStChc1jJiawU1tkUlkaokVGZEIFc5nI0jLHRPjI=";
        tags = ["netgo"];
      };

      osmosis4 = {
        name = "osmosis";
        version = "v4.2.0";
        src = inputs.osmosis4-src;
        vendorSha256 = "sha256-5P+HBZruAllTnykPfIec1EFrp6Wk4APz1QbLnJH5QQs=";
        tags = ["netgo"];
      };

      osmosis5 = {
        name = "osmosis";
        version = "v5.0.0";
        src = inputs.osmosis5-src;
        vendorSha256 = "sha256-YTXFxGsee6/ZS0oKquc+wQP9N7o1PrAI9h10PX6m87o=";
        tags = ["netgo"];
      };

      osmosis6 = {
        name = "osmosis";
        version = "v6.4.1";
        src = inputs.osmosis6-src;
        vendorSha256 = "sha256-UI5QGQsTLPnsDWWPUG+REsvF4GIeFeNHOiG0unNXmdY=";
        tags = ["netgo"];
      };

      osmosis7 = {
        name = "osmosis";
        version = "v7.3.0";
        src = inputs.osmosis7-src;
        excludedPackages = "./tests/e2e";
        vendorSha256 = "sha256-BL6Ko6jq1pumPgXCId+pj6juWYTbmkWauYKpefFZNug=";
        tags = ["netgo"];
        preFixup = utilities.wasmdPreFixupPhase "osmosisd";
        buildInputs = [libwasmvm_1];

        # Test has to be skipped as end-to-end testing requires network access
        doCheck = false;
      };

      osmosis8 = {
        name = "osmosis";
        version = "v8.0.0";
        src = inputs.osmosis8-src;
        excludedPackages = "./tests/e2e";
        vendorSha256 = "sha256-sdj59aZJBF4kpolHnYOHHO4zs7vKFu0i1xGKZFEiOyQ=";
        tags = ["netgo"];
        preFixup = utilities.wasmdPreFixupPhase "osmosisd";
        dontStrip = true;
        buildInputs = [libwasmvm_1];

        # Test has to be skipped as end-to-end testing requires network access
        doCheck = false;
      };

      osmosis9 = {
        name = "osmosis";
        version = "v9.0.0";
        src = inputs.osmosis9-src;
        excludedPackages = "./tests/e2e";
        vendorSha256 = "sha256-BsYqWU+2c5mGok4GmjQcUIlsToEOgKQstA+1VbMEfUE=";
        tags = ["netgo"];
        preFixup = utilities.wasmdPreFixupPhase "osmosisd";
        dontStrip = true;
        buildInputs = [libwasmvm_1];

        # Test has to be skipped as end-to-end testing requires network access
        doCheck = false;
      };

      osmosis10 = {
        name = "osmosis";
        version = "v10.2.0";
        src = inputs.osmosis10-src;
        excludedPackages = "./tests/e2e";
        vendorSha256 = "sha256-nHqpHwwR4L6Je8SKoDTe23Ex72bcScHBynTfcAT16fI=";
        tags = ["netgo"];
        preFixup = utilities.wasmdPreFixupPhase "osmosisd";
        dontStrip = true;
        buildInputs = [libwasmvm_1];

        # Test has to be skipped as end-to-end testing requires network access
        doCheck = false;
      };

      osmosis11 = {
        name = "osmosis";
        version = "v11.0.1";
        src = inputs.osmosis11-src;
        excludedPackages = "./tests/e2e";
        vendorSha256 = "sha256-4AgJ+0FlRQG5ZAhuFMABMKFu/Z8xxGLy+1i54CKqrFs=";
        tags = ["netgo"];
        preFixup = utilities.wasmdPreFixupPhase "osmosisd";
        dontStrip = true;
        buildInputs = [libwasmvm_1];

        # Test has to be skipped as end-to-end testing requires network access
        doCheck = false;
      };

      osmosis12 = {
        name = "osmosis";
        version = "v12.2.0";
        src = inputs.osmosis12-src;
        vendorSha256 = "sha256-9Al+LdDrVKBd9GP/uCiUcf0G5MQbk8ka7uRKqYp7Xtg=";
        tags = ["netgo"];
        preFixup = ''
          ${utilities.wasmdPreFixupPhase "osmosisd"}
          ${utilities.wasmdPreFixupPhase "chain"}
          ${utilities.wasmdPreFixupPhase "node"}
        '';
        buildInputs = [libwasmvm_1];

        # Test has to be skipped as end-to-end testing requires network access
        doCheck = false;
      };
    }
