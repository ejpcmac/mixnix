# MixNix

A set of tools to make integration between [Elixir](https://elixir-lang.org/)
[Mix](https://hexdocs.pm/mix/Mix.html) projects and [Nix](https://nixos.org/nix/) smooth.

This is especially useful for creating packages using nothing but MixNix and the
`mix.lock` found in almost all Elixir projects.

It's primarily meant for packaging applications for deployment, like servers or
executables, for normal development I'd still recommend a `mix` based workflow.

## Disclaimer

This project is still in early development, so I'm looking for people who can
try and run this on their projects and report any issues that might arise.

## Installation

You can run `nix-build` and use the `./result/bin/mixnix` executable.
Temporarily install into your user profile via `nix-env -i ./result`. Adding
this to nixpkgs is one of the future objectives, but not a high priority right
now until it's generally proven more useful.

## Usage

A good starting point is taking a look at the derivations in
`./nix/test/passing`. Which contains examples of some projects I got to build so
far.

### Without dependencies

If a project doesn't have any dependencies, building it is very straightforward.
As an example we'll use [tty2048](https://github.com/lexmag/tty2048).

    mix2nix.mkMixPackage {
      name = "tty2048";
      version = "0.0.1";
      src = fetchGit {
        url = https://github.com/lexmag/tty2048;
        rev = "f800247354593929b653f9f947a7c6f1844ad9fe";
      };
      releaseType = "escript";
    }


### Building on the fly

The easiest way `mixnix` can work is by using its derivation, and passing it a
`mix.lock` file to process on the fly.

This usually looks like:

#### Building Executable applications

The conventional method of making executable Elixir applications is to use the `escript.build` mix task. 

    mix2nix.mkMixPackage {
      name = "mixnix";
      version = "0.0.1";
      src = ./.;
      mixLock = ./mix.lock;
      releaseType = "escript";
    }


### Avoiding IFD (Import From Derivation)

This is required to build in more restricted environments that prevent
`import-from-derivation` like default [Hydra](https://nixos.org/hydra/)
installations or the [nixpkgs repository](https://github.com/nixos/nixpkgs).
This is usually done to avoid the significant performance impact of IFD in large
derivations.

To use `mixnix` to generate a lockfile that can be imported directly into Nix,
you can execute it like this in the root directory of your project:

    mixnix > mix.nix

MixNix will create a file describing all the dependencies needed to build the
project, mostly a mirrored version of the `mix.lock` file but without converting
it on the fly.

#### Example derivation

    mix2nix.mkMixPackage {
      name = "mixnix";
      version = "0.0.1";
      src = ./.;
      mixNix = ./mix.nix;
      releaseType = "escript";
    }
    
The only difference is that instead of `mixLock = ./mix.lock` we're now using `mixNix = ./mix.nix`.
The name and location of the file doesn't matter.

## Development

For development, I'd recommend simply starting the `nix-shell` with the
`shell.nix` in this repository. It'll make `elixir` available in your
environment, and you can just run `mix deps.get` and `mix escript.build` to get
the `mixnix` executable.

To run the Elixir tests, you can run the `mix test` or `mix test.watch` tasks.

A Nix test suite is still work in progress, for the moment there's a few
derivations in the `nix/test` directory, with failing and passing derivations
that might also make nice examples if you want to know how to use MixNix for
your own project and what might go wrong.

You can run specific tests like this:
`nix-build ./nix/test/all.nix -A passing.captain-fact-api`.

## Background

My primary objective for MixNix was to make developing and deploying Elixir
applications on NixOS one simple step. It's not fully-featured and may break
with certain dependencies that I haven't had the chance to test it with yet.

But the core idea was simple. Given that the `mix.lock` file already contains
checksums of each package, what would be the most straightforward way to teach
Nix about how to fetch them.

Turns out that the hashing algorithm is well described in the
[hex.pm specification](https://github.com/hexpm/specifications/blob/master/package_tarball.md).
So the solution was to first fetch the tarball, then create a file that contains
the contents the hash describes, and in the build step extract only the gzipped
tarball from it, which took a bit of fiddling with `dd` but ended up working
just fine for us.

If someone comes up with a more elegant solution with less steps, I'd very much
appreciate a PR :)

## Related Work

* [hex2nix](https://github.com/erlang-nix/hex2nix)
  * It was used to generate all the `beamPackages` that are found in `nixpkgs`.
    It has the tiny drawback that it downloads all of the available `hex.pm`
    packages which takes hours and may fail at any point.
  * Consequently the `beamPackages` collection hasn't been updated since March
    2018, making building any current project with it impossible.
  * It also doesn't support git dependencies or alternative repositories.
