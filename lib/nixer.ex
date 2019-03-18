defmodule Nixer do
  @moduledoc """
    Converts many Elixir types into Nix syntax
  """

  @plain_key ~r/^[a-zA-Z_-]+[a-zA-Z0-9_-]*$/

  def to_nix(value, level \\ 0)

  def to_nix(value, _) when is_nil(value) do
    "null"
  end

  def to_nix(value, _) when is_number(value) do
    "#{value}"
  end

  def to_nix(value, _) when is_boolean(value) do
    "#{value}"
  end

  def to_nix(value, _) when is_binary(value) do
    "\"#{value}\""
  end

  def to_nix(value, _) when is_atom(value) do
    "\"#{value}\""
  end

  def to_nix(value, level) when is_tuple(value) do
    value |> Tuple.to_list() |> to_nix(level)
  end

  def to_nix(value, level) when is_list(value) do
    "[\n" <>
      Enum.map_join(value, "", fn element ->
        indent(level + 1) <> to_nix(element, level + 1) <> "\n"
      end) <> outdent(level) <> "]" <> eof(level)
  end

  def to_nix(value, level) when is_map(value) do
    "{\n" <>
      Enum.map_join(value, "", fn {key, value} ->
        indent(level + 1) <> to_nix_key(key) <> " = " <> to_nix(value, level + 1) <> ";\n"
      end) <> outdent(level) <> "}" <> eof(level)
  end

  def plain_key?(value) when is_atom(value) do
    Regex.match?(@plain_key, Atom.to_string(value))
  end

  def plain_key?(value) when is_binary(value) do
    Regex.match?(@plain_key, value)
  end

  def plain_key?(_), do: false

  def to_nix_key(value) do
    if plain_key?(value), do: "#{value}", else: "\"#{value}\""
  end

  def indent(level) do
    String.duplicate("  ", level)
  end

  def outdent(level) do
    String.duplicate("  ", level)
  end

  def eof(0), do: "\n"
  def eof(_), do: ""
end
