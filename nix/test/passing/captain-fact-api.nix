{ mix2nix, beam }:

let
  src = fetchGit {
    url = https://github.com/CaptainFact/captain-fact-api;
    rev = "aaa8cfb2a9cce686b3a67f03c8f94b188a8603e8";
    ref = "v0.9.3";
  };
in mix2nix.mkMixPackage {
  name = "captain-fact-api";
  version = "0.9.3";
  inherit src;
  mixLock = "${src}/mix.lock";
  elixir = beam.packages.erlangR21.elixir_1_7;
  erlang = beam.interpreters.erlangR21;
  hex = beam.packages.erlangR21.hex.override { elixir = beam.interpreters.elixir_1_7; };
}
