# Cosmos.nix

This is an experimental Nix project for integrating the Rust and Go projects in Cosmos
as Nix packages. Use this at your own risk.

## Installation

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

## Sources

Right now only the sources of the upstream projects are given as
a Nix derivation. You can build them by running:

```bash
$ nix build .#sources
$ ls result/
cosmos-sdk  gaia  ibc-go  ibc-rs  tendermint-rs
```

This is just to show that our Nix derivations now have access to the source code
of the upstream projects we want to support. The exact versions of the source code
are pinned inside the `flake.lock` file, and can be updated using the
`nix flake lock` command.

We will then build actual Nix derivations based on these source files
in upcoming development.
