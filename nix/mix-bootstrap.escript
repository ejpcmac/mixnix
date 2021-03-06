#!/usr/bin/env escript
%% -*- erlang-indent-level: 4;indent-tabs-mode: nil -*-
%%! -smp enable
%%% ---------------------------------------------------------------------------
%%% @doc
%%% The purpose of this command is to prepare a mix project so that mix
%%% understands that the dependencies are all already installed. If you want a
%%% hygienic build on nix then you must run this command before running mix. I
%%% suggest that you add a `Makefile` to your project and have the bootstrap
%%% command be a dependency of the build commands. See the nix documentation for
%%% more information.
%%%
%%% This command designed to have as few dependencies as possible so that it can
%%% be a dependency of root level packages like mix. To that end it does many
%%% things in a fairly simplistic way. That is by design.
%%%
%%% ### Assumptions
%%%
%%% This command makes the following assumptions:
%%%
%%% * It is run in a nix-shell or nix-build environment
%%% * that all dependencies have been added to the ERL_LIBS
%%%   Environment Variable

-record(data, {version
              , erl_libs
              , root
              , name}).

main(Args) ->
    {ok, RequiredData} = gather_required_data_from_the_environment(Args),
    ok = bootstrap_libs(RequiredData).

%% @doc
%% This takes an app name in the standard OTP <name>-<version> format
%% and returns just the app name. Why? Because rebar doesn't
%% respect OTP conventions in some cases.
-spec fixup_app_name(file:name()) -> string().
fixup_app_name(Path) ->
    BaseName = filename:basename(Path),
    case string:tokens(BaseName, "-") of
        [Name, _Version] -> Name;
        Name -> Name
    end.


-spec gather_required_data_from_the_environment([string()]) -> {ok, #data{}}.
gather_required_data_from_the_environment(_) ->
    {ok, #data{ version = guard_env("version")
              , erl_libs = os:getenv("ERL_LIBS", [])
              , root = code:root_dir()
              , name = guard_env("name")}}.

-spec guard_env(string()) -> string().
guard_env(Name) ->
    case os:getenv(Name) of
        false ->
            stderr("Expected Environment variable ~s! Are you sure you are "
                   "running in a Nix environment? Either a nix-build, "
                   "nix-shell, etc?~n", [Name]),
            erlang:halt(1);
        Variable ->
            Variable
    end.

-spec bootstrap_libs(#data{}) -> ok.
bootstrap_libs(#data{erl_libs = ErlLibs}) ->
    io:format("Bootstrapping dependent libraries~n"),
    Target = "_build/prod/lib/",
    Paths = string:tokens(ErlLibs, ":"),
    CopiableFiles =
        lists:foldl(fun(Path, Acc) ->
                            gather_directory_contents(Path) ++ Acc
                    end, [], Paths),
    lists:foreach(fun (Path) ->
                          ok = link_app(Path, Target)
                  end, CopiableFiles).

-spec gather_directory_contents(string()) -> [{string(), string()}].
gather_directory_contents(Path) ->
    {ok, Names} = file:list_dir(Path),
    lists:map(fun(AppName) ->
                 {filename:join(Path, AppName), fixup_app_name(AppName)}
              end, Names).

%% @doc
%% Makes a symlink from the directory pointed at by Path to a
%% directory of the same name in Target. So if we had a Path of
%% {`foo/bar/baz/bash`, `baz`} and a Target of `faz/foo/foos`, the symlink
%% would be `faz/foo/foos/baz`.
-spec link_app({string(), string()}, string()) -> ok.
link_app({Path, TargetFile}, TargetDir) ->
    Target = filename:join(TargetDir, TargetFile),
    ok = make_symlink(Path, Target).

-spec make_symlink(string(), string()) -> ok.
make_symlink(Path, TargetFile) ->
    file:delete(TargetFile),
    ok = filelib:ensure_dir(TargetFile),
    io:format("Making symlink from ~s to ~s~n", [Path, TargetFile]),
    ok = file:make_symlink(Path, TargetFile).

%% @doc
%% Write the result of the format string out to stderr.
-spec stderr(string(), [term()]) -> ok.
stderr(FormatStr, Args) ->
    io:put_chars(standard_error, io_lib:format(FormatStr, Args)).
