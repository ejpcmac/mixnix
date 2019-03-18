{ mix2nix, erlangR19 }:

let
  src = fetchGit {
    url = https://github.com/asciinema/asciinema-server;
    rev = "5f8dd03ad552c8b8de4f5e367c2bd2c4735dec40";
  };
in mix2nix.mkMixPackage {
  name = "asciinema-server";
  version = "v20190302";
  inherit src;
  mixLock = "${src}/mix.lock";
  erlang = erlangR19;
}
