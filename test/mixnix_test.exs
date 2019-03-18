defmodule MixnixTest do
  use ExUnit.Case, async: true
  import Mocker

  doctest Mixnix

  test "reading mix.lock" do
    assert Mixnix.read_mix_lock("test/fixtures/minimum.lock") ==
             %{
               cowlib:
                 {:hex, :cowlib, "2.7.0",
                  "3ef16e77562f9855a2605900cedb15c1462d76fb1be6a32fc3ae91973ee543d2", [:rebar3],
                  [], "hexpm"},
               credo:
                 {:hex, :credo, "0.9.3",
                  "76fa3e9e497ab282e0cf64b98a624aa11da702854c52c82db1bf24e54ab7c97a", [:mix],
                  [
                    {:bunt, "~> 0.2.0", [hex: :bunt, repo: "hexpm", optional: false]},
                    {:poison, ">= 0.0.0", [hex: :poison, repo: "hexpm", optional: false]}
                  ], "hexpm"},
               crypt:
                 {:git, "https://github.com/msantos/crypt",
                  "1f2b58927ab57e72910191a7ebaeff984382a1d3",
                  [ref: "1f2b58927ab57e72910191a7ebaeff984382a1d3"]},
               bunt:
                 {:hex, :bunt, "0.2.0",
                  "951c6e801e8b1d2cbe58ebbd3e616a869061ddadcc4863d0a2182541acae9a38", [:mix], [],
                  "hexpm"},
               poison:
                 {:hex, :poison, "3.1.0",
                  "d9eb636610e096f86f25d9a46f35a9facac35609a7591b3be3326e99a0484665", [:mix], [],
                  "hexpm"},
               jason:
                 {:hex, :jason, "1.1.2",
                  "b03dedea67a99223a2eaf9f1264ce37154564de899fd3d8b9a21b1a6fd64afe7", [:mix],
                  [{:decimal, "~> 1.0", [hex: :decimal, repo: "hexpm", optional: true]}], "hexpm"}
             }
  end

  test "converting mix.lock to nix" do
    mock(System)

    intercept(
      System,
      :cmd,
      ["nix-prefetch-url", any()],
      with: fn "nix-prefetch-url", _, _ -> {"fetchTarballHash\n", 0} end
    )

    intercept(
      System,
      :cmd,
      ["nix-prefetch-git", any()],
      with: fn "nix-prefetch-git", _, _ ->
        {"""
         {
           "date": "2016-12-15T10:07:41-05:00",
           "fetchSubmodules": false,
           "rev": "1f2b58927ab57e72910191a7ebaeff984382a1d3",
           "sha256": "0y7jcgd9v5pl50yg6wxvws2dzmja1dnba59ik87srx13zg1plqnv",
           "url": "https://github.com/msantos/crypt"
         }
         """, 0}
      end
    )

    lock = Mixnix.read_mix_lock("test/fixtures/minimum.lock")
    lock_nix = Mixnix.convert_mix_lock(lock)

    assert Nixer.to_nix(lock_nix) == File.read!("test/fixtures/minimum.nix")
  end
end
