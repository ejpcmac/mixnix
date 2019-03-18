defmodule Mixnix.CLI do
  @moduledoc """
    A simple command line interface for mixnix
  """

  def main(args) do
    write_lock(args)
  end

  def write_lock([]) do
    write_lock(["mix.lock"])
  end

  def write_lock([mix_lock]) do
    mix_lock
    |> Mixnix.read_mix_lock()
    |> Mixnix.convert_mix_lock()
    |> Nixer.to_nix()
    |> IO.puts()
  end
end
