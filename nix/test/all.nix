{ pkgs ? (import <nixpkgs> {})
, callPackage ? pkgs.callPackage
, mix2nix ? pkgs.callPackage ../mix2nix.nix { }
}:

let
  call = file: callPackage file { inherit mix2nix; };
in {
  failing = {
    n2o = call ./failing/n2o.nix;
    medusa_server = call ./failing/medusa_server.nix;
  };
  passing = {
    captain-fact-api = call ./passing/captain-fact-api.nix;
    asciinema-server = call ./passing/asciinema-server.nix;
  };
}
