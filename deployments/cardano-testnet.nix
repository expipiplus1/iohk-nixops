with (import ./../lib.nix);

let
  cconf = import ./../config.nix;

  nodeConfig = testIndex: {pkgs, ...}: {
    imports = [
      ./../modules/common.nix
    ];

    services.cardano-node = {
      enable = true;
      testIndex = testIndex;
      port = cconf.nodePort;
      inherit (cconf) enableP2P genesisN slotDuration networkDiameter mpcRelayInterval totalMoneyAmount bitcoinOverFlat productionMode systemStart richPoorDistr;
    };
  };
in {
  network.description = "Cardano SL";

  report-server = import ./../modules/report-server.nix;
  sl-explorer = import ./../modules/cardano-explorer.nix;
} // (genNodes (range 0 13) nodeConfig)
