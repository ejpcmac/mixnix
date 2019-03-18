use Mix.Config

config :mix_test_watch,
  tasks: [
    "test",
    "credo"
  ],
  extra_extensions: [".nix", ".lock"]
