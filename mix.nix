{
  bunt = {
    buildTool = "mix";
    fetchHex = {
      sha256 = "951c6e801e8b1d2cbe58ebbd3e616a869061ddadcc4863d0a2182541acae9a38";
      url = "https://repo.hex.pm/tarballs/bunt-0.2.0.tar";
    };
    version = "0.2.0";
  };
  credo = {
    buildTool = "mix";
    deps = [
      "bunt"
      "jason"
    ];
    fetchHex = {
      sha256 = "5278e8953f379b41ebe27c75c96d2e154ebc3f75dfe057c8b68c39133c25bb9f";
      url = "https://repo.hex.pm/tarballs/credo-1.0.3.tar";
    };
    version = "1.0.3";
  };
  dialyxir = {
    buildTool = "mix";
    fetchHex = {
      sha256 = "b331b091720fd93e878137add264bac4f644e1ddae07a70bf7062c7862c4b952";
      url = "https://repo.hex.pm/tarballs/dialyxir-0.5.1.tar";
    };
    version = "0.5.1";
  };
  file_system = {
    buildTool = "mix";
    fetchHex = {
      sha256 = "fd4dc3af89b9ab1dc8ccbcc214a0e60c41f34be251d9307920748a14bf41f1d3";
      url = "https://repo.hex.pm/tarballs/file_system-0.2.6.tar";
    };
    version = "0.2.6";
  };
  hex_core = {
    buildTool = "rebar3";
    fetchHex = {
      sha256 = "9e52ee57c001022fa36dfa3b835c58383c1b09b162fd993e15bdc98904f29b0b";
      url = "https://repo.hex.pm/tarballs/hex_core-0.5.0.tar";
    };
    version = "0.5.0";
  };
  jason = {
    buildTool = "mix";
    fetchHex = {
      sha256 = "b03dedea67a99223a2eaf9f1264ce37154564de899fd3d8b9a21b1a6fd64afe7";
      url = "https://repo.hex.pm/tarballs/jason-1.1.2.tar";
    };
    version = "1.1.2";
  };
  jsone = {
    buildTool = "rebar3";
    fetchHex = {
      sha256 = "a970c23d9700ae7842b526c57677e6e3f10894b429524696ead547e9302391c0";
      url = "https://repo.hex.pm/tarballs/jsone-1.4.7.tar";
    };
    version = "1.4.7";
  };
  mix_test_watch = {
    buildTool = "mix";
    deps = [
      "file_system"
    ];
    fetchHex = {
      sha256 = "c72132a6071261893518fa08e121e911c9358713f62794a90c95db59042af375";
      url = "https://repo.hex.pm/tarballs/mix_test_watch-0.9.0.tar";
    };
    version = "0.9.0";
  };
  syringe = {
    buildTool = "mix";
    fetchHex = {
      sha256 = "5bb4ec4ec8d023c5d09c6300750ceca576736c42650d4bdd9e0a530fe93bdaf3";
      url = "https://repo.hex.pm/tarballs/syringe-1.1.5.tar";
    };
    version = "1.1.5";
  };
}

