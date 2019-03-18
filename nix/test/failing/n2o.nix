{ mix2nix }:

let
  src = fetchGit {
    url = https://github.com/synrc/n2o;
    rev = "7a4f929a27c83c33f3844ca5f6491ff17a1956ce";
  };
in mix2nix.mkMixPackage {
  name = "n2o";
  version = "0.1.0";
  inherit src;
  mixLock = "${src}/mix.lock";
}
