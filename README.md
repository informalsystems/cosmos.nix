<p align="center">

<img src="https://raw.githubusercontent.com/informalsystems/cosmos.nix/master/images/logo.png" width="320" height="320"/>
</p>

<p align="center">
<a href="https://cosmos.network/">
  <img src="https://img.shields.io/static/v1?label=&labelColor=1B1E36&color=1B1E36&message=cosmos%20ecosystem&style=for-the-badge&logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4KPCEtLSBHZW5lcmF0b3I6IEFkb2JlIElsbHVzdHJhdG9yIDI0LjMuMCwgU1ZHIEV4cG9ydCBQbHVnLUluIC4gU1ZHIFZlcnNpb246IDYuMDAgQnVpbGQgMCkgIC0tPgo8c3ZnIHZlcnNpb249IjEuMSIgaWQ9IkxheWVyXzEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHg9IjBweCIgeT0iMHB4IgoJIHZpZXdCb3g9IjAgMCAyNTAwIDI1MDAiIHN0eWxlPSJlbmFibGUtYmFja2dyb3VuZDpuZXcgMCAwIDI1MDAgMjUwMDsiIHhtbDpzcGFjZT0icHJlc2VydmUiPgo8c3R5bGUgdHlwZT0idGV4dC9jc3MiPgoJLnN0MHtmaWxsOiM2RjczOTA7fQoJLnN0MXtmaWxsOiNCN0I5Qzg7fQo8L3N0eWxlPgo8cGF0aCBjbGFzcz0ic3QwIiBkPSJNMTI1Mi42LDE1OS41Yy0xMzQuOSwwLTI0NC4zLDQ4OS40LTI0NC4zLDEwOTMuMXMxMDkuNCwxMDkzLjEsMjQ0LjMsMTA5My4xczI0NC4zLTQ4OS40LDI0NC4zLTEwOTMuMQoJUzEzODcuNSwxNTkuNSwxMjUyLjYsMTU5LjV6IE0xMjY5LjQsMjI4NGMtMTUuNCwyMC42LTMwLjksNS4xLTMwLjksNS4xYy02Mi4xLTcyLTkzLjItMjA1LjgtOTMuMi0yMDUuOAoJYy0xMDguNy0zNDkuOC04Mi44LTExMDAuOC04Mi44LTExMDAuOGM1MS4xLTU5Ni4yLDE0NC03MzcuMSwxNzUuNi03NjguNGM2LjctNi42LDE3LjEtNy40LDI0LjctMmM0NS45LDMyLjUsODQuNCwxNjguNSw4NC40LDE2OC41CgljMTEzLjYsNDIxLjgsMTAzLjMsODE3LjksMTAzLjMsODE3LjljMTAuMywzNDQuNy01Ni45LDczMC41LTU2LjksNzMwLjVDMTM0MS45LDIyMjIuMiwxMjY5LjQsMjI4NCwxMjY5LjQsMjI4NHoiLz4KPHBhdGggY2xhc3M9InN0MCIgZD0iTTIyMDAuNyw3MDguNmMtNjcuMi0xMTcuMS01NDYuMSwzMS42LTEwNzAsMzMycy04OTMuNSw2MzguOS04MjYuMyw3NTUuOXM1NDYuMS0zMS42LDEwNzAtMzMyCglTMjI2Ny44LDgyNS42LDIyMDAuNyw3MDguNkwyMjAwLjcsNzA4LjZ6IE0zNjYuNCwxNzgwLjRjLTI1LjctMy4yLTE5LjktMjQuNC0xOS45LTI0LjRjMzEuNi04OS43LDEzMi0xODMuMiwxMzItMTgzLjIKCWMyNDkuNC0yNjguNCw5MTMuOC02MTkuNyw5MTMuOC02MTkuN2M1NDIuNS0yNTIuNCw3MTEuMS0yNDEuOCw3NTMuOC0yMzBjOS4xLDIuNSwxNSwxMS4yLDE0LDIwLjZjLTUuMSw1Ni0xMDQuMiwxNTctMTA0LjIsMTU3CgljLTMwOS4xLDMwOC42LTY1Ny44LDQ5Ni44LTY1Ny44LDQ5Ni44Yy0yOTMuOCwxODAuNS02NjEuOSwzMTQuMS02NjEuOSwzMTQuMUM0NTYsMTgxMi42LDM2Ni40LDE3ODAuNCwzNjYuNCwxNzgwLjRMMzY2LjQsMTc4MC40CglMMzY2LjQsMTc4MC40eiIvPgo8cGF0aCBjbGFzcz0ic3QwIiBkPSJNMjE5OC40LDE4MDAuNGM2Ny43LTExNi44LTMwMC45LTQ1Ni44LTgyMy03NTkuNVMzNzQuNCw1ODcuOCwzMDYuOCw3MDQuN3MzMDAuOSw0NTYuOCw4MjMuMyw3NTkuNQoJUzIxMzAuNywxOTE3LjQsMjE5OC40LDE4MDAuNHogTTM1MS42LDc0OS44Yy0xMC0yMy43LDExLjEtMjkuNCwxMS4xLTI5LjRjOTMuNS0xNy42LDIyNC43LDIyLjYsMjI0LjcsMjIuNgoJYzM1Ny4yLDgxLjMsOTk0LDQ4MC4yLDk5NCw0ODAuMmM0OTAuMywzNDMuMSw1NjUuNSw0OTQuMiw1NzYuOCw1MzcuMWMyLjQsOS4xLTIuMiwxOC42LTEwLjcsMjIuNGMtNTEuMSwyMy40LTE4OC4xLTExLjUtMTg4LjEtMTEuNQoJYy00MjIuMS0xMTMuMi03NTkuNi0zMjAuNS03NTkuNi0zMjAuNWMtMzAzLjMtMTYzLjYtNjAzLjItNDE1LjMtNjAzLjItNDE1LjNjLTIyNy45LTE5MS45LTI0NS0yODUuNC0yNDUtMjg1LjRMMzUxLjYsNzQ5Ljh6Ii8+CjxjaXJjbGUgY2xhc3M9InN0MSIgY3g9IjEyNTAiIGN5PSIxMjUwIiByPSIxMjguNiIvPgo8ZWxsaXBzZSBjbGFzcz0ic3QxIiBjeD0iMTc3Ny4zIiBjeT0iNzU2LjIiIHJ4PSI3NC42IiByeT0iNzcuMiIvPgo8ZWxsaXBzZSBjbGFzcz0ic3QxIiBjeD0iNTUzIiBjeT0iMTAxOC41IiByeD0iNzQuNiIgcnk9Ijc3LjIiLz4KPGVsbGlwc2UgY2xhc3M9InN0MSIgY3g9IjEwOTguMiIgY3k9IjE5NjUiIHJ4PSI3NC42IiByeT0iNzcuMiIvPgo8L3N2Zz4K" alt="Cosmos ecosystem"/>
</a>
<a href="https://nixos.org/">
  <img src="https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a&style=for-the-badge" alt="Built with nix" />
</a>
<a href="https://github.com/informalsystems/cosmos.nix/blob/master/LICENSE">
  <img src="https://img.shields.io/badge/license-MIT%20v3.0-brightgreen.svg?style=for-the-badge" alt="License" />
</a>

</p>


# Cosmos.nix

This is an experimental Nix project for integrating the Rust and Go projects in Cosmos
as Nix packages. Use this at your own risk.

## Setup

NOTE: If you already have nix installed, make sure you are on version >=2.18.
Instructions to upgrade nix can be found [here](https://nixos.org/manual/nix/unstable/installation/upgrading.html)

### Non-NixOS

This project is developed entirely in [Nix Flakes](https://nixos.wiki/wiki/Flakes).
To get started, run the following:

1. [Install Nix](https://nixos.org/download.html):

```bash
$ curl -L https://nixos.org/nix/install | sh
```

2. [Install Nix Unstable](https://serokell.io/blog/practical-nix-flakes):

```bash
$ nix-env -iA nixpkgs.nixFlakes
```

3. [Enable experimental features](https://serokell.io/blog/practical-nix-flakes):

```bash
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

4. [Setup Caches](https://nixos.org/manual/nix/unstable/package-management/sharing-packages.html):

add this to your /etc/nix/nix.conf file (or wherever you keep your substituters)

```
substituters = https://cosmosnix-store.s3.us-east-2.amazonaws.com
trusted-public-keys = cosmosnix.store-1:O28HneR1MPtgY3WYruWFuXCimRPwY7em5s0iynkQxdk=
```

## Shell

If you are just here for a remote nix shell (a development environment where
you don't need to clone the repo) you can run the following command:

```bash
nix develop github:informalsystems/cosmos.nix#cosmos-shell
```

This will build the development environment. The environment will then be
cached in your nix store and should be very fast. If you want to pull the
latest development environment you should run:

```bash
nix develop github:informalsystems/cosmos.nix#cosmos-shell --refresh
```

## Overlays

There are a few nix utilities provided as a nix library. There is also an
overlay for all the cosmos packages exported by this flake, so you can fold
them into your nixpkgs package set.

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    cosmos-nix.url = "github:informalsystems/cosmos.nix";
  };
  outputs = { cosmos-nix, nixpkgs }: {
    let pkgs = import nixpkgs { 
            system = "x86_64-linux"; # Or whatever system you are on
            overlays = [
                cosmos-nix.overlays.cosmosNixLib # Provides just the nix utility lib
                cosmos-nix.overlays.cosmosNix    # Provides all the cosmos packages provided by cosmos.nix
                cosmos-nix.overlay               # The default overlay gives you everything in the previous two combined
            ];
        }
    in ...
  };
}
```

## Development

#### Formatting

Formatting will be run via the default nix command. You can find the formatter configuration in `modules/formatter.nix`

```bash
nix fmt
```

#### Contribution Guide

1. Add the chains source code as a flake input

```nix
    inputs = {
        my-chain-src.url = "github:my-chains-organization/my-chains-repo";
        my-chain-src.flake = false;
    };
```

2. Add a new file in `packages/` named after the chain that you are packaging

> Usually you will use this structure for cosmos-sdk chains, there are other examples of non-sdk chains in the repo
```nix
# packages/my-chain.nix
{
  mkCosmosGoApp,
  my-chain-src,
}:
mkCosmosGoApp {
  name = "my-chain";
  version = "v0.1.0";
  src = my-chain-src;
  rev = my-chain-src.rev;
  vendorHash = "sha256-WLLQKXjPRhK19oEdqp2UBZpi9W7wtYjJMj07omH41K0=";
  tags = ["netgo"];
  engine = "cometbft/cometbft";
}
```

3. Import your new derivation into the `modules/packages.nix` file

```nix
    my-chain = import ../packages/my-chain.nix {
      inherit (cosmosLib) mkCosmosGoApp;
      inherit (inputs) my-chain-src;
    };
```

4. Test that it works by running:
```
> git add .
> nix build .#my-chain
```

5. Add the package to apps.nix, after you have built the package in step 4 you can check what the binary path is by running `ls result/`
```nix
  my-chain = {
    type = "app";
    program = "${packages.my-chain}/bin/mychaind";
  };
```
