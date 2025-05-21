{
  inputs,
  mkCosmosGoApp,
  libwasmvm_1_5_0,
  libwasmvm_2_0_0,
  libwasmvm_2_1_2,
  libwasmvm_2_2_3,
  cosmosLib,
}: let
  gaias = with inputs;
    builtins.mapAttrs (_: mkCosmosGoApp)
    {
      gaia5 = {
        name = "gaia";
        vendorHash = "sha256-V0DMuwKeCYpVlzF9g3cQD6YViJZQZeoszxbUqrUyQn4=";
        version = "v5.0.6";
        src = gaia5-src;
        rev = gaia5-src.rev;
        tags = ["netgo"];
        engine = "tendermint/tendermint";
      };

      gaia6 = {
        name = "gaia";
        vendorHash = "sha256-KeF3gO5sUJEXWqb6EVYBYXpVBfhvyXZ4f03l63wYTjE=";
        version = "v6.0.4";
        src = gaia6-src;
        rev = gaia6-src.rev;
        tags = ["netgo"];
        engine = "tendermint/tendermint";
      };

      gaia6-ordered = {
        name = "gaia";
        vendorHash = "sha256-4gBFn+zY3JK2xGKdIlYgRbK3WWjmtKFdEaUc1+nT4zw=";
        version = "v6.0.4-ordered";
        src = gaia6-ordered-src;
        rev = gaia6-ordered-src.rev;
        tags = ["netgo"];
        engine = "tendermint/tendermint";
      };

      gaia7 = {
        name = "gaia";
        vendorHash = "sha256-bNeSSZ1n1fEvO9ITGGJzsc+S2QE7EoB703mPHzrEqAg=";
        version = "v7.1.0";
        src = gaia7-src;
        rev = gaia7-src.rev;
        tags = ["netgo"];
        engine = "tendermint/tendermint";

        # Tests have to be disabled because they require Docker to run
        doCheck = false;
      };

      gaia8 = {
        name = "gaia";
        vendorHash = "sha256-Wu4KZVzBCdGOCbHzaAE7zRFrYurlIeC0eJmOg28xbXg=";
        version = "v8.0.1";
        src = gaia8-src;
        rev = gaia8-src.rev;
        tags = ["netgo"];
        engine = "tendermint/tendermint";
        proxyVendor = true;

        # Tests have to be disabled because they require Docker to run
        doCheck = false;
      };

      gaia9 = {
        name = "gaia";
        vendorHash = "sha256-WIJ/VTMNh1YSj9fkmoJv1giANNgANV+pLdFzY2dqhVQ=";
        version = "v9.0.3";
        src = gaia9-src;
        rev = gaia9-src.rev;
        tags = ["netgo"];
        engine = "cometbft/cometbft";
        proxyVendor = true;

        # Tests have to be disabled because they require Docker to run
        doCheck = false;
      };

      gaia10 = {
        name = "gaia";
        vendorHash = "sha256-gL7Ved289OTelPXG3/bHzd4WtXk0TX9JFsIjJV2nyeo=";
        version = "v10.0.2";
        src = gaia10-src;
        rev = gaia10-src.rev;
        tags = ["netgo"];
        engine = "cometbft/cometbft";
        proxyVendor = true;

        # Tests have to be disabled because they require Docker to run
        doCheck = false;
      };

      gaia11 = {
        name = "gaia";
        vendorHash = "sha256-Qrd/w10j6kCO0fO98d1X1q4QNua2/obIht4AijVWuxk=";
        version = "v11.0.0";
        src = gaia11-src;
        rev = gaia11-src.rev;
        tags = ["netgo"];
        engine = "cometbft/cometbft";
        proxyVendor = true;

        # Tests have to be disabled because they require Docker to run
        doCheck = false;
      };

      gaia12 = {
        name = "gaia";
        vendorHash = "sha256-Q4dthEaOFF1GQUSsBi7FtXjeWpjDbirbiXLIU0vfaRQ=";
        version = "v12.0.0";
        src = gaia12-src;
        rev = gaia12-src.rev;
        tags = ["netgo"];
        engine = "cometbft/cometbft";
        proxyVendor = true;

        # Tests have to be disabled because they require Docker to run
        doCheck = false;
      };

      gaia13 = {
        name = "gaia";
        vendorHash = "sha256-GvinrC9/O7EjHqcWRC/CzbYIGdULiJxTGY3HH1LSz1U=";
        version = "v13.0.2";
        src = gaia13-src;
        rev = gaia13-src.rev;
        tags = ["netgo"];
        engine = "cometbft/cometbft";
        proxyVendor = true;

        # Tests have to be disabled because they require Docker to run
        doCheck = false;
      };

      gaia14 = {
        name = "gaia";
        vendorHash = "sha256-kmDemA4dfu8di9xzm6qLJZJ8sqQ56B7tbWuSBMsJKNY=";
        version = "v14.0.0";
        src = gaia14-src;
        rev = gaia14-src.rev;
        tags = ["netgo"];
        engine = "cometbft/cometbft";
        proxyVendor = true;

        # Tests have to be disabled because they require Docker to run
        doCheck = false;
      };

      gaia15 = {
        name = "gaia";
        vendorHash = "sha256-Ozh2m3YBdYVpN9qaywUbQ1ewFpwL4uWCdhmNTxBhSkI=";
        version = "v15.2.0";
        src = gaia15-src;
        rev = gaia15-src.rev;
        tags = ["netgo"];
        engine = "cometbft/cometbft";
        proxyVendor = true;

        # Tests have to be disabled because they require Docker to run
        doCheck = false;
      };

      gaia17 = {
        name = "gaia";
        vendorHash = "sha256-5XRQj6zR1VsJRe3VrjzI6INvm1Obz9JgmCQTQpCZyf0=";
        version = "v17.2.0";
        goVersion = "1.23";
        src = gaia17-src;
        rev = gaia17-src.rev;
        tags = ["netgo"];
        engine = "cometbft/cometbft";
        proxyVendor = true;

        # Tests have to be disabled because they require Docker to run
        doCheck = false;
      };

      gaia18 = {
        name = "gaia";
        vendorHash = "sha256-+vTP15mftPKWMkE4yI3avI+jQt917YCYGdUt29E1lYs=";
        version = "v18.1.0";
        goVersion = "1.23";
        src = gaia18-src;
        rev = gaia18-src.rev;
        tags = ["netgo"];
        engine = "cometbft/cometbft";
        proxyVendor = true;

        preFixup = ''
          ${cosmosLib.wasmdPreFixupPhase libwasmvm_1_5_0 "gaiad"}
        '';
        buildInputs = [libwasmvm_1_5_0];

        # Tests have to be disabled because they require Docker to run
        doCheck = false;
      };

      gaia19 = {
        name = "gaia";
        vendorHash = "sha256-+9Q5Zcg/WtUPp1AbU9sGh9pxALjJesQ+m2sd4WQYOEs=";
        version = "v19.1.0";
        # nixpkgs latest go version v1.22 is v1.22.5 but Gaia v19.1.0 requires
        # v1.22.6 or more so v1.23 is used instead
        goVersion = "1.23";
        src = gaia19-src;
        rev = gaia19-src.rev;
        tags = ["netgo"];
        engine = "cometbft/cometbft";
        proxyVendor = true;

        preFixup = ''
          ${cosmosLib.wasmdPreFixupPhase libwasmvm_2_0_0 "gaiad"}
        '';
        buildInputs = [libwasmvm_2_0_0];

        # Tests have to be disabled because they require Docker to run
        doCheck = false;

        excludedPackages = ["tests/interchain"];
      };

      gaia20 = {
        name = "gaia";
        vendorHash = "sha256-1WErtwmYr3AgY1lFpiFYrosU4leJ+ZC13Vbk8vwmmg8=";
        version = "v20.0.0";
        # nixpkgs latest go version v1.22 is v1.22.5 but Gaia v20.0.0 requires
        # v1.22.6 or more so v1.23 is used instead
        goVersion = "1.23";
        src = gaia20-src;
        rev = gaia20-src.rev;
        tags = ["netgo"];
        engine = "cometbft/cometbft";
        proxyVendor = true;

        preFixup = ''
          ${cosmosLib.wasmdPreFixupPhase libwasmvm_2_1_2 "gaiad"}
        '';
        buildInputs = [libwasmvm_2_1_2];

        # Tests have to be disabled because they require Docker to run
        doCheck = false;

        excludedPackages = ["tests/interchain"];
      };

      gaia23 = {
        name = "gaia";
        vendorHash = "sha256-ZIbxM5jTT0SyAYRbC51ilFkMcmkz5RQ3vt5xKA6TSIU=";
        version = "v23.3.0";
        # nixpkgs latest go version v1.22 is v1.22.5 but Gaia v20.0.0 requires
        # v1.22.6 or more so v1.23 is used instead
        goVersion = "1.23";
        src = gaia23-src;
        rev = gaia23-src.rev;
        tags = ["netgo"];
        engine = "cometbft/cometbft";
        proxyVendor = true;

        preFixup = ''
          ${cosmosLib.wasmdPreFixupPhase libwasmvm_2_2_3 "gaiad"}
        '';
        buildInputs = [libwasmvm_2_2_3];

        # Tests have to be disabled because they require Docker to run
        doCheck = false;

        excludedPackages = ["tests/interchain"];
      };
    };
in
  gaias // {gaia-main = gaias.gaia8;}
