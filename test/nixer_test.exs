defmodule NixerTest do
  use ExUnit.Case
  doctest Nixer

  @example [
    %{
      file_system: %{
        builders: [:mix],
        sha256: "19kgf0sks0b62yn95caph0x6xf03k87n1cck6wd113n50imxll0d",
        url: "https://repo.hex.pm/tarballs/file_system-0.2.6.tar"
      }
    },
    %{
      mix_test_watch: %{
        builders: [:mix],
        sha256: "12pcxjz1hh627v8z4yxjjprsixzsiyn9jbq0b012dpvfgx5fqzc1",
        url: "https://repo.hex.pm/tarballs/mix_test_watch-0.9.0.tar"
      }
    }
  ]

  describe "to_nix" do
    test "convert a mix.lock to Nix" do
      assert Nixer.to_nix(@example) == """
             [
               {
                 file_system = {
                   builders = [
                     "mix"
                   ];
                   sha256 = "19kgf0sks0b62yn95caph0x6xf03k87n1cck6wd113n50imxll0d";
                   url = "https://repo.hex.pm/tarballs/file_system-0.2.6.tar";
                 };
               }
               {
                 mix_test_watch = {
                   builders = [
                     "mix"
                   ];
                   sha256 = "12pcxjz1hh627v8z4yxjjprsixzsiyn9jbq0b012dpvfgx5fqzc1";
                   url = "https://repo.hex.pm/tarballs/mix_test_watch-0.9.0.tar";
                 };
               }
             ]
             """
    end

    test "binary" do
      assert Nixer.to_nix("foo") == "\"foo\""
    end

    test "nil" do
      assert Nixer.to_nix(nil) == "null"
    end

    test "int" do
      assert Nixer.to_nix(1) == "1"
    end

    test "float" do
      assert Nixer.to_nix(1.2) == "1.2"
    end

    test "true" do
      assert Nixer.to_nix(true) == "true"
    end

    test "false" do
      assert Nixer.to_nix(false) == "false"
    end

    test "list" do
      assert Nixer.to_nix([1, "2", [nil, nil]]) ==
               """
               [
                 1
                 "2"
                 [
                   null
                   null
                 ]
               ]
               """
    end

    test "map" do
      assert Nixer.to_nix(%{a: 2}) ==
               """
               {
                 a = 2;
               }
               """
    end

    test "map nested" do
      assert Nixer.to_nix(%{a: 1, b: %{c: 2}}) ==
               """
               {
                 a = 1;
                 b = {
                   c = 2;
                 };
               }
               """
    end

    test "tuple" do
      assert Nixer.to_nix({"a", "b", ["c"]}) == """
             [
               "a"
               "b"
               [
                 "c"
               ]
             ]
             """
    end
  end
end
