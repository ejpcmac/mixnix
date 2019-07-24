defmodule Mixnix do
  @moduledoc """
    A converter for mix.lock files for use in nix derivations.
    It requires network access for fetching the dependencies and calculating their Hash.
    Since the hash provided in the mix.lock is not compatible with the normal fetchers.
  """

  use Injector

  inject(System, as: SystemImpl)

  def read_mix_lock(path) do
    opts = [file: path, warn_on_unnecessary_quotes: false]

    with {:ok, contents} <- File.read(path),
         {:ok, quoted} <- Code.string_to_quoted(contents, opts),
         {%{} = lock, _binding} <- Code.eval_quoted(quoted, opts) do
      lock
    else
      _ -> %{}
    end
  end

  def to_json(lock) do
    convert_mix_lock(lock)
  end

  def convert_mix_lock(lock) do
    lock |> Enum.map(fn entry -> convert(lock, entry) end) |> Enum.reduce(%{}, &Map.merge/2)
  end

  def convert_hex_base(name, version, hash, [], repo) do
    %{
      version: version,
      fetchHex: %{
        url: repo_to_url(repo, name, version),
        sha256: hash
      },
      buildTool: "mix"
    }
  end

  def convert_hex_base(name, version, hash, builders, repo) do
    %{
      version: version,
      fetchHex: %{
        url: repo_to_url(repo, name, version),
        sha256: hash
      },
      buildTool: choose_builder(builders)
    }
  end

  def add_deps(base, name, lock, []) do
    base
  end

  def add_deps(base, name, lock, deps) do
    all_dep_names = Enum.map(lock, fn {name, _} -> name end)

    required_deps =
      Enum.map(
        deps,
        fn {name, _, [hex: name, repo: _, optional: optional]} ->
          if Enum.member?(all_dep_names, name) do
            name
          end
        end
      )

    final_deps = required_deps |> Enum.filter(fn name -> !is_nil(name) end)

    if length(final_deps) > 0 do
      %{name => Map.put(base, :deps, final_deps)}
    else
      %{name => base}
    end
  end

  def convert(_, {name, {:hex, name, version, hash, builders, [], repo}}) do
    %{name => convert_hex_base(name, version, hash, builders, repo)}
  end

  def convert(lock, {name, {:hex, name, version, hash, builders, deps, repo}}) do
    name |> convert_hex_base(version, hash, builders, repo) |> add_deps(name, lock, deps)
  end

  # old version of hex.lock
  def convert(_, {name, {:hex, name, version, hash, builders, []}}) do
    %{name => convert_hex_base(name, version, hash, builders, "hexpm")}
  end

  # old version of hex.lock
  def convert(lock, {name, {:hex, name, version, hash, builders, deps}}) do
    name |> convert_hex_base(version, hash, builders, "hexpm") |> add_deps(name, lock, deps)
  end

  def convert(_, {name, {:git, repo, ref, _}}) do
    %{
      name => %{
        version: ref,
        fetchGit: %{
          url: repo,
          rev: ref
        },
        buildTool: "mix"
      }
    }
  end

  def repo_to_url("hexpm", name, version) do
    "https://repo.hex.pm/tarballs/#{name}-#{version}.tar"
  end

  def choose_builder([]) do
    :mix
  end

  def choose_builder(builders) do
    Enum.find(builders, fn builder -> builder == :mix end) || hd(builders)
  end
end
