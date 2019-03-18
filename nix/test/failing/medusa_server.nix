{ mix2nix }:

let
  src = fetchGit {
    url = https://github.com/kurenn/medusa_server;
    rev = "5f3724e349a340ff8b55d57a6f0302cd945bca8f";
  };
in mix2nix.mkMixPackage {
  name = "medusa_server";
  version = "0.1.0";
  inherit src;
  mixLock = "${src}/mix.lock";
}
