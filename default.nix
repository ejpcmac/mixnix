{ pkgs ? import (fetchTarball {
    url = https://github.com/nixos/nixpkgs-channels/archive/0125544e2a0552590c87dca1583768b49ba911c0.tar.gz;
    sha256 = "04xvlqw3zbq91zkfa506b2k1ajmj7pqh3nvdh9maabw6m5jhm5rl";
  }
) {}}:

let
  mix2nix = pkgs.callPackage ./nix/mix2nix.nix { };
in mix2nix.mix2nix
