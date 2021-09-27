# ADR 1: E2E testing infrastructure for ibc-rs and IBC in general

## Context

The current system for testing ibc is a collection of shell scripts called
[gaia-manager](https://github.com/informalsystems/ibc-rs/tree/master/scripts),
`gm` for short.

These shell scripts read from a TOML configuration file, and spin up the
requesite chain infrastructure. There is also test automation via [E2E
tests](https://github.com/informalsystems/ibc-rs/tree/master/e2e) written in
python.

This testing system looks good, and the cosmos.nix project has made efforts to
support this workflow by providing the main
[gm](https://github.com/informalsystems/cosmos.nix/tree/master/gm) script,
along with its runtime dependencies (`sconfig` and `stoml`) bundled into a
single executable.

There is, however, interest in providing a testing solution that is enabled by
nix.  This kind of solution would provide a few things in addition to what
exists today: all dependencies included, virtualization, deployability, a
general solution for IBC testing, manual and automated.

- **all dependencies included**: This is handled quite well by nix, but the
idea is that the end user should not be required to install more than nix and
the flake to run the test infra.
 **virtualization**: It would be nice to be able to run these tests in a
sandboxed environment to prevent flaky tests.
- **deployability**: Testing locally is important, but testing across real
network partitions can improve confidence.
- **a general solution for IBC testing**: Cosmos.nix provides a bunch of chains
that may be IBC enabled, it would be nice to provide a testing framework that
could be used against any of these chains!
- **manual and automated**: If possible, it would be desirable to provide an
environment for automated testing as well as an environment where a user can
execute an action and inspect the state of the system manually.

Issues: [15](https://github.com/informalsystems/cosmos.nix/issues/15)

### Implementation goals

1. Local variant (as well as any required virtualization) should work on mac
   and linux
2. Should require no knowledge, or limited knowledge of nix
3. Should priortize testing [ibc-rs](https://github.com/informalsystems/ibc-rs)
   with [gaia](https://github.com/cosmos/gaia) over other relayer
   implementations and other chains

## Decision

I think that we should look into two approaches to testing:

1. A manual testing setup that allows the user to bring their own relayer
   implementation and spins up chains for them
2. An automated testing harness that can allow users to declaratively configure
   IBC enabled chains, and a relayer of their choice, and run a series of
   tests.

### 1. Manual Testing

The simplest solution for this is a nix-shell and cli tool that optionally
reads from a configuration file. This could be as easy as reusing `gm`. The
`nix-shell` could include a hook to automatically look for a configuration file
and run the program to spin up the chains.

We could write a more robust cli tool in a more expressive programming language
than bash. I would recommend `rust` given informal systems' proclivity for it.

The most complicated solution would be to reuse the nixos modules that will be
created based on this
[issue](https://github.com/informalsystems/cosmos.nix/issues/26). This would
require virtualization so that a minimal nixos box could be stood up with the
chains enabled as systemd services. There could be multiple vms or a single vm
running multiple chains as services. Multiple vms would lend itself better to
reuse as a **deployable** option.

My recommendation is a staged approach:
1. Users should already be able to access `gm` in a remote nix shell pending
   the merge of [35](https://github.com/informalsystems/cosmos.nix/pull/35)
2. Add a bespoke flake for `gm` with only the dependencies required to test and
   a shellhook that will detect a `gm` configuration based on 3 factors (local
   file called `gm.toml`, `$HOME/.gm/gm.toml`, path defined by the env var
   `$GM_CONFIG`) in respective order of precedence
3. Write a custom cli tool in `rust` that is a drop in replacement for `gm`
4. Provide nix-configurable virtualization that uses nixos-modules for the
   relayer and IBC enabled chains

Virtualization would be provided via QEMU since it has darwin support, and
there are efforts for nix to provide QEMU darwin support directly (tracked in
this [issue](https://github.com/NixOS/nixpkgs/issues/108984)). Virtualization
has the benefit of making the tests more portable to different contexts but has
the drawback of requiring users to configure their setups in nix.

At each stage, the value to the user can be assessed, and if there is little
pain the rest of the plan can be abandoned.

### 2. Automated Testing

Although there is already automated testing provided for `ibc-rs` in the form
of an E2E python test suite, I think there would be value in providing a
generic testing harness in which any IBC enabled chain and any relayer can be
substituted in.

My recommendation for the virtualization and automation of the tests is [NixOS
Tests](https://nixos.org/manual/nixos/stable/index.html#sec-nixos-tests). A more
hands on tutorial (that isn't just reference documentation) can be found
[here](https://nix.dev/tutorials/integration-testing-using-virtual-machines#integration-testing-vms).

I think a good approach is to start with something that works for `ibc-rs` and `gaia`
with a fixed number of chains, and see how much of that can be generalized to different
chain / relayer configurations. As well as how much would be applicable to more exotic
IBC enabled applications.

NixOS Tests depend on QEMU and are blocked from working on darwin until this
[issue](https://github.com/NixOS/nixpkgs/issues/108984) is resolved.

## Status

Proposed

## Consequences

The positive consequences are that we would end up with a more ergonomic, and
easier to setup workflow for testing `ibc-rs` and ibc enabled chains in
general.

The potential negative consequences are:
- Opportunity cost; could be implementing other features
- Overhead cost of more code in the repo
- Toil as developers are met with conflicting workflows and exotic tools like nix
