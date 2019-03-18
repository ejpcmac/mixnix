{ git, strace, tree, rebar3, erlang, elixir, ... }:

let
  straceExec = "${strace}/bin/strace -f -s1000 -e trace=execve,stat,access,getcwd,openat";
in {
  cowlib = {name, version, ...}: {
    ERLC_OPTS = "-W0"; # disable warnings

    preInstall = ''
      export HOME=$PWD
    '';
  };

  cowboy = {...}: {
    preBuild = ''
      grep erl_opts rebar.config > new_rebar.config
      mv new_rebar.config rebar.config
    '';
  };

  idna = {name, version, ...}: {
    preBuild = ''
      rm -f rebar.lock rebar.config
    '';
  };

  certifi = {name, version, ...}: {
    preBuild = ''
      rm rebar.config
    '';
  };

  ssl_verify_fun = { name, version, ... }: {
    preConfigure = ''
      ln -s ${rebar3}/bin/rebar3
    '';

    HEX_REGISTRY_SNAPSHOT = ./registry.ets;
  };

  guardian_db = {...}: {
    preBuild = ''
      mkdir -p config
      echo 'use Mix.Config' > config/config.exs
      echo 'config :guardian, Guardian.DB, schema_name: "something", repo: Guardian.DB' >> config/config.exs
    '';
  };

  hackney = {...}: {
    patches = [ ./patches/hackney.patch ];
  };
}
