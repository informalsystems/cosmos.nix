# Cosmos.nix

This is an experimental Nix project for integrating the Rust and Go projects in Cosmos
as Nix packages. Use this at your own risk.

## Setup

### Non-NixOS

This project is developed entirely in [Nix Flakes](https://nixos.wiki/wiki/Flakes).
To get started, run the following:

[Install Nix](https://nixos.org/download.html):

```bash
$ curl -L https://nixos.org/nix/install | sh
```

[Install Nix Unstable](https://serokell.io/blog/practical-nix-flakes):

```bash
$ nix-env -f '<nixpkgs>' -iA nixUnstable
```

[Enable experimental features](https://serokell.io/blog/practical-nix-flakes):

```bash
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

[Setup Caches](https://nixos.org/manual/nix/unstable/package-management/sharing-packages.html)

##### Cache Setup with Cachix

With nix installed you can run `nix-env -iA cachix -f https://cachix.org/api/v1/install`.
You can check that this worked by running `cachix --version`.

You can now run these commans to add all of our cachix caches:

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
nix develop github:informalsystems/cosmos.nix
```

This will build the development environment. The environment will then be
cached in your nix store and should be very fast. If you want to pull the
latest development environment you should run:

```bash
nix develop github:informalsystems/cosmos.nix --refresh
```

## Sources

Right now only the sources of the upstream projects are given as a Nix
derivation. You can build them by running:

```bash
$ nix build
$ ls result/
cosmos-sdk  gaia  ibc-go  ibc-rs  tendermint-rs
```

This is just to show that our Nix derivations now have access to the source code
of the upstream projects we want to support. The exact versions of the source
code are pinned inside the `flake.lock` file, and can be updated using the `nix
flake lock` command.

We will then build actual Nix derivations based on these source files in
upcoming development.

## Applications

Here is a list of the commands you can invoke to run specific packges.
- [hermes](https://hermes.informal.systems/): `nix run .#hermes`
