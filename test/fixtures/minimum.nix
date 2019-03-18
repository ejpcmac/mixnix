{
  bunt = {
    builder = "mix";
    fetchHex = {
      sha256 = "951c6e801e8b1d2cbe58ebbd3e616a869061ddadcc4863d0a2182541acae9a38";
      url = "https://repo.hex.pm/tarballs/bunt-0.2.0.tar";
    };
    version = "0.2.0";
  };
  cowlib = {
    builder = "rebar3";
    fetchHex = {
      sha256 = "3ef16e77562f9855a2605900cedb15c1462d76fb1be6a32fc3ae91973ee543d2";
      url = "https://repo.hex.pm/tarballs/cowlib-2.7.0.tar";
    };
    version = "2.7.0";
  };
  credo = {
    builder = "mix";
    deps = [
      "bunt"
      "poison"
    ];
    fetchHex = {
      sha256 = "76fa3e9e497ab282e0cf64b98a624aa11da702854c52c82db1bf24e54ab7c97a";
      url = "https://repo.hex.pm/tarballs/credo-0.9.3.tar";
    };
    version = "0.9.3";
  };
  crypt = {
    builder = "mix";
    fetchGit = {
      rev = "1f2b58927ab57e72910191a7ebaeff984382a1d3";
      url = "https://github.com/msantos/crypt";
    };
    version = "1f2b58927ab57e72910191a7ebaeff984382a1d3";
  };
  jason = {
    builder = "mix";
    fetchHex = {
      sha256 = "b03dedea67a99223a2eaf9f1264ce37154564de899fd3d8b9a21b1a6fd64afe7";
      url = "https://repo.hex.pm/tarballs/jason-1.1.2.tar";
    };
    version = "1.1.2";
  };
  poison = {
    builder = "mix";
    fetchHex = {
      sha256 = "d9eb636610e096f86f25d9a46f35a9facac35609a7591b3be3326e99a0484665";
      url = "https://repo.hex.pm/tarballs/poison-3.1.0.tar";
    };
    version = "3.1.0";
  };
}
