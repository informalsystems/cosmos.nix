{
  inputs,
  mkCosmosGoApp,
}:
with inputs;
  builtins.mapAttrs (_: mkCosmosGoApp)
  {
    gaia-main = {
      name = "gaia";
      vendorSha256 = "sha256-V0DMuwKeCYpVlzF9g3cQD6YViJZQZeoszxbUqrUyQn4=";
      version = "v8.0.0";
      src = gaia5-src;
      engine = "tendermint/tendermint";
    };

    gaia5 = {
      name = "gaia";
      vendorSha256 = "sha256-V0DMuwKeCYpVlzF9g3cQD6YViJZQZeoszxbUqrUyQn4=";
      version = "v5.0.6";
      src = gaia5-src;
      tags = ["netgo"];
      engine = "tendermint/tendermint";
    };

    gaia6 = {
      name = "gaia";
      vendorSha256 = "sha256-KeF3gO5sUJEXWqb6EVYBYXpVBfhvyXZ4f03l63wYTjE=";
      version = "v6.0.4";
      src = gaia6-src;
      tags = ["netgo"];
      engine = "tendermint/tendermint";
    };

    gaia6-ordered = {
      name = "gaia";
      vendorSha256 = "sha256-4gBFn+zY3JK2xGKdIlYgRbK3WWjmtKFdEaUc1+nT4zw=";
      version = "v6.0.4-ordered";
      src = gaia6-ordered-src;
      tags = ["netgo"];
      engine = "tendermint/tendermint";
    };

    gaia7 = {
      name = "gaia";
      vendorSha256 = "sha256-bNeSSZ1n1fEvO9ITGGJzsc+S2QE7EoB703mPHzrEqAg=";
      version = "v7.1.0";
      src = gaia7-src;
      tags = ["netgo"];
      engine = "tendermint/tendermint";

      # Tests have to be disabled because they require Docker to run
      doCheck = false;
    };

    gaia8 = {
      name = "gaia";
      vendorSha256 = "sha256-w3MLjxXzKytMxCN9Q9RPeeXq7ijDQXoH0d+ti5FLMtA=";
      version = "v8.0.1";
      src = gaia8-src;
      tags = ["netgo"];
      engine = "tendermint/tendermint";
      proxyVendor = true;

      # Tests have to be disabled because they require Docker to run
      doCheck = false;
    };

    gaia9 = {
      name = "gaia";
      vendorSha256 = "sha256-W1pKtrWfXe0pdO7ntcjFbDa0LTpD91yI2mUMXBiDo1w=";
      version = "v9.0.3";
      src = gaia9-src;
      tags = ["netgo"];
      engine = "cometbft/cometbft";
      proxyVendor = true;

      # Tests have to be disabled because they require Docker to run
      doCheck = false;
    };

    gaia10 = {
      name = "gaia";
      vendorSha256 = "sha256-W0+XQyXDvwKq7iS9GhW/UK0/4D32zK26u0abGNPsdZc=";
      version = "v10.0.2";
      src = gaia10-src;
      tags = ["netgo"];
      engine = "cometbft/cometbft";
      proxyVendor = true;

      # Tests have to be disabled because they require Docker to run
      doCheck = false;
    };

    gaia11 = {
      name = "gaia";
      vendorSha256 = "sha256-05S5mmex/IReEBfo0BgB/99NWY7tGM2wWCi0qTa50oM=";
      version = "v11.0.0";
      src = gaia11-src;
      tags = ["netgo"];
      engine = "cometbft/cometbft";
      proxyVendor = true;

      # Tests have to be disabled because they require Docker to run
      doCheck = false;
    };

    gaia12 = {
      name = "gaia";
      vendorSha256 = "sha256-yULjy7lBfxgm0rZjqwIAu99TYBnW4O29mz7u+Bnu6gY=";
      version = "v12.0.0";
      src = gaia12-src;
      tags = ["netgo"];
      engine = "cometbft/cometbft";
      proxyVendor = true;

      # Tests have to be disabled because they require Docker to run
      doCheck = false;
    };

    gaia13 = {
      name = "gaia";
      vendorSha256 = "sha256-SQF6YNVVOfpL55Uc4LIzo2jv/cdKp8hHUeqcpc/dBEc=";
      version = "v13.0.2";
      goVersion = "1.20";
      src = gaia13-src;
      tags = ["netgo"];
      engine = "cometbft/cometbft";
      proxyVendor = true;

      # Tests have to be disabled because they require Docker to run
      doCheck = false;
    };

    gaia14 = {
      name = "gaia";
      vendorSha256 = "sha256-7hmP0Uc4HHW7voy3DRMkpAXifon/qnaaT6jaUf/h8HU=";
      version = "v14.0.0";
      goVersion = "1.20";
      src = gaia14-src;
      tags = ["netgo"];
      engine = "cometbft/cometbft";
      proxyVendor = true;

      # Tests have to be disabled because they require Docker to run
      doCheck = false;
    };
  }
