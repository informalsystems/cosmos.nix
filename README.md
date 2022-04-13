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

##### Cache Setup with Cachix

With nix installed you can run `nix-env -iA cachix -f https://cachix.org/api/v1/install`. If you don't want to install cachix globally and just want a one time use, you can run `nix-shell -p cachix` to enter a temporary shell with `cachix` available. You can check that this worked by running `cachix --version`.

You can now run these commands to add all of our cachix caches:

```bash
$ cachix use cosmos
$ cachix use pre-commit-hooks
$ cachix use nix-community
```

##### Manual Cache Setup

Add these lines to your Nix config (either ~/.config/nix/nix.conf [for MacOS] or
/etc/nix/nix.conf [for flavors of Linux, depending on your distro]):

```
extra-substituters = https://cache.nixos.org https://nix-community.cachix.org https://pre-commit-hooks.cachix.org https://cosmos.cachix.org
trusted-public-keys = nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc= cosmos.cachix.org-1:T5U9yg6u2kM48qAOXHO/ayhO8IWFnv0LOhNcq0yKuR8=
cores = 4 # NB: You may want to increase this on machines with more cores
```

### NixOS

In your `configuration.nix` file you can add code below. It does 2 things, the
first is that it enables nix experimental features (which enables flakes) and
second it adds cache information so you don't have to build everything yourself.
Note, you can add the suggested binary caches in addition to your existing ones.

```nix
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    binaryCaches = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://pre-commit-hooks.cachix.org"
      "https://cosmos.cachix.org"
    ];
    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
      "cosmos.cachix.org-1:T5U9yg6u2kM48qAOXHO/ayhO8IWFnv0LOhNcq0yKuR8="
    ];
   };
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

## Development

#### Formatting

Formatting will be run via pre-commit hook if you are in the nix shell, otherise you can manually format using the `format` command like so:

```bash
nix develop -c format
```

## Applications

> Note: every command has a local and a remote variant. The local variant requires
> that the command is run from within the cloned repo. The remote variant can be run
> from wherever.
>
> Local: nix run .#my-app-name
>
> Remote: nix run github:informalsystems/cosmos.nix#my-app-name
>
> For brevity and consistency all the commands are listed in the local variant

### Executables provided

#### Relayers
- [hermes](https://hermes.informal.systems/): `nix run .#hermes`
- [ts-relayer](https://github.com/confio/ts-relayer):
  - `nix run .#ts-relayer`
  - `nix run .#ts-relayer-setup`
- [relayer](https://github.com/cosmos/relayer): `nix run .#relayer`

#### Validators
- [thor](https://github.com/thorchain/thornode):
  - bifrost: `nix run .#bifrost`
  - thorcli: `nix run .#thorcli`
  - thord: `nix run .#thord`
- [osmosis](https://github.com/osmosis-labs/osmosis): `nix run .#osmosis`
- [gravity dex](https://github.com/b-harvest/gravity-dex-backend): `nix run .#gdex`
- [iris](https://github.com/irisnet/irishub): `nix run .#iris`
- [regen](https://github.com/regen-network/regen-ledger): `nix run .#regen`
- [evmos](https://github.com/tharsis/evmos): `nix run .#evmos`

#### Development Tools
- [gaia](https://hub.cosmos.network/main/gaia-tutorials/what-is-gaia.html): `nix run .#gaia`
- [ica](https://github.com/cosmos/interchain-accounts-demo): `nix run .#ica`
- [cosmovisor](https://docs.cosmos.network/master/run-node/cosmovisor.html): `nix run .#cosmovisor`
- [simd](https://docs.cosmos.network/master/run-node/interact-node.html): `nix run .#simd`
- [gm](https://github.com/informalsystems/ibc-rs/tree/master/scripts/gm): `nix run .#gm`
